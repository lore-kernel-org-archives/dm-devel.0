Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA99290F
	for <dm-devel@lists.linux.dev>; Fri,  3 May 2024 22:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714777025; cv=none; b=P2YbhhZXmieB9O8wInn2jsJTVSvRz1PJ7cwe3H4Wi+8b6aqG2bYq3MIQApYn8vlOUrPIPt1NA08RKOZY9kTG4GPt+c85wObg43nFkjs6mgttKtJpMzZaO7GLrnE7z549p3hoYeop02pGTAO7pnjgMYWmbJYtXO3vu/X6lpJLcv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714777025; c=relaxed/simple;
	bh=uJJOKWkjqBt2uhIFuLwnJQq6Aqd5UMV3lkTUM7BN94A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=j4B2Ri9evwgzbne+402PuKkr45UFEaF6xJ8QM0KV6HkBGUfubs+RajDDqKMZo+mk+VVkwThpuDZaZ9AkvPanSYETLkokGDovxl1oERlEL6r6xEFS5nQCNJlveeB1y2Atik5HSv9P4JnceStWgEAiAOn7Es/nShA7dRu+roK0hig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CCRPy+5u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CCRPy+5u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714777023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TymXXOrXj2S+8uLLOwXbNIzNBItgkKwtD7YBNfz9Z1M=;
	b=CCRPy+5uIyNRntC8AzqttJo1Pyu0P33tWpsL7MFvrv50cI6QhXBIwbF5CiZigeQTU+PjLX
	QMgE0UF7qiWxQELzD1NhtrKKSKezWJ/pJCokF/SOGC1CMgq4KiUMnaURYBhqUOD5nTqpgu
	cAC4Di2VgsRDjBXQOQ8w0ocA1GRzZI0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-UnB7MPPwOAO0H8fNXLXWWA-1; Fri, 03 May 2024 18:56:59 -0400
X-MC-Unique: UnB7MPPwOAO0H8fNXLXWWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66BC818065AB;
	Fri,  3 May 2024 22:56:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CF9F40C6CC0;
	Fri,  3 May 2024 22:56:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 443Muxm72548242
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 3 May 2024 18:56:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 443Muwc92548241;
	Fri, 3 May 2024 18:56:58 -0400
Date: Fri, 3 May 2024 18:56:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Joel Colledge <joel.colledge@linbit.com>
Cc: Christian Loehle <christian.loehle@arm.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 1/1] dm-delay: fix hung task introduced by kthread mode
Message-ID: <ZjVrulz4zt77Lv6f@redhat.com>
References: <20240426072135.291206-1-joel.colledge@linbit.com>
 <20240426072135.291206-2-joel.colledge@linbit.com>
 <71a31fdb-fad6-4ce9-bda0-2f86633d23a3@arm.com>
 <CAGNP_+Uocb_8YtY9P3EuMQ8sQwWaQtqEMszqbGZrVyrKw-udRg@mail.gmail.com>
 <bc673c7e-f705-46ce-a3c0-0d34f612fe30@arm.com>
 <CAGNP_+WStY+C9=eT=gzC-dYhMtPTj4kzKDSuYiVHi0w41Qa_8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAGNP_+WStY+C9=eT=gzC-dYhMtPTj4kzKDSuYiVHi0w41Qa_8w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 30, 2024 at 06:12:37PM +0200, Joel Colledge wrote:
> On Tue, 30 Apr 2024 at 17:27, Christian Loehle <christian.loehle@arm.com> wrote:
> > On 30/04/2024 15:44, Joel Colledge wrote:
> > > On Tue, 30 Apr 2024 at 16:28, Christian Loehle <christian.loehle@arm.com> wrote:
> > >> Is this an issue for delay > 0 too somehow?
> > >
> > > I believe it is. If there is simply no IO to the delay device, then
> > > nothing will wake the new thread and the same issue will occur.
> >
> > Yes, but might be better to just set_current_state(TASK_INTERRUPTIBLE);
> > instead of the wakeup.
> 
> I'm afraid I don't follow what you mean.
> set_current_state(TASK_INTERRUPTIBLE) would need to be called from the
> worker, but the worker isn't running yet, so it can't do that.
> 
> When preparing this patch, I checked how common kthread_create()
> followed by wake_up_process() is. It is fairly common according to
> this very approximate metric:
> $ grep -r -I -A10 kthread_create | grep -c wake_up_process
> 49
> 
> I just looked through those matches in more detail and noticed that
> there is a kthread_run() macro which does exactly what we need. I will
> change my suggestion to use that instead.
> 
> I will wait for more comments before sending a new version of the patch.

kthread_run() looks like the right solution here. There's no need to
wait for more initialization and the kthread will put itself to sleep
momentarily.  Please send an updated patch.

-Ben

> 
> Best regards,
> Joel

