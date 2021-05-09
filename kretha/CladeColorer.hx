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
 * Clade coloror
 *
 * @author Yann Spoeri
 */
class CladeColorer {

    private static var colors:Array<String> = [
        "#FF0000",
        "#00FF00",
        "#0000FF",
        "#CC0000",
        "#00CC00",
        "#0000CC",
        "#CC6600",
        "#99CC00",
        "#006699",
        "#CC9900",
        "#00CC99",
        "#CC00CC",
        "#CC6699",
        "#009933",
        "#0033CC",
        "#6600FF",
        "#3333FF",
    ];

    private static inline function getColor(i:Int):String {
        var ii:Int = i % colors.length;
        return colors[ii];
    }

    private static inline function colorClade(c:Clade, i:Int):Void {
        var color:String = getColor(i);
        c.colorfy(color);
    }

    private static function same(l1:List<Sequence>, l2:List<Sequence>):Bool {
        if (l1.length != l2.length) {
            return false;
        }
        for (x in l1) {
            var found:Bool = false;
            for (y in l2) {
                if (x == y) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                return false;
            }
        }
        return true;
    }

    private static function findClade(c:Clade, l:List<Sequence>):Clade {
        if (same(c.mConnectedInfo.get("seqNames"), l)) {
            return c;
        }
        for (child in c.getChilds()) {
            var ccc:Clade = findClade(child, l);
            if (ccc != null) {
                return ccc;
            }
        }
        return null;
    }

    public static function colorClades(c:Clade, l:List<List<Sequence>>):Void {
        var i:Int = 0;
        for (ll in l) {
trace ("=== " + ll);
            var cc:Clade = findClade(c, ll);
            if (cc != null) {
trace (cc);
                colorClade(cc, i++);
            }
        }
    }

}
