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
 * A class representing a number.
 *
 * @author Yann Spoeri
 */
class Number {

    /**
     * The type of number this class is representing.
     *
     * 0 means not a number.
     * 1 means natural number.
     * 2 means rational number.
     */
    private var type:Int;

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
        if (this.m == 0) {
            type = 0; // TODO: actually not possible due to pareDown throwing exception
        } else if (this.m == 1) {
            type = 1;
        } else {
            type = 2;
        }
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
        if (type == 0) {
            return "NaN";
        } else if (type == 1) {
            return Std.string(n);
        } else {
            return Std.string(n) + "/" + Std.string(m);
        }
    }
    public inline function getDenominator():Int {
        return n;
    }
    public inline function getDivisor():Int {
        return m;
    }

    @:op(A * B)
    public function mult(o:Number):Number {
        var rn:BigInt = n * o.n;
        var rm:BigInt = m * o.m;
        var result = new Number(rn, rm);
        return result;
    }
    @:op(A * B)
    public function multBig(o:BigInt):Number {
        var rn:BigInt = n * o;
        var result = new Number(rn, m);
        return result;
    }
    @:op(A / B)
    public function div(o:Number):Number {
        var rn:BigInt = n * o.m;
        var rm:BigInt = m * o.n;
        var result = new Number(rn, rm);
        return result;
    }
    public function divBig(o:BigInt):Number {
        var rm:BigInt = m * o;
        var result = new Number(n, rm);
        return result;
    }

    @:op(A + B)
    public function add(o:Number):Number {
        var rn:BigInt = m * o.n + o.m * n;
        var rm:BigInt = m * o.m;
        var result = new Number(rn, rm);
        return result;
    }
    @:op(A + B)
    public function addBig(o:BigInt):Number {
        var rn:BigInt = m * o + n;
        var rm:BigInt = m;
        var result = new Number(rn, rm);
        return result;
    }

    @:op(A - B)
    public function sub(o:Number):Number {
        var rn:BigInt = n * o.m - o.n * m;
        var rm:BigInt = m * o.m;
        var result = new Number(rn, rm);
        return result;
    }
    @:op(A - B)
    public function subBig(o:BigInt):Number {
        var rn:BigInt = n - o * m;
        var rm:BigInt = m;
        var result = new Number(rn, rm);
        return result;
    }

    public inline function equals(o:Number):Bool {
        return n == o.n && m == o.m;
    }
    public inline function isBigger(o:Number):Bool {
        var t:BigInt = n * o.m;
        var o:BigInt = o.n * m;
        return t > o;
    }
    public inline function isSmaller(o:Number):Bool {
        var t:BigInt = n * o.m;
        var o:BigInt = o.n * m;
        return t < o;
    }
    public inline function isSmallerBig(o:BigInt):Bool {
        var t:BigInt = n;
        var o:BigInt = o * m;
        return t < o;
    }
    public inline function isBiggerEq(o:Number):Bool {
        var t:BigInt = n * o.m;
        var o:BigInt = o.n * m;
        return t >= o;
    }
    public inline function isSmallerEq(o:Number):Bool {
        var t:BigInt = n * o.m;
        var o:BigInt = o.n * m;
        return t <= o;
    }

    public static function fromFloat(f:Float):Number {
        var m:BigInt = BigInt.fromString("10000000000");
        var s:String = Std.string(f * 10E9);
        var s_:String = s.split(".")[0];
        var n:BigInt = BigInt.fromString(s_);
        return new Number(n, m);
    }
    public function toFloat():Float {
        var result = BigInt.divMod(n, m);
        var p:BigInt = result.quotient;
        var q:BigInt = result.remainder;
        return Std.parseFloat("" + p) + Std.parseFloat("" + q) / Std.parseFloat("" + m);
    }

    public static function main() {
        var z:Number = fromFloat(12.3141);
        trace(z.toString());
        trace(z.toFloat() + "");
        var q1:Number = new Number(3, 5);
        var q2:Number = new Number(10, 2);
        trace(q1.add(q2));
    }
}