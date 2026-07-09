Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A53F36C580
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 14:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783609130; cv=none; b=svx/wcN9NU1YeSOPtPFtsUI/IQc9j5Z1lkll+dVaIAuFHLMzuqT5UFO7H4rUMPa6GUj6NE7J/lKG3V5Na+Jmqc6Y5fYnejLCB6ZyPYSKeqZBWan3dPnk5UcPUtF+EATHzDrt0K76SF6SAywfIrt/mwxJRrd4f6PV7xH6gnTHciQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783609130; c=relaxed/simple;
	bh=OV447yAJHFywO+Pu5N7c23AOladzIK06lqaR5B1mhqk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YEqWFauSawISHUoq6CqzeHdosvJD/xolG9kmYl9GnrkOuh9HlN0hyrKCC5MiMzX2Ymc+zirohB90o7CDVV7wCAXNatxXVvGbVK0KeCliKtrMYnsBjH6bbTea/4JjPGdniYDPV6XMVptH403yixdT0HF9+q0y7jnaPYIf2ryXOq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KekMigfj; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KekMigfj"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4758b2a9e2aso629259f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 09 Jul 2026 07:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783609128; x=1784213928; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=OV447yAJHFywO+Pu5N7c23AOladzIK06lqaR5B1mhqk=;
        b=KekMigfjKXPZBGRzR/33744BWPojAbc/pryFU26SJtJKTykE/Zuw4G5cGAFLWSrOi5
         6jUkVNxOZhxrf39KebBmcSapkAfAZC5jnkhMG02Qk3bd8u1/T6bcEftY0WabS4DjfDYs
         jBcYQohzTJXuL/D1KQ0/g7JLwFcUySwcDCNK3B6KWNrTKTFj9L/K3QS0vWqYKWRTFV+J
         +3WtL8LxYDBxPVsFBmV8kxVeLyWY8WE9pv+zQOk58Q3pKMlMr1ESAjk45N/ChV3qztFs
         b3Fjhstlyh80kMNN2gYKDNyzIzv8zFuhD/8rMOhPs6rCTBgdvQYpKCZfJ1JgcNMYtD3G
         PWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783609128; x=1784213928;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OV447yAJHFywO+Pu5N7c23AOladzIK06lqaR5B1mhqk=;
        b=cyP4nlohahOWsCGdspK8mDV31ZmPgzhYCL51Bof/7zCKoD5dpYocb9cm5tq/NO0sEx
         3TAV2QW62fb5fYuYWKcHWp1AzUoQZniDV3rV+ETlnA+RmlZALAle8yIWM4vm8R3fK/dx
         mtuQtZi1wqmLFeseqzOgeI+B+gcaIMwGuJqQAyFx3uVLMmTCfhfjFN4HDC3ZZfFkaFTn
         xmyBnINZouEOXjKvW8atziynh5wa1JRNv1mjK90dVR0Yw+nO6Twydiq3RgiW1rU2nMZF
         eIZ1msgZO752jqk8Aze2Vkuatf5egPnBkwTddg1DV+6jUg0aCxHmRiZh/jKYdD8wTpLx
         25/w==
X-Gm-Message-State: AOJu0YyKU98pWCIYeNi74w+Hv4VhlPtl5L2wfTeTuOSGCv/D27VYAWcD
	iWkQUbWCZpQlndG2rzVcpWNhwLlKJpGJkfhtVAHodcrR31LzKlvrG7BO37y/yZ/9eRHimxGRfyo
	g0N/NF5c=
X-Gm-Gg: AfdE7clHfiJcEIaIO7oiXY3sXsh63Es7RKc34Vje72mlxsI6zPJzdmSnHeIJQyRFbX9
	1NoF5Pfx91VU2k4PN+wDav3eSYVdOmGDEnBPnS13eZBWoiMdBDrhaiwt81NBXLMHmAD/gSq2Otn
	FWn/BWhr/+u41f4v4oIFIZ5CRmVY35PQMdVvFBKCYwzYvsUSJIFL8e8CpMhLWhQSHt0HxAMDnSt
	Whin8HweeVurofEKLqdx3vzgO5ZiHhzj589eSktkpNO5Lc7C9wkH40IyBzAFh7ktSTWQMQCwNF8
	+i0vGs1iyFZ4ROlXgbksUt3t3XoHOVc5B8IUBSsH4+S1NlLFMQeGEWY7/pFVuzkKflsKhQbnIPj
	X0p8WUtodMapK+Eac4ANFjO3/v0N71YosNocriZ8CBGEcrOtd36Z4QKIOE9ZT/H3vn/5MRVAZqS
	MlMxTsCAoX0BW9C2NQMBnEUMYoOtZhoTx8wb83Nd3uaF/qMmmIqoTnqkkN8tHAOjB+JMQ1VDn4O
	/LW7Jke7flWH2O4u1RLFLcuuOtlbxJqSBjO5ng0USxmH2tUFmE=
X-Received: by 2002:a05:6000:230d:b0:476:dd2b:611 with SMTP id ffacd0b85a97d-47df071bb5fmr8027987f8f.3.1783609127655;
        Thu, 09 Jul 2026 07:58:47 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960634sm53055301f8f.26.2026.07.09.07.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 07:58:47 -0700 (PDT)
Message-ID: <5cf303a4c0782e6631a73f619d5ef2bed999beb6.camel@suse.com>
Subject: Re: [PATCH 1/2] libmultipath: make sure sscanf sets a max field
 width for strings
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Date: Thu, 09 Jul 2026 16:58:46 +0200
In-Reply-To: <20260707004817.1958264-1-bmarzins@redhat.com>
References: <20260707004817.1958264-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2026-07-06 at 20:48 -0400, Benjamin Marzinski wrote:
> In the iet and datacore prioritizers, multipath was using sscanf to
> get
> a string for a 255 byte buffer, without limiting the size of the
> string.
> This could result in a buffer overflow, if there was a bad value in
> multipath.conf.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>=20
> Note:
> This patch applies on top of Martin's ("libmultipath: iet
> prioritizer:
> obtain PATH_ID from udev") commit, from the "tip" branch.

As that patch hasn't been verified yet, I'm going to apply your patch
on the "queue" branch for now.

Regards
Martin
--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
