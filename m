Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ABEBC83F17
	for <dm-devel@archiver.kernel.org>; Mon, 28 Aug 2023 06:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693205176;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uYrIzdMzhxwGbjXbCOWjYCwycyE98eA+8WwJAoEGRj0=;
	b=ZnB8BaFR3dBIPCPPXGNwhnMwl2AbI79dKBU0qovK5Q+7WURJN0IkToKDRNzLSrvNgjxZBm
	kFTy8Vd56FZ+GvlLzADO5sLDy6lJZKogD381UJzvhDoM5G+dS/JL1K6mXP36JPGS3Csoxb
	iycfOcDUSf3PAvQJuhLaLO6c83FxbqE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-n4zX5wBHOAONnJxZUlpcAQ-1; Mon, 28 Aug 2023 02:46:11 -0400
X-MC-Unique: n4zX5wBHOAONnJxZUlpcAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64CCE185A78B;
	Mon, 28 Aug 2023 06:46:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED7642166B25;
	Mon, 28 Aug 2023 06:46:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D29A019465B6;
	Mon, 28 Aug 2023 06:46:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3889119465A8
 for <dm-devel@listman.corp.redhat.com>; Sat, 26 Aug 2023 02:29:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC3CD140E962; Sat, 26 Aug 2023 02:29:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E4F10140E950
 for <dm-devel@redhat.com>; Sat, 26 Aug 2023 02:29:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FB583C0252E
 for <dm-devel@redhat.com>; Sat, 26 Aug 2023 02:29:16 +0000 (UTC)
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-606-lRWZFOprMOOxmVvZKBndfA-1; Fri,
 25 Aug 2023 22:29:14 -0400
X-MC-Unique: lRWZFOprMOOxmVvZKBndfA-1
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat
 Linux)) id 1qZj2i-0010QB-1S; Sat, 26 Aug 2023 02:28:52 +0000
Date: Sat, 26 Aug 2023 03:28:52 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Message-ID: <20230826022852.GO3390869@ZenIV>
References: <20230810171429.31759-1-jack@suse.cz>
 <20230825015843.GB95084@ZenIV>
 <20230825134756.o3wpq6bogndukn53@quack3>
MIME-Version: 1.0
In-Reply-To: <20230825134756.o3wpq6bogndukn53@quack3>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 28 Aug 2023 06:46:05 +0000
Subject: Re: [dm-devel] [PATCH v2 0/29] block: Make blkdev_get_by_*() return
 handle
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 "Darrick J. Wong" <djwong@kernel.org>, linux-nvme@lists.infradead.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>, dm-devel@redhat.com,
 target-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
 Jack Wang <jinpu.wang@ionos.com>, Alasdair Kergon <agk@redhat.com>,
 drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org,
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Christoph Hellwig <hch@infradead.org>, xen-devel@lists.xenproject.org,
 Gao Xiang <xiang@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 Sven Schnelle <svens@linux.ibm.com>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Chao Yu <chao@kernel.org>,
 Joern Engel <joern@lazybastard.org>, reiserfs-devel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>, David Sterba <dsterba@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
 linux-mm@kvack.org, Song Liu <song@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>, ocfs2-devel@oss.oracle.com,
 Anna Schumaker <anna@kernel.org>, linux-fsdevel@vger.kernel.org,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: zeniv.linux.org.uk
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Aug 25, 2023 at 03:47:56PM +0200, Jan Kara wrote:

> I can see the appeal of not having to introduce the new bdev_handle type
> and just using struct file which unifies in-kernel and userspace block
> device opens. But I can see downsides too - the last fput() happening from
> task work makes me a bit nervous whether it will not break something
> somewhere with exclusive bdev opens. Getting from struct file to bdev is
> somewhat harder but I guess a helper like F_BDEV() would solve that just
> fine.
> 
> So besides my last fput() worry about I think this could work and would be
> probably a bit nicer than what I have. But before going and redoing the whole
> series let me gather some more feedback so that we don't go back and forth.
> Christoph, Christian, Jens, any opinion?

Redoing is not an issue - it can be done on top of your series just
as well.  Async behaviour of fput() might be, but...  need to look
through the actual users; for a lot of them it's perfectly fine.

FWIW, from a cursory look there appears to be a missing primitive: take
an opened bdev (or bdev_handle, with your variant, or opened file if we
go that way eventually) and claim it.

I mean, look at claim_swapfile() for example:
                p->bdev = blkdev_get_by_dev(inode->i_rdev,
                                   FMODE_READ | FMODE_WRITE | FMODE_EXCL, p);
                if (IS_ERR(p->bdev)) {
                        error = PTR_ERR(p->bdev);
                        p->bdev = NULL;
                        return error;
                }
                p->old_block_size = block_size(p->bdev);
                error = set_blocksize(p->bdev, PAGE_SIZE);
                if (error < 0)
                        return error;
we already have the file opened, and we keep it opened all the way until
the swapoff(2); here we have noticed that it's a block device and we
	* open the fucker again (by device number), this time claiming
it with our swap_info_struct as holder, to be closed at swapoff(2) time
(just before we close the file)
	* flip the block size to PAGE_SIZE, to be reverted at swapoff(2)
time That really looks like it ought to be
	* take the opened file, see that it's a block device
	* try to claim it with that holder
	* on success, flip the block size
with close_filp() in the swapoff(2) (or failure exit path in swapon(2))
doing what it would've done for an O_EXCL opened block device.
The only difference from O_EXCL userland open is that here we would
end up with holder pointing not to struct file in question, but to our
swap_info_struct.  It will do the right thing.

This extra open is entirely due to "well, we need to claim it and the
primitive that does that happens to be tied to opening"; feels rather
counter-intuitive.

For that matter, we could add an explicit "unclaim" primitive - might
be easier to follow.  That would add another example where that could
be used - in blkdev_bszset() we have an opened block device (it's an
ioctl, after all), we want to change block size and we *really* don't
want to have that happen under a mounted filesystem.  So if it's not
opened exclusive, we do a temporary exclusive open of own and act on
that instead.   Might as well go for a temporary claim...

BTW, what happens if two threads call ioctl(fd, BLKBSZSET, &n)
for the same descriptor that happens to have been opened O_EXCL?
Without O_EXCL they would've been unable to claim the sucker at the same
time - the holder we are using is the address of a function argument,
i.e. something that points to kernel stack of the caller.  Those would
conflict and we either get set_blocksize() calls fully serialized, or
one of the callers would eat -EBUSY.  Not so in "opened with O_EXCL"
case - they can very well overlap and IIRC set_blocksize() does *not*
expect that kind of crap...  It's all under CAP_SYS_ADMIN, so it's not
as if it was a meaningful security hole anyway, but it does look fishy.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

