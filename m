Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D80D241139
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 17:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772645945; cv=pass; b=SqfWl+uiEe3UahWVAzs/XvVygPoUUyd30NyoWhZKHhsTYIAIh2HiP9yLCL1cqTnmf7JLqbZjWx4w07Bb6UTy7tH7yOAQpYtanQhVe546o+yt8bupbpTWYRSpRO5QjP7+hRJjBvpozRqt/W3a25h79Xn9cwGzv9upz7P4YPs62aw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772645945; c=relaxed/simple;
	bh=r2gHX4m6csKDHHN1cB8HwC4sKTQX4Gu86S8teTlR4v4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X1OaYffYWjt/vAKkht7epDiqP1yNY11wOVXqBjGnHS5pKiZ5ex+aBR3NdIiGI6K5XIp7tvDJKWJbPctji1uRwFEDVJ5UGGdrFOK2BcO5EKYdhWcjFMorBZzTgiPOIYsBGr2hc7EGtX/87LUDXf/UjiZ4rzEXnITJVCKbcsiT59M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fBPeCDLg; arc=pass smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fBPeCDLg"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-38a3066b68bso12739921fa.3
        for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 09:39:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772645942; cv=none;
        d=google.com; s=arc-20240605;
        b=HHsVtm2f7836MaAz8WXs6EmDhre45bbPkYz+vR+Fk/t7kvWWgrcG3N5z9+j4TNDF9c
         qJXJNKRNDrI523Xvq+ensrupZCvL7dY6XpxbvJW5HfvgzBFzZnqF3NYBPMOYN4pVbnDX
         Uw5XXrxKPc16WuLnIDh8vmBP8LuF+VZwsy5F8KO/qpz98MG/gpru5/6EM0HcMlhwmurV
         Ps66Hdx/3s3hMyZSh4RgujXD2qt7Gb6LfYEdqf6u3Qx+v2X0dSTocEzBHe4/+VjfW2jH
         iknT8rX6kzXduH8AeqktRv+xGKQWZxhiRyUsYooaQ+TuTWY72jcHkK0D/piRNo257vfa
         PY+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D71L6XJ6JCEgo4iA00PlKypei6ttwD+XuXzX+FDC714=;
        fh=8V7fQtGA4OzqP4uGkUjZWZXAhLE7qc5tpV/IWlC1/ag=;
        b=iatGWeG+0AubqzoFWvwmRo78Ndx9xH7nTD5bY7Px3USXUfTnokeLU5FzCdhj5eFEDa
         GO7jfLBfrpA8ryrQtgTR/DVs4Xy7Irzg8I3N9oWzS8Tr3BH/VelZ5h/zgCQyRDSt81jF
         wyNyNmyHdQpWhKC111MUsv5DxrbWF1BBF6sRO/KucqhxBl93IVhn+SI39tGQvJC4jtSo
         CccNUiss6SwIRrOXCpleMx/4MmvFYDg6uRC8UYHzl9J0MNbvu5Y1jG4r7d59It4VsFqw
         lAK63vxVU+aTeI8TEfA7yOgR5+b5VdzXkrOpsgznx9Clf0tDs004Xr/yI5XaZx+BxgG7
         SZvQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772645942; x=1773250742; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D71L6XJ6JCEgo4iA00PlKypei6ttwD+XuXzX+FDC714=;
        b=fBPeCDLgtSq8jbg5498G3RCpr6ab7UykeyrvPTBWVBA+OacO9DKJchVduhy2mN8bDA
         MMdGllUQ5SFoQNsNluCkx1bMVr/dz4ZpP3psXZseOcH68me0TwGTGeraJdT2ly9UuxDo
         Zwzw/fK864ueChjg5dF/S+Ll0QIZPXo+DxavL3ApXq1WyDK+UCkZEOXuST0MmDbo3Vit
         FvUXD2rEyOVoxurK3kCyvhze4M1xHttkAMSijmHvWQd6h7fbAc8pEm4rMpV9aC4QNjsF
         jcgTf2T1q9WDmdfze929sgc3eXOBxt26HOcgukZdjQzzGubKZaTfeFUWXFrqQZuI/zmj
         gYlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772645942; x=1773250742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D71L6XJ6JCEgo4iA00PlKypei6ttwD+XuXzX+FDC714=;
        b=W8sbhts95ejsO0ZKM4rkNJCFPxl2adBWhXOn2du0CWWN1L9poublZv3iDpdV/Mpwx1
         lh8pGIlBWy34U/mrncWeKq/ZaQfzgCKsj5jHS8sCaLyv3IXSFyAQW0If89X6J9dEMlam
         tu2akrRNin4ClvN36Yd4+JZBB4jHzw510xnHUyGncRCnlwb/FuRi43zzi2ZZIoGGx3Xk
         Q+WZEgN3DipXatrniASPr1eSlsBq2yd7XQrxQTt7YQ9TKlZ79PWaWv94RWhvHIaWPXd2
         mdBHn865xQc19KFRv4FaMZCTEhZpH8y/ZBa8HzDXTk91Li85xvu1Yy76fo5pfG9WBxpG
         QaOg==
X-Forwarded-Encrypted: i=1; AJvYcCUYSVeXNOMxRF+5y4uOd6y7rw17BeCDgaUlkijSzvz3RXBPK+KW6OfKIKpgoXxteypdhWOZ0wyLSA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwwHR7XnQjcAfIz1oa2+yHvwq2hhi0yEA24pvkiQ1SKnStZoh4P
	MIItLKHCP51mR/CsLwORgEAjCP7q2xi0VEMCZqMXd9Kl2/J+ILF38dVm9SEwaO+WCNya9SvYLpd
	/hmKJxP0bA1OY0K8Zf2hEddcrW9T4RcZ6vHgPRmyZwA==
