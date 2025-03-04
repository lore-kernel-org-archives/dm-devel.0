Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE9C2E338E
	for <dm-devel@lists.linux.dev>; Tue,  4 Mar 2025 22:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741127435; cv=none; b=AEDkucn+DGxDB8/DYNX8Xg1N8lXwTEqUL39YBlzuFk2mfGqx/SJFpITbqfEhQvMNUQwmFkjSHQU9D56POppWE/Qbh4DPI3TQUPhwBudtz5CLopUBqXOldj85NgjjRXRqeaX7luunGxkgkHLA3rIzJSOqoAOjST2sGW+kpM9haxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741127435; c=relaxed/simple;
	bh=qtjctt8NbhzMjH60bfKUB+DuPmDmZvddyJd2mt4MPuw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cp0AN9vOvlbnVBExIwZUOhIHgBGycf6RREzK22HsaHnqLudNXYVUBygbc31ZtTvit6t2xpox5UlNMnm8F5a4tfqr3Gy6JvqZKl+Uaw9vgbsGfkzl7Woy1lUz8okXItOxXxmVlJKWdVr8IT70duREi/wH1yS2vnJ0Bv/HQhMz97Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aK46xHzM; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aK46xHzM"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e56b229d60so449443a12.0
        for <dm-devel@lists.linux.dev>; Tue, 04 Mar 2025 14:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741127431; x=1741732231; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qtjctt8NbhzMjH60bfKUB+DuPmDmZvddyJd2mt4MPuw=;
        b=aK46xHzM66B0pz5XH1//A0vKHR7Ds3i9xCydeds+EqHGQo9DSKGmvvpEavR3GqciZD
         8rPGvBuspdh6hi2JoK2em4CUtBmnj0a85miSKs4MvCFFXXxMPOwbNZZy+0+7dlRl6Qqz
         G//6rtdMte8OTgTQOWo3uwKgZgAi1QP+IIbKdHF4OiJnPHWPkia/Xp+OyvCI8eCxoW4k
         mm91hCEgIc9CpFKiZx3iGfIHpgMhlNmqLcmfQePYYzmJ71zEUcbdl0oPFjCRoTp2aEpB
         mKQN34rnviAGWsPXO/bfbWB6RZVs/ceHotiqqqZ11bbAjRxSMcdLM+9jJvw2Afa9JC5f
         eIRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741127431; x=1741732231;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qtjctt8NbhzMjH60bfKUB+DuPmDmZvddyJd2mt4MPuw=;
        b=nfBdeC8MCDjMBs6xgevytwhFsJleAFOHuUCiANQosZnX2PoGOmLsZ/1FvGe/s2W06g
         XBo8h5JzG3mMjJrAQY0xdxJAGqoL/tCj+1i7Jsiyo4hW1PnBFcLXJ1tTY9swG2mNuxFc
         CBx+t6G9wX075ZyA30gE52gsG8Ig3tnvE84Mq4/J0qsjqWC3fI1stS6gdeSo7T8WkL6e
         A3a3ndTLRfGUE9ke7e6a504Qz+MYVROyuNo4fsxYQuAUsalDtbNRM4jKmRLHstWKTu4N
         F/nUbib40a26eGATkFrpGwexXH+kZ8PtQ9zwMa7lWLNUVNieDgfHDiaAQgWiV8b5aLdc
         1TgA==
X-Gm-Message-State: AOJu0YwCvV/aavg1N1+NzTsNDgbx8/fJo8Q2/UhwV6ryroU3iM7Hr3RA
	KLglfapbXb7HYPoYM3D5kiyt/oconJElXYL2epndyi+wezySIXiuSzmq5BtgP+Y=
X-Gm-Gg: ASbGncshcWFcPdBFVkrf3mxlxP4ULtZukgtgts72B1WYxPEYoCKD3sq72OUqq8XOTdA
	9RW89P46xQlTGZbnsma8l2V1CWYUBbs1aJVa/qckF9a1mT/J/0LuozMnfgyoO95KxFKN8Uwe7c2
	GcDgQ3FJsWRAw0A9ZFkzrkHiw9SqxM54TbzmQSogICGElNtvLfNnNu1hmjPBCFcBjB9eK3aAuKC
	t4cwc4a2m5rHrIne8jlNbi1nS7sM5Bn5gHS47SLNd8o/8wsJ4/cnCg2RZTkSdY1PfvvqvCTTaG6
	XkaSAZ8Z4VIlOWZK2xpU27q3Ji3EBNoC+bI6kBjcBX59QR+/HiGg4Y3z7Mp+oKgC127X9uHWlM6
	hNzOJhbqOBoplHmkIgEP8LYhq4rh2Vn1N+aC1cKXpAweG7V3FEZp+/fJ9h/pkmIO1WZSLK1dnPJ
	yytlU=
X-Google-Smtp-Source: AGHT+IEcJbm6pNIqd9G0DiBkplfh5tBmulnubN/np9Smues+AlngYxilShuBWMfTgS4ztCbeVWUmQA==
X-Received: by 2002:a17:907:9450:b0:abf:6e88:3a63 with SMTP id a640c23a62f3a-ac20ed51c3amr61778566b.9.1741127430614;
        Tue, 04 Mar 2025 14:30:30 -0800 (PST)
Received: from ?IPv6:2003:de:3744:d600:a441:a57b:4aaa:2b39? (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf443a9603sm741940366b.89.2025.03.04.14.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 14:30:30 -0800 (PST)
Message-ID: <a314cad2fc4f78fde0960ba204321fe182ce45d8.camel@suse.com>
Subject: Re: [PATCH] libmultipath: remove buggy reinstate_paths function
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 04 Mar 2025 23:30:29 +0100
In-Reply-To: <20250303195628.2998595-1-bmarzins@redhat.com>
References: <20250303195628.2998595-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-03-03 at 14:56 -0500, Benjamin Marzinski wrote:
> The purpose of reinstate_paths() is to reinstate all the paths on a
> multipath device that multipathd thinks are usable, similar to
> sync_map_state(). However, reinstate_paths() doesn't work correctly.
> For instance, it will always reinstate every path in enabled (as
> opposed
> to active or disabled) pathgroups. This is clearly wrong. It might be
> badly written code to avoid enabling paths in PATH_GHOST in active
> pathgroups, but that's just a guess and isn't necessary at any rate.
>=20
> It's called in two places. The first is when multipath is run with
> CMD_CREATE. The second is when domap() is run with a mpp->action of
> ACT_SWITCHPG or ACT_SWITCHPG_RENAME. This case just exists to run
> extra
> reinstates for paths that are not in PATH_UP, on pathgroups that are
> now
> in the enabled state, instead of the active state. This is old code.
> I'm
> not sure if it ever made sense to do this, but it certainly doesn't
> now.
>=20
> Multipathd already will make sure that its path states are synced
> with
> the kernel states whenever either the paths get checked or a dm event
> occurs. It makes sense to additionally sync with the kernel state
> when a
> multipath device is reloaded, like sync_map_state() currently does,
> since the path's kernel state will start out of sync with
> multipathd's
> state.
>=20
> However, if multipathd isn't running, I can see the benefit of being
> able to reinstate paths by running "multipath". So if multipath is
> run to create or reload multipath devices (CMD_CREATE), it will now
> call
> sync_map_state() with a flag to make it behave like reinstate_paths()
> did (it will only reinstate paths, but never preemptively fail them).
> I
> thought about only doing this if check_daemon() said that multipathd
> wasn't running, but perhaps people are relying on running multipath
> to reinstate paths before the next scheduled checker run.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

PS: this doesn't look like "stable" material to me. Right?

