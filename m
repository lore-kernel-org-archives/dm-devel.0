Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A0A1CA9C
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732312477; cv=none; b=eKx0c7pP+8EvlF7WZzOukR83pdQqMLfPc3RS0HpmIAdN2IpxAHLkTi/QNSrd8YtC3SlImtuOXZrZrqKWG6MbJQsaHvOzNVJPFYiCnLrO9gW6+AHjHwNCGm1Xo0hwpGEcKGmTxYQrm8qoldT5l0qrbIRcbYdcro0cDQPwzKOeF0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732312477; c=relaxed/simple;
	bh=HNghjqtBDbGbb/AQ8UsUnVl37ydKvGpTZ8Bdq75+kk4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W55ByGFcW7jdm5hPzL7VtOSKpP3c7J6UU9ZAMIah083p4pSiIoCxDJ8mM0BHlQOpQc5yKbIEV4lzhlYp2ljjW7wOLDpn4oSr289ijjIddaV0c3U4jz3qZvEoNhoL1ddicMVQWCt2M3sQPhAGxqoPyEm66bhFbALDRFoeJ+nlwO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AhFJnptd; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AhFJnptd"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4315abed18aso22811195e9.2
        for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 13:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732312473; x=1732917273; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bR5yntziVMmiQIVkX9Pn4y3ARvm+zFzAXkg2zHSqtDs=;
        b=AhFJnptdI7AKqoAiJpzBkCiMbUKvpASGPO1yfSS7dWO/mn5OkCikuw+TmT9F+q1yIa
         Pw2PsYw+OOOAUt1vO9aP06aiid7pVsm6gmNE7Wiq7V1dewDo0Rn7a3kVGKDjnORrOt9A
         GhcgbxR/fEHn3fXT8RDbu2/6B0JjCZwqN1N7rDAAFguDnjhvQRHneP7ukvksB3LV0Klp
         BBJIgoinvPTBbnsMH/zoqWKgS0KC5ZCpG/YFvFosfAERyfJZO07O6A4e0MJt1N0CzvLo
         tQwltQ4HfAHkQMM2RT7iCfqWf1Skh6spVEreDQdLoy3CNg4kAimrAyQQAw+pz336jSfG
         mzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732312473; x=1732917273;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bR5yntziVMmiQIVkX9Pn4y3ARvm+zFzAXkg2zHSqtDs=;
        b=c4aMimY6aAYZdZMOUBr5dNP30iku8ntfsd1lcl+dpzW9lcaEP6azI5nb+XOBrAFD2v
         2PCen8na0NHFl0CP3+s8iOQG7FeMa+CUULofVgLpvlC3slBt4kXhIraJWXQhxV+M+69k
         EhJytrDgWaS+rqsAV1xFo3S1ZuGkhqaLfGouR9aaeAjPnwld7eu+Kq1VQGrGzYYV+x8d
         mKw9niqz5CIGa3IYxnlyx3jj+gDelGMclCV9bhUtn4d0rlH2dd8AzeIFpNRXwTlY307V
         MCJYD2vlvI438a/xyxnVJGYCqFFz/9qswocBAcf64GYu9A+1CHdvRpTeuhxK2IIb8idW
         Sb5A==
X-Gm-Message-State: AOJu0Yzzbv4xajihaMagvQ7WHqDAG1saFCBmKVMG+T64Q7XDZNgIf1Hz
	r6CHBemN5+gBiACgdpnhNsXKNhUoj9HUQOb6GbECXqzzF9kSoLE4FkxGUCevVMg=
