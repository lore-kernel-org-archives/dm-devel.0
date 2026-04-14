Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAEB318ED2
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 18:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776190787; cv=none; b=nZHH9+jXGRqf5eu5znQEN8J36A2TR0FuyTFawO4C7qxXREObEogvtJnDL4QfvMIXrQJzRBfb05+AC9X3XHQ3/dgzL7zePd+yR0roxabYRg4/ff0vjhx58tiHvSJeR9eDx0awnSa5D025t7/EtnjQL0nVwMUKdkBCDmlF4CY0sAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776190787; c=relaxed/simple;
	bh=BD+fSYOApqzhNLAHt8EvZcUNLapNQ0ZRjxFerMBk0wM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=p+ptPYIzfnbkNDr4dzLY8Ra8EMKIgkpr2/XUtKvmdZbY1vB3usI6ptwlQmF50iSj+C/dcE0uAqYb4pBTnMVuw7AQ7HZ4iqHu/f5aNTTvpKtAbPh5hZb6PisOGLscGl7L+ElFbNlAFjk0lDjzrBIOvizpn9FRim6ZXU8NHnQTuts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fru44fAn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fru44fAn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776190784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7RjOXoWYLfnz8sO1YYh7fuZX3eonFJOwujSktjw16hY=;
	b=fru44fAnDUu9DMnXe7V7jUohSsgTWajoZP9ZN4sja+A09rZFsLS164vw71LtfRkErFGtWi
	VtDffrGodVjoBGd53PhHLGb6CVfIOnMEHaLg+F7qZu2d5P/W5GS/vgEpEzYnpB1k2WnvSY
	1vVfKBCQ5Gvxq8Py8XM/reoxeWNZYjM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-192-PuyVI7DGN_OlGRmSTOhLdw-1; Tue,
 14 Apr 2026 14:19:41 -0400
X-MC-Unique: PuyVI7DGN_OlGRmSTOhLdw-1
X-Mimecast-MFC-AGG-ID: PuyVI7DGN_OlGRmSTOhLdw_1776190780
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 551DF1954B1D;
	Tue, 14 Apr 2026 18:19:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C00B1800579;
	Tue, 14 Apr 2026 18:19:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63EIJavd1945200
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 14:19:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63EIJXId1945199;
	Tue, 14 Apr 2026 14:19:33 -0400
Date: Tue, 14 Apr 2026 14:19:33 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>
Cc: Li Nan <linan666@huaweicloud.com>,
        Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        dm-devel@lists.linux.dev, Xiao Ni <xni@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>, Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: Re: [PATCH] md/raid5: Don't set bi_status on STRIPE_WAIT_RESHAPE
