Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1FC9ECAAA3
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 21:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661464260;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lAbPrOatrU2c8+YnUBUmPic699oAal08ZFi9O2mMRWM=;
	b=Bck98pGDY22Uboha9RBcTPDDyK/+PYyMgcQseEjz7KdP75HWXjzMMAoZ2Ge0ucf+5+IonZ
	6LzAiiyPmiFJqoEHC7mjrjJDR8ClQN5q+uExO1+rn2G07slRl/SqU6xPeUd3JkttjcI+yX
	zVQJIlEtHIZHGsYU+a+JZIOuUPjl5qA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-6Vzt_8Q4Ma-AyI8hSPC5EA-1; Thu, 25 Aug 2022 17:50:57 -0400
X-MC-Unique: 6Vzt_8Q4Ma-AyI8hSPC5EA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 785EC3C11981;
	Thu, 25 Aug 2022 21:50:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 21E22141510F;
	Thu, 25 Aug 2022 21:50:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 57DFE1946A5A;
	Thu, 25 Aug 2022 21:50:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 170CF1946A43
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 21:50:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EA2142166B29; Thu, 25 Aug 2022 21:50:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E64562166B26
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 21:50:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC130101A54E
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 21:50:52 +0000 (UTC)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-558-4Qi-7agsNzCVfaMmN39eVg-1; Thu, 25 Aug 2022 17:50:50 -0400
X-MC-Unique: 4Qi-7agsNzCVfaMmN39eVg-1
Received: by mail-pf1-f182.google.com with SMTP id 72so788380pfx.9;
 Thu, 25 Aug 2022 14:50:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=A1GDSS4ZswYZdPLm/xFYMxcSzWgFZQdBzdkCHj25ONs=;
 b=d0m5VaR6Si1s3b1buSzeeEW4yURjHNO/j3SphxwsBEojYt0+/BK8GcFOBLUaxFwu2i
 PODrKX7cDj1sxIwwsCgVxVqmmJKS+5QYUxtlXMTIBXRCohFxIvbUm5xZub2GjhOcrBu5
 hpE1bCslweM9YuD0tStjv4CoQQ23EfJE0aJF0J6blYQSfkWstwOvQ8DCNENrbT9DYFox
 EKQ6ryVL4+2rCL5b96Xq8UKZ0rUFtL34C7tOYU+5FlFMW4E9oWPg8UqQTP6eCte7ffhr
 DEFNFv3Xs6nplpKh6IJnaARY0uXgPs8cqSAs2+G4iqbiX0A2C40rHyx2Wjx/MZO8IHoR
 ckgQ==
X-Gm-Message-State: ACgBeo1yjrU7Wm6XIhjbM9Op5fOpEg/MWZ0qlD+WqHkbp+eJOfD80HHj
 z/d8TGwbg/OqfGiGqBR+6I0=
X-Google-Smtp-Source: AA6agR4mlNQNlswjcYi/OOqa2VKdvYxaaS8E9JPwi6wD85RRMAlmfsBiW/v3/FllaJ/9tjyjR3F0Cw==
X-Received: by 2002:a63:e20c:0:b0:42b:4467:e0f4 with SMTP id
 q12-20020a63e20c000000b0042b4467e0f4mr874532pgh.576.1661464248859; 
 Thu, 25 Aug 2022 14:50:48 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:349c:3078:d005:5a7e?
 ([2620:15c:211:201:349c:3078:d005:5a7e])
 by smtp.gmail.com with ESMTPSA id
 i12-20020a17090332cc00b001713af9e85dsm36928plr.180.2022.08.25.14.50.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Aug 2022 14:50:48 -0700 (PDT)
Message-ID: <1dcffde8-ded6-b665-58a4-0f9f091b2a8e@acm.org>
Date: Thu, 25 Aug 2022 14:50:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, agk@redhat.com, snitzer@kernel.org, 
 axboe@kernel.dk, damien.lemoal@opensource.wdc.com, hch@lst.de
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121909eucas1p113c0c29f7e28d0ee3e1161f7da243baf@eucas1p1.samsung.com>
 <20220823121859.163903-9-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220823121859.163903-9-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v12 08/13] dm-zoned: ensure only power of 2
 zone sizes are allowed
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
Cc: pankydev8@gmail.com, Johannes.Thumshirn@wdc.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/23/22 05:18, Pankaj Raghav wrote:
> From: Luis Chamberlain <mcgrof@kernel.org>
> 
> dm-zoned relies on the assumption that the zone size is a
> power-of-2(po2) and the zone capacity is same as the zone size.
> 
> Ensure only po2 devices can be used as dm-zoned target until a native
> support for zoned devices with non-po2 zone size is added.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

