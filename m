Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A2443C057
	for <dm-devel@lists.linux.dev>; Wed,  3 Jun 2026 09:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780479144; cv=pass; b=FhmiAHEMoW4n/YUBn/RmHaT+yp4l+N3UJLfZOh2LQqmcep1PHBr8TCoqPS1gOZFEfanQ79yFb/B6llbeLYiL4NYQb9KP31E7r+CoJibcPIH18pUxPV/hKbXbzbknLuJFnfnFzxI92DJJLEsg123oa5eKRar/P2iNE3xM2EAcQ9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780479144; c=relaxed/simple;
	bh=vAoKifGRxLhke/fWPJdfHO1Kz93iORW742nmZbi2bWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ue7vjrvOtKsr9ocl6F6x9XwheZnv6kgvKjVu+5qg+aGwcO1GhZY+Bt3fvH3QjF8/9m7SRh7MrDkEdK4uwu3m33aSfIhTWbFEai2OE/kiN5jRzfYcPow1ZtihUTr3Ivcl9WiNLBn0VhDdczNpY13Y4mWAUpqFOGbfkGdDj0/9m5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ghgVAMIM; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ghgVAMIM"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aa2c25c632so13606761e87.1
        for <dm-devel@lists.linux.dev>; Wed, 03 Jun 2026 02:32:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780479138; cv=none;
        d=google.com; s=arc-20240605;
        b=QHy9I4YJRrzMRU9R+X5RJsKhL0yrnrR62mCZpTm9Upfo3IdcBsQdgfqlHXgCW5cWYe
         h8j/94B9hMmInuRx83xEUBA8cbQoQZ3+FsxFr8cOxbFUlm9b/gIaAKB9SBehQHQI555M
         XoA9d0QVeeXShtVnoJVWQfMTYl/i6yTtRqwbcHV3wI/YxVayDbq7bQ/vS0ZP4NZDuhgM
         POWQUWkdd+0D4rAl1FIkkwGOZtLrFY/kNvCuY+dUz1z2LgXw9ugaBpHl72Ao+VUPYohF
         z+En43+lLAYjv33D1ShpfvGB7N3EV5q/V/RYiKaRhViUg/ulzzky6FAvXMfNgSRJkUBv
         4HIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p9S+45Uh1neShXNhH97CXA76ro1rtjpvrZHIIIa4kC8=;
        fh=STMz0KyQ3LJHs2/ATnNNlkZdGrXZ3Ht5QP6rOe+a0WA=;
        b=beql+T3OH9uOql8ndfHBzG61UbJEKVwnKtTphH14q7xOLo3u1MO29L83W5wpmE2pJB
         vFrUKKLtho7OjBhAgzaakvOMgOdywFqpBMeN5uJ/U4WCIXVqTh8cY3DcXrFfIe7SlD4X
         41Kka6QLcHyu1kj0ZBY5ow23cXgAAHcTsrBPZstr1h7SzYKUqFyDD0Zy4TswQcoE2uCI
         nVw9U0lj9yHFj/jeaEzNgcNhEgL69KgfppZv6STXDPkkDazJG5qIUluO1KgGZqkIsVkq
         YP8ZxF+/aCAG+XHyQAAf3uHJPcIjwL3mqvjnj57r6LIU1YNnbd1lJCVVHt40Deruz6jW
         jesA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780479138; x=1781083938; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p9S+45Uh1neShXNhH97CXA76ro1rtjpvrZHIIIa4kC8=;
        b=ghgVAMIM75k7lbAqyzvM/FmPhpnP7M9RsukfPZ0E3FAXt0l9HKBkPgiv30P1XsRdrQ
         Py5xXD4TXvEa+T6Q8ugrZ1+W2Wbd4Zg39kY5WA9nueC1lcqs2ZS4EijKFNH2U3WmEpcL
         6H7Yq2a1mH00zmo7LaLW8U65RLgU9JvQAdD8H1QqwGIeISF4ri4hI6y9kVmB4NLXv59W
         2g53s/QORV5ctGhhewhGp6N6+LuweQxVNAHoaAfczaTI9b8idurtERcwrxd5ICEHMilZ
         xymkhE4z22zfNZAiG6Db34CCXJopw5SI8Crf3POaVUk9pC2vRVDHNDVOwd+zPqtIkMbJ
         8Mxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780479138; x=1781083938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p9S+45Uh1neShXNhH97CXA76ro1rtjpvrZHIIIa4kC8=;
        b=eqheFngBvhxM7wo9T4e2eDNLa3T+hVV9SNHnDlBH7ycmnPa4+EqpA2YeHGrrnSvFnF
         6h416wh1Y6MNAhC1E0PLlmf8hXVtzIYpdVkY0mCnqIELlZ+k5EGge3rQtzdm6CvFHalk
         lG4q+AEqu9tX0bMReWxapt4jK9BTUihGbRkn0AkJd7S6OQd3DvfSm6mYw3sMuu6qY+oU
         5uO2Fk8TrV9Tf9VJTcwhzTB2caMMMYGWrdlZQoZpmSu+HMqw5ttto0mUpFPfw4HJGHDu
         5QN0d9wg4gLl7qABiG2pUF90XW2CMXn5u1Jt4HKzP/gSeIotltqtxaMseIGNsbyPq8/b
         uzog==
