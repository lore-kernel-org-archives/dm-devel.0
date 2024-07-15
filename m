Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3021F8121B
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 19:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721072442; cv=none; b=EmbhFVaNeTGtYGzApUv70weMoBR3ECKziXoey4uAVR/OLroRILz76wMC85jex8dcWZzL96k27/fWgi5i8exSkgOlH/ZzuUM6ZLt3a86LtlQvO3olyyfuVdGaKRGF/H5AfCjBjgEiq+R2eBCLxJjMAiO5qhpmkamS/iEkXTaXB5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721072442; c=relaxed/simple;
	bh=PD85X9Fnp22NPdykQWtqm5WnIpTP4ToZVPH0eUTQNS8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PWFEudN1GB5pBxsFaDFgEB64WGTDS42uN8MvfEZXdj354ISeaZVoT18VX/gflAxXxHlvX1woI/Exu0jLUj2nA3zVExR4yhbD1UXVXEdlXHQ8aOi2OhQuVjxCv0SlgZpj8cMtF9n92cAGweDFk/B1IFEpHVirSAmsU8JHaVasbo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MCu0umll; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MCu0umll"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4266b1f1b21so31580415e9.1
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 12:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721072438; x=1721677238; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N39uzKs8m2k0tWyPbuXXSWmnE/KKu9ouybu+N0W+szU=;
        b=MCu0umllk58XFdSCsBq+hf42rP6Xaw107Q+hY6IMa0WTAIoQ/WWwl7k7t0r35QIws1
         Yk5VZQdQrgCq3M+qKYhptiGobq+RdMHxtZNBFtWJVRFYqzIfMHVkhBggcQ9x/8dtzgLT
         lsjwlXAb/FT8pIYTRwXRFakPvCBm5AvcZPJT/hyx6oHkImzcVe2bDcRBAl/MJpKZ9yKm
         qXpc9u6uzdxFeQqBTaCKKHKZE2tXs2b/y41pVh/aleDe/mwJfvM19be4gm+cnafJA2r5
         FsbXA0gzcuDpWoyEhzZR6KF7d8/xWFX1rZES8ugcB9u/U6G4ewHRvd+7gQdxEqRCKcYG
         /gPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721072438; x=1721677238;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N39uzKs8m2k0tWyPbuXXSWmnE/KKu9ouybu+N0W+szU=;
        b=n9VNS0ychNVGf3Sq+bSlF6ERvn8L7NiT0kDKEQg0gD/mBKXJf8DLI8+a4G7LHNn2Do
         lIGtd9YUFJxKkoCvZe3SJvdrswSr6qKM8D6BCzpFvsHN1LtQi/lzMQ6y/YL4bTo7Sucn
         4h23o9mnn+LKtOa9fzEx9vWIdAuystSNxCRbvE3rUEfWR1YN2/kaQ1P/0nsqG61HiyUW
         tZvi0zw8/X2B4F6SB/ssHOwt3gdrbQhYnMOY5j8wW006JY5PmMZxwZ5B/xr1NZsnxUWo
         JLqQRhPnWtCyuORGnOUbxkzyJKpLehc6bz/I5yWA9QkZnwSeyYQPD9V9hELd8QHXKG2i
         w2fw==
X-Gm-Message-State: AOJu0Ywz6QEFw7Y9D4del3bQqktMYUbEJhCPVr3povN97TVCsLDkv7Ao
	AhzEFSfjRParnYT4nesBzKtZelc97jiPNxb73LbWc7yO4HHAVhFE5WRe5y46Im4=
X-Google-Smtp-Source: AGHT+IGNLcVPcksP/hO3cmYiJTTofCAHJRC6v7MP6NNL2HZxDdK5YNkK5e+oBRB+gsHSYZZLzU+RYQ==
X-Received: by 2002:a05:600c:450a:b0:425:69b7:3361 with SMTP id 5b1f17b1804b1-427b88a3acemr3995255e9.18.1721072438217;
        Mon, 15 Jul 2024 12:40:38 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f276a62sm133631655e9.24.2024.07.15.12.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 12:40:37 -0700 (PDT)
Message-ID: <c1221783863ab8faf540e82620cabeca738c670c.camel@suse.com>
Subject: Re: [PATCH 17/22] multipathd: handle changed wwid when adding
 partial path
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 21:40:36 +0200
In-Reply-To: <20240713060506.2015463-18-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-18-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:05 -0400, Benjamin Marzinski wrote:
> If multipathd noticed that the WWID didn't match the device when
> adding
> a partial path, but removing it failed, multipathd wasn't disabling
> the
> path. Instead of calling handle_path_wwid_change(), which doesn't
> make
> much sense when multipathd is expecting a uevent, just manually
> disable
> the path if ev_remove_path() fails.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/cli_handlers.c | 6 +++++-
> =C2=A01 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 0643be15..5d8ba3a6 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -540,7 +540,11 @@ add_partial_path(struct path *pp, struct vectors
> *vecs)
> =C2=A0	if (strlen(wwid) && strncmp(wwid, pp->wwid, WWID_SIZE) !=3D 0)
> {
> =C2=A0		condlog(0, "%s: path wwid changed from '%s' to '%s'.
> removing",
> =C2=A0			pp->dev, wwid, pp->wwid);
> -		ev_remove_path(pp, vecs, 1);
> +		if (!(ev_remove_path(pp, vecs, 1) &
> REMOVE_PATH_SUCCESS) &&
> +		=C2=A0=C2=A0=C2=A0 pp->mpp) {
> +			pp->dmstate =3D PSTATE_FAILED;
> +			dm_fail_path(pp->mpp->alias, pp->dev_t);
> +		}
> =C2=A0		udev_device_unref(udd);
> =C2=A0		return -1;
> =C2=A0	}


Is this sufficient? Can we be certain that this path won't be
reinstated by sync_map_state() later on? That's at least not
immediately obvious. Perhaps we should orphan the path?

Martin

