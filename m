Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1EEC19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 07:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660029497;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rXHy4tMiKHjH8JeKy0/J903qDRZ15l6FXH6Onf2aZh0=;
	b=Tfdk1MwHUnrZYtrF3c4jPM+JpmbLk0rTcOntO+u1eWIR5/pO9sR4ihPiPnexmqWZTJYfAP
	aoiPzWCmpum4+1Wzact5w01Q4q+Ka0ps+76C1mQhSdIaX8FmX8r7BrKdZ0aCglINJKrOFJ
	PP+6VNhbZQBNqTOOrzqeLaVUAKIhRvs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-ERZPfGS7MBa63vI4W_76iw-1; Tue, 09 Aug 2022 03:18:14 -0400
X-MC-Unique: ERZPfGS7MBa63vI4W_76iw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5D6D1824602;
	Tue,  9 Aug 2022 07:18:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A484A40CF8EB;
	Tue,  9 Aug 2022 07:18:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 613091946A4C;
	Tue,  9 Aug 2022 07:18:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 687811946A4D
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 07:18:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4941A1415125; Tue,  9 Aug 2022 07:18:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 455AB140EBE3
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 07:18:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3218C8117B0
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 07:18:11 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-c8QjlPBJMjulr7teT-zuVA-1; Tue, 09 Aug 2022 03:18:06 -0400
X-MC-Unique: c8QjlPBJMjulr7teT-zuVA-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 082B068B05; Tue,  9 Aug 2022 09:18:04 +0200 (CEST)
Date: Tue, 9 Aug 2022 09:18:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20220809071803.GB11161@lst.de>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-17-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220809000419.10674-17-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v2 16/20] scsi: Have sd pr_ops return a
 blk_status_t
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
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com, bvanassche@acm.org,
 martin.petersen@oracle.com, snitzer@kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 08, 2022 at 07:04:15PM -0500, Mike Christie wrote:
> This patch has the sd pr_ops convert from the low level SCSI errors to a
> blk_status_t.

Can you document the why here?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

