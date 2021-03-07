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
package kretha;

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

    /**
     * Compare this sequence against a sequence of equal length.
     */
    public inline function getDifferenceScore(o:Sequence):Int {
        if (o.getLength() != getLength()) {
            throw "Cannot compare sequences of different length!";
        }
        var score:Int = 0;
        for (i in 0...getLength()) {
            var c1:String = mSeq.charAt(i);
            var c2:String = o.mSeq.charAt(i);
            if (c1 != c2) {
                score++;
            }
        }
        return score;
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

}
