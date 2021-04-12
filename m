Return-Path: <SRS0=eE7R=JJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCE5C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 09:55:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 107C86120B
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 09:55:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 107C86120B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-qOuLvI0OObSY4z5ztKWFUA-1; Mon, 12 Apr 2021 05:55:10 -0400
X-MC-Unique: qOuLvI0OObSY4z5ztKWFUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55BDA800D53;
	Mon, 12 Apr 2021 09:55:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C08175D9DE;
	Mon, 12 Apr 2021 09:55:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B8A91806D0E;
	Mon, 12 Apr 2021 09:54:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13C9spq5028520 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Apr 2021 05:54:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 852E81112879; Mon, 12 Apr 2021 09:54:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 804881112877
	for <dm-devel@redhat.com>; Mon, 12 Apr 2021 09:54:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3F4A800140
	for <dm-devel@redhat.com>; Mon, 12 Apr 2021 09:54:48 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-187-4znEJnM3MWm-6GqmSgdc0A-1; Mon, 12 Apr 2021 05:54:47 -0400
X-MC-Unique: 4znEJnM3MWm-6GqmSgdc0A-1
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1lVtH1-0049Ay-34; Mon, 12 Apr 2021 09:54:36 +0000
Date: Mon, 12 Apr 2021 10:54:27 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20210412095427.GA987123@infradead.org>
References: <20210401021927.343727-1-ming.lei@redhat.com>
	<20210401021927.343727-9-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210401021927.343727-9-ming.lei@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: Re: [dm-devel] [PATCH V5 08/12] block: use per-task poll context to
 implement bio based io polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Apr 01, 2021 at 10:19:23AM +0800, Ming Lei wrote:
> Currently bio based IO polling needs to poll all hw queue blindly, this
> way is very inefficient, and one big reason is that we can't pass any
> bio submission result to blk_poll().
> 
> In IO submission context, track associated underlying bios by per-task
> submission queue and store returned 'cookie' in
> bio->bi_iter.bi_private_data, and return current->pid to caller of
> submit_bio() for any bio based driver's IO, which is submitted from FS.
> 
> In IO poll context, the passed cookie tells us the PID of submission
> context, then we can find bios from the per-task io pull context of
> submission context. Moving bios from submission queue to poll queue of
> the poll context, and keep polling until these bios are ended. Remove
> bio from poll queue if the bio is ended. Add bio flags of BIO_DONE and
> BIO_END_BY_POLL for such purpose.
> 
> In was found in Jeffle Xu's test that kfifo doesn't scale well for a
> submission queue as queue depth is increased, so a new mechanism for
> tracking bios is needed. So far bio's size is close to 2 cacheline size,
> and it may not be accepted to add new field into bio for solving the
> scalability issue by tracking bios via linked list, switch to bio group
> list for tracking bio, the idea is to reuse .bi_end_io for linking bios
> into a linked list for all sharing same .bi_end_io(call it bio group),
> which is recovered before ending bio really, since BIO_END_BY_POLL is
> added for enhancing this point. Usually .bi_end_bio is same for all
> bios in same layer, so it is enough to provide very limited groups, such
> as 16 or less for fixing the scalability issue.
> 
> Usually submission shares context with io poll. The per-task poll context
> is just like stack variable, and it is cheap to move data between the two
> per-task queues.
> 
> Also when the submission task is exiting, drain pending IOs in the context
> until all are done.
> 
> Tested-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Reviewed-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/bio.c               |   5 +
>  block/blk-core.c          | 155 +++++++++++++++++++++++-
>  block/blk-ioc.c           |   3 +
>  block/blk-mq.c            | 244 +++++++++++++++++++++++++++++++++++++-
>  block/blk.h               |  10 ++
>  include/linux/blk_types.h |  26 +++-
>  6 files changed, 439 insertions(+), 4 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 26b7f721cda8..04c043dc60fc 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1402,6 +1402,11 @@ static inline bool bio_remaining_done(struct bio *bio)
>   **/
>  void bio_endio(struct bio *bio)
>  {
> +	/* BIO_END_BY_POLL has to be set before calling submit_bio */
> +	if (bio_flagged(bio, BIO_END_BY_POLL)) {
> +		bio_set_flag(bio, BIO_DONE);
> +		return;
> +	}

Why can't driver that implements bio based polling call a separate
bio_endio_polled instead?

> +static inline void *bio_grp_data(struct bio *bio)
> +{
> +	return bio->bi_poll;
> +}

What is the purpose of this helper?  And why does it have to lose the
type information?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

