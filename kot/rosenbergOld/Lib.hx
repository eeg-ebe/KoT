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

    public inline static function factorial(a:BigInt):BigInt {
        var result:BigInt = 1;
        var i:BigInt = 2;
        while (i <= a) {
            result *= i;
            i++;
        }
        return result;
    }
    public inline static function multUp(a:BigInt, k:BigInt):BigInt {
        var result:BigInt = 1;
        var i:BigInt = a;
        var till:BigInt = a + k;
        while (i < till) {
            result *= i;
            i++;
        }
        return result;
    }
    public inline static function comb(n:BigInt, k:BigInt):BigInt {
        var prodUp:BigInt = 1;
        var prodDown:BigInt = 1;
        var i:BigInt = 1;
        while (i <= k) {
            prodUp = prodUp * (n + 1 - i);
            prodDown *= i;
            i++;
        }
        return prodUp / prodDown;
    }
    public inline static function sign(n:BigInt):BigInt {
        var result:BigInt = -1;
        if (n % 2 == 0) {
            result = 1;
        }
        return result;
    }

    public inline static function gjt_term(j, t, k):Q {
        var k_: = k - 1;
        
/*        k_ = k - 1
    expTerm = exp(-k * k_ * t / 2)
    upperTerm = ((k << 1) - 1) * sign(k - j) * multup(j, k_)
    downTerm = factorial(j) * factorial(k - j)
    result = expTerm * upperTerm / downTerm
    return result
*/
    }

    public inline static function gjt(j:BigInt, t:BigInt):Q {
        return new Q(1, 1); // TODO
    }

    public static inline function floatToQ(f:Float):Q {
        var up:BigInt = Std.int(f * 10E20);
        var down:BigInt = BigInt.fromString("10E20");
        return new Q(up, down);
    }


/*
def gjt(j, t):
    k = j
    term = gjt_term(j, t, k)
    summe = term
    while term > sigma or k < 100:
        k += 1
        term = gjt_term(j, t, k)
        summe += term
#    assert 0 <= summe <= 1, "%s %s %s" % (summe, j, t)
    return summe
*/
    public static function main() {
        trace(multUp(0, 0));
        trace(multUp(1, 0));
        trace(multUp(2, 0));
        trace(multUp(0, 5));
        trace(multUp(1, 1));
        trace(multUp(2, 1));
        trace(multUp(3, 1));
        trace(multUp(1, 2));
        trace(multUp(1, 3));
        trace(multUp(1, 4));
        trace(multUp(2, 4));
    }

}
