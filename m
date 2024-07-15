Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CF44D8CF
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 16:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721061640; cv=none; b=StAbGgvZ3UsbMVVTHf9x6oDWHDcvtovj3edhGALLJWZrv/XZA5yookXQwqt1Bi8sp2FIOhSGsfHEfhiSXPX5vs1YhTc2X9a+4GHTSW4LbeU1gpFCS5ifYz7jZrJyVa1/p9RvEGC3ss78AxKWTiquwIwqhYijCcj/FCvuyvT2srk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721061640; c=relaxed/simple;
	bh=/SKkhB23quVItbTEE+zvP92lRmJeWzqsc1ECweEe5bo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KS2kMuG/bnwHrYedoHbRX8GtNpV3eKfBnHkl7Tz+HvPYuc7fQBIYUvTdshTGV/tYNa+5u9HarldZKtqh8PQVqbF4+3mbUJTBPpOjxqqGYQphtIfmbNA9590B6shHITLSXEb3L351Pg9QGw6yL91UVDXjEPGaE1GuaSsuo2BzN70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gavVEQoa; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gavVEQoa"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-58b447c513aso4993800a12.2
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 09:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721061636; x=1721666436; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/SKkhB23quVItbTEE+zvP92lRmJeWzqsc1ECweEe5bo=;
        b=gavVEQoa1BFuZ97XK6ZaqIUDfyNqYmI69y9q3WKGe1LdqkqVHAHDXRAX6NYl5jINqf
         jt/3XW0uwW61UTmjJ0Biz2pNcp+/FhNOCBrY12zHYYqL1SvNoeRB/a19Cqokc1ffMz74
         75A+JQbl7sSv4G5z5uaJVzQkgsztKG8V0ndNNEH7mpKvoXTRZHa9sMUdj27vEDJ3sS5L
         M9s9te+Une12gh8xySZ79fR+TIQi5C0i8lR5KVkHMBKuEQGxklu+xD4EUKajWdbvK2V9
         F+Fyy8sJVvlMZflggUf5Kw+9YWNMH+Gii2z2e+QPp6s/7vffynVNvb+irfQl6wre6yjz
         ONKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721061636; x=1721666436;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/SKkhB23quVItbTEE+zvP92lRmJeWzqsc1ECweEe5bo=;
        b=J6e5YKKj/YpKfgOwsVZNS/J3phfiAqljAg1uKYTAUCz6yxUMxgOUInQnUGjMoub9oe
         B46vTmlImA6OoJScGgNocPhj1jh+OcPjtynZ9z3kHhNHNSfvD19a/ofKTG6TzqZns3LH
         +5jjluRC0Wsz48l+7dzjPDfFkBcXtskcekN0wLhGQPVE/FuuY6i8cljhFXCC0sZikBF8
         a0Xq8poMkrjW5HdTy4V4/+fqvHgOHI1O9IoGNowOv2NbbHoYKXN9xH2LLv8ca+XjCZMI
         +tACXVeDPkwJxIbh8UndjKnRKTsCvg375KcQSETxCtQZfiLlfcMHbo2kTtbRblpq+Ssg
         +fVQ==
X-Gm-Message-State: AOJu0YxbSTQdFdM+Q8hukfPlVAC5GH3sQGsVlPiXSnm9lFSeZEmURLIS
	Zoy9NvfsYZo2MKSZulhAU1cHIohrU58y4Q4kOMA4Cis9lbVhRtP8BpyLyFHrmok=
X-Google-Smtp-Source: AGHT+IEi/voFAQ47xjb++ykBApkLGHGrOxmbc2mEPpn1rFpEYgPoDAKgn2N9WY3WIu7MRMHy6sj74A==
X-Received: by 2002:a05:6402:50cd:b0:58d:ebf9:4e2d with SMTP id 4fb4d7f45d1cf-59e9caa9914mr336411a12.2.1721061635872;
        Mon, 15 Jul 2024 09:40:35 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-59b24a76ef7sm3518532a12.10.2024.07.15.09.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 09:40:35 -0700 (PDT)
Message-ID: <aebf9b5742958621671cc1f0c95141e8b3dc611c.camel@suse.com>
Subject: Re: [PATCH 15/22] multipathd: always resync map in
 reload_and_sync_map
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 18:40:34 +0200
In-Reply-To: <20240713060506.2015463-16-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-16-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> reload_and_sync_map() needs to always resync the map after calling
> reload_map(), because the mpp state may no longer match the kernel
> state if reload_map() fails.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


