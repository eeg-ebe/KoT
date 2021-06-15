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
 * Representation of a matrix.
 * 
 * @author Yann Spoeri
 */
class Matrix {

    /**
     * The width of the matrix.
     */
    private var mWidth:Int;

    /**
     * The height of the matrix.
     */
    private var mHeight:Int;

    /**
     * A vector to store the different values of the matrix.
     */
    private var mValues:Vector<Float>;

    /**
     * Create a new matrix.
     */
    public function new(w:Int, h:Int) {
        if (w < 1) {
            throw "Width must be bigger then 0!";
        }
        if (h < 1) {
            throw "Height must be bigger then 0!";
        }
        mWidth = w;
        mHeight = h;
        mValues = new Vector<Float>(w * h);
    }

    /**
     * Get the width of the matrix.
     */
    public inline function getWidth():Int {
        return mWidth;
    }

    /**
     * Get the height of the matrix.
     */
    public inline function getHeight():Int {
        return mHeight;
    }

    /**
     * Get a value saved in the matrix.
     */
    public inline function getValue(x:Int, y:Int):Float {
        if (0 > x || x >= mWidth || 0 > y || y >= mHeight) {
            throw "x or y (" + x + "," + y + ") out of range!";
        }
        return mValues.get(x + y * mWidth);
    }

    /**
     * Set a matrix value.
     */
    public inline function setValue(x:Int, y:Int, val:Float):Void {
        if (0 > x || x >= mWidth || 0 > y || y >= mHeight) {
            throw "x or y (" + x + "," + y + ") out of range!";
        }
        mValues[x + y * mWidth] = val;
    }

    /**
     * Get a textual represenation of this matrix.
     */
    public function toString():String {
        var result:Array<String> = new Array<String>();
        result.push("Matrix(" + mWidth + "," + mHeight + ")\n");
        for (j in 0...mHeight) {
            for (i in 0...mWidth) {
                if (i != 0) {
                    result.push("\t");
                }
                result.push("" + getValue(i, j));
            }
            result.push("\n");
        }
        return result.join("");
    }

}
