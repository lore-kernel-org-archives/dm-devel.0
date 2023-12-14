Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FB263DDB
	for <dm-devel@lists.linux.dev>; Thu, 14 Dec 2023 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O6UZ7jEk"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40c6736d10fso5340045e9.1
        for <dm-devel@lists.linux.dev>; Thu, 14 Dec 2023 09:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1702573716; x=1703178516; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vvwS+r3Fl0PN1Q1ZcghwojpT+5TtNE1zLylQzy5wdCQ=;
        b=O6UZ7jEk/JEM9iBTuKWmrDJdsbPyy5bNqfmvN1R8GcBG/6OJA121y/6mRlegDIsNH/
         fMHf9i5rAOouBBVJ/qQWVmqEHy2a0xN8jgf+bjdgpY1tP1jqa8mX0jfIXcH6nUq2rk2a
         69BXaPhIxwGoqzaCLe0ouypYWNjo1Y7CArsPsZ/5BYD7kjKx1iUxV+5iEgJ0BsiBfyF3
         t12u6Yi6y9zYVATJAvd4JdaczEhKpa2CHJ3jw4UOhgCQK4YmJD0ROjHO96C0CxWzb90j
         RXUldXY1XNF0du2uqLg2IvbDOLaNSgU8A9aFMRlN4Vg/VVj0imfZlJTa4rzksxTTthVB
         Zs8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702573716; x=1703178516;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vvwS+r3Fl0PN1Q1ZcghwojpT+5TtNE1zLylQzy5wdCQ=;
        b=AoRShej4LGPjzdO/ptgEfd5NNdeBGm23y4Htlt3oMzmWC1bkw3gwuak45dE080pn7a
         tT+qBkH/CJWLGA18TBbVr5AdxV8zZm5Y5cxIlthhXlbOiUDN6iJzyScLZIOR2FmAUbOf
         JSBlw8eq83Plv6KWRqsoUvPG4oE/bcyaXVCeGZuafzJl7GiYuTNZxgAI44HlEknVXgpA
         e4Z8ngcxGpnGtkVGOL6rhyDiG2ePBamR4JImXa+YB82aq8mRRbcV/twtnQWMJX53odBV
         ydRHw8W9eweY04gbemTP+E+/Uqd2900A0szoKLuCmQlM34Lb3OiorRxJWuZT0boZObTk
         WTCg==
X-Gm-Message-State: AOJu0YyHSGWGUr9r2TMHn/xUxVU/owO2YZ68Xv+25qJvE9vMmJ3IhvcG
	jHCQJtLGE1gO1HNX5EiqKn3GMQ==
X-Google-Smtp-Source: AGHT+IH0SCyqE0r6WgMX87BqpnvooHavBENbvAfXNxZJlW9S/c7DcgvOvp3GStFfBt1CyNta8ZQMAA==
X-Received: by 2002:a05:600c:1c95:b0:40c:3742:597 with SMTP id k21-20020a05600c1c9500b0040c37420597mr5839199wms.168.1702573715922;
        Thu, 14 Dec 2023 09:08:35 -0800 (PST)
Received: from apollon.wilcks.net (dslb-090-186-000-097.090.186.pools.vodafone-ip.de. [90.186.0.97])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b0040b40468c98sm26870597wmq.10.2023.12.14.09.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 09:08:35 -0800 (PST)
Message-ID: <9836ec8493130fd6f8ee3323fa7bd9d6da7a9cd2.camel@suse.com>
Subject: Re: [PATCH 07/16] multipathd: always start failure replies with
 "fail\n"
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 14 Dec 2023 18:08:34 +0100
In-Reply-To: <20231212235320.440336-8-bmarzins@redhat.com>
References: <20231212235320.440336-1-bmarzins@redhat.com>
	 <20231212235320.440336-8-bmarzins@redhat.com>
