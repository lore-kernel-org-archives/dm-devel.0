From: Mikulas Patocka <mpatocka@redhat.com>
Subject: libblkid filesystem block size
Date: Wed, 3 Oct 2018 17:41:59 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1810031724070.7859@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: Vojtech Trefny <vtrefny@redhat.com>, Karel Zak <kzak@redhat.com>
Cc: util-linux@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, lvm-devel@redhat.com
List-Id: dm-devel.ids

Hi

As you maintain libblkid, I'd like to ask - would it be possible to add 
detection of filesystem block size to it? libblkid already has description 
of various filesystem superblocks, so it shouldn't be too hard.

LVM needs to know the block size because when it enables caching for a 
logical volume using the dm-writecache target or integrity protection 
using the dm-integrity target, the block size of the device mapper target 
should match the block size of the underlying filesystem (if the cache has 
smaller block size than the filesystem, it is inefficient, if the cache 
has larger block size than the filesystem, the filesystem won't mount).

Caching or integrity protection can be enabled on the fly for existing 
logical volumes (mounted or not mounted). XFS creates filesystems with 
512-byte block size even on some modern SSDs, so the problem with small 
block size exists even today.

Mikulas

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
