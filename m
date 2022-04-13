Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8DE3C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Apr 2022 01:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649815032;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c431kgwLVTTQ3/N5pVB+X4DSgn1w8ZFuQL513pu3rP0=;
	b=JmfHWNwCnY4/zhofh1+VznM1NYOZ8zUcZz4iGN4BhDiECQiyTZXFcQNNySjYHb5YA/Cr8D
	pZLdQbrPcdxXyEwR7KCv2OpuwCAPLk0X39BZG7rbXc9aKhiJJj2MDS6tXnL6D267Cby2+S
	MxBOmfCq/GaNqjs7YqxQMKdJB2XPsG4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-N4iDZsyIM3qIRA8MigP9tw-1; Tue, 12 Apr 2022 21:57:09 -0400
X-MC-Unique: N4iDZsyIM3qIRA8MigP9tw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E12FC82A682;
	Wed, 13 Apr 2022 01:57:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9449E1457F07;
	Wed, 13 Apr 2022 01:57:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 48B981949763;
	Wed, 13 Apr 2022 01:57:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1CB721947BBE
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Apr 2022 01:57:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C13FD2166BB3; Wed, 13 Apr 2022 01:57:05 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CB6B72166BA4;
 Wed, 13 Apr 2022 01:56:48 +0000 (UTC)
Date: Wed, 13 Apr 2022 09:56:42 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YlYt2rzM0NBPARVp@T590>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-6-ming.lei@redhat.com>
 <YlXmmB6IO7usz2c1@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YlXmmB6IO7usz2c1@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 5/8] dm: always setup ->orig_bio in alloc_io
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 12, 2022 at 04:52:40PM -0400, Mike Snitzer wrote:
> On Tue, Apr 12 2022 at  4:56P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > The current DM codes setup ->orig_bio after __map_bio() returns,
> > and not only cause kernel panic for dm zone, but also a bit ugly
> > and tricky, especially the waiting until ->orig_bio is set in
> > dm_submit_bio_remap().
> > 
> > The reason is that one new bio is cloned from original FS bio to
> > represent the mapped part, which just serves io accounting.
> > 
> > Now we have switched to bdev based io accounting interface, and we
> > can retrieve sectors/bio_op from both the real original bio and the
> > added fields of .sector_offset & .sectors easily, so the new cloned
> > bio isn't necessary any more.
> > 
> > Not only fixes dm-zone's kernel panic, but also cleans up dm io
> > accounting & split a bit.
> 
> You're conflating quite a few things here.  DM zone really has no
> business accessing io->orig_bio (dm-zone.c can just as easily inspect
> the tio->clone, because it hasn't been remapped yet it reflects the
> io->origin_bio, so there is no need to look at io->orig_bio) -- but
> yes I clearly broke things during the 5.18 merge and it needs fixing
> ASAP.

You can just consider the cleanup part of this patches, :-)

1) no late assignment of ->orig_bio, and always set it in alloc_io()

2) no waiting on on ->origi_bio, especially the waiting is done in
fast path of dm_submit_bio_remap().

3) no split for io accounting


Thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

