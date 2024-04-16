Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B7A83A1D
	for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 09:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261588; cv=none; b=DvbosYfVmy+lcorNEV4juOsXdc1mutbEaTESskQIA2k9nX+lqgh/Ju9L3MwjQUzO6SwHgqRNREopW87P1l44GS/4kUQ64eufdqfNymOaJDoen7asIsoDkj2wc9sxfWtaqGeC/YP2ok5ffp4XyLSEuwechNvuMVG/TcKiO2ZuxgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261588; c=relaxed/simple;
	bh=Vo72edf2kOrLeVo0aO4zZ26/z3TZ29awbJMpR10wTxw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AeZXfCXAT17R3wYQ6+CWTUxARgFHyHaTY7ude8MjhgYRWnDKdF6naUxNVdIY6gECUZgnQpP2Ceg6NGyVW4OlB8CQIEQcPwQA9oX8hDrOXPXxshwePs7ETMw1QJMhdsiUcBIaxPWSwtSibwCHbwszl/gjWmN5wp0mrz/65LTl27Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YmbkYsb+; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YmbkYsb+"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-518a3e0d2ecso4873065e87.3
        for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 02:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713261584; x=1713866384; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vo72edf2kOrLeVo0aO4zZ26/z3TZ29awbJMpR10wTxw=;
        b=YmbkYsb+0GHlFBUpsaQwuOJqYL/T+wnKhoFjX248fdtdGKa+y/9nJU9a+1j1eJ24tp
         r88AXRx+R2aQWnZmrT/6y0bao84apdSlozkGGPtFASySbLv+emA63fN99koV5z9oPlq4
         DPEODwZb/GeKcqD1zlO4RBA5H6M+WrmfxgfQHrbSV9zAzJ4kdc7UI5PcrW5nPfmJfejM
         wVKPfAOwPARaOLSbnhlySaFs/u+cU/Cpa2vBsUrQVGLlQkS52lVhvNvV5x/2xeJ06PDI
         1l17miLz4iW0aiGfTwBghclQNzVRfoEZjwLEIvyQpJSZ0CRH3c8/eOAwmfYMUfUStJgc
         PmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261584; x=1713866384;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vo72edf2kOrLeVo0aO4zZ26/z3TZ29awbJMpR10wTxw=;
        b=umb10k32q9pv7/ICNML81SjJRQ6y0euT8ajbkw/BQcSweiVx6tA/LGVRGuwHiVYxcw
         3Hhc5vhSB7qJAk9Z6U2lB+FvitpbHRZW2TXbqp4zSYDc+pWCStksQ+9xG0+fce7L5fOO
         SRsBQ3Nttskdr1PHwwR2aBVfIFSEwtwqPjTovcqzeKLgUJLGZmNQOGSfwNwoTZRVopd1
         x+ydBYL+mAyp9/1Y97sBzLhvzGfNRRFEr2/nF7JC48l9cJISn/gaXct8RMfuA/pZAPj9
         Ci00sjwMkOv3DTa5BiAePx4uHeU+1t8A3ZRm8clUUe91VNsqVn2ggHa+bUh2d5YB+AD5
         lLpw==
X-Gm-Message-State: AOJu0YyVv8q8IU1ey3GFiMchsLp5NV/L3kS/5nyFeSPy1pT+uLOPbI5/
	rivYab6LRXwuFczBzWWbBt4fZY4yBy7kZO+Honlmvii9ftq4Fe3bW+LA+i1Pi+c=
X-Google-Smtp-Source: AGHT+IF9cGRfrMe0liArJVNzsTmedlj7RORLa//9EJdFRkWtRyIgOYiutMyDt4BYN+xN9SGD6CN3Bw==
X-Received: by 2002:a05:6512:2303:b0:519:166a:d217 with SMTP id o3-20020a056512230300b00519166ad217mr2081489lfu.32.1713261584351;
        Tue, 16 Apr 2024 02:59:44 -0700 (PDT)
Received: from apollon.fritz.box (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id m19-20020a17090679d300b00a4e03c28fd5sm6651466ejo.43.2024.04.16.02.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 02:59:44 -0700 (PDT)
Message-ID: <79596769d7ebe048cbfe95020f5c492a12bb1673.camel@suse.com>
Subject: Re: [PATCH v2] multipathd: Set CPUWeight to 1000 and LimitRTPRIO to
 10
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 16 Apr 2024 11:59:43 +0200
In-Reply-To: <20240415234306.1984762-1-bmarzins@redhat.com>
References: <20240415234306.1984762-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-04-15 at 19:43 -0400, Benjamin Marzinski wrote:
> If multipathd doesn't become a real time process, it was scheduled as
> a
> normal process, without any priority increase. Bump up the CPUWeight
> so
> that even as a normal process, it will still run with increased
> priority.
>=20
> If multipathd did become a real time process, it set itself to the
> highest priority, which is excessive. A priority of 10 is plenty.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
>=20
> Notes:
> =C2=A0=C2=A0=C2=A0 v2: Lowered LimitRTPRIO as suggested by Martin Wilck.
>=20
> =C2=A0multipathd/multipathd.service.in | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/multipathd/multipathd.service.in
> b/multipathd/multipathd.service.in
> index 18bb367e..a63ddd9a 100644
> --- a/multipathd/multipathd.service.in
> +++ b/multipathd/multipathd.service.in
> @@ -19,7 +19,8 @@ NotifyAccess=3Dmain
> =C2=A0ExecStart=3D/sbin/multipathd -d -s
> =C2=A0ExecReload=3D/sbin/multipathd reconfigure
> =C2=A0TasksMax=3Dinfinity
> -LimitRTPRIO=3Dinfinity
> +LimitRTPRIO=3D10
> +CPUWeight=3D1000
> =C2=A0
> =C2=A0[Install]
> =C2=A0WantedBy=3Dsysinit.target

