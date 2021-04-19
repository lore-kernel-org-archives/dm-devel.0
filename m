Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC5DC433ED
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:40:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 15249611CE
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15249611CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618839600;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=P6ZuqSY1Ll1Dg+ISnEBT6YqEBSaig0vghBHmB40Qbc8=;
	b=QZ899zjkyvAPX2k4M6vatslWMSklf4U4A5HWhuHhEgden2x4XeTF9OyzzEZIP3HVVScATJ
	Yb40Vq/LZxvafqWsjLUtFvdSbzM5o8Ji5t/pADVptCPr3mVOgG4MXeTF4pcHh7kgKm5rdc
	xHeyR5R0RqOxJp0rBVvEutp1parYCio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-3GG_Y0CtPa6TGhWk-e5MUw-1; Mon, 19 Apr 2021 09:39:58 -0400
X-MC-Unique: 3GG_Y0CtPa6TGhWk-e5MUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D63A0817469;
	Mon, 19 Apr 2021 13:39:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C71219809;
	Mon, 19 Apr 2021 13:39:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ED8691806D17;
	Mon, 19 Apr 2021 13:39:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13JDah9P028274 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Apr 2021 09:36:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 277B8610F3; Mon, 19 Apr 2021 13:36:43 +0000 (UTC)
Received: from T590 (ovpn-12-222.pek2.redhat.com [10.72.12.222])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA29060C04;
	Mon, 19 Apr 2021 13:36:21 +0000 (UTC)
Date: Mon, 19 Apr 2021 21:36:18 +0800
From: Ming Lei <ming.lei@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <YH2HUs8FV0pNDluk@T590>
References: <20210401021927.343727-12-ming.lei@redhat.com>
	<20210416080037.26335-1-jefflexu@linux.alibaba.com>
	<YHlTtVtTEBpxa8Gh@T590>
	<1fb6e15e-fb4d-a2bf-9f65-2ae2aa15a8a2@linux.alibaba.com>
	<YHzpJsOYJL/AGC7k@T590>
	<c0085cb4-2396-b0c2-c880-c6fa8fb7e491@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <c0085cb4-2396-b0c2-c880-c6fa8fb7e491@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
	snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH] block: introduce QUEUE_FLAG_POLL_CAP flag
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 19, 2021 at 01:40:21PM +0800, JeffleXu wrote:
> 
> 
> On 4/19/21 10:21 AM, Ming Lei wrote:
> > On Sat, Apr 17, 2021 at 10:06:53PM +0800, JeffleXu wrote:
> >>
> >>
> >> On 4/16/21 5:07 PM, Ming Lei wrote:
> >>> On Fri, Apr 16, 2021 at 04:00:37PM +0800, Jeffle Xu wrote:
> >>>> Hi,
> >>>> How about this patch to remove the extra poll_capable() method?
> >>>>
> >>>> And the following 'dm: support IO polling for bio-based dm device' needs
> >>>> following change.
> >>>>
> >>>> ```
> >>>> +       /*
> >>>> +        * Check for request-based device is remained to
> >>>> +        * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
> >>>> +        * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
> >>>> +        * devices supporting polling.
> >>>> +        */
> >>>> +       if (__table_type_bio_based(t->type)) {
> >>>> +               if (dm_table_supports_poll(t)) {
> >>>> +                       blk_queue_flag_set(QUEUE_FLAG_POLL_CAP, q);
> >>>> +                       blk_queue_flag_set(QUEUE_FLAG_POLL, q);
> >>>> +               }
> >>>> +               else {
> >>>> +                       blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
> >>>> +                       blk_queue_flag_clear(QUEUE_FLAG_POLL_CAP, q);
> >>>> +               }
> >>>> +       }
> >>>> ```
> >>>
> >>> Frankly speaking, I don't see any value of using QUEUE_FLAG_POLL_CAP for
> >>> DM, and the result is basically subset of treating DM as always being capable
> >>> of polling.
> >>>
> >>> Also underlying queue change(either limits or flag) won't be propagated
> >>> to DM/MD automatically. Strictly speaking it doesn't matter if all underlying
> >>> queues are capable of supporting polling at the exact time of 'write sysfs/poll',
> >>> cause any of them may change in future.
> >>>
> >>> So why not start with the simplest approach(always capable of polling)
> >>> which does meet normal bio based polling requirement?
> >>>
> >>
> >> I find one scenario where this issue may matter. Consider the scenario
> >> where HIPRI bios are submitted to DM device though **all** underlying
> >> devices has been disabled for polling. In this case, a **valid** cookie
> >> (pid of current submitting process) is still returned. Then if @spin of
> >> the following blk_poll() is true, blk_poll() will get stuck in dead loop
> >> because blk_mq_poll() always returns 0, since previously submitted bios
> >> are all enqueued into IRQ hw queue.
> >>
> >> Maybe you need to re-remove the bio from the poll context if the
> >> returned cookie is BLK_QC_T_NONE?
> > 
> > It won't be one issue, see blk_bio_poll_preprocess() which is called
> > from submit_bio_checks(), so any bio's HIPRI will be cleared if the
> > queue doesn't support POLL, that code does cover underlying bios.
> 
> Sorry there may be some confusion in my description. Let's discuss in
> the following scenario: MD/DM advertise QUEUE_FLAG_POLL, though **all**
> underlying devices are without QUEUE_FLAG_POLL. This scenario is
> possible, if you want to enable MD/DM's polling without checking the
> capability of underlying devices.
> 
> In this case, it seems that REQ_HIPRI is kept for both MD/DM and
> underlying blk-mq devices. I used to think that REQ_HIPRI will be
> cleared for underlying blk-mq deivces, but now it seems that REQ_HIPRI
> of bios submitted to underlying blk-mq deivces won't be cleared, since
> submit_bio_checks() is only called in the entry of submit_bio(), not in
> the while() loop of __submit_bio_noacct_ctx(). Though these underlying
> blk-mq devices don't support IO polling at all, or they all have been
> disabled for polling, REQ_HIPRI bios are finally submitted down.
> 
> Or do I miss something?

