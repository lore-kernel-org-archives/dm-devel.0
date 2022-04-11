Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 251C7C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649686701;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4uwHABKlIUTy+8CA2cTuoS0ff5zJE6151KXP9XFK/z4=;
	b=JwvAYvAKZoKh8mdUvKImSqS/VKoCWovSPtHXSxjkN4H1Z8k33g5ecRTps51YnB9nrFG39q
	8/0xJLZY8rwBLCIe5ksv9UltqSC81N6qr/D8xwxoSDMphy62jcNxiVVH37YEgxbDgCKO/M
	Rak9UIr+sGVPgAvVM4Iun1RaMOFvOX4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-zYNkrmWRPKKx9QMqH3J5rQ-1; Mon, 11 Apr 2022 10:18:19 -0400
X-MC-Unique: zYNkrmWRPKKx9QMqH3J5rQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05B7D296A606;
	Mon, 11 Apr 2022 14:18:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C93694047D3D;
	Mon, 11 Apr 2022 14:18:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7457C19451F2;
	Mon, 11 Apr 2022 14:18:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5630B19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 14:18:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 49878C44B17; Mon, 11 Apr 2022 14:18:14 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A7341C28130;
 Mon, 11 Apr 2022 14:18:10 +0000 (UTC)
Date: Mon, 11 Apr 2022 22:18:05 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <YlQ4na/HwBSm5C3U@T590>
References: <20220408171254.935171-1-ming.lei@redhat.com>
 <20220408171254.935171-2-ming.lei@redhat.com>
 <8b9078c2-7884-a5b5-5aa9-ad284b4068ef@opensource.wdc.com>
 <YlN4BC2qbGODxbVz@T590>
 <95d8a8ed-27f8-0d88-a543-16910dca83e3@opensource.wdc.com>
 <YlN+plgvwZQdPBGj@T590>
 <7ccf1709-8aec-18c3-1d09-fe03b4a57017@opensource.wdc.com>
 <6b617a59-1591-8323-9de8-b39247eb328f@opensource.wdc.com>
 <YlPZ7vSZGMZBaRDv@T590>
 <54279bbe-6e8b-2c0a-90fc-825b89863b3f@opensource.wdc.com>
