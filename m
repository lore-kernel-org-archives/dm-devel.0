Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23250E82CAE
	for <dm-devel@archiver.kernel.org>; Wed, 27 Sep 2023 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695834728;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=T0KCGwuSdmgz8znMVsUgBwmORtWldxoQSyeDmPsrm/c=;
	b=QvxeLKaGVv8ARGkj6chzJlj0umQdWFXTFUyG17C3pnw0wxiDV4z691weiGIkudc4N/u9j7
	87Tz9cHSprTgwC7W4TvHMljuNuBQwFvTVLW77y3Hny4K7F2FQia+5TTFRHCLho4H76hreA
	v9ilFmpCerHQhbIKL1oTFhA/ULipp6k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-t5o08Tn3PGCe1Tw8982gZw-1; Wed, 27 Sep 2023 13:12:05 -0400
X-MC-Unique: t5o08Tn3PGCe1Tw8982gZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E482858F1B;
	Wed, 27 Sep 2023 17:12:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B514140273F;
	Wed, 27 Sep 2023 17:12:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5605E19465A8;
	Wed, 27 Sep 2023 17:11:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 71F991946588
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Sep 2023 16:21:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 582EC40C6EA8; Wed, 27 Sep 2023 16:21:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 511C240C6E76
 for <dm-devel@redhat.com>; Wed, 27 Sep 2023 16:21:39 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FF7D101B043
 for <dm-devel@redhat.com>; Wed, 27 Sep 2023 16:21:39 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-pNmEIr2PMP-mZKa0aqjvqA-1; Wed,
 27 Sep 2023 12:21:36 -0400
X-MC-Unique: pNmEIr2PMP-mZKa0aqjvqA-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by sin.source.kernel.org (Postfix) with ESMTP id 89EFFCE1A9C;
 Wed, 27 Sep 2023 16:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3E3C433C7;
 Wed, 27 Sep 2023 16:21:21 +0000 (UTC)
Date: Wed, 27 Sep 2023 18:21:19 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Message-ID: <20230927-prahlen-reintreten-93706074e58d@brauner>
References: <20230818123232.2269-1-jack@suse.cz>
MIME-Version: 1.0
In-Reply-To: <20230818123232.2269-1-jack@suse.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v4 0/29] block: Make blkdev_get_by_*() return
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
 David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Trond Myklebust <trond.myklebust@hammerspace.com>, linux-raid@vger.kernel.org,
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 27 Sep 2023 11:34:07 +0200, Jan Kara wrote:
> Create struct bdev_handle that contains all parameters that need to be
> passed to blkdev_put() and provide bdev_open_* functions that return
> this structure instead of plain bdev pointer. This will eventually allow
> us to pass one more argument to blkdev_put() (renamed to bdev_release())
> without too much hassle.
> 
> 
> [...]

> to ease review / testing. Christian, can you pull the patches to your tree
> to get some exposure in linux-next as well? Thanks!

Yep. So I did it slighly differently. I pulled in the btrfs prereqs and
then applied your series on top of it so we get all the Link: tags right.
I'm running tests right now. Please double-check.

---

Applied to the vfs.super branch of the vfs/vfs.git tree.
Patches in the vfs.super branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.super

[01/29] block: Provide bdev_open_* functions
       https://git.kernel.org/vfs/vfs/c/b7c828aa0b3c
[02/29] block: Use bdev_open_by_dev() in blkdev_open()
        https://git.kernel.org/vfs/vfs/c/d4e36f27b45a
[03/29] block: Use bdev_open_by_dev() in disk_scan_partitions() and blkdev_bszset()
        https://git.kernel.org/vfs/vfs/c/5f9bd6764c7a
[04/29] drdb: Convert to use bdev_open_by_path()
        https://git.kernel.org/vfs/vfs/c/0220ca8e443d
[05/29] pktcdvd: Convert to bdev_open_by_dev()
        https://git.kernel.org/vfs/vfs/c/7af10b889789
[06/29] rnbd-srv: Convert to use bdev_open_by_path()
        https://git.kernel.org/vfs/vfs/c/3d27892a4be7
[07/29] xen/blkback: Convert to bdev_open_by_dev()
        https://git.kernel.org/vfs/vfs/c/26afb0ed10b3
[08/29] zram: Convert to use bdev_open_by_dev()
        https://git.kernel.org/vfs/vfs/c/efc8e3f4c6dc
[09/29] bcache: Convert to bdev_open_by_path()
        https://git.kernel.org/vfs/vfs/c/dc893f51d24a
[10/29] dm: Convert to bdev_open_by_dev()
        https://git.kernel.org/vfs/vfs/c/80c2267c6d07
[11/29] md: Convert to bdev_open_by_dev()
        https://git.kernel.org/vfs/vfs/c/15db36126ca6
[12/29] mtd: block2mtd: Convert to bdev_open_by_dev/path()
        https://git.kernel.org/vfs/vfs/c/4c27234bf3ce
[13/29] nvmet: Convert to bdev_open_by_path()
        https://git.kernel.org/vfs/vfs/c/70cffddcc300
[14/29] s390/dasd: Convert to bdev_open_by_path()
        https://git.kernel.org/vfs/vfs/c/5581d03457f8
[15/29] scsi: target: Convert to bdev_open_by_path()
        https://git.kernel.org/vfs/vfs/c/43de7d844d47
[16/29] PM: hibernate: Convert to bdev_open_by_dev()
        https://git.kernel.org/vfs/vfs/c/105ea4a2fd18
[17/29] PM: hibernate: Drop unused snapshot_test argument
        https://git.kernel.org/vfs/vfs/c/b589a66e3688
[18/29] mm/swap: Convert to use bdev_open_by_dev()
        https://git.kernel.org/vfs/vfs/c/615af8e29233
[19/29] fs: Convert to bdev_open_by_dev()
        https://git.kernel.org/vfs/vfs/c/5173192bcfe6
[20/29] btrfs: Convert to bdev_open_by_path()
        https://git.kernel.org/vfs/vfs/c/8cf64782764f
[21/29] erofs: Convert to use bdev_open_by_path()
        https://git.kernel.org/vfs/vfs/c/4d41880bf249
[22/29] ext4: Convert to bdev_open_by_dev()
        https://git.kernel.org/vfs/vfs/c/f7507612395e
[23/29] f2fs: Convert to bdev_open_by_dev/path()
        https://git.kernel.org/vfs/vfs/c/d9ff8e3b6498
[24/29] jfs: Convert to bdev_open_by_dev()
        https://git.kernel.org/vfs/vfs/c/459dc6376338
[25/29] nfs/blocklayout: Convert to use bdev_open_by_dev/path()
        https://git.kernel.org/vfs/vfs/c/5b1df9a40929
[26/29] ocfs2: Convert to use bdev_open_by_dev()
        https://git.kernel.org/vfs/vfs/c/b6b95acbd943
[27/29] reiserfs: Convert to bdev_open_by_dev/path()
        https://git.kernel.org/vfs/vfs/c/7e3615ff6119
[28/29] xfs: Convert to bdev_open_by_path()
        https://git.kernel.org/vfs/vfs/c/176ccb99e207
[29/29] block: Remove blkdev_get_by_*() functions
        https://git.kernel.org/vfs/vfs/c/953863a5a2ff

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

