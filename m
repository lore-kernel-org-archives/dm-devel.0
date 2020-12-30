Return-Path: <SRS0=/4vF=GC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37572C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 00:10:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 896A621D94
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 00:10:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 896A621D94
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=stoffel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-hBiLzytxOwWbGlhE_I5Bnw-1; Tue, 29 Dec 2020 19:10:14 -0500
X-MC-Unique: hBiLzytxOwWbGlhE_I5Bnw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68E3E80400C;
	Wed, 30 Dec 2020 00:10:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BEA865D9C2;
	Wed, 30 Dec 2020 00:10:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 60FF6180954D;
	Wed, 30 Dec 2020 00:10:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BU09KCC028684 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Dec 2020 19:09:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 216D010031FF; Wed, 30 Dec 2020 00:09:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C82510031FE
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 00:09:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85A68800BFF
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 00:09:14 +0000 (UTC)
Received: from mail.stoffel.org (li1843-175.members.linode.com
	[172.104.24.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-522-ly_F8YmSMOysz00qNp8GLA-1; Tue, 29 Dec 2020 19:09:10 -0500
X-MC-Unique: ly_F8YmSMOysz00qNp8GLA-1
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com
	[68.116.170.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest
	SHA256) (No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 441621E135;
	Tue, 29 Dec 2020 19:00:24 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 78668A6AC5; Tue, 29 Dec 2020 19:00:23 -0500 (EST)
MIME-Version: 1.0
Message-ID: <24555.49943.411197.147225@quad.stoffel.home>
Date: Tue, 29 Dec 2020 19:00:23 -0500
From: "John Stoffel" <john@stoffel.org>
To: dannyshih <dannyshih@synology.com>
In-Reply-To: <1609233522-25837-2-git-send-email-dannyshih@synology.com>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
	<1609233522-25837-2-git-send-email-dannyshih@synology.com>
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
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, snitzer@redhat.com,
	linux-block@vger.kernel.org, song@kernel.org,
	dm-devel@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 1/4] block: introduce
	submit_bio_noacct_add_head
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>>>>> "dannyshih" == dannyshih  <dannyshih@synology.com> writes:

dannyshih> From: Danny Shih <dannyshih@synology.com>
dannyshih> Porvide a way for stacking block device to re-submit the bio
dannyshih> which sholud be handled firstly.

You're spelling needs to be fixed in these messages.  

dannyshih> Signed-off-by: Danny Shih <dannyshih@synology.com>
dannyshih> Reviewed-by: Allen Peng <allenpeng@synology.com>
dannyshih> Reviewed-by: Alex Wu <alexwu@synology.com>
dannyshih> ---
dannyshih>  block/blk-core.c       | 44 +++++++++++++++++++++++++++++++++-----------
dannyshih>  include/linux/blkdev.h |  1 +
dannyshih>  2 files changed, 34 insertions(+), 11 deletions(-)

dannyshih> diff --git a/block/blk-core.c b/block/blk-core.c
dannyshih> index 96e5fcd..693dc83 100644
dannyshih> --- a/block/blk-core.c
dannyshih> +++ b/block/blk-core.c
dannyshih> @@ -1031,16 +1031,7 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
dannyshih>  	return ret;
dannyshih>  }
 
dannyshih> -/**
dannyshih> - * submit_bio_noacct - re-submit a bio to the block device layer for I/O
dannyshih> - * @bio:  The bio describing the location in memory and on the device.
dannyshih> - *
dannyshih> - * This is a version of submit_bio() that shall only be used for I/O that is
dannyshih> - * resubmitted to lower level drivers by stacking block drivers.  All file
dannyshih> - * systems and other upper level users of the block layer should use
dannyshih> - * submit_bio() instead.
dannyshih> - */
dannyshih> -blk_qc_t submit_bio_noacct(struct bio *bio)
dannyshih> +static blk_qc_t do_submit_bio_noacct(struct bio *bio, bool add_head)
dannyshih>  {
dannyshih>  	if (!submit_bio_checks(bio))
dannyshih>  		return BLK_QC_T_NONE;
dannyshih> @@ -1052,7 +1043,10 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
dannyshih>  	 * it is active, and then process them after it returned.
dannyshih>  	 */
dannyshih>  	if (current->bio_list) {
dannyshih> -		bio_list_add(&current->bio_list[0], bio);
dannyshih> +		if (add_head)
dannyshih> +			bio_list_add_head(&current->bio_list[0], bio);
dannyshih> +		else
dannyshih> +			bio_list_add(&current->bio_list[0], bio);
dannyshih>  		return BLK_QC_T_NONE;
dannyshih>  	}
 
dannyshih> @@ -1060,9 +1054,37 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
dannyshih>  		return __submit_bio_noacct_mq(bio);
dannyshih>  	return __submit_bio_noacct(bio);
dannyshih>  }
dannyshih> +
dannyshih> +/**
dannyshih> + * submit_bio_noacct - re-submit a bio to the block device layer for I/O
dannyshih> + * @bio:  The bio describing the location in memory and on the device.
dannyshih> + *
dannyshih> + * This is a version of submit_bio() that shall only be used for I/O that is
dannyshih> + * resubmitted to lower level drivers by stacking block drivers.  All file
dannyshih> + * systems and other upper level users of the block layer should use
dannyshih> + * submit_bio() instead.
dannyshih> + */
dannyshih> +blk_qc_t submit_bio_noacct(struct bio *bio)
dannyshih> +{
dannyshih> +	return do_submit_bio_noacct(bio, false);
dannyshih> +}
dannyshih>  EXPORT_SYMBOL(submit_bio_noacct);

So why is it named "submit_bio_noacct" when it's supposed to be only
used by layers submitting to lower level drivers.  How can this be
figured out by drivers automatically, so the writed doesn't have to
know about this?  
 
dannyshih>  /**
dannyshih> + * submit_bio_noacct - re-submit a bio, which needs to be handle firstly,
dannyshih> + *                     to the block device layer for I/O
dannyshih> + * @bio:  The bio describing the location in memory and on the device.
dannyshih> + *
dannyshih> + * alternative submit_bio_noacct() which add bio to the head of
dannyshih> + * current->bio_list.
dannyshih> + */

Firstly isn't proper english.  Maybe something like:

submit_bio_noacct - re-submit a bio which needs to be handled first
because <reasons> to the block device layer for I/O

But the name still sucks, and the *reason* the bio needs to be handled
differently isn't well explained. 

dannyshih> +blk_qc_t submit_bio_noacct_add_head(struct bio *bio)
dannyshih> +{
dannyshih> +	return do_submit_bio_noacct(bio, true);
dannyshih> +}
dannyshih> +EXPORT_SYMBOL(submit_bio_noacct_add_head);
dannyshih> +
dannyshih> +/**
dannyshih>   * submit_bio - submit a bio to the block device layer for I/O
dannyshih>   * @bio: The &struct bio which describes the I/O
dannyshih>   *
dannyshih> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
dannyshih> index 070de09..b0080d0 100644
dannyshih> --- a/include/linux/blkdev.h
dannyshih> +++ b/include/linux/blkdev.h
dannyshih> @@ -905,6 +905,7 @@ static inline void rq_flush_dcache_pages(struct request *rq)
dannyshih>  extern int blk_register_queue(struct gendisk *disk);
dannyshih>  extern void blk_unregister_queue(struct gendisk *disk);
dannyshih>  blk_qc_t submit_bio_noacct(struct bio *bio);
dannyshih> +blk_qc_t submit_bio_noacct_add_head(struct bio *bio);
dannyshih>  extern void blk_rq_init(struct request_queue *q, struct request *rq);
dannyshih>  extern void blk_put_request(struct request *);
dannyshih>  extern struct request *blk_get_request(struct request_queue *, unsigned int op,
dannyshih> -- 
dannyshih> 2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

