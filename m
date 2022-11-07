Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E96C4167B
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 09:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667812604;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wOos676sERGzYUjLfjbIuiDk3YwvbTdtFuTGZKN9M9k=;
	b=bIDE0159MSoxyLbRTo4NVJpCbiVYPAIYrX1Q4edBSXTH9dKnUhOgO4DTupnYKuOdLdVIro
	WYJsfQDNAgg3tMbPvOdz4lt6dzP4z8gFsVe7y23WPwultDG/e3p9QM1Rg78gzkxeJTg6I6
	aMeD/I3vwPosBfc2O2DiaQ7oHIbSER8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-wWt_HMZSN9iMGZMlvzU_Ew-1; Mon, 07 Nov 2022 04:16:41 -0500
X-MC-Unique: wWt_HMZSN9iMGZMlvzU_Ew-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EC0F185A79C;
	Mon,  7 Nov 2022 09:16:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0CD92492B05;
	Mon,  7 Nov 2022 09:16:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DFC381946588;
	Mon,  7 Nov 2022 09:16:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C1181946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Nov 2022 09:16:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1D9D82027064; Mon,  7 Nov 2022 09:16:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 167AB2027063
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 09:16:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED9BF101A54E
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 09:16:37 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-T9y4X60fOR2486gfCmu_hQ-1; Mon, 07 Nov 2022 04:16:35 -0500
X-MC-Unique: T9y4X60fOR2486gfCmu_hQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 50E4B67373; Mon,  7 Nov 2022 10:16:31 +0100 (CET)
Date: Mon, 7 Nov 2022 10:16:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20221107091631.GA3663@lst.de>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-13-michael.christie@oracle.com>
 <20221030082020.GC4774@lst.de>
 <a7e447b5-b26e-7aa0-ab6a-3463b8497d26@oracle.com>
 <20221101101511.GA13304@lst.de>
 <7762a877-9a5f-4dee-6dfc-c2e1fcb8a66a@oracle.com>
MIME-Version: 1.0
In-Reply-To: <7762a877-9a5f-4dee-6dfc-c2e1fcb8a66a@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, kbusch@kernel.org,
 Christoph Hellwig <hch@lst.de>, bvanassche@acm.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Nov 05, 2022 at 01:36:18PM -0500, Mike Christie wrote:
> Do you mean just doing this:

That would be the minimal fix.  We'd then still need to enumerate
the allowed positive return values and check noting else is returned.

I don't like the opt in in the other version.  The SCSI return values are
the defactor API, and we need to switch NVMe to align with it ASAP
instead of keeping the broken old version around.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

