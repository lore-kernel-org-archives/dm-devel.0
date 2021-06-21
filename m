Return-Path: <SRS0=G5ov=LP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD97C49361
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 07:40:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5A06560FEE
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 07:40:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A06560FEE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-13RK5XDTNFCPfUyTTk81_w-1; Mon, 21 Jun 2021 03:40:55 -0400
X-MC-Unique: 13RK5XDTNFCPfUyTTk81_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E008C804146;
	Mon, 21 Jun 2021 07:40:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B7D2F2C016;
	Mon, 21 Jun 2021 07:40:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 52DB01809C99;
	Mon, 21 Jun 2021 07:40:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15L7elUd017650 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Jun 2021 03:40:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B3CE0216029D; Mon, 21 Jun 2021 07:40:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ABA9C21602A1
	for <dm-devel@redhat.com>; Mon, 21 Jun 2021 07:40:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDAC8180F6E0
	for <dm-devel@redhat.com>; Mon, 21 Jun 2021 07:40:44 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-415-5vvw_7SGNaG9WNjuiebswg-1;
	Mon, 21 Jun 2021 03:37:00 -0400
X-MC-Unique: 5vvw_7SGNaG9WNjuiebswg-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 295EE68BEB; Mon, 21 Jun 2021 09:36:57 +0200 (CEST)
Date: Mon, 21 Jun 2021 09:36:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20210621073656.GB6896@lst.de>
References: <20210617103549.930311-1-ming.lei@redhat.com>
	<20210617103549.930311-4-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210617103549.930311-4-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 3/3] dm: support bio polling
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

On Thu, Jun 17, 2021 at 06:35:49PM +0800, Ming Lei wrote:
> +	/*
> +	 * Only support bio polling for normal IO, and the target io is
> +	 * exactly inside the dm io instance
> +	 */
> +	ci->io->submit_as_polled = !!(ci->bio->bi_opf & REQ_POLLED);

Nit: the !! is not needed.

> @@ -1608,6 +1625,22 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
>  	ci->map = map;
>  	ci->io = alloc_io(md, bio);
>  	ci->sector = bio->bi_iter.bi_sector;
> +
> +	if (bio->bi_opf & REQ_POLLED) {
> +		INIT_HLIST_NODE(&ci->io->node);
> +
> +		/*
> +		 * Save .bi_end_io into dm_io, so that we can reuse .bi_end_io
> +		 * for storing dm_io list
> +		 */
> +		if (bio->bi_opf & REQ_SAVED_END_IO) {
> +			ci->io->saved_bio_end_io = NULL;

So if it already was saved the list gets cleared here?  Can you explain
this logic a little more?

> +		} else {
> +			ci->io->saved_bio_end_io = bio->bi_end_io;
> +			INIT_HLIST_HEAD((struct hlist_head *)&bio->bi_end_io);

I think you want to hide these casts in helpers that clearly document
why this is safe rather than sprinkling the casts all over the code.
I also wonder if there is any better way to structur this.

> +static int dm_poll_bio(struct bio *bio, unsigned int flags)
> +{
> +	struct dm_io *io;
> +	void *saved_bi_end_io = NULL;
> +	struct hlist_head tmp = HLIST_HEAD_INIT;
> +	struct hlist_head *head = (struct hlist_head *)&bio->bi_end_io;
> +	struct hlist_node *next;
> +
> +	/*
> +	 * This bio can be submitted from FS as POLLED so that FS may keep
> +	 * polling even though the flag is cleared by bio splitting or
> +	 * requeue, so return immediately.
> +	 */
> +	if (!(bio->bi_opf & REQ_POLLED))
> +		return 0;

I can't really parse the comment, can you explain this a little more?
But if we need this check, shouldn't it move to bio_poll()?

> +	hlist_for_each_entry(io, &tmp, node) {
> +		if (io->saved_bio_end_io && !saved_bi_end_io) {
> +			saved_bi_end_io = io->saved_bio_end_io;
> +			break;
> +		}
> +	}

So it seems like you don't use bi_cookie at all.  Why not turn
bi_cookie into a union to stash the hlist_head and use that?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

