Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC3BBC41513
	for <dm-devel@archiver.kernel.org>; Wed,  9 Aug 2023 06:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691563808;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+r2rdC6olrcSoOIRDix5NNNPn9TBgtZsy0BwkX0JxGw=;
	b=L7U/CSn/JpT8a/k1Y41rKVNOpO3nIv7Mg3H4gVpBroPuQlL/qo5FUhhoICOXkesLaDmKEW
	WUqV2o0veQUuv9z0WP8n9BK9MCdKciwoX9I3GDHup/gZOa+PJfVciQRqDxn/j35ItfrMiT
	74PGdLY9F/xFTltHXMJtkinBWaqeifI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-vE_JULJCONG5ZTTaSxEBAg-1; Wed, 09 Aug 2023 02:50:05 -0400
X-MC-Unique: vE_JULJCONG5ZTTaSxEBAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2455101B450;
	Wed,  9 Aug 2023 06:50:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0BBF1121314;
	Wed,  9 Aug 2023 06:50:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00D291946A44;
	Wed,  9 Aug 2023 06:50:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4AC4A1946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Aug 2023 17:41:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3C6322166B27; Tue,  8 Aug 2023 17:41:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 34E262166B25
 for <dm-devel@redhat.com>; Tue,  8 Aug 2023 17:41:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1664A8DC666
 for <dm-devel@redhat.com>; Tue,  8 Aug 2023 17:41:20 +0000 (UTC)
Received: from mail.hugovil.com (mail.hugovil.com [162.243.120.170]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-523-RgVEypBgMpmnj0YNQQaxLQ-1; Tue,
 08 Aug 2023 13:41:18 -0400
X-MC-Unique: RgVEypBgMpmnj0YNQQaxLQ-1
Received: from modemcable061.19-161-184.mc.videotron.ca ([184.161.19.61]:49596
 helo=pettiford) by mail.hugovil.com with esmtpa (Exim 4.92)
 (envelope-from <hugo@hugovil.com>)
 id 1qTQ7J-0000iN-Ns; Tue, 08 Aug 2023 13:03:34 -0400
Date: Tue, 8 Aug 2023 13:03:33 -0400
From: Hugo Villeneuve <hugo@hugovil.com>
To: Yue Haibing <yuehaibing@huawei.com>
Message-Id: <20230808130333.2207c675d008fa6c808a472f@hugovil.com>
In-Reply-To: <20230808150301.45196-1-yuehaibing@huawei.com>
References: <20230808150301.45196-1-yuehaibing@huawei.com>
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 184.161.19.61
X-SA-Exim-Mail-From: hugo@hugovil.com
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on mail.hugovil.com)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 09 Aug 2023 06:49:58 +0000
Subject: Re: [dm-devel] [PATCH -next] dm: Remove unused declaration
 dm_get_rq_mapinfo()
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
Cc: heinzm@redhat.com, dm-devel@redhat.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: hugovil.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 8 Aug 2023 23:03:01 +0800
Yue Haibing <yuehaibing@huawei.com> wrote:

Hi,

> Commit ae6ad75e5c3c ("dm: remove unused dm_get_rq_mapinfo()")
> removed the implementation but leave declaration.

Maybe change to "removed the implementation but not the declaration."

Hugo Villeneuve.


> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>  include/linux/device-mapper.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 69d0435c7ebb..5bc69c6a64e0 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -502,7 +502,6 @@ int dm_post_suspending(struct dm_target *ti);
>  int dm_noflush_suspending(struct dm_target *ti);
>  void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors);
>  void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone);
> -union map_info *dm_get_rq_mapinfo(struct request *rq);
>  
>  #ifdef CONFIG_BLK_DEV_ZONED
>  struct dm_report_zones_args {
> -- 
> 2.34.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

