Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59E71C2D
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 01:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717378848; cv=none; b=njnN/SJjIUBFXzj/oXdqg2nJ8GPNNxMFapCoYVzwSGI8TNrsUBwbMaSZ28ncdlONkUotgxQ0FhBYwTnWoF6WulEJ9255cO8SvBODjhZKtxHtWSzEk4tl4i8CvXbI79Oi20/4lyhGJ0GdjTyaI+F2BiacFk15SUKsS7lJvyTM8go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717378848; c=relaxed/simple;
	bh=uDNSXK89staAi5wtMKyMoU94EEY42WkdDv0RK++eZMI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VUXELP3ZjKiJnsD4Smf3/M1MzXxSVG5f1f5MJeoh40jlB8t48zuPs7KvCjPOQE2eSHYAHFHmtLyZwJpvc4glJjxOd9mBQZaZ2fref0kbEdNnMmBkC1YFkblDTMzWTGlnx4spsq17gCMG1iNwn36UMtgoFNAavKrrFx3YiprOd/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=LkHtzEit; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="LkHtzEit"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-62a080a171dso24928167b3.0
        for <dm-devel@lists.linux.dev>; Sun, 02 Jun 2024 18:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1717378846; x=1717983646; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TDOjHWp8bXjvFuOeUFIDKGP58ph/UwrghwjNGtMBFo=;
        b=LkHtzEitj7JK1WetdVx8HDTQtlNtGc0r1ctX4P/J9RDSvtAZPEZ0AZ+sagEMyK+gpG
         UZnfthlSdu5FIL9Xy1rFTVFmimvTWhEB4pI4VCs0tg+QkF8qC22UX9K3jmsOHnW2etSQ
         vxcXr8AnFu0Jop0XNt8GkTUV5pGTiV8uan0uSwtRxz0vrU4rP0CflvQz5Xpb9NfBFRFm
         6BOODGjixE+gPWyhlVD+3XKdCRLa37fynoP7ETw5rRGitFhE3qqQ1oNTf+S8Gg44luOF
         wri4caKV7h8Drl9oUD0L4JrduZ2ICN/VeKj0uZnbs3LZyCCaSVUaNjzuThtJaa1wha80
         VqEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717378846; x=1717983646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/TDOjHWp8bXjvFuOeUFIDKGP58ph/UwrghwjNGtMBFo=;
        b=sML4OywiIGmiwYTyCUCEbSHv9+NAYMEwiaptugFgd+/e0zk1Emh3pZIEgN55j3cRO4
         nmLRD2GDIhISvrA0mVXkAd7yVwoVfcRLtQYWwk03pcgm7wWtxNxvzmNJVMaiSyvYuudz
         qxsUzSsFRhKVdpEbVdZXM2U+tA7LJXm0GCwTWQaKKYmeu2KutdrkZbRLNyU1urkVqfDo
         dz9ad6Gs//Q8dr9XmCUxHSc6EYVoeaYUfiBCgwJUFoimx3ZGT707Ru9ZwPaxsCPzIXm5
         sY29CKZH8W3SUURx/qJkn7OOSSPu54vr62bUh98ql/4SCfxjTWm6gH/vjIoI74ZfoiaR
         QzXw==
X-Forwarded-Encrypted: i=1; AJvYcCUc2jcKE5XWzieOjWZZF6iDVFXvqbRSQ5EuImOZoeDrUYtSkcBaSUe6WKl5XhTxk706/MTHY3PR7uFcBj+INGKq29Fkm5DDs0M=
X-Gm-Message-State: AOJu0Yz7bncuJvbBSyCJpbJJNEE4/KXo7pCXiw7pueojhz64nBh34te+
	MIzHoHv20uS8stcpjzfLQFFwkbJ9rzO3Jd0TK5XDapdyaTl5cexent9dcYQ2rFkkMGeexZi5eE7
	hgzfjMni0Ry+R+oPRRW6BjN4YG3Nc+G6HcuOq