MIME-Version: 1.0
In-Reply-To: <54279bbe-6e8b-2c0a-90fc-825b89863b3f@opensource.wdc.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 1/3] dm: don't grab target io reference in
 dm_zone_map_bio
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 11, 2022 at 04:42:59PM +0900, Damien Le Moal wrote:
> On 4/11/22 16:34, Ming Lei wrote:
> > On Mon, Apr 11, 2022 at 11:55:14AM +0900, Damien Le Moal wrote:
> >> On 4/11/22 11:19, Damien Le Moal wrote:
> >>> On 4/11/22 10:04, Ming Lei wrote:
> >>>> On Mon, Apr 11, 2022 at 09:50:57AM +0900, Damien Le Moal wrote:
> >>>>> On 4/11/22 09:36, Ming Lei wrote:
> >>>>>> On Mon, Apr 11, 2022 at 09:18:56AM +0900, Damien Le Moal wrote:
> >>>>>>> On 4/9/22 02:12, Ming Lei wrote:
> >>>>>>>> dm_zone_map_bio() is only called from __map_bio in which the io's
> >>>>>>>> reference is grabbed already, and the reference won't be released
> >>>>>>>> until the bio is submitted, so no necessary to do it dm_zone_map_bio
> >>>>>>>> any more.
> >>>>>>>
> >>>>>>> I do not think that this patch is correct. Removing the extra reference on
> >>>>>>> the io can lead to problems if the io is completed in the target
> >>>>>>> ->map(ti, clone) call or before dm_zone_map_bio_end() is called for the
> >>>>>>> DM_MAPIO_SUBMITTED or DM_MAPIO_REMAPPED cases. dm_zone_map_bio_end() needs
> >>>>>>
> >>>>>> __map_bio():
> >>>>>> 	...
> >>>>>> 	dm_io_inc_pending(io);
> >>>>>> 	...
> >>>>>> 	dm_zone_map_bio(tio);
> >>>>>> 	...
> >>>>>
> >>>>> dm-crypt (for instance) may terminate the clone bio immediately in its
> >>>>> ->map() function context, resulting in the bio_endio()clone) ->
> >>>>> clone_endio() -> dm_io_dec_pending() call chain.
> >>>>>
> >>>>> With that, the io is gone and dm_zone_map_bio_end() will not have a valid
> >>>>> reference on the orig bio.
> >>>>
> >>>> Any target can complete io during ->map. Here looks nothing is special with
> >>>> dm-crypt or dm-zone, why does only dm zone need extra reference?
> >>>>
> >>>> The reference counter is initialized as 1 in init_clone_info(), dm_io_inc_pending()
> >>>> in __map_bio() increases it to 2, so after the above call chain you mentioned is done,
> >>>> the counter becomes 1. The original bio can't be completed until dm_io_dec_pending()
> >>>> in dm_split_and_process_bio() is called.
> >>>>
> >>>> Or maybe I miss any extra requirement from dm-zone?
> >>>
> >>> Something is wrong... With and without your patch, when I setup a dm-crypt
> >>> target on top of a zoned nullblk device, I get:
> >>>
> >>> [  292.596454] device-mapper: uevent: version 1.0.3
> >>> [  292.602746] device-mapper: ioctl: 4.46.0-ioctl (2022-02-22)
> >>> initialised: dm-devel@redhat.com
> >>> [  292.732217] general protection fault, probably for non-canonical
> >>> address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN PTI
> >>> [  292.743724] KASAN: null-ptr-deref in range
> >>> [0x0000000000000010-0x0000000000000017]
> >>> [  292.751409] CPU: 0 PID: 4259 Comm: systemd-udevd Not tainted
> >>> 5.18.0-rc2+ #1458
> >>> [  292.758746] Hardware name: Supermicro Super Server/X11DPL-i, BIOS 3.3
> >>> 02/21/2020
> >>> [  292.766250] RIP: 0010:dm_zone_map_bio+0x146/0x1740 [dm_mod]
> >>> [  292.771938] Code: 00 00 4d 8b 65 10 48 8d 43 28 48 89 44 24 10 49 8d 44
> >>> 24 10 48 89 c2 48 89 44 24 18 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03
> >>> <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 78 0e 00 00 45 8b 7c 24 10 41
> >>> [  292.790946] RSP: 0018:ffff8883cd847218 EFLAGS: 00010202
> >>> [  292.796260] RAX: dffffc0000000000 RBX: ffff8885c5bcdce8 RCX:
> >>> 1ffff11034470027
> >>> [  292.803496] RDX: 0000000000000002 RSI: 0000000000000008 RDI:
> >>> ffff8885c5bcdc60
> >>> [  292.810732] RBP: 1ffff11079b08e4f R08: ffff8881a23801d8 R09:
> >>> ffff8881a238013f
> >>> [  292.817970] R10: ffff88821c594040 R11: 0000000000000001 R12:
> >>> 0000000000000000
> >>> [  292.825206] R13: ffff8885c5bcdc50 R14: ffff8881a2380000 R15:
> >>> ffff8885c5bcdd08
> >>> [  292.832442] FS:  00007fe169b06b40(0000) GS:ffff88880fc00000(0000)
> >>> knlGS:0000000000000000
> >>> [  292.840646] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [  292.846481] CR2: 00007ffd80a57a38 CR3: 00000004b91b0006 CR4:
> >>> 00000000007706f0
> >>> [  292.853722] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> >>> 0000000000000000
> >>> [  292.860957] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> >>> 0000000000000400
> >>> [  292.868194] PKRU: 55555554
> >>> [  292.870949] Call Trace:
> >>> [  292.873446]  <TASK>
> >>> [  292.875593]  ? lock_is_held_type+0xd7/0x130
> >>> [  292.879860]  ? dm_set_zones_restrictions+0x8f0/0x8f0 [dm_mod]
> >>> [  292.885718]  ? __module_address.part.0+0x25/0x300
> >>> [  292.890509]  ? is_module_address+0x43/0x70
> >>> [  292.894674]  ? static_obj+0x8a/0xc0
> >>> [  292.898233]  __map_bio+0x352/0x740 [dm_mod]
> >>> [  292.902512]  dm_submit_bio+0x72f/0x17a0 [dm_mod]
> >>> [  292.907222]  ? find_held_lock+0x2c/0x110
> >>> [  292.911217]  ? __send_empty_flush+0x2b0/0x2b0 [dm_mod]
> >>> [  292.916459]  ? lock_release+0x3b2/0x6f0
> >>> [  292.920368]  ? lock_downgrade+0x6d0/0x6d0
> >>> [  292.924458]  ? lock_is_held_type+0xd7/0x130
> >>> [  292.928714]  __submit_bio+0x12a/0x1f0
> >>> [  292.932450]  submit_bio_noacct_nocheck+0x324/0x840
> >>> [  292.937324]  ? should_fail_request+0x70/0x70
> >>> [  292.941670]  ? rcu_read_lock_sched_held+0x3f/0x70
> >>> [  292.946458]  ? submit_bio_noacct+0xfa4/0x1530
> >>> [  292.950888]  ? lock_is_held_type+0xd7/0x130
> >>> [  292.957813]  mpage_readahead+0x32e/0x4b0
> >>> [  292.964470]  ? do_mpage_readpage+0x17c0/0x17c0
> >>> [  292.971661]  ? blkdev_write_begin+0x20/0x20
> >>> [  292.978567]  ? lock_release+0x3b2/0x6f0
> >>> [  292.985073]  ? folio_add_lru+0x217/0x3f0
> >>> [  292.991620]  ? lock_downgrade+0x6d0/0x6d0
> >>> [  292.998237]  read_pages+0x18c/0x990
> >>> [  293.004308]  ? memcg_list_lru_alloc+0x810/0x810
> >>> [  293.011404]  ? folio_add_lru+0x238/0x3f0
> >>> [  293.017805]  ? file_ra_state_init+0xd0/0xd0
> >>> [  293.024395]  ? policy_node+0xbb/0x140
> >>> [  293.030416]  page_cache_ra_unbounded+0x258/0x410
> >>> [  293.037376]  force_page_cache_ra+0x281/0x400
> >>> [  293.043944]  filemap_get_pages+0x25e/0x1290
> >>> [  293.050342]  ? __lock_acquire+0x1603/0x6180
> >>> [  293.056654]  ? filemap_add_folio+0x140/0x140
> >>> [  293.063002]  ? lock_is_held_type+0xd7/0x130
> >>> [  293.069236]  filemap_read+0x29e/0x910
> >>> [  293.074927]  ? filemap_get_pages+0x1290/0x1290
> >>> [  293.081378]  ? __lock_acquire+0x1603/0x6180
> >>> [  293.087558]  blkdev_read_iter+0x20c/0x640
> >>> [  293.093529]  ? cp_new_stat+0x47a/0x590
> >>> [  293.099190]  ? cp_old_stat+0x470/0x470
> >>> [  293.104795]  new_sync_read+0x2e4/0x520
> >>> [  293.110362]  ? __x64_sys_lseek+0x1d0/0x1d0
> >>> [  293.116269]  ? lock_acquire+0x1b2/0x4d0
> >>> [  293.121928]  ? find_held_lock+0x2c/0x110
> >>> [  293.127648]  vfs_read+0x312/0x430
> >>> [  293.132755]  ksys_read+0xf3/0x1d0
> >>> [  293.137863]  ? __x64_sys_pwrite64+0x1f0/0x1f0
> >>> [  293.144032]  do_syscall_64+0x35/0x80
> >>> [  293.149391]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>>
> >>> The crash is at: drivers/md/dm-zone.c:499, which is
> >>> dm_need_zone_wp_tracking() called from dm_zone_map_bio(). The orig_bio
> >>> pointer is invalid. Weird. Investigating.
> >>>
> >>> Also checking why our weekly test runs did not catch this.
> >>
> >> This fixes the issue:
> >>
> >> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> >> index 3c5fad7c4ee6..3dd6735450c5 100644
> >> --- a/drivers/md/dm.c
> >> +++ b/drivers/md/dm.c
> >> @@ -581,7 +581,7 @@ static struct dm_io *alloc_io(struct mapped_device
> >> *md, struct bio *bio)
> >>         io->status = 0;
> >>         atomic_set(&io->io_count, 1);
> >>         this_cpu_inc(*md->pending_io);
> >> -       io->orig_bio = NULL;
> >> +       io->orig_bio = bio;
> >>         io->md = md;
> >>         io->map_task = current;
> >>         spin_lock_init(&io->lock);
> >>
> >> Otherwise, the dm-zone.c code sees a NULL orig_bio.
> >> However, this change may be messing up the bio accounting. Need to check that.
> > 
> > Looks it is one recent regression since:
> > 
> > commit 0fbb4d93b38b ("dm: add dm_submit_bio_remap interface")
> 
> Yep, saw that. Problem is, I really do not understand that change setting
> io->orig_bio *after* __map_bio() is called. It seems that the accounting
> is done on each fragment of the orig_bio instead of once for the entire
> BIO... So my "fix" above seems wrong. Apart from passing along orig_bio as
> an argument to  __map_bio() from __split_and_process_bio(), I do not think
> my change is correct. Thoughts ?

