/**
 * Copyright (c) 2022 Université libre de Bruxelles, eeg-ebe Department, Yann Spöri
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

#if sys
#else
#error "This class is for Sys targets only. To compile the JS version, compile the GUI class.";
#end

import haxe.ds.Vector;
import haxelib.bio.parsers.FastaParser;
import haxelib.bio.parsers.NewickParser;
import haxelib.bio.phylo.Clade;
import haxelib.bio.phylo.KOverTheta;
import haxelib.bio.phylo.NeighborJoining;
import haxelib.bio.phylo.treerooter.OutgroopRerooter;
import haxelib.bio.Sequence;
import haxelib.bio.SequenceListAnalyzer;
import haxelib.cmd.CommandlineParser;
import haxelib.cmd.CommandlineParserResult;
import haxelib.ds.graph.StringGraph;
import haxelib.ds.set.StringSet;
import haxelib.gui.plotter.CladeColorer;
import haxelib.gui.plotter.CladePlotter;
import haxelib.util.StringMatrix;
import haxelib.util.StringMatrixReader;
import haxelib.system.System;
import sys.io.File;

/**
 * The main input of the CLI (Commandline interface) of KoT.
 *
 * @author Yann Spoeri
 */
class CLI
{
    public static function getDistanceMatrixAndSequenceLength(cmd:CommandlineParserResult):{d:StringMatrix, l:Int} {
        var distanceMatrix:StringMatrix = null;
        var sequenceLength:Int = cmd.getInt("sequenceLength");

        var fastaFile:String = cmd.getString("fastaFile");
        var distanceMatrixFile:String = cmd.getString("distanceMatrix");
        
        if (fastaFile != null) {
            if (distanceMatrixFile != null) {
                System.messages.add(5, "CmdCheck", "Fasta file and distance matrix file given! Please specify only one.");
                return null;
            }
            
            var analyzer:SequenceListAnalyzer = new SequenceListAnalyzer();
            System.messages.add(3, "KoT", "Parsing fasta file ...");
            var fastaFileContent:List<Sequence> = null;
            try {
                var fastaFilefastaFileContent:String = File.getContent(fastaFile);
                var parser:FastaParser = new FastaParser();
                fastaFileContent = parser.read(fastaFilefastaFileContent);
            } catch (e) {
                System.messages.add(5, "FastaParser", "Error reading fasta file");
                System.messages.add(5, "FastaParser", "" + e);
                return null;
            }
            
            System.messages.add(3, "KoT", "Checking fasta file content ...");
            var stop:Bool = false;
            try {
                var containsEmptyNames:Bool = analyzer.containsASequenceWithAnEmptyName(fastaFileContent);
                if (containsEmptyNames) {
                    System.messages.add(5, "FastaCheck", "Your fasta file contains at least one sequence without a name. Every sequence in your dataset must have a (unique) name.");
                    stop = true;
                }
                var duplicatedNames:List<String> = analyzer.getDuplicatedNamesInDataSet(fastaFileContent);
                if (duplicatedNames.length != 0) {
                    System.messages.add(5, "FastaCheck", "There are multiple sequences with the same name(s) in your dataset, namely " + duplicatedNames.join(",") + ". Each sequence in your dataset must have a unique name.");
                    stop = true;
                }
                var sequenceWithDifferentLength:Sequence = analyzer.checkAllSequencesSameLength(fastaFileContent);
                if (sequenceWithDifferentLength != null) {
                    System.messages.add(5, "FastaCheck", "The length of the sequence " + sequenceWithDifferentLength.getName() + " in your dataset differs in comparison to the length of the sequence(s) before. Please align your sequences first!");
                    stop = true;
                }
                var allowedChars:Array<String> = ["A","C","T","G","R","Y","S","W","K","M","B","D","H","V","N",".","-","?"];
                var unallowedCharsInSequence:{s:Sequence, l:List<Int>} = analyzer.checkCharsInSequences(fastaFileContent, allowedChars);
                if (unallowedCharsInSequence != null) {
                    var seqName:String = unallowedCharsInSequence.s.getName();
                    var position = unallowedCharsInSequence.l.first();
                    var char:String = unallowedCharsInSequence.s.getSequence().charAt(position);
                    System.messages.add(5, "FastaCheck", "Illegal character " + char + " detected in sequence " + seqName + " at position " + position);
                    stop = true;
                }
            } catch (e) {
                System.messages.add(5, "FastaCheck", "Error checking fasta file");
                System.messages.add(5, "FastaCheck", "" + e);
                return null;
            }
            if (stop) {
                return null;
            }
            
            System.messages.add(3, "KoT", "Calculate distance matrix ...");
            var treatmentOfGapsAndMissingData:Int = cmd.getInt("treatmentOfGapsAndMissingData");
            if (treatmentOfGapsAndMissingData == 0) {
                distanceMatrix = analyzer.toDistanceMatrixUsingPairwiseComparison(fastaFileContent);
            } else if (treatmentOfGapsAndMissingData == 1) {
                distanceMatrix = analyzer.toDistanceMatrixUsingGlobalDeletion(fastaFileContent);
            } else {
                System.messages.add(5, "SequenceComparer", "Unknown compare method " + treatmentOfGapsAndMissingData + ". Compare Method must be 0 (pairwise deletion) or 1 (global deletion).");
                return null;
            }
            
            if (sequenceLength == -1) {
                sequenceLength = fastaFileContent.first().length();
            }
        } else if (distanceMatrixFile != null) {
            System.messages.add(3, "KoT", "Parsing distance matrix file ...");
            var distanceMatrixFileContent:String = null;
            try {
                distanceMatrixFileContent = File.getContent(distanceMatrixFile);
            } catch (e) {
                System.messages.add(5, "DistanceMatrixReader", "Error reading distance matrix file");
                System.messages.add(5, "DistanceMatrixReader", "" + e);
                return null;
            }
            try {
                distanceMatrix = StringMatrixReader.readMatrix(distanceMatrixFileContent);
            } catch (e) {
                System.messages.add(5, "DistanceMatrixReader", "Error parsing distance matrix file");
                System.messages.add(5, "DistanceMatrixReader", "" + e);
                return null;
            }
            
            System.messages.add(3, "KoT", "Checking distance matrix file ...");
            for (name1 in distanceMatrix.getNames()) {
                for (name2 in distanceMatrix.getNames()) {
                    if (name1 == name2) {
                        var val:Float = distanceMatrix.lookup(name1, name2);
                        if (val != 0.0) {
                            System.messages.add(5, "DistanceMatrixCheck", "A distance matrix must have 0s on the diagonal.");
                            return null;
                        }
                    } else {
                        var val:Float = distanceMatrix.lookup(name1, name2);
                        if (!(0.0 <= val && val <= 1)) {
                            System.messages.add(5, "DistanceMatrixCheck", "Values in this distance matrix must be between 0 and 1 (inclusive). Check " + name1 + "," + name2 + ".");
                            return null;
                        }
                        var val2:Float = distanceMatrix.lookup(name2, name1);
                        if (val != val2) {
                            System.messages.add(5, "DistanceMatrixCheck", "Distance matrix must be symmetrical. Check " + name1 + "," + name2 + " (" + val + "," + val2 + ").");
                            return null;
                        }
                    }
                }
            }
        } else {
            System.messages.add(5, "CmdCheck", "Neither Fasta file nor distance matrix file given! Please specify only of them.");
            return null;
        }
        
        if (sequenceLength <= 0) {
            System.messages.add(5, "CmdCheck", "Sequence length must be a positive, non 0 integer (not " + sequenceLength + ")");
            return null;
        }
        
        var distanceMatrixOutputFile:String = cmd.getString("distanceMatrixOutputFile");
        if (distanceMatrixOutputFile != null) {
            System.messages.add(3, "KoT", "Outputting distance matrix ...");
            var distanceMatrixAsString:String = distanceMatrix.toString();
            File.saveContent(distanceMatrixOutputFile, distanceMatrixAsString);
        }
        
        return {
            d : distanceMatrix,
            l : sequenceLength
        };
    }
/*
    public static function createGraph(distanceMatrix:StringMatrix, newickFile:String):StringGraph<String> {
        var result:StringGraph<String> = null;
        if (newickFile != null) {
            var clade:NewickClade = null;
            try {
                var newickFileContent:String = File.getContent(newickFile);
                var parser:NewickParser = new NewickParser();
                clade = parser.read(newickFileContent);
            } catch (e) {
                System.messages.add(5, "NewickParser", "Error reading newick file");
                System.messages.add(5, "NewickParser", "" + e);
            }
            var ok:Bool = true;
            var leafNames:List<String> = clade.getLeafNames();
            var seen:StringSet = new StringSet();
            for (name in leafNames) {
                if (name == null || name == "") {
                    System.messages.add(5, "NewickChecker", "Newick with empty leaf name");
                    ok = false;
                }
                if (seen.contains(name)) {
                    System.messages.add(5, "NewickChecker", "Newick tree with duplicated leaf name " + name);
                    ok = false;
                }
                seen.add(name);
            }
            var distMatrixNames:Vector<String> = distanceMatrix.getNames();
            for (name in distMatrixNames) {
                var contained:Bool = seen.remove(name);
                if (!contained) {
                    System.messages.add(5, "NewickChecker", name + " not present in newick but in distance matrix/fasta file!");
                    ok = false;
                }
            }
            for (name in seen) {
                System.messages.add(5, "NewickChecker", name + " present in newick but not in distance matrix/fasta file!");
                ok = false;
            }
            if (!ok) {
                return null;
            }
            result = new StringGraph<String>();
            for (name in leafNames) {
                result.addNode(name);
            }
            copyGraph(null, clade, result);
        } else {
            //var graph:StringGraph<Float> = NeighborJoining.runOnMatrix(distanceMatrix);
        }
        return result;
    }
    private static function copyGraph(from:NewickClade, clade:NewickClade, result:StringGraph<String>):Void {
        if (clade.subClades == null || clade.subClades.isEmpty()) {
            
            return;
        }
        
    }*/
    
