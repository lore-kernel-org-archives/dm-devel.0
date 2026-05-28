Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF553ECBE3
	for <dm-devel@lists.linux.dev>; Thu, 28 May 2026 12:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779972443; cv=none; b=Kz8bcYt2GN0uvmD2IRK3VnonQCtqT9ZMKEtGDgWtedQgmVIoZuHWCys+EaZyRgI4miRwenLa/zsdDJhrDijrplYK+Yd9f36B6R6bDf+2hevqjznOlMaJc7rs0dj13BlBHZIku86d/hceqqEZrWL9ApHeIUe0BrAhqoMEmiQuWmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779972443; c=relaxed/simple;
	bh=rlJ6IZTleaSV4ynsGiiv/xNT6dvVrFtp+E9/UhAzd60=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=h90ZqXFJhlzWAwe+YOmf2qeP4+5A7XfDjz6LwXbm+aX9TEHHluJY0+XYt9DzeXVzw2vD6p77lmJ37bqeh8A7J5KnZIBVoHtMi4i4UaBp+Ec9msjmmLPBjhKZ3ju51xLA0a2ponqJC5Rv/sG1jXcRR1YmSeGr7Q+4ak6xbsSEk84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=UtBFtdKv; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="UtBFtdKv"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-439712b3416so4453651fac.2
        for <dm-devel@lists.linux.dev>; Thu, 28 May 2026 05:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779972440; x=1780577240; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/zCb1mk47fudc1ZiKoDR5QYSbHkxRCJ6yfjOlHrX+vs=;
        b=UtBFtdKvQQtACNB+GaKrXSvYCvfE8vugx/+XoMVbyEjAoS+Oe8f/CVsythdOY7J1XC
         OUffMX8d+4cdTGtGF4lPZ0z7i1QuttLSII5F4nGPT37rv6+8fB+tvMlbE7fTJFLlg1IN
         2BJiqJIiHWbBw1utYGQMAgJiM9vhwYtkn2aZOH+VgtqKxWFi/GtN36wS8qTiJmQJEy7w
         R3VXkroCX3KsJ7ccl7BFbW91tNjxEHXwmTaIru52S+NKfYnw9SCVxM66/NRq3L0Ze0rZ
         JgvbSFGe9+9kXsDkAwwZgQ1NGwiwcRxqET2I0pQ3hl5CZRPJ+nG7PSH4R8rXV8nR5zd7
         xEVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779972440; x=1780577240;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/zCb1mk47fudc1ZiKoDR5QYSbHkxRCJ6yfjOlHrX+vs=;
        b=hPk/SlABbmAgCztLf+Mm4IgIvZKz/nI6OPvpTzp1pi5f/plSGmI4D0eLuKfDTzemCi
         2Tt8oGlckEgB/F119aM91fHq5jENnTNQ61wjE9aJTjvZ1zfPzri+1y20pCipqGi422LN
         2Y4wY6PoGAcFAy/a3oMKjSu5+YQ7Gu5nT30FGFLWKWsGCIZV49/DbKKqMDXa6ViJxNUR
         +TDt4PM0DFTYnLHnwNI9bzR5aqUE2b6rgC2JbO0qHWe5OA8qGjfjsFJkzDOAJ2TDDyZS
         NLm9uF0lDAjSOoyEQRmiGtWIM51vFXtjLevPNieZfnCVmZXCzKA/HYirQwDSBDX8yqXl
         cE8w==
X-Forwarded-Encrypted: i=1; AFNElJ8EcbqMsxDBzJ3FzisQnhW3UNtTZ0iaQayrwUBNmCFadvYXAUjuXNuoEu9dGOThco7zuLY9J/GMfg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwqtuKf6FvUrmMFNzv+U7fdI9GUtMQqopNNblxI5WFoY7COCwDA
	/oIBdfdwuQ/Tf554mu5raZNwWIeOE0AtVRlCwoQQvzZpB8lbJxhyUWjNCJU5VUpbzqA=
X-Gm-Gg: Acq92OF1F6hjENXHmcAOlll4jodPKe9dAv2SG9y32q9iyor5/ZrCEboU08dI1W5vDf0
	xOBVNkmElAcSO4wK/mcLDVO99iK6JeRihwvAJUFfeqDUSOgXLlzOA3urDxyAgcsLwAoI2O8HJ2/
	lvxDMZrxetlZ1CnXeMrNBhrVE0u1RifS3DtFVVGQfczGGkgW8BOkZyJLBK7vvR15HX+EIa8Vpjs
	G0Xpxv5kTdscPFIUryyIMHCLFva1F28G6RKKkTo1Ypzhr6cjJ8Ag844aEnZXtXzJs1dojCfxk2l
	etPCm8CanJZF9qnTB6zgYdHPQsGolzYF5DbPNO063U94nC6CBXQNAOmzzqVINC72qguh9gf2HBd
	see2UwyfuuJd4Za8hhTS7j5+GqcmaTPoczk6qgmQm6CYHLpdnph484PXvrQnXXajIn2gj3wtIRD
	rFtxAD2ZCq3TppyLgeG8Sm5ve3gHoWMT4j5FYndZzRA0P6eBVPT5u/MPvUWLy5M5sW3zz2Q3f8Q
	KdlL3GXfxkUlZyTHpIV
X-Received: by 2002:a05:6870:14c4:b0:439:7835:136c with SMTP id 586e51a60fabf-43b5ad8ccb6mr15892082fac.23.1779972439704;
        Thu, 28 May 2026 05:47:19 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b639fd7adsm19740646fac.14.2026.05.28.05.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 05:47:18 -0700 (PDT)
Message-ID: <c8301a62-8acf-4a59-9e3f-30805c358e29@kernel.dk>
Date: Thu, 28 May 2026 06:47:17 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] dm: limit target bio polling to one shot
To: Fengnan Chang <changfengnan@bytedance.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org, agk@redhat.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev
References: <20260513091349.2194-1-changfengnan@bytedance.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260513091349.2194-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/13/26 3:13 AM, Fengnan Chang wrote:
> dm_poll_bio() is the ->poll_bio() callback for a stacked dm device.
> The caller only knows about the dm queue, so it may decide to do a
> spinning poll if it thinks a single queue is being polled. Passing those
> flags unchanged to the mapped clone lets blk_mq_poll() spin on a target
> queue from inside dm_poll_bio().
> 
> With io_uring IOPOLL on a dm-stripe target this can keep a task in
> 
>   dm_poll_bio() -> bio_poll() -> blk_mq_poll()
> 
> long enough to trigger an RCU CPU stall, before io_uring gets back to
> io_iopoll_check() and its need_resched() check.
> 
> Keep dm's ->poll_bio() bounded by forcing one-shot polling for target
> bios. The caller can invoke dm_poll_bio() again if it wants to keep
> polling, and it also gets a chance to reap completions or reschedule
> between passes.

Looks good to me.

-- 
Jens Axboe

