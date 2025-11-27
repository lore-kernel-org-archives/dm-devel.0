Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61022D877C
	for <dm-devel@lists.linux.dev>; Thu, 27 Nov 2025 07:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764230358; cv=none; b=cdIpJCmLIYiL+WpviY2BIPdHavSp28hTblCwLca/fGR8+fuSKPAznk7/JSeByJD2KqFxaUkRY6I7HLtXOSRGPpJbQLgA57bnWS62cXCCaBhkT/ZxEiNKFatPdm8M78xQyiLf5hhnMm1MQj5cCdiHoAj2WxnGXtCS9/4pavyySwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764230358; c=relaxed/simple;
	bh=8e9pgmMtexm38fPOLh878dOcYTDs/MJtm+gpCClVin0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vome4wU45hK5Zsvd7eMOaIW3Fp0kdJrrjq5MjTfMpgmI79+RhA/R/68otvWJrPDbs4nrg0vPD7SdhAE5RKfD97BnJgPULGeov/iRYhemTpdlieUlKrduCFofSuWebB5EHwDGeyql/ZNtnML3SjKpgr4c3VgR9S7CI6n/1QATeh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nEjYKgTg; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEjYKgTg"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64312565c10so942248a12.2
        for <dm-devel@lists.linux.dev>; Wed, 26 Nov 2025 23:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764230355; x=1764835155; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=z9iBKcpWfLkBP0f8MQKdR3ZLtXd1IIP5cJjZBkNDvwo=;
        b=nEjYKgTgUH9xQbbvfN388/J8L2p64gZfqCGL9geFWutMZzeGHExGVdEFD8Mc6SvzGx
         9kvAvfn6au2HrC0960czno7+KCF9NwQgmc72ukdW5P36dsDmMuaj+otphv7oFxVJloD6
         genzvarRx+IumQh9ts1UTOrUA4aEEfFd/m9ADF2XGS6f//o4ZDhEFRQnlHxJQy3kmXnW
         XxoCm+a8T4Jx7nat8yYLBCiboyyHEMBLtYJemj7W7kKeFbUilelN1++PI9olmNnEWdB4
         MIzolAMXyBTSAKIT9GRFNEaFLlu8XqliiRTwzBnZivEef+4+4dSgDb6bC/fryUZEb2ss
         6w7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764230355; x=1764835155;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9iBKcpWfLkBP0f8MQKdR3ZLtXd1IIP5cJjZBkNDvwo=;
        b=lXxIfK8aQ4hxZ/0egiHhxC56IhjrjrnPrlnGxRr3Cq0Yo7eDHcsvFJIwwv23UgkeKa
         YgWt3pq+tf0MwDbxaK4k4HTo2ZA9QpON9jMiLIjkJTVoSgnPE6ZopI0tQW6SUr3zuXzL
         wLHFbvGbZ8pZjxqHvO/fLV7yjPFv3+09u8XJJiR7HhuKf9vIfpsK0YenZfd3SQG4VbLo
         IrlvtLFLJtumSWWNkOOOm6offOH0wxgs4UQPZnrypo4+PMK6qpEI/+3ZNTtmreYBhKjT
         6zT8Wrflf4pyXpMw+vZY35oBcS8Sww3gpk8v6zdaHHzqzWjZXOSduuWVWBGrhlu4lU1T
         M3DA==
X-Forwarded-Encrypted: i=1; AJvYcCVUOdj/5ZsVXgc/zswv7lA+KCo3T+aEA6DlGNudtlCtwBgL6jv2zLWPRuH0zr9wruqSDWmhJcoO+w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0xRkzW1i5BXHe6HdNPuvAr/SPumGwBp8P/IDukkSwekSKBrdr
	JX0zEIfr+1gUuzYa3/P9xIbyS2KV4lZfHLy6h4kBgaFWGhtUPuwAs9ek
X-Gm-Gg: ASbGncu1HGZSMf95QlENe+26QHUNKDLzCYzga5ngAeOWHD1l4YiNzFhed6FJxMgN6kt
	i5tvjT2HU6/HrH9icF6JrAPcZlg+mqEJVqStzaO8L/DM2cQxRJznpqqzYTblVWuaAqL5NLoCqt/
	q7hrvhLUjANS6d+bQtKMLfK83vP3bUt6xWdFV6sddEUuLL3bTIc1Eno4PvjYt6Ws7L/gmsZVN8z
	v5mcmH60DW6QPjzrZxlddE0IU/V1yFE58DTk7BJSdEUB7wtWclW6Bg+yAMZylB0vIEUGbPjpjqU
	x6FZOhrlPRyqNg7w0V/zw1mDad7hxmvr56ZCQfRhR0DnQasOMMiY6+4fY+ERjcJ0t0M/NcSOlgk
	Pyk+ISQR+ZiV32YL2monzJzaylN0OegH77zUj2cXHH5YHGddz0Jrp1QCsAdmG/rm/sFb+g1vcGJ
	hz1AaUFf7I7mT1R28=
