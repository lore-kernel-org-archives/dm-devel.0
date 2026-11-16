Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865095;
	b=uVG7mohYG7lzV2Otb6a31pvwgueczTLX/D9E3wvddYjYDibC7+qTnmoq7dbGsQyheqMo
	 4xI4D0tG3zXTSZYEhlkhbTGTLp8c8j0mvu5UsNxatoS5I/bHNTzZonS8igZTcmp4o7n39
	 CeJ0ypifNO+G5npBd3m8I+QgBUO07wNN6PQjQeh7+t9pdI9gwWUd4Y98tewb5pC4DEF08
	 +SQ7Ww8CzaWMGTgoarnLwJf9xJZ+G+I1l+UIt+j6u/j+cO42vdIPI4gYkO3mKkUQuKpcp
	 94c3uf6jywJhNfMXDcuPiOaIEeLKEfgX3GLd0Z1XFdNVYQ3Fz0GFr1dcLm+eq7MlXfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865095;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=pOsE2fZOP5CyyxVLwnrQ/OozsJQx/MvBC101pIaaKJE=;
	b=l2yDNn8SDeEplXbjoce1jvNnHyDRLZGq3FGmKNrocPWzlniH/gBME+kUkz6NPKXI6feu
	 bdwWxWX2BNgw8PRQmMq/EfsxvF1mIG0790GR1X+LkUYNhWHRjVlpL+ykfd5Y5ExQewLie
	 GF5Ab20VrV6wXFOSW3xeyWHTVSyN09EUXdxUzpHAeDn84jd0Rfuphh53+PqGMNpQJfSIL
	 SSjbynGgkYF1ZYxFbmV+kuqhu2h4na+PUDDagwk4dqghPWiMdT3HfeBniBKTx6OGH9iLk
	 9KK3L6UOw/PUlCz9nNerPELgaVdGEylPd7b0p23VaTgZib/EFjra1+AU82uUccxlvXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hIgdYGNm;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD79606A88E
	for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 21:38:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CD79606A88E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hIgdYGNm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794865092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pOsE2fZOP5CyyxVLwnrQ/OozsJQx/MvBC101pIaaKJE=;
	b=hIgdYGNmGEeIWA64jgLGaSXXeJKqAH/ycYeHf14vvNRVTCGJiP7bX5zoeNS7JyZWL8YKjA
	5gmWeIgV0HsjbAuTxyDOFb9UyUIxidxvqoX2JcTGw2+EYIGDVkYnzca55ZqP0+mrJiyOy5
	SPiQrJL/g0bMPCyPGZ1gfTJoIjI12gg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-iNLgbcilOH2eq_zC1Kc_aw-1; Mon,
 16 Nov 2026 16:38:08 -0500
X-MC-Unique: iNLgbcilOH2eq_zC1Kc_aw-1
X-Mimecast-MFC-AGG-ID: iNLgbcilOH2eq_zC1Kc_aw_1794865087
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D4901956057;
	Mon, 16 Nov 2026 21:38:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 036151956047;
	Mon, 16 Nov 2026 21:38:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AGLc5sq3257060
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 16:38:05 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AGLc5PR3257052;
	Mon, 16 Nov 2026 16:38:05 -0500
Date: Mon, 16 Nov 2026 16:38:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 01/13] multipath-tools: multipathd.8.in: fix mandoc
 WARNINGs
Message-ID: <avt3vc307mk4FHZK@redhat.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
 <20261113125549.504780-2-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261113125549.504780-2-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EI0XS4oI7yMT_N8PpipgBgq4-P8aLVl_Yv_mYMEYFps_1794865087
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 13, 2026 at 01:55:33PM +0100, Xose Vazquez Perez wrote:
> mandoc: ./multipathd/multipathd.8.in:36:1: WARNING: blank line in fill mode, using .sp
> mandoc: ./multipathd/multipathd.8.in:44:1: WARNING: blank line in fill mode, using .sp
> mandoc: ./multipathd/multipathd.8.in:80:1: WARNING: blank line in fill mode, using .sp
> mandoc: ./multipathd/multipathd.8.in:118:1: WARNING: blank line in fill mode, using .sp
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipathd/multipathd.8.in | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
> index 632cbe40..461e960d 100644
> --- a/multipathd/multipathd.8.in
> +++ b/multipathd/multipathd.8.in
<snip>
> @@ -77,7 +77,7 @@ multipathd executes the given command (see \fBCOMMANDS\fR below). If the
>  command contains whitespace or shell special characters, it needs to be quoted
>  like in \fImultipathd -k'show topology'\fR. No whitespace is allowed between
>  the \fB-k\fR and the command string.
> -
> +.br

Nitpick: If we don't want an actual blank line in the option
description, I'm not sure the line break really matters here.

-Ben

>  Commands can also be issued without using \fB-k\fR. In this case, the command
>  string should not be quoted. Command arguments that contain whitespace or
>  special characters still need to be quoted, like in \fImultipathd show paths
> @@ -115,7 +115,7 @@ socket file can be useful to communicate with multipathd from different
>  namespaces since it can be bind mounted in them, unlike the abstract namespace
>  socket. Multipathd will accept \fBlist|show\fR commands from any user. All
>  other commands must be issued by root.
> -
> +.PP
>  It is possible to change the sockets that multipathd listens on. If
>  \fImultipathd.socket\fR is running, multipathd will use the sockets it listens
>  on.  A maximum of two sockets can be defined by \fImultipathd.socket\fR, and by
> -- 
> 2.56.1

