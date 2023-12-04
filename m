Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3767D28DD1
	for <dm-devel@lists.linux.dev>; Mon,  4 Dec 2023 14:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LUhzVekg"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a1975fe7befso473834066b.2
        for <dm-devel@lists.linux.dev>; Mon, 04 Dec 2023 06:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1701700684; x=1702305484; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y+z42rqrLIGmiWF79QyMzreUHBjW+I4b0LBv0aNlF6E=;
        b=LUhzVekg9poYokQehC9MLmUS6IwPsCfzBRjCtZXO6uhHNj0BdttY9EPaYHzWV+6Exg
         1VoG9mOXpYWZtuHT02qTJxSKpDm9pfILOMEtICkJ/KfwbECjsjlfkKxo/OiuXt7Gr9me
         BEUfvuKn92KH6hsKcDT/7PSZlXdZc9Y+RI4/XV2VD7Ynlx1DmPlrvZTfyvlm5zrBleIr
         Ul2KqJXwiig8kmyti62uTRkXX9l6mUXnGPG0LTAB2/C2J47Rn1N6z0AxOYuQpKl2G9hp
         82Nv1YyLq0RQbFmeU1gi+kX0S59SmfAl/cc07v+icLLhdHX/rXABfxHiAC1dScwXQgku
         Ow0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701700684; x=1702305484;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+z42rqrLIGmiWF79QyMzreUHBjW+I4b0LBv0aNlF6E=;
        b=qFDVcl9V1b8C5OOXNPF9gbt2n44lxbKTsPkp6YB2eYWdKppV+MjCKDRlL9h+weuYA3
         c6dgnds14j9d+qC4gjUYmyI9EWBn1D4uPWnX8iTmlGmaNCoZ31GcdLi+od7i5mgp9dsj
         nsLju0D1hqv3cgCXZ5086qAUYg+CXkaKUL7wSSg8q9kJEsvqCoIIevdMV5EbJ5fU4MPQ
         wBoPoHn4stkettsSUEjzkBMYhMyv67mMqamqYvgGC7eBlon0N7P4n0x8BOcMXJyji+j3
         vccU0W03p+fZDIwNL80x/CwaJEkNQKGhA0UwI8JO5ryhMV2X9PjyqckPpJwfoTYo7CPW
         EW3w==
X-Gm-Message-State: AOJu0YwG+Rpa866U9oA2KSCyPeiLlb/6e3zkXxxOUsI44UH9d3sht3dh
	c8zXr5bectbVHoQcgIgt/QCy7A==
X-Google-Smtp-Source: AGHT+IEPNlGEbsQhodylwQdTyeOb9LWYWn14j7XDAizURd67Irlq1X+Zi6vkZdwFcMvMdpFx0lPsLw==
X-Received: by 2002:a17:906:4e:b0:a19:a19a:eada with SMTP id 14-20020a170906004e00b00a19a19aeadamr3642322ejg.147.1701700684395;
        Mon, 04 Dec 2023 06:38:04 -0800 (PST)
Received: from apollon.wilcks.net (dslb-090-186-000-097.090.186.pools.vodafone-ip.de. [90.186.0.97])
        by smtp.gmail.com with ESMTPSA id p22-20020a170906b21600b00a1920bc79b7sm4880880ejz.41.2023.12.04.06.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 06:38:04 -0800 (PST)
Message-ID: <23fc863a947a0362e31e4cf685a4cb92f4e9178f.camel@suse.com>
Subject: Re: [PATCH] multipathd: Make sure to disable queueing if recovery
 has failed.
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 04 Dec 2023 15:38:03 +0100
In-Reply-To: <20231127215418.271708-1-bmarzins@redhat.com>
References: <20231127215418.271708-1-bmarzins@redhat.com>
Autocrypt: addr=martin.wilck@suse.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2023-11-27 at 16:54 -0500, Benjamin Marzinski wrote:
> If a multipath device has no_path_retry set to a number and has lost
> all
> paths, gone into recovery mode, and timed out, it will disable
> queue_if_no_paths. After that, if one of those failed paths is
> removed,
> when the device is reloaded, queue_if_no_paths will be re-enabled.=A0
> When
> set_no_path_retry() is then called to update the queueing state, it
> will
> not disable queue_if_no_paths, since the device is still in the
> recovery
> state, so it believes no work needs to be done. The device will
> remain
> in the recovery state, with retry_ticks at 0, and queueing enabled,
> even though there are no usable paths.
>=20
> To fix this, in set_no_path_retry(), if no_path_retry is set to a
> number
> and the device is queueing but it is in recovery mode and out of
> retries with no usable paths, manually disable queue_if_no_path.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks, this makes sense. I am just wondering if this logic should
be moved to enter_recovery_mode() / leave_recovery_mode() instead.
That pair of functions is also called from
update_queue_mode{add,del}_path(), where the same reasoning would
apply, afaics. Am I overlooking something?

Regards
Martin

> ---
> =A0libmultipath/structs_vec.c | 12 +++++++++++-
> =A01 file changed, 11 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 0e8a46e7..3cb23c73 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -627,8 +627,18 @@ void set_no_path_retry(struct multipath *mpp)
> =A0			=A0=A0=A0 !mpp->in_recovery)
> =A0				dm_queue_if_no_path(mpp->alias, 1);
> =A0			leave_recovery_mode(mpp);
> -		} else if (pathcount(mpp, PATH_PENDING) =3D=3D 0)
> +		} else if (pathcount(mpp, PATH_PENDING) =3D=3D 0) {
> +			/*
> +			 * If in_recovery is set,
> enter_recovery_mode does
> +			 * nothing. If the device is already in
> recovery
> +			 * mode and has already timed out, manually
> call
> +			 * dm_queue_if_no_path to stop it from
> queueing.
> +			 */
> +			if ((!mpp->features || is_queueing) &&
> +			=A0=A0=A0 mpp->in_recovery && mpp->retry_tick =3D=3D
> 0)
> +				dm_queue_if_no_path(mpp->alias, 0);
> =A0			enter_recovery_mode(mpp);
> +		}
> =A0		break;
> =A0	}
> =A0}

