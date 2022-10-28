Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF28C38A02
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198338;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Zmwl4ZWxUwU4J8DDqsKRiCi0+okrOhevVaSrRmgHfFk=;
	b=HNZ1rMkW5ojV8VXJWiqQp8Sp47GXayTLjmiW8xzAaFav0wo4DhqEKU+1fji2gCux05C8La
	Px/wXz143osuSWdcjaNSCNmcGCWZgw1NxH9Pj+yeGBdYPWGVPqgUnfQZrRkoNpixTbMiGm
	WL1MZjHp4kzTAT7f7h83AqTZua6xXHE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-eN4KU8nEPcOUHqztRdZc1A-1; Mon, 31 Oct 2022 02:38:57 -0400
X-MC-Unique: eN4KU8nEPcOUHqztRdZc1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5007C848558;
	Mon, 31 Oct 2022 06:38:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B603C50927;
	Mon, 31 Oct 2022 06:38:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7BE631947049;
	Mon, 31 Oct 2022 06:38:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 97B011946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 28 Oct 2022 16:38:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 519524A927C; Fri, 28 Oct 2022 16:38:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A58E4A9265
 for <dm-devel@redhat.com>; Fri, 28 Oct 2022 16:38:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F073800B30
 for <dm-devel@redhat.com>; Fri, 28 Oct 2022 16:38:44 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-ZyRKtnxlNLOHOOgPCSqFMw-1; Fri, 28 Oct 2022 12:38:42 -0400
X-MC-Unique: ZyRKtnxlNLOHOOgPCSqFMw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 01AC2B82B81;
 Fri, 28 Oct 2022 16:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3087C433D6;
 Fri, 28 Oct 2022 16:38:38 +0000 (UTC)
Date: Fri, 28 Oct 2022 10:38:36 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <Y1wFjHzza1QYTzdG@kbusch-mbp.dhcp.thefacebook.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-9-michael.christie@oracle.com>
 <Y1q6so/3Hx9GZmTz@kbusch-mbp.dhcp.thefacebook.com>
 <370e66bd-81d0-5451-850e-50a4172ed64f@oracle.com>
MIME-Version: 1.0
In-Reply-To: <370e66bd-81d0-5451-850e-50a4172ed64f@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: Re: [dm-devel] [PATCH v3 08/19] nvme: Move pr code to it's own file
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
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 28, 2022 at 11:06:29AM -0500, Mike Christie wrote:
> On 10/27/22 12:06 PM, Keith Busch wrote:
> > On Wed, Oct 26, 2022 at 06:19:34PM -0500, Mike Christie wrote:
> >> This patch moves the pr code to it's own file because I'm going to be
> >> adding more functions and core.c is getting bigger.
> >>
> >> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> > 
> > Good idea.
> 
> Credit goes to Chaitanya.
> 
> One question for you. I wasn't sure about the copyright. I saw
> you added the pr_ops code in 2015 when you were at Intel. Do you
> want me to add:
> 
> Copyright (c) 2015, Intel Corporation.
> 
> to the new pr.c file?

I think I was just the last person to touch the code, but it was mostly
developed elsewhere. So "no", don't bother propagating the (c).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

