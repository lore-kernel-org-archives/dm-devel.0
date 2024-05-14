Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA317181320
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 19:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715716224; cv=none; b=GnG9w79BcKfn24+XxvOIektDwSyM6MBFQGBg3BnuBqceO0TV6Xw/Bj/K0yNrG58m5acsterRrncg2Cz45oSotIZMFeI4zMl/Pqxt8bVouOXualxxmB/w2vjj45dkpNKOyEIemiOVXCCIgJ2Cc94FbNM5+r9NYHcqxFrCx96Ua5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715716224; c=relaxed/simple;
	bh=xCGobSiEZZKVIGvtlb17VkXzrJav2cpynpYO5pxHsTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fs2czrxxGI0radmSkmESPLj67Hh75ERXhVQ7k38fb0cFG6SsiNcVM3ELCOmz2LrB1H+K2FjysqXKQdDwrNpvlOBKF3PBSi7aR5DfjRB1jNcHpW+7elPckJPQAqfilsHlzIlpdXe7RKzh+bOgHk3eAAxICVu1dETHb+DAQQd8V1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=ONEvMiMR; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="ONEvMiMR"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-de60a51fe21so5994397276.0
        for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 12:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1715716221; x=1716321021; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkp4I1/EP34xCsXz894jXcfOHu9Xc+3+8P13l0GVrxE=;
        b=ONEvMiMRLOgJNvyZuEidebbOwrHllocwsrUEhY9VnB0dJaGe5uCmOund/ra+kSdwKb
         LeFJjtUe4ozMuEquPZojx8X3EDSDhd4VsOIsvA0f8ll6PPlhb9dJn+ZNYs23wQ5qCfxn
         S2z9ra5xAJWfA7zZTIbjRi3X/frwc1E4vN/qhECbug6Mmg9+97YxnKx+jk65XvMVT5i/
         LmH+ZdloLR/fLxTadne/fwjOqvmCgioAErwm9FXK5J28yeG8Tov2b8SAAMK9BhbADJYX
         AfOyyXwoTm6Utc7XQ89ImwWkT2i/54RGz1eXNxgB2dV7hBnxR2R6np/QiiXjFoRYf6Jw
         +vuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715716221; x=1716321021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkp4I1/EP34xCsXz894jXcfOHu9Xc+3+8P13l0GVrxE=;
        b=vIHZEw7t8F6qjZZdsg4kBqPQ7hL+5gg25FlOXObw63BZK0KYy5GLpb0nFjeZ9tZxo5
         pY3JsjEeksToCoc9qylPfkH3dZS54SDwri2/KLEqvsDJegUCEIiMzy2U02K/JerB6QWh
         /QfwBOCfpGmLXKYLSsvMHJicBhTJCIkMQStAbgrYLJg0iFn19P0MwpQt48oJg4CU/Ynt
         l+AsprFhrEXYiTgEulj4P0Ncp4CveHQgSkqvnB/2PP7NKpEdRAStqKRJrsjcn8SaSSAb
         s9soSOeoLlpKu/9f8nmHmCBc7xzRM/YL3cqqzM0gHOyLnn+adJwhgFOaup34uz13JNsX
         ZVrg==
X-Forwarded-Encrypted: i=1; AJvYcCU7SsRe4zQ5dYylYUJNGyhxK4+FQeGkz+qvSzVXIlTl4w76WnP2mrcfcoA/28GYCgwSuESiWQItTxPv2blDnvF11whb2B4Louc=
X-Gm-Message-State: AOJu0YxGZ1xs0U39ZALBrk3t4mXCYZI7BRj5Fve9d0k79EoVK7eF5oS1
	xN2w3okr9kxpa5nqjtjAKd4Pu0VB020/pnuGYtyh2UjF4qPAjiJqM6t7r3XOMhUCB8zsXKzPCHP
	LARtVIXDBxBh8tQask3R4qNC/dcyhIp2ljGTF
X-Google-Smtp-Source: AGHT+IFWIy5UA2F/+z955H9aT1kkILcAstR0rQ1Z6k7ELYYSk3poMncJ+M812qPYw6M0u0TMB7AFkJo/BviRvM2KHkE=
X-Received: by 2002:a05:6902:218f:b0:dee:8da8:aeb7 with SMTP id
 3f1490d57ef6-dee8da8b092mr8719461276.25.1715716220678; Tue, 14 May 2024
 12:50:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1714775551-22384-1-git-send-email-wufan@linux.microsoft.com>
 <1714775551-22384-21-git-send-email-wufan@linux.microsoft.com>
 <ZjXsBjAFs-qp9xY4@archie.me> <ab7054cd-affd-47c3-bd98-2cf47d6a6376@linux.microsoft.com>
In-Reply-To: <ab7054cd-affd-47c3-bd98-2cf47d6a6376@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 14 May 2024 15:50:09 -0400
Message-ID: <CAHC9VhQewDL4cWXSiAgzvrHa8N5rd6TbhSCM3jRp29=Kmr3m-Q@mail.gmail.com>
Subject: Re: [PATCH v18 20/21] Documentation: add ipe documentation
To: Fan Wu <wufan@linux.microsoft.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>, corbet@lwn.net, zohar@linux.ibm.com, 
	jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org, 
	axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com, 
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 4, 2024 at 4:13=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> w=
rote:
> On 5/4/2024 1:04 AM, Bagas Sanjaya wrote:
> > On Fri, May 03, 2024 at 03:32:30PM -0700, Fan Wu wrote:
> >> +IPE does not mitigate threats arising from malicious but authorized
> >> +developers (with access to a signing certificate), or compromised
> >> +developer tools used by them (i.e. return-oriented programming attack=
s).
> >> +Additionally, IPE draws hard security boundary between userspace and
> >> +kernelspace. As a result, IPE does not provide any protections agains=
t a
> >> +kernel level exploit, and a kernel-level exploit can disable or tampe=
r
> >> +with IPE's protections.
> >
> > So how to mitigate kernel-level exploits then?
>
> One possible way is to use hypervisor to protect the kernel integrity.
> https://github.com/heki-linux is one project on this direction. Perhaps
> I should also add this link to the doc.

I wouldn't spend a lot of time on kernel exploits in the IPE
documentation as it is out of scope for IPE.  In face, I would say
just that in the last sentence in the paragraph above:

"As a result, kernel-level exploits are considered outside the scope
of IPE and mitigation is left to other mechanisms."

(or something similar)

--=20
paul-moore.com
