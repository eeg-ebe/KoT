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

#if js
import haxe.ds.StringMap;
#end
#if sys
import sys.io.File;
#end
import haxe.ds.Vector;

/**
 *
 *
 * @author Yann Spoeri
 */
class Kretha {

//    Matrix.hx                   OK
//    DistanceMatrix.hx           OK

//    Sequence.hx                 OK
//    FastaAlignmentReader.hx     OK
//    IAlignmentReader.hx         OK

//    Graph.hx                    OK
//    GraphNode.hx                OK

//    MedianJoining.hx            OK
//    Clade.hx
//    MidPointRooter.hx

    #if js
    static var workerScope:js.html.DedicatedWorkerGlobalScope;
    public static function onMessage(e:js.html.MessageEvent):Void {
        var result:StringMap<String> = new StringMap<String>();
        try {
            var fileContent:String = cast(e.data.txt, String);
            var decisionRatio:Float = cast(e.data.decisionRatio, Float);
            var globalDeletion:Bool = cast(e.data.globalDeletion, Bool);
            var transivity:Bool = cast(e.data.transivity, Bool);
            var g:Graph<Sequence,Float> = null;
            if (fileContent.charAt(0) == ">" || fileContent.charAt(0) == ";") {
                var reader:FastaAlignmentReader = new FastaAlignmentReader();
                var seqs:Vector<Sequence> = reader.readSequences(fileContent, globalDeletion);
                g = NeighborJoining.run(seqs);
            } else {
                var reader:DistanceMatrixReader = new DistanceMatrixReader();
                var d:DistanceMatrix<Sequence> = reader.readMatrix(fileContent);
                g = NeighborJoining.runOnMatrix(d);
                FourTimesRule.distanceMatrix = d;
            }
            var c:Clade = MidPointRooter.root(g);
            var s:List<List<Sequence>> = FourTimesRule.doRule(c, decisionRatio, transivity);
            var resL:String = formatSpeciesList(s);
            CladeColorer.colorClades(c, s);
            var svg:String = c.getSVG();
            result.set("svg", svg);
            result.set("putativeSpecies", resL);
        } catch(e:Dynamic) {
            trace(e);
            result.set("svg", "The following error occurred: " + e);
            result.set("putativeSpecies", "");
        }
        workerScope.postMessage(result);
    }
    #end

    public static function formatSpeciesList(s:List<List<Sequence>>):String {
        var result:List<String> = new List<String>();
        var i:Int = 1;
        for (subList in s) {
            for (e in subList) {
                for (name in e.getNames()) {
                    result.add(name + "\t" + i);
                }
            }
            ++i;
        }
        return result.join("\n");
    }

    public static function main() {
        #if sys
        var globalDeletion:Bool = true;
        var decisionRatio:Float = 4.0;

        var path:String = Sys.args()[0];
        var fileContent:String = File.getContent(path);

        var g:Graph<Sequence,Float> = null;
        if (fileContent.charAt(0) == ">" || fileContent.charAt(0) == ";") {
            var reader:FastaAlignmentReader = new FastaAlignmentReader();
            var seqs:Vector<Sequence> = reader.readSequences(fileContent, globalDeletion);
            g = NeighborJoining.run(seqs);
        } else {
            var reader:DistanceMatrixReader = new DistanceMatrixReader();
            var d:DistanceMatrix<Sequence> = reader.readMatrix(fileContent);
            g = NeighborJoining.runOnMatrix(d);
            FourTimesRule.distanceMatrix = d;
        }
        var c:Clade = MidPointRooter.root(g);
        var s:List<List<Sequence>> = FourTimesRule.doRule(c, decisionRatio, true);
        Sys.stdout().writeString("=== List of putative species ===\n");
        var id:Int = 0;
        for (lst in s) {
            id++;
            for (ind in lst) {
                Sys.stdout().writeString(ind + "\t" + id + "\n");
            }
        }
        #elseif js
        workerScope = untyped self;
        workerScope.onmessage = onMessage;
        #end
    }

/*    public static function main() {
//        var c:Clade = new Clade();
//        var c1:Clade = new Clade();
//        c.addChild(c1);
//        trace(c);
    }*/
}