X-Google-Smtp-Source: AGHT+IFp652CCfD0M3qHSzvSxnuvYGSkS9KDgo5K/vd2UhiOAnsvsgHt4NTZTmN643EolwNgor3GheXekQ2a83RNBjY=
X-Received: by 2002:a81:ae42:0:b0:627:e414:2f46 with SMTP id
 00721157ae682-62c79708847mr83808507b3.28.1717378845664; Sun, 02 Jun 2024
 18:40:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1716583609-21790-1-git-send-email-wufan@linux.microsoft.com>
 <1716583609-21790-16-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRsnGjZATBj7-evK6Gdryr54raTTKMYO_vup8AGXLwjQg@mail.gmail.com>
 <20240530030605.GA29189@sol.localdomain> <CAHC9VhRySQ0c16UZz5xKT-y5Tn39wXxe4-f7LNjFY+ROGGxpaQ@mail.gmail.com>
 <20240531004321.GA1238@sol.localdomain> <CAHC9VhRRuBdnv3u2VjKZCR672p4oj_smA72P-181ysdDXGJ-AA@mail.gmail.com>
 <20240531174710.GA1199@sol.localdomain>
In-Reply-To: <20240531174710.GA1199@sol.localdomain>
From: Paul Moore <paul@paul-moore.com>
Date: Sun, 2 Jun 2024 21:40:34 -0400
Message-ID: <CAHC9VhQDPnq3X0fFOXf5zY38K_STffmZJMqHp50sVqWW6pcabw@mail.gmail.com>
Subject: Re: [PATCH v19 15/20] fsverity: expose verified fsverity built-in
 signatures to LSMs
To: Eric Biggers <ebiggers@kernel.org>
Cc: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com, 
	jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, axboe@kernel.dk, 
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, eparis@redhat.com, 
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 1:47=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
> On Fri, May 31, 2024 at 11:51:47AM -0400, Paul Moore wrote:
> > On Thu, May 30, 2024 at 8:43=E2=80=AFPM Eric Biggers <ebiggers@kernel.o=
rg> wrote:
> > > On Thu, May 30, 2024 at 04:54:37PM -0400, Paul Moore wrote:
> > > > On Wed, May 29, 2024 at 11:06=E2=80=AFPM Eric Biggers <ebiggers@ker=
nel.org> wrote:
> > > > > On Wed, May 29, 2024 at 09:46:57PM -0400, Paul Moore wrote:
> > > > > > On Fri, May 24, 2024 at 4:46=E2=80=AFPM Fan Wu <wufan@linux.mic=
rosoft.com> wrote:
> > > > > > >
> > > > > > > This patch enhances fsverity's capabilities to support both i=
ntegrity and
> > > > > > > authenticity protection by introducing the exposure of built-=
in
> > > > > > > signatures through a new LSM hook. This functionality allows =
LSMs,
> > > > > > > e.g. IPE, to enforce policies based on the authenticity and i=
ntegrity of
> > > > > > > files, specifically focusing on built-in fsverity signatures.=
 It enables
> > > > > > > a policy enforcement layer within LSMs for fsverity, offering=
 granular
> > > > > > > control over the usage of authenticity claims. For instance, =
a policy
> > > > > > > could be established to permit the execution of all files wit=
h verified
> > > > > > > built-in fsverity signatures while restricting kernel module =
loading
> > > > > > > from specified fsverity files via fsverity digests.
> > > >
> > > > ...
> > > >
> > > > > > Eric, can you give this patch in particular a look to make sure=
 you