No matter the loop, the bios are actually submitted to the
current->bio_list via submit_bio_noacct() or submit_bio().
'grep -r submit_bio drivers/md' will show you the point.

Also it is a bug if one underlying bio is submitted without being checked.

You can observe it by the following bpftrace when you run io_uring on dm
disk:

#include <linux/blkdev.h>

kprobe:blk_mq_submit_bio
/strncmp(((struct bio *)arg0)->bi_bdev->bd_disk->disk_name, "nvme", 4) == 0/
{
	$b = (struct bio *)arg0;
	$hipri = $b->bi_opf & (1 << __REQ_HIPRI);

	printf("%s %d: %s %lu %lu high prio %d\n", comm, tid, $b->bi_bdev->bd_disk->disk_name,
		$b->bi_iter.bi_sector, $b->bi_iter.bi_size, $hipri);
}


> 
> 
> > 
> >>
> >>
> >> Something like:
> >>
> >> -static blk_qc_t __submit_bio_noacct(struct bio *bio)
> >> +static blk_qc_t __submit_bio_noacct_ctx(struct bio *bio, struct
> >> io_context *ioc)
> >>  {
> >>  	struct bio_list bio_list_on_stack[2];
> >>  	blk_qc_t ret = BLK_QC_T_NONE;
> >> @@ -1047,7 +1163,15 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
> >>  		bio_list_on_stack[1] = bio_list_on_stack[0];
> >>  		bio_list_init(&bio_list_on_stack[0]);
> >>
> >> 		if (ioc && queue_is_mq(q) && (bio->bi_opf & REQ_HIPRI)) {
> > 
> > REQ_HIPRI won't be set for underlying bios which queue doesn't support
> > poll, so this branch won't be reached. 
> 
> Sorry I missed the '(bio->bi_opf & REQ_HIPRI)' condition here. Indeed
> bio without REQ_HIPRI won't be enqueued into the poll_context.

Even though these bios are queued, blk_poll() still can handle them
easily by just ignoring queues which aren't POLL_TYPE. However, I still
think their HIPRI will be cleared.

Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

