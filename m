Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DDA86337
	for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 13:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771852761; cv=pass; b=YWuy6GA979WKIY6Cs7q/xHIQ6azrWyKEEWKlmufslS1e8q/EQuwpLtpvvnq8fPzZXXL5aa3JGtfneBPT6TB60okXIH+PE4EELGANgRRth/HwoZIrZ5MBrGBvwCpazhaUJs8jeiUjmXGdJafFPBBLPuFrj1h2LtfpDERZwWgq4tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771852761; c=relaxed/simple;
	bh=q0/6OHcjeWwhb/QiLiCKc76MvzKuN7UX4vB/hAZ/aOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nGSFyOB3j/Z+P0c0C3xXNddKZc1mqIK6RGAgUqv+oFgaY0tZQ5eEIUZ9f3krHw/NZ4SHX10kJhBm5x/2l0shGmlI5zEmXZMYlwNJQca0wfRHll3BEytFQ5roKPAZCwNUvLB3ziaNIfmfCiny67k/HwUGNEQk3hj1aa9qfSnh0d8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bt875uDh; arc=pass smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bt875uDh"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59b672f8ec4so4314954e87.1
        for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 05:19:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771852758; cv=none;
        d=google.com; s=arc-20240605;
        b=YoIG+inZgscwltYz3xq6C6L4I0I8gAmuDD582FaUucXSK1CCqIYHpQIhFG9tkODD5a
         ogX8sXMHBdz27A/lUYwLxOKQuNCSThV86LVRveIGAn7aLLkTUxlTRv0X4y2NylRYhKRp
         0psf4wcNgq72hS0vVKOsOLMrGmI9AOoq5ca1/KmezmNQs9doD/6tY5lLQ7FsfxSH/TFg
         szGdWrYs43j6VMjFlazxefxVCkTfMbse3N22BnDoV2LLZ/o8nD9XlpvpR8yMD0uiHv5x
         d1MtnzjB7H8LE5grcjhbVk8jVtC/EN3V1EzOT2Q7mO6h1GF1XGZ4ivA5ZvCEQpIefAzr
         1nxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q0/6OHcjeWwhb/QiLiCKc76MvzKuN7UX4vB/hAZ/aOs=;
        fh=9ub1vV+gyRIuNZJPWB2qEHGNo3L1cxc+dfuWHhJa1rM=;
        b=XSjbEi2LZNFsZ7WujFhDFOqJg0WmZUG71/VV582rDbiKXpHJ1AHurr39MTXdUtKWGd
         1RF9Plb2yMhJOr620vIhvN8oIKWW/HLBm9seC3Q+R8zCoZQvIFxkmZBXABe6o2y1smDQ
         3L6kPABV+/DmrfaiAfAptMgLqsnpm+62zHQS1ijSSM4G0Sg9mTAm3in/RUkJKQCWObn/
         u5ZcRT3zApsJJqJ4n+R5zfPux9YdNpoHxOzYyEAfYDbUj7bTD+sBSBLKmcFwzmjSij4p
         BOW64DhW042PQFO8LaxxUwdmnqXB8K6j0Et7mIiaIlJfQ0jC2l6AZYoJcKVxdlufxnLQ
         +L6A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771852758; x=1772457558; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0/6OHcjeWwhb/QiLiCKc76MvzKuN7UX4vB/hAZ/aOs=;
        b=bt875uDh+C8GFdEb9s2ARK+sDORnhYV5pTDt3/kaUWf9oPwmNT9LAW0loh0PNiL4NE
         GPX52XPLmvJWZ25Ha1w4ppoiUCP2/mwj8MDapmKzN8ov62MyVK9Bt7Fs7TSpyfu2asm1
         pfkJqOV1CDm//gs8CT1iG5gB06J6TLCv+Ab+7wA6jc6n5aComvQf7Mi3uYAQo+0SEeAH
         j0IX1638k+xvL++LMqHxXaBapi0XCu3KifCCXyfEcsxu5GtEQrlP3dv0Jtah0q15J+TM
         Om0mMTcHUgAT0BAU9iJO4NJLTYoGe6NGE+mIxFbeletUjAEaaXoRExaMtTfOcUq4taU7
         KsVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771852758; x=1772457558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q0/6OHcjeWwhb/QiLiCKc76MvzKuN7UX4vB/hAZ/aOs=;
        b=ayFPSB/Cq+ZzC8xpjpp13pNHq1qd+W2WDKaYF4Sk79hcaDvwMN7F0JOALM5oPzc45a
         LewZl7XqpVZz6cI6Gk7/9npIAhAlb0vNrMumj1YvG9PuRONkakgacXRtbzd7Fq6+hPaR
         doNQ7JhpmZgejZj0i/C7Fqm0/GiCG6sHsFOPvLsKZaVz8xqkJfafb6yfhUNIDZFlkVYS
         3HlylxEs3x0fYSZFEnqfK6tvIb0OLxDaJGo8cyeGe7aRxUmkcXQfbLijbNAdpWZQg3wk
         qX2TAMsaNuU/2alA22Eba/fkFOXm1UD0IoIvh6ytBSXI1+2kwnN0p+u+oggsH6SVLdnF
         GVCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAqBsFS775ZJIDaB/0oQQkuLt87QbgFwQQ/Yqt8pVYeuCBHp3D2TviJ8Ytaenl3t35GnSsLPSiUA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzQDbIj+L8UaHONHs3xXipGg8IM04annjnIUAytWAQlmhi1EBFk
	M3/9rrxg7aeuQnidBa5xuYULHJECs7ACgVuu3Equx+fMSoM9ySNdzdlEAwZF2C9ZvHfz6EyXPZe
	Xo9i80FPmlPPBmw0Lj7TaY06tHYIwx4vDOT8/VASW4w==
