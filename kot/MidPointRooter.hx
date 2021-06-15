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

import haxe.ds.Vector;

/**
 * Midpoint rooting.
 *
 * @author Yann Spoeri
 */
class MidPointRooter {

    public static function getLongestPath(g:Graph<Sequence,Float>, current:Sequence, commingFrom:Sequence):{ path : List<Sequence>, l : Float } {
        var bestLength:Float = 0;
        var path:List<Sequence> = null;
        for (connection in g.getEdges(current)) {
            if (connection.v == commingFrom) {
                continue;
            }
            var alternative:{ path : List<Sequence>, l : Float } = getLongestPath(g, connection.v, current);
            var l:Float = alternative.l + connection.e;
            if (l > bestLength) {
                bestLength = l;
                path = alternative.path;
            }
        }
        if (path == null) {
            path = new List<Sequence>();
        }
        path.add(current);
        return { path : path, l : bestLength };
    }

    public static function findLongestDistance(g:Graph<Sequence,Float>):{ path : List<Sequence>, l : Float } {
        var result:{ path : List<Sequence>, l : Float } = null;
        for (seq in g.getLeafs()) {
            var alternativeResult:{ path : List<Sequence>, l : Float } = getLongestPath(g, seq, null);
            if (result == null || result.l < alternativeResult.l) {
                result = alternativeResult;
            }
        }
        return result;
    }

    public static function findMidPoint(g:Graph<Sequence,Float>):{ n1:Sequence, n2:Sequence, a:Float, b:Float } {
        var result:{ path : List<Sequence>, l : Float } = findLongestDistance(g);
        trace("Longest path: " + result.path + " with length " + result.l);
        var midLen:Float = result.l / 2;
        var sum:Float = 0, conLen:Float = 0;
        var oldS:Sequence = null, newS:Sequence = null;
        for (s in result.path) {
            oldS = newS;
            newS = s;
            if (oldS == null) {
                continue;
            }
            conLen = g.getConnection(newS, oldS);
            sum += conLen;
            if (sum > midLen) {
                break;
            }
        }
        return {
            n1 : oldS,
            n2 : newS,
            a : conLen - (sum - midLen),
            b : sum - midLen
        };
    }

    public static function root(g:Graph<Sequence,Float>):Clade {
        var midPoint:{ n1:Sequence, n2:Sequence, a:Float, b:Float } = findMidPoint(g);
        trace("midPoint: " + midPoint);
        var rootClade:Clade = new Clade();
        rootClade.addInfo("Root");
        genSubClade(g, midPoint.n1, midPoint.n2, rootClade, midPoint.a, 0);
        genSubClade(g, midPoint.n2, midPoint.n1, rootClade, midPoint.b, 0);
        return rootClade;
    }

    public static function genSubClade(g:Graph<Sequence,Float>, process:Sequence, commingFrom:Sequence, parentClade:Clade, dist:Float, lvl:Int):Void {
        var connections:List<{ v: Sequence, e : Float }> = g.getEdges(process);
        var clade:Clade = new Clade();
        var seq:String = process.getSequenceString();
        if (seq != null) {
            clade.mConnectedInfo.set("sequence", process);
        }
        clade.addInfo(process.getNodeName());
        clade.setParent(parentClade, dist);
        for (connection in g.getEdges(process)) {
            if (connection.v == commingFrom) {
                continue;
            }
            genSubClade(g, connection.v, process, clade, connection.e, lvl+1);
        }
    }

}
