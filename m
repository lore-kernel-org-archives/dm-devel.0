Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B6D80043
	for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 20:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727211283; cv=none; b=HixQD7P5dbShLLpvfrNotY3r7gHETB2Uki4F64T3QtYqkcxzKz/YhI1B+rJzHPZ6ksP+s5oHhOzuLqP1cMbkQ0/LnUfCyukUUkJe2toDdmbiisatlT1VTyu6xig/2S2eF1DZ+G3FdfJh6oZ6QzN0K8QNAXRzUsCLE3qS0pZ61kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727211283; c=relaxed/simple;
	bh=GvF5YOtdRQ3nQ8/UT5Tf7btTwteD8WTQP93ieooi7aI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ep9UnchNJ0P5rQ4Nd656jHbRdg3iviMrsO12rdiIxkgUpn1OOUdLR4+6L5WcNHg0MvyiJLWswmhHhK3usnAFrTuzLYo/bIDIHZ5A4W1f/nNr47c3SjwXTS8q8B/K52l44NSG+GO4sEz7+Pliq2w6aYO25IuJ9gmfkyicQQ+Md2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I04L02WD; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I04L02WD"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c247dd0899so2217a12.1
        for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 13:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727211280; x=1727816080; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GvF5YOtdRQ3nQ8/UT5Tf7btTwteD8WTQP93ieooi7aI=;
        b=I04L02WDtdsgYbx/GGqyuRC16aqrRE7GbS2wGrdj4G+b7Am//7UYweevs/+KILDGR2
         ukYcHq/7K1MRX7nq5gZDZ+WHJkh9WYuDDbIQ9wp7F3/1p/mR0GOcgigrDpz7tOqSYHZo
         CM6O4n0jwyQaqL5GDzk2r2HY3JtnqWFQkuJIRb+mr/0t9rTSGFiBGqL2VTWjDptbwGs8
         7zoLvewGAe933Z7gnvNZoANx+Vib4Dm651IPbKEx5pIEmVbgbhcARZxVHyZeECZ8lDvs
         LC1Nto2yIHvPRv2VaBxqE+zMdBZ9AO929HK8owB2o+Xux3cZOWYuoHnzA+cyc5yX5kuP
         LUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727211280; x=1727816080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GvF5YOtdRQ3nQ8/UT5Tf7btTwteD8WTQP93ieooi7aI=;
        b=sqlSLCwIPGyBM9yQEQyxqwn1K6Pe7t83U5uSvtZtAQ78obxC4OuRa8UE9CkPTG9oC/
         hUPkOp8GP5KkN7TaO2nN4/LPauBhvr00Z05XHswBfd0Lxv4Ufdgt+41xPoLK6ug8XHp+
         8RQaEg+ge1S3fx2pqjxk89mC2v/yYTZfQkc/Gz3X16Nnk+u+x9bsG6/bq5uMvZFQ5zFg
         0jfIJD0/7SW0Fi9J2U+dLrCukL2zGb/fcoIGLKqpg4gol+4C+CHz8pcDLcNrsAZlgRdi
         x8kaP97Sm0RlKtFogkMoPEYq5f3W1ERbicCY96+BTba897RnJcXy8GVhK6ScXyuzKyt4
         ihNw==
X-Forwarded-Encrypted: i=1; AJvYcCUxOTApvWNB9fZt3CY6r/KrLFOY2JmExZo7pl1g5euv6phH60euElrBh0wcNCx9jhu/6V5At0fOAw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd/wJlwdD6VoS2cJBms8XXeTz83ICx/gDALDKht6QNoeSFV64h
	SbY7HzDpHjzJ4h6jQBU8sLFHcZcesBsKxOZs1sxuI/hHWusyzfyc2cUpLopdk6bFKCs3ZiuhDgs
	PCxpUKcehySo+x1WoNekZvWXd+bLg6ke/y+a6
X-Google-Smtp-Source: AGHT+IF9zLEeySDU7S2qlsZumrXByCG1GvyzkZnyv9xPXqpk/YFAiBraTSmn/qfb68au1I8pmsT75C1B3dhw156ZSOM=
X-Received: by 2002:a05:6402:430d:b0:5c2:5251:ba5c with SMTP id
 4fb4d7f45d1cf-5c720f4f073mr4502a12.0.1727211279863; Tue, 24 Sep 2024 13:54:39
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>
 <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com>
 <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com> <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
In-Reply-To: <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
From: Akilesh Kailash <akailash@google.com>
Date: Tue, 24 Sep 2024 13:54:27 -0700
Message-ID: <CABSDvD+PLF_HnGeJwVheW1HGcy8hV2BpfFw3NizkCYKxDeWURQ@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Maxim Suhanov <dfirblog@gmail.com>, 
	Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, 
	Mike Snitzer <snitzer@kernel.org>, security@kernel.org, dm-devel@lists.linux.dev, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2024 at 11:45=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
>
>
> On Tue, 24 Sep 2024, Akilesh Kailash wrote:
>
> > On Tue, Sep 24, 2024 at 10:44=E2=80=AFAM Sami Tolvanen <samitolvanen@go=
ogle.com> wrote:
> > >
> > > Hi Mikulas,
> > >
> > > On Tue, Sep 24, 2024 at 6:18=E2=80=AFAM Mikulas Patocka <mpatocka@red=
hat.com> wrote:
> > > >
> > > > Maxim Suhanov reported that dm-verity doesn't crash if an I/O error
> > > > happens. In theory, this could be used to subvert security, because=
 an
> > > > attacker can create sectors that return error with the Write Uncorr=
ectable
> > > > command. Some programs may misbehave if they have to deal with EIO.
> > >
> > > I seem to recall that this was intentional. We used to restart/panic
> > > on I/O errors with FEC enabled, but the behavior was changed in commi=
t
> > > 2c0468e054c0 ("dm verity: skip redundant verity_handle_err() on I/O
> > > errors"). Akilesh, do you remember what exactly was the issue here?
> > >
> >
> > I looked at the history and the original intent and the idea stems
> > from this patch:
> > https://lore.kernel.org/dm-devel/b004e7c7-f795-77ed-19b9-983785780e92@g=
mail.com/T/#mec4df1ba3f3cb63846875fb2bfc1f8b3100f31f1
> >
> > I think the EIO should be propagated back up the stack; I think this
> > will trigger panic
> > even for genuine I/O errors.
>
> Maxim Suhanov's point is that you should trigger panic for genuine I/O
> errors. Otherwise the attacker could corrupt some sectors and let some
> program receive EIO and the EIO could confuse the program to do something
> insecure (for example, to not load a configuration file with security
> policy).
>

Would it be ok to trigger the panic only when the system isn't shutting dow=
n?
During shutdown, we may end up with EIO requests from the underlying
driver and this may
inadvertently trigger the panic.

verity_is_system_shutting_down() should already have that logic to
skip during the shutdown path.


> Mikulas
