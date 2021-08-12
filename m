Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95205C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 01:41:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C987B6104F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 01:41:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C987B6104F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-UOK2F4pXOHuSEzpcojXvkQ-1; Wed, 11 Aug 2021 21:41:05 -0400
X-MC-Unique: UOK2F4pXOHuSEzpcojXvkQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61474760C0;
	Thu, 12 Aug 2021 01:41:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A66FD5FC25;
	Thu, 12 Aug 2021 01:40:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D87144BB7C;
	Thu, 12 Aug 2021 01:40:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17C1eofp023044 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Aug 2021 21:40:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6DF41208AB91; Thu, 12 Aug 2021 01:40:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69A702077FC2
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 01:40:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 019F7101A529
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 01:40:48 +0000 (UTC)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
	[209.85.216.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-129-MkDLqM_6O4ehFQg2M5NIQw-1; Wed, 11 Aug 2021 21:40:45 -0400
X-MC-Unique: MkDLqM_6O4ehFQg2M5NIQw-1
Received: by mail-pj1-f44.google.com with SMTP id
	lw7-20020a17090b1807b029017881cc80b7so12654857pjb.3
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 18:40:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=QBCEaZn4CkWRVtl+4I6ERHHpNUJaxKMTsA/sipIS2t8=;
	b=h60mZh0Meb16d7ugDCwvHMyKk1IRBn5CKlH7Pmat/a1GmQocfLRV4qwqdshkv/k7vS
	PpChE2zMxDyew0Sa3ajmW2uDPjBx0//bBUfyi04TdhaBvk6LrjIVUSWRkICYtu7WldLo
	pTpqRkUtk4veey6uFGcmWtd/0rGtp3rLDh1BnoOmZCyBxejGKMdZc5jp2vpyt23MDufF
	YJ21RZ+CIGBGxwW/l2zvQgnoSNct/XRoGbNr4Nu65PYc5zD4GT8GpO+aQLopaib+VirG
	Dm5B6Rbb20aCK7X3MfaeL/YjwgbhdpFDeB67gt6F6NgOliyPQsG685/kmvbAu+hasH7Y
	cuGw==
X-Gm-Message-State: AOAM5329CToF5cjhu3/eOp17wP9W2GdPA5T5susvK15rHdIPAxbMJmpX
	J28fzUBOl2ku+W1M3nsfD24tv5BBlRw3WccS
X-Google-Smtp-Source: ABdhPJzl/5HjrqjAQCGK1rRIV5X/InNfmv/4mjaWA+B4xSMg0kQhVfZ5cUxBLeChlLpXX2OQaNseQw==
X-Received: by 2002:a17:902:7041:b029:12d:267a:d230 with SMTP id
	h1-20020a1709027041b029012d267ad230mr1394258plt.55.1628732444664;
	Wed, 11 Aug 2021 18:40:44 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
	by smtp.gmail.com with ESMTPSA id
	ca12sm745528pjb.45.2021.08.11.18.40.43
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 11 Aug 2021 18:40:44 -0700 (PDT)
To: Guoqing Jiang <guoqing.jiang@linux.dev>, colyli@suse.de,
	kent.overstreet@gmail.com, agk@redhat.com, snitzer@redhat.com
References: <20210721025315.1729118-1-guoqing.jiang@linux.dev>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0a648cf7-69fc-d5c9-9a8d-537a644527f3@kernel.dk>
Date: Wed, 11 Aug 2021 19:40:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210721025315.1729118-1-guoqing.jiang@linux.dev>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] block: move some macros to blkdev.h
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/20/21 8:53 PM, Guoqing Jiang wrote:
> From: Guoqing Jiang <jiangguoqing@kylinos.cn>
> 
> Move them (PAGE_SECTORS_SHIFT, PAGE_SECTORS and SECTOR_MASK) to the
> generic header file to remove redundancy.

Applied for 5.15, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

