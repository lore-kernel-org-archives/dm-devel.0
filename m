Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014181;
	b=U9KJksGh2EOVn5pVLgo8sGJl4T1jg6O5hHHw0RMyE+NZIprIXRZt2Ai7U5dJzov+RK2+
	 Z4FK2U+eIghWXM6sFSQtwP2TGhJb27w1OxLlK+lhd4EAt1yYPymjU7UF4j2KpLKSjKmZ1
	 ycRT+VCt7vdT68v3ojMBa1oZdpW3Yc23pVnSEQ5VPBKrxs6un+S94B5VZqXLw14qMWejp
	 WmUQEbJJW0TvMmvktwkR7HQCyxYzvN+qWM79VrdvZt175i4qgTFHI/OFxFoQdsSfTpZEv
	 TP/wIZ5Hh1uOY9OpwmlicoN6gcBxuzZqZa7FZZRhckxWHUS+Jpvj+qK0qzmCddOqi6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014181;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=7RcE1P5ytrzgfUBFVZbPSBPyBdBAWa59NFxTcogpCig=;
	b=0Vrm7vmbmrRr1zHNzX0ARLuym3VkZDnRznCYXuTO05HfQlitMrQSrvpzJfB4zLgRgcAs
	 MJhFGdUlS11eI0I5FOHK5UXUMY2/1Exf7gOUThOiVus/t3hk1emICnwleIMOqyXlfWyxR
	 9YihLCTgvVjZLmfOjx+TctL2p5uvz1WqC6FGfiKSuHSVUM8L2vMJVnA3D1ivsroJgG53t
	 chvDjoxW/WKTzJ2Vvp9T6puREVZ1IQV1RdzWiuU77/31qzzVY3M6RHMCsQvyhQCRcdveF
	 fIP+SWPo/h5355Bxscf5ZDjyzK7orC/8XClaOApbM99GNVjR9MjJmIcnF6B/qILGKYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PhKgmiy1;
	arc=none smtp.remote-ip=209.85.167.53
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9C2606A333
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 15:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B9C2606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PhKgmiy1
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5c0ea47f5b8so124985e87.3
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 07:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795014179; x=1795618979; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7RcE1P5ytrzgfUBFVZbPSBPyBdBAWa59NFxTcogpCig=;
        b=PhKgmiy1vrS5YX+h85z5cTZEeNLPoKX3F813SY4zzhJQOf12AYpKgjCtGcsCzztmrX
         8IbpkwrByLKTgtG++mRkxRHFDNrBtVOF0mKcZxrqdZVRTuz47sWbcr8bx4951C3/gJM6
         QXy4TBK0ORoZ9vvFGYKB80VM1u3S4678MUHKfCdKDfIACeoyvVqHdWaWrHaWpxGHs68c
         MhlHtWVIxBJmUaXvXkeFM/27Er5nVHyU4Id6t5bTK5vqlDhgwAYTaP16FifMU6cH1P98
         OGqAaHo3p5y4pUOYdpT9pYeCb4fCtuovG3D2xH4QYq7Wurg0/5A9bDb5ipT4NoN5newN
         Qz3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795014179; x=1795618979;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7RcE1P5ytrzgfUBFVZbPSBPyBdBAWa59NFxTcogpCig=;
        b=2oLxr2NJiS01TjgXVGsQH3zYaA7cOKFFa5qTJ3bU9nx7OGiATpSuS66LqxaakwRPA7
         6c6vwpxPCeiGrp0QtmQcItlTQnyh2aqvM/yVKybCHHju4htpLPnnwiTSJxtMG0iKVEEn
         YMX9MJ+5geNnfqH5arvpGhS8mpBIzAp9YM5bJJ29nixOuQO3SgUBMfSvmuv/aQTvzaIu
         zp4PjEJBtTx8i0BuBoJeXYdgdRCVB2ldds0SoTpEh2V/27soGyA2lCplfV2I7cAwcAhx
         yxQlDQF2Oc+MxRlw1riPuQO1io2mY9sFUZw8wiWcQ6UBvCfpp3Xdf2LxNwt6vFCH62Iw
         d1eg==
