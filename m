Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF47314B72
	for <dm-devel@lists.linux.dev>; Wed, 11 Mar 2026 02:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194856; cv=pass; b=CQ4T5M+QMM1/37QkOXhG3n3YaiqUI9e3ZjLo4D9K6HvJIKwLuZw2vLWBhmIALKyy6REd4OIWyYg+A7btEh2MJN/FpMFxd8tNKEuzuvFfHLFP+Jet/8KUj22vEXer72n9bSU8bb63yF/0TOKg6amLSS8WNX2vPhspl27u5Cx06m4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194856; c=relaxed/simple;
	bh=8UJnLa/DDQ+b65RDSHa97nR/Rm6zetnRjswOkVb13wc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=byGraMQCie9pYDK7hyfJCwHVY6+oJ7d18FyYUD4bBwNC53+8/gHQFHF3kdMJE3gJYPTxGZa2ZdHRETsTevyL7LHCX2hAY3P8TZUDfnw+tebrl5xJi4Vj1Lk8SmBVyhVVN3qEQv7ELWcDfeD2EOtSNSbyNBwOa4aP39b6M7eyl6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=G46rxFFc; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="G46rxFFc"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5a0ff30b240so8038076e87.0
        for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 19:07:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773194852; cv=none;
        d=google.com; s=arc-20240605;
        b=Q4zZBWE79UQ/XZkTCNehZLgm2o2MbdldVjI/DH31v2EgTuCx2SFZN9HMjbgSxeqtii
         593UGIoWeNkhXy7hz0AU4BQ+Xg8hUKITCKv6WI0NiMGSQrVO2WiWmwkO+b7bU33y3mcy
         MsQMikZcPXp9VnKOWrbXIw3PoC8E0ILkm0HRiI6ZAmsQuEwf0VbKaGm/+jhQhzS74ect
         O6bevvANbks8CRQbtEAxDjwks4kvV5JSgxStpYdow9CP9EoO4nyTnVfFhdrp+/iJhO3Z
         0BRDVYbD7PO0fZqNn5AZGwB6iJO2yNHyjl3gj5nofbZH61uQtkVetO+bFXlLrgEOCLK4
         C2mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        fh=uhshGptzCJ6UQzSGbBtEVore9z7zlFONFf770CwOOiE=;
        b=jipDIuWezXD0ZzauUUelUaPVmTCY8UaGgjvhX3dIxf7M777421p8sHXoGr76WskMG8
         HNta84bS23WstbIa69yhVyyMD7wHFIyYdIN4iEXGBYKZvyJdudAXDeyi6ClwQZYDKt4K
         3YnSp9UIcyOl3nqu9UUhSO9tBuHE4psy3LMWqkY+DzD5/67jsgjKob0pNSnb2IZrdHbB
         X0YPoYtudWmmETHkQk3zhCf7cDuR5HMDVgDYkoYX3KOKgjYhBTAjAlNp49KPpTxn3TyC
         9a5FYwKTQncZGPvfL5GORzDZPsfFAjbwWrvS6vYfmDj9GMbb/yuaa4D5GdqRbBcMuhE+
         VBMg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773194852; x=1773799652; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        b=G46rxFFcX1hnQKxUUrTijJdlDpB5OBfdKVt7tJqloBNXcNg5JAjWvjlGBTrQCSFpEL
         kw5r/kEngKAkJ0pkN558AqUScugTYRjvdhsBLXq38oLpcnNpxGDuEjo6TpPJTbZMKzhC
         YhKhvGGnSCYDK9QQnvadjQAxBlN7qho59qSI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773194852; x=1773799652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        b=ob708F3+kc18QmhURELqvhTQJiuP8ua2TY8tEBLN7i13YWKtNN6ilL+bmw7ixcNhSQ
         R2cxH5iu0jbsZMbgwr4NVp0psMxUeWGJRoXEBk1M1D6cqlxxcRsirE19sO0SOvSCik/f
         sd6rA+ACu/zH3blD5ugcHEBwK3qPaOx581EwTvzqQOCqhFYkWhqcw2FUFWUm2q0RKwo5
         SmXmBcAjTYxWaS3nuZ40qFPfafxrGY/WEnOWIx5GHD2rQIgKx3yZzbvn5Kyi0xMiHwIm
         xCptEM/pTNtePDml+FX/VDdNmNruOpXLAsJbeTxQzBT4X5zstLlZI+cbJr3pvCfc04HR
         hwKg==
