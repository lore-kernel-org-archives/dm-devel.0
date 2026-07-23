Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A9C2594BD
	for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 01:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784769579; cv=none; b=b8xMMxj8yr9yyQ5HjBTF1ObgDJZeHHRd27yV41Rz91xfRVoee1d2nVnlls/sweSlbp+OgI8IpgYS5NAU+w+zPcPSYzK6uZY5qcBY7JGIoG8oOIVLEVrYIaXovJw1Ke5Y6qcWLIm86n1U0krVCSlaaX9gn6LQp/EDbR05TANOqtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784769579; c=relaxed/simple;
	bh=bziRmtnlyNU4DM20GQ18UJx+LKaYi+bisFQ1Qw0kLoo=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=PjpE7BKsTTE+cJHu1A8iJ3kfxhhGnqIgdjy76oZfMVYSohfJg60gnQ8J5gxdzm/ueye7Co1RDE1dzcm8Pv7gAWbkI3RNfvrkCa/SXB314306yc6M94QR7M0KWrVj68dilXdeCvtmNn68ZY0BDvBP8vLcA6VxxBsJnTRReJVdKd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mxe/JVip; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mxe/JVip"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ceeee8c46bso1096145ad.2
        for <dm-devel@lists.linux.dev>; Wed, 22 Jul 2026 18:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784769577; x=1785374377; darn=lists.linux.dev;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XUN92xTdTl6fNWFUT4QSVSSqJnaZF0E/uEhosiSF5L0=;
        b=Mxe/JVip1un7b5WzUqlgsMWrJS4gZgkDC0EzG+zME9B2LG8oYSyTCpXnzirLeLPj0p
         hWyAkRnUz7Ot/wWaAAVzhTa2s2VxRXHAgKNt0wuvbUHgVg4E30qlT9+g09buOT7wsLNm
         +lMFLiiNrlAdLtEdxu8EqyKzwmXphBY91hW77Vw26fwnInGRUfAyS9bkvP+UZ6LQ2f2A
         rG2n61StPkBpyvb0OVfny8b1zWJXMOPu8F2LYrmbEfoSIBA3ZvznAf6FSCmfBOJKx9dS
         zq69cIHWqna+G8Kv/cy0shKEruoRsviDLVA7SQhefB7qDo1qZgzLwfgmhXxTr/c8N8oC
         G3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784769577; x=1785374377;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XUN92xTdTl6fNWFUT4QSVSSqJnaZF0E/uEhosiSF5L0=;
        b=JLpQLtbAkPFYVoG1fk8o1yaBtEH1HeRh02nPYkP0epE86GlyHsnTmxiTXpwLKXkXAp
         d3dG+x3Y8nvZ+bid2oR1FY5OTNC6RT155Kg0aITGLDb577j2Ujpx43Y+py9Zr6yHMGuH
         EDffr3bzceeCY8b7SpRoaEp4FDekOwqSMVtR4+2hVpyYhBVPsJRJ2zlh58pI894KMLjm
         m+2W1pymW4mh4bzPthLavvHNZWjPY3M09+0juC5yNLO1+Ukkjrt94U4hwgZB2HczwRV2
         hLqwS41a2kSK53lHIPjCoEzwveCOhgVWufT9j/hm46ruE0rO5m5K6/954QAaOzw/LLpQ
         PZhg==
X-Forwarded-Encrypted: i=1; AHgh+RolJwiBcFfmQilDVbxRTTpi1LYFJ7zxEKtL/UhWsButufSP53WEtlE2DXdY0X0q9Alc7HkbpU0Ubg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwAhA5TAPAh2Z9AMBGuHmmlCDEFK5WN3iBFKsoErqJnpw5wvwgr
	vV/k8sXUpWqVyh9jVYzGrARgYE1R/3ZRf3gXFy8OZkj0ZUdZ1pxNDf4x
X-Gm-Gg: AR+sD11s/prGF6NMu50sH+bgzYAq5oX7MEbnrQHa40xWs2JmszpNbSBief0Fg3VCF96
	CNQyOD3NKyH2HzIZm0G5zB6PANmxReejgvnAh/CA+bk9ymdhhyoodPYQgTcY96tQ+s7n2lAZdgw
	Hzqilocs5pqSZx+9+tP/G3HXLciKiuwkMWhciiMsnu5IZCfVqT1ZYa2c1SZ2q3u53Fxf9yx4RXu
	O7CldBj/EivGNlG8OUWyJziNOGMFZepKCthzWNRLlIFD6y5TcXLUYl5rdqrtzZyOrpz564Y2aUH
	FfNe7O6R/1+0aPs961fJi6qKK6tKNm6mlIQaKWEvPztiPSVggum3LWbnfa86h7OSaArjsqVghQ/
	51nV4S2R/xv3lkVl54NalOH5uNfBVfuGBQ9EIvt8x6KCa6138YImd04320cbHNkduDoMXeE+935
	eXVvkdrNRAEWjZgXMh
