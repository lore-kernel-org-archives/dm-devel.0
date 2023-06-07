Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72FCAC87FDE
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206937;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fZohwcOeGdRVYYvvTEO6r+lZ8+9zzBVLlCy/4Qh1c+w=;
	b=YrI/K49y1xfrRMtF0HkvszbPDFbd3zapfLS1WtujgA9ZGcWJRi01iJnckmc5qfKXLC6FMi
	zYBk+kLACkQI6jAkxUgZtXGGkCJNJIyT39freTWmW9v8/9FczG9oNzlEGMGx7ieCsCDiGx
	qDnPRvfr/Vv77E97ZNkfnGVt3La5b5s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-QxCFdiyWM5yg2ryHCjX1Hg-1; Thu, 08 Jun 2023 02:48:54 -0400
X-MC-Unique: QxCFdiyWM5yg2ryHCjX1Hg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED4748582B6;
	Thu,  8 Jun 2023 06:48:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DAAF62026D6A;
	Thu,  8 Jun 2023 06:48:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B9E519451D5;
	Thu,  8 Jun 2023 06:48:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ADF3F19465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 09:27:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9971F40218C; Wed,  7 Jun 2023 09:27:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 90D9F492B00
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:27:56 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A4EE1C02D33
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 09:27:56 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-8wZvueytOymhRZ-shccJzQ-1; Wed, 07 Jun 2023 05:27:54 -0400
X-MC-Unique: 8wZvueytOymhRZ-shccJzQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id F296A6242E;
 Wed,  7 Jun 2023 09:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5FAC433EF;
 Wed,  7 Jun 2023 09:27:47 +0000 (UTC)
Date: Wed, 7 Jun 2023 11:27:45 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20230607-erwandern-posen-d5d15c9c2444@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606-raumtemperatur-languste-045c5472f6a0@brauner>
 <20230606084042.GA30379@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230606084042.GA30379@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:45 +0000
Subject: Re: [dm-devel] decouple block open flags from fmode_t
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 06, 2023 at 10:40:42AM +0200, Christoph Hellwig wrote:
> On Tue, Jun 06, 2023 at 10:27:14AM +0200, Christian Brauner wrote:
> > On Tue, Jun 06, 2023 at 09:39:19AM +0200, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > this series adds a new blk_mode_t for block open flags instead of abusing
> > 
> > Trying to look at this series applied but doesn't apply cleanly for
> > anything v6.4-rc* related. What tree is this on?
> 
> Jens' for-6.5/block tree.
> 
> I also have a git tree here:
> 
>     git://git.infradead.org/users/hch/block.git blk-open-release
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/blk-open-release


Thanks! I pulled from your tree.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

