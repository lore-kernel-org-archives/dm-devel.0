Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0160C7EE25
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 00:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686270506;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lhreQhTKd5mQ11yQXFCSpUp4JsBkbShCsdfSV6dQbqU=;
	b=N2Z/3DglJi6r88U+zH+6VIs4isi6diA5tCAmoK7DTDYppVj6HMflMCkiO3HiHVhC5tSLVC
	rJQTcodh9Cgz7zTPHVb3X5EH5EjsMkaRkPi5v6ozYfV6+1yXrYJd2khvOF5KzMB7J1C/8q
	cXoiejoaKwSyyziwgrkb/NUK75wDMRo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-aJhLtuaFPwKVbh3o9w8Pgw-1; Thu, 08 Jun 2023 20:28:23 -0400
X-MC-Unique: aJhLtuaFPwKVbh3o9w8Pgw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21858101AA68;
	Fri,  9 Jun 2023 00:28:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C8EB7492B00;
	Fri,  9 Jun 2023 00:28:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9AE6C19451C0;
	Fri,  9 Jun 2023 00:28:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D54AC194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 00:28:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 946FCC16046; Fri,  9 Jun 2023 00:28:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C704C16044
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 00:28:20 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 707071C00D00
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 00:28:20 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-TSRW_yvHNuWk2pIKu5j8Sg-1; Thu, 08 Jun 2023 20:28:19 -0400
X-MC-Unique: TSRW_yvHNuWk2pIKu5j8Sg-1
Received: by mail-qk1-f200.google.com with SMTP id
 af79cd13be357-75d42a5097bso148407385a.3
 for <dm-devel@redhat.com>; Thu, 08 Jun 2023 17:28:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686270498; x=1688862498;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=dZ0yORwAdXDCRd2fZyWQ1kLxeAr//tPmWz4kXkYhyTs=;
 b=d0v/O3AK1TutRwqVUbEFzncLc/f5vMj0mOQb6TXEBMPkH8yGbg9aZ+2QFzmit2Z73d
 VjE7u4i0haqMPGZGG/2dKrHlsaPZ67h9geEFCawsIC9bOHKHrqE9Ixs+/TdQq7V8MntH
 PlwPLQnNac2dyW46vjTqUXWJc4A6aeYZsn8xbRIFXXucPCfKvvGPTAXPhOba8/G8ICvW
 YPRAZvplqcHFKSMZlzrgy/nwjXLXiDfqmLBvnVGXAySNATtynBhb+Jq6Q5znp/SjRchO
 ipysZe0+LKNFjwKNXOvRmpHsgscsuxFWfcYZa1mS+v+xDgG05y0BYMh+HHEG7gW7YKYU
 AZLQ==
X-Gm-Message-State: AC+VfDxQ0BrzgHGPug3fmfjrrkojL5S9wIbBa5FiItnds+JnAp3MJHoP
 /V8Njz7P9YGuiKaeNCxrkTNwxl+7rD6/PuiIdIppyWJE2sB4YVbxP2edn9aVIDooLOHgFdvbemy
 4ZFnGE6XgoSqLag==
X-Received: by 2002:a05:620a:2810:b0:75b:23a1:830c with SMTP id
 f16-20020a05620a281000b0075b23a1830cmr6973252qkp.7.1686270498615; 
 Thu, 08 Jun 2023 17:28:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5VNYOErVU972i4sJBtGLp/lGfEdbBIVxwb21zSx3OzLfsQlP0gnu+6DNqAnZHJO5hi85SI6A==
X-Received: by 2002:a05:620a:2810:b0:75b:23a1:830c with SMTP id
 f16-20020a05620a281000b0075b23a1830cmr6973236qkp.7.1686270498360; 
 Thu, 08 Jun 2023 17:28:18 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 m14-20020a05620a13ae00b0075da00ef114sm693183qki.46.2023.06.08.17.28.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Jun 2023 17:28:17 -0700 (PDT)
Date: Thu, 8 Jun 2023 20:28:16 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>,
 Joe Thornber <ejt@redhat.com>, Brian Foster <bfoster@redhat.com>
Message-ID: <ZIJyIOIPx+jE9/iv@redhat.com>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <20230518223326.18744-5-sarthakkukreti@chromium.org>
 <ZGeUYESOQsZkOQ1Q@redhat.com> <ZIJHH+ekx59+6Uu0@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZIJHH+ekx59+6Uu0@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 08 2023 at  5:24P -0400,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Fri, May 19 2023 at 11:23P -0400,
