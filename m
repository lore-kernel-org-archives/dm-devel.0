Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509B83093AC
	for <dm-devel@lists.linux.dev>; Mon,  5 Jan 2026 14:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767625011; cv=none; b=j87iNa1imfj2JMnpBVWGpHiuRgPe/xrZNNsBcCyVJuT7YijFbbFgAKXuowEwr/53fOshSrVQDoDYC82qi5x7AjxP3R1uEbq1THaIHBLkgUOu/YyBXatwV+mOtJ1qQxB/5Z05Uk+mVx4hLcgSoRcE1tTPUFcoQoDGmkaPpTSo3IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767625011; c=relaxed/simple;
	bh=P9amMwUoDgoSVCSBJMgccS5kZG1wBAW1HV20cGeY1Pg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=MHFj6gWbtVi3VvxCP6ZWlzgAv7YDGnnss+9j8UUzDj385fBBaWQbx/tLlJmzTSjpcUC5Y1BZYh/o0h7cKvAK3Zdq61OtnaMetDmQ0wkyIdHbKDrhQj9T+Tt+gZSKF4nNHzaXwo2JNFY3uKH0qpPFh1on8Vtn1QM4WPc6kx/h2ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YJFmIeSA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YJFmIeSA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767625009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xzx7FjDPr5gCor82O4lgXhoV2CGZwulral8kM98/wo0=;
	b=YJFmIeSADs0DAfTxf8aN8uQTRxG8Y124hYIrV+DXCPGe2wi61jFgbgMOful5meTbN4YGbd
	k1pRoqLK6evO2r5gy9HsLW3bYeD7hSYE2K29J1G+vxwjJ9hdOpepKgGA35g02nnQMwsS93
	pytTfe9KNzko/Ia4k8o3S+ZoCVHHTg8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-Mjv8n_m0O-K9Rq_7sJcIxg-1; Mon, 05 Jan 2026 09:56:47 -0500
X-MC-Unique: Mjv8n_m0O-K9Rq_7sJcIxg-1
X-Mimecast-MFC-AGG-ID: Mjv8n_m0O-K9Rq_7sJcIxg_1767625007
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43102ac1da8so10428872f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 05 Jan 2026 06:56:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767625006; x=1768229806;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xzx7FjDPr5gCor82O4lgXhoV2CGZwulral8kM98/wo0=;
        b=wxIY7YyhRItldylRwjl7FDEOUZGwgqvuXqqz8xEyVsZKCgelKiaS16ASiv1LERCArj
         bGoBvXXblUQek/qh43FN+y8BmB+nqJkGvTx8+PatUOVIsK81ggFDOUl6KIae2hzwCxnQ
         DCnlubkSFGYi4Ialag4nb0Dr8MH2kWYEPsmxZZMBKqOl4qetLF1MKoh+Ad93Vpy+j82R
         IO6HVoqIvZa6Ij6zpG/dXWVXNrS47DTh2uHiSOMM7/GD3ngxWh090ZCg0avO0/dKk6f5
         xcoec0h3vEkWsaPGXdyLmEzFVafHsYzTRHKz/w0Lv6v6i27cIdIq+LXpGBWZCUGUwbFu
         nkMw==
X-Gm-Message-State: AOJu0Yyu1gb/vzdKTyQYGdPp2LrYYQ/N8tdIWEEsxkfBrlgtpRDKYM2c
	BmCoXDzDaalFwwvXHdapLt7QSdcg0QOtLCLMeywtYjeK7rmhaF34zy5kO99KH9AIrBbDvxutL5M
	725ihgbWv0XzESJprO5ZtsLGtPa/GrObLT+KrNUhR0GJqU4BfOrUSmkyUgndmFpWvBPBb
X-Gm-Gg: AY/fxX5Z4Vhe0zVNebXXd6YoFRCPGVlpAGsOWuvxWlMWzXvAo4HGHm48/3hdNLow7g/
	WjS5LH7G5H8w6sheKvQSBU1pP/56qJ84RRMllva76WfVSW21OSQy2doXa9hp431QGeKTGxSd2U2
	AgGi7vXQYzOidPHDciYPemCB3F5rRf4TRFNaKvkMLzAc93Ho2JnmOKZU6hVGJyo3tJti36k+W4B
	ODefNa/sHBJkweh+T+ixO6NJ+7eUEMS6LK1HS0Db4OxA8R92yR8YfG6ovP4YUri+mznkgkxZ0Cf
	BK2R+50yVd96c77UwRQR7jEe+lYHpvOqDa0glRxTl3z+SR30octqnR9cXrzV3Ry4WI0p8XUBw8p
	C
X-Received: by 2002:a05:6000:2504:b0:432:5bf9:cf26 with SMTP id ffacd0b85a97d-432bc9cbe81mr89113f8f.13.1767625006419;
        Mon, 05 Jan 2026 06:56:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGWDU9YSfafUNRp0lVQdT9QG8bfRQoSu01KiVGpSSQnpYO76DZoVTUTmuxNJPOzIc7kXGsfNQ==
X-Received: by 2002:a05:6000:2504:b0:432:5bf9:cf26 with SMTP id ffacd0b85a97d-432bc9cbe81mr89077f8f.13.1767625005995;
        Mon, 05 Jan 2026 06:56:45 -0800 (PST)
Received: from redhat.com ([81.187.19.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa64cesm101452308f8f.35.2026.01.05.06.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 06:56:45 -0800 (PST)
Date: Mon, 5 Jan 2026 14:56:44 +0000
From: "Bryn M. Reeves" <bmr@redhat.com>
To: Leo Samulis <anagon@gmail.com>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>
Subject: Re: [RFQ] dm-steg : a deniable encryption module
Message-ID: <aVvRLOlL4YF9sN0R@redhat.com>
References: <022d700d-d3d8-4ef9-8d7b-505f7df89354@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <022d700d-d3d8-4ef9-8d7b-505f7df89354@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w1nS2_6z6Ng7JWrHkTXja5fKEIdOwr5kqltmxZmZLjg_1767625007
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 23, 2025 at 01:35:38AM +0800, Leo Samulis wrote:
> I'm Leo, the author of dm-steg ( https://dmsteg.sourceforge.net/Steg.pdf ),
> a deniable encryption module for device mapper. It was working nicely in
> 2011 but I got caught up in life and never updated it.
> 
> What would need to be done for it to be accepted into mainline device
> mapper?

Short answer, it will need updating if there are changes to any of the
kernel or device-mapper APIs it uses (which is likely after that length
of time). I've had a look at the code in the git repo and it seems
fairly reasonable from a quick scan.

Things like DMWARN("u wot m8?") definitely need cleaning up before it
would be acceptable upstream.

The docs should be reformatted as RST in the style of the existing DM
docs under Documentation/admin-guide/device-mapper.

> Would I simply need to update the code, get it working reliably, and then
> submit a patch? Or would the specification and use of crypto primitives also
> need to pass a separate cryptography exam?

That should be enough to at least start an RFC thread. There may well be
questions about the crypto and where it belongs (the module is on the
larger side for a DM target, but still smaller than crypt/thin, and
sxts.c will probably raise some questions), userspace interface, docs,
tooling etc. but if you're willing to put the time in to modernise it
that should be enough to get a discussion going.

Regards,
Bryn.

