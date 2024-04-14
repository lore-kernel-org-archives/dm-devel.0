Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF531EB2B
	for <dm-devel@lists.linux.dev>; Sun, 14 Apr 2024 15:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713109441; cv=none; b=lIGcAiE2P2J/0hi9YypSw8f6mEF6AEOyYoCtcuUlSj2iPjNNtGMPdMhnSjD5yc3YurfWm5+EMukR+pelwDn+5zYcsk4TvFXsyl3OKQNE6trfCcQJuk3x2KUFduhH23ZqfD0BSR2HV8gSjR7bgiAuzgvqXU+5/1CiBZP2D4iHoCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713109441; c=relaxed/simple;
	bh=rM/zZ19SsomcGL4Q22Ri2+/vmBBE8hSCxOLnkIrVZV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=hVGmDcGk5ynrQw4/lrSQ1v7PMufPgr95isszQjXMF4zi0GkQb8KBxitkWLL+07duj57sxWM/gmhW1LOPhKHOouwfoO0dyMi97coo4G7+zwTea0/5XFl76+hoOdZp4dvGiqsD4Il5fJSgwG7lIjiB7UP1qp+0Hh3/Mi8PC0xnqc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AeA9i+k0; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AeA9i+k0"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a5224dfa9adso380690966b.0
        for <dm-devel@lists.linux.dev>; Sun, 14 Apr 2024 08:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713109438; x=1713714238; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:cc
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qeal0b8xcQSYS7bxWMu2Wl0VNhf2UUEMGzukE/4gris=;
        b=AeA9i+k0Xh3RA2YZDzat908fW2hIYbymkkFqyFI0tSsR2eR+qEg7RfhfhMq9iStr7z
         eOa8XiKPJ+v/GnNTXj/5IBRom0JSWdp7qwAnX/bVXAzFKyeYQYrIwpwnCUAcbldE4OK0
         2M3uGfj7FQ+E0LLX/vW9OlIkCL6AbWUPGlbIIICyRYKitxxFPjrLF8jEAUuCj4DkT6P5
         7JaZzCUfpHXo4DewoiZD4GY+/OOx1/0Zk4+dNBFfmTMExRd6QucYlOoh1rdYaw/HCrXa
         EyP1GKICn553+o0RSVESYSKKvXU3i2AdxP/gDtxlx7ED152ei85Aq4Z5NoYOtI0J8cve
         r34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713109438; x=1713714238;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:cc
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qeal0b8xcQSYS7bxWMu2Wl0VNhf2UUEMGzukE/4gris=;
        b=mFcH/5iQmph1Tz2ASA9jMa6K9B+61RYER8AXHnobJrOBKaQKhndnnRE6sEW8Alzi/W
         JEQypuuaCBnqr3oFcdgr/3VoGqlxTB+bldBXnc7afmlVqBYIT5N7v5Kt+9H3ztsg3kwL
         MVCsIRR7Ml7tf3UlaoQayeKibSNh1dwgdkxU66Mh9SnDomlD9O+Kacu+HU5gb9Ks9bvV
         2ILdUby9W5Nos/Me3pQ50eYueUTBpiPq2UB7QdcHH3y1FR1wasFEgjKLzKMVQZ5c5GUU
         VRmDAHfXXa3S5wwG1TRyG2iReIfs1AUe4hPd/Soo1BYlxx0fYNkoFCyDik3MT+8MOtl5
         FRoQ==
X-Gm-Message-State: AOJu0YxNp/9o1Ispv+xHZBrNrqrzZugPaeRshjMgI+6Qo8Tg3Ys1beMs
	cyQtTUVdyWK4WbMPGwmuuSbybZQHbpNMFH+RpaZaUOOqAZKOnMOZ
