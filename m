Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C476E3FA5CA
	for <dm-devel@lists.linux.dev>; Mon, 27 Jul 2026 11:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785150531; cv=pass; b=Oru8jeI92CeM1AS1t9KfsCboX+MUgbLMD0toQYtzRElLTCEf0k3/rO+Mcy+w9mnK9NJNVp/pLMbJuPEGg4Qpg+j9mFbbJjZ6jsoU8Q0n047BWgIsyxK2DSrKK1pLGn2YP4gwMJf1l+8DchX3chqea6+9v17+gDwQN9VUIAu4MWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785150531; c=relaxed/simple;
	bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FborLY8Cw5H9vEg5FDxY0K5eWltd4Yq0nGCwmkPMv1jT4DnOBmLCNBo387tn/ozCwfUThrlLpKZbiOfUHLTIiyBPw6P8r/5RiRGVVPQv3Tk/0+gTVt5HVXxlQ+XBs176vTqZ9N+Inb4ZbjXYfm069xEQI+GHtVi2Shd5zzXsydw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gq4W6o3b; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gq4W6o3b"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81e69a2db34so34332947b3.0
        for <dm-devel@lists.linux.dev>; Mon, 27 Jul 2026 04:08:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785150525; cv=none;
        d=google.com; s=arc-20260327;
        b=jjmJpdoqN+INMXWGO47w5zjj+x1B/v117A8t8LLwalLZFjHFoKFQzpBPHNW2k3b5fG
         RHlFOLI8KiP/OK10cWAzNyssrY9/h+x5cY577A8IBPNJh7qfSTj8rRegHrtgeB2IsTBF
         VJiudqMd1g7/OgeXmvNBxAQqIjsSuNYH1VwBRtwqK6B015rPxM9aYlxTiLSSf9AnMtfz
         d4FG6SlDP9grtyk/AEm0BC/4UeQ60Hp/kTuNqeLJZD3EeiEJtz3CAJHn92PBz5Qny9h2
         Zff/DiYXcOscbMjp4gF7+de54u5Mlq9r7zlvgO7lN4NDpTuvJYwnKU0eLrgHUBmdQCtW
         Rkfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
        fh=OlORlVjWIKjMsNwQj7OoAJHzAgZg5i31oEzMyO6qW8Q=;
        b=g0W7oLLX1QYY8Ma9+Nf2vputH7y/SODMGiqpsSxlUQ0zfdMHn4rYweNoAV0+rrikSd
         F9LhK796LgUqEGBhEdMjkAfuwgiTi6uiaUWIEJhvZaNGen95ruMgSWADIH5FtgidngRT
         3ODqxryftUOUgwvShUJx09tVi3msqIgxaKSIKim3LtGPNTcYBy+lHzue2kyNgAlq9Tus
         +NV1FnAosCpV5yJcGV2q1ubvbthyr2v09kvU9Brr6ku1fOQlQZ0KAiha8+dIaMlWGNQW
         rgHPQjkWjzOdFKaCIT22ClZ/g1l+xDb+HE+wqMYhy6ekAuh+K06piD8qYYXtL+1xEQGo
         fuzQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785150525; x=1785755325; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
        b=gq4W6o3bEozGbL2Fp2OEkeZYvKn/32uuhSoG/4R492rs+XD0NGOW74VNLG/bmhcld9
         PfCSRzOKGje5vA4z1+gfkJDVNq/uMO46wo1/+GLXfqfZHHiMl1sdMkQoMUzhVXwTcmwG
         xSltZQblhx4t9jNKdmb8mhIzMxHC0tj0oHBpMrMSLvRunY9/lREJZSJYc0DGgS3NDnHu
         HQ0CSwXvnYIMzqNVPDQqBPA6yKDsinGEqXGbDq9z77ShPwwcRKbv5V20fkdjltgeCR2m
         QWA845S3nHHZE+WSeVp9VfT6bbEKwAhEt4sAW1FbvKiwY1VJ4FWELqo10Pz33ZtyDYQj
         Poww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785150525; x=1785755325;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pV1TDUaa2YAV2kxJY3x35Y0FQXGiZRc6WWYevwzWDGg=;
        b=bttBtirTwZO3WmxXvDvt4nrcllzI9P8aNKVG2S/1laF9pvRf+D5ipLV1X0JntNtU6A
         t+6gNUa5rN3jknG0b0Qlw0ulz1cHmlzgvzaQVJd/ZnoNgechDvItFiK0A7c5X0nkzFnw
         wnHHFxs6DDT+BRmgvKqadjUc7xoU6Ggbf7+DXXBvKbPPr0yfWZBn/EnvDzS2ruR4SKKf
         nuiNpv4gJhz86E+xkYrEvtM0pDoMUIGEPLlO19pS5Pahs4HjDpC1/U9HYTxETOmhcDgv
         nVYzMyM8oPummDeEtJMISh++S6L0CTvbLkyp0i4O9VCpKlyFDRW0taZDBgJ7lHac0cRs
         /8jw==
