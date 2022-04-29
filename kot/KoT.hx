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
import haxelib.cmd.CommandlineParser;
import haxelib.cmd.CommandlineParserResult;
import haxelib.bio.evolution.Newick;
import haxelib.bio.evolution.IClade as NewickClade;
#end
import haxe.ds.Vector;

/**
 *
 *
 * @author Yann Spoeri
 */
class KoT {

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

    public static function calcKot():Void {

    }

    #if js
    static var workerScope:js.html.DedicatedWorkerGlobalScope;
    public static function onMessage(e:js.html.MessageEvent):Void {
        var result:StringMap<String> = new StringMap<String>();
        try {
            var fileContent:String = cast(e.data.txt, String);
            var decisionRatio:Float = cast(e.data.decisionRatio, Float);
            var globalDeletion:Bool = cast(e.data.globalDeletion, Bool);
            var transitivity:Bool = cast(e.data.transitivity, Bool);
            var g:Graph<Sequence,Float> = null;
            if (fileContent.charAt(0) == ">" || fileContent.charAt(0) == ";") {
                var reader:FastaAlignmentReader = new FastaAlignmentReader();
                var seqs:Vector<Sequence> = reader.readSequences(fileContent, globalDeletion);
                if (seqs.length <= 1) {
                    result.set("svg", "");
                    result.set("putativeSpecies", "All sequences are the same!");
                    return;
                }
                g = NeighborJoining.run(seqs);
            } else {
                var reader:DistanceMatrixReader = new DistanceMatrixReader();
                var d:DistanceMatrix<Sequence> = reader.readMatrix(fileContent);
                g = NeighborJoining.runOnMatrix(d);
                FourTimesRule.distanceMatrix = d;
            }
            var c:Clade = MidPointRooter.root(g);
            var s:List<List<Sequence>> = FourTimesRule.doRule(c, decisionRatio, transitivity);
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
                if (e.mOutputted) {
                    continue;
                }
                for (name in e.getNames()) {
                    result.add(name + "\t" + i);
                }
                e.mOutputted = true;
            }
            ++i;
        }
        return result.join("\n");
    }

    public static function main() {
        #if sys
        var cmdParser:CommandlineParser = new CommandlineParser("kot", "Perform k/thetha calculations");
        cmdParser.addArgument("transitivity", ["-t", "--transitivity"], "bool", "false", false, "Whether to use transitivity.");
        cmdParser.addArgument("noglobalDeletion", ["-n", "--noGlobalDeletion"], "bool", "false", false, "Whether to disable global deletion.");
        cmdParser.addArgument("decisionRatio", ["-k", "--decisionRatio"], "float", "4.0", false, "The decision treshhold.");
        cmdParser.addArgument("file", ["-f", "--file"], "string", null, true, "The path to the fasta file.");
        cmdParser.addArgument("out", ["-o", "--out"], "string", null, true, "The output path to write the delimitation result to.");
        cmdParser.addArgument("svgOut", ["-s", "--svg"], "string", null, false, "A possible file to write the svg tree to.");
        cmdParser.addArgument("newick", ["-w", "--newick"], "string", null, false, "Path to a file containint the tree (in Newick format) to use.");
        var cmd:CommandlineParserResult = cmdParser.parse(Sys.args());

        var globalDeletion:Bool = !cmd.getBool("noglobalDeletion");
        var decisionRatio:Float = cmd.getFloat("decisionRatio");
        var transitivity:Bool = cmd.getBool("transitivity");

        var path:String = cmd.getString("file");
        var fileContent:String = File.getContent(path);

        var g:Graph<Sequence,Float> = null;
        var newickFilePath:String = cmd.getString("newick");
        if (newickFilePath != null) {
            var newickAsStr:String = File.getContent(newickFilePath);
            var clade:NewickClade = Newick.parse(newickAsStr);
            var reader:FastaAlignmentReader = new FastaAlignmentReader();
            var seqs:Vector<Sequence> = reader.readSequences(fileContent, globalDeletion);
            if (seqs.length <= 1) {
                Sys.stderr().writeString("All sequences are the same!");
                return;
            }
            var endPoints:Vector<Sequence> = seqs.copy();
            g = new Graph<Sequence,Float>(endPoints);
            recursiveCopy(seqs, g, clade);
        } else if (fileContent.charAt(0) == ">" || fileContent.charAt(0) == ";") {
            var reader:FastaAlignmentReader = new FastaAlignmentReader();
            var seqs:Vector<Sequence> = reader.readSequences(fileContent, globalDeletion);
            if (seqs.length <= 1) {
                Sys.stderr().writeString("All sequences are the same!");
                return;
            }
            g = NeighborJoining.run(seqs);
        } else {
            var reader:DistanceMatrixReader = new DistanceMatrixReader();
            var d:DistanceMatrix<Sequence> = reader.readMatrix(fileContent);
            g = NeighborJoining.runOnMatrix(d);
            FourTimesRule.distanceMatrix = d;
        }
        //Sys.stderr().writeString("" + g.getGraphDotRepresentation());
        var c:Clade = MidPointRooter.root(g);
        var s:List<List<Sequence>> = FourTimesRule.doRule(c, decisionRatio, transitivity);

        var c:Clade = MidPointRooter.root(g);
        var s:List<List<Sequence>> = FourTimesRule.doRule(c, decisionRatio, transitivity);
        var resL:String = formatSpeciesList(s);
        File.saveContent(cmd.getString("out"), resL);

        var svgFilePath:String = cmd.getString("svgOut");
        if (svgFilePath != null) {
            CladeColorer.colorClades(c, s);
            var svg:String = c.getSVG();
            File.saveContent(svgFilePath, svg);
        }

        #elseif js
        workerScope = untyped self;
        workerScope.onmessage = onMessage;
        #end
    }

    #if sys
    public static function recursiveCopy(seqs:Vector<Sequence>, g:Graph<Sequence,Float>, clade:NewickClade, ?i:Int=0):Sequence {
        var name:String = clade.getName();
        var childs = clade.getChilds();
        if (childs != null && !childs.isEmpty()) {
            var l:List<String> = new List<String>();
            //l.add("Inner" + (i));
            var inner:Sequence = new Sequence(l, null);
            g.addNode(inner);
            for (child in childs) {
                var outer:Sequence = recursiveCopy(seqs, g, child, i+1);
                var dist:Float = child.getDistance();
                if (dist == null) {
                    throw "No distance given for clade";
                }
                g.addEdge(outer, inner, dist);
            }
            return inner;
        } else {
            var nameToFind:String = clade.getName();
            if (nameToFind == null || nameToFind == "") {
                throw "Empty name for leaf clade in newick";
            }
            for (seq in seqs) {
                var seqNames = seq.getNames();
                for (name in seqNames) {
                    if (name == nameToFind) {
                        return seq;
                    }
                }
            }
            throw "No sequence(s) for " + name + " found!";
        }
        return null;
    }
    #end

/*    public static function main() {
//        var c:Clade = new Clade();
//        var c1:Clade = new Clade();
//        c.addChild(c1);
//        trace(c);
    }*/
}
