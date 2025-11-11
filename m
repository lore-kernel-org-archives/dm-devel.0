Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1402F12BA
	for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 21:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762898241; cv=none; b=YwZPDovrqJ+gtGsC9DyfQMT2TEcHFouhY+BiqolYlpug6AxAZrn6MBhJz4M4QF+Aa5HEkuRCGXRuZ5vd+GIW3TvaPw7EHbAGf7eBZTZUODokVxiZgPrUAePpaQRc7/DZSCOqsBMu6iSv30fu+jCEVP/M/9iLdulDHYeYLlfRk8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762898241; c=relaxed/simple;
	bh=KXQ6fPHp84H+wjN5v+LoEcPvlIqxGR8UbHX7W+82ELg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j/7h1nd3rwONzgXO5xTSHMs6J61E1+eXYhfAPd5ZLoUU1MAD3BGK3+rzXposRK/+7Q+WES5aaTSnHXLeVS5BnlrcWZma7/E+KCQsoJG2zI2O/WsAEH5aIIkiPPznscqveYBHbKgS0kR/GtwAWDDflDBUMHRimq3R9XepblhE0sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YdZzp9a9; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YdZzp9a9"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so251276a12.0
        for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 13:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762898237; x=1763503037; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KXQ6fPHp84H+wjN5v+LoEcPvlIqxGR8UbHX7W+82ELg=;
        b=YdZzp9a9Yi3WU9HD3sbfTbWO6Q8k9VLSS1HrTtI4KOvrREL2OBpW59vYRDMTTE+Kg4
         2dXxMJrvxH3YFh7BeLeEu6mWCQWykF3AQYRbuTA64/YzaNwUQzs3JTQ42BSLmCkkq19n
         nXO7ugj7uas7kCUQWMyK1Xmqf6O2hqnkUW6JBoe0tGFuveCKZqkTFay3r9O071+GybSY
         IOGZ64ZhkGhyUQgMbi5VWBfItRfFMl9KH0a6tEw9B/VuLfaA6P6Ik1HeiciL9PgtPPMF
         e/LyaZ6f8GZQJALhKnxOEhSh3eHlyppA32p1kIdh3t4kyFa++GiiJNV8Ar4Mu6V3MIDg
         8S3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762898237; x=1763503037;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KXQ6fPHp84H+wjN5v+LoEcPvlIqxGR8UbHX7W+82ELg=;
        b=X9uA6eoQUZ6Iauf48cYrfIJbMPOJS9ZgPMbNxmbbb5tHY5HCAvsufx66+jpq+D5QCa
         XQxnHMRMG5hNPaqTRqyxMJuEnsigA9W32MFZf84gjjkGn0Cc95EZdrzKuEZL4nieZkU1
         mBXEIjwgd/SQ96GA54TEoDV6f1VwpZ0EismwfSehErCfsNo1kds5fTt3pJk+nHdLMh9M
         uyTum1RJem/yC1rxpelezZXHhbl394B1WI3WW89fDKHojU9bdhLi/UoNwcD44WqVFsbN
         rc1OqXfZr65X3GFSPfyWdEfH65BzISBUQIxmI7LR7cJoDyo/EI6+BSYk6OmCY0xyPkjp
         n4yg==
X-Gm-Message-State: AOJu0YxBS1ULhJr1v54wOY+1EQIEmeSS4v4iWvBGtGvXXsVtfJ/vwY0g
	Wa020yeS0qQQsvPERXhUs6p2Wb88MWmr66+puK7C0cXUYqqJBwlvIiMPYRAzfzZAo4ffGRAyXg8
	uNSZR
X-Gm-Gg: ASbGncsCiIsKAgJe+0D/S6pKZRPBpwHvlTnLWcdL+7MJRqOhlVlkUxAZrZWoP2+yQv5
	DpJgfw2M2QifEg9Ox/5T+/rkNwzTQCp3sYIXZReaLA6fajIgo5Huu/YbOK2QfVGrW/61cAyaUOB
	6MNKP8vbNIvYWj6HAoD21VkMBJVLkHAUuo7klCaFmOhhOdnOq9LeqD30hrmk/KR0c3YcQgCYmAb
	EzhQgD4A5ldMoTGo8mFvabBqZpSh96ArCU67LYWEg/Zyse3w3j4tTLvM+xo9kOBDoKIH+RWGycG
	MLTlDbIzOV+VBMNEK1/cd5fvsOE7y2YPZz/HxkSWqUP5y+vBpptbvURbJXghZ5Z6yZ6zAoE6Nia
	mAMnnTj/mOsjF9FbTedQTHifLz1rmQ8BNouY7HDQm0KM1pH8kvKdjLcCh2mQTHsQbbWUTCu0/HG
	VXN3EVvhb3TuFmTOev7WhzPKVn+TL71PAKzluL8NMtS6hHmWh1jkQ7ERthlzqJbjZXTobSQcFOy
	qAuaKkkRhENEdapSo5JzCdz9EEIahyOLScayWVipy690XM=
X-Google-Smtp-Source: AGHT+IHhE1ZJLteOhYVcZgJunqSFyM6S72y+BTdEli8g4WQR/e2FE7IMc09LwK1Yvfb5IRnsJbc3sA==
X-Received: by 2002:a17:907:2daa:b0:b3f:cc6d:e0a8 with SMTP id a640c23a62f3a-b7331980d22mr78058066b.17.1762898237399;
        Tue, 11 Nov 2025 13:57:17 -0800 (PST)
Received: from ?IPv6:2003:f9:7f04:900:e894:a50a:fc99:6ee7? (p200300f97f040900e894a50afc996ee7.dip0.t-ipconnect.de. [2003:f9:7f04:900:e894:a50a:fc99:6ee7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bdbcea8csm1429954366b.8.2025.11.11.13.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 13:57:17 -0800 (PST)
Message-ID: <fd236c198cb3a2590aaf95bb1c13fce68c7fdfea.camel@suse.com>
Subject: Re: [PATCH v2] mpathpersist: Fix REPORT CAPABILITIES output
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 11 Nov 2025 22:57:16 +0100
In-Reply-To: <20251111205253.629044-1-bmarzins@redhat.com>
References: <20251111205253.629044-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-11-11 at 15:52 -0500, Benjamin Marzinski wrote:
> mpathpersist was incorrectly parsing the REPORT CAPABILITES service
> action output. In reality, the type mask is two bytes where the type
> information is stored in bits 7, 6, 5, 3, & 1 (0xea) of the first
> byte
> and bit 0 (0x01) of the second byte. libmpathpersist was treating
> these
> two bytes as a big endian 16 bit number, but mpathpersist was looking
> for bits in that number as if it was little endian number.
>=20
> Ideally, libmpathpersist would treat prin_capdescr.pr_type_mask as
> two bytes, like it does for the flags. But we already expose this
> as a 16 bit number, where we treated the input bytes as a big endian
> number. There's no great reason to mess with the libmpathpersist API,
> when we can just make mpathpersist treat this data like
> libmpathpersist
> provides it. So, fix mpathpersist to print the data out correctly.
>=20
> Additionally, instead of printing a 1 or a 0 to indicate if a type
> was
> supported or not, it was printing the value of the type flag. Also,
> Persist Through Power Loss Capable (PTPL_C) was being reported if any
> bit in flags[0] was set. Fix these as well. Reformat all of the
> capability printing lines, since it is less confusing than only
> reformatting some of them.
>=20
> Fixes: ae4e8a6 ("mpathpersist: Add new utility for managing
> persistent reservation on dm multipath device")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