    private static function createCladesByNewickFile(distanceMatrix:StringMatrix, newickFile:String):Clade {
        var clade:Clade = null;
        try {
            var newickFileContent:String = File.getContent(newickFile);
            var parser:NewickParser = new NewickParser();
            clade = parser.read(newickFileContent);
        } catch (e) {
            System.messages.add(5, "NewickParser", "Error reading newick file");
            System.messages.add(5, "NewickParser", "" + e);
        }
        var ok:Bool = true;
        var leafNames:List<String> = clade.getLeafNames();
        var seen:StringSet = new StringSet();
        for (name in leafNames) {
            if (name == null || name == "") {
                System.messages.add(5, "NewickChecker", "Newick with empty leaf name");
                ok = false;
            }
            if (seen.contains(name)) {
                System.messages.add(5, "NewickChecker", "Newick tree with duplicated leaf name " + name);
                ok = false;
            }
            seen.add(name);
        }
        var distMatrixNames:Vector<String> = distanceMatrix.getNames();
        for (name in distMatrixNames) {
            var contained:Bool = seen.remove(name);
            if (!contained) {
                System.messages.add(5, "NewickChecker", name + " not present in newick but in distance matrix/fasta file!");
                ok = false;
            }
        }
        for (name in seen) {
            System.messages.add(5, "NewickChecker", name + " present in newick but not in distance matrix/fasta file!");
            ok = false;
        }
        if (!ok) {
            return null;
        }
        return clade;
//        return copyClade(clade);
    }
    /*
    private static function copyClade(c:NewickClade):Clade {
        var result:Clade = new Clade(c.name);
        if (c.extraInformation != null && c.extraInformation != "") {
            if (c.extraInformation.indexOf(":") == -1) {
                var dist:Float = Std.parseFloat(c.extraInformation);
                result.setDistance(dist);
            } else {
                var data = c.extraInformation.split(":");
                var dist:Float = Std.parseFloat(data[0]);
                var bootstrap:Float = Std.parseFloat(data[1]);
                result.setDistance(dist);
                result.setBootstrapValue(bootstrap);
            }
        }
        if (c.subClades != null) {
            for (child in c.subClades) {
                result.addChild(copyClade(child));
            }
        }
        return result;
    }*/

