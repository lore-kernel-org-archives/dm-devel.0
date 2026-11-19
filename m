Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795109809;
	b=iMAYOWgaX5n7ZsIIrd/y2OE0TEHooxNZSErrsHCsVRWtg7lLMe0QCvVwdhh5uxaF3iuZ
	 y37IG5I5HqD6JckM//tH4cq5Bf0hIHYElkQLQEdTL+brRM5CCvZnSRaRb7bQk5JTQpwjs
	 F/xP8Lv225z+IfWSvUQP0E+nJpcN/4mDZYjz4ncoVpeGIIjr3Nf3E6Q3ghFQlwHxfxSgI
	 LJqqPLG5nqvk5ry3zdA6GZfPq0/u0yMWOPtvVOYvw/fLrYrtq7YxV1wvpVkYMx2hAbinZ
	 ecW9IaLiHQ0TcOYGScR5WtwzTn7WlTIXyAHHrzuT8L4Hi9dafZw9nx2SNBjMFZPkT1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795109809;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=pC72hz4WbRk6wyBmSFsrkPy3hn/LK4UFAZrfhVKv5sA=;
	b=O5weDlo80i4/PDuisDRPPsgNFq7rbhHxkvv0VUh8o1G+JZ1XKdQE6PHJjWh/C73J9WWJ
	 Uon2OGdG3fmbsKi/0kk0K/5X0qkAY3TmRN7D82ksDWLRmK6mmpW7z5CB7HojZCwkPKkp5
	 7NC239Voezl5jcBw79G/WSnsT91VqCJE5QylpCVwJZpVQTLZ2mt7nZwymvJfC11KWnK53
	 /DyEqVQqhYDn+kamuF+Wwpdlwcxev+rhvn2nWBHvTjpCzMw/kIeX1GTssIja71sX/+ciK
	 OhZCQUiywA0TuC1gs0eralE3PTfgc4QE7SJqMwaiPrqq+D3NVHndKqNtfDQewGEBW3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="D/3wVUg0";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E25A606A325
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 17:36:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E25A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=D/3wVUg0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795109807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pC72hz4WbRk6wyBmSFsrkPy3hn/LK4UFAZrfhVKv5sA=;
	b=D/3wVUg0Y8SVco+F0sHbtkrXZNZFNrFAxLMlfU7rrTAN470YoQ9EB3K4FHtNkVgQE7KFJA
	Zh3VJr0udf7AIj33JmrBmcT8m7e1JWDzqTtqkPSOSDmfbHG4IPsJ7CYR7zoJc9xznSRgqT
	K8CWdGWnxadLg+8HMXWQ2EuwliEkNic=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-HOZEFmh7Nam-dlAMnpUTlg-1; Thu,
 19 Nov 2026 12:36:44 -0500
X-MC-Unique: HOZEFmh7Nam-dlAMnpUTlg-1
X-Mimecast-MFC-AGG-ID: HOZEFmh7Nam-dlAMnpUTlg_1795109803
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EAC4C1955F1A;
	Thu, 19 Nov 2026 17:36:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8460E180055C;
	Thu, 19 Nov 2026 17:36:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AJHaf5R834892
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 12:36:41 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AJHadJB834876;
	Thu, 19 Nov 2026 12:36:39 -0500
Date: Thu, 19 Nov 2026 12:36:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Ganesh Andhale <gandhale@redhat.com>
Cc: christophe.varoqui@opensvc.com, dm-devel@lists.linux.dev, mwilck@suse.com
Subject: Re: [PATCH] multipathd: cleanup global queues after threads exit
Message-ID: <av8zp_HtEUoGBn-F@redhat.com>
References: <20261112153310.19652-1-gandhale@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261112153310.19652-1-gandhale@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zPtRZdXBKWS16Fpx93cQgFnhcW_YfdwrMFA9hvCf4CU_1795109803
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 12, 2026 at 09:03:10PM +0530, Ganesh Andhale wrote:
> cleanup_global_uevq() and cleanup_global_purge_queue() were registered
> as pthread cleanup handlers in worker threads. During shutdown, these
> handlers could run as soon as their owning thread was cancelled, while
> another thread that also accessed the same global queue had not been
> joined yet.
> 
> This allowed the global uevent or purge queue to be cleaned while a
> producer or consumer thread could still touch it.
> 
> Move the global queue cleanup to cleanup_queues(), which is called
> after cleanup_threads(), once all related threads have been joined.
> Keep the pthread cleanup handlers only for thread-local temporary lists
> and other resources owned by the cancelling thread.
> 
> Export cleanup_global_uevq() from libmultipath so multipathd can call
> it during daemon shutdown.
> 
> Signed-off-by: Ganesh Andhale <gandhale@redhat.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

