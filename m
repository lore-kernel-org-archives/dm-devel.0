Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09253218599
	for <dm-devel@lists.linux.dev>; Thu, 16 Oct 2025 08:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760604406; cv=none; b=HCrmh9OBwcW3zOegkuRZy6VWp4og5qjIHmWK3EKmqbfYU4bgD9T5ND/Wxi+knRU45dEwQiPclL+U3JLaO3T27oJLoHWav66vRUbaMPGlo/C5tZazgxluoKTknVtYTjRgDbeB4tpXsafB1ZfArnqQfnjBuxpHNj1Esy0La6aquOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760604406; c=relaxed/simple;
	bh=zKJla3ACgGmPzl+hkJoJpXyWkM1AWMq3ufRa9CQMYQk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=h11/pQOwPSWYvGmx6q5654n2nnUVjzMfnPo/HDReZ6OfB7Jq0zVkpWKBbzjRFkXHHbVLzxYuKH+vqso9jjrnLto7LF/ytiKvSbnpjiI4zRJ/XKYr57Vsu2vIY7CEHSRGAdDe+C8Tdilka7IeVHOl/EdRx2Iuv3PrVlovhIdCuaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oo4YR6e9; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oo4YR6e9"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-26e68904f0eso5133135ad.0
        for <dm-devel@lists.linux.dev>; Thu, 16 Oct 2025 01:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760604404; x=1761209204; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zKJla3ACgGmPzl+hkJoJpXyWkM1AWMq3ufRa9CQMYQk=;
        b=Oo4YR6e9+wjT5Yo32gW8dedvtywNrQEee2hPM5WK8OndgnM23/OMDTjwT0HqKP8SaU
         1dUcpVIZaPysBSF32sblc6aETOHJAi+Zm1Q+RVJj+ctuVyMuO2mDFtkHvRbtAUFL0qv1
         hiXH5hmsaHLeMTN5MQWipnaojuMLTtFDnjenypYll+99L5xRtRhhIkU2j7a1oJQ5QdHr
         zENYLD3onJmiMXHTaIcsoJpyYVddiI4sDlc5++um+kgirgIrxA1iV9plaD5RAo64WGYH
         4Ue0CQbr95L8Mge7wlLjbpo5NOAz2NopN4QfFok0uvvSp9wn7vew4SRNGtbf2q6pO9su
         46Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760604404; x=1761209204;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zKJla3ACgGmPzl+hkJoJpXyWkM1AWMq3ufRa9CQMYQk=;
        b=wsDF8W/UnLhsjnfn/WZzaucad5bcqHf2J7b8Z4SbK/PuyR6K+Mnt2OFO5zFjQnQ3LS
         J01oiNGvdmJTDtjZ1q+dBBeiFDOTc8FxUOmzUZAd3NFTgs65a31s1e7GI6eNAv6LHFcn
         BRmQPNEkIFScZOpd7CJ2Z9yQXOfUf5d07kZ7S2ScNouZaPcjqHPD7xq7V7GChHIyCs03
         y9oErd8woCk4yM9lxVw2HGKWS7yU5ZKy/OK8ic/xRHBgSvj756y88Imq0HZgGJJiKx2M
         vYbk0QtEf5wtkUOefq7odAnpBhyHfY4b0u3MeKPOrwSYVLh8EoG1tZMSKWvEyBUf+xZP
         SH7A==
X-Gm-Message-State: AOJu0YwU2Z/wWOMLC0Oidj8bBcghWXacmll1vOhuC2pTl4H3IM7/tTQ5
	TkEkfr/trCxCU6xDlMtn/0kM04uoCkpgNR/wjYTq3ouqvhSqn2EWRhHmNpprMuZkvp8Wou4H70o
	1hq7cDqj6kviS0kgL5Y9OPYKwZv0zlkY=
X-Gm-Gg: ASbGncuMo2y08RevNJerIIQPqszVjX6vgkKqxQmqPOXJapSjisqb5M1ow0trPjnrQfI
	C+coSBIizdfGC4/5SLfR63+ya7MDnV9niFHPOTsfggKJ5WIDfaiZtubFMv1tZnuXqVJkCE3PQze
	B/IsPlxU+oTW4WqgjB/g8LDvLL2D/Co5EBYZcp7fzhnLw13UF/JV6ZdudKT6h4dooBT2p3+cvta
	8W9tAKx2oEha71iRxLrw8x1lXbIcz0GEqMPegkmz45bz85bu8FGBzPmKIsmrA==
X-Google-Smtp-Source: AGHT+IEnBx/RZDAT34eFw3vjBdX78UmBvUoN7jocgIdtcdsKcEhW72QXC1iyMazkm+l6R2qKOSG0CGSEJDmLHdehuI8=
X-Received: by 2002:a17:902:fc4c:b0:28e:7841:d437 with SMTP id
 d9443c01a7336-290272c0474mr425898005ad.38.1760604404132; Thu, 16 Oct 2025
 01:46:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Lei Li <noctis.akm@gmail.com>
Date: Thu, 16 Oct 2025 16:46:34 +0800
X-Gm-Features: AS18NWBBdggTN_wxM3EgnA6RniMsmbvgOxum5AvUIj2pAHWAiYihH4yDEADg2dE
Message-ID: <CAMhKsXm7MuxnxRtH6XH869jx_eByOHiU4nQ6rXG+bX6xiAubUQ@mail.gmail.com>
Subject: Writecache target power-off tolerance inquiry
To: mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi guys,
I want to know if dm writecache target can handle power-off situation.

I've read the dm-writecache.c recent days and got confused. It seems
that dm writecache may lose data if my pc encounter a power-off. Here
is my thought:
1. There is no replay process for dm writecache. Every time
writecache_ctr() builds a new wc_memory_entry array.
2. metadata update in dm-writeback can not guarantee atomic.

If I missed something?

Thanks
