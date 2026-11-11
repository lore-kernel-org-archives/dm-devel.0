Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794416270;
	b=XKUeIRb/A8isYI8wTUXwmGka55WuuS+tf2Pv50vXgv68orL/dEP4rvouZ/53wsMr4XBX
	 xzH9IUtrbyL8iZk2U77J8ovTCa2hYqUtRix8pNKAskDZcNRrpyFnkw7Hd65pn4IpJ2NNr
	 GzJpXI162Nl6NI2FHr/REk9N0hIFme2kPJVEz0IAa2dHy1nxxmrZB9mEF/PQXpP2P1pR+
	 AukilU9BG5VFLuRkWHTrmokh0AAstIIaElu3Kh6Hv3fIPxUYFdRx8jDvUlYDblnLjiIYi
	 7mBn704lvUlQGOMEeNlgrS6Yc8zZN2RVdT1J4JMGgnRk9aMgLDddsar1P0357FbBzDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794416270;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Disposition;
	bh=FruUgxjdM+QQtNM5gAaurdz1eFBoY5sZZQzGjTtIyYM=;
	b=jKlH1pTFYLikQFy0I3SFJ95/74UEKJFBuZyQDhQIMfPYj0ZWyKibAhKaDtoJm20jhPzd
	 w0NU5OkcC8xm23MWbbnQ5hgRTAL9XUyNpLKFrag9i44PxUmiZdqs0hrKk/5PFB+1KrfVY
	 YnPvjgl7jeMnnDxecaUWB23zzK3XXPTc1f6dMnUy/0goYdVEu/D9nEYjk7wz5HvEgWMX0
	 4a3vr5O3D+kcg8wV7992WlJj+82TA9w+q4pbqNt/Xvy+V8Ds4biiBnqpo/P5ZHLoIRLTm
	 MZEKsfM4NmTcrUxzyYkuFoIkXrd1jBgz8lONjcOJaBQFNSAXLYC6wHthRDDNIyHz7jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dilCPYuu;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAEF606A32A
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 16:57:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FAEF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dilCPYuu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794416268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FruUgxjdM+QQtNM5gAaurdz1eFBoY5sZZQzGjTtIyYM=;
	b=dilCPYuuaXUGoKkHP1fvJfDdlZjLPwhqGGOgVVCI6DX7tnwSHgbDMhSeYcAxsY/f389dq+
	iBKJCp1KpLLvtSXTFxeDFipn3P53Qo1HbEaDy4t3VCPo4xfaqhaRtX8rIaUrid4EhVjqvq
	PdPEW/vHStjROuN5CKMlpbCS+N899pQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-XC2OGaWyMiyE1-t7ACZCFQ-1; Wed,
 11 Nov 2026 11:57:44 -0500
X-MC-Unique: XC2OGaWyMiyE1-t7ACZCFQ-1
X-Mimecast-MFC-AGG-ID: XC2OGaWyMiyE1-t7ACZCFQ_1794416263
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B824180059B;
	Wed, 11 Nov 2026 16:57:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA785410;
	Wed, 11 Nov 2026 16:57:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6ABGvfXg1295326
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 11:57:41 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6ABGveS91295321;
	Wed, 11 Nov 2026 11:57:40 -0500
Date: Wed, 11 Nov 2026 11:57:40 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
        syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] dm-integrity: initialize journal accounting in
 dm_integrity_ctr
Message-ID: <avSehH3mO12esPfa@redhat.com>
References: <20261111004905.1047753-1-bmarzins@redhat.com>
 <6200b697-d686-cff2-1de5-d4948c171a4f@redhat.com>
 <avSXoMubUuU6kiR5@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <avSXoMubUuU6kiR5@redhat.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: bpZRUtJYnJ9TnRfSTxTnyG41U2ksWgRM6EURwRvxsJo_1794416263
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 11, 2026 at 11:28:17AM -0500, Benjamin Marzinski wrote:
> On Wed, Nov 11, 2026 at 03:37:44PM +0100, Mikulas Patocka wrote:
> > I think that we shouldn't attempt to flush the journal at all when the 
> > device is in erroneous state - because flushing it could cause other 
> > problems.
> > 
> > I've created a patch that disables journal flushing if the dm-integrity 
> > device is disabled due to an error - please review it.
> 
> I was on the fence about doing something similar to your method. It does
> drop any previous journal writes to the partially filled uncommitted
> section, which is a bigger change than just fixing a kernel warning. But
> that's the way you think we should go, I'm fine with that.
> 
> The way I planned to solve it was (copy-pasted so the whitespace is all
> messed up):
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c              
> index 1659a11a1a29..bf817c5ce2b3 100644                                         
> --- a/drivers/md/dm-integrity.c                                                 
> +++ b/drivers/md/dm-integrity.c                                                 
> @@ -2908,7 +2908,7 @@ static void integrity_commit(struct work_struct *w)       
>                                                                                 
>         spin_lock_irq(&ic->endio_wait.lock);                                    
>         flushes = bio_list_get(&ic->flush_bio_list);                            
> -       if (unlikely(ic->mode != 'J')) {                                        
> +       if (unlikely(ic->mode != 'J' || dm_integrity_failed(ic))) {             
>                 spin_unlock_irq(&ic->endio_wait.lock);                          
>                 dm_integrity_flush_buffers(ic, true);                           
>                 goto release_flush_bios;                                        
> 
> Even if we don't call dm_integrity_flush_buffers(), any dirty dm_bufio
> buffers still still get written out. By calling
> dm_integrity_flush_buffers(), we control when they get written out,
> and we want to guarantee that they get written out before we suspend.
> right?

Never mind. dm_integrity_postsuspend() will already call
dm_integrity_flush_buffers() after the queued commit_work is run, so the
dirty buffers are guaranteed to be written out. I'm fine with your
method (aside from the issue that sashiko caught).

-Ben
 
> -Ben
> 
> > Mikulas