X-Forwarded-Encrypted: i=1; AFNElJ84ME2H6KIlWUXHoWolCsrzlunhHcq177le25ngVZDQZj5xrrHYSOpnV+2lBUVTVVRUyQNU8uL2YQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyYVsfLva4t3GVPDQkofP6brGIDOD0IDuFhmwrs651kYQOSeCMg
	HAeRfyaMFeCXAKIHA/JUJbak47TGfMULoaBLFdDfb5kwQkUKgddKdrb7oGjnroToGBQeQCEtyXM
	R8IJJYeadD5fS0Fjoz+83EqcrTgYGRvnC2aTlVZPjwA==
X-Gm-Gg: Acq92OG6fkK/olSSJceLH/bZNVSVG38UHGUKsOexX1qdfn3e0ryYma2gTN6B7odsDuw
	/FpyeazrqkNW7LRMmVa+flTCEQy8bQ2KICWI5CaermSHdsVUtLQc7FpM80PrnMvW6/DBgXf3JKY
	OjDCaAGDRSK5IQRdFwnRN+SsLW2uy7AYoNgNP14Onfw/CWl/Q5PFrk0xcFnFZwSrjjagEKPDpnR
	AGUjGqWoDTPZehaccacXsX7Kv8lPqDSoq0szDQW2pPd/zUj7dkVZGlNY/ghcnMhuwIFy5YfSZ/a
	SN6Mx0vG1UMuiCxfnt81hShAB2tUGrrPTdeyWI69QNHq4ffTGnA=
X-Received: by 2002:a05:6512:4387:b0:5aa:6290:f78d with SMTP id
 2adb3069b0e04-5aa7c09607dmr747767e87.2.1780479137557; Wed, 03 Jun 2026
 02:32:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260514150122.357883-1-marco.crivellari@suse.com>
In-Reply-To: <20260514150122.357883-1-marco.crivellari@suse.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Wed, 3 Jun 2026 11:32:06 +0200
X-Gm-Features: AVHnY4JpaT7HnBaB_Nsw2vC2-cGaRj89xpl3XY_q8ezg-I_99O4T3uxALJvJGRc
Message-ID: <CAAofZF5mAr4iFtiv1cvS8uARBe7XrDwJCH33Qi5m8=OHyF0=Dw@mail.gmail.com>
Subject: Re: [PATCH v2] drm/bridge: anx7625: Add WQ_PERCPU add to alloc_workqueue
To: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Andrzej Hajda <andrzej.hajda@intel.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Robert Foss <rfoss@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 14, 2026 at 5:01=E2=80=AFPM Marco Crivellari
<marco.crivellari@suse.com> wrote:
> [...]
> Changes in v2:
> - Improved commit log
>
> - Rebased on v7.1-rc3
>
> Link to v1: https://lore.kernel.org/all/20251107114318.163015-1-marco.cri=
vellari@suse.com/
>
>  drivers/gpu/drm/bridge/analogix/anx7625.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Gentle ping.

Thanks!

--=20

Marco Crivellari

SUSE Labs
