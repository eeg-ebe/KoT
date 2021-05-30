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
package kretha.rosenberg;

/**
 * Rational numbers.
 *
 * @author Yann Spoeri
 */
class Q {

    /**
     * Denominator and Divisor.
     */
    private var n:BigInt;
    private var m:BigInt;

    /**
     * Create a new number 
     */
    public function new(n:BigInt, m:BigInt) {
        this.n = n;
        this.m = m;
        pareDown();
    }

    private inline function pareDown():Void {
        var c:BigInt = gcd(n, m);
        n = n / c;
        m = m / c;
    }

    public static function gcd(a:BigInt, b:BigInt):BigInt {
        while (b != 0) {
            var c:BigInt = a;
            a = b;
            b = c % b;
        }
        return a;
    }

    public function toString():String {
        return Std.string(n) + "/" + Std.string(m);
    }
    public inline function getDenominator():Int {
        return n;
    }
    public inline function getDivisor():Int {
        return m;
    }

    @:op(A * B)
    public function mult(o:Q):Q {
        var rn:BigInt = n * o.n;
        var rm:BigInt = m * o.m;
        var result = new Q(rn, rm);
        return result;
    }
    @:op(A / B)
    public function div(o:Q):Q {
        var rn:BigInt = n * o.m;
        var rm:BigInt = m * o.n;
        var result = new Q(rn, rm);
        return result;
    }

    @:op(A + B)
    public function add(o:Q):Q {
        var rn:BigInt = m * o.n + o.m * n;
        var rm:BigInt = m * o.m;
        var result = new Q(rn, rm);
        return result;
    }

    @:op(A - B)
    public function sub(o:Q):Q {
        var rn:BigInt = n * o.m - o.n * m;
        var rm:BigInt = m * o.m;
        var result = new Q(rn, rm);
        return result;
    }


}
