Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E4FECAAD3
	for <dm-devel@archiver.kernel.org>; Fri,  2 Sep 2022 00:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662077868;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HkNOlmVYWAXcs7UH4OkvWBDcbCBrWwgoF6g11J0nx18=;
	b=bq03SPQWrD4+4ZSq5Y3nPH6UbRt5+u+KebESVvyD9U5xcYm4eeKyDqwM21fXApRZcSjySD
	e9TxJl+IKs7235Q/nB/i61hgFZ5S3Wx8qKlOe0Swn34FWXHoRIYY0IbjZRJ4igM6ATj7ez
	bHe646ppEtBmYcJ8Uj5w+bzbq4r0YOc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-z8VgwTibPn2sTnl5GWQ_7w-1; Thu, 01 Sep 2022 20:17:47 -0400
X-MC-Unique: z8VgwTibPn2sTnl5GWQ_7w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA2DE3804516;
	Fri,  2 Sep 2022 00:17:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 995E140B40C7;
	Fri,  2 Sep 2022 00:17:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 62C9F19426AB;
	Fri,  2 Sep 2022 00:17:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3BE4F1946A5E
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Sep 2022 00:17:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1EB5140B40C7; Fri,  2 Sep 2022 00:17:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1ADDD40CF8F2
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 00:17:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00BB4811E76
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 00:17:40 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645--CQm4q-BMvSoC72zdUQ16g-1; Thu, 01 Sep 2022 20:17:31 -0400
X-MC-Unique: -CQm4q-BMvSoC72zdUQ16g-1
Received: by mail-qt1-f200.google.com with SMTP id
 z10-20020a05622a124a00b003445680ff47so409999qtx.8
 for <dm-devel@redhat.com>; Thu, 01 Sep 2022 17:17:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=1VQaTuOirjpYt85+XINqeDWNmKGLZ6/kyCDRTLfcVcM=;
 b=IAk2pWjPQWzZSqocGg8tdoVO+2vZEtmeno9iIG0jHySwMGc+mb7LJUPawXuPwu8PK2
 cEPUaiMfgPoupwgAkJ6cfotpbyn4KsK30+87yqUtlLnodUjCGlnwkNCbx9hAv5gWruXJ
 X7PiRyq1trjcnihHvCESlUsMAnM9tVXCHDmzLy8nbvnKLQpQAwc4diu22NBYb95DrK8y
 eCNMmlbHJUPrtrNW+/RKPD3Tve2el4Tvzel7ATGcBmx/ry4wJ8caPPYnKZML/piajqYl
 VVzoka37UQ5YpA4OOqquusCFGAvPWnbG+D5RUe9eG/pR1Q22HIHkBakHwTmVG8valwDs
 YEgw==
X-Gm-Message-State: ACgBeo1IgbPOTKT/yAndw4SNVMq+c1np73UG+WLp96p+vhEFxbP24yVW
 VmaqlFnV5GPhy1VCl8YJtq2DRZKk2rdeg/hwVMhKIlDAzjF9ec00Y0UX1wAoQqiMidqSxaFTqn8
 OMbxmZltcCZ2x+w==
X-Received: by 2002:a05:620a:170c:b0:6bb:208c:d276 with SMTP id
 az12-20020a05620a170c00b006bb208cd276mr21623964qkb.539.1662077850967; 
 Thu, 01 Sep 2022 17:17:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5l1Y1wPC9cb0WfGk58FA5BvETyt3RQ0Hl5DfpLwLcYUCBnnMhNzZcJHR6wWE4FxqLZfiIC3A==
X-Received: by 2002:a05:620a:170c:b0:6bb:208c:d276 with SMTP id
 az12-20020a05620a170c00b006bb208cd276mr21623953qkb.539.1662077850790; 
 Thu, 01 Sep 2022 17:17:30 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 m7-20020a05620a290700b006b9593e2f68sm345562qkp.4.2022.09.01.17.17.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Sep 2022 17:17:30 -0700 (PDT)
Date: Thu, 1 Sep 2022 20:17:29 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <YxFLmZ1KUwQ9LLDK@redhat.com>
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121912eucas1p18223e1b04b65a8a10f6c50187e7474ea@eucas1p1.samsung.com>
 <20220823121859.163903-11-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220823121859.163903-11-p.raghav@samsung.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v12 10/13] dm-table: allow zoned devices with
 non power-of-2 zone sizes
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 23 2022 at  8:18P -0400,
Pankaj Raghav <p.raghav@samsung.com> wrote:

> Allow dm to support zoned devices with non power-of-2(po2) zone sizes as
> the block layer now supports it.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

