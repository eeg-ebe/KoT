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
import haxe.ds.Vector;

/**
 * A Reader specialized in reading distance matrices.
 * 
 * @author Yann Spoeri
 */
class DistanceMatrixReader {

    public function new() {}
    public function readMatrix(fileContent:String):DistanceMatrix<Sequence> {
        var lines:Array<String> = fileContent.split("\n");
        var names:List<String> = new List<String>();
        for (line in lines) {
            line = StringTools.trim(line);
            if (line == "" || line.charAt(0) == "#") {
                continue;
            }
            var name:String = line.split("\t")[0];
            names.add(name);
        }

        var seqs:Vector<Sequence> = new Vector<Sequence>(names.length);
        var lookup:StringMap<Sequence> = new StringMap<Sequence>();
        var i:Int = 0;
        for (name in names) {
            var n:List<String> = new List<String>();
            n.add(name);
            var s:Sequence = new Sequence(n, null);
            seqs[i++] = s;
            lookup.set(name, s);
        }

        var d:DistanceMatrix<Sequence> = new DistanceMatrix<Sequence>(seqs);
        for (line in lines) {
            line = StringTools.trim(line);
            if (line == "" || line.charAt(0) == "#") {
                continue;
            }
            var name:String = line.split("\t")[0];
            var s1:Sequence = lookup.get(name);
            var pos:Int = -2;
            for (e in line.split("\t")) {
                pos++;
                if (pos == -1) {
                    continue;
                }
                var s2:Sequence = seqs[pos];
                var val:Float = Std.parseFloat(e);
                d.set(s1, s2, val);
            }
        }
        trace(d);
        return d;
    }

}
