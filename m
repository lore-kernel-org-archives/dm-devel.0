Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331C11ADC6C
	for <dm-devel@lists.linux.dev>; Wed, 12 Mar 2025 20:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810245; cv=none; b=GCYEygydKaBkjOQ89BAq7kAF1E/PudidwB0snS8br/fxcj2TROirHEpd5BpnbMSGtTkDGnXjWNtnld/9SKp6y8PgIiSZOVB6L3PG4iu4ivTX6Q27cS0HXH1/VYaANHXIypYvQD29MSrGDtQHeMC4v7eYt7mgtWETK3W1StuZwn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810245; c=relaxed/simple;
	bh=rqycji58J8TMiovBcMBtcrvHp6qRATj+egz+JGXq9fw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dvP9HrURosBwGLJwEYGuukysEZYFX45BCEinuIKCTYxxITR+XyUI7P8K941WGZF4+lPqaFwTVRBq/tmWcah6Eg0ICCW5NPwhGO+hM+NhGszOTllrdm/ToXuiOJ3DILyMjibA+tK1oNdQcbemxJh+Y4n+nG5YpOcykRFi84fbq4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IDKGq3yr; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IDKGq3yr"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cef035a3bso1276165e9.1
        for <dm-devel@lists.linux.dev>; Wed, 12 Mar 2025 13:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741810241; x=1742415041; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rqycji58J8TMiovBcMBtcrvHp6qRATj+egz+JGXq9fw=;
        b=IDKGq3yrLRintboxl5jOfn+HPHZ/yuJ50pfkWJQ+QvRljZ7AsST35tWlnawRk1STxX
         r14cUfEaPt896mqilRiNbWIu4spRf3K8wdjszWn9N256jX5inTsD2lzV8NGAf9uE25b0
         JvbjpTi8LM9KSQT7LoUBsT7JcwIcsVy8uWTqxm5izRyp4TlPHx98J37TSVMKddOvVTJV
         xZg4S+5iNmI19qkxvSN00KPmOlPDjzCDKhXDIfQz/ba0yq8cOAIRxfvRPtntbvO8aO/a
         mZ56oedXNep7a+NQHch44+tM8MomE0FSeYIMc6aQyRRHhOL87PY1eDN3SP/jiVSba43L
         bs4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741810241; x=1742415041;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rqycji58J8TMiovBcMBtcrvHp6qRATj+egz+JGXq9fw=;
        b=rFm4Ie2KSQ8Fvv+1Zv6hg8CZPfz09bQNCmkrZMSSIZTQYPpN8hGEFYpXkR3SpYJsKV
         6U8MTTTqJD3WinbbhQQlj+ei7WclRw2fcCKbg5XeRvwhc3/g0Ps8WPAXf4yUuap8oS/F
         qh6u523fsowP6/wbMhMoJ93mwUmhazpcypxpKmGvmK4Zaq31ox8fvz6vWTTR5kZLv+9t
         bv65paDhljxyrBq5kluKJgNAdCspFNBG53xysuFUx26sNOLab1LTbE9iK5QKcN+YrEdQ
         IpNNrrlXmuJ34El5w7yu1NavNsYSZ87F0MqkkE3Py4KOwMOGiplV25jNj7xagOHtet1h
         DbAQ==
X-Gm-Message-State: AOJu0Yz732oiUBzORlXbBZT45qSyKmPXWM9EnvskepMVYuI+sdr1NYep
	NvoJl0RswOZ/87lp6p8YGvK5/6GU4X8kH0D+kfs8Ts8hJ1AC6xh9wuQXqk1W0OWnGjTRvSjN3Mx
	Z
X-Gm-Gg: ASbGncszZvGO246OhUZ10weOoYwhG3liDZuG9wpIvELVv5FBC0kMUUNy3/TfWaZBR2e
	otxisECbdwUm71ykp80IvKagEyTnPnjc03gqsV+E5TZiPbj3fXyiuiRpPs5KIyVWFOsLYKx7DZi
	8N8s0h08T83jT5BftoIVHIoLj837iEBX2dk31PuNjVTKlAIrE4/RaYKv9nTOcQ3FhUPe0jv3FZG
	/aYslSlBQdCTzwJ9IgL1l/EuhRMH8W4gjWpk+l84sPi/DNG+ZLJ6Nh+wT9fLv/i2++O7sf/7HgR
	Y/mzG8ClVsn8PYTzdTv/AX6zC2G5+Fhy8DASErkryBibQFs64FcOWKQO85y4Yo95guHpozlfNp4
	rmkFuAFZLLHHZfoLZMa16r44Mxf15Vq8no6dW428LI+hn4W2HfZggHuFltA12M5XyyTA9tsIBk5
	gFQPE=
