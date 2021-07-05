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

    public static inline function s(l2:Number, l1:Number, j:Number):Number {
        var t1u:Number = Lib.comb(l1, l2).mult(Lib.comb(j, l2));
        var t1d:Number = Lib.comb(j.add(l1), j);
        var t2u:Number = l2.mult(j.add(l1));
        var t2d:Number = l1.mult(j);
        var tX:Number = t1u.div(t1d);
        var tY:Number = t2u.div(t2d);
        return tX.mult(tY);
    }

    public static inline function calcTerm2(ma:Number, mb:Number, ta:Number, tb:Number, ra:Number, rb:Number, g_mata:Number, k_mamb:Number, g_mbtb:Number):Number {
        var summe:Number = new Number(0, 1);
        var qa:Number = new Number(1, 1);
        while (qa.isSmallerEq(ma)) {
            var s_qamara:Number = s(qa, ma, ra);
            var qb:Number = new Number(1, 1);
            while (qb.isSmallerEq(mb)) {
                 var s_qbmbrb:Number = s(qb, mb, rb);
                 var k_qaqb:Number = Lib.comb(qa.add(qb), qa).mult((qa.add(qb).subBig(1)));
                 //           g_mata *    s_qamara *     g_mbtb *     s_qbmbrb *     k_qaqb /       k_mamb
                 var mult:Number = g_mata.mult(s_qamara).mult(g_mbtb).mult(s_qbmbrb).mult(k_qaqb).div(k_mamb);
                 summe = summe.add(mult);
                 qb = qb.addBig(1);
            }
            qa = qa.addBig(1);
        }
        return summe;
    }

    public static inline function calcTerm(ma:Number, ta:Number, tb:Number, ra:Number, rb:Number, g_mata:Number):Number {
        var mb:Number = new Number(1, 1);
        var summe:Number = new Number(0, 1);
        var term:Number = new Number(5, 2); // just a random value bigger then 10E-6
        var sigma = new Number(1, 1000000);
        while (term.isBigger(sigma) || mb.isSmallerBig(10)) {
            var k_mamb:Number = Lib.comb(ma.add(mb), ma).mult((ma.add(mb).subBig(1)));
            var g_mbtb:Number = Lib.gjt(mb, tb);
            term = calcTerm2(ma, mb, ta, tb, ra, rb, g_mata, k_mamb, g_mbtb);
            summe = summe.add(term);
            mb = mb.addBig(1);
        }
        return summe;
    }

    public static inline function calc(ta:Number, tb:Number, ra:Number, rb:Number):Number {
        var ma:Number = new Number(1, 1);
        var summe:Number = new Number(0, 1);
        var term:Number = new Number(5, 2); // just a random value bigger then 10E-6
        var sigma = new Number(1, 1000000);
        while (term.isBigger(sigma) || ma.isSmallerBig(10)) {
            var g_mata = Lib.gjt(ma, ta);
            term = calcTerm(ma, ta, tb, ra, rb, g_mata);
            summe = summe.add(term);
            ma = ma.addBig(1);
        }
        return summe;
    }

    public static inline function calcSimple(ta:Int, tb:Int, ra:Float, rb:Float):Number {
        var taI:Number = new Number(ta, 1);
        var tbI:Number = new Number(tb, 1);
        var raI:Number = Number.fromFloat(ra);
        var rbI:Number = Number.fromFloat(rb);
        return calc(taI, tbI, raI, rbI);
    }

    public static function main() {
        trace(calcSimple(1, 2, 5.0, 1.1));
    }

}
