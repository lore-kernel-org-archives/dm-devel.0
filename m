Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1493428507B
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764867375; cv=none; b=Zj29SY0tsP/FgB9DYARNzqeFYhC9dL1URwIfJAFTi4wjyuSFmqx/M1kMC0a/xovJsj8isXjA64b22okGLvEBoFGRPWrtiB4CciQH+MBw23He1F/yH+u/5x0ZyiFuM/xXiRuqHjn85PXup1HAfp5USEtjn1Hev0wuvU/1k2krrws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764867375; c=relaxed/simple;
	bh=hRBYd2AAEkv8YICoYuuQfQweBWUMysp+pV31tcVTRXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VDTAkhcJQeqV56NCZwTbg/VZojAT4vz7Wf5ScyAcwz9rTIwtYe1wr1Xj8yfanRcHzS8vcXbcaVrZjr9gLoeTrrkg9WnoK7XDhOKSx6Cc/xPfwagxdVQhn4r7IHIz//gaNQTIaQ6ubyjre2vxRDi0KKmwDPI1Vyp6z1Y4WanJkg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=elUwBbTQ; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="elUwBbTQ"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-37e56b0712aso9332901fa.0
        for <dm-devel@lists.linux.dev>; Thu, 04 Dec 2025 08:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764867370; x=1765472170; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRBYd2AAEkv8YICoYuuQfQweBWUMysp+pV31tcVTRXM=;
        b=elUwBbTQ9+U3wY/nBSuHA9A+H/dzzmBUlFiC0qxiKrXS3LfdSdPN3jSLqQ893kDlAg
         xqmqays4wB3Mlg6pWqGTzzF8wvzVMGsEfsYvKlcdlPT+e+QprpYk9qFa40xFiAO5AuH+
         eN+a6MoRBFXa9h0fHbD+JS1ITLSFrUWybWEyl/niNIEdEB/e6Kus5rMsCJ4c9/Ra67ew
         RakXMEjkygUyAvNTs0zIuLBGSmr2pMcRXUJE4IWRP18PgcQpKvci8j3UYXjYE3gapbjT
         /ZOER95KxgeL77yCj3RaPQhR+zWh3FE+XsM1RcmDs9aIHEobDadxTqpQl7bo6Chk/z2/
         /CLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764867370; x=1765472170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hRBYd2AAEkv8YICoYuuQfQweBWUMysp+pV31tcVTRXM=;
        b=Z+8V/coQ9uTde8nzhlmh9ONDAkJW3Or6is3PB55NdwM3wgf3CoPz58zq8UchfC40T0
         4RIwsaRMl14AUj8G/VzryosNhwOe3G8BL/zJY3WoW9Uif6VkkzhZGmgi4rPJwmkFMu42
         lRXSjOXh4jGFJ+kg8CNcppoojnWFwpJZXWzyNHxVDbjQIkTiqA02b0b6VWCgeNFjrDOK
         0qsZMD+J6DpNRF5r/ivlD+mwMo3/1PZyJPt9p+THYJ7vvjj9wrytJeRExpj0TS3YVchq
         mOppDHVETzq3Tzu55WdDISj2Y/hGiMCMypilwtVhxVnFCzEUpeo/sLrGY4aqpsrDeLQv
         vxJA==
X-Forwarded-Encrypted: i=1; AJvYcCWyg9sK8EoG2A2ytHPDaXEID4l3bSI24aT2CabbuVVxnpGl4XZhM5YTqo8u0zVfQVuR3OhHzCaHPw==@lists.linux.dev
X-Gm-Message-State: AOJu0YybWNtPZpNcdxYm/7ZESg6Dgz0aiYKRN6sOr1/Ki2vNDCDOKvN+
	e24tUMZkbEG+D/z9pr4xuaoAG1Q8KS2fnbpPaeWS5DGf/P5OzzCbG/4vMdi9nGBfTc8iMndJ/hN
	GeP+kJN0NGVLyPjDlbCV+Z+CI7qmfKSAn9CDHDIBmqw==
X-Gm-Gg: ASbGncut7r/Sgx6DhhogTxPYEcb+BNY0FkmkE8naLQqTfmA/gDBFCgZqVpto6YR01iV
	qyXujnlHvoEKN10s5k5dP/P2HMzy4RordM9p9EpgeVi4ShItu7AQIIr+KIEmnzASB2OWm4dHcSr
	Od6cf28NDLwhpjl2ex5TSONU8s1rERuUwDuQ3ojuZT2uXawyy5OA9EotOTd8Rxg1mxTxh7C8D/l
	2YP2UQeDD+5riKWU6csXZ0zQYwSYoEPbVqkXQ8Q+5x/D9r1FmVNyzZYdhpQNh0RWV2JD9YLXK6n
	qqVC1PYikY9L3cQhbzAAuXKIWF5BPnKRTGhwc5UH46bekPNrJ8ONCA==