X-Google-Smtp-Source: AGHT+IGUOKW6F5FS113p653lsKvlpeK2sBEh6Ngnt2v9kCLGX4w6J8eiuyMeBBixqNwPaFIiEPaPKQ==
X-Received: by 2002:a17:907:7fa2:b0:b5c:66ce:bfe6 with SMTP id a640c23a62f3a-b76c558f2eamr1050311066b.55.1764230354708;
        Wed, 26 Nov 2025 23:59:14 -0800 (PST)
Received: from [192.168.1.27] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f51a9819sm97759866b.25.2025.11.26.23.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 23:59:14 -0800 (PST)
Message-ID: <2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
Date: Thu, 27 Nov 2025 08:59:13 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
To: Aaron Rainbolt <arraybolt3@gmail.com>, linux-mm@kvack.org,
 cryptsetup@lists.linux.dev,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Cc: linux-kernel@vger.kernel.org, adrelanos@whonix.org,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20251111231835.1232ad8f@kf-m2g5>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20251111231835.1232ad8f@kf-m2g5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 11/12/25 6:18 AM, Aaron Rainbolt wrote:
> Not sure if this is a memory management issue, a LUKS issue, or both,
> so I wrote both mailing lists.

It is not a LUKS issue; cryptsetup/LUKS activates the encrypted device,
so it is only the kernel/dm-crypt handling IOs.

Adding cc to dm-devel as this would be another combination device-mapper
and encrypted swap that could cause issues...

However, could you please specify exactly your storage configuration?

 From the subject, I expected you to have an encrypted swap, but it is
not clear if there are other encrypted devices.

Please paste at least lsblk, lsblk -f output, and also luksDump
(or crypttab if it is not LUKS) for LUKS/dm-crypt configuration.

Thanks,
Milan


> 
> I'm seeing an issue with both the latest mainline kernel (6.18-rc5) and
> Debian 13's 6.12 kernel package. When physical memory fills up, the
> entire system locks up hard, as if it hit rather severe thrashing,
> despite the fact that there appears to be disk cache that can still be
> evicted, and there is ample amounts of swap space remaining (gigabytes
> of it). This issue did not occur with the 6.1 kernel in Debian 12. I'm
> seeing this occur in very low-memory Debian VMs, with between 512 and
> 900 MB RAM, running under VirtualBox and KVM. (I suspect, but have not
> verified, that I'm seeing similar behavior under Xen as well.) These
> VMs generally use a swappiness of 1, though I have seen a lockup occur
> even with a swappiness of 60. The filesystem in use, in case it
> matters, is ext4.
> 
> To reproduce on a system running Linux 6.18-rc5, with :
> 
> * Follow the steps from
>    https://gitlab.com/cryptsetup/cryptsetup/-/wikis/FrequentlyAskedQuestions,
>    section "2.3 How do I set up encrypted swap?", but creating a
>    swapfile rather than a swap partition. I created an 8 GB swapfile
>    with fallocate. Reboot the system when done.
> * In a TTY, open a terminal multiplexer (or something you can abuse as
>    one, Vim works well), and open two terminals. In one terminal, run
>    `htop` so you can observe memory and swap usage.
> * In the `htop` terminal, sort by M_RESIDENT.
> * In the other terminal, create a new file `test.py`, that will
>    gradually fill memory at a relatively fast pace and print an
>    indicator that it's still alive. I used the following code for this:
> 
>      import time
> 
>      count = 0
>      mem_list = []
>      while True:
>          mem_list.append([x for x in range(2048)])
>          count += 1
>          time.sleep(0.002)
>          print(count)
> 
> * Run the script with `python3 test.py`.
> * While the script runs, observe the growing memory usage in `htop`.
>    Swap usage should start at or near 0, RAM usage will gradually
>    increase. Once RAM usage starts getting high, some data will start
>    being swapped out as expected, but after a short while the whole VM
>    will lock up despite there being gigabytes of swap left. (On my KVM
>    VM, the last time htop updated its screen, it showed RAM usage of
>    712M/846M, and swap usage of 328M/7.40G. The python3 process
>    running the script was consuming 551M memory. The VM is entirely
>    unresponsive. Incidentally, the python3 process also was in
>    uninterruptible sleep when htop last updated its screen, but that
>    could mean nothing since it might have come out of sleep between the
>    last screen update and the VM lockup.)
> 
> Under Bookworm with Linux 6.1, the Python script would occasionally
> freeze, but the VM would remain responsive, and the script would
> eventually resume. Even with kernel 6.12, both unencrypted swapfiles and
> swapfiles that are technically unencrypted but live on a LUKS volume
> both behave as expected. It's only swapfiles that are themselves
> encrypted that seem to trigger these lockups.
> 
> I haven't looked at the code at all, but it seems like maybe memory
> LUKS needs available in order to operate is being consumed, thus
> making it impossible to swap anything in and out of the swapfile? That
> seems like it would cause these symptoms or similar, though I don't
> know.
> 
> Let me know if I can provide any further information on the issue. I'm
> happy to bisect the kernel if it will help.
> 
> --
> Aaron

