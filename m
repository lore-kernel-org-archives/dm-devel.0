Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D6BECAAA2
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 21:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661464434;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BtGgMn3LIyq8xF/kueKhun9sQTEkgLqtc+uO+vZ6CNI=;
	b=F6R75LI3i2SfMStBxsuMYwt2jVBPEhbLSQeEiIxlGitUjuWrYgc3xsO8H1ljbLbq/922rO
	G/25U80QUpllo/Ox1jz0XzI1eEfaPgqYOtFAw40SJUVKgHA1HoeXqhZZnlRgCGdfv8zzgQ
	HlioM/MQ0GpPW0HwOqxlxuZ97+2A5+Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-VkqGkMQbPVO8qDiFEUwIXQ-1; Thu, 25 Aug 2022 17:53:51 -0400
X-MC-Unique: VkqGkMQbPVO8qDiFEUwIXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C47285A585;
	Thu, 25 Aug 2022 21:53:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EFAB5409B3E3;
	Thu, 25 Aug 2022 21:53:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BE04A1946A5A;
	Thu, 25 Aug 2022 21:53:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6DC7B1946A43
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 21:53:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 26599403348; Thu, 25 Aug 2022 21:53:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22671492C3B
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 21:53:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AC18823F13
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 21:53:48 +0000 (UTC)
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com
 [209.85.210.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-12-YHgxs16SPQWZ6xjVjYYvaA-1; Thu, 25 Aug 2022 17:53:45 -0400
X-MC-Unique: YHgxs16SPQWZ6xjVjYYvaA-1
Received: by mail-pf1-f178.google.com with SMTP id a65so178837pfa.1;
 Thu, 25 Aug 2022 14:53:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=PoKbqdZjqcMil3GUCh8PrCnRMNvOIz0uCEqvIuzke58=;
 b=PgAR5WfvOONZpwklQ5c5pcATHir4K5PYCxN09UhxYVWNxCQp061k2VvdRcSXWUR2xk
 j2i7YmM5fViZ5plYo+bvJvY0rL24crnbLdGacSAn5yA22ZXfUOZaJJM5QLw88mGKF1yN
 dad6K5ljto5ggOqaWAm8fwgORcoM14GjSKze+EZA7Ib5vdWERljYDObkwPrwjYpMz4QC
 fPeoyFRfJvR0SxVeSejs7J9BHvQt1i6i/iRyGaZ6GLzdKtiV/FoYEDclKaSbDcG0tJ0T
 dwBQ5JHN38vCPGLf+eiQxt0nFfYLn2YygQCT2T2mSD058qHnIsjxh1p2HQyK79dMT9dI
 LFiw==
X-Gm-Message-State: ACgBeo10D59sTWLzI0uDSZJ1M3Fv5MDajqss0O5Pr+nPDWWrrlXhaGkz
 8LRGejycS+fgdHOeZcs2Wxs=
X-Google-Smtp-Source: AA6agR4oitY7DdgWzlDg0toNkuqiso8T3oQu+9kbXRQF5gO1MpCeX6jwibhLOIeQZecVmG/fiQTvbA==
X-Received: by 2002:a05:6a00:3497:b0:536:d6a8:6f62 with SMTP id
 cp23-20020a056a00349700b00536d6a86f62mr1039067pfb.79.1661464424600; 
 Thu, 25 Aug 2022 14:53:44 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:349c:3078:d005:5a7e?
 ([2620:15c:211:201:349c:3078:d005:5a7e])
 by smtp.gmail.com with ESMTPSA id
 d8-20020a17090a3b0800b001fb0a363c18sm195698pjc.52.2022.08.25.14.53.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Aug 2022 14:53:43 -0700 (PDT)
Message-ID: <9e81fd1e-b206-dd8d-4c27-1aa5cdcf4e10@acm.org>
Date: Thu, 25 Aug 2022 14:53:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, agk@redhat.com, snitzer@kernel.org, 
 axboe@kernel.dk, damien.lemoal@opensource.wdc.com, hch@lst.de
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121911eucas1p2a55dec72a6d780123e6c7655aee72457@eucas1p2.samsung.com>
 <20220823121859.163903-10-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220823121859.163903-10-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v12 09/13] dm-zone: use generic helpers to
 calculate offset from zone start
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/23/22 05:18, Pankaj Raghav wrote:
> Use the bdev_offset_from_zone_start() helper function to calculate
> the offset from zone start instead of using power of 2 based
> calculation.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