X-Google-Smtp-Source: AGHT+IEqcpK2ZqFWIPMOhzNeXSIJ0sHwiW+7fFFZQO34LMj1exAdEutc6YE0aneJdvUdypQKOr+08ByNG8Zy4U9ygyw=
X-Received: by 2002:a2e:81d4:0:b0:37a:3615:89f2 with SMTP id
 38308e7fff4ca-37e636f64fcmr20766801fa.9.1764867370027; Thu, 04 Dec 2025
 08:56:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251113184317.55038-1-brian@purestorage.com> <aSC4YOZjDiIZadJ4@redhat.com>
 <CAHZQxyLJMZ6VpFFj1D8TLECBrQ7_digxT1BS1Dk68LNqTzV5EQ@mail.gmail.com>
 <aSS75Rt0f4fFbUUA@redhat.com> <793c255dbd79b17a2a3e9e4f781f6efa5fabc622.camel@suse.com>
 <aTCRXZLVlq8me1EO@redhat.com>
In-Reply-To: <aTCRXZLVlq8me1EO@redhat.com>
From: Brian Bunker <brian@purestorage.com>
Date: Thu, 4 Dec 2025 08:55:58 -0800
X-Gm-Features: AWmQ_bnMBZti7lFvbm0w6jAbSOeVO3sI4xjy-K01ZvsxV4NMBVANzY-Sw1vcllg
Message-ID: <CAHZQxyJ0Y7Tx4UC4je40s6dQKDE942qo-OwSpnFUeJcocozL-Q@mail.gmail.com>
Subject: Re: [PATCH] Add purge capability to multipath-tools
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <martin.wilck@suse.com>, dm-devel@lists.linux.dev, 
	Krishna Kant <krishna.kant@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 11:37=E2=80=AFAM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> On Thu, Nov 27, 2025 at 12:31:12PM +0100, Martin Wilck wrote:
> > On Mon, 2025-11-24 at 15:11 -0500, Benjamin Marzinski wrote:
> > > On Fri, Nov 21, 2025 at 02:35:23PM -0800, Brian Bunker wrote:
> > >
> > > >
> > > > I added the purge thread because I didn't want to starve the
> > > > checker thread at a large disconnect volume scale. I noticed
> > > > that the number of devices if I purged inline with the check that
> > > > it didn't scale linearly after a point and seemed to be
> > > > significantly
> > > > starving the checker thread. Doing the purge in another thread
> > > > seemed to relieve that pressure.
> > >
> > > That might be because the check thread has safeguards to try to avoid
> > > starving the other threads. Since a lot of multipathd's work is gated
> > > by
> > > the vecs lock, there's only so much parallelism that can happen with
> > > multiple threads. If deleting the devices is taking a long time, it
> > > might
> > > be better for this to get interrupted, so that other threads can run.
> > >
> > > Since purging the paths is fairly low priority, we could continue to
> > > run
> > > it in its own thread, but instead of running through all the devices
> > > at
> > > once, purgeloop could lock the vecs->lock, handle one device, and
> > > then
> > > unlock and loop. This means it would need to search through the list
> > > from the start each time it regrabbed the lock, since the list could
> > > have changed while it wasn't holding it. When purgeloop makes it all
> > > the
> > > way through the list without finding any paths that are due for a
> > > delete
> > > attempt, it can sleep or block waiting for more paths.
> > >
> > > This would mean that paths would need to remember if they had already
> > > been handled in a cycle. That could be done by purgeloop keeping
> > > track
> > > of which cycle it was on, and the paths storing the cycle number
> > > whenever they were checked.
> >
> > As I wrote in my other post, wish that this thread wouldn't hold the
> > vecs lock at all. multipathd could simply use a pipe to write dev_t's
> > of to-be-purged paths to the purge thread (or process :-) ).
>
> This seems like a good idea. Obviously, writing to sysfs while the vecs
> lock is being held means that multipath will continue to have that scsi
> device open, so there's no chance of the device name getting reused if
> the device is removed from the system. But this other thread/process
> could simply open the scsi device, double check that it's still
> disconnected, write to sysfs, and then close the device. That would
> offer the same guarantee, without the need to interact with anything
> else.
>
> > Martin
>
Martin,
If you look at the v3 implementation that I sent up yesterday, you will
see we are no longer holding the vecs lock during the sysfs delete
operation. We also made the delete operation non-blocking.

The two places in the purgeloop where we do hold the lock are for two
very short operations:

1. We scan the vector to find one path that needs purging. We update
pp->purge_cycle and increment the retry counter pp->purge_retries++.
Then we copy the necessary data for the purge into the purge_info
data structure. Then we release the lock. There shouldn't be much
contention here with these operations.

2. We also re-acquire the lock to make sure the path still exists in
the pathvec and clear the purge_path and reset purge_retries. This should
also be very fast.

We can't take the approach to open the device since it is disconnected.
I think it will just fail or hang. We have the udev reference to make sure
the device object is alive and not freed underneath us.

Thanks,
Brian

--=20
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
