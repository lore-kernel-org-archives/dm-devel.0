Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5650FC433F5
	for <dm-devel@archiver.kernel.org>; Sat, 23 Apr 2022 16:55:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-iDfJ6PTuNv2M_x2x56hQWw-1; Sat, 23 Apr 2022 12:55:43 -0400
X-MC-Unique: iDfJ6PTuNv2M_x2x56hQWw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A2B829AA386;
	Sat, 23 Apr 2022 16:55:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1F8CC28109;
	Sat, 23 Apr 2022 16:55:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 48BA41947BBC;
	Sat, 23 Apr 2022 16:55:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1D0A419451F1
 for <dm-devel@listman.corp.redhat.com>; Sat, 23 Apr 2022 16:55:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EBA8840D017E; Sat, 23 Apr 2022 16:55:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E7AD640D017A
 for <dm-devel@redhat.com>; Sat, 23 Apr 2022 16:55:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF37C800882
 for <dm-devel@redhat.com>; Sat, 23 Apr 2022 16:55:35 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-cYuJGKq6NI-gk8dbF0YArQ-1; Sat, 23 Apr 2022 12:55:33 -0400
X-MC-Unique: cYuJGKq6NI-gk8dbF0YArQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1niJ2f-004gEs-Hx; Sat, 23 Apr 2022 16:55:29 +0000
Date: Sat, 23 Apr 2022 09:55:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <YmQvgdqHlsQVpxR+@infradead.org>
References: <YkSK6mU1fja2OykG@redhat.com> <YkRM7Iyp8m6A1BCl@fedora>
 <YkUwmyrIqnRGIOHm@infradead.org> <YkVBjUy9GeSMbh5Q@fedora>
 <YkVxLN9p0t6DI5ie@infradead.org> <YlBX+ytxxeSj2neQ@redhat.com>
 <YlEWfc39+H+esrQm@infradead.org> <YlReKjjWhvTZjfg/@redhat.com>
 <YlRiUVFK+a0DwQhu@redhat.com> <YlRmhlL8TtQow0W0@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YlRmhlL8TtQow0W0@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] block: remove redundant blk-cgroup init from
 __bio_clone
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
Cc: axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
 Dennis Zhou <dennis@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

So while I'm still diving into the somewhat invasive changes to
optimize some of the cloning all we might relaly need for your
use case should be this:

http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/blk-clone-no-bdev

Can you check if this helps you?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

