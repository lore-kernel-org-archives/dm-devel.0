Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FEE7FA373D
	for <dm-devel@archiver.kernel.org>; Sun, 30 Oct 2022 08:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667117521;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/5GTNFKY9V4ZKG2X4V/EN9IV1YbDmECNEcucUVF1kX4=;
	b=X2rVdaPF92CuJ67K+pIdHfkPI4/WBRJP/XmwQgRcdJP1WB3PwpHHcdZC1vF7ZB0iPiogXz
	LG0O0yzlDSKFckas4S2Oo/WvK0Kybjqh4pxWWQhXbH3r0GhQg+E2DNnn1Zug93Wr9tyoTk
	AacEZ/M9+IuOoeo5oh5a2BbKwv4FkIs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-qgngf_xJNHmmIrOouFYsXA-1; Sun, 30 Oct 2022 04:11:57 -0400
X-MC-Unique: qgngf_xJNHmmIrOouFYsXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 725FB299E77A;
	Sun, 30 Oct 2022 08:11:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 648DA1415102;
	Sun, 30 Oct 2022 08:11:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 09D771946587;
	Sun, 30 Oct 2022 08:11:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 09DBD1946586
 for <dm-devel@listman.corp.redhat.com>; Sun, 30 Oct 2022 08:11:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C1BCD1410F38; Sun, 30 Oct 2022 08:11:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BAC7B140EBF3
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 08:11:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3E44185A792
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 08:11:49 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-qzNjbWlJMFyew3y8rwyqCg-1; Sun, 30 Oct 2022 04:11:46 -0400
X-MC-Unique: qzNjbWlJMFyew3y8rwyqCg-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id F009F68AFE; Sun, 30 Oct 2022 09:06:32 +0100 (CET)
Date: Sun, 30 Oct 2022 09:06:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Message-ID: <20221030080632.GI4214@lst.de>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-9-michael.christie@oracle.com>
 <Y1q6so/3Hx9GZmTz@kbusch-mbp.dhcp.thefacebook.com>
 <370e66bd-81d0-5451-850e-50a4172ed64f@oracle.com>
 <Y1wFjHzza1QYTzdG@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
In-Reply-To: <Y1wFjHzza1QYTzdG@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, hch@lst.de,
 Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 28, 2022 at 10:38:36AM -0600, Keith Busch wrote:
> I think I was just the last person to touch the code, but it was mostly
> developed elsewhere. So "no", don't bother propagating the (c).

You actually did write the PR ops code.  I wrote the core and SCSI
side, and you added NVMe.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