Frankly speaking, both changing ->orig_bio after split and setting ->orig_bio
after ->map() looks ugly & tricky, and the following change should avoid the
issue, meantime simplify dm accounting a bit:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3c5fad7c4ee6..f1fe83113608 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -581,7 +581,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	io->status = 0;
 	atomic_set(&io->io_count, 1);
 	this_cpu_inc(*md->pending_io);
-	io->orig_bio = NULL;
+	io->orig_bio = bio;
 	io->md = md;
 	io->map_task = current;
 	spin_lock_init(&io->lock);
@@ -1223,19 +1223,11 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
 	 * Account io->origin_bio to DM dev on behalf of target
 	 * that took ownership of IO with DM_MAPIO_SUBMITTED.
 	 */
-	if (io->map_task == current) {
+	if (io->map_task == current)
 		/* Still in target's map function */
 		dm_io_set_flag(io, DM_IO_START_ACCT);
-	} else {
-		/*
-		 * Called by another thread, managed by DM target,
-		 * wait for dm_split_and_process_bio() to store
-		 * io->orig_bio
-		 */
-		while (unlikely(!smp_load_acquire(&io->orig_bio)))
-			msleep(1);
+	else
 		dm_start_io_acct(io, clone);
-	}
 
 	__dm_submit_bio_remap(tgt_clone, disk_devt(io->md->disk),
 			      tio->old_sector);
