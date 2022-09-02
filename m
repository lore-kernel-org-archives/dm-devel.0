Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEF0C38145
	for <dm-devel@archiver.kernel.org>; Fri,  2 Sep 2022 00:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662077911;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2R307usxmnSwhJ7EoJdFmpg3S2GYPD3KTI79Ulz/lQ0=;
	b=HLtOViH+A2Pl5j46mfgUh1KN4UFfmo7yor0gh/xSR4kp/UQh6urBunROOBVKoK5qjXxd/Y
	vVevFBUwHN3Yz2wuXrpyjhNt8Dpj2/2n6AzOiMoS7eOT8iwCszlfUHh+gAbAQofOjQ+ozY
	0c5LEPBq8woaZYZN+vfBQN+UdsLFPfw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-Vqd4MfKSMOm9SASN_KuN8g-1; Thu, 01 Sep 2022 20:18:27 -0400
X-MC-Unique: Vqd4MfKSMOm9SASN_KuN8g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB6EA1C05AE3;
	Fri,  2 Sep 2022 00:18:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB61C492C3B;
	Fri,  2 Sep 2022 00:18:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB7E419426AB;
	Fri,  2 Sep 2022 00:18:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 20DAE1946A5E
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Sep 2022 00:18:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC0492166B2A; Fri,  2 Sep 2022 00:18:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E7F812166B26
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 00:18:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC3C3811E81
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 00:18:23 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-445--Dqd1YWbNOalgid1IhaNzw-1; Thu, 01 Sep 2022 20:18:22 -0400
X-MC-Unique: -Dqd1YWbNOalgid1IhaNzw-1
Received: by mail-qt1-f199.google.com with SMTP id
 k9-20020ac80749000000b0034302b53c6cso381249qth.22
 for <dm-devel@redhat.com>; Thu, 01 Sep 2022 17:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=/3zSW4akroZH3AEa4Ob/zy2W13gQovdXsrNdOSGyuxY=;
 b=jjvjD81hwsQ6zPo5XCEz7ghYMgf5/2WQ/VFB3kkaVzEw6oicYC29GTO5CHPGt3/GXf
 /Zpkwpay4fITfbYJZxv0bZqfTt3DN9Rw1HUYtmTzyt05ZfYMvXKWJwQ2rP9CYPMm1dZ0
 kKOgqKv6vjcmSR1MBPp5+Z1UHVBorkX6bqDFCfPx9Zyg16VmrfkQ3uJK9QTRARqvHyfu
 0hCxD3vRbji1V8yj5/iZy8Le5HHNBHgWuK/OhJcUMyPwlam/CuTBUyVlnOU7nx4AmjoS
 8rapnFeviI8EFmrv5EOjJw/fijhipTTP6iAfeaHml9KOs586QbvjPODBCmQWRFNv4PkP
 Kdkg==
X-Gm-Message-State: ACgBeo1DAA2HWT+JELIlV+LjrjjHCdkvGrJ78Ln62agWHFzyIeKsxXQ+
 hPNNMTepySmQ9tiuGEYDuPxr/R4TVY65BtFKKvjPlfrolvuJVNrVA/S9iQ7sv1GEduo4Jb74HyQ
 4K58nhD8+ZtS/mw==
X-Received: by 2002:ac8:58c6:0:b0:343:6ea4:c5d with SMTP id
 u6-20020ac858c6000000b003436ea40c5dmr25887005qta.371.1662077902207; 
 Thu, 01 Sep 2022 17:18:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6oRhhYYJ6PrG/1HFlpvhf8UmICNazDZnq0j+/fuj1YsRN/1lRkHtGn1KfEAsjk0buEiHYDsQ==
X-Received: by 2002:ac8:58c6:0:b0:343:6ea4:c5d with SMTP id
 u6-20020ac858c6000000b003436ea40c5dmr25886979qta.371.1662077902000; 
 Thu, 01 Sep 2022 17:18:22 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 bn5-20020a05620a2ac500b006bb41ac3b6bsm267782qkb.113.2022.09.01.17.18.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Sep 2022 17:18:21 -0700 (PDT)
Date: Thu, 1 Sep 2022 20:18:20 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <YxFLzHoYF7damFip@redhat.com>
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121913eucas1p11c222f4c57a0132117bb9712e6018668@eucas1p1.samsung.com>
 <20220823121859.163903-12-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220823121859.163903-12-p.raghav@samsung.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v12 11/13] dm: call dm_zone_endio after the
 target endio callback for zoned devices
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
Cc: axboe@kernel.dk, bvanassche@acm.org, pankydev8@gmail.com,
 Johannes.Thumshirn@wdc.com, damien.lemoal@opensource.wdc.com,
 snitzer@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, matias.bjorling@wdc.com, gost.dev@samsung.com,
 jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 23 2022 at  8:18P -0400,
Pankaj Raghav <p.raghav@samsung.com> wrote:

> dm_zone_endio() updates the bi_sector of orig bio for zoned devices that
> uses either native append or append emulation, and it is called before the
> endio of the target. But target endio can still update the clone bio
> after dm_zone_endio is called, thereby, the orig bio does not contain
> the updated information anymore.
> 
> Currently, this is not a problem as the targets that support zoned devices
> such as dm-zoned, dm-linear, and dm-crypt do not have an endio function,
> and even if they do (such as dm-flakey), they don't modify the
> bio->bi_iter.bi_sector of the cloned bio that is used to update the
> orig_bio's bi_sector in dm_zone_endio function.
> 
> This is a prep patch for the new dm-po2zone target as it modifies
> bi_sector in the endio callback.
> 
> Call dm_zone_endio for zoned devices after calling the target's endio
> function.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Great patch header, explains the situation nicely.

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

