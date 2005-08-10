From: "goggin, edward" <egoggin@emc.com>
Subject: How should path group failback work in a multi-node
	cluster?
Date: Wed, 10 Aug 2005 18:16:02 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ABC5@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Should automatic path group failback be disabled on all cluster
configurations?
This is certainly what I have assumed in order to avoid cases where the
nodes
of a cluster are battling one another trying to activate different path
groups for
the same block device.

Yet, this approach has the disadvantage of potentially resulting in an
unbalanced
assignment of block devices to path groups over time, that is, too many
block
devices could be active on the same path group.  Most asymmetric storage
systems are not meant to reserve a path group as a hot standby for all
logical
units, but instead statically balance the assignment of logical units to
path groups
in order to balance the overall IO load.

Another approach is to only initiate automatic failback from a host if the
initial
failover was initiated by that host.  Otherwise, assuming the currently
active path
group contains active paths, simply accept the externally initiated path
group
re-assignment away from the highest priority path group and start using
paths
from the active path group.

This approach certainly requires the tracking of path group
assignment/activations
away from the highest priority path group initiated by a host on a block
device
basis.  Seems like the multipath target driver in the kernel is the best
place for this.
Multipathd could pull out this information and use it to further
conditionalize the
autoamtic path group failback.
