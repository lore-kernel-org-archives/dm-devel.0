Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4F626A089
	for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 22:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742942422; cv=none; b=nhrqLnLVQS1zAlSLD2PbXb2dXB2LCG/WvM/VcSR1SJ6sykrKJJa/duh6tvpiMtL/6xRFY/hn4KBuysOL+X4nBdB8OPkCRV3bAPl16U/GZihZE+cO/9nanrmAOOLU9GHORzRS0AlYmwlMcHaL6ZhWmr3ESsEDkK3YVpeQ0lyIiOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742942422; c=relaxed/simple;
	bh=dZApIzxNMloq7Z6GNClVa66wmILj3Iyx4xK32BBAEug=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kaIjC3VeQJPws4V9HwvQPdtylWxVQVhcnDsTzFpaOEjAdDbocyzfyZ0RXhsVwYL1iNkDRJ5hw4pl6hfNSQgOmBsGGuw7VhRpodGhnQwN5l1bQ50z82crLX172nex46Io4jB5en59mj58uWGZQlV8NPHjVjJTuKXXop8fLFLOAMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g5E60Dhf; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g5E60Dhf"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ac289147833so875254266b.2
        for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 15:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742942418; x=1743547218; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nL6sIMuOn0u4+s6kNaur+QaRyTdN87CL/l222EEGHJg=;
        b=g5E60Dhfz6tEKhIWzWBWzDFQECrmQK+XpWIJJ1sCpM0prxgNh6jqKAkSFoLoRBxXN1
         9PUXQ2yY7NjR4Hbf0rQzdBn19FhyXrAXBchF+I+6xMRNUJk9RnayXzQG++fUHzyxylT6
         2JSkpEFCD4NqRk1Bbr44mY8eLpKyszSuJIHoJRasByzylDk+eHFtSrrAN38Nc5GJ2AdB
         RZYOFSznP32s8u0Am0Tmb9hYsHF3sKE0SkGJ1SkjYl0rcFPZb38RQ9MQhjI35tte7o4Q
         jrEXlTYtTwhCpXRQwsjnswDCcnJBk0OdCAkAxNhFI+iWyppHYA5mVhheWQdQajtyee0C
         icXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742942418; x=1743547218;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nL6sIMuOn0u4+s6kNaur+QaRyTdN87CL/l222EEGHJg=;
        b=mLryGb5silWgRJcXMKazdd2z2bYgpX0hWj0mKFkyQUX3yc/aXpkpbgW9BBKloI9qYg
         r9SlbioBWPpBENXHNUtuWC3OmhGJ3I62EPb6P3kUKMcT+7dpfuVsZJ4wQFoB1Ud67Tfg
         iuqSoP9JPk9Lj0WDdlxoH+GgUry1pTmdAiTr33s0l7DIl1R0fG2s18sgjU5Mw63SCxuR
         W7gcKPqhE7o7nSLJ+NjVThRnVT1mul9b/vGEAFwnVzDWirqEVrBKdkGvMMu2JlFWt5Qa
         7WCFXtKNia6IqTM/ufbamvMiDuiObbdQP6HrSORSvQ2HDwvqfG7DOJHujxY2npcwRBvq
         3iFw==
X-Gm-Message-State: AOJu0YyVnlG7NeI5cP0B/Wo/9HvAwckoM+r3IcsAWR8CPGwHmAM7OnL/
	nTvPJBQ5focfepDiCW6lsDJA2ClN7d31qpL0kSfWcuLEiXUftAEn+zLZRX+gu64=
X-Gm-Gg: ASbGncunM+YLAw//plmPOXa3zB4vB71xVmkS8wmmfbClbfmxALHmF7d3mOnF/SEOcWD
	ZOwDQPYlLZyNolbTEdd57aZ/MTl69d1tFooHnugDAvoXETLlXqjB01SNBvQJY7dTZW57pfMnHG/
	j3vsnMHc3hEu/RS+73RcXeOGt5jhg2iECc7LXLp9fQuQ9LWFymz0zrJ8uEV9CnRELezQwnmIqvm
	crkyEceKFBfRbojzlfaT5yNeEEpIz7RP/hftqX6OiN1/5wnbQ/vOnseL5nfr5F4xO392WHNHwqD
	CLS5u+2zNIuplnIEBFxT82fiBeHQ8w12BSEK5OC2esWywVoEHmaDDujII8AhMpdB8fUWH9p+hkT
	CIvZQt4yslQUfs3LZ1Kcl/GSDz929MwrZdYIGkh3DDj291p85OgJbbBAWfj9IwHvdYajDtn/uWh
	a4YMQ=
X-Google-Smtp-Source: AGHT+IE6qzYUlw8dOpVnlTQQRqYyWHcdyH3e3aHQRbo6vSwcs1gLNk9hJUcMHmJsotvqTy0lA7b/cg==
X-Received: by 2002:a17:906:c14a:b0:ac6:d7d2:3221 with SMTP id a640c23a62f3a-ac6d7d233d6mr208905866b.24.1742942417738;
        Tue, 25 Mar 2025 15:40:17 -0700 (PDT)
Received: from ?IPv6:2003:de:3744:d600:a441:a57b:4aaa:2b39? (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac6964189f1sm474744266b.33.2025.03.25.15.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 15:40:17 -0700 (PDT)
Message-ID: <32b431bbc0862658491874b78ce8e799401f2bf7.camel@suse.com>
Subject: Re: [PATCH 3/3] multipathd: don't update paths in INIT_MISSING_UDEV
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 25 Mar 2025 23:40:16 +0100
In-Reply-To: <20250324205504.2523493-4-bmarzins@redhat.com>
References: <20250324205504.2523493-1-bmarzins@redhat.com>
	 <20250324205504.2523493-4-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-03-24 at 16:55 -0400, Benjamin Marzinski wrote:
> There is nothing for update_uninitialized_path() to do for paths in
> the
> INIT_MISSING_UDEV state. In fact, there shouldn't be any paths in
> this
> state when update_uninitialized_path() is called, since they will
> have
> switched to a different state in check_uninitialized_path().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck  <mwilck@suse.com>


> ---
> =C2=A0multipathd/main.c | 1 -
> =C2=A01 file changed, 1 deletion(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index ecad5a4f..9c44e6e6 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2889,7 +2889,6 @@ update_uninitialized_path(struct vectors *
> vecs, struct path * pp)
> =C2=A0	struct config *conf;
> =C2=A0
> =C2=A0	if (pp->initialized !=3D INIT_NEW && pp->initialized !=3D
> INIT_FAILED &&
> -	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_MISSING_UDEV &&
> =C2=A0	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_OFFLINE)
> =C2=A0		return CHECK_PATH_SKIPPED;
> =C2=A0

