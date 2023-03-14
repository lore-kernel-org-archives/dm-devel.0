Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2544CC7618A
	for <dm-devel@archiver.kernel.org>; Tue, 14 Mar 2023 17:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678815075;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TGlcSEqEIL1EDxsXbs/ckRiB9z564Lx99dSDrA9J7kk=;
	b=TlKBxq09GzAZhJRklt5ytT8Ogxx81IvyZY3hIzeMlfms1LENObAUrmSp0eIHxgQACyQQ81
	z2YCeyHqZybPM4im/mWIzoJY3RcWxcjzQKa4ZGJwpx/9rnV/iXzDWoUcDosYWQI9Vhea8s
	KOeOMWgV/KwibdKh7626pnBGmLLKQXo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-X9YHmSPBMKmChLGcBcD4Rw-1; Tue, 14 Mar 2023 13:31:13 -0400
X-MC-Unique: X9YHmSPBMKmChLGcBcD4Rw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97C65857F4D;
	Tue, 14 Mar 2023 17:31:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A1D4492B00;
	Tue, 14 Mar 2023 17:31:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14FE019465A2;
	Tue, 14 Mar 2023 17:31:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EA9FC19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Mar 2023 17:31:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B09A9C158C2; Tue, 14 Mar 2023 17:31:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A9433C15A0B
 for <dm-devel@redhat.com>; Tue, 14 Mar 2023 17:31:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DB2F101A52E
 for <dm-devel@redhat.com>; Tue, 14 Mar 2023 17:31:09 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-Ixlmpou2NLqc123WhH72uw-1; Tue, 14 Mar 2023 13:31:04 -0400
X-MC-Unique: Ixlmpou2NLqc123WhH72uw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 722B4B81AA0;
 Tue, 14 Mar 2023 17:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BF9C4339B;
 Tue, 14 Mar 2023 17:31:01 +0000 (UTC)
Date: Tue, 14 Mar 2023 11:30:59 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZBCvU0ldBvvTqz+y@kbusch-mbp.dhcp.thefacebook.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-10-michael.christie@oracle.com>
 <20230314171322.GE6780@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230314171322.GE6780@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v4 09/18] nvme: Move pr code to it's own file
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
 Chaitanya Kulkarni <kch@nvidia.com>, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, snitzer@kernel.org, linux-nvme@lists.infradead.org,
 james.bottomley@hansenpartnership.com, dm-devel@redhat.com,
 target-devel@vger.kernel.org, martin.petersen@oracle.com,
 Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 14, 2023 at 06:13:22PM +0100, Christoph Hellwig wrote:
> > +++ b/drivers/nvme/host/pr.c
> > @@ -0,0 +1,155 @@
> > +// SPDX-License-Identifier: GPL-2.0
> 
> I'd feel much more comfortable if we had a copyright notice code
> here.  This code was written by Keith, maybe he can help to fill
> in what the proper notice should be?

Okay, this was initially introduced with 1d277a637a711a while employed with
Intel, so let's add for the history:

/*
 * Copyright (c) 2015 Intel Corporation 
 *	Keith Busch <kbusch@kernel.org>
 */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

