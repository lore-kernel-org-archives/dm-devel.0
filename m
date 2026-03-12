Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992AF3AB29A
	for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 19:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773343166; cv=pass; b=VMc2v+lOp5h8hDeHZp7Uq5ii/AdCeEqtImpC5DpxNzG6Ap/yr+iu6Kro6hH1TlzfSiKbPi6whTJFLqPZ5NFNMJYf6AZgmsOWbJvsKc1XgqqwZ7vX8/CABxG54DlSIptFra4TD9exRdynhg93Mtkn8iWfRl+J2To2yrvbYD6a3NA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773343166; c=relaxed/simple;
	bh=I3uKnC16ezyhP+czELeQ/aWDMFjA1rI9w2SJmMhY5go=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=JzvhCRRqA9JT/6860mhVEU0je0LH+7cbb3znGav/RteS8XVO1b94eUk+fFE0AT1qMpuj7VmVyZiy3XIVl1CM+ePEMQ6BdM+hYG+z5P59+Mp9L3k0ucujlSD/1fETvpXKptcUXqKrJypVTD+shjcBXzVgJH2ds5L6FuTbWHN68pw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=TNweFMU0; arc=pass smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="TNweFMU0"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-38a67221fe8so13064821fa.3
        for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 12:19:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773343162; cv=none;
        d=google.com; s=arc-20240605;
        b=S7dxCMYLDdmm9A+OCdAmjv4VRNCVPYyudurs7CcVW86Eh+3tgyvTxfvAyMBI3Zpxrp
         mnqSVBMLlrBMFZjlTHO3swajpkK1AqMdRUnnHdBpV5Pd1XDpGu3iJmPwZLODzjlVwMUK
         9xQeskeYeIpC8jlBxeiCCVRmT4V0YtEteWv8YVHteXp0TVgCgVzc4f9eWWD0rBleUkB2
         cyMgHfHRB98QkUxXDcHcN3RAJBfhpuPprCa43HqFhlsCwlQWTwNo91Z0CE1g/1YqhlyW
         o9/0DBLXMazjDUQn5Sgr1iU6+GXLHw8IQ1OC6wI3yjW9j5jCoux5kKGB6uMmHDwSl/hD
         QzRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rAm4iYP5dKixiOkXLqp54PSNBJLPGNPkqOxwaaOp/3E=;
        fh=l3CRNgvI34UZ3wS7PlCwranVVWi6QT1yE5+JJM716rk=;
        b=GioNxmam+5hrhUm8YJz5jMKorg4wxXzcHvNOgcnbCCQODEkqgaYfUo94nmb3+xKuWj
         MWmOeHRRO0QUKG2VJSYF2Eqfbw+641WGfJQiJHXHT9vtdH9HFuDYQMngHpXraxbpah2Y
         VPiSCHzl9MzPeRm3DSc5/8CcFxeJ1A0VgTXKd4u0tssYhEwam7FD9VXXteYt3v7tspAc
         sqq9LXrsNK+EXoorcvbSZqH13ilfUle0EWcBca+jeM1au0JjtJ7Rmu8r3RzlJV65h4us
         4RNxrXOjXYly4ptqtjxlznwofOB4Jd2Xgd/sKODdhpFnuJDubvhGMJSfxQ7eywEmSWgE
         V6xg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773343162; x=1773947962; darn=lists.linux.dev;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rAm4iYP5dKixiOkXLqp54PSNBJLPGNPkqOxwaaOp/3E=;
        b=TNweFMU0forVDbCFwiGNIKWnI9WhFU8z3sa3xYtaPQHSu76rqT+hO1pLN5oAvyosPM
         fMBymnBybS9QGA46bQnaPuq4z5hMYkUGh5m8Qx8edhU0B3ZWj9worVi7pUBiq+ErFdRr
         1VIIlOkPlRYYgyNXvs79sDIffduz0+4prdHqaW85bRTbzZkasL/EWcPwZHwjqDvTc+US
         I7s9v/4+Itescj2i0p2jnkksQJPfUFMQkoKVg0CvI5DIjsRxfj76bU11w+JXBdoSa4bh
         jYpjIHmRy2guMcxUjBo161wvNNosM7xA5GXClIhyYcjGjWeOeFjXLn6AYcBV2I8Pf5L5
         XYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773343162; x=1773947962;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rAm4iYP5dKixiOkXLqp54PSNBJLPGNPkqOxwaaOp/3E=;
        b=rEbKTHyOfCaoWxJlskDqkHk9I+Foob25EeoA0vItk1QdFMI0j+EEDvTq9P0WXX/K74
         0EKXvxQkxlIhUdmj3wXg4v8rbnddqZ+PeSRGdt7RYmB43djuTXJXhoj4ugDEwosUVKD0
         4t+EsKW7B801V9jZvibxbWYB2VKnVn9aNoMcWZFVARWbhdnGeS0ja6FSQb6DObtMRy0b
         SYL7f2ZPqvZXwyI3zvXlbO+GekdCq63BP6fBDHbwaC+fLotgdS+ZDO4ODUSRzCVj/h5A
         03bN0WbaavYNKx6WXX4pK2osrW1Y5ywnMzQJK5HbgoZ2SwVkjBTV75sLl6gvm/7I287t
         QZMQ==
