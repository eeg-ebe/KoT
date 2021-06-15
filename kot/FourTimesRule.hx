/**
 * Copyright (c) 2019 Université libre de Bruxelles, eeg-ebe Department, Yann Spöri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package kot;

import haxe.ds.IntMap;

/**
 * Implementation of the 4x rule.
 *
 * @author Yann Spoeri
 */
class FourTimesRule {

    public static var distanceMatrix:DistanceMatrix<Sequence> = null;

    public static inline function calcPairwiseDifference(a1:Sequence, a2:Sequence):Float {
        var result:Float = 0;
        if (distanceMatrix != null) {
            result = distanceMatrix.lookup(a1, a2);
        } else {
            var res:Float = a1.getDifferenceScore(a2, false);
            result = res; // / a1.getLength();
        }
        return result;
    }

    public static inline function calcPairwiseDistance(seqs:List<Sequence>):Float {
        var count:Int = 0, diff:Float = 0;

        var c:Int = 0;
        for (seq1 in seqs) {
            for (i in 0...seq1.getNames().length) {
                var d:Int = 0;
                for (seq2 in seqs) {
                    for (j in 0...seq2.getNames().length) {
                        if (c == d) {
                            d++;
                            continue;
                        }
                        count++;
                        diff += calcPairwiseDifference(seq1, seq2);
                        d++;
                    }
                }
                c++;
            }
        }
        if (count == 0) return 0;
        return diff / count;
    }

    public static inline function calcPairwiseDistanceOfSubClades(seqsA:List<Sequence>, seqsB:List<Sequence>):Float {
trace(seqsA + " " + seqsA);
        var comparisons:Float = 0, diff:Float = 0;
        for (seq1 in seqsA) {
            for (seq2 in seqsB) {
                for (i in 0...seq1.getNames().length) {
                    for (j in 0...seq2.getNames().length) {
                        comparisons++;
                        diff += calcPairwiseDifference(seq1, seq2);
                    }
                }
            }
        }
        var result:Float =0;
        if (diff != 0) { result = - (3.0 / 4) * Math.log (1 - 4 * diff / (3.0 * comparisons)); }
        return result; 
    }

    public static inline function calcTheta(seqs:List<Sequence>, c:Clade):Float {
        var n:Int = 0;
        for (seq in seqs) {
            n += seq.getNames().length;
        }
        var pairwiseDistance:Float = calcPairwiseDistance(seqs);
        var pi:Float = 0;
        if (n == 1) {
            // do as if this individual was sampled twice
            n = 2;
        }
        if (pairwiseDistance == 0) {
            var seqLen:Int = seqs.first().getLength();
            pairwiseDistance = 1 / seqLen;
            pi = 2 / (seqLen * n * (n - 1));
        } else {
            pi = pairwiseDistance;
        }
//c.addInfo("n " + n + " " + seqs + ", d " + floatToStringPrecision(pairwiseDistance, 3) + ", pi " + floatToStringPrecision(pi, 3));
        return pi / (1 - 4 * pi / 3);
    }

    public static function getBestSubClades(subCladeA:List<List<Sequence>>, subCladeB:List<List<Sequence>>, c:Clade):List<List<Sequence>> {
/*        var best:Float = Math.POSITIVE_INFINITY;
        var a:List<Sequence> = null, b:List<Sequence> = null;
        for (spSA in subCladeA) {
            for (spSB in subCladeB) {
                var current:Float = calcPairwiseDistanceOfSubClades(spSA, spSB);
//                c.addInfo(spSA + " " + spSB + " -> " + current);
                if (current < best) {
                    best = current;
                    a = spSA;
                    b = spSB;
                }
            }
        }*/
        var l:List<List<Sequence>> = new List<List<Sequence>>();
//        l.add(a);
//        l.add(b);
        l.add(subCladeA.first());
        l.add(subCladeB.first());
        return l;
    }

    public static function mergeSpecies(cladeA:List<List<Sequence>>, cladeB:List<List<Sequence>>, spA:List<Sequence>, spB:List<Sequence>, l:List<List<Sequence>>) {
        for (lA in cladeA) {
            if (lA == spA) {
                continue;
            }
            l.add(lA);
        }
        for (lB in cladeB) {
            if (lB == spB) {
                continue;
            }
            l.add(lB);
        }
        var u:List<Sequence> = new List<Sequence>();
        for (n1 in spA) {
            u.add(n1);
        }
        for (n2 in spB) {
            u.add(n2);
        }
        l.add(u);
    }

