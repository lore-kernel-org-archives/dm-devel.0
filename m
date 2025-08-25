Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B134F5E0
	for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756138925; cv=none; b=rz6M0AdPcKrE+VzmOpl1Ma1nAlLTMD43s30fbsww22GFjBdD96itdEhZwSLTQFtdFcWteXRZNak0kxjndZyvOyTSNLvPmgPPUAHXfZg0kctxT+Jzcx10A7pzHp1a9d5xutOo2R9DfM/EYDxK5tO9KU8A3dJuNodRWl6pPdXP7c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756138925; c=relaxed/simple;
	bh=bjxQrEBtBv1Sp7edQWmewge0LJNdaQOgkMOu7X5kJiw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i9z3y20lp6sydoc7BN/ah7lw5La1gDzCKTbhnDNVUUGqZBCBpAVwJQzgXsPjAgPLwBBUJidw0fPHzvSGYHPolJY7S9m5wJNdUcLaJVk/lQJo4OBdd3xVAySLlNaWd4oPR5c6NYHsQ47LTFFZ0nlOF6rQkALzaWzTOvCUBPubSDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZCi9dpVc; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZCi9dpVc"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afcb7af30a5so780313566b.3
        for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 09:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756138921; x=1756743721; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5WcP/PiaLBwDa+girjZrZiLCa8t/Tq4qk2mmb/S7tU0=;
        b=ZCi9dpVccxdnXZDn1sFUqCtnHa3322dG86/TfT+2rEbO1RskH+XyqZMwx4aSWyChie
         vJC7T27YJnP7VpS+Y8Y447fk/SfNqpwxEdhxDl6G2YkB7tfyZc7E3UfooV3giDBQtqhK
         R5u/wuZ0sEtvjG+uV1Ub3/80WZdAcPIgQ4mWVVluudDyklahhJ03onW7+pqP69Eg/5Iq
         xJOftONnKiTEx0/HPmmEAwRPTukyXQZBRRLrbwAHv/r5j/3hgd2+WG/K6EsP8GNahtDo
         0pmvfaka+XzOL/KtugIekrSGdTkvnlHJ5+BoDWzSD57Dd+DordAVLdz6QMCdbLVvfABG
         9Usg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756138921; x=1756743721;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5WcP/PiaLBwDa+girjZrZiLCa8t/Tq4qk2mmb/S7tU0=;
        b=ArYaTBV6ETqBuT5my8EP8ZNNLkaQ+F9tlPJBoYHOtxUWRioeSySKLE/F8amdB65OEl
         4dim+nunsd4KVSgolkJM/X5kz4SnA0Xbv5tDFLGa9+Hrl7rK6+wUym04JG+d9zE5ARpE
         du72mBwweTaB4AyuJGvC3Vb3+n5kHd5CKppwnw4a/wuFddvfjXjBQ394R4SAwcqyMCEo
         ShYpyhjG1jF20RsH1O7gEb+7DmJ+xgzWcyc7d8vRNRk1wMhJwIBRZiOWbRMMmhvVAe3Y
         djsKUSxqLOVQhR98nA/oBMl0EQExwHY1yyagpEzisxYo3ln5Oc4A/c4HyJgcoMzXsOek
         dXLQ==
X-Gm-Message-State: AOJu0YwtEQv6VuAcFqWZ8muYZKQGBV+hGjyE19PKp5xN4FenjNwZ1MTU
	PHneyhc/mwvojfjmeYCHoiN4+lsHExAaPjwwWtfjYJsY5KfwrisPc9J3ZBNdddsnMoU=
X-Gm-Gg: ASbGncsHPZsYtDJoIUFLBkO1/KlenZ47X4Xn+/Uk9NQI+HurvtcY7iRkxGuOmYIOrL5
	5kAOY1XxJnF/xExQnRVwIN6oMDa3ic2TrU0CAnVYRvdO8O/Jy4KWIbrs5PugBh3WByWkafRGkUk
	p1euzPnr1M/szhQV6EJUiGuYh2Ey6gafzj6dGNDkJ4kcaOoB68htYgyusu5gCryKJnzPET61WnX
	VGs/kg3Kq7aH4LPPrbWrN+JoAP4Msg+fcDUfPX5l/IQP93KEuxQaUgWAX0dTs/4YuqSXOTMXRg0
	Po7SlEZFFBjmwvZWWcr37JxLVtnHGlI7gni+fDZbFYdgBlV/vH4SJ9H39yMcWgdNCvAS4gR5GIO
	5VeJg2/IL8tx6/mDX+yD0inrCCFDVKYx8/sZ7vOYhOa0BYKjY+Qrus0DLZ0UgBFSX8dZkn1a4Xx
	HRJ5PvLInhrcBdHbiOP72uGNEkb5wQAHrkPCvXql4rAaCulHUvr41/S9w=
X-Google-Smtp-Source: AGHT+IFHK1YWd6PdzydvrNxTgL7n7B85FUSoGR6QV/nGhmmtOmxlXbBXK/HtgfhLD9RU616dnTiu6g==
X-Received: by 2002:a17:906:4784:b0:af9:3f90:12a0 with SMTP id a640c23a62f3a-afe28fd3967mr1310484266b.16.1756138920952;
        Mon, 25 Aug 2025 09:22:00 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe79fba62dsm285231166b.100.2025.08.25.09.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 09:22:00 -0700 (PDT)
Message-ID: <7ceefd5d4a7fb72cb0162e3ef4c23286d128be09.camel@suse.com>
Subject: Re: [PATCH 10/14] libmpathpersist: only clear the key if we are
 using the prkeys file
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 25 Aug 2025 18:21:59 +0200
In-Reply-To: <20250726035855.363290-11-bmarzins@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
	 <20250726035855.363290-11-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2025-07-25 at 23:58 -0400, Benjamin Marzinski wrote:
> Otherwise this request will create a useless prkeys file.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index dfdadab6..f901b955 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -831,7 +831,8 @@ int do_mpath_persistent_reserve_out(vector curmp,
> vector pathvec, int fd,
> =C2=A0		break;
> =C2=A0	case MPATH_PROUT_CLEAR_SA:
> =C2=A0		update_prflag(mpp->alias, 0);
> -		update_prkey(mpp->alias, 0);
> +		if (mpp->prkey_source =3D=3D PRKEY_SOURCE_FILE)
> +			update_prkey(mpp->alias, 0);

Should this condition be checked in update_prkey_flags() directly?

Martin
