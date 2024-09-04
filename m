Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580C01DEFE6
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725466213; cv=none; b=Hg4JLw/V58AaKIcS2R3pN+RJxsuIrBJaQaL9TGvDN259k4j5ocbHF8F8PSwIblbBtPZBudlt+cWSbsjHrftuksdq++Cafy0j+kD5WwWeIRVNAyHDSOKp+ZGuWzwUmzgelUqu1RX9CM4dsHOT2lxkgkfCqP3zGdKt88QE12A8Ppw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725466213; c=relaxed/simple;
	bh=cbb+WNR/ZOLfPsv5R0v9Cl0gIIAkTT67ixrAjbrZgbk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lQcSUqc356GHUIh7gOiMWGkrRlOEEzShcdBmiH2DFXx5GVD2IMXEd62GzdAG+Rmemtjd7d6P1J7HNt7YUGjxHsgQj/kyludaq6cc5S1fPo01TRTXXx3dJ3hSaqJItGpc0BAzNTRdjzM3g9TMvMBXBiiImBY+jPtJdbMXHjT/vOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IAuvEDV+; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IAuvEDV+"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c26852af8fso3173075a12.2
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 09:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725466210; x=1726071010; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q2yeemNopmbX1QjFyIwv19wA+D9JT1z8G4CzKT6XfVE=;
        b=IAuvEDV+w1bwZaxveOKotg9o0FBk6Zrj4mQgOR8DW7aDsr4lEu7JJwarOEnoAPzZbK
         ZEjxhicDL46tEka0qwYia0wHQKc170O0jQMo/VVTGy3Fmac//gWhJpp0TMJ72xlqzu0k
         rJPXw+s5qHvWqWVZJImdpRNkmVxHlRUJzVztruv1e7DJ7GbAhO7WdknseGGCd0a0AJEl
         EhGvdubasyg711Wuzy7cl1jP9mwihWYjjZEif2TnVZeMg2Mw47V2mdtJbNNj/raIGeoF
         8Lk0zTQPyrhe2Helcn7RSh1IHZy+1P7s+XMu9dPJxTdFqqyHXHm2gyZzH/HSGilHjDPq
         11Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725466210; x=1726071010;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q2yeemNopmbX1QjFyIwv19wA+D9JT1z8G4CzKT6XfVE=;
        b=DAvpwP5LKIIaxINBPawFL8CF7bq0VpxPbkyFWit1lt8HdF9bHXBgYZPSagja5J75WA
         bM11wYg0WGC7sQgtkuYhZO/b4lmYWLkmiOR4gzEtm+63JSU3iRATBktwRbEP9nekHbSh
         qwqrW/HDU+GPegyPI9y7HsPPBmDafyn9M0FaaevKiuJM6JxekJUS/N+fcB5b72cUwsLp
         3HsJmis+aN9epk07iUSH0HkzyqE4EA4uUW83nhqPMVKxd0q27+N46uXBuGkurlHNudrE
         yWd0oWP1gzT7GqRF8cIc3hR8DrQtE6MCGboq3dBfZQx/i+EW1ooN42nRfs/9Xu/SfACl
         x9rA==
X-Gm-Message-State: AOJu0YyS2M527wdBL696vlVd8OEjYErq6kcSLYwn0FbB6yoJO5pxIVw+
	A9ezL18JKyq4txifNM1V4rqF5yA5JbAdO44/pHrGFaJyFveLhq5fy8f91k0euyA=
X-Google-Smtp-Source: AGHT+IGotSpWUIkvLNZfZIRiz0rszt8FiuUcWWMbsA5IxF+GjLvpgE4us5t+b1uiHBu2NuOQMciJkQ==
X-Received: by 2002:a05:6402:1d56:b0:5c0:9097:c0fc with SMTP id 4fb4d7f45d1cf-5c21ed89fe2mr16133158a12.26.1725466209499;
        Wed, 04 Sep 2024 09:10:09 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3cc699f7esm76755a12.60.2024.09.04.09.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 09:10:09 -0700 (PDT)
Message-ID: <79c1d4e097278f550c599909751d17e4a44a5557.camel@suse.com>
Subject: Re: [PATCH 15/15] multipathd: fix deferred_failback_tick for reload
 removes
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 18:10:08 +0200
In-Reply-To: <20240828221757.4060548-16-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-16-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> If reload_and_sync_map() removes the multipath device,
> deferred_failback_tick() needs to decrement the counter so that it
> doesn't skip the following device.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

One day we should add symbolic return values for reload_and_sync_map().

Other than that:

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =C2=A0multipathd/main.c | 9 ++++++---
> =C2=A01 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index f9b0ebaf..9e930b53 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2098,9 +2098,12 @@ deferred_failback_tick (struct vectors *vecs)
> =C2=A0
> =C2=A0			if (!mpp->failback_tick &&
> =C2=A0			=C2=A0=C2=A0=C2=A0 need_switch_pathgroup(mpp,
> &need_reload)) {
> -				if (need_reload)
> -					reload_and_sync_map(mpp,
> vecs);
> -				else
> +				if (need_reload) {
> +					if (reload_and_sync_map(mpp,
> vecs) =3D=3D 2) {
> +						/* multipath device
> removed */
> +						i--;
> +					}
> +				} else
> =C2=A0					switch_pathgroup(mpp);
> =C2=A0			}
> =C2=A0		}



