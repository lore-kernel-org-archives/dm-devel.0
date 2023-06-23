Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42B54EB64DD
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 05:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687499543;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=f1AKaV9uDnLJESrOJxbfwLItQOHcRtr335RR2mhY8Qs=;
	b=D0IKYGh51KAZs49TKS0cf4XPWpNg/pyg3pY7VWG1KaaCzMG3NQI9cEnHZByTe5TonPcQOG
	XRn62M9txIwjCsaPpokop9QiLj3JqZD5xtBa4HoLAC93mJtdmcXL86zOOLC12y2MNSeYGS
	CT5elYqvUOkDZ6x8Rfzz+AjSJMEJ/NY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-GJr5fb2OOiuaKM0gM8abEA-1; Fri, 23 Jun 2023 01:52:19 -0400
X-MC-Unique: GJr5fb2OOiuaKM0gM8abEA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4B4C8E44F7;
	Fri, 23 Jun 2023 05:52:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 30E7FF5AD6;
	Fri, 23 Jun 2023 05:52:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D402D1946588;
	Fri, 23 Jun 2023 05:52:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D905A1946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 05:52:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B899940C2070; Fri, 23 Jun 2023 05:52:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1C7340C2063
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 05:52:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 857971C08DBD
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 05:52:14 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-V0KVPcNNN8q6zPVV5-iCFQ-1; Fri, 23 Jun 2023 01:52:10 -0400
X-MC-Unique: V0KVPcNNN8q6zPVV5-iCFQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 8CFEC67373; Fri, 23 Jun 2023 07:52:05 +0200 (CEST)
Date: Fri, 23 Jun 2023 07:52:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20230623055205.GF9085@lst.de>
References: <20230621201237.796902-1-bvanassche@acm.org>
 <20230621201237.796902-8-bvanassche@acm.org>
MIME-Version: 1.0
In-Reply-To: <20230621201237.796902-8-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v4 7/7] block: Inline blk_mq_{,
 delay_}kick_requeue_list()
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
Cc: Jens Axboe <axboe@kernel.dk>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Mike Snitzer <snitzer@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Damien Le Moal <dlemoal@kernel.org>, Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Keith Busch <kbusch@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>,
 Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 21, 2023 at 01:12:34PM -0700, Bart Van Assche wrote:
> Patch "block: Preserve the order of requeued requests" changed
> blk_mq_kick_requeue_list() and blk_mq_delay_kick_requeue_list() into
> blk_mq_run_hw_queues() and blk_mq_delay_run_hw_queues() calls
> respectively. Inline blk_mq_{,delay_}kick_requeue_list() because these
> functions are now too short to keep these as separate functions.

You're not inlining them, but you're removing them and open code
the trivial logic in the callers.

The code change looks good to me, though.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

