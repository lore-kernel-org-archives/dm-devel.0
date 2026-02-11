Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162FC355020
	for <dm-devel@lists.linux.dev>; Wed, 11 Feb 2026 22:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770849009; cv=pass; b=GzCkcIDNl1NA0YzHvy67xdC9TINuX48WzTaEsFFG6pBmeHBcoxAUOWJWpEgtCdmlfXeB4DRrnmOPI+rnZfg1xX1VGTBXUlxltz93WHiqdHXFXMyl8jZorQIWtn/urDtdege4YxsAQy7nUrqhJ10BQjmtDnPwRl+rSRLa7T3WsH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770849009; c=relaxed/simple;
	bh=pGdDWQqG1KFZxJTAs8F1G6rNe5pllLAyQQWQEejQa1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Grb1/OaqV5nk3nA3J7lF2nhqNZB7bRmBmvEOFjPR0yeEZN6mFlZRNwqjIeULqzuf19LDduWH6F8qeHjewXny3OhiMFwsTYByTWPYJEjluIL2HanH9sQAqFXhK+sQGW0/Ett3HWje93NFZ712tZR1H+FzHShafLYZHKprbzHur6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xYtBP/+y; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xYtBP/+y"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65a3a1740e7so1626a12.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Feb 2026 14:30:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770849005; cv=none;
        d=google.com; s=arc-20240605;
        b=fZ6jwGQjB7yTACiuAaGG+nQLhSPPn5NfsTTZznBvEQGYqr7jWoYkiKYdrqeKcjvoRZ
         bYZ4oPZmuMAyxbXh4sdH6WaAkLTnzRHSfLB12RMnIf/p43k0Vy/BBoH6SIQ7V5XIr+1R
         gCxL/PhhefaV8Ijios94EgP7BXJwjLwdECkTbz9DdnV95miKTZcJ2+GSta3uJut6AU+l
         duil0nAplUr8cIc7osjCH8mqY1sYArtSHVHzSqHO4v5abJ8eq1LCxSmG77gCzF+/xceI
         FoGJSXieP5DnIm4VQ3ZZ3mZFSLqKOuTKjEcnui6ds47on1Lv8t/grozV2MV+63VVoKfD
         l47A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZxVigXbvBhhR1mA0KIKOZKOhZET0Gp0En0HjTBqR0nY=;
        fh=dTAHK+0abp6vtiCw8MzE2mrS5eqwMiO7Tz4d9qqUk/4=;
        b=NxQVKDbxlYwJ33XedqyfpPY22WbaWDU2BQgLaZAKT4oFV7J2H9AhI0rfKRWkQiy2y+
         stNzSVkB90Mjt+VrJdIfGmGApTCDYa21f4Ja7CBfIanHY/NNDRV2SwLCVyZAxc1szoS3
         O9Fk58BkiDMlbcytbiwlkNeKsb2M1RgpalGzmQKsu0RBRU329AuQ0XN0pN5qlP16RlBu
         cqAT+KW6tNPEVZux/Mr2XV9j+ICK/K4uEwOWOOmpgDRbou4ncjgX1qsKFcxRtfiEOpub
         jtCZI4Ly80AQkinzWkj+40rNfoNkpyn+DWooesBgYh3UaAjiIEtwfXlhxIvjYmNIZUW1
         TR6g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770849005; x=1771453805; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZxVigXbvBhhR1mA0KIKOZKOhZET0Gp0En0HjTBqR0nY=;
        b=xYtBP/+ysJVR0mVaKrEU7ji5qeuELvsiww4azzd/xmOPzu6fQ6DvCDztn6IIbURJCT
         BAfUXJaM5T9OuiXzJN1xLICprtrB8aqonJKvdf5ZLUPTfZqCFcVqFs3r4V1n0BwIOGy+
         0gmzqGdQJXRf1V2+5IrWn5ldbF1zx1a31IaCWha0TF5A8GKHsAdIRBor8IsavkWB5kFv
         NSGebGrUtMofkfrZ+nT86Q01Qb6nRbD3tk7nKx4Lc/qESEscEgU85Lik7SfG5kbdMmUP
         VZ+7KwHpDA94ucX0XD3gwCt/yZEcUQQsC6zTNbN/8m+SEyduj6aVkVAQylTrM1tfqsHZ
         ecOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770849005; x=1771453805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZxVigXbvBhhR1mA0KIKOZKOhZET0Gp0En0HjTBqR0nY=;
        b=neezZaW8xoYC+G/fwQ6dpvl1R2q/XlK61KAaJhHXOkHrX/EcEujPMIPXd9K36fu/KC
         qb0XHl7Or6LCFX06Ksyu5t574fLmTeHEg0jDfzLb0dK4+X9Ckkf/jYMnKa9er/avXsdX
         KZLTPgygYIyCFFWIYg2I6q+vcWHhj1OcCRgNSU9Aywiy9NbgvbdingXtkrIYf+MGY5i+
         bNU+aW+vmxHUYhNnsBLpCCK5YGNYpS/yISrJHDe1Pyy2ugmtvQHk8+VxvzdD02WhWX7+
         0C+Zb/WPzbi17kX6mK0C8XjbpZgsyvISJcUgjMAIg0W66h05On5eTkw8yaYH2mtCBSrA
         lz0w==
