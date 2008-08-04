From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH RFC] dm snapshot: shared exception store
Date: Mon, 4 Aug 2008 17:22:12 +0900
Message-ID: <20080804171242V.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

This is a new implementation of dm-snapshot.

The important design differences from the current dm-snapshot are:

- It uses one exception store per origin device that is shared by all snapshots.
- It doesn't keep the complete exception tables in memory.

I took the exception store code of Zumastor (http://zumastor.org/).

Zumastor is remote replication software (a local server sends the
delta between two snapshots to a remote server, and then the remote
server applies the delta in an atomic manner. So the data on the
remote server is always consistent).

Zumastor snapshot fulfills the above two requirements, but it is
implemented in user space. The dm kernel module sends the information
of a request to user space and the user space daemon tells the kernel
what to do.

Zumastor user-space daemon needs to take care about replication so the
user-space approach makes sense but I think that the pure user-space
approach is an overkill just for snapshot. I prefer to implement
snapshot in kernel space (as the current dm-snapshot does). I think
that we can add features for remote replication software like Zumastor
to it, that is, features to provide user space a delta between two
snapshots and apply the delta in an atomic manner (via ioctl or
something else).

Note that the code is still in a very early stage. There are lots of
TODO items:

- snapshot deletion support
- writable snapshot support
- protection for unexpected events (probably journaling)
- performance improvement (handling exception cache and format, locking, etc)
- better integration with the current snapshot code
- improvement on error handling
- cleanups
- generating a delta between two snapshots
- applying a delta to in a atomic manner

The patch against 2.6.26 is available at:

http://www.kernel.org/pub/linux/kernel/people/tomo/dm-snap/0001-dm-snapshot-dm-snapshot-shared-exception-store.patch


Here's an example (/dev/sdb1 as an origin device and /dev/sdg1 as a cow device):

- creates the set of an origin and a cow:

flax:~# echo 0 `blockdev --getsize /dev/sdb1` snapshot-origin /dev/sdb1 /dev/sdg1 P2 16 |dmsetup create work

- no snapshot yet:

flax:~# dmsetup status
work: 0 125017767 snapshot-origin : no snapshot


- creates one snapshot (the id of the snapshot is 0):

flax:~# dmsetup message /dev/mapper/work 0 snapshot create 0


- creates one snapshot (the id of the snapshot is 1):

flax:~# dmsetup message /dev/mapper/work 0 snapshot create 1


- there are two snapshots (#0 and #1):

flax:~# dmsetup status
work: 0 125017767 snapshot-origin 0 1


- let's access to the snapshots:

flax:~# echo 0 `blockdev --getsize /dev/sdb1` snapshot /dev/sdb1 0|dmsetup create work-snap0
flax:~# echo 0 `blockdev --getsize /dev/sdb1` snapshot /dev/sdb1 1|dmsetup create work-snap1

flax:~# ls /dev/mapper/
control  work  work-snap0  work-snap1