X-Google-Smtp-Source: AGHT+IEGCR2A0TEt7r0Gk9m7GvY98tz8M2DFoxG2MKT/vG94bCjV2loqAUmc+V6HDB9XYphDXkRTJA==
X-Received: by 2002:a17:906:eca8:b0:a52:6b76:c722 with SMTP id qh8-20020a170906eca800b00a526b76c722mr218907ejb.9.1713109437702;
        Sun, 14 Apr 2024 08:43:57 -0700 (PDT)
Received: from [192.168.2.30] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id l21-20020a1709061c5500b00a473a1fe089sm4317187ejg.1.2024.04.14.08.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Apr 2024 08:43:57 -0700 (PDT)
Message-ID: <acd54b09-c5b9-4548-a24f-95c503e20139@gmail.com>
Date: Sun, 14 Apr 2024 17:43:56 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm-integrity: 4k devices report 512b discard alignment
To: Eric Wheeler <linux-integrity@lists.ewheeler.net>,
 linux-integrity@vger.kernel.org
References: <447e2027-bfe2-9c21-a5ad-291e16b78f28@ewheeler.net>
Content-Language: en-US
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 Mikulas Patocka <mpatocka@redhat.com>
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <447e2027-bfe2-9c21-a5ad-291e16b78f28@ewheeler.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/24 3:05 AM, Eric Wheeler wrote:
> Hello all,
> 
> I'm not sure if this is a bug or a feature, so thought I'd report it.
> These are all for Linux 6.6.26:
> 
> If you start with a 512-byte backing device (logical and physical):
>    # blockdev --getss --getpbsz  /dev/nvme9n9
>    512
>    512

Hi,

this looks wrong. But you should send it to dm-devel list (added to cc) ...

Maybe also add lsblk -D (and lsblk -t for block sizes)
(where you can see inherited values for all layers).

And I see similar problem in dm-crypt with 4k sector but 512B discard granularity
(on 6.8.4 - LUKS with forced 4k sector and alllow_discards).

What is interesting, for current Linus' tree I see discard granularity 0 (?), but
with Mike's DM for-next (with use queue_limits_set fixes) it correctly shows 4k.

(Ditto for your integrity case. So perhaps linux-next is fixed.)

Milan



> 
> then format+open with 4k sectors:
>    # integritysetup format -s 4096 /dev/nvme9n9
>    # integritysetup open /dev/nvme9n9 integrity-nvme9n9
> 
> and find the dm-X device:
>    # ls -l /dev/mapper/integrity-nvme9n9
>    lrwxrwxrwx. 1 root root 9 Apr 13 17:09 /dev/mapper/integrity-nvme9n9 -> ../dm-189
> 
> then check it's discard_granularity, it shows 512:
>    # tail /sys/block/dm-189/queue/discard_*
>    ==> /sys/block/dm-189/queue/discard_granularity <==
>    512
> 
> The sector size is 4k, so supporting unaligned discards seems at least
> strange, if not invalid, and dmesg complains too:
>    # blockdev --getss /dev/mapper/integrity-nvme9n9
>    4096
> 
> Relatedly, should the physical size of an integrity volume "properly"
> report 512 to match the backing device, or is 4k correct in this case?
> Presently it reports 4k:
>    # blockdev --getpbsz /dev/mapper/integrity-nvme2n1
>    4096
> 
> Finally, this is what made me go investiage: when you issue `blkdiscard`
> on the integrity volume:
>    # blkdiscard /dev/mapper/integrity-nvme9n9
> 
> it causes dmesg spews the following:
> [ 2508.364637] device-mapper: integrity: Bio not aligned on 8 sectors: 0x74ff8000, 0x7f0f
> [ 2508.364856] device-mapper: integrity: Bio not aligned on 8 sectors: 0x74ffff16, 0xea
> [ 2508.365070] device-mapper: integrity: Bio not aligned on 8 sectors: 0x757fff0e, 0x7
> [ 2508.365973] device-mapper: integrity: Bio not aligned on 8 sectors: 0x757f8000, 0x7f0e
> 
> What do you think?
> 
> 
> --
> Eric Wheeler