Message-ID: <ad6FNUtSCS_zTrHW@redhat.com>
References: <20260413224556.1914504-1-bmarzins@redhat.com>
 <0e53701a-2471-9b72-eef8-27b168a0f3ea@huaweicloud.com>
 <717caf7b-03ef-41d8-bbb3-f6ce5d4a49fa@fnnas.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <717caf7b-03ef-41d8-bbb3-f6ce5d4a49fa@fnnas.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: X_7zw_Bnq0TK7e7q4xLuJlaUoSqnRU4EfEDc1USnGfs_1776190780
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Apr 14, 2026 at 02:20:40PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2026/4/14 9:25, Li Nan 写道:
> >
> >
> > 在 2026/4/14 6:45, Benjamin Marzinski 写道:
> >> When make_stripe_request() encounters a clone bio that crosses the
> >> reshape position while the reshape cannot make progress, it was setting
> >> bi->bi_status to BLK_STS_RESOURCE when returning STRIPE_WAIT_RESHAPE.
> >> This will update the original bio's bi_status in md_end_clone_io().
> >> Afterwards, md_handle_request() will wait for the device to become
> >> unsuspended and submit a new cloned bio. However, even if that clone
> >> completes successfully, it will not clear the original bio's bi_status.
> >>
> >> There's no need to set bi_status when retrying the bio. md will already
> >> error out the bio correctly if it is set REQ_NOWAIT. Otherwise it will
> >> be retried. dm-raid will already end the bio with DM_MAPIO_REQUEUE.
> >>
> >> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >> ---
> >>   drivers/md/raid5.c | 1 -
> >>   1 file changed, 1 deletion(-)
> >>
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index dc0c680ca199..690c65cd1e29 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -6042,7 +6042,6 @@ static enum stripe_result 
> >> make_stripe_request(struct mddev *mddev,
> >>       raid5_release_stripe(sh);
> >>   out:
> >>       if (ret == STRIPE_SCHEDULE_AND_RETRY && 
> >> reshape_interrupted(mddev)) {
> >> -        bi->bi_status = BLK_STS_RESOURCE;
> >>           ret = STRIPE_WAIT_RESHAPE;
> >>           pr_err_ratelimited("dm-raid456: io across reshape position 
> >> while reshape can't make progress");
> >>       }
> >
> > The link below leads to the same patch, which Kuai has already replied 
> > to.
> >
> > https://lore.kernel.org/all/20260203095156.2349174-1-yangxiuwei@kylinos.cn/
> 
> Perhaps instead of clearing the error code from error path, this problem can be fixed
> by resetting the error code from the issue path if original bio is resubmitted.

I saw your comments at
https://lore.kernel.org/all/71e50b0e-0669-4a40-84d5-3c3061dfb229@fnnas.com/
and I'm a little confused.

The only code path where STRIPE_WAIT_RESHAPE is returned and
bi->bi_status is currently set to BLK_STS_RESOURCE is:
md_handle_request -> raid5_make_request -> make_stripe_request()

make_stripe_request() returning STRIPE_WAIT_RESHAPE, means that
raid5_make_request() will return false (this is the only situation where
raid5_make_request() returns false). This causes the cloned bio to be
freed without completing the original bio.

raid5_make_request() returning false will cause md_handle_request() to
do different things, depending on whether the device is a dm device or a
md device.

For dm devices, md_handle_request() will return false, causing
dm-raid.c:raid_map() to return DM_MAPIO_REQUEUE. This will either
requeue dm's original bio (md's orignal bio is itself a clone of dm's
original bio) if the device is currently in a noflush suspend or
complete dm's original bio with BLK_STS_IOERR if the device is not.
Since the DM_MAPIO_REQUEUE overrides any error for bios that should be
requeued, removing "bi->bi_status = BLK_STS_RESOURCE" doesn't actually
seem important for DM.

But for md devices, md_handle_request() will loop back to check_suspend,
which will complete the bio with BLK_STS_AGAIN if it's a REQ_NOWAIT bio,
and will otherwise wait until the device is no longer suspended to call
raid5_make_request() again. If that later call to raid5_make_request()
completes successfully, the original bio will retain the
BLK_STS_RESOURCE status from the earlier failed call, instead of
completing successfully like it should.

I don't see where a bio could get completed without bio->bi_status
getting set to an approriate error here. Am I missing something?
Obviously clearing the error when you resubmit would fix the issue
as well. It just seems odd to set it and then clear it when AFAICT
nothing requires it to be set in the first place. But perhaps I'm
overlooking something.

Yang Xiuwei, have you verified that this fix actually solves your
problems? If a dm map() function completes with DM_MAPIO_REQUEUE, and
the device is in a noflush suspend, it shouldn't set the error on the
original bio, regardless of the clone bio. It should requeue the bio. If
a dm map() function completes with DM_MAPIO_REQUEUE, and the device
isn't in a noflush suspend, the original bio will always be completed
with an error.

To me, it seems more likely that what you are seeing is
make_stripe_request() returning STRIPE_WAIT_RESHAPE when the dm device
isn't actually in a noflush suspend. I have seen this myself.

-Ben

> 
> >
> >
> > -- 
> > Thanks,
> > Nan
> >
> >
> -- 
> Thansk,
> Kuai