X-Gm-Gg: ASbGncvcONTtp2o7W/GdMbcVRNCUHgqElpE2LlWPCgqcN5RtwBxcH1xcuIaD39345lT
	6+1JCfN8AWncLuk/ddkT+tuDF8u7zlTHAORhjQNPYStJank6lZHZuyhK+k2agsT6g1Oai6a/v3v
	InkbEzr/2on13mN1fUex0MRwPtDeXkMB+bYz0EEzR57FYLxzYbx7Ve4rzRlUP7uw+mRQXFip4mu
	A3Zeg/tFHcE9sBjMXL7hNYsA6TwcOLugLqUvzwrHCTk0vOTGXqcqGOCpodlalHI8ZkOLwNtQzAe
	fGUsvEsJ2kx1j/x1jQ1b6t7cccnrPlLBE/E0ak6wskbc15FULCHMahNBOrHaimhVC5aZF0sJBpo
	XSJDr6w==
X-Google-Smtp-Source: AGHT+IFczj8lP49upndEqExnqgd3eou8LgOJ5TlqDVYOkzXWVI+apusdvqJnVXEImI67jTTBMRhxIA==
X-Received: by 2002:a05:600c:5249:b0:431:5aea:95f with SMTP id 5b1f17b1804b1-433ce430fecmr44950225e9.16.1732312472641;
        Fri, 22 Nov 2024 13:54:32 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-433cde97c68sm40057425e9.36.2024.11.22.13.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 13:54:32 -0800 (PST)
Message-ID: <e1b620534c909d8ea01e193292ec5dd1ad652ab0.camel@suse.com>
Subject: Re: [PATCH v2 06/13] libmultipath: handle a create corner case for
 empty devices
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 22 Nov 2024 22:54:31 +0100
In-Reply-To: <20241122211133.718861-7-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
	 <20241122211133.718861-7-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-11-22 at 16:11 -0500, Benjamin Marzinski wrote:
> Multipath already notices if there is any empty device with the same
> alias and wwid as a device it is trying to create, and switches to a
> reload. However, if the empty device has a different alias but the
> same
> wwid, instead of reloading and renaming the device like it would for
> a device with a table. multipath will attempt to create a new device
> and fail.
>=20
> Fix this by checking for these devices, and doing a reload and
> rename.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/configure.c | 21 ++++++++++++++++++++-
> =C2=A01 file changed, 20 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index a7257981..d0e9c958 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -835,7 +835,6 @@ int domap(struct multipath *mpp, char *params,
> int is_daemon)
> =C2=A0{
> =C2=A0	int r =3D DOMAP_FAIL;
> =C2=A0	struct config *conf;
> -	char wwid[WWID_SIZE];
> =C2=A0
> =C2=A0	/*
> =C2=A0	 * last chance to quit before touching the devmaps
> @@ -846,6 +845,7 @@ int domap(struct multipath *mpp, char *params,
> int is_daemon)
> =C2=A0	}
> =C2=A0
> =C2=A0	if (mpp->action =3D=3D ACT_CREATE) {
> +		char wwid[WWID_SIZE];
> =C2=A0		int rc =3D dm_get_wwid(mpp->alias, wwid,
> sizeof(wwid));
> =C2=A0
> =C2=A0		if (rc =3D=3D DMP_OK && !strncmp(mpp->wwid, wwid,
> sizeof(wwid))) {
> @@ -863,7 +863,26 @@ int domap(struct multipath *mpp, char *params,
> int is_daemon)
> =C2=A0			mpp->action =3D ACT_REJECT;
> =C2=A0		}
> =C2=A0	}
> +	if (mpp->action =3D=3D ACT_CREATE) {
> +		char alias[WWID_SIZE];
> +		int rc =3D dm_find_map_by_wwid(mpp->wwid, alias,
> NULL);
> =C2=A0
> +		if (rc =3D=3D DMP_NO_MATCH) {
> +			condlog(1, "%s: wwid \"%s\" already in use
> by non-multipath map \"%s\"",
> +				mpp->alias, mpp->wwid, alias);

Nitpick: This is almost the same message that dm_find_map_by_wwid() has
printed immediately before. Similar messages are also printed in all
other callers of dm_find_map_by_wwid(). I suggest that we either remove
the log message in the callers or in dm_find_map_by_wwid() itself.
Probably the latter, then we can decide on a case by case basis in the
caller whether the situation needs to be logged.

Martin