X-Google-Smtp-Source: AGHT+IGaqV1TvLiAa0ljQ4yzGqTmQYMhdtDXAiUZ62tStnvnlbm5KTFrg0A+QPo/Hij+KFSisGByyg==
X-Received: by 2002:a5d:648f:0:b0:391:2d97:7d0e with SMTP id ffacd0b85a97d-39132da92f4mr17548257f8f.42.1741810241245;
        Wed, 12 Mar 2025 13:10:41 -0700 (PDT)
Received: from ?IPv6:2003:de:3744:d600:a441:a57b:4aaa:2b39? (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c103035sm21615016f8f.88.2025.03.12.13.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 13:10:40 -0700 (PDT)
Message-ID: <84988b83ba8591fe6051dd4638688edd33a5fe82.camel@suse.com>
Subject: Re: [PATCH 2/2] multipathd: Add multipathd man page section about
 sockets
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 12 Mar 2025 21:10:39 +0100
In-Reply-To: <20250307001034.3141833-2-bmarzins@redhat.com>
References: <20250307001034.3141833-1-bmarzins@redhat.com>
	 <20250307001034.3141833-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-03-06 at 19:10 -0500, Benjamin Marzinski wrote:
> Add a section with information about how to communicate with the
> multipathd daemon to the man page. Also mention that multipathd
> CLI commands can be run without the -k option.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =C2=A0multipathd/multipathd.8.in | 31 +++++++++++++++++++++++++++++++
> =C2=A01 file changed, 31 insertions(+)
>=20
> diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
> index 315884eb..5b1aeb42 100644
> --- a/multipathd/multipathd.8.in
> +++ b/multipathd/multipathd.8.in
> @@ -83,6 +83,11 @@ multipathd executes the given command (see
> \fBCOMMANDS\fR below). If the
> =C2=A0command contains whitespace or shell special characters, it needs t=
o
> be quoted
> =C2=A0like in \fImultipathd -k'show topology'\fR. No whitespace is allowe=
d
> between
> =C2=A0the \fB-k\fR and the command string.
> +
> +Commands can also be issued without using \fB-k\fR. In this case,
> the command
> +string should not be quoted. Command arguments that contain
> whitespace or
> +special characters still need to be quoted, like in \fImultipathd
> show paths
> +format "%n %w"\fR
> =C2=A0.
> =C2=A0.TP
> =C2=A0.B \-k
> @@ -103,6 +108,32 @@ multipath devices on dmevents. Use this flag to
> force it to use the old event
> =C2=A0waiting method, based on creating a separate thread for each device=
.
> =C2=A0.
> =C2=A0.
> +.\" ----------------------------------------------------------------
> ------------
> +.SH COMMUNICATING WITH MULTIPATHD
> +.\" ----------------------------------------------------------------
> ------------
> +
> +In addition to the multipathd CLI, the \fBlibmpathcmd\fR library can
> be used to
> +send commands (see \fBCOMMANDS\fR below) to the multipathd daemon
> from other
> +programs. By default, multipathd listens on both the
> \fI@ABSTRACT_SOCKET@\fR
> +abstract namespace socket and the \fI@PATHNAME_SOCKET@\fR socket
> file.
> +libmpathcmd will use either of these sockets to connect to
> multipathd. The
> +socket file can be useful to communicate with multipathd from
> different
> +namespaces since it can be bind mounted in them, unlike the abstract
> namespace
> +socket. Multipathd will accept \fBlist|show\fR commands from any
> user. All
> +other commands must be issued by root.
> +
> +It is possible to change the sockets that multipathd listens on. If
> +\fImultipathd.socket\fR is running, multipathd will use the sockets
> it listens
> +on.=C2=A0 A maximum of two sockets can be defined by
> \fImultipathd.socket\fR, and by
> +default it listens on \fI@ABSTRACT_SOCKET@\fR and
> \fI@PATHNAME_SOCKET@\fR. If
> +\fImultipathd.socket\fR is not running, a single socket can be
> configured for
> +listening on by setting the \fIMULTIPATH_SOCKET_NAME\fR environment
> variable
> +when starting multipathd. This environment variable must also be set
> to make
> +multipathd CLI commands (or any other program using libmpathcmd)
> connect to the
> +multipathd daemon using a non-default socket, regardless of whether
> that socket
> +was set for the daemon using \fImultipathd.socket\fR or the
> +\fIMULTIPATH_SOCKET_NAME\fR environment variable.
> +.
> =C2=A0.
> =C2=A0.\" ---------------------------------------------------------------=
-
> ------------
> =C2=A0.SH COMMANDS

