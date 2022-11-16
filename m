Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B6CC433FE
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 20:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668629148;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5yyfBsgyx2oBgiTTc7wH4t1iaBtw7yy/8/uoM9Q/Yxs=;
	b=ETWNLlRfF9PeToKS7E+MBUsXoKukYC6iShrKgF2EefAdgqKug3+tHYpmRY1vcN7YXARIGI
	nyhKIhruVpEKBqLTY+WS6gwo/RdVfiFDGPP8AQoR6OGwDCrWGfhPG9TzDSmCmqHIZy9rsQ
	l4WFRMrynsfn4lVocez2qT+AzEOgRdQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-WbgkJ4p6N5upcm98F6w4fw-1; Wed, 16 Nov 2022 15:05:47 -0500
X-MC-Unique: WbgkJ4p6N5upcm98F6w4fw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E6F23C0F67B;
	Wed, 16 Nov 2022 20:05:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D3665492B0E;
	Wed, 16 Nov 2022 20:05:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 771C319465A3;
	Wed, 16 Nov 2022 20:05:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 13C8E19465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 20:05:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EA046C1908A; Wed, 16 Nov 2022 20:05:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E2F4EC1E88E
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 20:05:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7601101A58E
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 20:05:39 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-471-uCy6CuF5MyqTqHEU7ZFSBQ-1; Wed, 16 Nov 2022 15:05:37 -0500
X-MC-Unique: uCy6CuF5MyqTqHEU7ZFSBQ-1
Received: by mail-qk1-f197.google.com with SMTP id
 bi42-20020a05620a31aa00b006faaa1664b9so18272807qkb.8
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 12:05:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=JLUc8wFQUngPcn9VE0lYivlFFmu9hagcuFWZhYxzxAg=;
 b=iM+sRLmxeLCRIbPd3vdRO8irEPSo2c9FuaBaGIYiyNZJUTeZV3hgO1LnIpoB/Xqo5Q
 AKi6zvr7vyJJ6jydvDNRIon3aGhVqxrRnXfZsDO18Xb1i/f+RjkEp4Vir6q4keeGIFFp
 a7J8FY6rIauUkOswpf6YUSA9/C0yXgklLUiX9skakkfqJnIZPa3a7uexOaA5iUaJkdJV
 eOMB93y3dD7Kb/60mn/fx8XbS1VYjErFvtPbTCC8K5nins7TbiUGZsvYil8FqZedjg/3
 VGN+WfWlXVSnIPziZa/IGT7vKG5qOd8fA2a/tzDriYxbHTuwZmzpwQmQP0DcZbvF+1d+
 74Iw==
X-Gm-Message-State: ANoB5pmAuXy0Q+l8QH+YSCXozTrf7qYVMC3F1UU2tQhmyzPb4sH3NDRO
 VO7hXqDMYBrtPyK8uLk4heZU0DTvZ7kdSH/s7d2desZWAwOItKM8+/kagRaLvOhDkdkiwINK4NF
 SEEuPSrLCv7gcCw==
X-Received: by 2002:a05:620a:c43:b0:6fa:6423:65b6 with SMTP id
 u3-20020a05620a0c4300b006fa642365b6mr13695671qki.324.1668629136794; 
 Wed, 16 Nov 2022 12:05:36 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7QFuYuDYf+7fZ1eA/V2zF+3DqiMnkhOXs+SdKPfUYyDPJiEMnLz8vlNganM/gmYt11Dh8S9Q==
X-Received: by 2002:a05:620a:c43:b0:6fa:6423:65b6 with SMTP id
 u3-20020a05620a0c4300b006fa642365b6mr13695661qki.324.1668629136592; 
 Wed, 16 Nov 2022 12:05:36 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 p70-20020a374249000000b006eef13ef4c8sm10488872qka.94.2022.11.16.12.05.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 12:05:36 -0800 (PST)
Date: Wed, 16 Nov 2022 15:05:34 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Keith Busch <kbusch@meta.com>
Message-ID: <Y3VCjoT2PtHWRvrO@redhat.com>
References: <20221110184501.2451620-1-kbusch@meta.com>
 <20221110184501.2451620-3-kbusch@meta.com>
MIME-Version: 1.0
In-Reply-To: <20221110184501.2451620-3-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCHv2 2/5] dm-crypt: provide dma_alignment limit
 in io_hints
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, mpatocka@redhat.com, stefanha@redhat.com,
 Keith Busch <kbusch@kernel.org>, me@demsh.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 10 2022 at  1:44P -0500,
Keith Busch <kbusch@meta.com> wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> This device mapper needs bio vectors to be sized and memory aligned to
> the logical block size. Set the minimum required queue limit
> accordingly.
> 
> Link: https://lore.kernel.org/linux-block/20221101001558.648ee024@xps.demsh.org/
> Fixes: b1a000d3b8ec5 ("block: relax direct io memory alignment")
> Reportred-by: Eric Biggers <ebiggers@kernel.org>
> Reported-by: Dmitrii Tcvetkov <me@demsh.org>
> Signed-off-by: Keith Busch <kbusch@kernel.org>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

