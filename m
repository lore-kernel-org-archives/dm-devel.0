Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3F02EB64DA
	for <dm-devel@archiver.kernel.org>; Thu, 20 Jul 2023 07:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689839462;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Q0n/Xk3wQoXrwKtxbE5UyrS9Tl3ZbdVTFRoOn0h/PpA=;
	b=dOtR1sOLlrWHl3TjCsTGqx8SDVe9AwCmD925PAJRJJWC7YPmRi8ohmJPsxyy7+NQ4mllBW
	3riw/a3tjNc2oWEH6/BACeB1OOHi57lCzIw1GTNzpPFSsIFrvxl9ozo9gipB3FVY8Erk0E
	hjlMPL19o3DK+Wxj+t7/Zkl62idiYxs=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-wjHKNR1XMO-Gd_jbtAnuWw-1; Thu, 20 Jul 2023 03:51:01 -0400
X-MC-Unique: wjHKNR1XMO-Gd_jbtAnuWw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0C6A3C0E446;
	Thu, 20 Jul 2023 07:50:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 81330C2C857;
	Thu, 20 Jul 2023 07:50:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 504B419465B9;
	Thu, 20 Jul 2023 07:50:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 06B4E1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Jul 2023 07:50:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D913A2166B26; Thu, 20 Jul 2023 07:50:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D08602166B25
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 07:50:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B22572834774
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 07:50:57 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-HbzpNqsdMuSN_xrLWs3gVA-1; Thu, 20 Jul 2023 03:50:55 -0400
X-MC-Unique: HbzpNqsdMuSN_xrLWs3gVA-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 7C7756732D; Thu, 20 Jul 2023 09:50:50 +0200 (CEST)
Date: Thu, 20 Jul 2023 09:50:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <20230720075050.GB5042@lst.de>
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184020epcas5p13fdcea52edead5ffa3fae444f923439e@epcas5p1.samsung.com>
 <20230627183629.26571-4-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230627183629.26571-4-nj.shetty@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v13 3/9] block: add emulation for copy
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
Cc: Vincent Fu <vincent.fu@samsung.com>, linux-doc@vger.kernel.org,
 djwong@kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, willy@infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> +static void *blkdev_copy_alloc_buf(sector_t req_size, sector_t *alloc_size,
> +		gfp_t gfp_mask)
> +{
> +	int min_size = PAGE_SIZE;
> +	void *buf;
> +
> +	while (req_size >= min_size) {
> +		buf = kvmalloc(req_size, gfp_mask);
> +		if (buf) {
> +			*alloc_size = req_size;
> +			return buf;
> +		}
> +		/* retry half the requested size */
> +		req_size >>= 1;
> +	}
> +
> +	return NULL;

Is there any good reason for using vmalloc instead of a bunch
of distcontiguous pages?

> +		ctx = kzalloc(sizeof(struct copy_ctx), gfp_mask);
> +		if (!ctx)
> +			goto err_ctx;

I'd suspect it would be better to just allocte a single buffer and
only have a single outstanding copy.  That will reduce the bandwith
you can theoretically get, but copies tend to be background operations
anyway.  It will reduce the required memory, and thus the chance for
this operation to fail on a loaded system.  It will also dramatically
reduce the effect on memory managment.

> +		read_bio = bio_map_kern(in, buf, buf_len, gfp_mask);
> +		if (IS_ERR(read_bio))
> +			goto err_read_bio;
> +
> +		write_bio = bio_map_kern(out, buf, buf_len, gfp_mask);
> +		if (IS_ERR(write_bio))
> +			goto err_write_bio;

bio_map_kern is only for passthrough I/Os.  You need to use
a bio_add_page loop here.

> index 336146798e56..f8c80940c7ad 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -562,4 +562,9 @@ struct cio {
>  	atomic_t refcount;
>  };
>  
> +struct copy_ctx {
> +	struct cio *cio;
> +	struct work_struct dispatch_work;
> +	struct bio *write_bio;
> +};

This is misnamed as it's only used by the fallback code, and also
should be private to blk-lib.c.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