X-Gm-Message-State: AOJu0YwDDgIfTiV29gh3yuy/rtqXqaEQzyz4y4V7tGWRY7C1G1Xlnp0m
	WECmb6A8ZdttJHP7587UIPC2O5BUkaGlj0WXHNuYQKdH95LC/2xx/v05vUADi+f0LHctLm+Toh0
	zT3rbUVq+SBeJWKPxlwAUTWIFSJcwXFmpi/hSEOPoCSOSXINH8Wbg6Htn
X-Gm-Gg: AZuq6aJGCPNrjccv/SoriKh8i39ObBTJYJ6nyo4OVn2RkXP4EK+RaX2Zdvl+oFXg7pz
	xUdOeOm3DjB4GifQqDaDDRPnH2u/U7x5cXEotbJpsn+5czcY/gIutm7p2XrmI/gdGSpklAg8htp
	8x/Ds0l30A9dPdukmWvOxkBT7nZ+x4enjATEzFXGs2+h0zQxd/tiyImHTfk9e3un4FzvNZan/25
	xHtC22Xz61M41F360AeCVyzGcr9wVThIDczPNOaOydBT+YmrMDcNgtePpkeskcOV8pKAli5ZdGe
	BZkq
X-Received: by 2002:a05:6402:3549:b0:659:785c:d3a5 with SMTP id
 4fb4d7f45d1cf-65b9912a432mr14930a12.8.1770849004949; Wed, 11 Feb 2026
 14:30:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260206045942.52965-1-ebiggers@kernel.org>
In-Reply-To: <20260206045942.52965-1-ebiggers@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 11 Feb 2026 14:29:28 -0800
X-Gm-Features: AZwV_QjXUSjV1pv6Y68lqJuBrcv9hMb-19wxW5nMb6HgoGHcM1hIcT1G1aOVgPQ
Message-ID: <CABCJKufKYMPcjiviWdGR=h5HVAmavwacsSdMNPQaaXeeL+GoFw@mail.gmail.com>
Subject: Re: [PATCH 00/22] dm-verity: more FEC fixes and cleanups
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Thu, Feb 5, 2026 at 9:01=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> This series applies to linux-dm/for-next.  It can also be retrieved from:
>
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/li=
nux.git dm-verity-fec-2026-02-05
>
> Patches 1-5 fix bugs in dm-verity's forward error correction (FEC):
>
> - FEC and hash devices that are too small were not rejected.
>
> - Corrected blocks could be multiple-counted in statistics.
>
> - The erasures array was significantly oversized for its use case.
>
> - An out-of-bounds read could occur when decoding an RS codeword whose
>   parity bytes span a block boundary.

Thanks for the fixes, these look correct to me. It would be nice to
have tests for the edge cases though. Perhaps in the
verity-compat-test script that's included in the cryptsetup repo?

> Patches 6-22 clean up the FEC implementation to be easier to understand
> and improve documentation and log messages.

The clean-ups also look reasonable. For the series:

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
