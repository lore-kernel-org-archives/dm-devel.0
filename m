Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A69BC77B7A
	for <dm-devel@archiver.kernel.org>; Fri, 19 May 2023 04:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684471911;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zZY04BvoSk3wyq9ha2Q+SesZfgL1dhQOYHPPGh0ksQY=;
	b=GyEYQG83Thu1qbzGx7YzgPoL/8qacd304aGjYvyn4pcviZWqTtarHKH21l8cBQtWBZBfjG
	JA46hkl+59f9NMVstT0GARPN1FgEugZm7dKCRygMB9IXzPJJiS0iHSvUxPYd6TPVGirtOk
	uHf5XXNYMgw/GQeY0Vc8a0Q2xMBdeS0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-xVVwi4HxNXeqZYo5fjjoUQ-1; Fri, 19 May 2023 00:51:49 -0400
X-MC-Unique: xVVwi4HxNXeqZYo5fjjoUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E27C91854AED;
	Fri, 19 May 2023 04:51:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C982563F5F;
	Fri, 19 May 2023 04:51:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7241819465B2;
	Fri, 19 May 2023 04:51:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EAC9019465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 19 May 2023 04:51:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B19F22166B32; Fri, 19 May 2023 04:51:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A8C8E2166B31
 for <dm-devel@redhat.com>; Fri, 19 May 2023 04:51:43 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AC0A185A7A4
 for <dm-devel@redhat.com>; Fri, 19 May 2023 04:51:43 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-C3vgk8cENTi-wAgH0G1WDA-1; Fri, 19 May 2023 00:51:38 -0400
X-MC-Unique: C3vgk8cENTi-wAgH0G1WDA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat
 Linux)) id 1pzrQM-00F1NI-14; Fri, 19 May 2023 04:09:02 +0000
Date: Thu, 18 May 2023 21:09:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZGb2Xi6O3i2pLam8@infradead.org>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230518223326.18744-1-sarthakkukreti@chromium.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

FYI, I really don't think this primitive is a good idea.  In the
concept of non-overwritable storage (NAND, SMR drives) the entire
concept of a one-shoot 'provisioning' that will guarantee later writes
are always possible is simply bogus.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

