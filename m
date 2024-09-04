Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE5E383A3
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 22:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725490424; cv=none; b=gHnraS+wm5ceC7ia8nD72Z0JxH4eR7wBP1GwTRTSnWDm3xT45/XZdVF/uQR/pEl+Bxy44c/Upq9+RbluSY/kZGDGu4sv5IGaerzHj9bAIo/VaygxRODTGjh2L2VvsCLSZA30uz0SQm/16NQwMSXcCfnL4l88Z6Bt5xb1yEMAgAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725490424; c=relaxed/simple;
	bh=xteuIKkoD3j1GlviRBTZJbwEAgVROJG84UYydiZKHQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=myZacTtOOR0dL/QSoXAm387jk+DlOAFIFWouiAtyCzRSPy6dSnhP/z9BtwaRCiAVycimdCQeMNyUBhpi5QMd3NV/GtmFHGeuaau69aS20LfFGlw3sPsZf45y43AEVn5xYPzN5igkbLbmnTHtGcZxevET+zXF1HhS9bmPPDozcm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X27y+J3g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X27y+J3g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725490421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VhHS4/8sbI8piybYn3lgLnrNvoft7SYS8HBhfU5tQZw=;
	b=X27y+J3g6HwwgEXFIDUkIeYH1NmKLFrd+R5lb78tbW8w6b8kKVzxBJSlw7qiZRFnFV+LRK
	oGYU3Yxwpq2GAOCppRRTZRCODpcmB2Le491lEIQPcJ6ybifHpReWRmHb04indejJd59/t1
	B3iIiGYLLPbLooyMWXdHWjWnp4N2ruw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-301-XGUeU69EOmC_NyrA8srI3A-1; Wed,
 04 Sep 2024 18:53:39 -0400
X-MC-Unique: XGUeU69EOmC_NyrA8srI3A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 580821955F44;
	Wed,  4 Sep 2024 22:53:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0473B19560AA;
	Wed,  4 Sep 2024 22:53:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 484Mradg492361
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Sep 2024 18:53:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 484Mrab2492360;
	Wed, 4 Sep 2024 18:53:36 -0400
Date: Wed, 4 Sep 2024 18:53:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 05/15] multipath-tools tests: fix up directio tests
Message-ID: <Ztjk8I_6_6f8roHP@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
 <20240828221757.4060548-6-bmarzins@redhat.com>
 <534d539850c59ac55911bdd584737934cb24d060.camel@suse.com>
 <ZtinIZY2jMe0ZDNX@redhat.com>
 <d0f8e48a5ac7e42d1643c07dd6b08a601aef8f07.camel@suse.com>
 <7a08873cbc34964f97fce214c4906568c1b86c77.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7a08873cbc34964f97fce214c4906568c1b86c77.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2024 at 09:43:59PM +0200, Martin Wilck wrote:
> On Wed, 2024-09-04 at 21:36 +0200, Martin Wilck wrote:
> > On Wed, 2024-09-04 at 14:29 -0400, Benjamin Marzinski wrote:
> > > On Wed, Sep 04, 2024 at 06:12:37PM +0200, Martin Wilck wrote:
> > > > On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> > > > > Make the directio tests work with libcheck_pending() being
> > > > > separate
> > > > > from
> > > > > libcheck_check
> > > > > 
> > > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > 
> > > > There's still something wrong with this test. I'm seeing lots of
> > > > CI
> > > > errors with your complete series applied.
> > > > 
> > > > https://github.com/openSUSE/multipath-tools/actions?query=branch%3Atip
> > > > https://github.com/openSUSE/multipath-tools/actions/runs/10704501258/job/29677643779
> > > 
> > > It looks like your "tip" brach is missing:
> > > [PATCH 04/15] libmultipath: remove pending wait code from
> > > libcheck_check calls
> > 
> > Yeah. That patch ended up in a different mail folder, and I didn't
> > notice. Weird. CI looks much better now.
> 
> But some issues remain, e.g.
> 
> https://github.com/openSUSE/multipath-tools/actions/runs/10708349169/job/29690448105

I'm pretty sure that due to valgrind and virtual machine induced delays,
we end up waiting more than 1ms in test_check_state_async() between
starting the checker at

do_check_state(&c[256], 0, PATH_PENDING);

and calling libcheck_pending at

do_libcheck_pending(&c[256], PATH_UP);

This means that we will only call get_events() once, and we won't get
the IO for the c[256] which the test returns on the second call to
get_events(). This would cause the error from the github CI runs (I
haven't been able to reproduce this myself locally, but I haven't tried
on an Ubuntu VM):

[ RUN      ] test_check_state_async
[  ERROR   ] --- 0x6 != 0x3
[   LINE   ] --- directio.c:237: error: Failure!
[  FAILED  ] test_check_state_async

Since the time it takes the test program to run is out of our hands and
the checker wait time isn't configurable, I'm not sure that we can
guarantee that this test will always run correctly while testing this
code path without being a little hacky and manually bumping up
ct->endtime so that we're sure it hasn't already passed when we call
libcheck_pending().

Obviously if we took your route and did the waiting outside of
libcheck_pending(), then this code path wouldn't exist and the problem
would go away. I'll think on this a bit.

-Ben

> 
> Martin

