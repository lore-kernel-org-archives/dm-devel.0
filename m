Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D54364948
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 01:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778635230; cv=none; b=kSBlR3Xvde67/lqQGytqopcJSe6i0OA+IMgD4H6d7TC5+WI+pp9gSnMrkL5z05H0zJF3fCNBMIx4OYhY/8LAKhs6/o/qQ1Jb9mYjSqapVB3rOmNbbWBrChl3fnHmdM7DvUjg+dj6oQ8ckMdGbvLjs0+PCTKBOa+lZC6iSBakeLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778635230; c=relaxed/simple;
	bh=nPU9/GxI8N0KxWAnsE/FWeyMn/e/xfgTRDINaJ2KleE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ar5SdjNfjMFzWD40lfMHjoeYF8/FAqQ5nVVJVsds9OVhfz9GjJRV+n4dqXgjjzELPOlr8i92GfahTZO1TSEYEYOpJmraIbl6hWUm0wLdB9L0C1ZjazzVWvzS9ZVQXRvyTsxDZWwEjfF73vAitXX8TrmNG8cGXKs+CsUcbr9qNaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UM6HQkwG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UM6HQkwG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778635217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IrcVHCtoNrFpPuERxn1taLVyoUuqz4AmQRx1tl/BPGY=;
	b=UM6HQkwGF711LVp70+hP6UYNtip4dWg6/ikNxWZMxKQxk+WuP+okUuTkJjEfCvXfnT08si
	oNqqtAnDNmVxZyY31DKIBbJeTFvkk+V/mBakzeY8eDl5UFDP9McYc9vVbd2Ovrw5M31Jqd
	SCYfHV7573d+jigX9zuuUfKNtUB2boI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-473-LyyoBk06MxOEmn-_DYLtGg-1; Tue,
 12 May 2026 21:20:13 -0400
X-MC-Unique: LyyoBk06MxOEmn-_DYLtGg-1
X-Mimecast-MFC-AGG-ID: LyyoBk06MxOEmn-_DYLtGg_1778635212
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31D99195608A;
	Wed, 13 May 2026 01:20:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D88AC180058F;
	Wed, 13 May 2026 01:20:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D1KAmG3332746
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 21:20:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D1KAIt3332745;
	Tue, 12 May 2026 21:20:10 -0400
Date: Tue, 12 May 2026 21:20:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 18/18] libmultipath: convert emc_clariion to async_checker
Message-ID: <agPRygKYahqLafvM@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-19-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-19-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cEY0CoTA20wUJLrMr3DxiiRfVt8SP2Pbjzu2lcWBCT4_1778635212
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:32PM +0200, Martin Wilck wrote:
> ---
>  libmultipath/checkers/emc_clariion.c | 79 ++++++++++++----------------
>  1 file changed, 33 insertions(+), 46 deletions(-)
> 

No Signed-off-by. Also, I don't think it really matters much, but
running this checker asynchronously means that the checkers will not
have their mpcontext updated by previous checkers run in the same
checker loop, like they did when the checker was synchronous. If an
earlier path check detects that a snapshot LU is no longer inactive, a
later call to a passive path in the same checker loop will still return
PATH_DOWN instead of PATH_UP, since the mpcontext won't be updated until
update_paths() gets called. Obviously, this will get fixed the next time
the path is checked, so I think it's fine.

-Ben

