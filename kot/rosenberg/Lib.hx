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
package kot.rosenberg;

/**
 * Library for rosenberg.
 *
 * @author Yann Spoeri
 */
class Lib {

    public inline static function factorial(a:Number):Number {
        var result:Number = new Number(1, 1);
        var i:BigInt = 2;
        while (i <= a.getDenominator()) {
            result = result.multBig(i);
            i++;
        }
        return result;
    }

    public inline static function multUp(a:Number, k:Number):Number {
        var result:Number = new Number(1, 1);
        var i:BigInt = a.getDenominator();
        var till:Number = a.add(k);
        while (i < till.getDenominator()) {
            result = result.multBig(i);
            i++;
        }
        return result;
    }

    public inline static function sign(n:BigInt):BigInt {
        var result:BigInt = -1;
        if (n % 2 == 0) {
            result = 1;
        }
        return result;
    }
    public inline static function comb(n:Number, k:Number):Number {
        var prodUp:Number = new Number(1, 1);
        var prodDown:Number = new Number(1, 1);
        var i:BigInt = 1;
        while (i <= k.getDenominator()) {
            var x:Number = n.addBig(1).subBig(i);
            prodUp = prodUp.mult(x);
            prodDown = prodDown.multBig(i);
            i++;
        }
        return prodUp.div(prodDown);
    }

    public inline static function exp(e:Number):Number {
        var ef:Float = e.toFloat();
        var rf:Float = Math.exp(ef);
        return Number.fromFloat(rf);
    }
    public inline static function gjt_term(j:Number, t:Number, k:Number):Number {
        var k_:Number = k.subBig(1);
        var expTerm:Number = exp(k.multBig(-1).mult(k_).mult(t).divBig(2));
        var upperTerm:Number = k.multBig(2).subBig(1).multBig(sign((k.sub(j)).getDenominator())).mult(multUp(j, k_)); //new Number(1,1); // k.mult(2).sub(1).mult(multUp(j, k_)).mult(sign(k.sub(j)));
        var downTerm:Number = factorial(j).mult(factorial(k.sub(j)));
        var result:Number = expTerm.mult(upperTerm).div(downTerm);
        return result;
    }

    public inline static function gjt(j:Number, t:Number):Number {
        var k:Number = j;
        var term:Number = gjt_term(j, t, k);
        var sigma:Number = new Number(1, 1000000);
        var summe = term;
        while(term.isBigger(sigma) || k.isSmallerBig(100)) {
            k = k.addBig(1);
            term = gjt_term(j, t, k);
            summe = summe.add(term);
        }
        return summe;
    }

    public static function main() {
trace(factorial(new Number(10, 1)).toString());
/*        trace(multUp(0, 0));
        trace(multUp(1, 0));
        trace(multUp(2, 0));
        trace(multUp(0, 5));
        trace(multUp(1, 1));
        trace(multUp(2, 1));
        trace(multUp(3, 1));
        trace(multUp(1, 2));
        trace(multUp(1, 3));
        trace(multUp(1, 4));
        trace(multUp(2, 4));*/
    }

}
