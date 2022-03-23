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

import haxe.ds.HashMap;
import haxe.ds.Vector;

/**
 * Implementation of the well-known NeighborJoining algorithm.
 *
 * @author Yann Spoeri
 */
class NeighborJoining {

    public static function run(seqs:Vector<Sequence>):Graph<Sequence,Float> {
        var endPoints:Vector<Sequence> = seqs.copy();
        var nrIndividuals:Int = seqs.length;

        var d:DistanceMatrix<Sequence> = new DistanceMatrix<Sequence>(endPoints);
        for (ind1 in endPoints) {
            for (ind2 in endPoints) {
                if (ind1 == ind2) {
                    break;
                }
                var diff:Float = ind1.getDifferenceScore(ind2, false);
                d.set(ind1, ind2, diff);
            }
        }
        return runOnMatrix(d);
    }

    public static function runOnMatrix(d:DistanceMatrix<Sequence>):Graph<Sequence,Float> {
        var endPoints:Vector<Sequence> = d.getNames(); //seqs.copy();
        var result:Graph<Sequence,Float> = new Graph<Sequence,Float>(endPoints);

        var innerNumber:Int = 0;
        while (endPoints.length > 2) {
            // calc r_i
            var r:HashMap<Sequence,Float> = new HashMap<Sequence,Float>();
            for (seq in endPoints) {
                var sum:Float = 0;
                for (otherSeq in endPoints) {
                    sum += d.lookup(seq, otherSeq);
                }
                r.set(seq, sum / (endPoints.length - 2));
            }
            // calc m-Matrix
            var m:DistanceMatrix<Sequence> = new DistanceMatrix<Sequence>(endPoints);
            for (seq1 in endPoints) {
                var r_i:Float = r.get(seq1);
                for (seq2 in endPoints) {
                    if (seq1 == seq2) {
                        break;
                    }
                    var r_j:Float = r.get(seq2);
                    var val:Float = d.lookup(seq1, seq2) - (r_i + r_j);
                    m.set(seq1, seq2, val);
                }
            }
            // get position of lowest m value
            var lowestSeq1:Sequence = endPoints[0], lowestSeq2:Sequence = endPoints[1];
            var lowestVal:Float = m.lookup(lowestSeq1, lowestSeq2);
            for (seq1 in endPoints) {
                for (seq2 in endPoints) {
                    if (seq1 == seq2) {
                        break;
                    }
                    var currentVal:Float = m.lookup(seq1, seq2);
                    if (currentVal < lowestVal) {
                        lowestSeq1 = seq1;
                        lowestSeq2 = seq2;
                        lowestVal = m.lookup(lowestSeq1, lowestSeq2);
                    }
                }
            }
            // create combined inner sequence
            var l:List<String> = new List<String>();
//            l.add("Inner" + (innerNumber++));
            var inner:Sequence = new Sequence(l, null);
            // calc diff of inner sequence
            var dist:Float = d.lookup(lowestSeq1, lowestSeq2);
            var v_iu = (dist + r.get(lowestSeq1) - r.get(lowestSeq2)) / 2;
            var v_ju = dist - v_iu;

            if (v_iu < 0 && v_ju < 0) {
                var x_tmp:Float = v_iu;
                v_iu = -v_ju;
                v_ju = -x_tmp;
            } else {
                if (v_iu < 0) {
                    v_ju = v_ju - v_iu;
                    v_iu = 0;
                }
                if (v_ju < 0) {
                    v_iu = v_iu - v_ju;
                    v_ju = 0;
                }
            }

            // combine in graph
            result.addNode(inner);
            result.addEdge(lowestSeq1, inner, v_iu);
            result.addEdge(lowestSeq2, inner, v_ju);
            // combine endpoints
            var endPoints_new:Vector<Sequence> = new Vector<Sequence>(endPoints.length - 1);
            var idx:Int = 0;
            for (seq in endPoints) {
                if (seq == lowestSeq1 || seq == lowestSeq2) {
                    continue;
                }
                endPoints_new[idx++] = seq;
            }
            endPoints_new[idx] = inner;
            // combine distance matrix
            var d_new:DistanceMatrix<Sequence> = new DistanceMatrix<Sequence>(endPoints_new);
            // fill d_new
            for (seq1 in endPoints_new) {
                for (seq2 in endPoints_new) {
                    if (seq1 == seq2) {
                        break;
                    }
                    if (seq1 == inner || seq2 == inner) {
                        var k = (seq1 == inner) ? seq2 : seq1;
                        var dist:Float = (d.lookup(lowestSeq1, k) + d.lookup(lowestSeq2, k) - d.lookup(lowestSeq1, lowestSeq2)) / 2;
                        d_new.set(seq1, seq2, dist);
                    } else {
                        var dist:Float = d.lookup(seq1, seq2);
                        d_new.set(seq1, seq2, dist);
                    }
                }
            }
            // use new d, endPoints
            endPoints = endPoints_new;
            d = d_new;
        }

        // combine remaining
        var dist:Float = d.lookup(endPoints[0], endPoints[1]);
        result.addEdge(endPoints[0], endPoints[1], dist);

        return result;
    }

}
