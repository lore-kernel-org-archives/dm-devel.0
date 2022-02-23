Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C3BCC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:56:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-Eb6A8FwqPKqOsTV-UeaV-w-1; Tue, 22 Feb 2022 19:56:11 -0500
X-MC-Unique: Eb6A8FwqPKqOsTV-UeaV-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABD2AFC80;
	Wed, 23 Feb 2022 00:56:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7731E1038ACD;
	Wed, 23 Feb 2022 00:56:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B72FE1809C98;
	Wed, 23 Feb 2022 00:56:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21N0tsD8030045 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 19:55:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 14EEE2166B48; Wed, 23 Feb 2022 00:55:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1071E2166B2D
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 00:55:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71124811E76
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 00:55:50 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-605-fVphqj2rOtiYPn8t8JGY-w-1; Tue, 22 Feb 2022 19:55:48 -0500
X-MC-Unique: fVphqj2rOtiYPn8t8JGY-w-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1nMfwT-00C2dS-Pt; Wed, 23 Feb 2022 00:55:41 +0000
Date: Tue, 22 Feb 2022 16:55:41 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <YhWGDUyQkUcE6itt@bombadil.infradead.org>
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080605epcas5p16868dae515a6355cf9fecf22df4f3c3d@epcas5p1.samsung.com>
	<20220214080002.18381-3-nj.shetty@samsung.com>
	<20220217090700.b7n33vbkx5s4qbfq@garbanzo>
	<20220217125901.GA3781@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220217125901.GA3781@test-zns>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	Chaitanya Kulkarni <kch@nvidia.com>, osandov@fb.com,
	Alasdair Kergon <agk@redhat.com>, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
	hch@lst.de, chaitanyak@nvidia.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, msnitzer@redhat.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v3 02/10] block: Introduce queue limits for
 copy-offload support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 17, 2022 at 06:29:01PM +0530, Nitesh Shetty wrote:
>  Thu, Feb 17, 2022 at 01:07:00AM -0800, Luis Chamberlain wrote:
> > The subject says limits for copy-offload...
> > 
> > On Mon, Feb 14, 2022 at 01:29:52PM +0530, Nitesh Shetty wrote:
> > > Add device limits as sysfs entries,
> > >         - copy_offload (RW)
> > >         - copy_max_bytes (RW)
> > >         - copy_max_hw_bytes (RO)
> > >         - copy_max_range_bytes (RW)
> > >         - copy_max_range_hw_bytes (RO)
> > >         - copy_max_nr_ranges (RW)
> > >         - copy_max_nr_ranges_hw (RO)
> > 
> > Some of these seem like generic... and also I see a few more max_hw ones
> > not listed above...
> >
> queue_limits and sysfs entries are differently named.
> All sysfs entries start with copy_* prefix. Also it makes easy to lookup
> all copy sysfs.
> For queue limits naming, I tried to following existing queue limit
> convention (like discard).

My point was that your subject seems to indicate the changes are just
for copy-offload, but you seem to be adding generic queue limits as
well. Is that correct? If so then perhaps the subject should be changed
or the patch split up.

> > > +static ssize_t queue_copy_offload_store(struct request_queue *q,
> > > +				       const char *page, size_t count)
> > > +{
> > > +	unsigned long copy_offload;
> > > +	ssize_t ret = queue_var_store(&copy_offload, page, count);
> > > +
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	if (copy_offload && !q->limits.max_hw_copy_sectors)
> > > +		return -EINVAL;
> > 
> > 
> > If the kernel schedules, copy_offload may still be true and
> > max_hw_copy_sectors may be set to 0. Is that an issue?
> >
> 
> This check ensures that, we dont enable offload if device doesnt support
> offload. I feel it shouldn't be an issue.

My point was this:

CPU1                                       CPU2
Time
1) if (copy_offload 
2)    ---> preemption so it schedules      
3)    ---> some other high priority task  Sets q->limits.max_hw_copy_sectors to 0
4) && !q->limits.max_hw_copy_sectors)

Can something bad happen if we allow for this?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

