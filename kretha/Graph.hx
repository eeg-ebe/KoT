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

import haxe.ds.HashMap;
import haxe.ds.Vector;

/**
 * A simple graph object.
 *
 * @author Yann Spoeri
 */
class Graph<V:{function hashCode():Int;function getNodeName():String;},E> {

    /**
     * The set of nodes.
     */
    private var mNodes:HashMap<V,GraphNode<V,E>>;

    /**
     * Init the graph.
     */
    public function new(nodeInfo:Vector<V>=null) {
        mNodes = new HashMap<V,GraphNode<V,E>>();
        if (nodeInfo != null) {
            for (node in nodeInfo) {
                var gn:GraphNode<V,E> = new GraphNode<V,E>(node);
                mNodes.set(node, gn);
            }
        }
    }

    public function getLeafs():List<V> {
        var result:List<V> = new List<V>();
        for (node in mNodes) {
            var ele:V = node.getElement();
            if (node.countConnections() >= 2) {
                continue; // not a leaf
            }
            result.add(ele);
        }
        return result;
    }

    /**
     * Add a node to this graph.
     */
    public inline function addNode(ele:V):Void {
        var gn:GraphNode<V,E> = new GraphNode<V,E>(ele);
        mNodes.set(ele, gn);
    }

    /**
     * Check whether an element exists.
     */
    public inline function exists(ele:V):Bool {
        return mNodes.exists(ele);
    }

    /**
     * Add a new edge.
     */
    public inline function addEdge(x:V, y:V, val:E):Void {
        var v1:GraphNode<V,E> = mNodes.get(x);
        if (v1 == null) {
            throw x + " not in graph!";
        }
        var v2:GraphNode<V,E> = mNodes.get(y);
        if (v2 == null) {
            throw y + " not in graph!";
        }
        v1.addEdge(v2, val);
        v2.addEdge(v1, val);
    }

    /**
     * Get all edges.
     */
    public inline function getEdges(x:V):List<{ v: V, e : E}> {
        var v1:GraphNode<V,E> = mNodes.get(x);
        if (v1 == null) {
            throw x + " not in graph!";
        }
        return v1.getEdges();
    }

    /**
     * Get the connection between two nodes.
     * In case there is no connection between the two nodes, null will be returned.
     */
    public inline function getConnection(x:V, y:V):E {
        var v1:GraphNode<V,E> = mNodes.get(x);
        var v2:GraphNode<V,E> = mNodes.get(y);
        return v1.getEdge(v2);
    }

    public function getGraphDotRepresentation():String {
        var result:List<String> = new List<String>();
        var seen:HashMap<V,Bool> = new HashMap<V,Bool>(); // a HashSet would be better, but is not available in haxe.ds
        result.add("graph {");
        for (node in mNodes) {
            var ele:V = node.getElement();
            for (edge in node.getEdges()) {
                if (seen.exists(edge.v)) {
                    continue;
                }
                result.add("  " + ele.getNodeName() + " -- " + edge.v.getNodeName() + " [label=\"" + edge.e + "\"];");
            }
            seen.set(ele, true);
        }
        result.add("}");
        return result.join("\n");
    }

}