X-Gm-Message-State: AOJu0YyxsMVXyj3n0xyVqNyeBdX0ySUEnO3Fe8Zbre1QUGVxJnyynz1S
	2xsn5wIaUxoSs2HLQnhdk2WjwyPAO8BbFNTbTX3Zf/hDec0yjeAgcDy6juuLllUCDpnju80OXJe
	1l1nKqLucJWTLp3Gg5oqtbfxrHV+qrHAZnGyFQwMfggCQGuTCEcMD01k=
X-Gm-Gg: ATEYQzz+h2ed7+q7ifR4EDg/LtxjncrK08GrSsiyKVg5bePnbFGbb7wySCEWwX1Mgdt
	r4bIFTVWQJuFklBMrm0Qe4hDRCsTnJnGjp82erZFpVBYtYPbml344CTdh9n65lHl4bUq6jXH0lL
	VWqIfeF/RhdlHorQQ/0HB8A7mXTy1XXa6mXJL6j0Ym2d2NZYlCh9lLb7NBsDn4I0uXCRI4tKZML
	SyrCsOQY29s/Xt5Pndu5BRWUrlhcKoWXeWJducFwbXXhsJDn4hyTOrTdqHCXXA7+ykBevR+w6jp
	TUrr1eaPGgXhIPfo2aGRJkRoSrz+ffr4neYldPMeRgpxOB0bXireJSqjUAAaUa0=
X-Received: by 2002:a2e:a98b:0:b0:38a:8b28:f9d4 with SMTP id
 38308e7fff4ca-38a8b28fc87mr73301fa.41.1773343162013; Thu, 12 Mar 2026
 12:19:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260312001642.53321-1-brian@purestorage.com> <91ed7162-719f-4ff2-9951-913fe8096f08@suse.de>
