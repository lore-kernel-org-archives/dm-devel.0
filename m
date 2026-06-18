Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B3F244667
	for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 19:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781811507; cv=none; b=jmO0Uyz1n0s+AC8isecYU+6l+COwAnTW+vsyl08ylxsgu2v2oH4HT7nQL8AS6cCSO1vjsjxpkI/Di1xAZPiCPPfAjb1XSqVkJHruy6FlKTRP14V4EhjPereSZ4nVJmulP69kqU1pqwGKxAv+hqPKFR9TCukBaapAFOhkhfzkvTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781811507; c=relaxed/simple;
	bh=AXB+vd7q3QFtApjuwjNJ1C9pK/9ayqpcEsMsyT2bzVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=rv54lpgWE7pTvnl3dZH//19FzSagRz1atAg+frTCMKDwD0c9djVJP5gWZmcvxICF6dqByXXwjpL5Vh/XUsIFR6kaVj0dWwuNmzZnudnER4pUh1xkxIxcqmAG7S9EAaz9tUqQkBq9y9jvH988rZ1ElLpBBtfDv+NL1gpAzoRZqno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CeMw1+mA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CeMw1+mA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781811504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v4tU6EXgAyv7y3kQU85iL044CFSI/k5F6+KrX2jO5uU=;
	b=CeMw1+mAByvd1sWDzz+UBXl1wiQ4bGWdLifLQIuy0swYfjbNZ0UI+XNa3zaD6BhCS67Yeh
	pwv5Tf8yZPJBgvd6jd08kMlJ3sI39t2rh4subjW/j0mCvBvfoF8d0FjvgMOQNdXWzU7Bk3
	jyJATWS8tLgheG040TgKNi0z2aVPOtw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-232-dkm0OffCPG6yuv3lxSR4Mw-1; Thu,
 18 Jun 2026 15:38:21 -0400
X-MC-Unique: dkm0OffCPG6yuv3lxSR4Mw-1
X-Mimecast-MFC-AGG-ID: dkm0OffCPG6yuv3lxSR4Mw_1781811500
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E60691955F78;
	Thu, 18 Jun 2026 19:38:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 656E5195608D;
	Thu, 18 Jun 2026 19:38:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65IJcIrB910228
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 15:38:18 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65IJcGSn910227;
	Thu, 18 Jun 2026 15:38:16 -0400
Date: Thu, 18 Jun 2026 15:38:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v3 5/8] multipath-tools: clarify path selector
 descriptions in multipath.conf.5
Message-ID: <ajRJKF_oQ9ws3HeR@redhat.com>
References: <20260618134521.16878-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260618134521.16878-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KPzwxF7bf17XOPJrTfkdBSjm0V2YcG5hspX4mnaoe_s_1781811500
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 18, 2026 at 03:45:20PM +0200, Xose Vazquez Perez wrote:
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
> v3: revert v2, "group" makes more sense. (spotted by Ben)

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

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
> +Choose the path for the next I/O request by \fBcycling through the path group\fR.
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

