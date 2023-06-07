Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD84C7EE23
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 07:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686124514;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=m/Ss6uXesd3zoW28y9Cul1AxAeR7uurwrtiYPixIiq0=;
	b=NauqMAVWJBkKecvUFzEkAFKLRC/VSDInHJnIWEEr7xAYIL1ig8XAqlckhN+ot+K506W0yT
	X1zItK55L2mbX33sHvm44CjE8KL9+UDTuHJ9Sw6qldB+BQEaMQOPu/mp/doKNzMU8uaNoM
	hmes637aG7blv+5OdkZUCC9I1Qni9m0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-toTo87pBNjCiJNdjVxwEMA-1; Wed, 07 Jun 2023 03:55:13 -0400
X-MC-Unique: toTo87pBNjCiJNdjVxwEMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12EA23815EEE;
	Wed,  7 Jun 2023 07:55:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD90B40D1B66;
	Wed,  7 Jun 2023 07:55:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 46E7519452C3;
	Wed,  7 Jun 2023 07:55:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF73319465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 07:55:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 61FB59E8B; Wed,  7 Jun 2023 07:55:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A7AA9E93
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 07:55:07 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C5411C07845
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 07:55:07 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-Mco4sMo7NJSVH0sNTtmuSA-1; Wed, 07 Jun 2023 03:55:03 -0400
X-MC-Unique: Mco4sMo7NJSVH0sNTtmuSA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat
 Linux)) id 1q6nLa-004gCI-2l; Wed, 07 Jun 2023 07:12:46 +0000
Date: Wed, 7 Jun 2023 00:12:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <ZIAt7vL+/isPJEl5@infradead.org>
References: <20230605121732.28468-1-nj.shetty@samsung.com>
 <CGME20230605122310epcas5p4aaebfc26fe5377613a36fe50423cf494@epcas5p4.samsung.com>
 <20230605121732.28468-6-nj.shetty@samsung.com>
 <ZH3mjUb+yqI11XD8@infradead.org>
 <20230606113535.rjbhe6eqlyqk4pqq@green245>
MIME-Version: 1.0
In-Reply-To: <20230606113535.rjbhe6eqlyqk4pqq@green245>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v12 5/9] nvme: add copy offload support
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
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 willy@infradead.org, Christoph Hellwig <hch@infradead.org>,
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 06, 2023 at 05:05:35PM +0530, Nitesh Shetty wrote:
> Downside will be duplicating checks which are present for read, write in
> block layer, device-mapper and zoned devices.
> But we can do this, shouldn't be an issue.

Yes.  Please never overload operations, this is just causing problems
everywhere, and that why I split the operations from the flag a few
years ago.

> The idea behind subsys is to prevent copy across different subsystem.
> For example, copy across nvme subsystem and the scsi subsystem. [1]
> At present, we don't support inter-namespace(copy across NVMe namespace),
> but after community feedback for previous series we left scope for it.

Never leave scope for something that isn't actually added.  That just
creates a giant maintainance nightmare.  Cross-device copies are giant
nightmare in general, and in the case of NVMe completely unusable
as currently done in the working group.  Messing up something that
is entirely reasonable (local copy) for something like that is a sure
way to never get this series in.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

