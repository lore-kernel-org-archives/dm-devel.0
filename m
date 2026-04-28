Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79F827E049
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 17:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777398412; cv=none; b=AeErg445i7BRI0Xhf3GvSYVEAQvTMeee/z8BjgyKaII3Ds0aK8LlJvFO60l8akPK+oFKUnaesCDrLzQ5i4rJBglguk+DpJu/cJFpHfYVNBIEilTjrJrtrU1zWPjXUhkpzVM7rCCCUHwr+sGy77yJY+dxA0PAGlcUYJ6vPw/t2zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777398412; c=relaxed/simple;
	bh=+py5uc/Fz2CZmn87E9gYjXJJc0rrdCHb129ovFBdA2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=D1ug5pVFhKx2Q7d1Q5BEJSLZTE6c902jYiFYfmT13alZW7LPW0CUPjPePnb1AfxAalGuGRhDZTOXI4xn7StIbEIhVzE0po1/dLYA0NlKBrSK2XKJwArE2S17K6s0YWLR0LC25e+KYLo2QTD7B18nhtS59kqTTenvmjp8eC49ThE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PnPAQVeF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PnPAQVeF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777398410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c99/9o1mN+1jiK3SnmB3YVS+SxCt+cofnBDYxU+5vqc=;
	b=PnPAQVeFft0ZRpdmKWHLQTQZEWC0VvyGjB+z6ZTAWDKdY2s/1onmaMtp5fEM0qExp2MpeO
	zTwE15ppAbndeh0wlsk3s6CVEpYBub+3rCsHlCfO2vGZ1pVoS1fgKpGSjeVLY81bpGAU/l
	vQQSyI0WlFHAsPHwKuNXhCMEogL4LyE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-nxWprrQEOnKl3sa6xBZEKg-1; Tue,
 28 Apr 2026 13:46:49 -0400
X-MC-Unique: nxWprrQEOnKl3sa6xBZEKg-1
X-Mimecast-MFC-AGG-ID: nxWprrQEOnKl3sa6xBZEKg_1777398408
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A915819560AE;
	Tue, 28 Apr 2026 17:46:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 693AE1800446;
	Tue, 28 Apr 2026 17:46:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63SHkknR2775608
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 28 Apr 2026 13:46:46 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63SHkkA12775607;
	Tue, 28 Apr 2026 13:46:46 -0400
Date: Tue, 28 Apr 2026 13:46:46 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 3/5] multipath-tools tests: add test program for
 thread runners
Message-ID: <afDyhmj4yzEyVQDl@redhat.com>
References: <20260428114942.292307-1-mwilck@suse.com>
 <20260428114942.292307-4-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260428114942.292307-4-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1tCqQ8bzeU7f8HHosWKeG5KqnUyHC_np7YHDIZSaFbA_1777398408
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 28, 2026 at 01:49:40PM +0200, Martin Wilck wrote:
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

