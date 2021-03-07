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

class GraphNode<V,E> {

    /**
     * The object connected to this GraphNode object.
     */
    private var mEleObject:V;

    /**
     * The edges connected to this node.
     */
    private var mConnectedEdges:List<{ node : GraphNode<V,E> , e : E }>;

    /**
     * Create new new GraphNode object.
     */
    public function new(ele:V) {
        mEleObject = ele;
        mConnectedEdges = new List<{ node : GraphNode<V,E> , e : E }>();
    }

    /**
     * Get the element connected to this node object.
     */
    public inline function getElement():V {
        return mEleObject;
    }

    /**
     * Add an edge.
     */
    public function addEdge(other:GraphNode<V,E>, e:E):Void {
        for (edge in mConnectedEdges) {
            if (edge.node == other) {
                edge.e = e;
                return;
            }
        }
        mConnectedEdges.add({
            node : other,
            e : e
        });
    }

    /**
     * Check whether this GraphNode is connected to another graph node.
     */
    public function isConnectedTo(other:GraphNode<V,E>):Bool { 
        for (edge in mConnectedEdges) {
            if (edge.node == other) {
                return true;
            }
        }
        return false;
    }

    /**
     * Get an edge.
     */
    public function getEdge(other:GraphNode<V,E>):E {
        for (edge in mConnectedEdges) {
            if (edge.node == other) {
                return edge.e;
            }
        }
        return null;
    }

    /**
     * Get a list of connected nodes.
     */
    public function getEdges():List<{ v: V, e : E}> {
        var result:List<{ v: V, e : E}> = new List<{ v: V, e : E}>();
        for (edge in mConnectedEdges) {
            result.add({ v : edge.node.getElement(), e : edge.e });
        }
        return result;
    }

}
