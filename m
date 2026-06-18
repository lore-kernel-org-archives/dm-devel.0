Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE6623392B
	for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 13:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790475; cv=none; b=fVSyesIlCmGBaLPr2JZu4uVVTgAupzVrlL+GUf5nOCVrcpb/TOARmggrBnXBPrFRewk3WFKFs+5z+glkGCNidO410qoBTU4l1FVVnTzU1exykOz102hxI8q8FiWDcLPTSKyNvMb+A94hoRrSocWRLS6/sew1oLQDLPqcJLLjhis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790475; c=relaxed/simple;
	bh=hXMiDwqSnL5Wfs9SHl8MGl6UPXeovc3XzPTo7Lh2wdg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JcVONWJBdXOhKuN2K0Epl/5NnBjSQT0qffm1iCrWZ4l87ETiMAMW05NLRt3IZ4xDOFAddt4R51mCaHBGdcfLVBEqnlEYTvmbp915idi6iqM2+Zl2QdjqWxUx3LEQUgF4Q50HFNiLlUaZI/w1rH0MSwTVcLo5NBVvLH4aowIY+GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjsHnvKE; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjsHnvKE"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-462f54dceedso61195f8f.0
        for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 06:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781790472; x=1782395272; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tfL2oRsKxjJV+nkfT7Jwpd4JPv9Jd9KZ6MrvR1aGxwM=;
        b=LjsHnvKEWlOOEnJ2UEpHnVwsSkzHybNbUUzMubF4fQlqP2N1bJEpS1Yr5ERHEvcHcq
         oKpev5k/qei4J1KReEdwjlm3Miu/ze1sbT3VuSsg8Qct+G4N4mdephJML+8W1TiBW1ES
         TWNflolg6sz0P2o2z21cuL44UrfitoJGiNJdrDPubNX55GcCrYRH7IVQoCC/iUKraThi
         lA3e2FxyKNRUR/i9YRVdmwwu/d7HTLLyg9FkczuN3euMpGK/bWiVKz9OeeKGCKEx9qdS
         VZhEIyIpp2+Yv6dRgnoCbfti0QyRQtRgJ9tDZ+dPEFKwNapLq1reuNptoL84qFtsj5M2
         +6zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781790472; x=1782395272;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tfL2oRsKxjJV+nkfT7Jwpd4JPv9Jd9KZ6MrvR1aGxwM=;
        b=BSTa/DyIHuz1dVK+x4x65lEUmmPT+GJ/VpIcrPhkRmcXG7461ZUvIlnCrapBjhnPDp
         SOXgkFBWIKYQ/Cp3iyWxZ/u5EpngBk7mTTseqpoHDXpMAby1SVMxmqbgMAUVSgkcaI2z
         ZXcX0n4KF+h5TDLyIYnGwoBTbXA4FcBgrnYtgwGa6KP38BN3VIedLKKZ8obKiEPmb03J
         tMVHtmqQP3qoAdug73zUXHH7LjjDBuBXiv8JuZ4TjJd6awkVmw/Y6POmb1dy2yvZ63h8
         ItxpbFLjdHolEu/ox5S712dIoyAv/NKHADI2PCkpy2g0ejafAIWWYtnvrtpmiag9FXKJ
         kpvw==
X-Forwarded-Encrypted: i=1; AFNElJ9d0xr3KWtWR7fskjzLeCwf4fDxyYqFxle2V/KqDlFbNez5qCw5/Rh8V+sfh3EGihGkDDDzc1EYBg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzRkVlCUP96nqZp3k6oqtbtGgsQ7pQATy1Mx0kMJMFtHuVhrgTY
	C3mDzH7GaROJEVLbxZhZMFoYTkXHzbpFwTntHb/hTREuAg0NhKwsC7s=
X-Gm-Gg: AfdE7clnGijNFlj4khjEU/cfpab0tZE73o0sCf/uDbQNbr3s+ZPiPEDdYyssE+bDX8i
	nzz7jRZVdtTATbY0YIrmHQF1iZNdoYSbLSkdU/7BYu7Sp4eT4q+XKvfE+AD6gR4T/HFRa1qz10r
	SjAyCvx/7WxmmqENoJbCGu3Zb1OqUKFFYp3GOnh1iHcyETRxXd0i4g3TFV/IzK0dx6y99eHHvGZ
	ERF8BNrHxMLoi1FiCzuq9uouQzzNGelg7bOobhdDJh0/PTIIrBuY0/oKGfXoEHRunaHwoGq1NHT
	gg+XWG1ZZCPlmTb+EC1dAwGY85yqZMmbhsMNzKee2qmREgkPF9ZtSDRCFPuw0jctQK+fsNnMi1X
	i4mre1g9mCyJTVDIvdNDO6G2HzlmTWGpAK5yaz41cITXJnNJI7urTkzXBNq17uv43YyTe5tfd5a
	1Y8LvjCCifL0I3fmEFtBiQaA/wSl221Pf8vQANSr6a8LQkO8fZTRcS3ktyP16WxwXHIMTD
X-Received: by 2002:a05:6000:22c3:b0:441:1c35:4b79 with SMTP id ffacd0b85a97d-463ab32654amr2867894f8f.8.1781790472180;
        Thu, 18 Jun 2026 06:47:52 -0700 (PDT)
Received: from localhost (241.red-88-28-13.dynamicip.rima-tde.net. [88.28.13.241])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26434dsm65314159f8f.1.2026.06.18.06.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 06:47:51 -0700 (PDT)
Message-ID: <32468762-a81d-4a8f-bbab-0874bb696681@gmail.com>
Date: Thu, 18 Jun 2026 15:47:50 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/8] multipath-tools: clarify path selector
 descriptions in multipath.conf.5
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20260616122909.244619-1-xose.vazquez@gmail.com>
 <20260616122909.244619-6-xose.vazquez@gmail.com>
 <ajHKli7e2XP82alM@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <ajHKli7e2XP82alM@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/26 12:13 AM, Benjamin Marzinski wrote:

> On Tue, Jun 16, 2026 at 02:29:01PM +0200, Xose Vazquez Perez wrote:

>> +Choose the path for the next I/O request by \fBcycling through the path groups\fR.
> 
> This isn't a strong objections, but personally, I'm not sure "groups"
> makes this better. It kind of sounds like paths are picked from multiple
> path groups. Perhaps:
> "cycling through the paths"
> or
> "cycling through the paths in the path group"
> 
> I'm also o.k. with leaving it as you have it.
You are absolutely right. Using the plural "groups" breaks the coherence
of the sentence because I/O is cycled within the active path group,
not between different groups.

I'll restore the singular form in v3. Thanks