    public static function main() {
        var cmdParser:CommandlineParser = new CommandlineParser("kot", "Program to perform k/thetha calculations.");
        cmdParser.addArgument("fastaFile", ["-f", "--fastaFile"], "string", null, false, "The path to the fasta file.");
        cmdParser.addArgument("treatmentOfGapsAndMissingData", ["-g", "--treatmentOfGapsAndMissingData"], "int", "0", false, "The compare method to use in order to create the p-distance matrix. Till now pairwise deletion (0) and global deletion (1) are implemented.");
        cmdParser.addArgument("distanceMatrix", ["-d", "--distanceMatrix"], "string", null, false, "Instead of the fastaFile file a p-distance matrix may be uploaded (required if no fasta file was passed to this program).");
        cmdParser.addArgument("sequenceLength", ["-s", "--sequenceLength"], "int", "-1", false, "The sequence length of the alignment used to calculate the p-distance matrix (required if a distance matrix is passed to this program).");
        cmdParser.addArgument("distanceMatrixOutputFile", ["-x", "--distanceMatrixOut"], "string", null, false, "If given the calculated p-distance matrix will be written to this file.");
        
        cmdParser.addArgument("newickFile", ["-n", "--newick"], "string", null, true, "The path to the Newick file.");
        //cmdParser.addArgument("newickFile", ["-n", "--newick"], "string", null, false, "The path to the Newick file. If not given, NJ will be used to calculate a tree based on the distance matrix.");
        //cmdParser.addArgument("bootstrapThreshold", ["-t", "--bootstrapThreshold"], "float", "0.995", false, "The bootstrap threshold to use.");
        //cmdParser.addArgument("midPointRooting", ["-p", "--midPointRooting"], "bool", "false", false, "Whether to use midpointrooting.");
        cmdParser.addArgument("outgroopRooting", ["-u", "--outgroopRooting"], "string", null, false, "Outgroop rooting. If given, the parsed newick tree will be rerooted by using the given individual as outgroop.");
        //cmdParser.addArgument("outgroupRooting", ["-r", "--outgroup"], "string", null, false, "By default midpointrooting is used in order to convert the unrooted tree into a rooted one. However by using this argument you may specify an outgroup.");
        cmdParser.addArgument("rule", ["-l", "--rule"], "int", null, true, "The rule to decide whether two sister clades are different species. Till now the rules of Rosenberg (0) and Birky (1) are implemented.");
        cmdParser.addArgument("decisionThreshold", ["-k", "--decisionThreshold"], "float", null, true, "The decision threshold to use.");
        //cmdParser.addArgument("combinationRule", ["-c", "--combinationRule"], "int", "0", false, "The combination rule to take. Till now (0) short, (1) transitivity, (2) majority and (3) all are implemented.");
        cmdParser.addArgument("monophyleticOnly", ["-m", "--monophyleticOnly"], "bool", "false", false, "Delimit only monophyletic species.");
        cmdParser.addArgument("out", ["-o", "--out"], "string", null, true, "The output file to write the delimitation result to.");
        cmdParser.addArgument("svgOut", ["-v", "--svg"], "string", null, false, "A possible file to write the svg tree to.");
        var cmd:CommandlineParserResult = cmdParser.parse(Sys.args());
        
        if (cmd.hasError()) {
            var errorMessage:String = cmd.getErrorMessage();
            Sys.stderr().writeString(errorMessage);
            Sys.exit(1);
        }
        
        System.messages.add(3, "KoT", "Launched calculations ...");
        
        var distanceMatrixAndSequenceLength = getDistanceMatrixAndSequenceLength(cmd);
        if (distanceMatrixAndSequenceLength == null) {
            return;
        }
        var distanceMatrix:StringMatrix = distanceMatrixAndSequenceLength.d;
        var sequenceLength:Int = distanceMatrixAndSequenceLength.l;

        // clade ... TODO ...
        /**var newickFile:String = cmd.getString("newickFile");
        var g:StringGraph<String> = createGraph(distanceMatrix, newickFile);
        if (g == null) {
            Sys.exit(1);
        }*/
        var clade:Clade = createCladesByNewickFile(distanceMatrix, cmd.getString("newickFile"));
        
        var outgroop:String = cmd.getString("outgroopRooting");
        if (outgroop != null && outgroop != "") {
            var rerooter:OutgroopRerooter = new OutgroopRerooter(outgroop);
            clade = rerooter.reroot(clade);
        }

        System.messages.add(3, "KOverTheta", "Running K over Theta algorithm");
        var method:KOverTheta = new KOverTheta();
        method.setDecisionRule(cmd.getInt("rule"));
        method.setDecisionThreshold(cmd.getFloat("decisionThreshold"));
        method.setDelimitedSpeciesMonophyletic(cmd.getBool("monophyleticOnly"));
        var result:List<StringSet> = method.runKOverTheta(clade, distanceMatrix, sequenceLength);
        System.messages.add(3, "KOverTheta", "Finished running K over Theta algorithm; Nr. of putative species: " + result.length);
        
        var speciesList:List<String> = new List<String>();
        var i:Int = 1;
        for (set in result) {
            for (ele in set) {
                speciesList.add(ele + "\t" + i);
            }
            i++;
        }
        
        File.saveContent(cmd.getString("out"), speciesList.join("\n"));
        
        var svgFilePath:String = cmd.getString("svgOut");
        if (svgFilePath != null) {
            CladeColorer.colorClades(clade, result);
            var plotter:CladePlotter = new CladePlotter();
            var result:String = plotter.plotClade(clade);
            File.saveContent(svgFilePath, result);
        }
    }
}