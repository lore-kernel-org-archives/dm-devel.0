Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD518614C
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706631023; cv=none; b=kSlYdqVtJXew7xvwiGtRoCo+YwMo8E+SbzEDeqMseldXutJxHOt420mcctoe/lVhlRD8HglH52tER39c00X35pbvBMkHq+o/ClmVtCL6OT6kJaWd8JKDL0hMQ0f8ERNqQgoa2N6pJHMnmYH4QAA710ppCk+U19eIxB7nnrkzjFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706631023; c=relaxed/simple;
	bh=/zMCnzrzvsWFCne0jCq9Q4B0qX5tZaDcIXZPfIwSNmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d5Wx2FVjgcvZEtnZ5AmXwdDzuteCLZUuXD+BzL5PPtZmSEdS3wYAbLBsyJobWCqJoUvi+gxCBTepcZF9/PRRMmrAoqQhZlie/IELUyrBuIZaq3sRSwqWsS6WvKYFKAuXMQngeuM4saj3+0/OPyCKzoA0mJkWtoK/fxGAh1bahRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uf3IiYIl; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uf3IiYIl"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7838af983c1so325286485a.3
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 08:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706631021; x=1707235821; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2jMJ9gkLa3FCMVCAzaOh9pYg0+25Xl7Z9WBoe0M8JL0=;
        b=Uf3IiYIlgS5RciqphhpZhJrh6e1cHE8lFYH4M3p6+ATzuhvpSK2ChZcOqYTMyIOr4C
         BEWIH2uU1iom+yYUs58G4+a2KB3vIeq0ywywv9qmsNoE6bmdGsRyA0RPAUMbdDyBPA98
         9rffZ6OBsv8BwhP8VXQ7ODGCIdhGkpaIYSUISGFw67Zep7XUD0rYRK14LJU4d5IBewt2
         7jfyxPlJyJhNYKKKmXdkwV9Em//Cy3Xf+lQgawzvDnuzjr0JoZoIsf+lRA3X7otaOXdm
         1IUAQpuN3WbcAGjvc3pTs8LLNaSoWF9aFgifqa8yP9BT8DH9aafEMIp7R8oadpfFizx7
         38wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706631021; x=1707235821;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2jMJ9gkLa3FCMVCAzaOh9pYg0+25Xl7Z9WBoe0M8JL0=;
        b=ovVq5YS4UJRmdOC89L/jI1lMe4avv6AA2872Fb3IsTE2iEZdXbmdVQ6GudJUU4HAme
         cn3QUoOfx6WotXbgNjfdCDbdcQkbRl0jipFJlg6EynZT5kufpMiLsfhym8CcNfYuCVOS
         603CRrFyLhvgCHV+dXZGbkgF/ALq9UgjtLr9FbvYVgwe6/2WFeRU74TyumG30r553jds
         zbD9iPnJrVSEAYzXlVUo5dsdC8p3cgQT2BlACYdFTLIun2Fiu4J4TbbFfR0ZTWB+aohu
         dghiJ0/zJ2JaaqzZQZgwaR4fHS2TKRQpdVcW3WHM1m9EoBa/5haa7Wek7yFvfmWDvUgo
         EMkA==
X-Gm-Message-State: AOJu0Yz/HHDOxF8CnY4KHQyxcEu+5ADUpKGAbSZoq/jQDhpCFuQ49l5Z
	tphxLvLPnKuSJDU1T7/LV3Ipnff964Y62nQRTnsZB+ApF4/2aZEN
X-Google-Smtp-Source: AGHT+IGxtOwHCwjjjtIbL2nq87jfL7/iYjXqYSCiipQRKZxUlxm7QgbCmoZ0dJLKDR3WQJ1QNlg0ew==
X-Received: by 2002:ac8:4e86:0:b0:42a:b809:7f95 with SMTP id 6-20020ac84e86000000b0042ab8097f95mr1565882qtp.8.1706631020920;
        Tue, 30 Jan 2024 08:10:20 -0800 (PST)
Received: from [10.56.180.189] (184-057-057-014.res.spectrum.com. [184.57.57.14])
        by smtp.gmail.com with ESMTPSA id z12-20020ae9c10c000000b00783d75b2335sm3767489qki.11.2024.01.30.08.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jan 2024 08:10:20 -0800 (PST)
Message-ID: <13d33c62-35c5-465d-b5e5-dffecac6f4da@gmail.com>
Date: Tue, 30 Jan 2024 11:10:18 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm-crypt: Automatically enable no_{read,write}_workqueue on SSDs
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: dm-devel@lists.linux.dev
References: <8213bdcd-2b2f-48c9-86da-ce3feeb37774@gmail.com>
 <CALrw=nG1y50LZUr_v4HfojmnzOOAMNycZ6xPkX-q+_cFkT8G4Q@mail.gmail.com>
