Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D4FFC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657108816;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Xd8z/eIW+7ThnuMyQ0j+03qw2HOOo1hOfEOuLKNBB+o=;
	b=XBnh1ThwWsph8wvIK8SIq2xZVFiRVikUkcdS/TKV46tRLbcaXy+r0bY1vcmdUea2OM6vLy
	bX23KGCikOttCbdT6t1d7zsNNEFYGS2C+fwAmu8sv45uovoYGdggmpvbY5Ju70chbnYe40
	ezonAtr+tlXeiI5WgomJ+2tDqua0st8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-xf1O2JzoPCCyqOxxvRyT_A-1; Wed, 06 Jul 2022 08:00:13 -0400
X-MC-Unique: xf1O2JzoPCCyqOxxvRyT_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AE571019C8F;
	Wed,  6 Jul 2022 12:00:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 73EDC2026D64;
	Wed,  6 Jul 2022 12:00:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3D13F1947063;
	Wed,  6 Jul 2022 12:00:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 084561947063
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 12:00:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EDF411415117; Wed,  6 Jul 2022 12:00:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E798B140EBE3
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 12:00:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFC77823F11
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 12:00:06 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-N-4WbDNGMqKdX2dUgUN4jQ-1; Wed, 06 Jul 2022 07:59:59 -0400
X-MC-Unique: N-4WbDNGMqKdX2dUgUN4jQ-1
X-IronPort-AV: E=Sophos;i="5.92,249,1650902400"; d="scan'208";a="205688368"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2022 19:59:56 +0800
IronPort-SDR: C3AjxPeG4XrvlxmvMnsqD7gghXKEeDTj0CbhPMcQN9ygiDL+8Wl3o8fN2XXK5IgO5JfYL59iQT
 xGy2oy2yhJC2Qi1wbn6Jp3MXUFxZaYP+N8vYKHlnQvjTuZmFX3m7jWkcmdt8YfwuYS2SVTgPIF
 nMdqaRJbyxSFqyOH5fuF4XIXO/Tpjj8kHuzXejej4qtxcOeMR5/RCStEVsrDKzNRKyG01Q14ih
 vr3M850w+WKNymubfXnOQ/vAOZmA3FTV5Kyf+8lZbNfsCA1wm2wJRVX3SlPMooj4T+9trzjb8w
 8CTTYUhoXK4i/RF8lOgNJ3Fj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jul 2022 04:21:44 -0700
IronPort-SDR: nTHVjEKVaYT0E2inb52DtsoN9f1d0Le9EpRL2REsTm6Y85KtnoEfBHb9BN63hIs4kb5y6up9x4
 He/7L6siN6CqCay/TO5MM+0sAH3GhaAmsIJaim6hfOp4Xs9B6QwPyfB20ojTY3syMhzB10rjzO
 4UyJdXL0yGwbIWDBUnpu0Gl0/PLUA8XVliR+O9spOGNSxNAuNEP21XqexQjhVzxZvkQ9SyoO5I
 NpXqfLU7Y4W3tHiNSsHcvEgZAsqTKcXKhPHvHP6Z2btI+AWae8SAsduC1tbWRJD3zRpgU6prka
 LDY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jul 2022 04:59:58 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LdJ4r6fh4z1Rw4L
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 04:59:56 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id mWIMyfCOzcdt for <dm-devel@redhat.com>;
 Wed,  6 Jul 2022 04:59:56 -0700 (PDT)
Received: from [10.225.163.110] (unknown [10.225.163.110])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LdJ4q5LQPz1RtVk;
 Wed,  6 Jul 2022 04:59:55 -0700 (PDT)
Message-ID: <07305397-4756-52b3-eda9-a572b5cdb3c4@opensource.wdc.com>
Date: Wed, 6 Jul 2022 20:59:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220706070350.1703384-1-hch@lst.de>
 <20220706070350.1703384-14-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220706070350.1703384-14-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 13/16] nvmet:: use bdev based helpers in
 nvmet_bdev_zone_mgmt_emulate_all
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/6/22 16:03, Christoph Hellwig wrote:
> Use the bdev based helpers instead of the queue based ones to clean up
> the code a bit and prepare for storing all zone related fields in
> struct gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/nvme/target/zns.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
> index c4c99b832daf2..9d8717126ab31 100644
> --- a/drivers/nvme/target/zns.c
> +++ b/drivers/nvme/target/zns.c
> @@ -413,7 +413,7 @@ static u16 nvmet_bdev_zone_mgmt_emulate_all(struct nvmet_req *req)
>  		ret = 0;
>  	}
>  
> -	while (sector < get_capacity(bdev->bd_disk)) {
> +	while (sector < bdev_nr_sectors(bdev)) {
>  		if (test_bit(blk_queue_zone_no(q, sector), d.zbitmap)) {
>  			bio = blk_next_bio(bio, bdev, 0,
>  				zsa_req_op(req->cmd->zms.zsa) | REQ_SYNC,
> @@ -422,7 +422,7 @@ static u16 nvmet_bdev_zone_mgmt_emulate_all(struct nvmet_req *req)
>  			/* This may take a while, so be nice to others */
>  			cond_resched();
>  		}
> -		sector += blk_queue_zone_sectors(q);
> +		sector += bdev_zone_sectors(bdev);
>  	}
>  
>  	if (bio) {


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

