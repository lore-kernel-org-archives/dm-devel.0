From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCHES] convert dm-thin to use dm-bufio
Date: Sun, 14 Aug 2011 16:18:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I created patches that convert dm-thin to use dm-bufio interface (so that 
it is consistent with dm-zeroed and dm-multisnap).

The patches are here:
http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/

Advantages:

* It uses kmalloc, __get_free_pages or __vmalloc, so the block size is not 
limited and memory fragmentation is not an issue. The original code only 
used kmalloc.

* It has dynamic cache sizing, cache size can be configured by the user. 
In case of inactivity over some time (a buffer is unused for a minute), 
the buffers are freed. The original code had cache size hardcoded and it 
couldn't be changed.

* Submit bios directly (if we can) without dm-io layer.

Notes:

* Buffer locking is not supported, I suppose it is not used for anything 
anyway. If it is used, tell me, I can add it after reviewing it.

* dm_bm_rebind_block_device changes the block device, but it is not used 
for anything (dm-thinp never changes the device). I think it could be 
removed.

* Two small bugs in dm-thin are fixed --- not closing the superblock 
buffer on exit and improper termination sequence (the block devices were 
closed before the buffer interface exited).

Mikulas
