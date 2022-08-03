Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE0D1C19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659546686;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Nfsm0f7Xcw+Qprh/yYEhI6hnUH1XjtxnraBOhanl6P0=;
	b=M88ryp3KWWkFZhX1W4/2n6/41X9vs4kGkw2HFLLvmvVsmKGJhjrFMrW4OqTki3VZ3RsFq9
	HjHuYD4eN2uXk0erkc37/gOe8/IAjldSIqXH8B7R8hbW2DwgmoOJ1NwX6tDuvRyl+Ny0us
	trCtugGDuz/MTSrxksNQpe6hTc/L0VI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-9Ob1niA1M26zudxm1ZS7Kw-1; Wed, 03 Aug 2022 13:11:25 -0400
X-MC-Unique: 9Ob1niA1M26zudxm1ZS7Kw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D9EA101A586;
	Wed,  3 Aug 2022 17:11:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71CC118EB5;
	Wed,  3 Aug 2022 17:11:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1EC201946A53;
	Wed,  3 Aug 2022 17:11:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B29AA1946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 17:11:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D434C15D4F; Wed,  3 Aug 2022 17:11:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 99524C202C5
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 17:11:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82887185A7B2
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 17:11:18 +0000 (UTC)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-QaDBqUDYNsW8VOqBKzC35g-1; Wed, 03 Aug 2022 13:11:16 -0400
X-MC-Unique: QaDBqUDYNsW8VOqBKzC35g-1
Received: by mail-pl1-f179.google.com with SMTP id w14so3924005plp.9;
 Wed, 03 Aug 2022 10:11:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=o2afx9aZmzEdoWwdGDbShaY9b54ZclDxz5tctOo//Fo=;
 b=K4vhQy629XWN+ezI9rtoA4w0aa0/y96soMEvNVFwx1lnXEL5ZuEe4JDq8Hr9/vRHxF
 Q/Zd2lttqypgJX+7YVEPFxbgvm9xzL94TQ8fHZhJLYnt9ACyxtFYqs66UhY5Tqc/3tKL
 gfKZh3lBM5GGPrC4YE7dTfDsGhroa9UrLiRGm4PVb2Fiv3Up971AzS2+aGdHluFHA2/A
 RlcIJZGj2SRZizzFXk7eIqC3UalVUq/AojbdVqRzr4lbk26HBN5MKs7osc71VVbk+D3W
 vagV143+1gQHxBhg7cgIM5Zh+0E1Jj9kqk+DPUf+doDK5wkAIs9pQqtimbzMpFSWUtRP
 qgRA==
X-Gm-Message-State: ACgBeo0TA4iwaYcpOAFTVJV3TpzyFMs4c1XY+Ak6J7rxcokqUEBfxleH
 35ss8hXoL5j5AzMl8DwQyxo=
X-Google-Smtp-Source: AA6agR6EBIzKze1/rFrYedIXXEbWGppFAk1TLH0M11oAyd1FFJw2h6QmbM00Fe9GucsJfuqW4gRWhw==
X-Received: by 2002:a17:903:245:b0:16b:9c49:6b1c with SMTP id
 j5-20020a170903024500b0016b9c496b1cmr26089750plh.153.1659546675071; 
 Wed, 03 Aug 2022 10:11:15 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:db71:edb7:462a:44af?
 ([2620:15c:211:201:db71:edb7:462a:44af])
 by smtp.gmail.com with ESMTPSA id
 w127-20020a623085000000b0052df34124b4sm3552742pfw.84.2022.08.03.10.11.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 03 Aug 2022 10:11:14 -0700 (PDT)
Message-ID: <d091dcf8-ce01-06cb-bff0-b41a5bb1ee86@acm.org>
Date: Wed, 3 Aug 2022 10:11:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, Johannes.Thumshirn@wdc.com,
 snitzer@kernel.org, axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
 agk@redhat.com, hch@lst.de
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094804eucas1p1feea4b1bdae819f4c8750994ddd94803@eucas1p1.samsung.com>
 <20220803094801.177490-3-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220803094801.177490-3-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v9 02/13] block:rearrange bdev_{is_zoned,
 zone_sectors, get_queue} helpers in blkdev.h
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/3/22 02:47, Pankaj Raghav wrote:
> Define bdev_is_zoned(), bdev_zone_sectors() and bdev_get_queue() earlier
> in the blkdev.h include file.
> 
> This commit has no functional change, and it is a prep patch for allowing
> zoned devices with non-power-of-2 zone sizes in the block layer.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

