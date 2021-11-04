Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 338A7C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:33:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF27C61076
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:33:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BF27C61076
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-SpBqNSpIPve8upbGvQmniw-1; Thu, 04 Nov 2021 13:32:58 -0400
X-MC-Unique: SpBqNSpIPve8upbGvQmniw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8193C362FC;
	Thu,  4 Nov 2021 17:32:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C6AA56A8C;
	Thu,  4 Nov 2021 17:32:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 017D14EA2F;
	Thu,  4 Nov 2021 17:32:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4HWoJq005161 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 13:32:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2481F2026D11; Thu,  4 Nov 2021 17:32:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CF6A2026D69
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 17:32:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2A3E18A01B1
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 17:32:41 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-504-NbxnEBVsObunlPeAmv8MRw-1;
	Thu, 04 Nov 2021 13:32:38 -0400
X-MC-Unique: NbxnEBVsObunlPeAmv8MRw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51D5260EBC;
	Thu,  4 Nov 2021 17:32:36 +0000 (UTC)
Date: Thu, 4 Nov 2021 10:32:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20211104173235.GI2237511@magnolia>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104071439.GA21927@lst.de>
	<661bcadd-a030-4a72-81ae-ef15080f0241@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <661bcadd-a030-4a72-81ae-ef15080f0241@nvidia.com>
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
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	Christoph Hellwig <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
	"javier@javigon.com" <javier@javigon.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dongli.zhang@oracle.com" <dongli.zhang@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"osandov@fb.com" <osandov@fb.com>,
	"danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"sagi@grimberg.me" <sagi@grimberg.me>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"clm@fb.com" <clm@fb.com>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	"jlayton@kernel.org" <jlayton@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
	"jack@suse.com" <jack@suse.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 0/8] block: add support for REQ_OP_VERIFY
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 04, 2021 at 09:27:50AM +0000, Chaitanya Kulkarni wrote:
> On 11/4/2021 12:14 AM, Christoph Hellwig wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > What is the actual use case here?
> > 
> 
> One of the immediate use-case is to use this interface with XFS 
> scrubbing infrastructure [1] (by replacing any SCSI calls e.g. sg_io() 
> with BLKVERIFY ioctl() calls corresponding to REQ_OP_VERIFY) and 
> eventually allow and extend other file systems to use it for scrubbing.

FWIW it /would/ be a win to have a general blkdev ioctl to do this,
rather than shoving SCSI commands through /dev/sg, which (obviously)
doesn't work when dm and friends are in use.  I hadn't bothered to wire
up xfs_scrub to NVME COMPARE because none of my devices support it and
tbh I was holding out for this kind of interface anyway. ;)

I also wonder if it would be useful (since we're already having a
discussion elsewhere about data integrity syscalls for pmem) to be able
to call this sort of thing against files?  In which case we'd want
another preadv2 flag or something, and then plumb all that through the
vfs/iomap as needed?

--D

> [1] man xfs_scrub :-
> -x     Read all file data extents to look for disk errors.
>                xfs_scrub will issue O_DIRECT reads to the block device
>                directly.  If the block device is a SCSI disk, it will
>                instead issue READ VERIFY commands directly to the disk.
>                If media errors are found, the error report will include
>                the disk offset, in bytes.  If the media errors affect a
>                file, the report will also include the inode number and
>                file offset, in bytes.  These actions will confirm that
>                all file data blocks can be read from storage.
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