    public static function seqsInClade(c:Clade):List<Sequence> {
        var l:List<Sequence> = new List<Sequence>();
        var seq:Sequence = c.mConnectedInfo.get("sequence");
        if (seq != null) {
            l.add(seq);
        }
        for (subClade in c.getChilds()) {
            var subL = seqsInClade(subClade);
            for (s in subL) {
                l.add(s);
            }
        }
        c.mConnectedInfo.set("seqNames", l);
        return l;
    }

// tks to https://stackoverflow.com/questions/23689001/how-to-reliably-format-a-floating-point-number-to-a-specified-number-of-decimal
public static function floatToStringPrecision(n:Float, prec:Int){
  n = Math.round(n * Math.pow(10, prec));
  var str = ''+n;
  var len = str.length;
  if(len <= prec){
    while(len < prec){
      str = '0'+str;
      len++;
    }
    return '0.'+str;
  }
  else{
    return str.substr(0, str.length-prec) + '.'+str.substr(str.length-prec);
  }
}


    public static function speciesInClade(c:Clade, decisionRatio:Float, transitivity:Bool):List<List<Sequence>> {
        var l:List<List<Sequence>> = new List<List<Sequence>>();
        if (c.isTerminal()) {
            l.add(c.mConnectedInfo.get("seqNames"));
            return l;
        }

        var terminalSeqList:List<Sequence> = new List<Sequence>();
        var s:List<List<List<Sequence>>> = new List<List<List<Sequence>>>();
        for (child in c.getChilds()) {
            var sub:List<List<Sequence>> = speciesInClade(child, decisionRatio, transitivity);
            s.add(sub);
//            c.addInfo("" + sub);
            var childSeqs:List<Sequence> = cast child.mConnectedInfo.get("seqNames");
            for (seq in childSeqs) {
                terminalSeqList.add(seq);
            }
        }
        c.mConnectedInfo.set("seqNames", terminalSeqList);

        if (s.length != 2) throw "WTF?";
        var sA:List<List<Sequence>> = s.first();
        var sB:List<List<Sequence>> = s.last();
        var nSpecies:Int = sA.length + sB.length;
trace("=== " + sA + " " + sB + " ===");
        if (!transitivity) { //nSpecies == 2) {
            var bestClades:List<List<Sequence>> = getBestSubClades(sA, sB, c);
            var k:Float = calcPairwiseDistanceOfSubClades(bestClades.first(), bestClades.last());
            var theta1:Float = calcTheta(bestClades.first(), c);
            var theta2:Float = calcTheta(bestClades.last(), c);
            c.addInfo(floatToStringPrecision(theta1, 5) + "(" + bestClades.first().length + ") " + floatToStringPrecision(theta2, 5) + "(" + bestClades.last().length + ")");
            var theta:Float = (theta1 > theta2) ? theta1 : theta2;
            if (theta != -1) {
                var ratio:Float = k / theta;
                c.addInfo(floatToStringPrecision(k, 5) + "/" + floatToStringPrecision(theta, 5) + "=" + floatToStringPrecision(ratio, 5));
                if (ratio >= decisionRatio) {
//                    var colors = ["green", "blue", "red"];
//                    var pcolor:Int = 0;
//                    for (child in c.getChilds()) {
//                        child.colorfy(colors[pcolor]);
//                        pcolor = (pcolor + 1) % colors.length;
//                    }
                    for (n1 in sA) {
                        l.add(n1);
                    }
                    for (n2 in sB) {
                        l.add(n2);
                    }
                } else {
                    mergeSpecies(sA, sB, bestClades.first(), bestClades.last(), l);
                }
            } else {
                mergeSpecies(sA, sB, bestClades.first(), bestClades.last(), l);
            }
        } else if (transitivity) {
            // check whether there is a pair between sA and sB that "fits". If yes, set goOn to true
            var goOn:Bool = false;
            var bestClades:List<List<Sequence>> = getBestSubClades(sA, sB, c);
            var k:Float = calcPairwiseDistanceOfSubClades(bestClades.first(), bestClades.last());
            var theta1:Float = calcTheta(bestClades.first(), c);
            var theta2:Float = calcTheta(bestClades.last(), c);
            c.addInfo(floatToStringPrecision(theta1, 5) + "(" + bestClades.first().length + ") " + floatToStringPrecision(theta2, 5) + "(" + bestClades.last().length + ")");
            var theta:Float = (theta1 > theta2) ? theta1 : theta2;
            if (theta != -1) {
                var ratio:Float = k / theta;
                c.addInfo(floatToStringPrecision(k, 5) + "/" + floatToStringPrecision(theta, 5) + "=" + floatToStringPrecision(ratio, 5));
                if (ratio < decisionRatio) {
                    goOn = true;
                }
            }
            // ok, put everything into l
            for (n1 in sA) {
                l.add(n1);
            }
            for (n2 in sB) {
                l.add(n2);
            }
            // no check whether we need to combine
            while (goOn) {
                var toCombine:IntMap<List<Int>> = new IntMap<List<Int>>();
                for (i in 0...l.length) {
                    var lxxx:List<Int> = new List<Int>();
                    lxxx.add(i + 1);
                    toCombine.set(i + 1, lxxx);
                }
                goOn = false;
                var i:Int = 0;
                for (s1 in l) {
                    i++;
                    var j:Int = 0;
                    for (s2 in l) {
                        j++;
                        if (i >= j) {
                            continue;
                        }
                        var k:Float = calcPairwiseDistanceOfSubClades(s1, s2);
                        var theta1:Float = calcTheta(s1, c);
                        var theta2:Float = calcTheta(s2, c);
                        c.addInfo(s1 + " " + s2);
                        c.addInfo(floatToStringPrecision(theta1, 5) + "(" + s1.length + ") " + floatToStringPrecision(theta2, 5) + "(" + s2.length + ")");
                        var theta:Float = (theta1 > theta2) ? theta1 : theta2;
                        if (theta != -1) {
                            var ratio:Float = k / theta;
                            c.addInfo(floatToStringPrecision(k, 5) + "/" + floatToStringPrecision(theta, 5) + "=" + floatToStringPrecision(ratio, 5));
                            if (ratio < decisionRatio) {
                                // Same
                                goOn = true;
                                var combined:List<Int> = new List<Int>();
                                combined.add(i);
                                combined.add(j);
                                if (toCombine.exists(i)) {
                                    var xI:List<Int> = toCombine.get(i);
                                    for (s in xI) {
                                        combined.add(s);
                                    }
                                    toCombine.remove(i);
                                }
                                if (toCombine.exists(j)) {
                                    var xJ:List<Int> = toCombine.get(j);
                                    for (s in xJ) {
                                        combined.add(s);
                                    }
                                    toCombine.remove(j);
                                }
                                var minVal:Int = (i > j) ? j : i;
                                toCombine.set(minVal, combined);
                            }
                        }
                    }
                }
trace("toCombine: " + toCombine);
                // toCombine
                var newL:List<List<Sequence>> = new List<List<Sequence>>();
                for (xL in toCombine) {
                    var alreadyDone:IntMap<Bool> = new IntMap<Bool>();
                    var sL:List<Sequence> = new List<Sequence>();
                    if (xL.isEmpty()) { // security check
                        throw "sL is Empty " + toCombine;
                    }
                    for (x in xL) {
                        if (alreadyDone.exists(x)) {
                            continue;
                        }
                        var idx:Int = 0;
                        for (s1 in l) {
                            idx++;
                            if (idx == x) {
                                for (ele in s1) {
                                    sL.add(ele);
                                }
                                break;
                            }
                        }
                        if (sL.isEmpty()) {
                            throw "Index " + x + " not found!";
                        }
                        alreadyDone.set(x, true);
                    }
                    newL.add(sL);
                }
                l = newL;
            }
        } else {
            for (n1 in sA) {
                l.add(n1);
            }
            for (n2 in sB) {
                l.add(n2);
            }
        }
        c.addInfo("" + l);
trace("output: " + l + " " + l.length);
        return l;
    }

    private static function initColors(c:Clade, l:List<List<Sequence>>):Void {
        c.mConnectedInfo.set("psppl", l.first());
    }

    public static function doRule(c:Clade, decisionRatio:Float, transitivity:Bool):List<List<Sequence>> {
        seqsInClade(c);
        var result:List<List<Sequence>> = speciesInClade(c, decisionRatio, transitivity);
        initColors(c, result);
        return result;
    }

}
