Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EF13D8E
	for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 00:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227263; cv=none; b=A4bL9MVU9skho3y8MbWKDlMgkhmny2Seb67DM6WUyP1SovGryvM6qMmk9J2HAeqe0vlTnlBD5ASPf2w3lONqPQIKqtY6MPiJav7JEYDpxk5kat5S4rMcjRdxz0orL5wlnz3z5e6Qe1aqPbPvk326sQNS+lEkq+0dA02NSrb2oJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227263; c=relaxed/simple;
	bh=nWMh2AAT2ENJC3oskCzD9My+7gvgkOWPnCBWTqrEttk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgCkT990HvlFaM3B4EaE6Ps6S5UV1PbyZZLcS3pNW+Bw/Vzk4Ux+6Hy0cd53BPeAVlz16Rd+w6KchdSUy7khMQupBCaCqpU2FoRmDjCqgYQ81v6UxqUzC3pHDspq35rE/1DQII1ymRvtLONUd5fhMsY23YXGZ/LkiqyuNAAH94w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UIVHmdkP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UIVHmdkP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713227261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HPwh9VINljuHhg0//cSxsSBfaGykarxyPhh5vJg/F44=;
	b=UIVHmdkPM2PTqfPeh7OsrkRx2mXfZXqIco8ckhdVB63Kvkv74RRMAagFiezKZ/sNNByaPY
	g3xOF25Ls7lAn7ZxVc9H/HfFr8zn5xUr55FU/I54SesGxPeg9p1QnC60a1hYc63QPqGvTL
	fsYgSsJRujsL9W5fLAIB0IRo5V7RrGU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-DRhFFx2MNymlYr12d2L5GQ-1; Mon,
 15 Apr 2024 20:27:36 -0400
X-MC-Unique: DRhFFx2MNymlYr12d2L5GQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EEE61C3F0EC;
	Tue, 16 Apr 2024 00:27:36 +0000 (UTC)
Received: from fedora (unknown [10.72.116.28])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBB9FC13FA1;
	Tue, 16 Apr 2024 00:27:30 +0000 (UTC)
Date: Tue, 16 Apr 2024 08:27:22 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 04/34] md: port block device access to file
Message-ID: <Zh3F6saW9O7pWB5n@fedora>
References: <20240123-vfs-bdev-file-v2-0-adbd023e19cc@kernel.org>
 <20240123-vfs-bdev-file-v2-4-adbd023e19cc@kernel.org>
 <Zhzyu6pQYkSNgvuh@fedora>
 <20240415-haufen-demolieren-8c6da8159586@brauner>
 <Zh07Sc3lYStOWK8J@fedora>
 <20240415-neujahr-schummeln-c334634ab5ad@brauner>
 <Zh1Dtvs8nst9P4J2@fedora>
 <20240415162210.zyoolbj27usnhk56@quack3>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240415162210.zyoolbj27usnhk56@quack3>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Mon, Apr 15, 2024 at 06:22:10PM +0200, Jan Kara wrote:
> On Mon 15-04-24 23:11:50, Ming Lei wrote:
> > On Mon, Apr 15, 2024 at 04:53:42PM +0200, Christian Brauner wrote:
> > > On Mon, Apr 15, 2024 at 10:35:53PM +0800, Ming Lei wrote:
> > > > On Mon, Apr 15, 2024 at 02:35:17PM +0200, Christian Brauner wrote:
> > > > > On Mon, Apr 15, 2024 at 05:26:19PM +0800, Ming Lei wrote:
> > > > > > Hello,
> > > > > > 
> > > > > > On Tue, Jan 23, 2024 at 02:26:21PM +0100, Christian Brauner wrote:
> > > > > > > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > > > > > > ---
> > > > > > >  drivers/md/dm.c               | 23 +++++++++++++----------
> > > > > > >  drivers/md/md.c               | 12 ++++++------
> > > > > > >  drivers/md/md.h               |  2 +-
> > > > > > >  include/linux/device-mapper.h |  2 +-
> > > > > > >  4 files changed, 21 insertions(+), 18 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > > > > > index 8dcabf84d866..87de5b5682ad 100644
> > > > > > > --- a/drivers/md/dm.c
> > > > > > > +++ b/drivers/md/dm.c
> > > > > > 
> > > > > > ...
> > > > > > 
> > > > > > > @@ -775,7 +778,7 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
> > > > > > >  {
> > > > > > >  	if (md->disk->slave_dir)
> > > > > > >  		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
> > > > > > > -	bdev_release(td->dm_dev.bdev_handle);
> > > > > > > +	fput(td->dm_dev.bdev_file);
> > > > > > 
> > > > > > The above change caused regression on 'dmsetup remove_all'.
> > > > > > 
> > > > > > blkdev_release() is delayed because of fput(), so dm_lock_for_deletion
> > > > > > returns -EBUSY, then this dm disk is skipped in remove_all().
> > > > > > 
> > > > > > Force to mark DMF_DEFERRED_REMOVE might solve it, but need our device
> > > > > > mapper guys to check if it is safe.
> > > > > > 
> > > > > > Or other better solution?
> > > > > 
> > > > > Yeah, I think there is. You can just switch all fput() instances in
> > > > > device mapper to bdev_fput() which is mainline now. This will yield the
> > > > > device and make it able to be reclaimed. Should be as simple as the
> > > > > patch below. Could you test this and send a patch based on this (I'm on
> > > > > a prolonged vacation so I don't have time right now.):
> > > > 
> > > > Unfortunately it doesn't work.
> > > > 
> > > > Here the problem is that blkdev_release() is delayed, which changes
> > > > 'dmsetup remove_all' behavior, and causes that some of dm disks aren't
> > > > removed.
> > > > 
> > > > Please see dm_lock_for_deletion() and dm_blk_open()/dm_blk_close().
> > > 
> > > So you really need blkdev_release() itself to be synchronous? Groan, in
> > 
> > At least the current dm implementation relies on this way sort of, and
> > it could be addressed by forcing to mark DMF_DEFERRED_REMOVE in
> > remove_all().
> > 
> > > that case use __fput_sync() instead of fput() which ensures that this
> > > file is closed synchronously.
> > 
> > I tried __fput_sync(), but the following panic is caused:
> > 
> > [  113.486522] ------------[ cut here ]------------
> > [  113.486524] kernel BUG at fs/file_table.c:453!
> > [  113.486531] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > [  113.488878] CPU: 6 PID: 1919 Comm: dmsetup Kdump: loaded Not tainted 5.14.0+ #23
> 
> Wait, how come this is 5.14 kernel? Apparently you're crashing on:
> 
> BUG_ON(!(task->flags & PF_KTHREAD));
> 
> but that is not present in current upstream (BUG_ON was removed in 6.6-rc1
> by commit 021a160abf62c).

Indeed, just tried the change on v6.9-rc3, looks it does work. 


Thanks,
Ming

