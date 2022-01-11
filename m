Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD5CC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 11 Jan 2022 08:42:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-tWZUn4iJPISRKAKYHOvZcA-1; Tue, 11 Jan 2022 03:42:49 -0500
X-MC-Unique: tWZUn4iJPISRKAKYHOvZcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B019805744;
	Tue, 11 Jan 2022 08:42:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 770BD10589D4;
	Tue, 11 Jan 2022 08:42:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DC44F4BB7C;
	Tue, 11 Jan 2022 08:42:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20B8gfLZ026888 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 11 Jan 2022 03:42:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BBA411121315; Tue, 11 Jan 2022 08:42:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B73DE1121321
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 08:42:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC315811E76
	for <dm-devel@redhat.com>; Tue, 11 Jan 2022 08:42:38 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-271-2phYRrrhNrulEgsxpjWbHQ-1; Tue, 11 Jan 2022 03:42:37 -0500
X-MC-Unique: 2phYRrrhNrulEgsxpjWbHQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1n7CjZ-00FO7F-Gg; Tue, 11 Jan 2022 08:42:25 +0000
Date: Tue, 11 Jan 2022 00:42:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <Yd1C8Y6H7ZDhWY2k@infradead.org>
References: <20220110075141.389532-1-ming.lei@redhat.com>
	<20220110075141.389532-2-ming.lei@redhat.com>
	<YdxuWlZAPJkPyr3h@infradead.org> <Ydzj1JSoRGz+9g8B@T590>
MIME-Version: 1.0
In-Reply-To: <Ydzj1JSoRGz+9g8B@T590>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	lining <lining2020x@163.com>, Tejun Heo <tj@kernel.org>,
	Chunguang Xu <brookxu@tencent.com>
Subject: Re: [dm-devel] [PATCH 1/2] block: add resubmit_bio_noacct()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 11, 2022 at 09:56:36AM +0800, Ming Lei wrote:
> 2) block throttle is block layer internal stuff, and we shouldn't expose
> blk_throtl_charge_bio_split() to driver.
> 
> Maybe rename the new API as submit_split_bio_noacct(), but we can't
> reuse submit_bio_noacct() simply, otherwise blk_throtl_charge_bio_split()
> needs to be exported.

submit_bio_noacct should only ever be used for resubmitting bios that
came up from the upper layer, although they might not always be "split".
blk_throtl_charge_bio_split

> Another ides is to clearing BIO_THROTTLED before calling submit_bio_noacct(),
> meantime blk-throttle code needs to change to avoid double accounting of bio
> bytes, so the caller of submit_bio_noacct() still needs some change.
> This way can get smooth IOPS throttle, but needs to call __blk_throtl_bio
> for split bio one more time.
> 
> Or other idea for this bio split vs. iops limit issue?

Well, if you want a helper specificly for splits, add one that actally
specifically handles splits and makes the callers life easier, something
like:

void bio_submit_splice(struct bio *split, struct bio *orig)
{
	split->bi_opf |= REQ_NOMERGE;
	trace_block_split(split, orig->bi_iter.bi_sector);
	submit_bio_noacct(orig);
	blk_throtl_charge_bio_split(orig);
}

including a proper kerneldoc comment.

But I still fail to grasp how a split is so different from just
resubmitting a not split bio.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