X-Forwarded-Encrypted: i=1; AJvYcCUpylOvq3dtmy279l7sA/gDVRB6x3gYw6fArkCRUNje1xhW+81fE9ggCdBCCEfaWiynmiWYFfQaCA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6r9qCjfp5omqVfmZITVSxhu3F/bDy/H90yzTl4/wbsexkvqJZ
	S7wF3VfUQbG72J4EBe8X8y874JokIQfKBpuGx4ujwYbTj2jyAvfPUxMSN3Ku4hUA7nZIpDE0m0A
	tqy5bsHtSQkvfeS1t2duirklvy5iR0d8f2qE/JB8D
X-Gm-Gg: ATEYQzxf86Y/Ze6VO57d1JMffKoZ/zO1t70Me2bWTPKWvSngzncvGKEjRjCEgrHl8r9
	hsBkTNIJQDwCToY3E0K0YACA23jgrlxwHVExSr7QgyIzRuiFN6EIRbDi8PJMUrZb3OeMBrxSVJo
	CI9S68ro/9YbZ5mrl4IJuEEESAJIblnfnTxZPY65yVip+npgv0B43sHdnmiAejdDAP8qK8wlzPW
	kqLqZFkS0srLZJUGRyJmNT22gNFEKsQtIuyaePLb4KGaf6UHLps8S2BlcScUsVihtI6TJHUFSzq
	+HzbbixzSg==
X-Received: by 2002:ac2:4427:0:b0:5a1:3134:9bac with SMTP id
 2adb3069b0e04-5a156cbd1bbmr169453e87.28.1773194852284; Tue, 10 Mar 2026
 19:07:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Wed, 11 Mar 2026 11:07:21 +0900
X-Gm-Features: AaiRm5028PWt8n-JnveiRgn8oYMksdR_-_nk4JOkvxMfplWs-GDr7RRk-OxICyw
Message-ID: <CAGXv+5FQAVaJjqhv+Xq-ysOc4SHQn2mCNTgCAp8XocmWBWGGoA@mail.gmail.com>
Subject: Re: [PATCH 56/61] clk: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Michael Turquette <mturquette@baylibre.com>, 
	Stephen Boyd <sboyd@kernel.org>, Daniel Lezcano <daniel.lezcano@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 9:57=E2=80=AFPM Philipp Hahn <phahn-oss@avm.de> wro=
te:
>
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Semantich change: Previously the code only printed the warning on error,
> but not when the pointer was NULL. Now the warning is printed in both
> cases!
>
> Change found with coccinelle.
>
> To: Michael Turquette <mturquette@baylibre.com>
> To: Stephen Boyd <sboyd@kernel.org>
> To: Daniel Lezcano <daniel.lezcano@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  drivers/clk/clk.c               | 4 ++--
>  drivers/clocksource/timer-pxa.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 47093cda9df32223c1120c3710261296027c4cd3..35146e3869a7dd93741d10b72=
23d4488a9216ed1 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -4558,7 +4558,7 @@ void clk_unregister(struct clk *clk)
>         unsigned long flags;
>         const struct clk_ops *ops;
>
> -       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> +       if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))
>                 return;
>
>         clk_debug_unregister(clk->core);
> @@ -4744,7 +4744,7 @@ void __clk_put(struct clk *clk)
>  {
>         struct module *owner;
>
> -       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> +       if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))

clk_get_optional() returns NULL if the clk isn't present.

Drivers would just pass this to clk_put(). Your change here would cause
this pattern to emit a very big warning.

I don't think this change should be landed.


ChenYu

>                 return;
>
>         clk_prepare_lock();
> diff --git a/drivers/clocksource/timer-pxa.c b/drivers/clocksource/timer-=
pxa.c
> index 7ad0e5adb2ffac4125c34710fc67f4b45f30331d..f65fb0b7fc318b766227e5e7a=
4c0fb08ba11c8f9 100644
> --- a/drivers/clocksource/timer-pxa.c
> +++ b/drivers/clocksource/timer-pxa.c
> @@ -218,7 +218,7 @@ void __init pxa_timer_nodt_init(int irq, void __iomem=
 *base)
>
>         timer_base =3D base;
>         clk =3D clk_get(NULL, "OSTIMER0");
> -       if (clk && !IS_ERR(clk)) {
> +       if (!IS_ERR_OR_NULL(clk)) {
>                 clk_prepare_enable(clk);
>                 pxa_timer_common_init(irq, clk_get_rate(clk));
>         } else {
>
> --
> 2.43.0
>
>
