Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E3D81720
	for <dm-devel@lists.linux.dev>; Sun,  5 Oct 2025 18:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759688505; cv=none; b=qxShSwFTZt7gQxuLIkf0nMjI76ypRsY8d905C4ZmN/x3pm7zSHPHZbN46LcTiwOoR6e6eM7UG42ZUTDCVTp0VI35zyZVPXQKt1XcXhCibFQUKKR9jkhj9qTrQdM2zfI87tvTub4ys2ZtP1pbyJu9ICatAtl+M9TKGA0gz/BPUGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759688505; c=relaxed/simple;
	bh=uOU6dzTimbtiu4IECYGdUOvNjgoMImEzw4QEXddckqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hTDmodHt6oKOaYtAiK/G/y5E03T6Acyvvl7N245x5v8kDTgeTqQ4SEjlcsJwzdo7yOehuqfGSSnHoyg8U/DyiQBA7UMGJShc9xUjq1J6k1Ai7oQkbt3rPA1iovIUutOXYBtK7oKcgmJ9sdd/oegIhB46T4qt6aI1ZPxfQcLcaho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ewpIPJdD; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ewpIPJdD"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e34b0841aso5979655e9.0
        for <dm-devel@lists.linux.dev>; Sun, 05 Oct 2025 11:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759688502; x=1760293302; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ue/3V2fkrdEChIWxGzBcqe64VcGsLo8x/jy3mcSPZOI=;
        b=ewpIPJdDJ0ScnY0fsV1ZsxqYG969JneQLOFD9UFscbMYgUUFVXXqp9Ma7BJvUtG68U
         tBLmC9UNVltRRYTMT7JNd630yLdKCzzO1XQeSC9iLtRP+iMfPbB+5cBnjS9zt0U+8B3G
         mqRWfK0AnoX2rbWaOeozqKouqwKi/S8+BORXhE3iYE+Mv2eiO1hGhtzpqrDjZ+yvJ0/M
         0zwzKnNl1Cqy4kvbSReGfbFDpZXpnnnNA1r/sQ+RhWVfwnzHngvYSd0/VyPh3v+A6ctp
         OvDzHDcRxS0iNK7APb4/FWBT23HnwKrBLZfpX9YyDdyoHW3As7FOLOeGfJpPOz6Ytz2c
         k+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759688502; x=1760293302;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ue/3V2fkrdEChIWxGzBcqe64VcGsLo8x/jy3mcSPZOI=;
        b=ST0XaqrTDFgk2tjbFyw3BJjE7nP0hznO46HSB6WkxoQA9fVunHMSuNErLaiXTFSIWv
         Wl7oNRVI4M8/O9w23ElETlsma/jdPO9Kjgx+5V74vyafvXM95YABLAl1xLFWEk4/e1vb
         jg+UU5cG5XwpzxxhLGNaGNg0UqyJO85WD1233JtM0QdgrBzMVrEes/wsTuyFdRHHwT13
         0fYy++wHqCb1d7DZuWteAqdt4HzHqTxuuc9Ioe3kQgXF6AWeyAOECSdfuBYc6XhvHLZZ
         J7h/ruk2mszpJsg14FxPo9CjegtylC7JqwMVQNgiTxxpgAPeDB8/wCGXA38ZqqG+eHM8
         pOww==
X-Forwarded-Encrypted: i=1; AJvYcCWtEXsUt9j6j7HPr2POtwgfB7JoGl2vCADdOZvpGBn2/ZP/z+XwZPGXV8A45CVzEShNpHqVS6Ocbw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywj0L7yb5wYeT1Wfi3shKYi8tJmF+rcYvnaZ5nxbADEPYUQeVuB
	hOXd0n6VYzdpcxDQuQbAl2N5oNvnEy7RQ9GmLnuNfG6KK47mqT10FWM=
X-Gm-Gg: ASbGncvu9xk3G1cpIKASbPj0VGKTG4YoopQnzargwgj1YYTK5erQbts054e4nP5FPDs
	pjV7B1AzVPQNrtMY5xJ3lR3blSvvXOEyGaot4d3Sgld/LjAf1sqwyVHRFA4jPpxwQU1KSLwM9Pe
	YGJ281U8oD2CL9saW7OQpqbPCfbUVz9S9FjNdm0gOHaJXflLuSRYkCX8qz0sa5bn59COWLZ0nII
	VFNGjhMiXVCfVRf2n1nAO6jzT9prMVNmFlBgAv7FaoLaJDt64MA/vk2J0b1eKFkC2TB3ZRH85s8
	3tAxPJItZG3OCy5Sp7ETNki83ua62Hb9YW6JjWqQ4qbsSJ9pAjTzt3H/vYN1z34bu6nOhGnjnJz
	S48GlYclnslkl8YQ67Dq6o/aEGV/zAw+lPI57KqS/G09sRmcrqNH4UT4lRo0ma1qRhAP2TRH8bX
	e8Vh3d5VC/1BPdAwTRAGdLvS0T5w==
X-Google-Smtp-Source: AGHT+IEFmJfuFhTkXOCk6z4tigJkNSZMk/moMGtkLOLj30f7qaU7uRZYxAiuaT5bJ7aVClqtkLoKlQ==
X-Received: by 2002:a05:600c:4fd3:b0:46e:36f9:c57e with SMTP id 5b1f17b1804b1-46e71146132mr35960895e9.5.1759688501643;
        Sun, 05 Oct 2025 11:21:41 -0700 (PDT)
Received: from localhost (120.red-80-39-141.dynamicip.rima-tde.net. [80.39.141.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e9762sm17287103f8f.38.2025.10.05.11.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Oct 2025 11:21:41 -0700 (PDT)
Message-ID: <df59e23f-8df1-4e4e-a610-93de7c6b5251@gmail.com>
Date: Sun, 5 Oct 2025 20:21:40 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] multipath-tools: add Acronis Cyber Infrastructure to
 hwtable
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20250910194205.145919-1-xose.vazquez@gmail.com>
 <20250910194205.145919-2-xose.vazquez@gmail.com>
 <aMMNV-_0nX0gOdXM@redhat.com>
 <c5f6f6b7957683f0d4a73d9162d05ab31b16e080.camel@suse.com>
 <35c05d07d399fd56f1baa4c30c7a3447fef2d9fd.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <35c05d07d399fd56f1baa4c30c7a3447fef2d9fd.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/23/25 8:22 AM, Martin Wilck wrote:

> On Mon, 2025-09-22 at 20:38 +0200, Martin Wilck wrote:

>> Not necessarily. path_group_prio_update() calculates the average of
>> the
>> path priorities in the group. With ALUA and groups of 6+ paths, an
>> optimized group with one healthy path will have a lower prio (8) than
>> a
>> non-optimized group with all healthy paths (10). In such a case it
>> could happen that multipathd switches to the non-optimized group and
>> never switches back.
> 
> Sorry, this example was incorrect. Only paths in UP or GHOST states are
> counted in for the PG prio. In this example the optimized group would
> still have p = 50, and what I described would not occur.
> 
> The example would be correct if the 5 non-"healthy" paths in the first
> PG were in standby aka GHOST state (resulting in p = 55 / 6 = 9). But
> that's a very different scenario, and highly theoretical.
> 
>> I would suggest setting FAILBACK_IMMEDIATE instead. It's well
>> documented that FOLLOWOVER is only for cluster environments.
> 
> Despite the wrong example, I still think FAILBACK_IMMEDIATE makes
> more sense as a general default. We can add a comment about the vendor
> recommendations.

I sent a new patch with that fixed.
