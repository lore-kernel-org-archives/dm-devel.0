Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F96CFA3742
	for <dm-devel@archiver.kernel.org>; Sun, 30 Oct 2022 08:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667118029;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+E9jTrxx59mi2LBNz7l+WYlZ4GTAr1to8yTT8ekwkJ4=;
	b=J7C2nF7njvDVGHzO94maBQ8NHWNYmaGUJ3ACP0Tip+oijpKzBA7tu0hh3j331R5+a5brtP
	TkSJbC4vU4ETAQxUp6RZg3G45scLOjnPZqFKbvnN7ub0FaoP7cQtyoO8O9mLUb/0p1IfV1
	1EiZzmKQL1RD7GpA1nyMeRMWisryiAM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-p7dD6uHkPgSx_m37s8yTmw-1; Sun, 30 Oct 2022 04:20:28 -0400
X-MC-Unique: p7dD6uHkPgSx_m37s8yTmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D374101A588;
	Sun, 30 Oct 2022 08:20:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 598052027062;
	Sun, 30 Oct 2022 08:20:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 23F1E1946587;
	Sun, 30 Oct 2022 08:20:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 497CE1946586
 for <dm-devel@listman.corp.redhat.com>; Sun, 30 Oct 2022 08:20:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 39DD84A927F; Sun, 30 Oct 2022 08:20:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 321664A927D
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 08:20:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B679800B30
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 08:20:25 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-496mdRxLO9eqHyOnJqhOfQ-1; Sun, 30 Oct 2022 04:20:23 -0400
X-MC-Unique: 496mdRxLO9eqHyOnJqhOfQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id B1D8968AA6; Sun, 30 Oct 2022 09:20:20 +0100 (CET)
Date: Sun, 30 Oct 2022 09:20:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20221030082020.GC4774@lst.de>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-13-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20221026231945.6609-13-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v3 12/19] block, nvme, scsi,
 dm: Add blk_status to pr_ops callouts
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, chaitanyak@nvidia.com,
 bvanassche@acm.org, linux-scsi@vger.kernel.org, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, martin.petersen@oracle.com,
 kbusch@kernel.org, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 26, 2022 at 06:19:38PM -0500, Mike Christie wrote:
> To handle both cases and keep userspace compatibility, this patch adds a
> blk_status_t arg to the pr_ops callouts. The lower levels will convert
> their device specific error to the blk_status_t then the upper levels
> can easily check that code without knowing the device type. Adding the
> extra return value will then allow us to not break userspace which expects
> a negative -Exyz error code if the command fails before it's sent to the
> device or a device/driver specific value if the error is > 0.

I really hate this double error return.  What -E* statuses that matter
can be returned without a BLK_STS_* equivalent that we couldn't convert
to and from?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