> Mike Snitzer <snitzer@kernel.org> wrote:
> 
> > On Thu, May 18 2023 at  6:33P -0400,
> > Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:
> > 
> > > dm-thinpool uses the provision request to provision
> > > blocks for a dm-thin device. dm-thinpool currently does not
> > > pass through REQ_OP_PROVISION to underlying devices.
> > > 
> > > For shared blocks, provision requests will break sharing and copy the
> > > contents of the entire block. Additionally, if 'skip_block_zeroing'
> > > is not set, dm-thin will opt to zero out the entire range as a part
> > > of provisioning.
> > > 
> > > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > > ---
> > >  drivers/md/dm-thin.c | 74 +++++++++++++++++++++++++++++++++++++++++---
> > >  1 file changed, 70 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > > index 2b13c949bd72..f1b68b558cf0 100644
> > > --- a/drivers/md/dm-thin.c
> > > +++ b/drivers/md/dm-thin.c
> > > @@ -1245,8 +1247,8 @@ static int io_overlaps_block(struct pool *pool, struct bio *bio)
> > >  
> > >  static int io_overwrites_block(struct pool *pool, struct bio *bio)
> > >  {
> > > -	return (bio_data_dir(bio) == WRITE) &&
> > > -		io_overlaps_block(pool, bio);
> > > +	return (bio_data_dir(bio) == WRITE) && io_overlaps_block(pool, bio) &&
> > > +	       bio_op(bio) != REQ_OP_PROVISION;
> > >  }
> > >  
> > >  static void save_and_set_endio(struct bio *bio, bio_end_io_t **save,
> > > @@ -1394,6 +1396,9 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
> > >  	m->data_block = data_block;
> > >  	m->cell = cell;
> > >  
> > > +	if (bio && bio_op(bio) == REQ_OP_PROVISION)
> > > +		m->bio = bio;
> > > +
> > >  	/*
> > >  	 * If the whole block of data is being overwritten or we are not
> > >  	 * zeroing pre-existing data, we can issue the bio immediately.
> > 
> > This doesn't seem like the best way to address avoiding passdown of
> > provision bios (relying on process_prepared_mapping's implementation
> > that happens to do the right thing if m->bio set).  Doing so cascades
> > into relying on complete_overwrite_bio() happening to _not_ actually
> > being specific to "overwrite" bios.
> > 
> > I don't have a better suggestion yet but will look closer.  Just think
> > this needs to be formalized a bit more rather than it happening to
> > "just work".
> > 
> > Cc'ing Joe to see what he thinks too.  This is something we can clean
> > up with a follow-on patch though, so not a show-stopper for this
> > series.
> 
> I haven't circled back to look close enough at this but
> REQ_OP_PROVISION bios _are_ being passed down to the thin-pool's
> underlying data device.
> 
> Brian Foster reported that if he issues a REQ_OP_PROVISION to a thin
> device after a snapshot (to break sharing), it'll fail with
> -EOPNOTSUPP (response is from bio being passed down to device that
> doesn't support it).  I was able to reproduce with:
> 
> # fallocate --offset 0 --length 1048576 /dev/test/thin
> # lvcreate -n snap --snapshot test/thin
> 
> # fallocate --offset 0 --length 1048576 /dev/test/thin
> fallocate: fallocate failed: Operation not supported
> 
> But reports success when retried:
> # fallocate --offset 0 --length 1048576 /dev/test/thin
> # echo $?
> 0
> 
> It's somewhat moot in that Joe will be reimplementing handling for
> REQ_OP_PROVISION _but_ in the meantime it'd be nice to have a version
> of this patch that doesn't error (due to passdown of REQ_OP_PROVISION)
> when breaking sharing.  Primarily so the XFS guys (Dave and Brian) can
> make progress.
> 
> I'll take a closer look tomorrow but figured I'd let you know.

This fixes the issue for me (causes process_prepared_mapping to end
the bio without REQ_OP_PROVISION passdown).

But like I said above back on May 19: needs cleanup to make it less of
a hack for the REQ_OP_PROVISION case. At a minimum
complete_overwrite_bio() would need renaming.

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 43a6702f9efe..434a3b37af2f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1324,6 +1324,9 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	m->data_block = data_dest;
 	m->cell = cell;
 
+	if (bio_op(bio) == REQ_OP_PROVISION)
+		m->bio = bio;
+
 	/*
 	 * quiesce action + copy action + an extra reference held for the
 	 * duration of this function (we may need to inc later for a

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