Autocrypt: addr=martin.wilck@suse.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2023-12-12 at 18:53 -0500, Benjamin Marzinski wrote:
> When multipathd interactive commands fail for certain reasons, like
> timing out or incorrect permissions, they do not reply with "fail\n".
> Currently, multipath and multipathc expect that a reply other than
> "fail\n" means success. Instead, prefix all failure replies with
> "fail\n", and adapt multipath and multipathc to return failure for
> any
> reply starting with "fail\n".
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libdmmp/libdmmp.c=C2=A0=C2=A0 |=C2=A0 6 +++---
> =C2=A0multipath/main.c=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0multipathd/uxclnt.c |=C2=A0 2 +-
> =C2=A0multipathd/uxlsnr.c | 12 +++++-------
> =C2=A04 files changed, 10 insertions(+), 12 deletions(-)
>=20
> diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
> index 0025e66d..77f8a6a0 100644
> --- a/libdmmp/libdmmp.c
> +++ b/libdmmp/libdmmp.c
> @@ -321,7 +321,7 @@ invoke:
> =C2=A0		}
> =C2=A0	}
> =C2=A0	if ((*output !=3D NULL) &&
> -	=C2=A0=C2=A0=C2=A0 (strncmp(*output, "timeout", strlen("timeout")) =3D=
=3D 0))
> +	=C2=A0=C2=A0=C2=A0 (strncmp(*output, "fail\ntimeout",
> strlen("fail\ntimeout")) =3D=3D 0))
> =C2=A0		flag_check_tmo =3D true;
> =C2=A0
> =C2=A0	if (flag_check_tmo =3D=3D true) {
> @@ -364,8 +364,8 @@ invoke:
> =C2=A0	}
> =C2=A0
> =C2=A0	if ((*output !=3D NULL) &&
> -	=C2=A0=C2=A0=C2=A0 strncmp(*output, "permission deny",
> -		=C2=A0=C2=A0=C2=A0 strlen("permission deny")) =3D=3D 0) {
> +	=C2=A0=C2=A0=C2=A0 strncmp(*output, "fail\npermission deny",
> +		=C2=A0=C2=A0=C2=A0 strlen("fail\npermission deny")) =3D=3D 0) {
> =C2=A0		_error(ctx, "Permission deny, need to be root");
> =C2=A0		rc =3D DMMP_ERR_PERMISSION_DENY;
> =C2=A0		goto out;
> diff --git a/multipath/main.c b/multipath/main.c
> index c37befa5..4b399e21 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -804,7 +804,7 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
> =C2=A0	}
> =C2=A0
> =C2=A0	if (reply !=3D NULL && *reply !=3D '\0') {
> -		if (strcmp(reply, "fail\n"))
> +		if (strncmp(reply, "fail\n", 5))
> =C2=A0			r =3D DELEGATE_OK;
> =C2=A0		if (r !=3D NOT_DELEGATED && strcmp(reply, "ok\n"))
> =C2=A0			printf("%s", reply);

Perhaps here we should check if the reply length is > 5, and if yes,
strip the "fail\n" part. That would make the output consistent with
what it used to be.


> diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
> index c3ae5db6..2401199d 100644
> --- a/multipathd/uxclnt.c
> +++ b/multipathd/uxclnt.c
> @@ -31,7 +31,7 @@ static int process_req(int fd, char * inbuf,
> unsigned int timeout)
> =C2=A0		return 1;
> =C2=A0	} else {
> =C2=A0		printf("%s", reply);

Same here.

> -		ret =3D (strcmp(reply, "fail\n") =3D=3D 0);
> +		ret =3D (strncmp(reply, "fail\n", 5) =3D=3D 0);
> =C2=A0		free(reply);
> =C2=A0		return ret;
> =C2=A0	}
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 4d6f258c..4df01666 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -392,6 +392,11 @@ static void drain_idle_fd(int fd)
> =C2=A0
> =C2=A0void default_reply(struct client *c, int r)
> =C2=A0{
> +	if (r =3D=3D 0) {
> +		append_strbuf_str(&c->reply, "ok\n");
> +		return;
> +	}
> +	append_strbuf_str(&c->reply, "fail\n");
> =C2=A0	switch(r) {
> =C2=A0	case -EINVAL:
> =C2=A0	case -ESRCH:
> @@ -406,13 +411,6 @@ void default_reply(struct client *c, int r)
> =C2=A0	case -ETIMEDOUT:
> =C2=A0		append_strbuf_str(&c->reply, "timeout\n");
> =C2=A0		break;
> -	case 0:
> -		append_strbuf_str(&c->reply, "ok\n");
> -		break;
> -	default:
> -		/* cli_handler functions return 1 on unspecified
> error */
> -		append_strbuf_str(&c->reply, "fail\n");
> -		break;
> =C2=A0	}
> =C2=A0}
> =C2=A0

