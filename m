Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B02C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 15:39:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B6D3020659
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 15:39:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6D3020659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-Gb9bhQBdP3iu9sxMvOPCOQ-1; Thu, 03 Dec 2020 10:39:12 -0500
X-MC-Unique: Gb9bhQBdP3iu9sxMvOPCOQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAF1E800D53;
	Thu,  3 Dec 2020 15:39:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6779960873;
	Thu,  3 Dec 2020 15:39:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8F85918095C7;
	Thu,  3 Dec 2020 15:39:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3Fd1Ma025658 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 10:39:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7E8FD20296B4; Thu,  3 Dec 2020 15:39:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79EAE20296A9
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 15:38:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B9A7802A5D
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 15:38:58 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
	[209.85.219.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-65-BZCbgtX8M3iNRCdn48XtrQ-1; Thu, 03 Dec 2020 10:38:56 -0500
X-MC-Unique: BZCbgtX8M3iNRCdn48XtrQ-1
Received: by mail-qv1-f48.google.com with SMTP id 4so1137631qvh.1
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 07:38:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=8iYfZK7k4LKkXHjhIpzgbWtlDMSLNvryIb4qP/617/A=;
	b=mNr2uhl2SHR4i8E3P+iuKD5CCk7jqqMWUH30gGJeE8olDM2xCZGIZQJaGEuik/m5PN
	7Zgo7uHuCymptUNZQWo9YQxDEyZxY0w97frM01R9ULKh669AyeiChnovvo6Ia5NI3mG1
	djisac1m3E5G+K9mboyD6eahES0iWpY3U5iFT7AflmcUe6Vw/FD4mA2reqd2TGhiVcg3
	wS5lHuypwjIA7lP3BVQtMKmPoWuzwTZxXCiUVUouUPf8kr8iEovi2rQWRXqGfND6kwyG
	biJxRPwmZ03+pk/gKMtFdjUWukJz5NvQe+J1P37jg4Cj64vZU6lMaMnVqLzUhlPYx5to
	yyfw==
X-Gm-Message-State: AOAM5319O5kmh5W2V2fDVReSf4YVJ/1gi988Wbvz22d/5qBSOo+SfB4p
	o5XOg9kD6gvZQF9Tq/J6gDSvdPmEOTWMvw==
X-Google-Smtp-Source: ABdhPJx09aEGriwr3pY6WH0RuczKuf2fJnXuG/xMIJwR9iDX4IW9IWBXN98EBXBwIGOF+0zIbLpqjA==
X-Received: by 2002:a0c:db8c:: with SMTP id m12mr3854958qvk.11.1607009935544; 
	Thu, 03 Dec 2020 07:38:55 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id a85sm1723149qkg.3.2020.12.03.07.38.53
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Dec 2020 07:38:54 -0800 (PST)
Date: Thu, 3 Dec 2020 10:38:26 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8kGcgHvk8L22Nc+@mtj.duckdns.org>
References: <20201130175854.982460-1-hch@lst.de>
	<20201203082559.GA15521@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201203082559.GA15521@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [dm-devel] block tracepoint cleanups
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 03, 2020 at 09:25:59AM +0100, Christoph Hellwig wrote:
> Whom can I trick into reviewing this fairly simple series now that
> the one dependig on it got fully reviewed?

Care to resend? I'd be happy to take a look later today.

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

