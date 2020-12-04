Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1F7C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 16:42:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E293722AAF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 16:42:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E293722AAF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-OoRpJGQIMj2UHbFc3wOxSg-1; Fri, 04 Dec 2020 11:42:31 -0500
X-MC-Unique: OoRpJGQIMj2UHbFc3wOxSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E2C81005513;
	Fri,  4 Dec 2020 16:42:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D5F9360918;
	Fri,  4 Dec 2020 16:42:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 925A4180954D;
	Fri,  4 Dec 2020 16:42:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B4GgJsL009866 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 11:42:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C3E632166B2C; Fri,  4 Dec 2020 16:42:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE5FD2166B2F
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 16:42:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 191E6186E124
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 16:42:17 +0000 (UTC)
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com
	[209.85.166.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-409-nP1pyPJnOTWQH2lF7-nDbw-1; Fri, 04 Dec 2020 11:42:14 -0500
X-MC-Unique: nP1pyPJnOTWQH2lF7-nDbw-1
Received: by mail-il1-f169.google.com with SMTP id p5so5747414iln.8
	for <dm-devel@redhat.com>; Fri, 04 Dec 2020 08:42:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=fikGB5tiwbaXtQtRZDejlU5o/PV+EqzyE1dSj5rzFBI=;
	b=OnCS8wNC8TENuLHliX2au9IfBZwMKlj+ENL+bQRslJnGvSnZtDFfOIHoABYT6IK4By
	crBrMlii9qGA6FRJRZDeiaTaJRT+xnjLHdRymHkdnAoSw5WPCeHSKxOfy68JJNb3hf1/
	52k1CNiiifOJy7ZRzCRom9SjuVMC/UqY/hWlgCRAetEoiK4cGKoc6ilVPqiUWgIx4x2s
	VRUayAewR4qmJ9gInHeVQrJxy/O4kzspo0Qn4lZlawRlLnlNcLMwACumYCXhuNFO418p
	EJLGgfGjqw7TDOGgf3DFBm07irckaCk/WUAZHXho8G+jNt85hqcj3cXYVsKO/SVO0aP/
	qoqw==
X-Gm-Message-State: AOAM533ypmvbNcGp0D+s4FgYLk+OeURMqpITr2cuZZebT3QIbp7fKcrx
	7v/GZB7s1vwXgsiBw65v8hMMNw==
X-Google-Smtp-Source: ABdhPJyW5yIk7VMQwzcjfu979UjnKKVuVKC1F7TQhIJYUX++QDtGzNaJxMSREo0fly/SWSE8ENM4PA==
X-Received: by 2002:a92:204:: with SMTP id 4mr5121778ilc.79.1607100129990;
	Fri, 04 Dec 2020 08:42:09 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id u16sm1849585ilj.6.2020.12.04.08.42.09
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 04 Dec 2020 08:42:09 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>
References: <20201203162139.2110977-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8859c43f-a1fa-60dc-ea27-4a126f95dc68@kernel.dk>
Date: Fri, 4 Dec 2020 09:42:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201203162139.2110977-1-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-raid@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [dm-devel] block tracepoint cleanups v2
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/3/20 9:21 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series cleans up the block layer tracepoints by removing unused
> tracepoints or tracepoint arguments and consolidating the implementation
> of various bio based tracepoints.

Applied, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

