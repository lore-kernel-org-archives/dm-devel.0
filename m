Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4796BC6FA8B
	for <dm-devel@archiver.kernel.org>; Thu, 22 Sep 2022 07:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663830604;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0orfGwD4reSmfG7+W9L4ep2JbwRF2EWrCdNnXRTTME4=;
	b=CTls4kjAzZ3GXbdJckV+REf5lJ3HdG/451AcwQtsI6LNz3C+H8nqWhPqdHmziNANeo0Txw
	Zleb7JP9Su/3KZA11XnttODZmfnbYma4M05hor5F55CkyBAR/BliP6KLbtkOP3ncQu/9vQ
	VRXnfpIgEw+LgZ/F2LfM4q//KKMSRb8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-qlbn2qtPMouDf0HkajI0iQ-1; Thu, 22 Sep 2022 03:10:00 -0400
X-MC-Unique: qlbn2qtPMouDf0HkajI0iQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEF6F1C05159;
	Thu, 22 Sep 2022 07:09:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DE13340C2064;
	Thu, 22 Sep 2022 07:09:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF54A19465B1;
	Thu, 22 Sep 2022 07:09:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DD33B1946588
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Sep 2022 09:09:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CD51B112131B; Wed, 21 Sep 2022 09:09:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C6B701121314
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 09:09:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A73EF3810787
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 09:09:46 +0000 (UTC)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com
 [209.85.167.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-503-Dtw9bF3gOweNhUhN5v2MGQ-1; Wed, 21 Sep 2022 05:09:43 -0400
X-MC-Unique: Dtw9bF3gOweNhUhN5v2MGQ-1
Received: by mail-lf1-f51.google.com with SMTP id j16so8143041lfg.1;
 Wed, 21 Sep 2022 02:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=CJumgeBihgLxngSicS7NE5vjfcZmDSi/RxXboW9qUWM=;
 b=Wgg15Wp/qDLEmiNoxrW/J/bl9lmZzN2W3L79M0XBXt6h1UsqA/psQueKmfpJ/p/lI9
 hYjW436E9Hul9tYaHCMFwIA8MPf5Uco8/cgO1mdskDW3FQwFJDQA8LKVojAu7bvjjIl2
 I2Qzus9DKFLCe1ByK4Nq5Jm6ZQgjzar/medm54x9Q9qMryYprC5qldW5WzPadlKzhVfp
 Pa1oH5+o8rM7HDrAthj6eP5VhZbrKNM0DA5ZwIBJAzMyJBKpPJ6sawfC/41OlGCd93pe
 YKpJ3fnvH6KONH6yQqNVzTaG5kg7TEA5oPrDs5hNTLepavV0dso7xoXfMncFWoMGfRQE
 kH6Q==
X-Gm-Message-State: ACrzQf34gbsDzUjLiPrf8+n/Xg/ZgXpuT2Woftx/Jwpl47gxXgD92eKL
 dyPiNGbwtAuh66mnpcAHjVt44t8vZOdfQQ==
X-Google-Smtp-Source: AMsMyM78QjYWwhFLJE3RBK+mf1B8gSuLs5C2lsPiD6VXHdS7GXnjk0nvF1D3N60TEIuzwOsVYeu7OA==
X-Received: by 2002:a05:6512:1313:b0:49a:1194:bbab with SMTP id
 x19-20020a056512131300b0049a1194bbabmr9164791lfu.623.1663751380788; 
 Wed, 21 Sep 2022 02:09:40 -0700 (PDT)
Received: from localhost (80-62-117-68-mobile.dk.customer.tdc.net.
 [80.62.117.68]) by smtp.gmail.com with ESMTPSA id
 u24-20020ac24c38000000b0048afbe8a6a1sm340722lfq.241.2022.09.21.02.09.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Sep 2022 02:09:40 -0700 (PDT)
Date: Wed, 21 Sep 2022 11:09:38 +0200
From: Pankaj Raghav <pankydev8@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20220921090938.5o6yimq7vvl7ihpv@quentin>
References: <alpine.LRH.2.02.2209201350470.26058@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2209201358580.26535@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2209201358580.26535@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Thu, 22 Sep 2022 07:09:54 +0000
Subject: Re: [dm-devel] [PATCH v2 4/4] brd: implement secure erase and write
 zeroes
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Zdenek Kabelac <zkabelac@redhat.com>, Pankaj Raghav <p.raghav@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> @@ -330,7 +344,9 @@ static void brd_submit_bio(struct bio *b
>  	struct bio_vec bvec;
>  	struct bvec_iter iter;
>  
> -	if (bio_op(bio) == REQ_OP_DISCARD) {
> +	if (bio_op(bio) == REQ_OP_DISCARD ||
> +	    bio_op(bio) == REQ_OP_SECURE_ERASE ||
> +	    bio_op(bio) == REQ_OP_WRITE_ZEROES) {
>  		brd_do_discard(brd, bio);
>  		goto endio;
>  	}
> @@ -464,6 +480,8 @@ static int brd_alloc(int i)
>  	if (discard) {
>  		disk->queue->limits.discard_granularity = PAGE_SIZE;
>  		blk_queue_max_discard_sectors(disk->queue, UINT_MAX);
> +		blk_queue_max_write_zeroes_sectors(disk->queue, UINT_MAX);
> +		blk_queue_max_secure_erase_sectors(disk->queue, UINT_MAX);
>  	}
>  
The previous patch has the following description for the discard module
param:
MODULE_PARM_DESC(discard, "Support discard");

But you are reusing it here to enable write zeroes and sec erase.
MODULE_PARM_DESC's "desc" parameter also needs to be updated in this patch.

I understand that all these operations kind of do the same thing at the
end, so it is upto you to decide if you want to add individual module param
for each operation or club them together as you have done here. If you
do the latter, then changing the module param variable `discard` to
something more generic would give more clarity as well.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

