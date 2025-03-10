Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574EA22D4D4
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 14:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741617343; cv=none; b=TPOkPiyKZRV+/EGtbub4GiInBp+eStTCHyJ8Rh8ikM5BccsoV6ThE+nGb75F/PnTuUu4Y2PkC1ylt4POE5IoyfdIDVcZW20iEwXF1JhbLA8KxI+tTGcDS7wL1frYIlqCnVZmL635C5hJ931tHwOCPg9TRFC/qez6T8MIMrFFG74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741617343; c=relaxed/simple;
	bh=Dg0qjDmpHN5xtsPXTCsYTPeD40Hdl345LQv5Bn69Tdw=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:References:
	 In-Reply-To:Content-Type; b=UXujPnfyNdlur7FaMzGO1lkArUIoCky23zhWEjryPOxlIXKd0id3jV/bcziH5e2V9Xjc2k3a/DRpmCuC/7IBQQk1IlSV7exiWewbdj6z7M0YZariq0tNR6ZLz6M44dr9S7V+3YrRoEwKH8fqdrMP4KpByhXNCWXMEHHQfpkWV6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fZ2BRIhc; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fZ2BRIhc"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-abbb12bea54so796808466b.0
        for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 07:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741617340; x=1742222140; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:user-agent:mime-version:date:message-id:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rqGBkEMi5Xm7guC42j0iH05fymC0N83rCNQIDAeFErc=;
        b=fZ2BRIhc0s8Ef/GBIh8oDV6VtemIFsZZvwkfX4hFAIAiPU1iHSUOpF1X0ceby2bstT
         xlSMP6u+Pg11vcZmFSZWR+e8IfpTaoowjJc68YUi3+RCXS57uQD/eGcV/WAexPHp40Ux
         9Cufam/OVp+vbSXTeT39p28jQhs0QOfoJ+4+kxfuS9XMxmJ6ESjrr+sEQnp7FlJrdi9+
         2DJObyZpA/p8CQ9IuQWawLYGpFaFHZME77h2gyOMSVqP4oAwqt8rL/HS1FUuQUmO2U8h
         NWe+5k3kyWDAgCol2S4mIQr1q9tL/446SMgdnLdyB+2HYxEB4XMScfn1FYozJr11DeOm
         ycrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741617340; x=1742222140;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rqGBkEMi5Xm7guC42j0iH05fymC0N83rCNQIDAeFErc=;
        b=aVy/G7/wn0jsxPqaCnI9evVFyMjkt/WaXImzPQJDpe/TT4pAp+59VUwu3iewLHjQ5R
         AkWeWbKyN+T9Nyd2vX5XODDCCJL2s6D4OVN4BeM9zzA/TLW0zahp5Qfa+SqvhOVSKpq0
         APIBRgqoax0yzpb1uTY0lolPhnEHLWncW5Xht2Hn6QFjLdn2k3dhrLEhVCYiYaNF7sqM
         dWWDxOUt1x8uSv4Owpd0224dreT7iNNhg8oT6lVH52uiGCT69RBEbnM+qd/6nggD+IwO
         ZOvRbgGDZQEwR2MLYvtWaF9EMPS0w/jUBCUxbbnoq2SXsSCRYZyLWPBGNeHcfmxI7FVn
         ogNw==
X-Forwarded-Encrypted: i=1; AJvYcCWK1pVDJIZgOn2BBNE8Is2d1/rYmx0lHOn2TnaQ9D6qz5EH6Hlx70ptvue3zVBZj1fPzDLHdoQ6pg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxoAHAgX34MPSay0JxQf7H4DNAx2+EWvJl1HQmZlMtAWpR9aR/7
	Rkjy0Yvn7XvObDB853RYHNdvy3fLYBVqkicjEDuHrgj5cZFC09aVVennRV/b
