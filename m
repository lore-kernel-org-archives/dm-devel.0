From: Jim Minter <jminter@redhat.com>
Subject: dm-thin discard issue
Date: Wed, 6 Mar 2013 08:12:39 -0500 (EST)
Message-ID: <23057571.57.1362575554699.JavaMail.javamailuser@localhost>
References: <1801783.47.1362573815861.JavaMail.javamailuser@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1801783.47.1362573815861.JavaMail.javamailuser@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello,

I think I've uncovered a problem when issuing the BLKDISCARD ioctl to a thin volume.  If I create a thin volume, fill it with data, snapshot it, then call BLKDISCARD on the thin volume, it looks like the kernel doesn't take into account the fact that the underlying blocks are shared with the snapshot, and just goes ahead and discards them.  This appears to then leave the metadata in an inconsistent state.

Here's a reproducer (works on rawhide as of today, 3.9.0-0.rc1.git0.1.fc19.x86_64):
(assumes volumes 253:2 for metadata and 253:3 for pool; uses blkdiscard from upstream util-linux to issue the BLKDISCARD ioctl)

=== 8< ===
echo +++ Creating pool and thin...
dmsetup create pool --table '0 2097152 thin-pool 253:2 253:3 128 0 1 no_discard_passdown'
dmsetup message /dev/mapper/pool 0 "create_thin 0"
dmsetup create thin --table "0 1048576 thin /dev/mapper/pool 0"

echo +++ Filling thin...
dd if=/dev/zero of=/dev/mapper/thin bs=1M &>/dev/null

echo +++ Creating snap...
dmsetup suspend /dev/mapper/thin
dmsetup message /dev/mapper/pool 0 "create_snap 1 0"
dmsetup resume /dev/mapper/thin

dmsetup create snap --table "0 1048576 thin /dev/mapper/pool 1"

dmsetup status

echo +++ Discarding thin...
blkdiscard /dev/mapper/thin
dmsetup status
=== 8< ===

Output is:

=== 8< ===
+++ Creating pool and thin...
+++ Filling thin...
+++ Creating snap...
thin: 0 1048576 thin 1048576 1048575
vg-pool: 0 2097152 linear 
fedora-swap: 0 8257536 linear 
fedora-root: 0 32653312 linear 
vg-meta: 0 262144 linear 
snap: 0 1048576 thin 1048576 1048575
pool: 0 2097152 thin-pool 0 72/32768 8192/16384 - rw no_discard_passdown
+++ Discarding thin...
thin: 0 1048576 thin 0 -
vg-pool: 0 2097152 linear 
fedora-swap: 0 8257536 linear 
fedora-root: 0 32653312 linear 
vg-meta: 0 262144 linear 
snap: 0 1048576 thin 1048576 1048575
pool: 0 2097152 thin-pool 0 73/32768 0/16384 - rw no_discard_passdown
=== 8< ===
-------------------------------------^
At this point, pool's used data blocks looks wrong - I'd expect 8192 still, not 0.

After 'dmsetup remove'ing snap, thin and pool, the output of thin_check /dev/mapper/vg-meta is:

=== 8< ===
Errors in metadata
  Errors in data block reference counts
    0: was 0, expected 1
    1: was 0, expected 1
...
    8190: was 0, expected 1
    8191: was 0, expected 1
=== 8< ===

I'm also having trouble recovering from this situation using the user-space tools, but I'll continue about that on a second thread.

Cheers,

Jim
