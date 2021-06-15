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
import haxe.ds.IntMap;
import haxe.ds.Vector;

/**
 * A Reader specialized in reading fasta alignments.
 * 
 * @author Yann Spoeri
 */
class FastaAlignmentReader implements IAlignmentReader {

    public function new() {}
    public function readSequences(fileContent:String, globalDeletion:Bool):Vector<Sequence> {
        var sequences:Array<Sequence> = new Array<Sequence>();
        var lines:Array<String> = fileContent.split("\n");
        var name:Null<String> = null, seq:Null<String> = null;
        var seqAlreadySeen:StringMap<Sequence> = new StringMap<Sequence>();
        var badPositions:IntMap<Bool> = new IntMap<Bool>();
        for (line in lines) {
            line = StringTools.trim(line);
            if (line == "" || line.charAt(0) == ";" || line.charAt(0) == "#") {
                continue;
            }
            if (line.charAt(0) == ">") {
                if (name != null) {
                    if (seqAlreadySeen.exists(seq)) {
                        var s:Sequence = seqAlreadySeen.get(seq);
                        s.getNames().add(name);
                    } else {
                        var l:List<String> = new List<String>();
                        l.add(name);
                        var s:Sequence = new Sequence(l, seq);
                        seqAlreadySeen.set(seq, s);
                        sequences.push(s);
                    }
                }
                name = StringTools.trim(line.substr(1));
                seq = "";
            } else {
                seq = seq.toUpperCase() + line;
            }
        }
        if (name != null) {
            if (seqAlreadySeen.exists(seq)) {
                var s:Sequence = seqAlreadySeen.get(seq);
                s.getNames().add(name);
            } else {
                var l:List<String> = new List<String>();
                l.add(name);
                var s:Sequence = new Sequence(l, seq);
                seqAlreadySeen.set(seq, s);
                sequences.push(s);
            }
        }
        if (globalDeletion) {
            // ok, we need to perform a global deletion
            // check which positions need to be deleted
            var posToDelete:IntMap<Bool> = new IntMap<Bool>();
            for (sequence in sequences) {
                sequence.getBadPositions(posToDelete);
            }
            // combine
            var count:Int = 0;
            var seqs:StringMap<List<String>> = new StringMap<List<String>>();
            for (sequence in sequences) {
                var s:String = sequence.removePositions(posToDelete);
                if (seqs.exists(s)) {
                    var names:List<String> = seqs.get(s);
                    for (name in sequence.getNames()) {
                        names.add(name);
                    }
                    seqs.set(s, names);
                } else {
                    seqs.set(s, sequence.getNames());
                    count++;
                }
            }
            // create vector
            var result:Vector<Sequence> = new Vector<Sequence>(count);
            var i:Int = 0;
            for (sequence in seqs.keys()) {
                var s:String = sequence;
                var names:List<String> = seqs.get(sequence);
                result[i++] = new Sequence(names, s);
            }
            return result;
        }
        var result:Vector<Sequence> = new Vector<Sequence>(sequences.length);
        var i:Int = 0;
        for (sequence in sequences) {
            result[i++] = sequence;
        }
        return result;
    }

}