X-Forwarded-Encrypted: i=1; AHgh+RoLmLM67RfiMRgRDTulMfT+BvB0EUhUKgm19aifksMCNuhabyMjpkteHiMK6NFo4adSyApwC8sqrA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyMJi6r71vJwYIHLFrf5tEaNezdRXb22kXeuAvDvjRgdN1VtCQo
	lPQ0iZrMd34GM9/HKFPLkZJLUErCeXAVIEZJoGpB+jsew9Ps/PVbEQyA/Th17Z3vJYdkbtAYQ7F
	Ss87z5mAscxDapi+zCER9bzHA5P5Xm0E=
X-Gm-Gg: AR+sD12fPoEnBEGB+/l6Cp6XaNwHf9lLqWV5Fh8aR5W5f4pe+AB6bRFjvxTYeTsuqtE
	/vBDSwyhjrHZHR84s/q2JVSpRbLsLqfgt0PiQMmXidSxihie4H/CFrbUuAHdi17AsHMe8oMokRj
	mJfKkYlDfaSJK9DYsrhGm08KdmgG0iSrpmN9QfSxT3zzbFipt+kgF5VScempMGC0kps+Yy1luYE
	4jSxNQSs3go9JVYZEzK46IxgNu9l0UDUC9ghfIbnZSDSv7y0Gmxj5WCJ2s=
X-Received: by 2002:a05:690c:3747:b0:809:86c6:ee18 with SMTP id
 00721157ae682-81f69e3978bmr27868337b3.37.1785150525277; Mon, 27 Jul 2026
 04:08:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
 <20260724144822.6af8213f@kernel.org> <0ee1ef4aa7daa908bf28397ccc639c89b6aabd9c@intel.com>
In-Reply-To: <0ee1ef4aa7daa908bf28397ccc639c89b6aabd9c@intel.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 27 Jul 2026 20:08:33 +0900
X-Gm-Features: AUfX_mzhfgKW48GB4CRuyNKliFu1x1EH8aDGDqYePXeE0rGOBX3Wid5IOU1hKpc
Message-ID: <CABFDxMFMOAZ_3kYxEGCutnGt1OSSmgvmwx-=M1RxGc3VGKORYQ@mail.gmail.com>
Subject: Re: [PATCH 00/36] treewide: remove conditional returns with no effect
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Julia.Lawall@inria.fr, 
	Alex Deucher <alexander.deucher@amd.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Andrew Lunn <andrew@lunn.ch>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>, Borislav Petkov <bp@alien8.de>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Daniel Lezcano <daniel.lezcano@kernel.org>, David Airlie <airlied@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
	Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hans de Goede <hansg@kernel.org>, 
	Hans Verkuil <hverkuil@kernel.org>, Heikki Krogerus <heikki.krogerus@linux.intel.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Jaroslav Kysela <perex@perex.cz>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Johan Hovold <johan@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Julian Anastasov <ja@ssi.bg>, 
	Leon Romanovsky <leon@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Linus Walleij <linusw@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Mark Brown <broonie@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Sakai <msakai@redhat.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Maxime Ripard <mripard@kernel.org>, 
	Michael Turquette <mturquette@baylibre.com>, Mike Rapoport <rppt@kernel.org>, 
	Miri Korenblit <miriam.rachel.korenblit@intel.com>, Nicolas Palix <nicolas.palix@imag.fr>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Paolo Abeni <pabeni@redhat.com>, 
	Ping-Ke Shih <pkshih@realtek.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Sebastian Reichel <sre@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Simon Horman <horms@verge.net.au>, Stephen Boyd <sboyd@kernel.org>, 
	Steve French <sfrench@samba.org>, Takashi Iwai <tiwai@suse.com>, Thomas Renninger <trenn@suse.com>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Tony Luck <tony.luck@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	Vinod Koul <vkoul@kernel.org>, Will Deacon <will@kernel.org>, 
	Yazen Ghannam <Yazen.Ghannam@amd.com>, cocci@inria.fr, amd-gfx@lists.freedesktop.org, 
	dmaengine@vger.kernel.org, dm-devel@lists.linux.dev, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-edac@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org, 
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-rtc@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, lvs-devel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	nouveau@lists.freedesktop.org, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Jul 27, 2026 at 5:30=E2=80=AFPM Jani Nikula <jani.nikula@linux.inte=
l.com> wrote:
>
> On Fri, 24 Jul 2026, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 24 Jul 2026 03:45:02 +0900 Sang-Heon Jeon wrote:
> >> Patch 1 adds a Coccinelle script that matches the pattern, including
> >> negation and constant-comparison variants. Where a local variable is
> >> assigned right before the check, the assignment and the two returns
> >> turn into a single return of the assigned expression.
> >
> > Huh, I thought we already had such script. Various script children have
> > been sending such "cleanups" in the past.
>
> We did, and it was removed, I believe in 1a617a8475e8 ("coccinelle:
> misc: remove "complex return code" warnings"), because people just don't
> want this constant churn.
>
> It's perfectly fine to have the error case and happy day scenario
> separated.

Thanks for sharing the history.

I checked the mailing list. The removed script looks similar to the
new one, but it is different. The removed script reported a
conditional return followed by an explicit return 0, where the error
case and happy day scenario are separated as you mentioned, and Johan
also complained about this 10 years ago.

But the new script only reports when both branches return the same
variable, not the explicit 0. So, I think the new script is close to
the restricted version that Julia mentioned 10 years ago, and it
should be acceptable.

>
> BR,
> Jani.
>
>
> --
> Jani Nikula, Intel

Best Regards,
Sang-Heon Jeon
