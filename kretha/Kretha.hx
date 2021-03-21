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
            var g:Graph<Sequence,Float> = null;
            if (fileContent.charAt(0) == ">" || fileContent.charAt(0) == ";") {
                var reader:FastaAlignmentReader = new FastaAlignmentReader();
                var seqs:Vector<Sequence> = reader.readSequences(fileContent);
                g = NeighborJoining.run(seqs);
            } else {
                var reader:DistanceMatrixReader = new DistanceMatrixReader();
                var d:DistanceMatrix<Sequence> = reader.readMatrix(fileContent);
                g = NeighborJoining.runOnMatrix(d);
                FourTimesRule.distanceMatrix = d;
            }
            var c:Clade = MidPointRooter.root(g);
            FourTimesRule.doRule(c, decisionRatio);
            var svg:String = c.getSVG();
            result.set("svg", svg);
        } catch(e:Dynamic) {
            trace(e);
            result.set("svg", "The following error occurred: " + e);
        }
        workerScope.postMessage(result);
    }
    #end

    public static function main() {
        #if sys
        var path:String = Sys.args()[0];
        var fileContent:String = File.getContent(path);
        var reader:FastaAlignmentReader = new FastaAlignmentReader();
        var seqs:Vector<Sequence> = reader.readSequences(fileContent);
        var g = NeighborJoining.run(seqs);
        var result:String = g.getGraphDotRepresentation();
        trace(result);
        var c:Clade = MidPointRooter.root(g, seqs);
        trace(c);
        FourTimesRule.doRule(c);
        trace(c);
        trace(c.getSVG());
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
