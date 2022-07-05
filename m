Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04379C43334
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656988266;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fPBVHJufZyQM9YrovNYn0A7P/CQwPXaLAXQAeWjSpfY=;
	b=KXXtp9kZilJuPRpFi1We+ieIDq+1ncVpcgj9/JYNAjNegBgml5G/aRnCsJjXLky2guehHs
	7616kLouC56D6nnktU2lMaIk70EvIKuo0hLnj8tUyOoiQA+a098vgV+xjAjddbKiYrCmbq
	FjSMe/B+/BPeTnRgSXPsXbsFkIEea7Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-fw-vyk-zPka7dCX4r_4vnw-1; Mon, 04 Jul 2022 22:31:04 -0400
X-MC-Unique: fw-vyk-zPka7dCX4r_4vnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65870833975;
	Tue,  5 Jul 2022 02:31:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 529151415130;
	Tue,  5 Jul 2022 02:31:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1CA94194704A;
	Tue,  5 Jul 2022 02:31:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1FFCB1947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:31:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CCB27141510F; Tue,  5 Jul 2022 02:31:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C87121410F3C
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:31:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A86951C068C8
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:31:01 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-85hWKF_3O0udF_AoaVcpxg-1; Mon, 04 Jul 2022 22:30:59 -0400
X-MC-Unique: 85hWKF_3O0udF_AoaVcpxg-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="209699350"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:30:58 +0800
IronPort-SDR: 5j34ZNWjWB79UHH4yrNarfZoWvN9ylDWUnObaSB/DsE56hvUWu/Ub0YWrQaq2mYMpYydRtVyNG
 5KpxOs50g8f4nQz++6LqfrfbjxILrRZUqdZhO6adIUyFM3465Usu3ZBJOVFDKmq9crtjYTBv07
 5+OhKVxZ1f9PyQG1ahDBy2NisH/23/WZA4ES34PP+qjjUstsRa6n9ejxLzwWWfAzi9woXKxU1G
 HwAgEDMe+2XeHXhgVtOpC9ql+GqQtoZNDtToQ+xVI76AgBBOzeta1L5tiabFVuZ0OcsUoZD/y3
 sTW8IPzdVMCMf4KLovNfQPfm
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 18:48:17 -0700
IronPort-SDR: SPXUt/aNysfrtFGSRdoe2Qv4CUlow/WOjN8QjZddqzCUXim/XzdFey84hRkdtVU6VDuBg3k2Lj
 ghm0SQlg0qWCqTRhBfk28dnG4+2P/teqDQFbxl1SIim3bKg5qfQLDKhIfWcZ/7ER5HMq6l2MbK
 LEtHv3mNJv7wgwNlofEKcctDA9kvQbQ8w/DeF54qog/98gSCleDR/Y0vF7Iex8eGqXD+TjFex4
 tpPC44d4AOQnwgX5wxhERFjZyPb+eMrV3h6ABKr9LHMEXh1IsV2V/SMRC7dpQHbiWS0ICJPZBA
 3V4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:30:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRVp2Cvqz1Rwnl
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:30:58 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id btTRL3xvRxQ0 for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:30:57 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRVm5SzGz1RtVk;
 Mon,  4 Jul 2022 19:30:56 -0700 (PDT)
Message-ID: <36284d54-bb3d-d77b-cc30-1759e897478b@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:30:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-5-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-5-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 04/17] block: simplify blk_mq_plug
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/22 21:44, Christoph Hellwig wrote:
> Drop the unused q argument, and invert the check to move the exception
> into a branch and the regular path as the normal return.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c  |  2 +-
>  block/blk-merge.c |  2 +-
>  block/blk-mq.c    |  2 +-
>  block/blk-mq.h    | 18 ++++++++----------
>  4 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 6bcca0b686de4..bc16e9bae2dc4 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -719,7 +719,7 @@ void submit_bio_noacct(struct bio *bio)
>  
>  	might_sleep();
>  
> -	plug = blk_mq_plug(q, bio);
> +	plug = blk_mq_plug(bio);
>  	if (plug && plug->nowait)
>  		bio->bi_opf |= REQ_NOWAIT;
>  
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 0f5f42ebd0bb0..5abf5aa5a5f0e 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -1051,7 +1051,7 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
>  	struct blk_plug *plug;
>  	struct request *rq;
>  
> -	plug = blk_mq_plug(q, bio);
> +	plug = blk_mq_plug(bio);
>  	if (!plug || rq_list_empty(plug->mq_list))
>  		return false;
>  
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 15c7c5c4ad222..dc714dff73001 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2804,7 +2804,7 @@ static void bio_set_ioprio(struct bio *bio)
>  void blk_mq_submit_bio(struct bio *bio)
>  {
>  	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> -	struct blk_plug *plug = blk_mq_plug(q, bio);
> +	struct blk_plug *plug = blk_mq_plug(bio);
>  	const int is_sync = op_is_sync(bio->bi_opf);
>  	struct request *rq;
>  	unsigned int nr_segs = 1;
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index 31d75a83a562d..1cc0b17d69229 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -294,7 +294,6 @@ static inline void blk_mq_clear_mq_map(struct blk_mq_queue_map *qmap)
>  
>  /*
>   * blk_mq_plug() - Get caller context plug
> - * @q: request queue
>   * @bio : the bio being submitted by the caller context
>   *
>   * Plugging, by design, may delay the insertion of BIOs into the elevator in
> @@ -305,23 +304,22 @@ static inline void blk_mq_clear_mq_map(struct blk_mq_queue_map *qmap)
>   * order. While this is not a problem with regular block devices, this ordering
>   * change can cause write BIO failures with zoned block devices as these
>   * require sequential write patterns to zones. Prevent this from happening by
> - * ignoring the plug state of a BIO issuing context if the target request queue
> - * is for a zoned block device and the BIO to plug is a write operation.
> + * ignoring the plug state of a BIO issuing context if is for a zoned block

s/if is/if it is/

> + 8 device and the BIO to plug is a write operation.

s/8/*

>   *
>   * Return current->plug if the bio can be plugged and NULL otherwise
>   */
> -static inline struct blk_plug *blk_mq_plug(struct request_queue *q,
> -					   struct bio *bio)
> +static inline struct blk_plug *blk_mq_plug( struct bio *bio)
>  {
> +	/* Zoned block device write operation case: do not plug the BIO */
> +	if (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio)))
> +		return NULL;
> +
>  	/*
>  	 * For regular block devices or read operations, use the context plug
>  	 * which may be NULL if blk_start_plug() was not executed.
>  	 */
> -	if (!bdev_is_zoned(bio->bi_bdev) || !op_is_write(bio_op(bio)))
> -		return current->plug;
> -
> -	/* Zoned block device write operation case: do not plug the BIO */
> -	return NULL;
> +	return current->plug;
>  }
>  
>  /* Free all requests on the list */

With the typos fixed, looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

