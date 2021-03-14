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

import haxe.ds.StringMap;

/**
 * @author Yann Spoeri
 */
class Clade {

    /**
     * A reference to the parent clade.
     */
    private var mParent:Null<Clade>;

    /**
     * The distance of this clade to the parental clade.
     */
    private var mDist:Float;

    /**
     * A list of child clades.
     */
    private var mChilds:List<Clade>;

    /**
     * Information text connected to this clade.
     */
    private var mInfo:List<String>;

    /**
     * A color connected to this clade.
     */
    private var mColor:String = "black";

    /**
     * Additional info connected to this clade.
     */
    public var mConnectedInfo:StringMap<Dynamic>;

    /**
     * Create a new Clade.
     */
    public function new() {
        mDist = 0;
        mChilds = new List<Clade>();
        mInfo = new List<String>();
        mConnectedInfo = new StringMap<Dynamic>();
    }

    /**
     * Colorfy this clade (and all subclades).
     */
    public function colorfy(color:String) {
        this.mColor = color;
        for (child in mChilds) {
            child.colorfy(color);
        }
    }

    /**
     * Set the parental clade of this clade.
     */
    public inline function setParent(clade:Clade, dist:Float):Void {
        mParent = clade;
        mDist = dist;
        clade.mChilds.add(this);
    }

    /**
     * Get this nodes childs.
     */
    public inline function getChilds():List<Clade> {
        return mChilds;
    }

    /**
     * Add info.
     */
    public inline function addInfo(info:String):Void {
        mInfo.add(info);
    }

    /**
     * Check whether this is a terminal clade.
     */
    public inline function isTerminal():Bool {
        return mChilds.length == 0;
    }
    public inline function isRoot():Bool {
        return mParent == null;
    }

    // Draw settings
    private var mCladeDist:Int = 5;
    private var mTextDist:Int = 5;
    private var mTextSize:Int = 14;
    private var mLineWidth:Int = 1;
    private var mBorder:Int = 20;
    private var mLineTextDist:Int = 3;
    private var mDistStretch:Float = 20;

    /**
     * Calculate the needed draw size (in case this clade needs to get drawn).
     */
    private var mLastSizeCalc:Null<{ w:Float, h:Float }>;
    public inline function calcSize(useCache:Bool):{ w:Float, h:Float } {
        if (useCache && mLastSizeCalc != null) {
            return mLastSizeCalc;
        }
        var w:Float = 0, h:Float = 0;
        if (isTerminal()) {
            var maxInfoLen:Int = 0;
            for (info in mInfo) {
                maxInfoLen = (maxInfoLen > info.length) ? maxInfoLen : info.length;
            }
            w = mDist * mDistStretch + mLineTextDist + maxInfoLen * mTextSize;
            if (mInfo.length == 0) {
                h = mCladeDist << 1;
            } else {
                h = mInfo.length * mTextSize + (mInfo.length - 1) * mTextDist + (mCladeDist << 1);
            }
        } else {
            for (child in mChilds) {
                var childInfo:{ w:Float, h:Float } = child.calcSize(useCache);
                w = (w > childInfo.w) ? w : childInfo.w;
                h += childInfo.h;
            }
            w += mDist * mDistStretch;
            h += mInfo.length * mTextSize + (mInfo.length - 1) * mTextDist + (mCladeDist << 2);
        }
        mLastSizeCalc = { w : w, h : h };
        return mLastSizeCalc;
    }

