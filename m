Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794661391;
	b=dnOoDYdFm2WvEj6Ye8k2u8G0/nk5IRMnlzJhPdbhIgy1u5VLfhhenoQVICSgggVLeOPV
	 bLtn0BvZYA9kgvaTbFJi642BN/A76g/N4PnLkdTMON0yuRcohQbXLoG6h4ILSTQxOPy7F
	 LbdPkp2kd8kyMpBE6PODK/CA8xwHMcZsIE1/61MFe87h5Frog3Oi3IGTCJ4K4/cjIrQUE
	 iAJ5bBTR96W7vmRpzRiajZy/HtXGmywXE4iIF/DabF619u/iNxY8scs5KOMnWBWqIRJOw
	 WUwFyVFEkgHb+X/shgC5HPcXRePP5J2a4wc5/s4lZ/uyBln8cB3NuO3hNUNb1J3ysQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794661391;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=voIO8VlTvL+eYASbCl/rFeZp/+p5C7oqqVud5Dtqaes=;
	b=Ub5HL7Od26OfvqS4thEE+KhdXjxlrK/hfFcj3z+flpcBFrdWRVgymtSXJH9QSj1xZJac
	 ljsM4P2NO+90nrRd17Gh0yhTp3m7CdTP7YO76365OC7tnJ7oEyDfwsQd0/sW8AB1gtwW3
	 CmzYO9PNlZZ/4mHRvveYtJz3IiJP3uo0MpgaoIM4buB9SAWeEEl1GXlxXao8qvWuLvQ0P
	 wMFNFEHgyTKyAf+vFJg+DohFHE5n3HOFukwwTPd8LQS4CXSZfR431Fc1HYWMYk/C/RI8x
	 RHNi5XCBlq2jCC8GeRhZAQCpjNvRCZVJ2rDgpVKYfP8uIWKIeoJSNNNhm+IAEIq/gRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vEQuJUup;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32A0606A32D
	for <dm-devel@lists.linux.dev>; Sat, 14 Nov 2026 13:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A32A0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vEQuJUup
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c3fae9338f0so27969666b.2
        for <dm-devel@lists.linux.dev>; Sat, 14 Nov 2026 05:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794661389; x=1795266189; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=voIO8VlTvL+eYASbCl/rFeZp/+p5C7oqqVud5Dtqaes=;
        b=vEQuJUupHGNQy4dI9LtKRjOjxiYDjyzNmHIt1r3p4A9dUkGQxxlHGssKmW60HlNpK2
         ZDHJ39v7E6mV0LYR3eHWN4ezkraltk1zVRwpiJFVFkFpuPpEpSmYmgeKQljk52vDxGjA
         tnAQD1Axi+p+Le3q140zYNh2X2dkwyEvwqxP1z0V/xW6kxmzP/QEd5VPxuOdLKXE5ehG
         o6IeQD6SowHc28Mzdl8f5y0FCRYNzaFuwLzj1nIObfjcDguwJyMtsIJaCwxRPy/QKd8I
         qRgaDCF/EiWXn3XbxHL/SfnHOK7RYNXwlYwW+dqtWQGbR16tjwx1TEbKOpJDsx8xKbbi
         /VhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794661389; x=1795266189;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=voIO8VlTvL+eYASbCl/rFeZp/+p5C7oqqVud5Dtqaes=;
        b=IyvRRioidi0fZPhbJ9n0/WTJ/Y17WMuliBML3fWUH1nWH0+F3VNSTarYy6mDnSBGVh
         gaNWUBT/+Odevpzq/bJKMWJbxm1kihD2cDvRsxQpLM+DGsAu8ieRtl1dwzF4+onPh5HI
         qArLSGwBhZWZQVWj35YdTTAhfo+gXWnph8pyM6hbbtj3JcLhCrX4YK2jn8KZTUTttE/y
         1DeX1GDlCLPQ8kxb3xQd/9NW2AcphltRfG+afMQJXFI+0MsNn0Z8bhOs+DGEqLdsdgXV
         2K+SvKaDMIwF+jgmVj16enj62Ao1rZMbkk3gVBSw3KKUczWvAaaix+scPbuyboKemF7p
         PfAg==
X-Forwarded-Encrypted: i=1; AL+hErGf0q4wYN/Yru7BK39inrx/CLZ7qYX7cKw1Ix60s+Fy0po+6jXblVtVmyS2Z9cUtUQ72SMjMsjLJA==@lists.linux.dev
X-Gm-Message-State: APuU4Z92HoZFFNZ8HDP9++TsuqvUCvb6Q0j4wlFd/qofKmOBI+ZvwXsw
	XDqrEvy5o0SqEFczIDiH0vYEom4j1Q8SM9nJfDJlc0KL5oFzZRim2ds=
