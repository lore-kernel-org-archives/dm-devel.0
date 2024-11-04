Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6962F1C302C
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730739333; cv=none; b=QeAAHXWtzjmYIdoZJ8B2P3jnRbbvtp79KJ5iz7XB2O6/sEbS3PQRpfpFsj1tUOeIkZIm+oKlu4keCjcpTSwbrSkWraslkOoyMOgQf95+Ts3XrUz0robosKvfHm8PCqxsTbHXDJ+WOMEXVuivN3w6mqQ2uTQAOK36UP8+kFqDUEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730739333; c=relaxed/simple;
	bh=izds6rNXRJRgMBy5yY/E6EmVjB9/+JpXsWHh1BXpDI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ewvauWB5RAQ69ysviYcteGW0VutRiFElxS8ZXQ92LrH3yyFhYkKJX3MZvfOjldiNXSBCkatvWLC7y/tJosw85VMUmDFIjBGn1UDjJlcKOs0/9EJIczXdOVxlM2CNZASh3GZ2usyNQg4Ys3K2n5LlpGJ6iboBdEbn1R+38o0HViA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bso7V0r6; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bso7V0r6"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-37d5689eea8so2581535f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 04 Nov 2024 08:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730739331; x=1731344131; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jr73ezgvuUs5UgQIJgHI4pt6G1Ok43c2Na/LruXFLMQ=;
        b=Bso7V0r67CR3GxtfxS3WhV2dwepj69G48jFILLsaW5jCNfwSnpbJOITqU1lyElc9EQ
         ww+XbHbhrXxcMEo7qF1FKxPuXdripu3il4a80k20Hb/uVeBdCh3ZF2/QvgniaiXQMl9J
         CrBxXeq8qW4u1ytO/QEnfbDigr9JBrT6eoX2Cl6JkdCJqePctbM2KurtmOqL9Rzcpal6
         VZNKSfuQ7nPbgCtmATf2RFqh8IWrL6XhK3nbu6PMTUybvCJyehY843RexTZeSwYA+3XI
         cb0nUw82i2PmxF3QyGZ3skp16FQhpBxPcaLn6dBavOUeXxCHH5AZiRKu7mAjayOq0D+8
         GriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730739331; x=1731344131;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jr73ezgvuUs5UgQIJgHI4pt6G1Ok43c2Na/LruXFLMQ=;
        b=LG8V7/X1CJwQe4yIC1QPwGGIG88Csl0y1N+K/Gp8AeGDfn/axymd388jR7bLZXrP/2
         Q3yVQO51mNLDYVPHJHo6rSLnsDax231CHnWf6Ft3CwmDNpamrgtywuXuP/g/YlW820cU
         8ZQVyn5uyqqjn5bexRIy8o+uT/FF3gyj/PGRFcqWsUvRKxQyg76eVLO1hINQU/GSrtM9
         +Eu0WA2eNaIahZpG7P+E1v9oDxlSeYcpZzPBLzrmH2Mf8UWkFqt+UUwqA5e3wJm3t7Cu
         UmC0OUnqiiAKeKxXE1FOwuUBeNtbW+7xCtEWUXWZ7Zrq0X4KABzItIMYsiLjVuI+bVzu
         PaYQ==
X-Gm-Message-State: AOJu0YzZpxGhWnzJecFRGu5MkpWHwRTPq2OHLPquj1h8xR5jTbI7NkLf
	WmBsHLXiCZGycLPDJgZobYILf1TMLTDl8l0v9xgdLb8zWyH+H9i/
X-Google-Smtp-Source: AGHT+IHYtZA8kAnzBJnmFgcBpORq2xJhVZYnBu/uwfeAtRkL3Qm4rkw3Pu1SRtlJaSXA0RngEOmUVw==
X-Received: by 2002:a5d:4bc4:0:b0:37d:528d:b8ad with SMTP id ffacd0b85a97d-380610f830cmr24014751f8f.6.1730739330560;
        Mon, 04 Nov 2024 08:55:30 -0800 (PST)
Received: from ?IPV6:2a03:a900:1000:7e9:403e:7c8b:351b:f333? ([2a03:a900:1000:7e9:403e:7c8b:351b:f333])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c113e5cbsm13674300f8f.80.2024.11.04.08.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 08:55:30 -0800 (PST)
Message-ID: <04e0c494-a04d-49e1-861d-77738b799c91@gmail.com>
Date: Mon, 4 Nov 2024 17:55:28 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] 11-dm-mpath.rules.in: set .DM_NOSCAN if
 MPATH_UNCHANGED is set
To: Martin Wilck <mwilck@suse.com>, Zdenek Kabelac <zkabelac@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <20241103224349.42582-1-mwilck@suse.com>
 <20241103224349.42582-6-mwilck@suse.com>
 <3edf87cf-a698-4415-9fd0-b4f7eb40bd61@redhat.com>
 <753040e488750a3fcd3b911b741173bace4c0cb3.camel@suse.com>
Content-Language: en-US, cs
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <753040e488750a3fcd3b911b741173bace4c0cb3.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dne 04. 11. 24 v 16:03 Martin Wilck napsal(a):
> On Mon, 2024-11-04 at 15:00 +0100, Zdenek Kabelac wrote:
>> Dne 03. 11. 24 v 23:43 Martin Wilck napsal(a):
>>> When multipath reloads a device or fails or restores a path, the
>>> udev
>>> rules disable LVM scanning, but since .DM_NOSCAN isn't set, blkid
>>> is
>>> still run on the device. When multipath devices that are set to
>>> queue_if_no_path lose all their paths at close to the same time,
>>> udev
> But note that multipath is overloading the .DM_NOSCAN flag here to tell
> higher layers that blkid shouldn't be run in the first place if a
> multipath map is in a certain state (we're reusing this flag, which was
> originally created for LVM, in a similar but not identical case where
> we want the blkid call to be skipped).
> 
> Unlike LVM, multipath has no way to set a UUID with special properties,
> because multipath doesn't own any meta data on disk. In the case of
> multipath, the .DM_NOSCAN property can, and will, change for a map
> while its UUID remains constant. That's what this patch is about.

Hi

It's been more about the idea - that you can try to communicate some
protocol logic for 'libblkid' in some way - that will automatically
make sure blkid will not try to open device in these unwanted cases.

It could be possibly something like:

if DM device is  'mpath' &&  file  /run/mpath/do_not_open_MPATH_UUID exists
the this will be makeing libblkid think it's a device it should not
be opened.

Then mpath tool is just manages present of this file - so this way you
do not rely on works of any udev flag.

Although the case here can be different if the device as such is supposed to 
be a udev visible volume - as the  blkid skipping might make the volume just 
'invisible' as whole.

Regards

Zdenek