@@ -1562,7 +1554,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 				     struct dm_table *map, struct bio *bio)
 {
 	struct clone_info ci;
-	struct bio *orig_bio = NULL;
+	struct bio *new_bio = NULL;
 	int error = 0;
 
 	init_clone_info(&ci, md, map, bio);
@@ -1578,22 +1570,14 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	if (error || !ci.sector_count)
 		goto out;
 
-	/*
-	 * Remainder must be passed to submit_bio_noacct() so it gets handled
-	 * *after* bios already submitted have been completely processed.
-	 * We take a clone of the original to store in ci.io->orig_bio to be
-	 * used by dm_end_io_acct() and for dm_io_complete() to use for
-	 * completion handling.
-	 */
-	orig_bio = bio_split(bio, bio_sectors(bio) - ci.sector_count,
-			     GFP_NOIO, &md->queue->bio_split);
-	bio_chain(orig_bio, bio);
-	trace_block_split(orig_bio, bio->bi_iter.bi_sector);
-	submit_bio_noacct(bio);
+	new_bio = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
+			&md->queue->bio_split);
+	bio_trim(new_bio, bio_sectors(bio) - ci.sector_count, ci.sector_count);
+	bio_trim(bio, 0, bio_sectors(bio) - ci.sector_count);
+	bio_chain(new_bio, bio);
+	trace_block_split(new_bio, new_bio->bi_iter.bi_sector);
+	submit_bio_noacct(new_bio);
 out:
-	if (!orig_bio)
-		orig_bio = bio;
-	smp_store_release(&ci.io->orig_bio, orig_bio);
 	if (dm_io_flagged(ci.io, DM_IO_START_ACCT))
 		dm_start_io_acct(ci.io, NULL);
 

-- 
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

