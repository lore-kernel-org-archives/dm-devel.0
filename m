Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DDA187344
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 22:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732312990; cv=none; b=OZLqhiuG9v84XRd1WQKEWHWf5nR0Gu8f63N/ZqOAYaVvoyW+uzJGMGlb1YsShyhVU22d8cfQrQ6dHsmMKxto3KOKEPi15DRza5ATGOXBQLycEXbfEW4EOna4dQ+AaScif60hMD7TRoZVOD9hp80OFVuUXEobNRg0sVHCgoObbo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732312990; c=relaxed/simple;
	bh=7qq5RjOr87vpibeK4kW05N9YlxESN0/KNm/X2Xr9IiI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q/Qa9Ovesvk6WGQSFpH4H38OY/XNap4n2BkjBNY6L+Gqf+zZHc79l6wTy03AuGbdKGAhPpZwIJupYlFVWw3WDD9Afv4VJIuR00h7UnUohTFmZ5hoHPlyx//+ztI3frXGvYtBbkQIku5Tso0N5MAly7HqYTyOOHtXtgLOyCG2JQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MQODoQg3; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MQODoQg3"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43169902057so22594865e9.0
        for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 14:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732312986; x=1732917786; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7qq5RjOr87vpibeK4kW05N9YlxESN0/KNm/X2Xr9IiI=;
        b=MQODoQg3QCqq2gBB/tqMG7K3VDwwVH7Lr5DgWEAE53za/ZVea0GOxIs2OdYUU01Zp2
         XrYkqS+AWbA2MQDgiVOGJZOWIbHFjs9d8CnWFxhdzMGOZvQMHNgEUNx0Wld5QiHHkC7j
         n7iFvRLbylwTxfkZWtBpI6Xbt0EWHByKfPk9TCWhLTdxBzAr0MJaXH3XIkz7ncHZ7huY
         95a04yTd3DAs7m7B0e/YhIyB5r5rZQ8JwJH8FU4bgdvY2R+j6NNpWm8ujBMBs2Pkeyi1
         AAztv9eox542jCmwAhqavgYtAqZUd97pYYRpEfjeh4Y+EFyVBWh7RLQtWF5vt+pxYApz
         ae4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732312986; x=1732917786;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7qq5RjOr87vpibeK4kW05N9YlxESN0/KNm/X2Xr9IiI=;
        b=VuyVSwUiGtWgUAPm3At5Hzmg8ylrtzaAp8v3U5vtfbLcM3lAS9wznsJCtET/IxNDhv
         RYEOBbJ+27B/jvHD/a/fAVODVa8jE/IlkEDsveCtS7iArn494v5QENKA7oJQmlgZg6Vz
         kSV9/mVw4TWwg1kR7/hJW2XPXcuFaBtrXPhqI+zIelUKgHWeS4d7O1iKw1glza1rhPVP
         mMZWoS2u221FZJoJIVncWnjfRqw6EThdx2ZdavvcCke+phb5JLjLzttyY05uvHtEZDBQ
         dntzlsqBEMobEpyoISzuaNu70leeySM9a4uPm3iMx55wonh2HadhH9W3tnvwzU13OWKX
         HGqg==
X-Gm-Message-State: AOJu0Yym0t5ngBHWcQWLU6XxqBOKb8Bq6YcKH5Vaa3O4dCuhkFpfwhyj
	dNOKGsTmqB4TAqv7o7dVlYeK8AkQwp27n1Lv5sZQL7b6iCh7ubaFzsHvpN3iJSY=
X-Gm-Gg: ASbGnctKQkBJ0NFLiKv7maIJOIGXswLCOu9phUdET4UoYmnUFLyDT6tVBc6hXITAJC/
	FRPouJ8UwFHh6R/a6gNJiI9ighH4gMOB0TPiePYdqKIOde0MavVwDv9VyYImpOMQbGdrcRV3Zc4
	2TvmmyYUAL2SwDDEsoe03DVRYw9XxiUiBcOP25Cc8Jz+gTelHi3WAU7gFFF5hX4GGvTo7UInxOs
	I+N2FdWhqQKx6DXLCj8nOjewHIqb242qlht/9fi3m/5Ov5DkxG5SdHGSSeTwcYJ38DGX7rUgzRZ
	5d/zbbIN0odjCNLibrCRSqvyed6bmKz9hd4Q2RPMeyJzJSV77IXn4y0L9zfY8e7IS/S/cr1fS98
	k/Elc4g==
X-Google-Smtp-Source: AGHT+IHZrq54uEFQzeL1xtAMCrpjIC7a54Qur7ivGYIpbB0O3uYaEGQp2wT31hPbtyo5KyOcvPuHpQ==
X-Received: by 2002:a05:600c:4690:b0:431:2b66:44f7 with SMTP id 5b1f17b1804b1-433ce4d4c6emr44768765e9.31.1732312985943;
        Fri, 22 Nov 2024 14:03:05 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fb36612sm3426949f8f.59.2024.11.22.14.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 14:03:05 -0800 (PST)
Message-ID: <3e3849afe0f279848078158382596f0c11d8d149.camel@suse.com>
Subject: Re: [PATCH v2 10/13] libmultipath: move dm_rename__ before
 rename_partmap
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 22 Nov 2024 23:03:04 +0100
In-Reply-To: <20241122211133.718861-11-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
	 <20241122211133.718861-11-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-11-22 at 16:11 -0500, Benjamin Marzinski wrote:
> No functional changes.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I suggest squashing this into the previous patch.

Martin

