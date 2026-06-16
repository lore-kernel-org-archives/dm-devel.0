Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9AE32C302
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 22:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781648030; cv=none; b=VPVqtwnjUT5+lqmKW36IPR1P9L8st3Jw1o/iv9H90mG5akJgMRy7p8vuFy4SXklZfHmUaGqtZLRKCbzggD8IRmR3b3CZqy1q8cicPYd+6YpJPcrikbPxdSyDb3w1xl2bV4x7jVZchezfYEc/5f4zoJoJNc/533lztPIo4vgdEpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781648030; c=relaxed/simple;
	bh=gVLbi8wE+Ml2kFuPwV9DVqPsesU3gtab0fEubT/8ns8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=sjvBRPQ1dMdSqreyH+TIlYahREGmUm5mEncy+qgeHe67ZuTRN9TJHvn4b4LnDjmqiXQtB3TvRvaIkuOCMZNrxMXZYoec/ym4v6pfIuXiZQiPAH99Xln7iAJ/Wt1A6pTdPDDEgGvasE6zIn4/EMM1phOjaQwYvSd0kZ8f4rZUcZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KJQUUD28; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KJQUUD28"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781648028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JH+nilC5i2IeqlLadGWx0oTbDGewWi8UlzKWhexGkQM=;
	b=KJQUUD28sndya0cJad6KOKAq55FnP/0K98/r1VPvKGdywpye1HESjXOSEY+ZiyXk0AShpy
	e2D86JIWFXLtpCG90gjQhwuRXk9+KXSkl5ymg7x/H20f4zzdOKiq1OnC8A7sSit0UkSI4x
	xGDzKwyW6tdxDukuUUdgyXXLSSEyfbk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-B-f0lBHsOji8NTn4SkTkSQ-1; Tue,
 16 Jun 2026 18:13:45 -0400
X-MC-Unique: B-f0lBHsOji8NTn4SkTkSQ-1
X-Mimecast-MFC-AGG-ID: B-f0lBHsOji8NTn4SkTkSQ_1781648024
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B61FB1955F07;
	Tue, 16 Jun 2026 22:13:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 454AC1955BC0;
	Tue, 16 Jun 2026 22:13:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65GMDg9W841896
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 18:13:43 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65GMDgFt841895;
	Tue, 16 Jun 2026 18:13:42 -0400
Date: Tue, 16 Jun 2026 18:13:42 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 5/8] multipath-tools: clarify path selector
 descriptions in multipath.conf.5
Message-ID: <ajHKli7e2XP82alM@redhat.com>
References: <20260616122909.244619-1-xose.vazquez@gmail.com>
 <20260616122909.244619-6-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260616122909.244619-6-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jZKytvxdSfq0Wsz4ONNmV4UfiA87LcyPmne6LQhgAwc_1781648024
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 16, 2026 at 02:29:01PM +0200, Xose Vazquez Perez wrote:
> Selectors operate on the next individual I/O request rather
> than a "bunch" of I/O.
> 
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> v2: fix typo, s/group/groups (spotted by Martin)
> 
>  multipath/multipath.conf.5.in | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
> index 422ab120..5b730801 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -2,7 +2,7 @@
>  .\" Update the date below if you make any significant change.
>  .\" ----------------------------------------------------------------------------
>  .
> -.TH MULTIPATH.CONF 5 2026-05-27 Linux
> +.TH MULTIPATH.CONF 5 2026-06-13 Linux
>  .
>  .
>  .\" ----------------------------------------------------------------------------
> @@ -193,20 +193,18 @@ kernel multipath target:
>  .RS
>  .TP
>  .I "round-robin 0"
> -Choose the path for the next bunch of I/O by looping through every path in the
> -path group, sending \fBthe same number of I/O requests\fR to each path.
> -
> +Choose the path for the next I/O request by \fBcycling through the path groups\fR.

This isn't a strong objections, but personally, I'm not sure "groups"
makes this better. It kind of sounds like paths are picked from multiple
path groups. Perhaps:
"cycling through the paths"
or
"cycling through the paths in the path group"

I'm also o.k. with leaving it as you have it.

-Ben

>  .TP
>  .I "queue-length 0"
> -(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe lowest
> +(Since 2.6.31 kernel) Choose the path for the next I/O request based on \fBthe lowest
>  number of outstanding in-flight I/O requests\fR to the path.
>  .TP
>  .I "service-time 0"
> -(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on \fBthe
> +(Since 2.6.31 kernel) Choose the path for the next I/O request based on \fBthe
>  lowest total size (in bytes) of outstanding in-flight I/O requests\fR to the path.
>  .TP
>  .I "historical-service-time 0"
> -(Since 5.8 kernel) Choose the path for the next bunch of I/O with \fBa dynamic
> +(Since 5.8 kernel) Choose the path for the next I/O request with \fBa dynamic
>  algorithm based on the historical service time and the number of outstanding
>  in-flight I/O requests\fR to the path.
>  .TP
> -- 
> 2.54.0

