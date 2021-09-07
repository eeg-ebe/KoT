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
 * A Sequence.
 *
 * @author Yann Spoeri
 */
class Sequence {

    /**
     * The (possible multiple) names of this sequence.
     */
    private var mNames:List<String>;

    /**
     * The sequence of this sequence.
     */
    private var mSeq:String;

    /**
     *
     */
    private static var nextHashCode:Int = 0;
    private var mHashCode:Int;

    /**
     * For outputting
     */
    public var mOutputted:Bool = false;

    /**
     * Create a new Sequence object.
     */
    public function new(names:List<String>, seq:String) {
        this.mNames = names;
        this.mSeq = (seq == null) ? seq : seq.toUpperCase();
        mHashCode = nextHashCode;
        nextHashCode++;
    }

    /**
     * Get the name of this sequence.
     */
    public inline function getNames():List<String> {
        return mNames;
    }

    /**
     * Get the sequence of this sequence.
     */
    public inline function getSequenceString():String {
        return mSeq;
    }

    /**
     * Get the length of this sequence.
     */
    public inline function getLength():Int {
        return (mSeq == null) ? 0 : mSeq.length;
    }

    public inline function isAmbChar(c:String) {
        return !(c == 'A' || c == 'T' || c == 'G' || c == 'C');
    }

    /**
     * Compare this sequence against a sequence of equal length.
     */
    public inline function getDifferenceScore(o:Sequence, flag:Bool):Float {
        if (o.getLength() != getLength()) {
            throw "Cannot compare sequences of different length!";
        }
        var score:Int = 0;
        var count:Int = 0;
        for (i in 0...getLength()) {
            var c1:String = mSeq.charAt(i);
            var c2:String = o.mSeq.charAt(i);
            if (isAmbChar(c1) || isAmbChar(c2)) continue;
            if (c1 != c2) {
                score++;
            }
            count++;
        }
        if (count == 0) {
            if (flag) return score;
            return 1.0;
        }
        return (flag) ? score : score / count;
    }

    public inline function getNodeName():String {
        var result = null;
        if (mNames == null || mNames.length == 0) {
            result = "noName";
        } else if (mNames.length == 1) {
            result = mNames.first();
        } else {
            result = mNames.join(",");
        }
        return result;
    }
    public function toString():String {
        return getNodeName();
    }

    public inline function hashCode():Int {
        return mHashCode;
    }

    public function getBadPositions(result:IntMap<Bool>):Void {
        for (i in 0...mSeq.length) {
            var c:String = mSeq.charAt(i);
            if (c != 'A' && c != 'T' && c != 'G' && c != 'C' && c != '-') {
                result.set(i, true);
            }
        }
    }
    public function removePositions(im:IntMap<Bool>):String {
        var newS:List<String> = new List<String>();
        for (i in 0...mSeq.length) {
            var c:String = mSeq.charAt(i);
            if (im.get(i)) {
                continue;
            }
            newS.add(c);
        }
        return newS.join("");
    }

}
