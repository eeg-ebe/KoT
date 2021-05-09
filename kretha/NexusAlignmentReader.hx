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
 * A Reader specialized in reading fasta alignments.
 * 
 * @author Yann Spoeri
 */
class NexusAlignmentReader implements IAlignmentReader {

    public function new() {}
    public function readSequences(fileContent:String):Vector<Sequence> {
        var sequences:<String> = new StringMap<String>();
        var lines:Array<String> = fileContent.split("\n");
        var started:Bool = false;
        for (line in lines) {
            line = StringTools.trim(line);
            if (line == "" || line.charAt(0) == "[" || line.charAt(0) == "#") {
                continue;
            }
            if (line == "MATRIX") {
                started = true;
                continue;
            }
            if (!started) {
                continue;
            }
            
            // CF1     GAGCTGAAGAGCTCATATCTGGATTATGCGATGTCGGTCATTGTTG   [46]
            
        }

        var result:Vector<Sequence> = new Vector<Sequence>(entries);
        var i:Int = 0;
        for (key in sequences) {
            var seq:String = sequences.get(key);
            result[i++] = new Sequence(key, seq);
        }
        return result;
    }

}
