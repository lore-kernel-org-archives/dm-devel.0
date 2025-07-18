Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C092046B3
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 20:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752872097; cv=none; b=oRSG7z5Y+JP7C5hhILih+RLgIuvoNAyJeba6cnnzHGApK8OIx2G+SnU+OANJV3CHxJV4YKyCJ+TPCKgzBHNz2lPyR2WSHndKEkYFaoG8lY3Ir24caNrzZxVBrm5K2DQWPgrYNMKcBHLzDqfWdgCSB1+m1qdJqTNEpzJS39+mVKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752872097; c=relaxed/simple;
	bh=/v9WWF6F6utjgz9JGBDPXJxOIe4C/8Qw9JemRuRmy20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g1RWKP3Li/WvkG5CD/vIIjN8HEfxrIY/gFmrG1DEYbWdMgh372dF1nwDcuvYtvLROIQQxvVabN0RZmpp+VVr5TAjJGvXoYfGISrGxhacmRzSG8QNTLA2cR912QlxKr0Y3V7m+o0kwzNfKypYCseH1vIWBKMGwVOkNa15q/WJSJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j3Pu9HIB; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j3Pu9HIB"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a52878d37aso288020f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 13:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752872094; x=1753476894; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DIjz4BPZJqOIM9QQ4fdBf3Y2eXQwrnGfHoI2Y40n68s=;
        b=j3Pu9HIBLHmz11onyzZ3xk04U97HCaV+INW2ate1ahId3K4zL/Sf7TtaGzmoi0yjuV
         KE9d9jMxkFip18mcYPJs+HodZSaFPmDFhq5b/W5VYkpXxsZ53qOBRPiFFHWzG5K4VFNd
         fZ866hJxCFQyFV6mK/er+kJ62hCE44LONZVq6XifHhpXxmWqjEhRgd6FmfAlUyZwlosP
         UcteIN8vJfS+izCBg2Xek+I2uY2isczqjLvIRUOsMp4UCH7HGaIRzcHxNwwYajjUswtJ
         2xE3soZEsbymp2RxXO5VvG/Z1z5num1wkdLjFxGIYmtb3GHhRMeifxx0TxXrDn2kuSZ2
         SkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752872094; x=1753476894;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DIjz4BPZJqOIM9QQ4fdBf3Y2eXQwrnGfHoI2Y40n68s=;
        b=vuBcBLG/r86/rV6kyHfQUVKqz205N0YyNmvF2ta1X6bH64YXAe9PDjQdsOEKiCuEY/
         l7eohxm+EVWp/fLk6Qu0liOuI7sDSZxk+t7l+Z5PbdZ3oXEhSV99zVTKtHkgUVEDzhJy
         WZHUWR53zUxwoNYZq/6L803021t9iuHQbAyTGqxxa+u0ZxKMMS828FuAcGE+NQJS8m7B
         G1ahziS0V9sEyZ9XAPsqPnD2IDNZNaxJiq+Q5u0kJ/gJE7jWycrwOcK6AZNvsHXlf5Or
         KYZZD7O9TVDPoPhZ0btpZDZojBk4IuOlpETHlXFK3kuc/nG0QNZv0b4hMfSu3gTHwSpw
         PX+w==
X-Forwarded-Encrypted: i=1; AJvYcCUVcR7zI80exjzoNhhKnWxjz4rioreOOYiaS4igcwMrlAbgNxfCKLv/vgL5g1TLiUBhFZ94aw5dQg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyIogNwdixt2TSq2qScj6wQYVTg7Dkd01Yu0gZeUjHGaFPIoWtO
	mwdJTzmkB4BPevE4VVPKia8VZnECvjsMTYV7rKBCJxiwp7szhgG3Ivc=
X-Gm-Gg: ASbGncu4/t46tXAB+w45wQS7NgS8fwfI6TuhAJWP2TdJ3YtjI5rYgtehXGG8ST1R7Rs
	2UzAA6KT0uCCQWMysy4spaFzreWnM4lz/bYXM0W3XK15N1j3AZFgc175ZFqb3BkPh/DuzqvxF9E
	q6++duJ0wJru3klAe2kyEKHsaKocWFpIQFkdw4Uhw0sI97+ioF53tWFpo8gAiwFmegcEcCD6FwO
	QEqUK/cPAv6eJJWrpnI06PBJ+czqvIHEZ/ONUywhpjFXOJec4A3V1+ZmdXIgKarSZhJlceSrdw4
	E8/vaMBAXD+b4kUxVHAzKlAjujkJ8IUGeuoBXSbpflmuoy7Hh3/joYlpZNCLQ4Kf3m3SgHSl8kF
	5s2tSdr6sI0GQjFGOOtgczeHr2FQurEUZptzDXxBEbOCjkRW7ynX9oM6bW4cvdB2xgw==
X-Google-Smtp-Source: AGHT+IFjtNzhZVpFDZWJ7RTeQG+bUKsioxGzYlerosV0A+WYUA92JBe3a3yqDV9rsPpz0H4sieMqNA==
X-Received: by 2002:a05:600c:a218:b0:43b:c825:6cde with SMTP id 5b1f17b1804b1-4562e4fd51dmr30617885e9.3.1752872093235;
        Fri, 18 Jul 2025 13:54:53 -0700 (PDT)
Received: from localhost (179.red-80-39-133.dynamicip.rima-tde.net. [80.39.133.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca31394sm2840353f8f.37.2025.07.18.13.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 13:54:51 -0700 (PDT)
Message-ID: <2c83b76c-46cc-4632-a930-d023c7d3d7b0@gmail.com>
Date: Fri, 18 Jul 2025 22:54:50 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] multipath-tools: fix default blacklist of s390 devices
To: Stefan Haberland <sth@linux.ibm.com>
Cc: Nigel Hislop <hislop_nigel@emc.com>,
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Hannes Reinecke <hare@suse.de>,
 Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 S390-ML <linux-s390@vger.kernel.org>, DM-DEVEL-ML
 <dm-devel@lists.linux.dev>, Nigel Hislop <hislop_nigel@dell.com>
References: <20250712201454.215404-1-xose.vazquez@gmail.com>
 <76bde3f1-0f06-46fc-8e0a-729e6629024c@gmail.com>
 <d5e08375-211d-405b-9a00-f44c857cedac@linux.ibm.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <d5e08375-211d-405b-9a00-f44c857cedac@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/14/25 2:38 PM, Stefan Haberland wrote:

>> Is PAV really supported on FBA devices ???
>> And other than 3390 and 3380(3390 model 2/3 in track-compatibility mode) ECKD types ?
> 
> Currently there is no support in the driver for PAV with FBA devices.
> But the devices itself are capable of PAV.

If there is no PAV support for FBA devices on Linux, and it looks like it won't be
implemented even in the distant future. The detection code, and the device, could
be deleted from multipath-tools:
https://github.com/opensvc/multipath-tools/blob/de16cf82c5263fc148118be56ebf44c8f0ee60b8/libmultipath/hwtable.c#L688-L697
https://github.com/opensvc/multipath-tools/blob/de16cf82c5263fc148118be56ebf44c8f0ee60b8/libmultipath/discovery.c#L1674-L1685

Is PAV supported on 9343/9345 (cutype/devtype) ECKD devices?


Thanks.
