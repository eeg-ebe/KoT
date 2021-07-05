/**
 * Copyright (c) 2019 Université libre de Bruxelles, eeg-ebe Department, Yann Spöri
 *
> * Licensed under the Apache License, Version 2.0 (the "License");
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
package kot.rosenberg;

/**
 * @author Yann Spoeri
 */
class Rosenberg {

    public static inline function s(l2:BigInt, l1:BigInt, j:BigInt):Q {
        var t1u:BigInt = Lib.comb(l1, l2) * Lib.comb(j, l2);
        var t1d:BigInt = Lib.comb(j + l1, j);
        var t2u:BigInt = l2 * (j + l1);
        var t2d:BigInt = l1 * j;
        var tX:Q = new Q(t1u, t1d);
        var tY:Q = new Q(t2u, t2d);
        return tX.mult(tY);
    }

    public static inline function calcTerm2(ma:BigInt, mb:BigInt, ta:BigInt, tb:BigInt, ra:BigInt, rb:BigInt, g_mata:Q, k_mamb:BigInt, g_mbtb:Q):Q {
        var summe:Q = new Q(0, 1);
        var qa:Int = 1;
        while (qa <= ma) {
            var s_qamara:Q = s(qa, ma, ra);
            var qb:Int = 1;
            while (qb <= mb) {
                 var s_qbmbrb:Q = s(qb, mb, rb);
                 var k_qaqb:BigInt = Lib.comb(qa + qb, qa) * (qa + qb - 1);
                 //           g_mata *    s_qamara *     g_mbtb *     s_qbmbrb *     k_qaqb /       k_mamb
                 var mult:Q = g_mata.mult(s_qamara).mult(g_mbtb).mult(s_qbmbrb).multBig(k_qaqb).divBig(k_mamb);
                 summe = summe.add(mult);
                 trace("Summe: " + summe + " " + g_mata + " " + s_qamara + " " + g_mbtb + " " + s_qbmbrb + " " + k_qaqb + " " + k_mamb);
                 qb++;
            }
            qa++;
        }
        return summe;        
    }

    public static inline function calcTerm(ma:BigInt, ta:BigInt, tb:BigInt, ra:BigInt, rb:BigInt, g_mata:Q):Q {
        var mb:BigInt = 1;
        var summe:Q = new Q(0, 1);
        var term:Float = 2.5; // just a random value > 10E-6
        while (term > 10E-6 || mb < 10) {
            var k_mamb:BigInt = Lib.comb(ma + mb, ma) * (ma + mb - 1);
            var g_mbtb:Q = Lib.gjt(mb, tb);
//ma:BigInt, mb:BigInt, ta:BigInt, tb:BigInt, ra:BigInt, rb:BigInt, g_mata:Q, k_mamb:BigInt, g_mbtb:Q
//            term = calcTerm2(ma, mb, ta, tb, ra, rb, g_mata, k_mamb, g_mbtb);
            term = calcTerm2(2, 2, 2, 2, 2, 2, new Q(1, 1), 2, new Q(1, 1));
            var termQ:Q = Lib.floatToQ(term);
            summe = summe.add(termQ);
            mb++;
        }
        return summe;
    }

/*

def calcTerm(ma, ta, tb, ra, rb, g_mata):
    mb = 1
    summe, term = 0.0, float("inf")
    while term > sigma or mb < 10:
        k_mamb = comb(ma + mb, ma) * (ma + mb - 1) #k(ma, mb)
        g_mbtb = gjt(mb, tb)
        term = calcTerm2(ma, mb, ta, tb, ra, rb, g_mata, k_mamb, g_mbtb)
        summe += term
        mb += 1
    return summe


/*
              //                               9          1       14.3 2.814     5         1        0              6.4       90         0.821183806711 => 9.53804758478e-221
    public static inline function calcTerm2(ma:BigInt, mb:BigInt, ta:Q, tb:Q, ra:BigInt, rb:BigInt, g_mata:BigInt, k_mamb:Q, g_mbtb:Q):Q {
    }
/*
    summe = 0.0
    for qa in xrange(1, ma + 1):
        s_qamara = s(qa, ma, ra)
        for qb in xrange(1, mb + 1):
            s_qbmbrb = s(qb, mb, rb)
            k_qaqb = comb(qa + qb, qa) * (qa + qb - 1) # k(qa, qb)
            summe += g_mata * s_qamara * g_mbtb * s_qbmbrb * k_qaqb / k_mamb
# 15 3 0.2 0.2 8 7 -0.0319569753257 13872 -15.5954784729 2.35744549991
#    print(ma, mb, ta, tb, ra, rb, g_mata, k_mamb, g_mbtb, summe)
    return summe
*/
    public static function main() {
//        trace(s(3, 6, 10).toString());
//        trace(s(4, 6, 10).toString());
//  1 1 12 14 3 2 0.99998 2 0.9999975 => 0.99997750005
        trace(calcTerm(1, 1, 12, 14, 3, new Q(2, 1)));
    }

}
