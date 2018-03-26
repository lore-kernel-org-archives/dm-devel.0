From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 0/8] dm-bufio patches
Date: Mon, 26 Mar 2018 16:20:41 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1803261619480.29393@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180326182939.169591126@debian.vm>
	<20180326185746.GA22409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180326185746.GA22409@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids



On Mon, 26 Mar 2018, Mike Snitzer wrote:

> On Mon, Mar 26 2018 at  2:29pm -0400,
> mpatocka@redhat.com <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > Here I'm sending the second version of dm-bufio patches for arbitrary
> > sector size.
> > 
> > I dropped the patch that removes alloc_pages because it turns out that
> > alloc_pages is faster than the slab allocator.
> 
> I had already staged the previous set, so I need to go back over that
> and update accordingly.
> 
> > I also added a patch that removes struct bio from struct dm_buffer
> > (reducing the size of dm_buffer to 1/3) and allocates the bio only when
> > doing read or write.
> 
> OK, I'll go over your new set and try to tease out any differences.
> 
> Mike

One more patch that I forgot to include.



From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bufio: delete outdated comment

This comment was true when dm-bufio was written, but since the kernel 4.3,
bios can have arbitrary size and the driver splits them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2018-03-13 16:38:32.257954000 +0100
+++ linux-2.6/drivers/md/dm-bufio.c	2018-03-13 16:38:32.247954000 +0100
@@ -540,10 +540,6 @@ static void __relink_lru(struct dm_buffe
  *
  *	the memory must be direct-mapped, not vmalloced;
  *
- *	the I/O driver can reject requests spuriously if it thinks that
- *	the requests are too big for the device or if they cross a
- *	controller-defined memory boundary.
- *
  * If the buffer is small enough (up to DM_BUFIO_INLINE_VECS pages) and
  * it is not vmalloced, try using the bio interface.
  *
