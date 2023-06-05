Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E649DC7EE23
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685977387;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=d/vQd490jIQDGTe75BdyIQs5Q6dY6/fDZs8VCmgFY38=;
	b=WKqWGMTKJhHo2vt5X2I8sqLYN0gx8Gsy+wxxfKVMhkD8FO0gfAIiGw8UutJ4j+x181CF+V
	U+a/ivgfn4WAUyGRMOmYFl+mUdCQWp9nh8gigb4XYOXYdjGgGXDQx+M0dsDIuDgcsX/Mrh
	bvp59iQkqvwYSTVLwfDHnS1wksep1Q4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-Xu_Glo2vNsi1Q2UleWLJig-1; Mon, 05 Jun 2023 11:02:20 -0400
X-MC-Unique: Xu_Glo2vNsi1Q2UleWLJig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35B32810BDD;
	Mon,  5 Jun 2023 15:01:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 92BD52166B25;
	Mon,  5 Jun 2023 15:01:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 66F3719465A3;
	Mon,  5 Jun 2023 15:01:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F15C11946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 15:01:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 97C969E8B; Mon,  5 Jun 2023 15:01:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 90CBA9E72
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 15:01:14 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 735763C0C8AA
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 15:01:14 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-6zmDBr0UNrybhNmR8L83Yg-1; Mon, 05 Jun 2023 11:01:12 -0400
X-MC-Unique: 6zmDBr0UNrybhNmR8L83Yg-1
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat
 Linux)) id 1q6AUn-00FeYT-1D; Mon, 05 Jun 2023 13:43:41 +0000
Date: Mon, 5 Jun 2023 06:43:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <ZH3mjUb+yqI11XD8@infradead.org>
References: <20230605121732.28468-1-nj.shetty@samsung.com>
 <CGME20230605122310epcas5p4aaebfc26fe5377613a36fe50423cf494@epcas5p4.samsung.com>
 <20230605121732.28468-6-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230605121732.28468-6-nj.shetty@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v12 5/9] nvme: add copy offload support
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
Cc: linux-doc@vger.kernel.org, djwong@kernel.org,
 linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 willy@infradead.org, Chaitanya Kulkarni <kch@nvidia.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Mike Snitzer <snitzer@kernel.org>,
 ming.lei@redhat.com, linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, Kanchan Joshi <joshi.k@samsung.com>,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>  		break;
>  	case REQ_OP_READ:
> -		ret = nvme_setup_rw(ns, req, cmd, nvme_cmd_read);
> +		if (unlikely(req->cmd_flags & REQ_COPY))
> +			nvme_setup_copy_read(ns, req);
> +		else
> +			ret = nvme_setup_rw(ns, req, cmd, nvme_cmd_read);
>  		break;
>  	case REQ_OP_WRITE:
> -		ret = nvme_setup_rw(ns, req, cmd, nvme_cmd_write);
> +		if (unlikely(req->cmd_flags & REQ_COPY))
> +			ret = nvme_setup_copy_write(ns, req, cmd);
> +		else
> +			ret = nvme_setup_rw(ns, req, cmd, nvme_cmd_write);

Yikes.  Overloading REQ_OP_READ and REQ_OP_WRITE with something entirely
different brings us back the horrors of the block layer 15 years ago.
Don't do that.  Please add separate REQ_COPY_IN/OUT (or maybe
SEND/RECEIVE or whatever) methods.

> +	/* setting copy limits */
> +	if (blk_queue_flag_test_and_set(QUEUE_FLAG_COPY, q))

I don't understand this comment.

> +struct nvme_copy_token {
> +	char *subsys;
> +	struct nvme_ns *ns;
> +	sector_t src_sector;
> +	sector_t sectors;
> +};

Why do we need a subsys token?  Inter-namespace copy is pretty crazy,
and not really anything we should aim for.  But this whole token design
is pretty odd anyway.  The only thing we'd need is a sequence number /
idr / etc to find an input and output side match up, as long as we
stick to the proper namespace scope.

> +	if (unlikely((req->cmd_flags & REQ_COPY) &&
> +				(req_op(req) == REQ_OP_READ))) {
> +		blk_mq_start_request(req);
> +		return BLK_STS_OK;
> +	}

This really needs to be hiden inside of nvme_setup_cmd.  And given
that other drivers might need similar handling the best way is probably
to have a new magic BLK_STS_* value for request started but we're
not actually sending it to hardware.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