X-Gm-Gg: AYBFou3u61982R5VPF/ArZm+7YqKL8qDLv5bfJlS+CZiN61c0kAKlfKBnJNapB4BXJL
	VCBf2rFQRLi13QgusERYbYe6DJFguUxdUo1p5tWXfzoODiMj9Sz79QPNZ8auOmsQhDZUnSfN77+
	NQ5yhcVZiqwERAxN24BPFZb92ueeaeJpEz3/w00h+RrkDUDmyJ8FkPTTUXyAsutMfr70EZXUUWH
	xWAC+4r7AMDk48bwLTwE/jux0iqlC+kpQmEo8oVU5PNPw9/Ib1vslFSjUD9zds9eZAL8aN7P2Yq
	lUaFWoQfwAP8l6wkC8sxs8m/LOSQE8Q6pRBVMMlxTXgL86QBpuOnsSmAQdPmwzqCtmgVVW9pHqe
	9LgKobzi+IA4FlbGfK5SehLw0v8z6mKqIsStN7GsyywjfWTHeuoFbQNTX7/mwRStU4i/KgRflvl
	1yS6NhaNYliOSHt/wscWpkE82r+TDaT5uVH58fIxOQRTK+eNtPr6TZj+WwwEFwP58YgDzUTpq/m
	9VfcmhXzGsMPVfi5prvi6QkFAacrr/trKyFsIKjeQatNqL+BrJcvzs+feF9qucxzO7WCMlCWhha
	XWx+g2HQ2748WAdHKV2pUEpQwpYt4IQqbaSgxc3+z4Y2MNPKLRR591aoXhYj/plobQ==
X-Received: by 2002:a05:6402:a152:b0:6b7:c8fb:53cc with SMTP id 4fb4d7f45d1cf-6b7c8fb58e4mr3242227a12.1.1794661388747;
        Sat, 14 Nov 2026 05:03:08 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49d7150529dsm5866714f8f.51.2026.11.14.05.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 05:03:07 -0800 (PST)
Message-ID: <00e03246-95dc-46dd-a2f9-89ad88f177d1@gmail.com>
Date: Sat, 14 Nov 2026 14:03:06 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
To: John Garry <john.garry@linux.dev>, Laurence Oberman <loberman@redhat.com>
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com,
 dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 mkp@kernel.org, Benjamin Marzinski <bmarzins@redhat.com>,
 Martin Wilck <mwilck@suse.com>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
 <3332329d-b922-45a4-8333-e8353e983885@linux.dev>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <3332329d-b922-45a4-8333-e8353e983885@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/10/26 10:05 AM, John Garry wrote:

> On 11/9/26 20:19, Laurence Oberman wrote:
>> 3. Smaller points
>>
>> - numa with equal NUMA distance uses one path per LUN, so with two AO
>>    paths through two HBAs, half the optimized bandwidth is idle (sdl:2
>>    above under numa). That matches NVMe, but users coming from
>>    dm-multipath service-time will notice. Would round-robin or
>>    queue-depth be a better default for SCSI?
> 
> Maybe, but round-robin may not be always ideal considering only a bio mode of operation is supported and no merging like dm-mpath RQ mode.

iopolicy can easily be customized per array/device via udev rules.
Just like it's done for NVMe:
https://github.com/linux-nvme/nvme-cli/blob/master/nvmf-autoconnect/udev-rules/71-nvmf-hpe.rules.in

Additionally, "service-time" and "latency" I/O policies are currently under
development:
https://lore.kernel.org/linux-nvme/20261026111019.3724465-1-kanie@linux.alibaba.com/T/
https://lore.kernel.org/linux-nvme/20260815173502.1185929-1-nilay@linux.ibm.com/T/

>> - There is no userspace tool yet to show heads, paths and ALUA state
>>    (the equivalent of multipath -ll or nvme list-subsys). I used a
>>    small sysfs script for this testing. Ben, is native SCSI multipath
>>    support in multipath-tools planned?
> 
> Well, the whole point is that we don't need userspace tools. However, I appreciate that there is no general SCSI tooling which could help here. I know that Himanshu M did work on a SCSI version of 
> nvme-cli tool previously. Martin may know the status of that.

Agreed that userspace tools are not strictly needed for configuration, but
observability is key.
A standard utility to visualize the device topology, path health and ALUA
states at a glance, similar to what multipath-tools provides, would save a
lot of friction for sysadmins migrating away from dm-multipath.
Relying solely on ad-hoc scripts or manual sysfs parsing can become quite
tedious in production environments.
