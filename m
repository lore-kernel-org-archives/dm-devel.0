Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E3541F7D0
	for <dm-devel@lists.linux.dev>; Tue,  7 Jul 2026 13:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783430296; cv=none; b=JmtnIcrq9hLU+ZE8wtSarmlFsxt4QO25kfTh20l8c5obGrVmUOEo0C3kjiNe9K7z7K7Why8R+o4qg1d93YRsGrRoGDdXWIX8idtpeSGh4078jRizKmJPUllUbhjo9hd5SA8E+ufvIVF+t+At8qSR4w0VPk8fGpLx8uuzXG0Kwj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783430296; c=relaxed/simple;
	bh=DJRRh2/pl1YodPLkMJ9lJkzOfXjea/5am9b5nEDGvh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hqqS1xV5iyZSt1TsgfmV0Faz14N2wK7fmVTK78ND0RiKDrYu+Ksb/gNoJGo7WSwCT05JWv+QSz3a/njA4dY3DTjNEAXuj3dYLLth6HkluQ226Ey/6E+G9WZdLOl9GhTl+m/pkDyZSb+E790zLXzoG9zHZmnAx4bi7GDoi67k4Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ch8Is7x2; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ch8Is7x2"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4629324e267so479707f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 07 Jul 2026 06:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783430293; x=1784035093; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WDZKNoe7zjGW3eRVEbagNJuzovlD+fc1ggy+HEORn/I=;
        b=Ch8Is7x2qSP9yeVOs3vB5Jr5jbJZAsLObbsbVw57lzSl3m9A7RdoEOhaEJoMc27byq
         0dx1wW6oi7LSfdpnpjyHTAcIsGpwkX6yZmwgSHl0YPsSHich3eFAPY3fb0yASHOtu1gq
         /HiUdWjlk+qYdv7rAUWuqM/GMYIWZuME2OL6LUHz7rq/d9LOa0Att+u60iTLIe+b48Sf
         HgN7E/ZaGPIS4f5llF2Xurmhol4wKgXYlDv2kWou8zOcaGI5iorvGmljbXTzwNvqUqbH
         R9qaYeT3qgXx8qJyQ+JbHrBEVEQcXc3fRrlBiU2qHx3h6EtNQpFI/8/FDIBpAnhgX8Ag
         fbNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783430293; x=1784035093;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WDZKNoe7zjGW3eRVEbagNJuzovlD+fc1ggy+HEORn/I=;
        b=j1Jbsf0QE1guoEr9KetASuq5h4iewknovxFEXj54FiNfFft3cFgxU8A1ZQ4CR1zynj
         efaebyV8lu4ddnv9BcKIvbeLv3y72ukJY+kPyaVa8kfl+r6M1aynTv0LogrfzR3K3IOl
         ODqLfpyzTvPkxtnqmlvqSwxQIMIChNaklGDT3VAGuUPhsTXxvKPWStBCsK4KzxEKGBYB
         ZHxMBaNQJNJbtAXpYF2Q5zDnVbjn7ULkIxqG8vCcsiWEh/y384clKeNcRtGnwrBbtm4Z
         mqditaQbtYeQA2N7q9ArM/oB/qQ4eMoQ0UUVdgAA6gYcem1JxpzR/YQfsEfwQghvdVLs
         TvbA==
X-Gm-Message-State: AOJu0Yw0FNHTtaNHaPjrcZ3Otuwc2wE2QrgoqFwwZrxPjpiP3eX5rD+Z
	dpA+AZBrbwt1aLUiiwd3Kek/zGw0HAQ6bSQITeOB7rJpPjt8AnD9rg8=
X-Gm-Gg: AfdE7cnVRe6A3v8H0SUYMSzXBPJT9OVoZ1iziwlTkFqXfPOKSjYu0JrNviIx+OUxfpK
	gplS9PEjp3VOKTxP6r3kD99tzvqX4rkeEp//7RDbxmC6BIgM7zOyfYY91zuDmU60fxuicJOBsmo
	G9ZV/cvFHOFzU7Ac9J4dRcSAdJK1XQs7WPUEbTfzXug0dD+Tp/EXtpUyO+U7yw/hgobX9ffjOnf
	DR7m+Q+6ZB/aUSzCin1ElWX6mnYc+RD/dkCP/L6AH6oY19M1hWbwlGxJu+GuG+H4mw0pigSnVbQ
	HGXlY5aAoYUOe9rzCGzJQfLVh5k89XT7gj4U9phWrLtTe7DXiv3AQ3PRBX9EyYHRQByW+1gdvwK
	ouK/77yCnGQoZXAYCL0OTbqw75eMUiStglocnVStvZCmkfINt+sg7jQ2UpBE8sy5H9a2w5N1SX2
	amcBeiyYag3ogtTlJkkVU4LfvXrJ79qI11HPNMze0zfAvUMrZl42RkOJnr
X-Received: by 2002:a05:600c:3596:b0:493:bda2:8d92 with SMTP id 5b1f17b1804b1-493d0f3dfa7mr137439675e9.5.1783430292932;
        Tue, 07 Jul 2026 06:18:12 -0700 (PDT)
Received: from localhost (153.red-80-39-135.dynamicip.rima-tde.net. [80.39.135.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0f3676dsm59237305e9.5.2026.07.07.06.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 06:18:12 -0700 (PDT)
Message-ID: <a657d0e8-faba-40d9-9a6f-5a44435926ff@gmail.com>
Date: Tue, 7 Jul 2026 15:18:11 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] libmultipath: make sure sscanf sets a max field width
 for strings
To: Martin Wilck <martin.wilck@suse.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
References: <20260707004817.1958264-1-bmarzins@redhat.com>
 <edd01616-ab8f-4cec-bae9-5f4e84e1cf59@gmail.com>
 <70cc82feb7bc45076f566d507a4da764c7bdf819.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <70cc82feb7bc45076f566d507a4da764c7bdf819.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/7/26 1:46 PM, Martin Wilck wrote:

> On Tue, 2026-07-07 at 07:52 +0200, Xose Vazquez Perez wrote:

>> Martin, this should be removed from iet.c:
>> "// Uses /dev/disk/by-path to find the IP of the device."

> I'm working on a fix. See my "tip" branch.
I mean this:

diff --git i/libmultipath/prioritizers/iet.c w/libmultipath/prioritizers/iet.c
index 97d35192..ab3e1f0c 100644
--- i/libmultipath/prioritizers/iet.c
+++ w/libmultipath/prioritizers/iet.c
@@ -21,7 +21,6 @@
  //   prio      "iet"
  //   prio_args "preferredip=10.11.12.13"
  //
-// Uses /dev/disk/by-path to find the IP of the device.
  // Assigns prio 20 (high) to the preferred IP and prio 10 (low) to the rest.
  //
  // by Olivier Lambert <lambert.olivier.gmail.com>
