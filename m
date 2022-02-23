Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B48FC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 23 Feb 2022 01:44:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-xkeDfJKTPVWGnSHfo8Uzsg-1; Tue, 22 Feb 2022 20:43:57 -0500
X-MC-Unique: xkeDfJKTPVWGnSHfo8Uzsg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D94B8145F0;
	Wed, 23 Feb 2022 01:43:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 035884BC68;
	Wed, 23 Feb 2022 01:43:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6CC3C4A701;
	Wed, 23 Feb 2022 01:43:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21N1hnCh001155 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 20:43:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1F2262026990; Wed, 23 Feb 2022 01:43:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A81F2026D2F
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 01:43:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FF97296A601
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 01:43:46 +0000 (UTC)
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au
	[211.29.132.246]) by relay.mimecast.com with ESMTP id
	us-mta-138-kdnO9ciFN3SIbiyb6V9uaQ-1; Tue, 22 Feb 2022 20:43:43 -0500
X-MC-Unique: kdnO9ciFN3SIbiyb6V9uaQ-1
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au
	[49.186.17.0])
	by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C1E5D52F66C;
	Wed, 23 Feb 2022 12:43:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1nMggp-00FHrN-4M; Wed, 23 Feb 2022 12:43:35 +1100
Date: Wed, 23 Feb 2022 12:43:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <20220223014335.GH3061737@dread.disaster.area>
References: <CGME20220214080551epcas5p201d4d85e9d66077f97585bb3c64517c0@epcas5p2.samsung.com>
	<20220214080002.18381-1-nj.shetty@samsung.com>
	<20220214220741.GB2872883@dread.disaster.area>
	<20220217130215.GB3781@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220217130215.GB3781@test-zns>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6215914d
	a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
	a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
	a=ejYDZuiVgDdOHNFj5oEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
	javier@javigon.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
	James Smart <james.smart@broadcom.com>, hch@lst.de,
	chaitanyak@nvidia.com, Chaitanya Kulkarni <kch@nvidia.com>,
	msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, Sagi Grimberg <sagi@grimberg.me>,
	axboe@kernel.dk, tytso@mit.edu, joshi.k@samsung.com,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v3 00/10] Add Copy offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 17, 2022 at 06:32:15PM +0530, Nitesh Shetty wrote:
>  Tue, Feb 15, 2022 at 09:08:12AM +1100, Dave Chinner wrote:
> > On Mon, Feb 14, 2022 at 01:29:50PM +0530, Nitesh Shetty wrote:
> > > [LSF/MM/BFP TOPIC] Storage: Copy Offload[0].
> > The biggest missing piece - and arguably the single most useful
> > piece of this functionality for users - is hooking this up to the
> > copy_file_range() syscall so that user file copies can be offloaded
> > to the hardware efficiently.
> > 
> > This seems like it would relatively easy to do with an fs/iomap iter
> > loop that maps src + dst file ranges and issues block copy offload
> > commands on the extents. We already do similar "read from source,
> > write to destination" operations in iomap, so it's not a huge
> > stretch to extent the iomap interfaces to provide an copy offload
> > mechanism using this infrastructure.
> > 
> > Also, hooking this up to copy-file-range() will also get you
> > immediate data integrity testing right down to the hardware via fsx
> > in fstests - it uses copy_file_range() as one of it's operations and
> > it will find all the off-by-one failures in both the linux IO stack
> > implementation and the hardware itself.
> > 
> > And, in reality, I wouldn't trust a block copy offload mechanism
> > until it is integrated with filesystems, the page cache and has
> > solid end-to-end data integrity testing available to shake out all
> > the bugs that will inevitably exist in this stack....
> 
> We had planned copy_file_range (CFR) in next phase of copy offload patch series.
> Thinking that we will get to CFR when everything else is robust.
> But if that is needed to make things robust, will start looking into that.

How do you make it robust when there is no locking/serialisation to
prevent overlapping concurrent IO while the copy-offload is in
progress? Or that you don't have overlapping concurrent
copy-offloads running at the same time?

You've basically created a block dev ioctl interface that looks
impossible to use safely. It doesn't appear to be coherent with the
blockdev page cache nor does it appear to have any documented data
integrity semantics, either. e.g. how does this interact with the
guarantees that fsync_bdev() and/or sync_blockdev() are supposed to
provide?

IOWs, if you don't have either CFR or some other strictly bound
kernel user with well defined access, synchronisation and integrity
semantics, how can anyone actually robustly test these ioctls to be
working correctly in all situations they might be called?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