X-Forwarded-Encrypted: i=1; AL+hErEs8cJ4r4S/dQ+typKDUBTLallZTuFxFbcPrRb7iTM3xeCsuC52tMddM17zjfderJbZ0nDcQwa6rw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/VTv3m8t/jda7n9+vLF861n8j6VLiU+c/DR0ZyxfISdSM8FAqs
	R0c6yoAKPa+oZkQHNvEHmuRKXSZJnVaQOohBU7yQa2yuRuwf2cIK2Lo=
X-Gm-Gg: AYBFou2hy2WsIBISNQHWmgpVNeBrs+fQLJ1U72Bg+g/e30phPvS82+Wt/toGiZ0PUJO
	w0gEbDPmZuCKL554jJA/12/bB1rUuAfT4D+nUTcpf39m74rPhSVF4RKdwn6BYVJKxLUVaj/f2Un
	ROqiJgZIHdPUeZwK8yfoFDGfcaiJe8SpaYI+imroiG7L9czRgu/zkfRzzsKYVsSEJLqISMfNhMK
	HKKPhueP1bMhPyvDXKKyfjxOVI+Vcc71JFeUmvgVU51JnvSRhyIJpQkJbGSaR+AuJLH9HzYiw7P
	HlEC6is/4s2PFX7bHK4XqH5dAZ7u3JC7icMLaBArG5xkOT1K712toCM0/fUkWEN1ue1gEoHiG2s
	VFPO4OKEL2gR3sgxHPq/N495m4OkJSbrQtUVTiiybfKBtcZJQNDB/kuiUa6kOjMMbbgr8J7Y+7g
	wbzuiEDbJKkYKeMabKSeaY8qL1DtRNqdhN70MWWvgjBlrq7FdUgByeM/KQ5w59SIcQzhiwv+AUk
	u+RQK9DabHwk4cu9+FRYCiUhzNtfnA9NJl4lrunPPIJTc3pdNgPJ7f71MArt/Gb5Xwxp2As447t
	VE4GjXEq0x5kSyZvY4UdPu8KEOEJT0LBxbd3XywdYBZqsKPg28LS5TVM7P5dzX8kjA==
X-Received: by 2002:a05:6512:6201:b0:5bf:ba43:fa67 with SMTP id 2adb3069b0e04-5c1aa031659mr1205533e87.6.1795014179141;
        Wed, 18 Nov 2026 07:02:59 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a656c11f1csm5743954f8f.53.2026.11.18.07.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 07:02:58 -0800 (PST)
Message-ID: <ac29a29d-9932-495a-b75f-1fe4fe7948c7@gmail.com>
Date: Wed, 18 Nov 2026 16:02:58 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Subject: Re: [PATCH 01/13] multipath-tools: multipathd.8.in: fix mandoc
 WARNINGs
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
 <20261113125549.504780-2-xose.vazquez@gmail.com>
 <avt3vc307mk4FHZK@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <avt3vc307mk4FHZK@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/26 10:38 PM, Benjamin Marzinski wrote:

> On Fri, Nov 13, 2026 at 01:55:33PM +0100, Xose Vazquez Perez wrote:

>> @@ -77,7 +77,7 @@ multipathd executes the given command (see \fBCOMMANDS\fR below). If the
>>   command contains whitespace or shell special characters, it needs to be quoted
>>   like in \fImultipathd -k'show topology'\fR. No whitespace is allowed between
>>   the \fB-k\fR and the command string.
>> -
>> +.br

> Nitpick: If we don't want an actual blank line in the option
> description, I'm not sure the line break really matters here.
My intention was simply to replace the blank line that mandoc was
complaining about and remove the visible empty line while keeping the
rest of the formatting as is.

That said, if you prefer merging it into a single continuous paragraph,
I have no objection to dropping the .br in v2.