Content-Language: en-US
From: Adrian Vovk <adrianvovk@gmail.com>
In-Reply-To: <CALrw=nG1y50LZUr_v4HfojmnzOOAMNycZ6xPkX-q+_cFkT8G4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/30/24 03:07, Ignat Korchagin wrote:
> On Tue, Jan 30, 2024 at 2:14 AM Adrian Vovk <adrianvovk@gmail.com> wrote:
>> Hello all,
>>
>> I am working as a contractor for the GNOME Foundation to integrate
>> systemd-homed into the GNOME desktop and related components, as part of
>> a grant by the Sovereign Tech Fund[1]. systemd-homed is a component of
>> systemd that, among other things, puts each user's home directory into a
>> separate LUKS volume so that each user can have their data encrypted
>> independently.
> Seems filesystem encryption is better suited here, but I see it
> already supports this option.

Filesystem encryption does not protect metadata so we consider it weaker 
encryption for the purposes of homed. Thus we prefer LUKS, which is 
definitely more complicated but it protects all user data.

It's also easier to move a loopback file between devices, which is 
another goal of homed

>> I have recently come across a blog post from Cloudflare[2] that details
>> a significant (~2x) improvement to throughput and latency that they were
>> able to achieve on dm-crypt devices by implementing[3] and using the
>> no_read_workqueue and no_write_workqueue performance flags. These flags
>> bypass queuing that was in place to optimize for access patterns of
>> spinning media and work around limitations of kernel subsystems at the time.
>>
>> Thus, to me it looks like these flags should default to on for SSDs
>> (i.e. /sys/block/<name>/queue/rotational is 0). Such a distinction based
>> on the type of storage media has precedent (i.e. selecting the `none` IO
>> scheduler for SSDs to improve throughput). So, I was going to change
> This is a different layer IMO. The IO scheduler is more "tightly
> coupled" with underlying storage vs device mapper framework, which is
> a higher level abstraction. Does it even have this capability to look
> into the underlying storage device? What if there are several layers
> of device mapper (dm-crypt->lvm->dm-raid->device)?

I don't know if you have convenient access on the kernel side, but from 
the userspace side we can fairly easily resolve what is backing a 
dm-crypt device by probing sysfs a little

As for several layers: I don't know. My use-case isn't that complicated. 
I suppose if you have dm-crypt on LVM, then it's not on an SSD and thus 
we don't turn on the flags (i.e. we don't walk the layers until we reach 
an actual physical disk; we just check the immediate parent)

> I'm mentally comparing device mapper to a network OSI model: should
> the TCP protocol tune itself based on what data link layer it runs on
> (ethernet vs token ring vs serial port)?

In theory I suppose not. But I _really_ wouldn't be surprised if in 
practice people do this.

But also, TCP does make an effort to tune itself based on the 
bandwith/etc it finds available. I do not think dm-crypt can do this so 
easily.
>> systemd to turn these flags on when it detected an SSD, but I spoke to
>> the maintainers first and they suggested that I try to implement this in
>> cryptsetup instead. So I reached out there[4], and they suggested that I
>> should write to you, and that the kernel should set optimal defaults in
>> cases like this. They also mentioned recalling some hardware
>> configurations where these flags shouldn't be on.
> At least within our testing it is not as straightforward as "if you
> run on SSDs - you always get performance benefits". Some of
> Cloudflare's workloads chose not to enable these flags to this day.
> With all the external feedback I received for these flags - most
> people reported improvements, but there were also a small number of
> reports of regressions.

Are these workloads more complicated than dm-crypt running directly on a 
drive? In other words, are these workloads involving many device-mapper 
layers?

Is this feedback public anywhere or internal to Cloudflare?I would like 
to know in which situations the regressions can happen, and in which we 
get improvements.

> So ultimately it is more than just a type of storage, which goes into
> the decision whether to enable these flags, which in turn creates a
> "policy", which the kernel should not dictate. I can see a world where
> spinning media would not be used anymore at all, so the kernel
> probably can flip these for everything to "default on", but more
> "complex decision trees" would be better off somewhere in userspace
> (systemd, cryptsetup, users themselves).

Sure, complicated policy probably starts to belong in userspace, 
especially if someone will need to tune it later for a given workload.

I'd hesitate to make it default on. This would mean someone running 
spinning media + a new kernel + an old userspace or config will suddenly 
see performance regressions. If userspace is dictating the policy, it 
will be deciding when to turn the flags on anyway.

>> Is there some reason these two flags aren't on by default for SSDs?
>>
>> Thanks,
>> Adrian
> Ignat
>
>> [1]:
>> https://foundation.gnome.org/2023/11/09/gnome-recognized-as-public-interest-infrastructure/
>>
>> [2]: https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
>> [3]:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/md/dm-crypt.c?id=39d42fa96ba1b7d2544db3f8ed5da8fb0d5cb877
>>
>> [4]: https://gitlab.com/cryptsetup/cryptsetup/-/issues/862
Adrian