X-Gm-Gg: AZuq6aJ2n7rPmu3+vtxhYzT1PwFpiv66RqVGlpAdK172xYrS/XEqpfvCeBG8l6ZGDjx
	+cYYSmMGE11oimIH59NafDWrgfRD3F3ytAXblzHXwz/leSl53GCO0XL907Pvq4M4l5w2VdGx6r6
	2ccsimmzj0Momh8va3B+PjF9Nht1LM8AKcV4cZGUN6QbsA8oEAmVtEm+LlfpZSwduKu8NwZx97w
	CcKk9XrpaFf0Gf3xTYCrxaBANE+xYuwG4Nar3eLQFxCn76mIktgWecmnP66g709UsSKMiSoMPqP
	+/K7vMXpywG8lCrEJ12Ki0MVMf3MqD1wWzfI86ge
X-Received: by 2002:a05:6512:3c9f:b0:59f:6a34:59d0 with SMTP id
 2adb3069b0e04-5a0ed89510fmr2790747e87.14.1771852758103; Mon, 23 Feb 2026
 05:19:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260113110302.114843-1-marco.crivellari@suse.com>
 <CAAofZF7gneM02R9oHKS-=NmFs47Unk+rO9bjEiW5Gv694GLTvA@mail.gmail.com> <391f5759-e85c-c6eb-d81a-ec0d82d57ab6@redhat.com>
In-Reply-To: <391f5759-e85c-c6eb-d81a-ec0d82d57ab6@redhat.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Mon, 23 Feb 2026 14:19:07 +0100
X-Gm-Features: AaiRm52jGATcPHwKVLuopNDtnhO8bkx472ci8zmwuLLol3AO-nY-wqCtSssZAXo
Message-ID: <CAAofZF4u=STE+5yLr=stpNLLi-rX1BiFQK7ZHvhFF4V4ejuAeA@mail.gmail.com>
Subject: Re: [PATCH] dm: add WQ_PERCPU to alloc_workqueue users
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 1:13=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
> [...]
> Hi
>
> The patch was already committed to 7.0-rc1. See the commit
> d4880868670198df321627a949e7b7f2d76cf54e.
>
> Mikulas

Hi,

Ouch, many thanks!


--=20

Marco Crivellari

L3 Support Engineer