X-Gm-Gg: ASbGncunZda10SM4bWzUr+y5i3rnZRo00JT6eQDRWPDLD54ofH9UVaBQUkAS2SY6FKW
	WfzlA1PGlFcaC/kmrirVk2yduZwNICQzmr3bzRweTW1lkAB69tYM1CEYMKwdNl7QbLzOqOgUjq9
	D4gyOsP8PWZgRs41XlGtF4Al7OVvqtyQpwfeyMvSWYc8knMXfXjCTkCHr+L0Ct60flGsuEpLW1Y
	UD+QkR/53WnVkE7X+ExVJTsLXCz6Dxb8tjjqmWfQn0oX4JmoxZ2XG0Td303DbLGPg1F6b4J9yBr
	2G7qCkCkvtfxbtpJezCW71bbHQTMYbKZWTzk9YMyeVUhX+mrVL5eo31hPupBPcKgzQF4NnDyudx
	ZP23q987JxKTwMsAhGM2KseGb8Vw=
X-Google-Smtp-Source: AGHT+IHhf1Al+kP+WWx3NFsoZlYEdTgBvIAomSXwzEf4z0xq6TOLNzbjpihGllKurHdnXBW/Cowzhg==
X-Received: by 2002:a17:907:1b05:b0:ac2:8a4:b9db with SMTP id a640c23a62f3a-ac2525f4065mr1351665366b.16.1741617339295;
        Mon, 10 Mar 2025 07:35:39 -0700 (PDT)
Received: from ?IPV6:2a03:a900:1000:7e9:403e:7c8b:351b:f333? ([2a03:a900:1000:7e9:403e:7c8b:351b:f333])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2a40aa5fcsm159140966b.139.2025.03.10.07.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 07:35:38 -0700 (PDT)
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
X-Google-Original-From: Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <4dd35799-f43b-461a-a3c4-5cec8ff22006@redhat.com>
Date: Mon, 10 Mar 2025 15:35:36 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Allowed characters in strings passed to/from device-mapper APIs
To: Zack Weinberg <zack@owlfolio.org>, dm-devel@lists.linux.dev
References: <0211b995-d844-4a0d-a02f-2f9bd2a4215e@app.fastmail.com>
Content-Language: en-US, cs
In-Reply-To: <0211b995-d844-4a0d-a02f-2f9bd2a4215e@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dne 09. 03. 25 v 17:00 Zack Weinberg napsal(a):
> I am developing a device-mapper client library in Rust.  The language is
> relevant here because Rust's standard library makes a strong distinction
> between strings that are known to be encoded in UTF-8 and strings whose
> encoding is not known (`str` vs `OsStr`), with the latter being awkward
> to use compared to the former.
> 
> The device-mapper ioctls use a lot of strings, and it's not clear
> to me from either the documentation or the kernel's source code
> what expectations the *kernel* has of the character encoding of these
> strings.  I don't expect the kernel to care about UTF-8 versus
> ISO-8859-n or whatever, but it is plausible to me that at least some
> of the strings used in device-mapper ioctls can be expected always to
> be ASCII, in which case I can safely use `str` for them on the library
> side and it'll be more ergonomic for end users.

Hi

While you could surely interface kernel directly through ioctl(),
you should probably base your tool around libdevmapper as this library
is there to solve version differences or possible kernel or udev
issue that pops up here and there -  if you will go your own path,
you will need to reimplement these things within Rust - which
might potentially be problematic - as we are solving i.e. udev trouble
to be working only within our 'small world' across different version of kernel 
and udev version installed on the system.

> 
> There are, I think, four different kinds of strings used in device-
> mapper ioctls: target names, device names and UUIDs, table parameters,
> and target messages.  For each of these, I would like to ask:

Device name and UUID are always plain 7bit ASCII.
But there is a catch in udev process - as udev has even further limited char 
subset usable for device names - libdevmapper uses name mangling for those.

Again - you are free to reimplement your Rust version - but eventually this 
may lead to a completely different set of udev rules needed for management of 
Rust devices -  as libdevmapper is free to 'change' DM udev rules as long as 
we are 'internally' consistent - as these rules are seen as 'internal' 
property for DM world.

Regards

Zdenek

