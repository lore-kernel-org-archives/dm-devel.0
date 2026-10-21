Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792613820;
	b=neX04iU3AMS8AWeFpQaiXaQE8MvWeQ+TM57LkXxQjCwSfcW+zA+Xr3sY+m8BsCYAp9Rm
	 KX1qj/2Dzfd+2zPuHxaRD79V327CSnyFJBuwpLO5fE6Qit/77KEqFnJFwm2tYjcQDIbEb
	 8vV8f0ApjaNUUnHxKVIfCfpAKGMGTWhzt9VQXdNQ0/Q/iVEyGg3W6RRD1UZPf/q/eSWem
	 qwEUx7+mKaRJDO5IjQRzFOYtmhnyfNtKczB6JYHItv28fe0ImCbwzhUzPLGusaSNVFNhu
	 I8YyKpdgMuRCSAO3nfCiExlHGeUEe+tcE1/bI8FpWVgCS+cWkuORYhQWpg/N9ixBltw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792613820;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=n+GGmqqba6HQAuCkAQ2r2Q77aSfO55edxcx3o43LGGM=;
	b=g90Io/elckj9AmV2Y93ncKb2PJHvMsQB6JDjg2ey+1rByCr5sxDwyhsNy1Vwj8mb7/o9
	 t/fG4pZxziKEpBjWeHU9feRkCf+rniTL0cuV+1GYsDsN8/qeTKrp+Y+EmNAio1Tf0YdC1
	 1/hLne1n68DhPZg0AcZE+QwDi84hmvePU2ZrSMW2hDxvqrP6Iy5Hw+ROYvjYiB1S9qM08
	 hDH/7ohLoA8Agm6qwQp7flBQOfsWVObSNJXD2GYFHqk4nKKb9B+I4cpZxoChTGLH1WSfx
	 Qsy5qRQgmqam6GAHcXH3Y5MLTo0PbNwiP9biYlGZfL/v1uzauyuqaBRAJo00RPuEDsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KL7XAK1k;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5776E606A31A
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 20:17:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5776E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KL7XAK1k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792613819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n+GGmqqba6HQAuCkAQ2r2Q77aSfO55edxcx3o43LGGM=;
	b=KL7XAK1kvPCPEDfG7DEQW9T/ZjwfWgxtjuLyqJ3IZ3kaLsqxzJdVc6u2WZqSUHFrGpaVZI
	2dDQuTXYqEsC1gt47BQ1omOlzCfQ8daHaoFtqASeZESB2fNUsIxuNvRaNX2kDq3MlDkjrx
	mEdaYgE37LZWoQofKRE06K5byULfXn4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-241-UCeNWNOlOgqgXi1QmStDgw-1; Wed,
 21 Oct 2026 16:16:55 -0400
X-MC-Unique: UCeNWNOlOgqgXi1QmStDgw-1
X-Mimecast-MFC-AGG-ID: UCeNWNOlOgqgXi1QmStDgw_1792613814
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 486F11955E85;
	Wed, 21 Oct 2026 20:16:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E527E1956042;
	Wed, 21 Oct 2026 20:16:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69LKGqlM074432
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 16:16:52 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69LKGqXb074431;
	Wed, 21 Oct 2026 16:16:52 -0400
Date: Wed, 21 Oct 2026 16:16:52 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Enabling Sashiko for dm-devel?
Message-ID: <atkdtNT83DBoCTVS@redhat.com>
References: <20261021173943.GF1879@quark>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261021173943.GF1879@quark>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yDfSAWHmrMLmiTvunmzqfqUQCPHxkz4dqTf3VcGcMv0_1792613814
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 21, 2026 at 10:39:43AM -0700, Eric Biggers wrote:
> Currently, Sashiko doesn't monitor dm-devel or send email replies to it
> (https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml).
> 
> Sometimes Sashiko reviews for device-mapper patches can be found on
> https://sashiko.dev anyway, due to the patches also being Cc'ed to
> linux-kernel which is monitored.  However, get_maintainer.pl is being
> updated to no longer suggest Cc'ing linux-kernel.
> 
> Would there be any objection to enabling monitoring and email replies
> for dm-devel, like this which various other lists already use?:
> 
>     ["dm-devel@lists.linux.dev"]
>     reply_to = ["author", "list", "recipients"]
> 
> If the dm maintainers prefer monitoring-only (no emails), that could be
> done instead.  But I think the email replies are really helpful.

Sounds good, and I think emailing when issues are found is fine. I'll go
open a Pull Request to add this.

Thanks
-Ben

> 
> - Eric

