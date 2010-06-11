From: Phillip Susi <psusi@cfl.rr.com>
Subject: 2 TB wraparound on 32 bit host
Date: Fri, 11 Jun 2010 16:57:16 -0400
Message-ID: <4C12A32C.3000501@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I am seeing access to > 2tb on a dm target silently wrap around to 0.
Simple recreation steps:

lvcreate --type zero -L 3TB -n empty vg0
lvcreate -s vg0/empty -L 10G -n thin
mke2fs -t ext4 -E lazy_itable_init /dev/vg0/thin
e2fsck -f /dev/vg0/thin

The fsck will find block bitmap differences on a cleanly formatted fs
that seem to be caused by wraparound.  Accessing block 536870912 with dd
seems to return the superblock instead of the block allocation bitmap
that should be located there.

This is using kernel 2.6.31-21-generic-pae i686 build from Ubuntu 9.10.

Is this a known issue and/or can anyone reproduce it?
