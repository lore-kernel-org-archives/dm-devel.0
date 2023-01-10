Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB8DFC54EBE
	for <dm-devel@archiver.kernel.org>; Tue, 10 Jan 2023 06:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673333795;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Y2W0ltHGsgP/knK09T8a2YJGYHNvZF53zY6VCcvndaE=;
	b=UCzZHxKbm6PT50L8vOcNr27vGPgAmSrSnqYhuzEMsR6ML6RQbhvuHoY5X04GBBdmpRLH2R
	qOnaRpeVEnbXa+mcpCZshsL4pHIjGOPjcDb3YB+Ly2CBpjvuF7v6VnOcPyI6giCqUb4Bwn
	xO8db055lKC/6QKUhqMlc62crdbKubo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-TJVnhsYZMEGLU0HAB2Dyaw-1; Tue, 10 Jan 2023 01:56:32 -0500
X-MC-Unique: TJVnhsYZMEGLU0HAB2Dyaw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AD0D2999B37;
	Tue, 10 Jan 2023 06:56:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AC6F492C18;
	Tue, 10 Jan 2023 06:56:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 305001949751;
	Tue, 10 Jan 2023 06:56:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E11A01946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 Jan 2023 06:56:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C0D29492C18; Tue, 10 Jan 2023 06:56:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B981C492C14
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 06:56:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A203C3806624
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 06:56:28 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-Vc-GsJYIOmqT3OqyZElPpg-1; Tue, 10 Jan 2023 01:56:26 -0500
X-MC-Unique: Vc-GsJYIOmqT3OqyZElPpg-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 2E03868C4E; Tue, 10 Jan 2023 07:56:24 +0100 (CET)
Date: Tue, 10 Jan 2023 07:56:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <20230110065623.GD10289@lst.de>
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083322eucas1p2414f1f7f121fbbd7a0e5e1b1b622f5c0@eucas1p2.samsung.com>
 <20230106083317.93938-6-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230106083317.93938-6-p.raghav@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 5/7] dm-zoned: ensure only power of 2 zone
 sizes are allowed
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
Cc: axboe@kernel.dk, bvanassche@acm.org, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, hch@lst.de,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Given that we don't even support the non pow of 2 zones in the block
layer I don't see why this is needed.  But either way it doesn't really
seem to fit into this series.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

