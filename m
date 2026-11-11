Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794391407;
	b=kHunaX3lgb9u0JMYyUtfFcWxfDmn9boYT1Ycw50aDBokddfxjj3uU9muJKD4Ga5KEbM4
	 F65GNBSJLJVgi482gS1wz9HOCKat7F3zXW2ThTmEavjmoEb4+KRNsmd6XZrxbCDvliXYh
	 VSA4S4fbSCqqNd6ilFgDjpF50M3E3jCKJG6sSZ60+3CEnavUoKNryiwZoX7f94Zcz4JTt
	 XktIkTO4r7HShrYO3kj2GuJJy7BYU7p+zlE4oIzH8fluApJyAUwxmuSr2FzWt48nbGDKJ
	 NWrDHkfT+NWLOrtpuyrfXaD0d9+UKqFHfk5kURlsvLTCQa1/DgJ8/mSIyqXAYqV7Nyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794391407;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=WIyySDXSY9wYkJ/4CMT6YnvYyD7xUGkzWd3HvtBVh0s=;
	b=ixyzj+2qSCaXZIQAikJngrHj2qjOtirWRn1bbl7P02T5u8rgBEfIfxRgW8n9cU1LmUQo
	 VVO9WTGxWjpjlZ9EEH8lYoITHsltOQ3WXQf15ZZTO2xZQ8VqyKfd6IWYRb03DTG1uiIIX
	 m4rVRK5rcWQWDZI/TILNdqqgEOlveYsoqb9azj8AnIiOn/VvaKe/jXXoARM/BNhH3Ojoh
	 A2cTM55DgOLLkxwQoL+7GS6AQFIOjhMsKijE01NGMc54qLBP1RpBO7xDJ59jRKC5XBEYZ
	 lBWgHTzv7Z+/kB+MMldVQDPUCWKMSrxTolONDE2OdNY2ZC9zGxf9HLulCMJ9a9T78jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ihGuiCbM;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9493260A2603
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 10:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9493260A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ihGuiCbM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794391405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WIyySDXSY9wYkJ/4CMT6YnvYyD7xUGkzWd3HvtBVh0s=;
	b=ihGuiCbM7u2inix+OYN03FLrP5NjV/34bSgzGCAy1Kebq3IgSiTdf34dLQVng55j7Df8QL
	AyECsOiA4zbyWI41KXXiTXA/VA1KC2HaKZixmkLkZWn23wsdNy4rvOTj81V8VZGVgxvS+I
	fsADQG9pSJS5uw3xCcbeeii7Zg0nZaE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-vkdMEjhlP_-FYmrodf4Uag-1; Wed, 11 Nov 2026 05:03:21 -0500
X-MC-Unique: vkdMEjhlP_-FYmrodf4Uag-1
X-Mimecast-MFC-AGG-ID: vkdMEjhlP_-FYmrodf4Uag_1794391400
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3ad00533aa8so16970281fa.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 02:03:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794391400; x=1794996200;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WIyySDXSY9wYkJ/4CMT6YnvYyD7xUGkzWd3HvtBVh0s=;
        b=UDOr3IxSmWHKZqMWb0ERgQG8O6vgXgtSdSOEEt4GY09nwQKbWKjiFolm6eTX3B+Fqu
         +nRh5M1a3PxaZOLGf3StliDNmcIPd68C4zB8QexIxTtgL7DOgV7vNArbqH3HG6WNvLOu
         UIXj7W5+jamCRVO8iFCJoANndb/hvF7jOls2+eAoYreX50csENyhRixrT/Ifz6IJkkQu
         qIq+Me8uJNcqTmAOJZmmyc+wbmTqPuShDmGMAh9x0szS3WbUXmLl+hB+M9N7wfgT3XPv
         HK9R3inTBKQEOwSxRF9mYjp1pxhuNddii0bJZ1tz2gdTwHZaiVcD8Lr8YL+roxvfR9eh
         BXDw==
X-Forwarded-Encrypted: i=1; AL+hErEiMBA+IAvg9NvSqwokeis60nQRdaK+eSG/OgIzjtc6KNWcwKUrDRF7ks8uU0ndW2nUXmAosS8syQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z/gzaerqrSFxnGTKLd8ebBxfdJq0C/av5k2tOL5vLcA1Qk6lZDD
	vG4o9PziZLOBL8XfEdYlRH6vnbb9FbRpFIdt6P76tvNw5PpxARv4N4RnTVcKHvJZzSX4l4Gq0TO
	MvqlIpPyROJlMkwmp7ErFO1XFZFcXD84G/t8Sv59iXohMDi5Hxx4n9ugcWzRcXlCB63lFt6cE87
	GibWl20H5PyE2UIfNRDAYjIw0C7vMlemKhXw==
X-Gm-Gg: AYBFou1NIW/J5l6ocIL+VBeJNL7Y0IrZ1lbtVQnEcE1NNV6G66AGx6v43IqIrmoIWoM
	rx+zXjFelGud+hx8pyZl7ZbLw0wPG8gmpscMSkCpW57G0rpHpotQCSk+v+NMpk5NJLlDKF9jneD
	04QcNXK/YmYYwhnsB6XFeRIjR6oeYSCZth9ACGh1R3DFnOOeDrr8hKf583ofPS8YBl4uvod6MsV
	oSEG3Z0+8waiBo=
X-Received: by 2002:a2e:a590:0:b0:3a3:7682:49a1 with SMTP id 38308e7fff4ca-3ae126d2881mr3556621fa.22.1794391400223;
        Wed, 11 Nov 2026 02:03:20 -0800 (PST)
X-Received: by 2002:a2e:a590:0:b0:3a3:7682:49a1 with SMTP id
 38308e7fff4ca-3ae126d2881mr3556561fa.22.1794391399775; Wed, 11 Nov 2026
 02:03:19 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <69e705f7-eb73-19c1-2ba8-0737a53d8614@redhat.com>
In-Reply-To: <69e705f7-eb73-19c1-2ba8-0737a53d8614@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 11 Nov 2026 18:03:07 +0800
X-Gm-Features: AclHuK-aHcFJ7bAib_-hjjkvsQYG9PIk-fpubSF_JlI-vjaUH9s2NmYF_TtWRbw
Message-ID: <CALjSBEtuu+dnta=6hRLmWSk2NmEebKDAxqLGcG3RBygrBr8XBw@mail.gmail.com>
Subject: Re: [PATCH] dm-thin: fix parsing of feature arguments
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -FJXrj8OJfQfsLRJQZRsPQh-fwp1eA_2gGTLnvcPE2c_1794391400
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 2:57=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.com=
> wrote:
>
> "struct dm_arg _args" limits the number of arguments to 4, but there are
> 5 possible arguments that can be specified.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Assisted-by: Claude:claude-opus-5
> Cc: stable@vger.kernel.org
> Fixes: 787a996cb251 ("dm thin: add error_if_no_space feature")
>
> ---
>  drivers/md/dm-thin.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/dm-thin.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-thin.c
> +++ linux-2.6/drivers/md/dm-thin.c
> @@ -3147,7 +3147,7 @@ static int parse_pool_features(struct dm
>         const char *arg_name;
>
>         static const struct dm_arg _args[] =3D {
> -               {0, 4, "Invalid number of pool feature arguments"},
> +               {0, 5, "Invalid number of pool feature arguments"},
>         };
>
>         /*
>
>

The ignore_discard and no_discard_passdown arguments are mutually
exclusive, so setting a thin-pool table with all 5 arguments is
redundant. Thus, dm-thin rejects tables with more than 4 feature
arguments.


Hank