In-Reply-To: <91ed7162-719f-4ff2-9951-913fe8096f08@suse.de>
From: Brian Bunker <brian@purestorage.com>
Date: Thu, 12 Mar 2026 12:19:10 -0700
X-Gm-Features: AaiRm52y1m-7QKdiMhkwB4orxtvBmSd4qa2dLGFaVT84Ldv10HnMIXIupBCa5-Q
Message-ID: <CAHZQxyJGxCBkWC7qU2TMowx1G5hPp4UNi3rkixeW4dwEWS9CkQ@mail.gmail.com>
Subject: Re: [PATCH 0/1] checkers: add alua path checker
To: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 12:10=E2=80=AFAM Hannes Reinecke <hare@suse.de> wro=
te:
>
> On 3/12/26 01:16, Brian Bunker wrote:
> > For ALUA-capable storage arrays, multipath-tools currently uses TUR
> > (Test Unit Ready) as the default path checker while a separate
> > prioritizer determines ALUA state. When sysfs provides ALUA state
> > (the common case), no RTPG command is needed for priority. However,
> > if sysfs is unavailable or detect_prio is off, the prioritizer issues
> > RTPG, resulting in two SCSI commands per path check cycle: TUR + RTPG.
> >
> > This patch introduces an 'alua' path checker that uses RTPG as the path
> > check command, providing two benefits:
> >
> > 1. For configurations where RTPG is needed for priority, this eliminate=
s
> >     duplicate I/O by combining path checking and ALUA state retrieval
> >     into a single RTPG command.
> >
> > 2. RTPG provides richer path state information than TUR:
> >     * TRANSITIONING state detected and mapped to PATH_PENDING,
> >       preventing false all paths down during controller failover
> >     * STANDBY state detected and mapped to PATH_GHOST
> >     * UNAVAILABLE/OFFLINE states properly distinguished
> >
> > The richer state information is valuable even when sysfs is available,
> > as TUR cannot distinguish between these ALUA-specific conditions.
> >
> > This design intentionally couples the checker and prioritizer: the
> > alua_cached prioritizer consumes state cached by the alua checker.
> > While this blurs the traditional separation between these components,
> > for ALUA the path state and priority fundamentally derive from the
> > same underlying data, making the coupling a natural fit.
> >
> > This patch sets the alua checker as the auto-detected default for ALUA
> > devices to demonstrate its benefits. We recognize that adopting a new
> > default checker requires careful consideration; the auto-detection can
> > be adjusted or removed based on review feedback.
> >
> > Brian Bunker (1):
> >    checkers: add alua path checker
> >
> >   libmultipath/Makefile                   |   5 +
> >   libmultipath/checkers.c                 |   1 +
> >   libmultipath/checkers.h                 |   1 +
> >   libmultipath/checkers/Makefile          |   3 +-
> >   libmultipath/checkers/alua.c            | 426 +++++++++++++++++++++++=
+
> >   libmultipath/checkers/alua.h            |  15 +
> >   libmultipath/prio.c                     |   1 +
> >   libmultipath/prio.h                     |   1 +
> >   libmultipath/prioritizers/Makefile      |   1 +
> >   libmultipath/prioritizers/alua_cached.c | 225 +++++++++++++
> >   libmultipath/prioritizers/alua_rtpg.c   |  12 +-
> >   libmultipath/prioritizers/alua_rtpg.h   |   1 +
> >   libmultipath/prioritizers/sysfs.c       |   7 +-
> >   libmultipath/propsel.c                  |  25 +-
> >   libmultipath/structs.c                  |   2 +
> >   libmultipath/structs.h                  |   3 +
> >   16 files changed, 721 insertions(+), 8 deletions(-)
> >   create mode 100644 libmultipath/checkers/alua.c
> >   create mode 100644 libmultipath/checkers/alua.h
> >   create mode 100644 libmultipath/prioritizers/alua_cached.c
> >
>
> Hmm. Some array vendor have been less than happy when I
> tried a similar thing during development of the ALUA
> device handler.
> Problem is that RTPG requires a cluster callout on the
> array side, as it needs to contain information about
> the _entire_ target system. Which, for distributed systems,
> is a costly operation. So using this as a path
> checker is not making certain array vendors happy.
From working on one of these arrays, many of the path
state decisions often require the same set of information
to respond correctly to test unit ready.  Other OS's including
both Windows and ESX, once they determine that the array
supports ALUA, use RTPG rather than TUR as the periodic
path checker.
>
> However: as you might have followed the discussion
> about scsi multipathing, maybe we can turn this around
> to profit both sides:
> Can't we move ALUA state handling into the generic
> code, leaving the device handler only to deal with
> explicit ALUA?
> That way we can intercept sense codes and send RTPG
> only when required, such that the ALUA state of
> the scsi device is correct.
> And the the ALUA path checker just has to evaluate
> the information in sysfs.
> _And_ scsi multipathing can use that information, too.
>
> Hmm?
I think that there are likely ways to re-imagine the checker
and prioritizer separation that would have benefit. This
patch wasn't really about going in "as is" but to start that
sort of thought.

In general multipath-tools is "good enough" to support the
ALUA story from my perspective as a target vendor. There
are some improvements that would likely simplify things.

The Linux kernel, in my view, should take these two
changes to complete its ALUA story:
https://marc.info/?l=3Dlinux-scsi&m=3D177189801604075&w=3D2
https://marc.info/?l=3Dlinux-scsi&m=3D176530648031820&w=3D2

It would be great if someone could review those two changes.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), GF: I. Totev, A. McDonald, W. Knoblich

Thanks,
Brian
--=20
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
