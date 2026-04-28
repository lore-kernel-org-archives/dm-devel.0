Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFA972623
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 00:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777335877; cv=none; b=PJmIdAH7ox9/mGpGrJ8nceMmF0jBJo+DZ7LmDsw+uCtv3tsmwY6M198Y80c+oE77IVC2/niPeVYOonbeoB3tlFAOwqoG4V+Z8uofCwlHoSVJu+1V7x3k/pvJGxuoSk7r/GAfXuIYsBoHLlF3H8kApDlJjWa+4vu7hpYWX8+rjPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777335877; c=relaxed/simple;
	bh=xUCr+kti8R9hKYXSKt/77eSNPKTzDQGYlSLdca4F9k0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=bJvWi/MIlKGw3VQJoq5IxfcQyUgA0gb/T6c0vhZ+EPpsbz7lqudhMjFDodn83grra1c6gFhZU/UaeNnqlsAhuPorP0TVs5k3+N5vieKjq5yTu7UnOPhEpIhVP0sEWDZMmBSwxIayDuka1ja0P4G0onDlqdiU8ZKqQd/hXg0cCYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fkWgfHMn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkWgfHMn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777335875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jw44C1ok4UN5chuv8IBQ6wIV/vSHPhe8vLCxkeSscls=;
	b=fkWgfHMniBUU4vGN+21WHAHVQxCxH/pxxh8I7Cagdj1WI/fcFnpyS7V0x2u78nZhpPNbjC
	urSApQU60LTj5ACfwG0ss+Z3m1aGytqFUH5bo8D6Yp3fyyTvfasoe7BBtYrD7rcN3qthF/
	vVhYutgSQ2Ylzm+47lSaXocV7mXorQc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-zTfCggjKM_m4rjfbBkgx4Q-1; Mon,
 27 Apr 2026 20:24:33 -0400
X-MC-Unique: zTfCggjKM_m4rjfbBkgx4Q-1
X-Mimecast-MFC-AGG-ID: zTfCggjKM_m4rjfbBkgx4Q_1777335872
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 26BA01800451;
	Tue, 28 Apr 2026 00:24:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D2881180047F;
	Tue, 28 Apr 2026 00:24:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63S0OUGm2748375
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 20:24:30 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63S0OUrT2748374;
	Mon, 27 Apr 2026 20:24:30 -0400
Date: Mon, 27 Apr 2026 20:24:30 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 3/5] multipath-tools tests: add test program for
 thread runners
Message-ID: <ae_-PpInT2ZT4yBC@redhat.com>
References: <20260423204446.472642-1-mwilck@suse.com>
 <20260423204446.472642-4-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260423204446.472642-4-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s3vSuwNNKmnbBdf7uj88FewNgs8JSNoUN2AY83tlDSU_1777335872
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 23, 2026 at 10:44:44PM +0200, Martin Wilck wrote:
> Add a test program for the "runner" thread implementation from the previous
> commit. The test program runs simulated "hanging" threads that may time
> out, and optionally kills all threads at an arbitrary point in time. See
> the comments at the top of the file for details.
> 
> Also add a test driver script (runner-test.sh) with a few reasonable
> combinations of command line arguments.
> 
> The test program has been used to test the "runner" implementation
> extensively on different architectures (x86_64, aarch64, ppc64le, s390x),
> using both valgrind and the gcc address sanitizer (libasan) for detection
> of memory leaks and use-after-free errors.
> 
> For valgrind, a suppression file needs to be added, as valgrind doesn't
> seem to capture the deallocation of thread local storage for detached
> threads in the test case where the test program is killed. The suppression
> affects only memory allocated by glibc. This leak has not been seen with
> libasan, only with valgrind.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

