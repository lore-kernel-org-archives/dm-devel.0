Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04220302151;
	Wed, 22 Oct 2025 08:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761120610; cv=none; b=Xi1dZ/q1Lvq65aph2DQTNoD7uyOkZt61CYi8TzjeWLJx69IreNyo24Vr/W2Wz5AldKB1qLuK7SQynlMC9xkiJt9OSxCKvFrxX/SWEC7mhxYduCoTCKPLB1ilKmIno+QMoyNvu+E4f+mR8pVjDGvuMl1SyehJ5+5DcvnRRb0oRlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761120610; c=relaxed/simple;
	bh=pdjzDIyGc0Ha6pX2r3NiQ3rBH7VjgJGHYVWdUrWURzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KKRoPhSzaXhHJQ3hoETlQ7i1QMCdTpDvTg7eVhfnvdUEkCsj4LPKh3zHguz3i0RTpTQCXk2gu3IMKnmOeMEmXSDI4UCUEe10j03CAGPO4DQS9WwvgU+em4xrjoyeDk2aUfl6ORGtYJknQtM/DjgifeBnrwYfY+VJU/u2nxUFfgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWitcTay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWitcTay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D452C4CEF5;
	Wed, 22 Oct 2025 08:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761120609;
	bh=pdjzDIyGc0Ha6pX2r3NiQ3rBH7VjgJGHYVWdUrWURzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XWitcTaylUNucJ5mO2g433Pq6yk8i5gfWa6Lu2+qyhIy3ytGA9WIEF0WC6O8igclZ
	 mvZOwCuoyTjcmzoPl+EWfFbv0+CS/R5IjyYhVuyQmiNW+l2rp0UzOAKo0oa/ktP8xK
	 uTy/39Th4piX/543EzqvL5Vm+8a8xDJN/MYVk4wc=
Date: Wed, 22 Oct 2025 10:10:07 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Li Lingfeng <lilingfeng3@huawei.com>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	Zheng Qixing <zhengqixing@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	yangerkun <yangerkun@huawei.com>,
	"zhangyi (F)" <yi.zhang@huawei.com>, Hou Tao <houtao1@huawei.com>
Subject: Re: [PATCH 5.10.y] dm: fix NULL pointer dereference in __dm_suspend()
Message-ID: <2025102252-abrasive-glamorous-465b@gregkh>
References: <2025101316-favored-pulsate-a811@gregkh>
 <20251014030334.3868139-1-sashal@kernel.org>
 <cdadc001-3c0e-4152-8b05-08eb79fb528b@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cdadc001-3c0e-4152-8b05-08eb79fb528b@huawei.com>

On Wed, Oct 22, 2025 at 04:01:04PM +0800, Li Lingfeng wrote:
> Hi,
> 
> 在 2025/10/14 11:03, Sasha Levin 写道:
> > From: Zheng Qixing <zhengqixing@huawei.com>
> > 
> > [ Upstream commit 8d33a030c566e1f105cd5bf27f37940b6367f3be ]
> > 
> > There is a race condition between dm device suspend and table load that
> > can lead to null pointer dereference. The issue occurs when suspend is
> > invoked before table load completes:
> > 
> > BUG: kernel NULL pointer dereference, address: 0000000000000054
> > Oops: 0000 [#1] PREEMPT SMP PTI
> > CPU: 6 PID: 6798 Comm: dmsetup Not tainted 6.6.0-g7e52f5f0ca9b #62
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
> > RIP: 0010:blk_mq_wait_quiesce_done+0x0/0x50
> > Call Trace:
> >    <TASK>
> >    blk_mq_quiesce_queue+0x2c/0x50
> >    dm_stop_queue+0xd/0x20
> >    __dm_suspend+0x130/0x330
> >    dm_suspend+0x11a/0x180
> >    dev_suspend+0x27e/0x560
> >    ctl_ioctl+0x4cf/0x850
> >    dm_ctl_ioctl+0xd/0x20
> >    vfs_ioctl+0x1d/0x50
> >    __se_sys_ioctl+0x9b/0xc0
> >    __x64_sys_ioctl+0x19/0x30
> >    x64_sys_call+0x2c4a/0x4620
> >    do_syscall_64+0x9e/0x1b0
> > 
> > The issue can be triggered as below:
> > 
> > T1 						T2
> > dm_suspend					table_load
> > __dm_suspend					dm_setup_md_queue
> > 						dm_mq_init_request_queue
> > 						blk_mq_init_allocated_queue
> > 						=> q->mq_ops = set->ops; (1)
> > dm_stop_queue / dm_wait_for_completion
> > => q->tag_set NULL pointer!	(2)
> > 						=> q->tag_set = set; (3)
> > 
> > Fix this by checking if a valid table (map) exists before performing
> > request-based suspend and waiting for target I/O. When map is NULL,
> > skip these table-dependent suspend steps.
> > 
> > Even when map is NULL, no I/O can reach any target because there is
> > no table loaded; I/O submitted in this state will fail early in the
> > DM layer. Skipping the table-dependent suspend logic in this case
> > is safe and avoids NULL pointer dereferences.
> > 
> > Fixes: c4576aed8d85 ("dm: fix request-based dm's use of dm_wait_for_completion")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > [ omitted DMF_QUEUE_STOPPED flag setting and braces absent in 5.15 ]
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/md/dm.c | 7 ++++---
> >   1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 0868358a7a8d2..b51281ce15d4c 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -2457,7 +2457,7 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
> >   {
> >   	bool do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG;
> >   	bool noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG;
> > -	int r;
> > +	int r = 0;
> >   	lockdep_assert_held(&md->suspend_lock);
> > @@ -2509,7 +2509,7 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
> >   	 * Stop md->queue before flushing md->wq in case request-based
> >   	 * dm defers requests to md->wq from md->queue.
> >   	 */
> > -	if (dm_request_based(md))
> > +	if (map && dm_request_based(md))
> >   		dm_stop_queue(md->queue);
> It seems that before commit 80bd4a7aab4c ("blk-mq: move the srcu_struct
> used for quiescing to the tagset") was merged, blk_mq_wait_quiesce_done()
> would not attempt to access q->tag_set, so in dm_stop_queue() this kind
> of race condition would not cause a null pointer dereference. The change
> may not be necessary for 5.10, but adding it doesn’t appear to cause any
> issues either.
> >   	flush_workqueue(md->wq);
> > @@ -2519,7 +2519,8 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
> >   	 * We call dm_wait_for_completion to wait for all existing requests
> >   	 * to finish.
> >   	 */
> > -	r = dm_wait_for_completion(md, task_state);
> > +	if (map)
> > +		r = dm_wait_for_completion(md, task_state);
> The fix tag c4576aed8d85 ("dm: fix request-based dm's use of
> dm_wait_for_completion") seems to correspond to the modification of
> dm_wait_for_completion().
> >   	if (!r)
> >   		set_bit(dmf_suspended_flag, &md->flags);
> 
> Perhaps adding another fix tag would be more appropriate?

Those tags come directly from the original commit.
