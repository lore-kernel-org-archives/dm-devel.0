Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72921456286
	for <dm-devel@lists.linux.dev>; Mon, 17 Aug 2026 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786984699; cv=none; b=Yd9w56vXlcKN2Nd9YaHy/f612qsYpLlOrvKNU3ESo7qg+YbAlZOnw0cINHikGJiNSmyVnI/ZxV+uywlwACE2y+1MgA1zSln39MgRSJ3t1YaKyJ8SxBCEDxlEqchsUDQ/jxQhCYXKCEIv6pqyX/LDsehgpzmbJ1QLKVR0VSCJPtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786984699; c=relaxed/simple;
	bh=IfRho8fqzRqTS9CLbda4QyvcgsD0V46YKHNgCve52R4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=jvguYCa/2u1YroRNnzG/4mezP3t+mnuy7O3Gn0G6k8bypxKBRkRxPr4SVDYvWWP5jod+DQWTzYooKjPnq5fmYqH08ua/iWcN1XKQcQ+V2tDhcMGM3E+cuBfNgtBEyxC6uqwkwbspx0G0+Fc+NULxZr7qZzdCu7ICl9fn7dof3LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PmCtOgpI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PmCtOgpI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786984696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOzhb9NoEkV97Gv3qIjkwGZZ40L9NNVjp3ehoWV/JF0=;
	b=PmCtOgpIjjHzcZovPW4x24PHf93xQlzkQVkJoh2x6AzSfwrsxnobKvgIzWc6fFx6cck+9Y
	Rgz5Rt6ZC7nJ+AiEiahUOGg9LvYrtbSAKnpwa+iOkXcv8AKtG8gN6GUGXTjioPnOTUKcjG
	USr27m0AFh4kZQ/1XCp0v+JDUQdFNbs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-577-oayov7bSPs6Jbo9DSNjm6g-1; Mon,
 17 Aug 2026 12:38:11 -0400
X-MC-Unique: oayov7bSPs6Jbo9DSNjm6g-1
X-Mimecast-MFC-AGG-ID: oayov7bSPs6Jbo9DSNjm6g_1786984690
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 956EE180064B;
	Mon, 17 Aug 2026 16:38:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B21718005BB;
	Mon, 17 Aug 2026 16:38:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 67HGc8Og2351869
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 12:38:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 67HGc8Or2351848;
	Mon, 17 Aug 2026 12:38:08 -0400
Date: Mon, 17 Aug 2026 12:38:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: dm-devel@lists.linux.dev, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-delay: advertise flush support
Message-ID: <aoM48Je-Dhxypa0e@redhat.com>
References: <20260814045813.3148127-1-matthias.goergens@gmail.com>
 <an9t_JepVb2zJcD_@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <an9t_JepVb2zJcD_@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: mMoXbKNEN6Bg6eFPPyj-wTSbtEFiYNqUiLb3cZGD1Sc_1786984690
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 14, 2026 at 03:35:25PM -0400, Benjamin Marzinski wrote:
> On Fri, Aug 14, 2026 at 12:58:12PM +0800, Matthias Goergens wrote:
> > dm-delay parses and reports a flush delay class (the 9-argument table
> > form's <flush_device> <flush_offset> <flush_delay>), delay_map() routes
> > REQ_PREFLUSH bios to it, the target sets num_flush_bios = 1, and
> > Documentation/admin-guide/device-mapper/delay.rst documents flush
> > delays. But the target never sets ti->flush_supported, so
> > dm_table_supports_flush() is false: the block layer strips REQ_PREFLUSH
> > as a no-op before the bio ever reaches the target (blk_insert_flush()),
> > REQ_FUA is stripped too, and the flush delay class is dead code. Anyone
> > who configures a flush delay on dm-delay (e.g. to model slow-flush
> > devices in tests) silently measures nothing.
> > 
> > Set ti->flush_supported = true so the flush delay class is actually
> > reachable. dm core clones empty flushes with
> > REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC (__send_empty_flush), which
> > delay_map() already routes to the flush class, and delayed completion
> > is already handled for every class by the delay worker.
> > 
> > Verified with dm-delay over a virtio-scsi disk: without this change
> > REQ_PREFLUSH completes immediately and REQ_FUA writes are stripped by
> > the block layer; with it, flushes take the configured delay and FUA
> > writes reach the wire (measured as device-time per MB at D_f = 200 ms
> > and 800 ms flush delays).
> > 
> 
> The code seems fine, but could you please change the commit message.
> It's not true that "Anyone who configures a flush delay on dm-delay
> silently measures nothing". dm-delay doesn't *force* the dm device to
> support flushes. It works just like most of the dm targets: linear,
> stripe, raid, etc. If an underlying device sets BLK_FEAT_WRITE_CACHE or
> BLK_FEAT_FUA, the dm device will as well (see blk_stack_limits, called
> by dm_set_device_limits). I assume if you look at
> /sys/block/<underlying_disk>/queue/write_cache, you see "write through".
>

Actually, it might be better to only set ti->flush_supported if
dc->flush.delay is non-zero, so that if the user doesn't want a
flush delay, dm-delay behaves like a linear target for flushes.

-Ben

> -Ben
> 
> > Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
> > ---
> >  drivers/md/dm-delay.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
> > --- a/drivers/md/dm-delay.c
> > +++ b/drivers/md/dm-delay.c
> > @@ -301,6 +301,7 @@
> >  	}
> > 
> >  	ti->num_flush_bios = 1;
> > +	ti->flush_supported = true;
> >  	ti->num_discard_bios = 1;
> >  	ti->accounts_remapped_io = true;
> >  	ti->per_io_data_size = sizeof(struct dm_delay_info);
> > @@ -451,7 +452,7 @@
> > 
> >  static struct target_type delay_target = {
> >  	.name	     = "delay",
> > -	.version     = {1, 5, 0},
> > +	.version     = {1, 5, 1},
> >  	.features    = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
> >  	.module      = THIS_MODULE,
> >  	.ctr	     = delay_ctr,

