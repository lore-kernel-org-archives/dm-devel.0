Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6894022329
	for <dm-devel@lists.linux.dev>; Thu,  9 Nov 2023 17:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SRCcjJoV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699550801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M5caDkB/fNBoDgipRySBeQzoGWDX4RgoBAoj9nwPCzM=;
	b=SRCcjJoVL0F8F0HxtS7Lr0E0B/Udmu+6MM/ivqHvwRLEGYXbTfFufwbzqtS+6reSgrKsoO
	MMQBU8MnJjRHk+wxest0WxgU2fPeHlFvSGYWxr4U2UWmRc1hhozLsxdDWn2SqEXTko9ASL
	EVDWqzBqvy/pyC9kZcnW5aio7N9dWuw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-K2-RmjLQNWebSB0oCxzl4Q-1; Thu, 09 Nov 2023 12:26:39 -0500
X-MC-Unique: K2-RmjLQNWebSB0oCxzl4Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B00E283DCCB;
	Thu,  9 Nov 2023 17:26:38 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A67401C060B1;
	Thu,  9 Nov 2023 17:26:38 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A9HQcEF097480
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 9 Nov 2023 12:26:38 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A9HQcua097479;
	Thu, 9 Nov 2023 12:26:38 -0500
Date: Thu, 9 Nov 2023 12:26:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
        "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/7] libmultipath: Add max_retries config option
Message-ID: <ZU0WTmeqxb+vKRaf@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
 <20231102221507.105371-2-bmarzins@redhat.com>
 <e704003e124116e72771d2b7ef90ca66ef242e1c.camel@suse.com>
 <ZUwG6iJU1xZ/S8WS@bmarzins-01.fast.rdu2.eng.redhat.com>
 <4eb3625118838c31b4348c24f0712665b9a05109.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <4eb3625118838c31b4348c24f0712665b9a05109.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 09, 2023 at 09:07:23AM +0000, Martin Wilck wrote:
> Hi Ben,
> 
> On Wed, 2023-11-08 at 17:08 -0500, Benjamin Marzinski wrote:
> > On Wed, Nov 08, 2023 at 03:36:14PM +0000, Martin Wilck wrote:
> > > On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> > > > This option lets multipath set a scsi disk's max_retries sysfs
> > > > value.
> > > > Setting this can be helpful for cases where the path checker
> > > > succeeds,
> > > > but IO commands hang and timeout. By default, the SCSI layer will
> > > > retry
> > > > IOs 5 times. Reducing this value will allow multipath to retry
> > > > the IO
> > > > down another path sooner.
> > > > 
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > 
> > > 2 nitpicks below. Please explain to me again why we recommend to
> > > activate shaky paths detection with this. What will go wrong if the
> > > user uses max_retries without shaky path detection?
> > 
> 
> I've thought about this some more after my review. Similar to the auto-
> resize, do we need to make this parameter a hardware property? AFAICS
> it would be sufficient to have it as setting in the "defaults" section,
> which would make the patch much simpler.

Sure.

> 
> > In the case were the path_checker keeps succeeding, but the IOs keep
> > hanging, multipathd will just keep restoring this path over and over
> > again. That's the sort of path ping-ponging that shaky path detection
> > should be able to stop. I guess this is can speed up other cases for
> > failover as well, so I can leave that off.  Hopefully people know
> > that
> > if they are seeing ping-ponging, shaky path detection can help with
> > it.
> 
> This is a general argument for enabling shaky paths detection. But I
> don't see how it relates to max_retries. Decreasing max_retries should 
> make it less likely that regular IOs are hanging while the path checker
> succeeds, whether or not shaky path detection is enabled. By decreasing
> max_retries, we force the kernel to treat regular IO more like
> passthrough IO. AFAIU that should decrease the difference of failure
> probability between the path checker and regular IO.

I wasn't being clear. Changing this won't make ping-ponging more likely.
It's just that if you are in the case where IO is hanging for extended
periods of time and then failing, but the path checker is succeeding,
and you want to an efficiently running system, changing max_retries will
only get you halfway there, since it won't fix the ping-ponging. I agree
that the ping-ponging is a seperate issue. My brain was sort of stuck in
the specific customer issue that drove all this work, which did involve
ping-ponging. 

> I have another question; as pointed out in my previous post about this
> patch, max_retries only affects the kernel's "maybe_retry" case, IOW
> mostly DID_TRANSPORT_DISRUPTED. This is a condition that can happen
> with shaky paths. But SCSI command timeouts are also likely, and for
> that case, reducing max_retries isn't going to help, as timed out
> commands won't be retried but passed to the error handler.
> DID_TRANSPORT_DISRUPTED errors will happen quickly most of the time.
> IOW, I don't quite understand how decreasing max_retries substantially
> decreases the time regular I/O would be hanging [1]. I associate
> hanging IO mostly with command timeouts. Am I missing something here?

This work is all in response to a customer, who found that the only way
to work around what turned out in the end to be an HBA issue, was to
lower max_retries and turn on shaky path detection, to make multipath
quickly ignore unusable paths. I admit that I didn't dig into why
reducing max_retries sped things up. They just asked if it was possible
to make multipath control this scsi config parameter like it does
others, and it seemed like a reasonable request to me.

-Ben

> Regards
> Martin
> 
> [1] Note that SAM_STAT_BUSY is treated by the kernel with
> ADD_TO_MLQUEUE, which means max_retries is ignored.

