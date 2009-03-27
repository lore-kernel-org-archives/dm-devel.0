From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 2] DM Exception Store: Clusterized Exception
	Store (for cluster-aware snapshots)
Date: Fri, 27 Mar 2009 16:38:11 -0500
Message-ID: <1238189891.16995.9.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-zgDQkTvv8XcDQbiP2cTX"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--=-zgDQkTvv8XcDQbiP2cTX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

In addition to the simple fix (s/ENOENT/-ENOENT/) mentioned after my
previous post, I've also discovered and fixed a nasty semaphore deadlock
condition.

I've run some mild tests and found that I can successfully:
- Create/mount ext3 file system on node-A
- Create cluster snapshot
- Mount snapshot on node-B for reading, while node-A is untarring linux
kernels

I'm including a script, 'clusterize_snapshot.sh', which converts
snapshots to cluster-aware snapshots.  The steps I perform are as
follows:
1) on one node, create a snapshot ('lvcreate -s ...')
2) 'vgchange -ay' on all nodes (you must be using shared storage)
3) run 'clusterize_snapshot.sh' on all nodes

 brassow



--=-zgDQkTvv8XcDQbiP2cTX
Content-Disposition: attachment; filename=clusterize_snapshot.sh
Content-Type: application/x-shellscript; name=clusterize_snapshot.sh
Content-Transfer-Encoding: 7bit

#!/bin/bash

if [ -z $1 ]; then
	snapshot_name="vg-snap"
else
	snapshot_name=$1
fi

if ! cman_tool status >& /dev/null; then
	echo "Cluster status failure: is the cluster running/quorate?"
	exit 1
fi

if ! lsmod | grep clusterized >& /dev/null; then
	echo "Cluster exception store module not loaded... attempting load"
	if ! modprobe dm-exstore-clusterized; then
		echo "Failed to load module"
		exit 1
	fi
fi

a=(`dmsetup table $snapshot_name`)

if [ ${a[4]} == "clusterized-persistent" ]; then
	echo "Returning snapshot to single mode"
	ctr_str="${a[0]} ${a[1]} ${a[2]} ${a[3]} ${a[6]} P ${a[7]}"
else
	echo "Converting snapshot to cluster mode"
	ctr_str="${a[0]} ${a[1]} ${a[2]} ${a[3]} clusterized-persistent 3 ${a[4]} ${a[6]} cluster_uuid:$snapshot_name"
fi

dmsetup suspend $snapshot_name
echo $ctr_str | dmsetup load $snapshot_name
dmsetup resume $snapshot_name

--=-zgDQkTvv8XcDQbiP2cTX
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-zgDQkTvv8XcDQbiP2cTX--
