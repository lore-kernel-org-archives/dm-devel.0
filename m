Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A43C1F8725
	for <dm-devel@lists.linux.dev>; Sun, 24 Aug 2025 12:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756040249; cv=none; b=MHE56RBKGrBfkQGzkQWJ/7/Zug7kWa36SVRIkEr/4r86Q2r2xxuTFMQx1Co1MLNn5hPOA48OvT8xbSuJfkntixTFxcgR4zFvTWZvHM1LgCHbyJP/rpCCyjVkGLVmDtFPTSB4hqdRp4VA9+RkEhpP8abaFOwwkYJCnUFypmuoyG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756040249; c=relaxed/simple;
	bh=S2t2Bl/HLfKk9g/HZmYsXb5mBHVOo5cTnw+NPr2NJUg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=THjsUfJj0SR37VlECeamSVVdOsvfLgzvCm/IZ2UrTc3Q4rDBg8TiuUucdRn7i76UfmHBptCIq7YTeFnV/fPML8ddvEdJ/x1YzW69HZnH4NlwIgVyprrx0+1kBoDB5RP3q40clmb6tRCMI3rn/FHQpbaarEPwiZ63BMWDi6knlTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZzT1phoa; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZzT1phoa"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3c607029266so1327270f8f.3
        for <dm-devel@lists.linux.dev>; Sun, 24 Aug 2025 05:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756040245; x=1756645045; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O3bp9Q05BcFj7IjponeUkXkzTfPqR9Vun25OVKfAJA0=;
        b=ZzT1phoaiykpYhMlY1zTkPsEVxPJYKPQIw/e108IJ7KajDwWQTLUsihpx76CaEDH1W
         8oNNDVGAxuVwNyhXCZZRiBiBBSPYoLRRFv4AjXCwn6/j55C5A6E1hiSBtpGAhPL/UNYV
         Q6IZXTnvk+Y7qK18rxmxE0dMvV/JqWzSnN/+BEf1fxenj43jzZnVJHU/gZDGCoJaw+V6
         HHdIBlAc5cRUQKlJIMutyLDrsj3JbC6UrfJzwTx6NdynkylYM7odcVpZtff9b/FqIa0A
         3VuJPdC87lR0QztqVDIhC6KCA85RZy+Y3/XbyrPgSHkmYY1BCEgusRI0CllC0IOArvaZ
         AUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756040245; x=1756645045;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O3bp9Q05BcFj7IjponeUkXkzTfPqR9Vun25OVKfAJA0=;
        b=FwbWVvoC6SRKbksudQbWdwQrJuK51LSKYwViN0eHIX6xX+jJsioB5958g/IMDFKwPz
         jfutaKh8CffwYz9M+KzvzlSyaERepjwXmvivWMMQGBZAqiecKUhii1porsZRLhqOzwA+
         T+vimHvWdYW58DolO/izqAjrbMPNcrrrIY18rBBEzO/Vt/NjeTzo7Qw9alQBwrlEUe21
         8evIzPkNq7Kcde988KPK7f8WA9B4lZoAdv+hvhZTy9Px8hNO/Acf9Yq3zafM244uyOqj
         oef5ij1aB9bJLA4H/6lh3Y28C1cwQFGOlm4HH99N3puDHn9OUSzelJkylj4SHAU1uUJS
         hKtQ==
X-Gm-Message-State: AOJu0YyDtGOfCmrak8gBhZLQ0ieYu3EQPcDeAZjzAlh8Flyjw6asRFS9
	b/ytDOufGmZOdGi2n/wlFTdQOWfTpuAKLA4DDlwea4Yix5SeMk/ahDcukHBJClmlI14=
X-Gm-Gg: ASbGnctM4sZ51JTlvNSk60HEm/uxmf0xJe57c55nG9qfCIDUYxZ+LsjsAQ6rmUqzRAS
	DEgOTUDgNA6absm0JpKRazYPGQj/LqK56KUTbksrzrd+MQAdXwtu8xMwZWNAJM9tMVtMYqfCBEz
	52a3k4vhhk4NyCsio0DWccUwnL+DXfD2WnlQOcnRYskvQRXis53pnBoyp1xRS0xU0rWzQzOxW17
	K8uMzjY7oZuIa4cQxwx7oNO/L29nBHQAu/ZeJNoeYV3zyOuX/EHIZFc/jE+hUQKHEVfrm6VZNbg
	Cv6Hvf4oqfOMl9rPnSTLsL6a48hEkyWTVASc4P66X5CS4m/Uz9MeVzoqwJqVlOz4E1zXlrNxSlf
	xDyls++n8ClosjCK45F/KZVCD7fy0c2Mhd7FkmB9XiTB0h4BSpnZM/huK5JwYNloYxvDge5K073
	btce3fqzJsIRAbAMSlRJadJfTN5DFai36rvYcoU2skVSARhLEqY7TcNA==
X-Google-Smtp-Source: AGHT+IEXIswceP7eOkA0NTSMQ7HG46GYacYfU53Mb7FgH3OyBiJ+57sAbsSuQtIsQEbw+GXsbUZ0WA==
X-Received: by 2002:a05:600c:610a:b0:456:24aa:9586 with SMTP id 5b1f17b1804b1-45b574ece0emr40442585e9.21.1756040245352;
        Sun, 24 Aug 2025 05:57:25 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5758a018sm73505945e9.21.2025.08.24.05.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 05:57:24 -0700 (PDT)
Message-ID: <d2797732d55fbeb4f474fffbde623c8480da27a0.camel@suse.com>
Subject: Re: [PATCH 03/15] libmpathpersist: reduce log level for persistent
 reservation checking
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 24 Aug 2025 14:57:24 +0200
In-Reply-To: <20250710181100.3997759-4-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
	 <20250710181100.3997759-4-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-07-10 at 14:10 -0400, Benjamin Marzinski wrote:
> Move logging of minor expected behavior to INFO level. Modify the log
> level of some messages by whether or not mpp->prflag changed values.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmpathpersist/mpath_persist_int.c | 26 ++++++++++++++------------
> =C2=A01 file changed, 14 insertions(+), 12 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index 612bbed9..4172167a 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> =C2=A0	}
> @@ -761,22 +761,24 @@ int update_map_pr(struct multipath *mpp)
>=20
> =C2=A0keys.key_list[i*8], 8 , 1);
> +		if (libmp_verbosity >=3D 3) {
> +			condlog(3, "%s: PR IN READKEYS[%d]
> reservation key:",
> +				mpp->alias, i);
> +			dumpHex((char *)&resp-
> >prin_descriptor.prin_readkeys.key_list[i * 8], 8, 1);
> +		}

I'd suggest to restrict usage of dumpHex() to verbosity 4 and higher.

> =C2=A0
> -		if (!memcmp(&mpp->reservation_key, &resp-
> >prin_descriptor.prin_readkeys.key_list[i*8], 8))
> -		{
> -			condlog(2, "%s: reservation key found in pr
> in readkeys response", mpp->alias);
> +		if (!memcmp(&mpp->reservation_key, &resp-
> >prin_descriptor.prin_readkeys.key_list[i * 8], 8)) {
> +			condlog(3, "%s: reservation key found in pr
> in readkeys response", mpp->alias);

This one should be logged at verbosity 4 only, too, IMO.

Martin

