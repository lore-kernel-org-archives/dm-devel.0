Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A2A0EB64DD
	for <dm-devel@archiver.kernel.org>; Thu, 20 Jul 2023 08:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689840085;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iP1Lhqk6G7/qahAKaWJgzU1DcgWRDOn2WwZRD6DcdtA=;
	b=Rp9aS7Rw/ADCsZpRghnm8yaLcNHSUUi9fDLqPYwTT7qru3yPMhfxxykHI6jK7OI5Oteq5F
	c9dPyzwRamtk0TiQu//zCAacd4mNPa3+mhU7mXIrFYDvZPROSOqAEcuENUoiFUKkT/oXgt
	5s7WwTSgq4uzdtfosykgAw3vExkVsGg=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-oSZ20hanNwanDDHf4PNiVA-1; Thu, 20 Jul 2023 04:01:22 -0400
X-MC-Unique: oSZ20hanNwanDDHf4PNiVA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC47C282380F;
	Thu, 20 Jul 2023 08:01:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D32DA4A9004;
	Thu, 20 Jul 2023 08:01:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A1D021946A6D;
	Thu, 20 Jul 2023 08:01:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8112919451F8
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Jul 2023 08:00:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 61766F6CD5; Thu, 20 Jul 2023 08:00:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 59018F77AD
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 08:00:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DD621C28098
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 08:00:34 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-9AqcbsEuPfSANrdsSRGdpg-1; Thu, 20 Jul 2023 04:00:30 -0400
X-MC-Unique: 9AqcbsEuPfSANrdsSRGdpg-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 98BAB6732D; Thu, 20 Jul 2023 10:00:26 +0200 (CEST)
Date: Thu, 20 Jul 2023 10:00:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <20230720080026.GB6246@lst.de>
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184039epcas5p2decb92731d3e7dfdf9f2c05309a90bd7@epcas5p2.samsung.com>
 <20230627183629.26571-6-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230627183629.26571-6-nj.shetty@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v13 5/9] nvme: add copy offload support
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
 nitheshshetty@gmail.com, willy@infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, Kanchan Joshi <joshi.k@samsung.com>,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> +	if (blk_rq_nr_phys_segments(req) != 2)
> +		return BLK_STS_IOERR;

The magic number of segments adding up source and dest really need
constants and helpers to make the code understandable.

> +	/* +1 shift as dst+src length is added in request merging, we send copy
> +	 * for half the length.
> +	 */
> +	n_lba = blk_rq_bytes(req) >> (ns->lba_shift + 1);

I do not understand the logic and comment here.

> +	if (WARN_ON(!n_lba))

WARN_ON_ONCE

> +		return BLK_STS_NOTSUPP;

and BLK_STS_NOTSUPP seems like the wrong error here, this is an
invalid argument.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