X-Received: by 2002:a17:903:46c7:b0:2ca:e134:9e6d with SMTP id d9443c01a7336-2cfa70ae7b2mr10999695ad.8.1784769576684;
        Wed, 22 Jul 2026 18:19:36 -0700 (PDT)
Received: from [10.70.111.138] ([202.189.104.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efa39ddsm23134055ad.17.2026.07.22.18.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 18:19:35 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------Vu0RN6w7Hu5n5YLqydm1b7g8"
Message-ID: <cf9f50c5-391b-4623-87c6-f1af9d6ca900@gmail.com>
Date: Thu, 23 Jul 2026 09:19:32 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] dm-integrity: dangling reboot notifier after resume vs
 remove race
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: snitzer@kernel.org, bmarzins@redhat.com, agk@redhat.com,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <2582d759-1e99-4a31-9a1b-5eccf0af3891@gmail.com>
 <0ce40d40-1a42-7ee8-2fbd-6e1e8f9ce4b9@redhat.com>
Content-Language: en-US
From: Junzhe Yu <junzheyu1@gmail.com>
In-Reply-To: <0ce40d40-1a42-7ee8-2fbd-6e1e8f9ce4b9@redhat.com>

This is a multi-part message in MIME format.
--------------Vu0RN6w7Hu5n5YLqydm1b7g8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Mikulas,

Thanks for the suggested fix. We verified it on Linux 6.6.144 with KASAN
against our minimized PoC (resume racing remove / reboot-notifier UAF).

   if (!dm_suspended_md(md) || test_bit(DMF_FREEING, &md->flags))
           goto out;

Results:
   - unpatched: KASAN slab-use-after-free in notifier_chain_register via
     dm_integrity_resume within ~20s
   - with your change: no KASAN UAF for a 5-minute PoC window

Self-contained test package (patch + poc.c + A/B scripts + captured logs):

   dm-integrity-dm-resume-fix-test.tar.gz

Re-run with Docker (see README.md inside the tarball):

   docker build -t dm-integrity-patch-test -f Dockerfile .
   mkdir -p artifacts
   docker run --rm --privileged --device=/dev/kvm --network=host \
     -v "$PWD/artifacts:/artifacts" -e OUTPUT_DIR=/artifacts \
     dm-integrity-patch-test

Thanks,
Junzhe

On 7/23/2026 12:14 AM, Mikulas Patocka wrote:
>
> On Sat, 18 Jul 2026, Junzhe Yu wrote:
>
>> Hello,
>>
>> I am reporting a KASAN slab use-after-free in dm-integrity involving the
>> reboot notifier registration path.
>>
>> Summary
>> =======
>>
>> A late do_resume() can register ic->reboot_notifier on a dm_integrity_c
>> object that a concurrent DM_DEV_REMOVE path is destroying. The removal path
>> unregisters the old notifier via dm_integrity_postsuspend() and later frees
>> ic in dm_integrity_dtr(), but does not unregister the notifier that the
>> racing resume just installed. The global reboot notifier chain is then left
>> with a dangling node; a later notifier_chain_register() walk touches it and
>> panics under KASAN.
> Hi
>
> Does this patch fix it?
>
> Mikulas
>
>
> dm: fix resume-vs-remove race
>
> If the user issues the resume ioctl and the remove ioctl at the same
> time, it may be possible that the device is resumed after it is suspended
> in __dm_destroy. The result is that the table is destroyed without
> calling the postsuspend method.
>
> Dm targets expect that they may be removed only after the postsuspend
> method method was called. If we break this expectation, it can cause
> misbehavior in various targets. For example - in the dm-integrity target,
> the reboot notifier is not unregistered, leading to use-after-free.
>
> Fix this bug by refusing to resume if the device is being destroyed.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>   drivers/md/dm.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2026-07-13 20:58:56.000000000 +0200
> +++ linux-2.6/drivers/md/dm.c	2026-07-22 17:40:29.000000000 +0200
> @@ -3140,7 +3140,7 @@ retry:
>   	r = -EINVAL;
>   	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
>   
> -	if (!dm_suspended_md(md))
> +	if (!dm_suspended_md(md) || test_bit(DMF_FREEING, &md->flags))
>   		goto out;
>   
>   	if (dm_suspended_internally_md(md)) {
>
--------------Vu0RN6w7Hu5n5YLqydm1b7g8
Content-Type: application/x-gzip;
 name="dm-integrity-dm-resume-fix-test.tar.gz"
Content-Disposition: attachment;
 filename="dm-integrity-dm-resume-fix-test.tar.gz"
Content-Transfer-Encoding: base64

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
Mn1t6f8BI6IBsQDwAAA=

--------------Vu0RN6w7Hu5n5YLqydm1b7g8--
