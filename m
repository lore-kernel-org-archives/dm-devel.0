Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5536C19F2D
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 07:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660029640;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cHo/gSTgQDpSzeOZkJ6AkpQqaNX0QTN22XMAo0LZjxU=;
	b=QVk5yKaOxrkhV3dg78vkn70ZfH9WWm+1cnQViY7XJn7ah9yOSOE6ummSAeTdh5gHUqugTD
	bNVBCCJaAUvZyMpLI7B2X3DL/mfJ1KEkT4Tqs3YIi5nVBPAWFikKuKB6BlGUac5F8aiS9b
	oW+J/Ke1blx6ALEW4XN4Kc6hXF6yhMw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-FP9kLFPpMRa_hDqEDE4rig-1; Tue, 09 Aug 2022 03:20:37 -0400
X-MC-Unique: FP9kLFPpMRa_hDqEDE4rig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5DE185A58A;
	Tue,  9 Aug 2022 07:20:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 957672026D4C;
	Tue,  9 Aug 2022 07:20:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 62CCE1946A54;
	Tue,  9 Aug 2022 07:20:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 64A8F1946A44
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 07:20:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5719394585; Tue,  9 Aug 2022 07:20:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 53A659457F
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 07:20:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C82D3801162
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 07:20:34 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-XxS_KGBPM9yK-Dmk__hFZQ-1; Tue, 09 Aug 2022 03:20:32 -0400
X-MC-Unique: XxS_KGBPM9yK-Dmk__hFZQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 8814668C4E; Tue,  9 Aug 2022 09:20:29 +0200 (CEST)
Date: Tue, 9 Aug 2022 09:20:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20220809072029.GE11161@lst.de>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-9-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220809000419.10674-9-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 08/20] nvme: Add helper to convert to a
 pr_ops PR type
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 08, 2022 at 07:04:07PM -0500, Mike Christie wrote:
> This adds a helper to go from the NVMe spec PR type value to the block
> layer pr_type, so for Reservation Report support we can convert from its
> value.

Without a user this is going to create a compiler warning.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

