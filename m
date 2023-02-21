Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D13BC61DA3
	for <dm-devel@archiver.kernel.org>; Tue, 21 Feb 2023 23:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677023950;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SMYMpVjobKymLF5G9Cbe3d+Tc+dUK2HED1QGAz+vfT8=;
	b=UpPQcpZ8g8wO+R454haf8vJeIEMNNwHxCfYPyvcE5m5LTmjHHrkTQftkGXRS0Bxa6UFmH3
	cg73K3+5BdfmFuxNSjaZARbUJckF10dXq60hnF3Wd1LUizD2XXivkSJg7vootdL1NMkosA
	cMOto5TlJZ8JJCvvR1UIDjl6JpoQ7bs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-8HXosnzUNnq74cBBXH-kCQ-1; Tue, 21 Feb 2023 18:59:06 -0500
X-MC-Unique: 8HXosnzUNnq74cBBXH-kCQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCAF9803481;
	Tue, 21 Feb 2023 23:59:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED23A2166B26;
	Tue, 21 Feb 2023 23:59:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00C351946588;
	Tue, 21 Feb 2023 23:58:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 08D121946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 21 Feb 2023 23:58:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 97D37492B01; Tue, 21 Feb 2023 23:58:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 901E2492B00
 for <dm-devel@redhat.com>; Tue, 21 Feb 2023 23:58:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74885101A52E
 for <dm-devel@redhat.com>; Tue, 21 Feb 2023 23:58:44 +0000 (UTC)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-351-JIyBX1SJP86Scv48Djk9Ew-1; Tue, 21 Feb 2023 18:58:38 -0500
X-MC-Unique: JIyBX1SJP86Scv48Djk9Ew-1
Received: by mail-pj1-f45.google.com with SMTP id x34so3485635pjj.0;
 Tue, 21 Feb 2023 15:58:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=kxYAOATXwwZXmQtvACIiPy5oHqnMX7B0skEyunTy3sc=;
 b=a0UderLZWaEK1tBk+U7Mm8VF/Y2oVW68+GyN/nbnVVZnK5uj0PSjrVSnQa7YaJGp+U
 skih7Hde4jyccHod41f0XL5qqMN85c4WwSeGP1nUKbsBWsja3WshhtvxpzC4qpHY5ST5
 3A89O/zvb5FhWTePqUWFPr02S8vS3wc0JwHR21C8bugnp1igk0hQfSjv5e1K2RMJQDQn
 8XJAfbSKvX13VVkk/q+HAX/JZZaJEWY5xNfkQta8fXYmKdXfDBkeOSX0TCznIA69ufBw
 iSmyfpsBKmpIgP2xcchiP9miZEGOhqjUU33zDueaCmeHtO57buhvC536hKu9EXN3G8dG
 hM5A==
X-Gm-Message-State: AO0yUKWQOm01pkL62dqMSi0gxvBqEveZc0XLWZ0NtoAdjq/XcyaduwOs
 iYxDd8IW50vMyvLOXoPe6bA=
X-Google-Smtp-Source: AK7set8mA8AovJsVEgiRILnqsy5kyIIpZuG+CasVxypbtihvOZT+c/1ugL7OC3W+zb8/8oWG2s3pAA==
X-Received: by 2002:a17:903:28c4:b0:19b:c3e:6e61 with SMTP id
 kv4-20020a17090328c400b0019b0c3e6e61mr7453237plb.68.1677023916448; 
 Tue, 21 Feb 2023 15:58:36 -0800 (PST)
Received: from minwoo-desktop ([1.237.94.73]) by smtp.gmail.com with ESMTPSA id
 q16-20020a170902dad000b00189ac5a2340sm6126741plx.124.2023.02.21.15.58.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Feb 2023 15:58:36 -0800 (PST)
Date: Wed, 22 Feb 2023 08:58:28 +0900
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <Y/VapDeE98+A6/G2@minwoo-desktop>
References: <20230220105336.3810-1-nj.shetty@samsung.com>
 <CGME20230220105441epcas5p49ffde763aae06db301804175e85f9472@epcas5p4.samsung.com>
 <20230220105336.3810-3-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230220105336.3810-3-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v7 2/8] block: Add copy offload support
 infrastructure
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
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, anuj20.g@samsung.com,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>, joshi.k@samsung.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 damien.lemoal@opensource.wdc.com, Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> +/*
> + * @bdev_in:	source block device
> + * @pos_in:	source offset
> + * @bdev_out:	destination block device
> + * @pos_out:	destination offset

@len is missing here.

> + * @end_io:	end_io function to be called on completion of copy operation,
> + *		for synchronous operation this should be NULL
> + * @private:	end_io function will be called with this private data, should be
> + *		NULL, if operation is synchronous in nature
> + * @gfp_mask:   memory allocation flags (for bio_alloc)
> + *
> + * Returns the length of bytes copied or a negative error value
> + *
> + * Description:
> + *	Copy source offset from source block device to destination block
> + *	device. length of a source range cannot be zero. Max total length of
> + *	copy is limited to MAX_COPY_TOTAL_LENGTH
> + */
> +int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
> +		      struct block_device *bdev_out, loff_t pos_out, size_t len,
> +		      cio_iodone_t end_io, void *private, gfp_t gfp_mask)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

