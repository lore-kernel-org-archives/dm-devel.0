Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0408C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 21:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686259501;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tMQq21SJiT0N1SfMyt6i8bDmgyM0hxLep/86N5c/9JQ=;
	b=gAIG1d9JvfHHjhRZ4IOg/vRbyOaIzhITDvNzNJK98dxKjTrk5NHjex6/nrWXQFmIT2ESFA
	QYwCnV1GAzd3Iaoq/1PTXJsO5HUqeBpLz1qNMGbQmdOmMQCRwajRM1frd1JZTjPrNzqLtQ
	fm4WN/8DmUcUDcSupY+4OCU2pZEuSN0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-YS-o-Mh-PcOaD1dXceBXkw-1; Thu, 08 Jun 2023 17:24:57 -0400
X-MC-Unique: YS-o-Mh-PcOaD1dXceBXkw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AC18185A792;
	Thu,  8 Jun 2023 21:24:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 90CC140CFD46;
	Thu,  8 Jun 2023 21:24:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 30F7B19451C0;
	Thu,  8 Jun 2023 21:24:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E2CB194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 21:24:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6BD742166B26; Thu,  8 Jun 2023 21:24:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6445C2166B25
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 21:24:51 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47EC129AA3BC
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 21:24:51 +0000 (UTC)
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com
 [209.85.222.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-Q6jBgX9HM7aV4u0CNUYNfg-1; Thu, 08 Jun 2023 17:24:49 -0400
X-MC-Unique: Q6jBgX9HM7aV4u0CNUYNfg-1
Received: by mail-qk1-f178.google.com with SMTP id
 af79cd13be357-75d4a4cf24aso97757485a.1
 for <dm-devel@redhat.com>; Thu, 08 Jun 2023 14:24:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686259489; x=1688851489;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=liAgCM+QUjk8WKzG6uC2H2ST/koBGGcMOvClrIQqatc=;
 b=afpcrFAFraxkHbIp8IEU4Z7FpXhjCnHEMe82bvNSetAmKdtDmCfAh8Tad6FthFH4XP
 tFH02FjhfwqGlumV+TpMKbid+pHt3/iSB+hH+4AMnopw21y/ZlOXCeDBqy0uMLRnxtIv
 GCrqxdYfMh4T/wnkoEdwinN/Xd3Xfe9QbXI6X8Cn1uvhBF3zwoJRW6zAGtAtuDMs98Rz
 cg/T4cNt56b5azqJpZRHk3Un9WB01LIFGQNvaTEpp41uN+Ypm7k/tHSc+2DZXRYLC7E2
 CFb/wsn/bQZlmFbUDhzmAxpiLC2nWmOFkNPAebkvI0r/RuanM879ZVn0dcBS1zEUtURs
 sFDw==
X-Gm-Message-State: AC+VfDymOD/RCxtG55YQaXM+EZWpyk9IoH+VRFGkuvb68Oxh9uuxnhsS
 3PLkN9N/i2EaI6nXqLcqIRBMWNY=
X-Google-Smtp-Source: ACHHUZ5cTCLmtiiH2aSe8aPBdiBk6FrasapLcCm72SE2cqNOiC9OqxtNKW6L219nYmdc4g2nkFpg4Q==
X-Received: by 2002:a05:6214:c88:b0:628:c4c8:4afb with SMTP id
 r8-20020a0562140c8800b00628c4c84afbmr3203617qvr.60.1686259489142; 
 Thu, 08 Jun 2023 14:24:49 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 g16-20020ac84690000000b003f8e6071e43sm669752qto.3.2023.06.08.14.24.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Jun 2023 14:24:48 -0700 (PDT)
Date: Thu, 8 Jun 2023 17:24:47 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>,
 Joe Thornber <ejt@redhat.com>, Brian Foster <bfoster@redhat.com>
Message-ID: <ZIJHH+ekx59+6Uu0@redhat.com>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <20230518223326.18744-5-sarthakkukreti@chromium.org>
 <ZGeUYESOQsZkOQ1Q@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZGeUYESOQsZkOQ1Q@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v7 4/5] dm-thin: Add REQ_OP_PROVISION support
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
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 19 2023 at 11:23P -0400,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Thu, May 18 2023 at  6:33P -0400,
> Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:
> 
> > dm-thinpool uses the provision request to provision
> > blocks for a dm-thin device. dm-thinpool currently does not
> > pass through REQ_OP_PROVISION to underlying devices.
> > 
> > For shared blocks, provision requests will break sharing and copy the
> > contents of the entire block. Additionally, if 'skip_block_zeroing'
> > is not set, dm-thin will opt to zero out the entire range as a part
> > of provisioning.
> > 
> > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > ---
> >  drivers/md/dm-thin.c | 74 +++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 70 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > index 2b13c949bd72..f1b68b558cf0 100644
> > --- a/drivers/md/dm-thin.c
> > +++ b/drivers/md/dm-thin.c
> > @@ -1245,8 +1247,8 @@ static int io_overlaps_block(struct pool *pool, struct bio *bio)
> >  
> >  static int io_overwrites_block(struct pool *pool, struct bio *bio)
> >  {
> > -	return (bio_data_dir(bio) == WRITE) &&
> > -		io_overlaps_block(pool, bio);
> > +	return (bio_data_dir(bio) == WRITE) && io_overlaps_block(pool, bio) &&
> > +	       bio_op(bio) != REQ_OP_PROVISION;
> >  }
> >  
> >  static void save_and_set_endio(struct bio *bio, bio_end_io_t **save,
> > @@ -1394,6 +1396,9 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
> >  	m->data_block = data_block;
> >  	m->cell = cell;
> >  
> > +	if (bio && bio_op(bio) == REQ_OP_PROVISION)
> > +		m->bio = bio;
> > +
> >  	/*
> >  	 * If the whole block of data is being overwritten or we are not
> >  	 * zeroing pre-existing data, we can issue the bio immediately.
> 
> This doesn't seem like the best way to address avoiding passdown of
> provision bios (relying on process_prepared_mapping's implementation
> that happens to do the right thing if m->bio set).  Doing so cascades
> into relying on complete_overwrite_bio() happening to _not_ actually
> being specific to "overwrite" bios.
> 
> I don't have a better suggestion yet but will look closer.  Just think
> this needs to be formalized a bit more rather than it happening to
> "just work".
> 
> Cc'ing Joe to see what he thinks too.  This is something we can clean
> up with a follow-on patch though, so not a show-stopper for this
> series.

I haven't circled back to look close enough at this but
REQ_OP_PROVISION bios _are_ being passed down to the thin-pool's
underlying data device.

Brian Foster reported that if he issues a REQ_OP_PROVISION to a thin
device after a snapshot (to break sharing), it'll fail with
-EOPNOTSUPP (response is from bio being passed down to device that
doesn't support it).  I was able to reproduce with:

# fallocate --offset 0 --length 1048576 /dev/test/thin
# lvcreate -n snap --snapshot test/thin

# fallocate --offset 0 --length 1048576 /dev/test/thin
fallocate: fallocate failed: Operation not supported

But reports success when retried:
# fallocate --offset 0 --length 1048576 /dev/test/thin
# echo $?
0

It's somewhat moot in that Joe will be reimplementing handling for
REQ_OP_PROVISION _but_ in the meantime it'd be nice to have a version
of this patch that doesn't error (due to passdown of REQ_OP_PROVISION)
when breaking sharing.  Primarily so the XFS guys (Dave and Brian) can
make progress.

I'll take a closer look tomorrow but figured I'd let you know.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