    /**
     * Get svg representation.
     */
    public function getSVG():String {
        var result:Array<String> = new Array<String>();
        var dim:{ w:Float, h:Float } = calcSize(false);
        result.push("<svg id='resultTree' version='1.1' baseProfile='full' width='" + (2 * mBorder + 200 + dim.w) + "' height='" + (2 * mBorder + dim.h) + "' xmlns='http://www.w3.org/2000/svg'>");
        result.push("<g style='stroke:" + mColor + ";stroke-width:" + mLineWidth + "' font-family='Courier New' font-size='" + mTextSize + "'>");
        paint(result, mBorder, mBorder, mColor);
        result.push("</g>");
        result.push("</svg>");
        return result.join("");
    }
    private function paint(result:Array<String>, x:Float, y:Float, color:String):{ x:Float, y:Float, finalY:Float } {
        var resX:Float = 0, resY:Float = 0, finalY:Float = 0;
        result.push("<g id='" + mInfo.first() + "' style='stroke:" + mColor + "'>");
//        if (mColor != color) {
//        }
        if (isTerminal()) {
            var dim:{ w:Float, h:Float } = calcSize(true);
            finalY = dim.h + y;
            var mx:Float = x, my:Float = y + dim.h / 2;
            result.push("<line x1='" + mx + "' y1='" + my + "' x2='" + (mx + mDist * mDistStretch) + "' y2='" + my + "' title='" + mDist + "'/>");
            resX = mx;
            resY = my;
            mx = x + mDist * mDistStretch + mLineTextDist;
            my = y + mCladeDist + mTextSize / 2 + 2.5;
            for (info in mInfo) {
                result.push("<text x='" + mx + "' y='" + my + "'>" + info + "</text>");
                my += mTextSize + mTextDist;
            }
        } else {
            var dim:{ w:Float, h:Float } = calcSize(true);
            finalY = dim.h + y;
            var mx:Float = x, my:Float = y + dim.h / 2;
            result.push("<line x1='" + mx + "' y1='" + my + "' x2='" + (mx + mDist * mDistStretch) + "' y2='" + my + "' title='" + mDist + "'/>");
            resX = mx;
            resY = my;
            var h:Float = mCladeDist;
            var lowestY:Float = -1;
            var highestY:Float = -1;
            var txtY:Float = -1;
            for (child in mChilds) {
                var childDim:{ w:Float, h:Float } = child.calcSize(true);
                var midPoint:{ x:Float, y:Float, finalY:Float } = child.paint(result, x + mDist * mDistStretch, y + h, mColor);
                txtY = (txtY != -1) ? txtY : midPoint.finalY;
                lowestY = (lowestY != -1 && lowestY < midPoint.y) ? lowestY : midPoint.y;
                highestY = (highestY > midPoint.y) ? highestY : midPoint.y;
                h += childDim.h + mInfo.length * mTextSize + (mInfo.length - 1) * mTextDist;
            }
            mx = (mx + mDist * mDistStretch);
            result.push("<line x1='" + mx + "' y1='" + lowestY + "' x2='" + mx + "' y2='" + highestY + "' title='" + mDist + "'/>");
            mx = mx + mLineTextDist;
            my = txtY + mCladeDist + mTextSize / 2 + 2.5;
            for (info in mInfo) {
                result.push("<text x='" + mx + "' y='" + my + "'>" + info + "</text>");
                my += mTextSize + mTextDist;
            }
        }
        result.push("</g>");
//        if (mColor != color) {
//        }
        return { x : resX, y : resY, finalY : finalY };
    }

    /**
     * Get a textual representation of this clade. (This is for debugging.)
     */
    public function getTextRepresentation(result:Array<String>, indent:Int):Void {
        for (i in 0...indent) {
            result.push("  ");
        }
        result.push("Clade(" + mDist + ", " + mColor + ";" + mInfo + ")\n");
        for (clade in mChilds) {
            clade.getTextRepresentation(result, indent + 1);
        }
    }
    public function toString():String {
        var result:Array<String> = new Array<String>();
        getTextRepresentation(result, 0);
        return result.join("");
    }
    public function toString_():String {
        var result:Array<String> = new Array<String>();
        result.push("Clade(" + mInfo.join(",") + ")");
        result.push("  parent: " + ((mParent == null) ? "null" : mParent.mInfo.join(",")));
        result.push("  childs: " + mChilds.length); //((mChilds == null) ? "null" : mParent.mInfo.join(",")));
        return result.join("");
    }
}
