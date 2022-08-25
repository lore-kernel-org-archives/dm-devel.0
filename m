Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121F9ECAAD1
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 21:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661463977;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FxiDSjVG3g6vOjCssO5Oba6Ucw4Xz0/VdpQ2FKUidSg=;
	b=Z6U1IeN2kXUwA1/yKDm51L45WOsOqywWPxJAVtZmtH+sHs9XRBup6glJRDd74zEk6jHhwp
	9gyLhuH8r9i5Kw5/1/ublnF/dUZPbMDxS+qNAMYaBF4hDQtMtq9HT4qS5CqRXPfvoGqKgb
	1lOiNj2SAHxqgG67ENkWUOWV+SL6P+E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-Bq8ZkVylPf6xaPxfpxDPBA-1; Thu, 25 Aug 2022 17:46:13 -0400
X-MC-Unique: Bq8ZkVylPf6xaPxfpxDPBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09F45801231;
	Thu, 25 Aug 2022 21:46:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ECF631410DD5;
	Thu, 25 Aug 2022 21:46:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B3D791946A5A;
	Thu, 25 Aug 2022 21:46:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 83B291946A43
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 21:46:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 65A89400F36; Thu, 25 Aug 2022 21:46:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 622F7492C3B
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 21:46:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A81E803520
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 21:46:09 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-124-qmd_5R4nPHKarQtPgey7PQ-1; Thu, 25 Aug 2022 17:46:07 -0400
X-MC-Unique: qmd_5R4nPHKarQtPgey7PQ-1
Received: by mail-pf1-f169.google.com with SMTP id 142so1962876pfu.10;
 Thu, 25 Aug 2022 14:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=b/kOGC4F2xUm59JRxyr6870MdL+nGgrRYhM7/o4VT0c=;
 b=JxigNgWaz/ron3+QDAKz7cZ+rE3nxW+p6d5yFn57UyJ+27k314mVDdJ7HGs9cJnwqf
 j5lAm2q8LY4VBeNGKnrCl+C4l4YKZFB8/F1pwhpo60s9bLgJbTH52Xx+ubWwo2khfKAh
 WeqTPG8WZSr/Q3h1bW+ZqfLhULhg4q0SqwnUCW94XFIRoReaNhrGhyXX6vbDkcd/50mW
 l6NoD3Mdxoq6mQAfpP4Xn306ivbOj6uNHqLEr9H92zQI7G408aOKeWVFZUCl1O1vUjvN
 bcg5MS5Vg7f0gpOFwtMHIWntQf5a9kL60Dm2gJReuX9bHVY1gRtpeDA6Y/2S0kCP33U7
 GnPw==
X-Gm-Message-State: ACgBeo1W9Rapm2PEfmKjAdamvtR7Y6ITSwYtT8VyzehkDEPBrY5r5Cir
 FKRHrsO6Z9bZtodcmvKAYuc=
X-Google-Smtp-Source: AA6agR75klAqItVGOT27TBqBxype2jtUq57AMSY37jZpLRunDrmU0pjJoNsnSIYBhfJ1+Z5ssbsM1g==
X-Received: by 2002:a05:6a00:1a91:b0:52f:29e7:c32c with SMTP id
 e17-20020a056a001a9100b0052f29e7c32cmr1064285pfv.10.1661463966264; 
 Thu, 25 Aug 2022 14:46:06 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:349c:3078:d005:5a7e?
 ([2620:15c:211:201:349c:3078:d005:5a7e])
 by smtp.gmail.com with ESMTPSA id
 a16-20020a170902ecd000b0016b90620910sm49487plh.71.2022.08.25.14.46.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Aug 2022 14:46:05 -0700 (PDT)
Message-ID: <ee3be9d8-b473-8e59-4d3c-84e0ef9dd6f8@acm.org>
Date: Thu, 25 Aug 2022 14:46:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, agk@redhat.com, snitzer@kernel.org, 
 axboe@kernel.dk, damien.lemoal@opensource.wdc.com, hch@lst.de
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121907eucas1p295c375935b556729864dce39534c2579@eucas1p2.samsung.com>
 <20220823121859.163903-6-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220823121859.163903-6-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v12 05/13] nvme: zns: Allow ZNS drives that
 have non-power_of_2 zone size
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
 linux-block@vger.kernel.org, dm-devel@redhat.com, gost.dev@samsung.com,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/23/22 05:18, Pankaj Raghav wrote:
> Remove the condition which disallows non-power_of_2 zone size ZNS drive
> to be updated and use generic method to calculate number of zones
> instead of relying on log and shift based calculation on zone size.
> 
> The power_of_2 calculation has been replaced directly with generic
> calculation without special handling. Both modified functions are not
> used in hot paths, they are only used during initialization &
> revalidation of the ZNS device.
> 
> As rounddown macro from math.h does not work for 32 bit architectures,
> round down operation is open coded.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

