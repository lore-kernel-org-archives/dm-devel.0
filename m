From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] offload bios to a thread
Date: Wed, 6 Jul 2016 09:36:56 -0400
Message-ID: <20160706133656.GA28547@redhat.com>
References: <alpine.LRH.2.02.1607041846020.16388@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1607041846020.16388@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Mon, Jul 04 2016 at  6:53pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> This is the second version of patches that fix deadlocks by redirecting 
> bios from current->bio_list to rescuer workqueues.
> 
> I found out that the original patches caused deadlock with the loopback 
> device. When the loopback device is used, both lower and upper filesystems 
> use the same bio set - fs_bio_set. Consequently, bios submitted by both of 
> them end up on the same rescuer workqueue. There is a deadlock possibility 
> - if generic_make_request for the upper filesystem's bio blocks (because 
> there are too many requests in flight on the loop device), it may stall 
> processing some bios for the lower filesystem.
> 
> Ideadlly, each filesystem should have its own bio set. But it doesn't. So 
> I fix this problem by not offloading bios allocated from fs_bio_set.

I'd much preferred you just send an incremental fix that built on the
tree you know I started, here:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip

I've now folded your fix into this tree.

But please don't ignore work you know that was done to further prepare
your patches for inclusion.  It makes for tedious busy work on my end to
pull out the incremental fix, which is simply:

diff --git a/block/bio.c b/block/bio.c
index 7c49b91..80ebe88 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -357,7 +357,9 @@ static void bio_alloc_rescue(struct work_struct *work)
  * to their rescue workqueue.
  *
  * If the bio doesn't have a bio_set, we leave it on queued_bios->bio_list.
- * However, stacking drivers should use bio_set, so this shouldn't be
+ * If the bio is allocated from fs_bio_set, we must leave it to avoid
+ * deadlock on loopback block device.
+ * But stacking drivers should use a bio_set, so this shouldn't be
  * an issue.
  */
 static void blk_timer_flush_bio_list(unsigned long data)
@@ -371,7 +373,7 @@ static void blk_timer_flush_bio_list(unsigned long data)
 	while ((bio = bio_list_pop(&list))) {
 		unsigned long flags;
 		struct bio_set *bs = bio->bi_pool;
-		if (unlikely(!bs)) {
+		if (unlikely(!bs) || bs == fs_bio_set) {
 			bio_list_add(&queued_bios->bio_list, bio);
 			continue;
 		}
