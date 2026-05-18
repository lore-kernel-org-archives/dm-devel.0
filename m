Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650302DC767
	for <dm-devel@lists.linux.dev>; Mon, 18 May 2026 19:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132486; cv=none; b=gSHBrAn+kImwErG4a+6jKbypJEEOaj1+3t9xeJJT1NEdJjxDoNalPNAJGkfAcAe3hob6DZ3WTh2dXFRcfshsnWQoMboNzdgVodL2Fcid1IebnHdz73cG88MmqgGY9VnXX2KxG4Rk8fPVG/eqot8ciS99NPfBcVF0aCrC/beFhGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132486; c=relaxed/simple;
	bh=m0lQDFVtZya6Tr87FyHBc1sTpV2dpx3pEnE2dKQ5QPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=BkYdUM+yoa3SXttSJRwF6yGU3fzQ6Ld+678euXaBFUk1gadAi6yE9V4DHd0Z7L8d8IZTb3k435id2j1RqJ9q6puaomfeRzttEBSGyHtb4f5d8FfTsz4C6jOo4UMLvSh4Tqv7HRbYBQs8qSR7JTVTLgvkeYn6jZ/pee5/9SKox4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LAk9Z57h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LAk9Z57h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779132483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hpGBy1b2Qd4FaU9/BixeBFmCwqbbiqWXIVPjZnT8oWw=;
	b=LAk9Z57hMrbMZScFA0Z5Xlx2lEpUVT7haxAaLoTgXkUAHSOiH8yUVeF7h1C4tqYPsd5jKw
	MSCrhv1qOiOwUUwU4GzQeUaqmRtLpbA9RXlUhp3qcuuf26p9SB3WibbPwDRGeTMVoCLM2d
	nGRBnmp0u96D5oQQ98ZCuNzqNFJWGAE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-HXtw-cxWMnWLffXbYNDusQ-1; Mon,
 18 May 2026 15:27:59 -0400
X-MC-Unique: HXtw-cxWMnWLffXbYNDusQ-1
X-Mimecast-MFC-AGG-ID: HXtw-cxWMnWLffXbYNDusQ_1779132478
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 770BA19560A6;
	Mon, 18 May 2026 19:27:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04F6319560A2;
	Mon, 18 May 2026 19:27:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64IJRuFo3679907
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 18 May 2026 15:27:56 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64IJRuBc3679906;
	Mon, 18 May 2026 15:27:56 -0400
Date: Mon, 18 May 2026 15:27:56 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 06/18] libmultipath: use shared_ptr for checker classes
Message-ID: <agtoPFRlhXx7lJzH@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-7-mwilck@suse.com>
 <agPKtqVRFSIsxerR@redhat.com>
 <41f748a2979937ca6d7e8016d06de9ddc4c4d129.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <41f748a2979937ca6d7e8016d06de9ddc4c4d129.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zvRt5kkswtyIBEtoIXt2xj22tDKcc1NcTjy8KG0EZRU_1779132478
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, May 17, 2026 at 11:57:25AM +0200, Martin Wilck wrote:
> On Tue, 2026-05-12 at 20:49 -0400, Benjamin Marzinski wrote:
> > On Tue, May 05, 2026 at 05:43:20PM +0200, Martin Wilck wrote:
> > > Utilize the share_ptr code for tracking the refcount of checker
> > > classes.
> > > 
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/checkers.c | 98 +++++++++----------------------------
> > > ----
> > >  libmultipath/checkers.h |  2 -
> > >  2 files changed, 20 insertions(+), 80 deletions(-)
> > > 
> > > diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> > > index 8f18ca6..a3b9cc8 100644
> > > --- a/libmultipath/checkers.c
> > > +++ b/libmultipath/checkers.c
> > [...]
> > > @@ -163,8 +143,7 @@ static struct checker_class
> > > *add_checker_class(const char *name)
> > >  		goto out;
> > >  
> > >  	c->mp_init = (int (*)(struct checker *)) dlsym(c->handle,
> > > "libcheck_mp_init");
> > > -	c->reset = (void (*)(void)) dlsym(c->handle,
> > > "libcheck_reset");
> > > -	c->thread = (void *(*)(void*)) dlsym(c->handle,
> > > "libcheck_thread");
> > > +	c->reset = (void (*)(void))dlsym(c->handle,
> > > "libcheck_reset");
> > 
> > Nitpick. Dropped a space here.
> 
> I didn't do that. clang-format did, as it also reformats context lines
> in patches. I think clang-format is correct. We usually don't use space
> after cast, do we? (As usual, our code base is inconsistent in this
> respect).
> 
> While I don't want to enforce formatting style throughout the entire
> code base, I tend to keep the changes that clang-format applies to
> context lines (be it only to avoid red lights from the GitHub CI).
> 
> Do you disagree with this policy?

It's fine. It just doesn't match the dlsym lines around it, which is fine.
-Ben

> 
> Regards
> Martin
> 
> > 
> > >  	c->pending = (int (*)(struct checker *)) dlsym(c->handle,
> > > "libcheck_pending");
> > >  	c->need_wait = (bool (*)(struct checker *)) dlsym(c-
> > > >handle, "libcheck_need_wait");
> > >  	/* These 5 functions can be NULL. call dlerror() to clear
> > > out any
> > [...]
> > > @@ -371,43 +350,6 @@ bad_id:
> > >  	return generic_msg[CHECKER_MSGID_NONE];
> > >  }
> > 
> > Removing the checker thread stuff is more of a cleanup from d1ebd977.
> > It
> > should probably either be it's own cleanup patch, or it should at
> > least
> > get mentioned in the commit message.
> >   
> > > -static void checker_cleanup_thread(void *arg)
> > > -{
> > > -	struct checker_class *cls = arg;
> > > -
> > > -	free_checker_class(cls);
> > > -	rcu_unregister_thread();
> > > -}
> > > -
> > > -static void *checker_thread_entry(void *arg)
> > > -{
> > > -	struct checker_context *ctx = arg;
> > > -	void *rv;
> > > -
> > > -	rcu_register_thread();
> > > -	pthread_cleanup_push(checker_cleanup_thread, ctx->cls);
> > > -	rv = ctx->cls->thread(ctx);
> > > -	pthread_cleanup_pop(1);
> > > -	return rv;
> > > -}
> > > -
> > 
> > Also, start_checker_thread() is stil declared in
> > libmultipath/checkers.h,
> > along with a comment.
> > 
> > -Ben
> > 
> > > -int start_checker_thread(pthread_t *thread, const pthread_attr_t
> > > *attr,
> > > -			 struct checker_context *ctx)
> > > -{
> > > -	int rv;
> > > -
> > > -	assert(ctx && ctx->cls && ctx->cls->thread);
> > > -	/* Take a ref here, lest the class be freed before the
> > > thread starts */
> > > -	(void)checker_class_ref(ctx->cls);
> > > -	rv = pthread_create(thread, attr, checker_thread_entry,
> > > ctx);
> > > -	if (rv != 0) {
> > > -		condlog(1, "failed to start checker thread for %s:
> > > %m",
> > > -			ctx->cls->name);
> > > -		checker_class_unref(ctx->cls);
> > > -	}
> > > -	return rv;
> > > -}
> > > -
> > >  void checker_clear_message (struct checker *c)
> > >  {
> > >  	if (!c)