X-Gm-Gg: ATEYQzx2Q7ObtVeFiidgR18wkCQKgDfseoAdk7HPCQ9axSLJkAtRY89En+9Lg+bme+K
	JcBLwRN09RRLaJcI5rC20WmTKDdLeazHIW/YpKCDJ/oUE/IC+VZgPo2OUUCKWO3f4JVyIrWQhe9
	84qJY5mCRx11354yK/MIimq8PWu9ZmZlj3p5DX+oPG9mxpimaB6EFU6BEL0h4mJD/Ju6jo1/+Az
	8a9t22R1zg3e8+xUIZsE7sobIFfGX1N8P854I7GxneMoIBQhejHHHJ4dcDHkV63rh60BKhiWARS
	NMYGmUCWGKKPcevwHP4cy9c8ydp1Mylao4GNDH76mSU6z2Jnahhfrv7AuZ9hyao=
X-Received: by 2002:a2e:995a:0:b0:38a:aba:9c0b with SMTP id
 38308e7fff4ca-38a2c7b248emr16165361fa.27.1772645941860; Wed, 04 Mar 2026
 09:39:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260224010058.35337-1-brian@purestorage.com> <d9355e67dc64b7af940f6b8e6845d0f37565dd34.camel@suse.com>
 <aZ9ec_ce8dCCBzR0@redhat.com> <d223eb7cb4088d672b0312d929fa7d2c0e723875.camel@suse.com>
 <aaCVelI_vQZEBihM@redhat.com> <2ae78a2af1cc187a0cee9f0660e31fbd7cc79cd9.camel@suse.com>
In-Reply-To: <2ae78a2af1cc187a0cee9f0660e31fbd7cc79cd9.camel@suse.com>
From: Brian Bunker <brian@purestorage.com>
Date: Wed, 4 Mar 2026 09:38:50 -0800
X-Gm-Features: AaiRm52Gk70E0twx9dDjR8im-x-Na0wf9yZ7ZMRXwU9drVPqqMcXa_dbNCZPvh4
Message-ID: <CAHZQxyLzqG-N5jOOrODL-O+RRLmwHiNO1wSUGC=gvYpVkQTbnA@mail.gmail.com>
Subject: Re: [PATCH 0/1] checkers: fix race in async TUR and ALUA result collection
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ben and Martin,

Sorry for the delayed response. I sent this to you both initially instead o=
f
to the list because I thought you might have some insight into the issue.
I have an 'alua' checker that I will post where I found this issue. I
didn't actually
find it in the 'tur' checker but I could see it is prone to the same
issue. I have a
test I created to show the issue called test_tur.c. I will send this
too if it helps.
The problem when I didn't use this patch was that my checker the entire
checker thread would stall. It didn't just correct itself. Until other
paths failed
the checker thread was deadlocked somehow.

In the 'tur' checker without this change, the 'running !=3D 0' will lead
to PATH_PENDING
and MSG_TUR_RUNNING without looking at what those actual values are.
It might actually
be finished, but running hasn't changed to 0 yet, and ct->thread is not
0 on returning. I am not sure what extra conditions were true when my check=
er
thread deadlocks, but with this change the deadlock never happens.

Thanks,
Brian

On Fri, Feb 27, 2026 at 12:36=E2=80=AFAM Martin Wilck <mwilck@suse.com> wro=
te:
>
> On Thu, 2026-02-26 at 13:48 -0500, Benjamin Marzinski wrote:
> > On Wed, Feb 25, 2026 at 11:00:44PM +0100, Martin Wilck wrote:
> > >
> > > I'm still undecided if it's worth changing this code in order to
> > > reinstate some paths 1s earlier in certain sitautions.
> > >
> > > Thoughts?
> >
> > I don't see any problems with this. But I also didn't see any real
> > problems with Brian's version (although this version does remove most
> > of
> > my theoretic issues. Like I said before. If we hang in the condlog,
> > we've got bigger problems than a stray checker thread). If we do
> > this,
> > we should probably document the uatomic_add_return() call,
>
> Of course, this was not an official patch submission, just an idea how
> we might improve this code. It's not exactly the same thing; Brian's
> patch meant simply ignoring ct->running, while mine would make the ct-
> >running check reliable, albeit with changed semantics.
>
> >  or just use
> > cmm_smp_mb() directly. But I still not sure what we get out of this,
> > other than a very slight chance to finish the checker a second
> > sooner.
>
> Yes. But it's also a fact that the simple atomic_read() test in the
> current code isn't reliable. It can well return true when ct->running
> has already been set to false. I guess the implementation tends to be
> as light-weight as possible, avoiding a memory barrier (or taking a
> lock with the side effect of a memory barrier) in the "fast path". That
> comes with the price that we may miss an already finished checker
> thread.
>
> > don't think that really makes a difference, but I don't really see
> > much
> > risk in the patch either, so I guess I'm fine either way.
>
> If the risk was truly zero, I would agree. But experience tells that
> it's very easy to get these things wrong for corner cases, and I tend
> to want to avoid even a minimal risk just for "very slight chance to
> finish the checker a second sooner", as you've expressed it very
> nicely.
>
> @Brian, feel free to try to convince us otherwise. It might be helpful
> if we understood your use case better.
>
> Martin



--=20
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
