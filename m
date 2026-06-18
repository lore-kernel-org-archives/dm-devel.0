Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8146244667
	for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 19:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781811596; cv=none; b=ax2yOFcfGAdLlxP3Qu2kGQwXInCFJQiTU9Sbx3PFN7jWqg6s3xm/VbXYmtUyLQ51qE7kqzRb8ri1MtdRyWJb5bnsDDsAYxhgDT8Eoh7INf6ncJeVBDFGIEz17QML5ZWFsqBD8STvxCq51yYErmdWEJQk6CfTHD0TAhACbHMyVn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781811596; c=relaxed/simple;
	bh=ujuCkZxzNqeCHrd60AeokeH+DmBIJqLF506rIQTnrHg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n0bZNJ/i8tKaTQ8H08lrefBPgjE+eGR5KtjR3ZjqTk1kBPHsSWSD8cTQXDLdG5NmiaLJZnUWkp+DzqJSQOSfVXPMMHAIbdtuspHKjKO37Phhk+va/m6nGkxYwX4HjfN7XetDMKYQjidYzeh5KN/Yn8fumHkpnxObPNrsjH9yLxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EL4qyfep; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EL4qyfep"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-491609cdd8fso7913715e9.2
        for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 12:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781811593; x=1782416393; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ujuCkZxzNqeCHrd60AeokeH+DmBIJqLF506rIQTnrHg=;
        b=EL4qyfepI1odyiQgfyjKQVKwwe25ejgMcEaqCJ1XEsodYsVw+gxSjMOgkG1ncbj+pS
         JyVRmak2fAMQKPONMxW8/MkRT4Jz126euDnN+0YIyiRniGKWuIdj/6b58eh9oKyrH1E+
         iaWvmv+E3uwzm7BUbzUZv+FvxROi4ZyJyGfIDcHXWzqiCUObwvMosfWjL13dbox7T/M5
         uWCPYgSPfaA8QwMIaE+JatUYsjfYkWTlfCbeEvFg+S7OkUXu6L4ueeZCzEPBFsePkxSt
         UmibyPGitWgRMMJNbDT7yDpFTUppJroBBK8NWq71PT0drnK3Mkbn1ZoVO7G+NbdnfBu2
         nPzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781811593; x=1782416393;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ujuCkZxzNqeCHrd60AeokeH+DmBIJqLF506rIQTnrHg=;
        b=r8OuH994+uI03HMnC913epmVsBhaVlf+GNi7rBhmlHIwKjE41Ka4zCU3+7pcy/6zy9
         Zigqk9/8aChfnKh3Yk1p0JuJyBD4whb/ZJEJTPmwciDlx0NexGWbwY7tm4gLqgfedWda
         DTWEZW2HsVuxquK7Hxxq1VBjvznjsZXKF4NBVMn6gA+gd8WFGQcC+d8d0uDn8vpvIlGU
         cbUXEwfDr1gqN37cfqhOpmL0wV7OATxBTr38Jx88sprxyNgfqIa1wT9HNWIdE3+qu7uw
         QAj2umoM4lrBh8BA9P8WDB07RQknskdEGqakU5COWGDR46rtOe9R+M+R8hJSOFX+CAn8
         sPkQ==
X-Gm-Message-State: AOJu0YzoKP09uiD4G0tsJrnLQw0/Ozw/q/DA90lI3PnZ5g0lbimBpto/
	QUi513ZROOnbpZKe4+hPh7RS7qLl6n2XMqJ6UR2PkZSXrkuv0otIIYwxCwYglrw/ubA=
