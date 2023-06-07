Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B799C87FDE
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206956;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=biZJ3mi1XukxCNjtsZf3r5NgvzsVeGW0oNZLnEd0kMM=;
	b=DjCkairs7kh2uR1io7S4PWsIrDpYBUCGY+ZG2F2TwikTBZuemirqGbaL3fDYWXtvo6bAZA
	IsTs8eHVwigu1oAH683xoNHGBQN9QPKSgPuI3g2Ag2Mtc0v6SEr5cNJf0EJJ3JghFv2alb
	yDBmmcEpIREnhYFl1WRVRX5oQGr/fHE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-vv9L9TI4PTOiyZswSR7V2Q-1; Thu, 08 Jun 2023 02:49:12 -0400
X-MC-Unique: vv9L9TI4PTOiyZswSR7V2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E742B381D4D1;
	Thu,  8 Jun 2023 06:49:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D5704FFE1;
	Thu,  8 Jun 2023 06:49:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B3EB919543A9;
	Thu,  8 Jun 2023 06:48:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 28FE019465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 12:47:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2EA8F492B00; Wed,  7 Jun 2023 12:47:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2629C48205E
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 12:47:18 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A50A85A5BA
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 12:47:18 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-JLPvBRqKOcG0dLtsgHg8qA-1; Wed, 07 Jun 2023 08:47:16 -0400
X-MC-Unique: JLPvBRqKOcG0dLtsgHg8qA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D614963EED;
 Wed,  7 Jun 2023 12:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F576C4339B;
 Wed,  7 Jun 2023 12:47:09 +0000 (UTC)
Date: Wed, 7 Jun 2023 14:47:06 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20230607-bekannt-sonnig-c881b3228862@brauner>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-29-hch@lst.de>
 <20230607-kocht-kornfeld-a249c6740e38@brauner>
 <20230607121658.GA13632@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230607121658.GA13632@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:45 +0000
Subject: Re: [dm-devel] [PATCH 28/31] block: replace fmode_t with a
 block-specific type for block open flags
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 07, 2023 at 02:16:58PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 07, 2023 at 11:21:14AM +0200, Christian Brauner wrote:
> > On Tue, Jun 06, 2023 at 09:39:47AM +0200, Christoph Hellwig wrote:
> > > The only overlap between the block open flags mapped into the fmode_t and
> > > other uses of fmode_t are FMODE_READ and FMODE_WRITE.  Define a new
> > 
> > and FMODE_EXCL afaict
> 
> FMODE_EXCL isn't used outside the block layer and removed in the last
> patch.
> 
> > > +blk_mode_t file_to_blk_mode(struct file *file)
> > > +{
> > > +	blk_mode_t mode = 0;
> > > +
> > > +	if (file->f_mode & FMODE_READ)
> > > +		mode |= BLK_OPEN_READ;
> > > +	if (file->f_mode & FMODE_WRITE)
> > > +		mode |= BLK_OPEN_WRITE;
> > > +	if (file->f_mode & FMODE_EXCL)
> > > +		mode |= BLK_OPEN_EXCL;
> > > +	if ((file->f_flags & O_ACCMODE) == 3)
> > 
> > I really don't like magic numbers like this.
> 
> I don't like them either, but this is just moved around and not new.
> 
> > Groan, O_RDONLY being defined as 0 strikes again...
> > Becuase of this quirk we internally map
> > 
> > O_RDONLY(0) -> FMODE_READ(1)
> > O_WRONLY(1) -> FMODE_WRITE(2)
> > O_RDWR(3)   -> (FMODE_READ | FMODE_WRITE)
> 
> O_RDWR is 2.

Yeah, that was a typo. See the other mail I sent right after:
https://lore.kernel.org/all/20230607-kribbeln-dilettanten-b901b57dd962@brauner

> 
> > so checking for the raw 3 here is confusing in addition to being a magic
> > number as it could give the impression that what's checked here is
> > (O_WRONLY | O_RDWR) which doesn't make sense...
> 
> Well, that is exactly what we check for.  This is a 30-ish year old
> quirk only used in the floppy driver.

Ugh, it's f_flags. I misread that as f_mode...

This is rather ugly. Then please, make it explicit and check for
== (O_WRONLY | O_RDWR) and leave a brief comment.

Anything's better than that raw 3 in there. We just had fun with
figuring out why there was a raw coredump in fs/coredump.c 30 years
later.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

