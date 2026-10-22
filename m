Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792687027;
	b=xnwGItnFiWhrrdlPwucLdv0XORZ9Kl/QmNhuX6uqnoqJfY9JF6LKD+RsuQqr5dDShrSE
	 K5Ln5xDvL4Xp06N9XOGm4YC1+IO5y45EeToVeCVnMVcopf1iovdFWTrzrKrK0gW7oRjaf
	 Njp+6/XpCGxp/zve58ezXpu1pBV1cidrmzIcmcIjRTofe+D3g9uQOkd9Y0OJrgU05Kxh2
	 dd7fkFwbSHr1u9Bk/08nggwjBh+SYeAZBoGgySFESo8hAzazrdEydgGP7FbwVzMPUB0WB
	 Kjhjj43Ek0m/w77aWLnB7YLA5l+M3RGHaLIjwAou8J5je0RVzqtApwC/5Az+/42B+0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792687027;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=zPOM5juDmCxmFl3ZadACco9Sx9537YC2QDRS8cVTGec=;
	b=xlCUS9fG+kZOo2+dCB5h7wa5VwfJoymyo70qt36fcKnmIuF8/KLmnaKhp3YJjYWXRqy0
	 T/FAdKhp/QNmZt82nLl0OhI3fSUiGh2X4gC2bN70aRM23KvgYg2EncRvyQf5lr8KBhdPk
	 h87pS8J3DQOPyxvsD0D3TM67p/juzN34fHzhVD+MhHuBJRHyaq6iY7Tk/BxCI6tuNYO0u
	 x+RnIrfxTQYts9a6XHgQfpK92vrgCQHC50JVnTwu+FpTPWSKN5tn95TsZq7WUeSdJxVfL
	 gF3f5U/6SW7E7evodqhtyTdKCh76dH1S51EfffhoOnTu0djLKvMKrlFeKsQXukxs1iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gaHagDrT;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D57606A319
	for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 16:37:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30D57606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gaHagDrT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792687026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zPOM5juDmCxmFl3ZadACco9Sx9537YC2QDRS8cVTGec=;
	b=gaHagDrTNcvLkp2aoSwH0Wpa9LImkwd7uWTGjh/6MgW6gfwhhS73Gtbfm01ZF7OmbvTlrY
	0/ODvy3CWLfSU4bLv1Mb1JMQ5eKn25My56/hDioYWKAKcinsUWaL62oVMxtw3tIZyefYx6
	PnEQI6tBJlz0m0jZgyV0Pb2laaUQsPo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-AWCH1pMUOZa7pIEBbb-CKA-1; Thu,
 22 Oct 2026 12:37:02 -0400
X-MC-Unique: AWCH1pMUOZa7pIEBbb-CKA-1
X-Mimecast-MFC-AGG-ID: AWCH1pMUOZa7pIEBbb-CKA_1792687021
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64BC71955EB5;
	Thu, 22 Oct 2026 16:37:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1476A1800495;
	Thu, 22 Oct 2026 16:37:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69MGaxAs2365762
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 12:37:00 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69MGaxkN2365669;
	Thu, 22 Oct 2026 12:36:59 -0400
Date: Thu, 22 Oct 2026 12:36:59 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Enabling Sashiko for dm-devel?
Message-ID: <ato7qykzvctpGmdy@redhat.com>
References: <20261021173943.GF1879@quark>
 <atkdtNT83DBoCTVS@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <atkdtNT83DBoCTVS@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x8fqo_Z6JPPDdfXmLtbAxBj1tg7JzI5cDY0GwGHvE3I_1792687021
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 21, 2026 at 04:16:52PM -0400, Benjamin Marzinski wrote:
> On Wed, Oct 21, 2026 at 10:39:43AM -0700, Eric Biggers wrote:
> > Currently, Sashiko doesn't monitor dm-devel or send email replies to it
> > (https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml).
> > 
> > Sometimes Sashiko reviews for device-mapper patches can be found on
> > https://sashiko.dev anyway, due to the patches also being Cc'ed to
> > linux-kernel which is monitored.  However, get_maintainer.pl is being
> > updated to no longer suggest Cc'ing linux-kernel.
> > 
> > Would there be any objection to enabling monitoring and email replies
> > for dm-devel, like this which various other lists already use?:
> > 
> >     ["dm-devel@lists.linux.dev"]
> >     reply_to = ["author", "list", "recipients"]
> > 
> > If the dm maintainers prefer monitoring-only (no emails), that could be
> > done instead.  But I think the email replies are really helpful.
> 
> Sounds good, and I think emailing when issues are found is fine. I'll go
> open a Pull Request to add this.

This has been added:
https://github.com/sashiko-dev/sashiko/pull/724

> 
> Thanks
> -Ben
> 
> > 
> > - Eric
> 

