Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE103C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 16:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646672195;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6Lj7pfZVxyCqLdWrLV9V6FRVTeeYEfCkD2dhI44F+j8=;
	b=djnxKeYDtbJyR3EPKbyVA5oUmJpiFt2/JeBvX9V83Z0/60u1PH3t7tLpjq9zkUEa1cHqVU
	oY8j4aMrZusl3qZ3KrvK808oZnWc69s4UwG1riDfTpKcjOrWxvUZTJSXEq112Acg3CxCln
	L+m031KolwnENk0OI8/yBxYQ/gJ0UAs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-3K_asauWMQqKLH_myCSgYw-1; Mon, 07 Mar 2022 11:56:32 -0500
X-MC-Unique: 3K_asauWMQqKLH_myCSgYw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C82C4101AA42;
	Mon,  7 Mar 2022 16:56:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 767B5401E32;
	Mon,  7 Mar 2022 16:56:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 37CA619305AB;
	Mon,  7 Mar 2022 16:56:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 94F8319305AA
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 16:56:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 738EE145FBAE; Mon,  7 Mar 2022 16:56:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 70055145FBAD
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 16:56:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56A21811E80
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 16:56:28 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-qXhTfsXFNWO0nTbIdBrJVw-1; Mon, 07 Mar 2022 11:56:26 -0500
X-MC-Unique: qXhTfsXFNWO0nTbIdBrJVw-1
Received: by mail-qt1-f197.google.com with SMTP id
 e28-20020ac8415c000000b002c5e43ca6b7so13051547qtm.9
 for <dm-devel@redhat.com>; Mon, 07 Mar 2022 08:56:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GKvX1sl7p58ECEtwztu/8ZgveUC73k+ES14SIrLarpQ=;
 b=4gG7Amhf6jasKFNFgbcB6ltGne+unlNLk7uGe6vGT1G37CVIDzv+RDPerlJrzih2j/
 kgrjky4E7N+QI0wiXfcxbrMd+tkC0vHtmHhXRN8/2E6THiXG4UJRcYQdC7iqJqrbnHxZ
 SCtnyhqBDUW+g1LbhV5e5RwG00NARNSDUf4T3xSpMX8cmk4fp7GMzDomzTPxOOIh4yc0
 sS/btsvnd7fnwl+3SCjsnXjbvdB+/YtEWgNZ+vNcEeBTuJLgJTkn9ioP7FI19X6IXiA0
 u1ZTeCzQb/k71ijweykDpVsH5yvNLyLu4Y4JZFxmdj+jaAN70MIT9O7h0F1uJs+seIef
 m6DA==
X-Gm-Message-State: AOAM533+hGBYB2TP7RTBvErnvwHf1CrLVMktCCFRt+rS34tZFvJ6x8vM
 JHNMRDCbDQSsnAwbiNWLQGOUuHaE9VzGnOe73rQgbqJK+peRcCTjVYBe48UVm1Nms/3g+PwECK7
 S2+5fiqlCT1BaoQ==
X-Received: by 2002:a37:e303:0:b0:47b:b0e1:fc3f with SMTP id
 y3-20020a37e303000000b0047bb0e1fc3fmr7411353qki.108.1646672185820; 
 Mon, 07 Mar 2022 08:56:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgimeaJmCviuje97Vzy/Bu8ddKoAbj4Lj2WFLdHhsuRx8YeCO+5ZEp3hBleQ9OYyyKUFJxWg==
X-Received: by 2002:a37:e303:0:b0:47b:b0e1:fc3f with SMTP id
 y3-20020a37e303000000b0047bb0e1fc3fmr7411341qki.108.1646672185573; 
 Mon, 07 Mar 2022 08:56:25 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 l19-20020a05622a175300b002de935a94c9sm9086902qtk.8.2022.03.07.08.56.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Mar 2022 08:56:25 -0800 (PST)
Date: Mon, 7 Mar 2022 11:56:24 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YiY5OLhi1WMFUgGH@redhat.com>
References: <20220304180105.409765-1-hch@lst.de>
 <164666057398.15541.7415780807920631127.b4-ty@kernel.dk>
 <YiY2wUVIz3NXIjlc@redhat.com> <20220307164814.GA12591@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220307164814.GA12591@lst.de>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] remove bio_devname
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, linux-ext4@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 07 2022 at 11:48P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Mar 07, 2022 at 11:45:53AM -0500, Mike Snitzer wrote:
> > Should those go through block too? Or is there no plan to remove
> > bdevname()?
> 
> My preference would be:  do the full bio_devname removal through Jens'
> tree and you keep the bvdevname removal.  I hope bdevname will go away
> as well, but certainly not in this merge window.

OK, sounds good. Thanks

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