X-Gm-Gg: AfdE7ckIG729Enx7ISMO0wGwG7sbdh0HgT6jjdDRmaucfWKBzmBOLkItUsTS5fIuW/n
	35K5v3T4S9DB8hfM33nxnEoAbHFaa7EgqCXsCcEMtATIra5XRRcEie7beNZXhD5UtqAZQ4FY5/1
	83IcgUiYKTE+2NC/8RtYqFupZOVKCoLLkOb+v7aGabDTxdYPsrU8Ngo8TT4RMuMvAaOJitPtswJ
	8B8/wFlbsyLLIcAwmfZ5f/9zYFEnVZaAbtqMKpfArZ1ocsppKwrLt5XO0k6HZcw59zlIYuK3R4U
	yN8Q6gZE1rekbHFO5x7PgYCOVlQuemqcT2QEw51+5jAn9zDZMDUWlVf12h22h60Fzk4HvmjsrPm
	KwWJm3j2C1TcpPAMmGmnDnOc0ntI91cZyaqHib7WyH1jA5raO2gTBWfjKS5qZdFPIoUSdo8F6XQ
	FkZqOpyUfiWe7C0+78O1lmBvDd6T9dj6UFVu+/xfSa6ihf9EiuX9YWTQEathN4UXP2WD9nRuEUY
	0SqcKiS9wpW5PfwLPZEM39kCaKFk0aH4788tL++R+OAekjY42I=
X-Received: by 2002:a05:600c:2305:b0:492:2f59:4969 with SMTP id 5b1f17b1804b1-49240e5b469mr4770285e9.22.1781811593092;
        Thu, 18 Jun 2026 12:39:53 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46508a04692sm1415957f8f.6.2026.06.18.12.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 12:39:52 -0700 (PDT)
Message-ID: <afbc85cf75c12856c2a7348efc9102e4b04fb69e.camel@suse.com>
Subject: Re: [PATCH v2 0/4] minio cleanup patches.
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Date: Thu, 18 Jun 2026 21:39:52 +0200
In-Reply-To: <20260615233611.804954-1-bmarzins@redhat.com>
References: <20260615233611.804954-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2026-06-15 at 19:36 -0400, Benjamin Marzinski wrote:
> This patchset is to deprecate the rr_weight, rr_min_io_rq, and
> rr_min_io
> multipath config options. It's a companion of the patchset to handle
> their deprecation in the man pages.
> https://lore.kernel.org/all/20260607103831.336833-2-xose.vazquez@gmail.co=
m/
>=20
> It does not completely remove the minio setting code, since there are
> ideas for reusing this in the future. The final patch is simply a
> change
> to avoid a kernel warning message that I hit while testing these
> patches.

With patch 1/4 goes our only way to set path-specific weights. But it
wasn't functional anyway, so if we want to do anything of the kind
again in the future, we'll have to re-implement it in a cleaner way
than what we had until now.

For the series:
Reviewed-by: Martin Wilck <mwilck@suse.com>

>=20
> Changes in V2 (due to issues pointed out by Xose Vazquez Perez):
> 0001: removed rr_weight_mode enum, default value, and
> print_rr_weight()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 function declaration
> 0002: changed do_default() to mp_set_default()
> 0003: Removed comment mentioning the DM target version check for
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 the minio source.
>=20
> Benjamin Marzinski (4):
> =C2=A0 libmultipath: deprecate rr_weight, and make it do nothing
> =C2=A0 libmultipath: deprecate rr_min_io_rq, and make it do nothing
> =C2=A0 libmultipath: deprecate rr_min_io
> =C2=A0 libmultipath: don't set hwhander for bio based devices
>=20
> =C2=A0libmultipath/config.c=C2=A0=C2=A0=C2=A0 |=C2=A0 6 ---
> =C2=A0libmultipath/config.h=C2=A0=C2=A0=C2=A0 |=C2=A0 6 ---
> =C2=A0libmultipath/configure.c |=C2=A0 1 -
> =C2=A0libmultipath/defaults.h=C2=A0 |=C2=A0 3 +-
> =C2=A0libmultipath/dict.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 90 +++++++-----=
--------------------------
> --
> =C2=A0libmultipath/dict.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 -
> =C2=A0libmultipath/dmparser.c=C2=A0 | 28 +------------
> =C2=A0libmultipath/hwtable.c=C2=A0=C2=A0 |=C2=A0 3 --
> =C2=A0libmultipath/propsel.c=C2=A0=C2=A0 | 54 ++++++------------------
> =C2=A0libmultipath/propsel.h=C2=A0=C2=A0 |=C2=A0 1 -
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0 |=C2=A0 7 ----
> =C2=A0tests/hwtable.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 13 ++----
> =C2=A0tests/test-lib.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 2 -
> =C2=A013 files changed, 33 insertions(+), 182 deletions(-)
