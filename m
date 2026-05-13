Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73C8349CF3
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 01:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778634573; cv=none; b=qhCZp8RCK6/KW2HthZnBA1b+gVPbF5Ciq6+eRe9cMF+ehQs3ls9Yib3s3UWTzXapybwb+SuU22D9xleYzokplvxKSqroVgTS6Vj7RYtMao/mqL6HJyaa3XnqepPM52tJ4nCQTHXeCBGwQPuXT0q5zhjMzqyY1eN9pfnW0vLI5fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778634573; c=relaxed/simple;
	bh=qJSH2rqRvD8nZNMmKF9UVDFxkJaAjQVcHReSzS6k49M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=EBIQziLQYk4vH/IjqT1QnrzXHBt/FS52zv7oOcmSXzK2+l8HoKryXTBsa537DRVG9R/7FA+1jBzPoX1y3EXpEdEDhm23v/7r+8kae4CYzum07dn3zO6WhrsVneufP3af4SUEOTUO8EFekXUCNIumy1oqtoOpXfEtR9O7Ybp92qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MC7QFLbk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MC7QFLbk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778634569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qJSH2rqRvD8nZNMmKF9UVDFxkJaAjQVcHReSzS6k49M=;
	b=MC7QFLbk0m5vfZaS8mOvX4B6RrgTT51RK3PQz2sl2inS8GVAqYkt0g0NJ0nYcDj+GdHEJX
	C7uzzJKHg8knKkmjDf69xc1KDNZiBjK59yf4POrsy08LV+2Ha0wKCzyOXEOPF8oFzg32+r
	AcTNZRISVxN2DhCRtpZCA90dDFKIlIE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-3BfX5w_NPtCggaEn-JstcA-1; Tue,
 12 May 2026 21:09:27 -0400
X-MC-Unique: 3BfX5w_NPtCggaEn-JstcA-1
X-Mimecast-MFC-AGG-ID: 3BfX5w_NPtCggaEn-JstcA_1778634566
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37B5D18005BF;
	Wed, 13 May 2026 01:09:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04A27180058F;
	Wed, 13 May 2026 01:09:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D19PB63332437
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 21:09:25 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D19O3r3332436;
	Tue, 12 May 2026 21:09:24 -0400
Date: Tue, 12 May 2026 21:09:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 16/18] libmultipath: async_checker: add context_size and
 init symbols
Message-ID: <agPPROSan-bLfsvz@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-17-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-17-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RGSJPzFC-UL9KTN4eLlEu5cIw3IMg94DNHjWZ13c_qY_1778634566
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:30PM +0200, Martin Wilck wrote:
> Add two symbols that can be read from checker .so files with dlsym():
> "async_context_size" for defining the size of a checker-private context,
> and "async_init" for initializing this context.

Why not "libcheck_async_context_size" and "libcheck_async_init", to
go with "libcheck_async_func"? Otherwise this looks good.

-Ben