> > > > > > are okay with everything?  I believe Fan has addressed all of y=
our
> > > > > > previous comments and it would be nice to have your Ack/Review =
tag if
> > > > > > you are okay with the current revision.
> > > > >
> > > > > Sorry, I've just gotten a bit tired of finding so many basic issu=
es in this
> > > > > patchset even after years of revisions.
> > > > >
> > > > > This patch in particular is finally looking better.  There are a =
couple issues
> > > > > that I still see.  (BTW, you're welcome to review it too to help =
find these
> > > > > things, given that you seem to have an interest in getting this l=
anded...):
> > > >
> > > > I too have been reviewing this patchset across multiple years and h=
ave
> > > > worked with Fan to fix locking issues, parsing issues, the initramf=
s
> > > > approach, etc.
> > >
> > > Sure, but none of the patches actually have your Reviewed-by.
> >
> > As a general rule I don't post Acked-by/Reviewed-by tags for patches
> > that are targeting a subsystem that I maintain.  The logic being that
> > I'm going to be adding my Signed-off-by tag to the patches and arguing
> > these in front of Linus, so adding a Acked-by/Reviewed-by simply
> > creates more work later on where I have to strip them off and replace
> > them with my sign-off.
> >
> > If the lack of a Reviewed-by tag is *really* what is preventing you
> > from reviewing the fs-verity patch, I can post that starting with the
> > next revision, but I'm guessing the lack of my tag isn't your core
> > issue (or at least I would argue it shouldn't be).
> >
> > > > My interest in getting this landed is simply a
> > > > combination of fulfilling my role as LSM maintainer as well as bein=
g
> > > > Fan's coworker.  While I realize you don't work with Fan, you are
> > > > listed as the fs-verity maintainer and as such I've been looking to
> > > > you to help review and authorize the fs-verity related code.  If yo=
u
> > > > are too busy, frustrated, or <fill in the blank> to continue review=
ing
> > > > this patchset it would be helpful if you could identify an authoriz=
ed
> > > > fs-verity reviewer.  I don't see any besides you and Ted listed in =
the
> > > > MAINTAINERS file, but perhaps the fs-verity entry is dated.
> > > >
> > > > Regardless, I appreciate your time and feedback thus far and I'm su=
re
> > > > Fan does as well.
> > >
> > > Maintainers are expected to do reviews and acks, but not to the exten=
t of
> > > extensive hand-holding of a half-baked submission.
> >
> > Considering the current state of this patchset I don't believe that
> > verdict to be fair, or very considerate.
> >
> > We clearly have different styles and approaches towards subsystem
> > maintainer roles.  I've had the good fortune to work with both hostile
> > and helpful senior developers during the early years of my time
> > working in the Linux kernel, and it helped reinforce the impact
> > patience and mentoring can have on contributors who are new to the
> > Linux kernel or perhaps system programming in general.  While I'm far
> > from perfect in this regard, I do hope and recommend that all of us in
> > maintainer, or senior developer, roles remember to exercise some
> > additional patience and education when working with new contributors.
> >
>
> It's not clear to me that you've done a close review of the verity relate=
d
> patches, including not just this one but the dm-verity related ones and t=
he
> fsverity and dm-verity support in IPE itself, given the issues that I've =
been
> finding in them in the last couple months.

I have not been able to give the fs-verify or dm-verity patches the
same level of scrutiny as the associated subsystem maintainers simply
because I lack the deep history and background; I rely on the
associated maintainers to catch the important "gotchas" as we've seen
in the patchset.

> As I said before, I'm not too
> enthusiastic about IPE myself, for various reasons I've explained, so I'v=
e
> really been looking to the people who actually want it to help drive it f=
orward.

Once again, that is what I have been doing in my effort to get this to
a point where it can be merged and sent to Linus.  I've spent numerous
hours reviewing patches on-list (and catching quite a few issues), and
working with Fan off-list, to ensure these patches continue to
improve.  I'm asking you to review the fs-verity patch(es) for two
main reasons: 1) to identify any fs-verity interaction problems, 2) as
a courtesy since you are the fs-verity maintainer and I want you to be
aware of this and accepting of the code being introduced in the
subsystem you are responsible for maintaining.

> Anyway, as I also said, the fsverity and dm-verity support does seem to b=
e
> improved now after all the rounds of feedback, and I think it's close to =
the
> finish line.

I agree.  I appreciate your help in reviewing this patchset, and those
that came before it.  I've seen Fan voice his appreciation too
on-list.

>  I just hope you can understand that I'm also a bit burnt out now,

I can understand that, and I'm sympathetic.  I've been doing this long
enough to have gone through my own cycles of burnout and rejuvenation
and I know how disheartening it can be at times.

> and getting asked for an ack on this patch again and then seeing a bug in=
 it
> (despite it having been simplified to only a few lines now) and also stil=
l
> misleading information in the commit message that I asked to be fixed bef=
ore, is
> a bit frustrating.  I think it's reasonable to expect a bit better, espec=
ially
> for a security oriented feature.

I firmly believe that no one writes perfect code, and no one performs
a perfect review.  As far as I'm concerned, the important bit is that
you respond, learn, and strive to do better next time.

--=20
paul-moore.com
