Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A191C393DCA
	for <dm-devel@lists.linux.dev>; Sun, 24 Aug 2025 21:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756070478; cv=none; b=tUAfG1uPHn/aTq3iusqaUWL9PFuUZiSsLiQJjNpAtTwkVIyJrAoxNOgyJUqNPX04Ea5/8pP73q04C2ucS2txfOOvxc8xRNqoBn/iRe8qAHQtt9jsKYskOQSodoZ7HG61fp1GzkbZKrN6yyPNL2LNJXgWWZyU+pykLeA7bW/AlQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756070478; c=relaxed/simple;
	bh=m8DdgRIRTouMi3kKmdZqUDVjvRhYIU+1q61HnLPHd54=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LPweZPcdNYxir8j2OYo4pQCPHRqK8DV73hBadzLkQ4rE8iaXYW3XUzHMSsccfnNqeYdhO/pMokRhxjLPwQbHejcnMIPgitTwHF+KeaFLfybshNgGfYOAUYz9e8oLeeBTcnFu8Gdy4w3L/Eo57EHZggPhoGCcrx0M4P/eNI63gaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HwfpFGbt; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HwfpFGbt"
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-45a20c51c40so30163535e9.3
        for <dm-devel@lists.linux.dev>; Sun, 24 Aug 2025 14:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756070474; x=1756675274; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m8DdgRIRTouMi3kKmdZqUDVjvRhYIU+1q61HnLPHd54=;
        b=HwfpFGbtdVmGl122AEFVn5CtyHHef/MqYTVtkkXFPkJyBBlkPXjMUgRqKIbPfzlwiu
         zkPG9J6S1TkGACCxBzUxOMEg0qMPDL4RacVMjRVed6gVDvvrubcMkacDux/R5wfRb1Eb
         OgGlFO706vULMmcjf4AUmt/UzHillXAYcqcubiBViwn+whULH/tDs91aueJg6SwUWUzt
         nS6s56X7jDy4l7Ho4jbnJUuRCPJISeOcFrOBuol32+gF2udulXUfK9Yu88LMHqV3NjgJ
         Jjrzbww4h8RnIBtAFbnxSRYDK4M+Px0qyWbYdls/0brRIDth6d7FslNbebejrwFX4EVB
         l7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756070474; x=1756675274;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m8DdgRIRTouMi3kKmdZqUDVjvRhYIU+1q61HnLPHd54=;
        b=WI/w7iw5a3ZJqw+feitSicwwNQl9kdsb46hjgUpFo+RsqRIS1MGjA1zAZ2NYBVle3P
         kRw5ftTw/VQfpp+a15JgtVjLj8bYcjSRNKn5yMlZbYB2OPGdwgsLcBxE2Xuxw+y4d4Ba
         w2wcBzqh1sy+8lWj2+tYDoir3iX9U5pNuALMvgpVxiJ2XQP30+yR5VK6iBqXeafNDihr
         y34Rw1m0TkPcpiBHbYsuJZptyW+wGUI186ttNDg+sJFD47e0n1MVqjCIQU3nXeHRugY5
         9G7WYiENMsl05U/BHtKNi0sGLBsU/X5dO++NpRb7yjL4gx1cIia9oTT6UQUCLqCx+xvi
         1o+A==
X-Gm-Message-State: AOJu0Yz8Ba9qt5aKJ60Ti+95E/DC4p96EQlTEKoe/cNWHwnXLIQyOYnu
	GvQHm+THGhM9cJPSiT6fyz0GPoBT6t+CwFXvNffTl30GwrrX8wQHtVDHHZwfwEh8Qf0=
X-Gm-Gg: ASbGncslHtvbT7F0ZTicKBqRpHNROeYX4AVUsPfeBPiijg9n7cirq0nJ9nCeaE3r/kP
	CsHNE67W5teP8N0AzDNtWsIMse9525ZJKjLwlZMjEl/5PPzYSr9AKy2mGxb/c4hRv4MHARnaYu0
	GTfEr83YP22VuNfQjqkd2SQiMEMNBmZMt7JkNEGl7Lne9yHqEQttca9lrRNSW9czmNM9YFZ4HtQ
	5X0Qyzgd1OynPJsYk/7BQAIUWDtV27ebsciqrWkXOoe+oZBzgpRko36eF+Y4pkGFEavPjSSbf/6
	5gRQvNVV1+f4jZ0BatewFtGwjzoMMPPJ2tB3+1+C8AHJyrAvuwFVuWDQuH8a8ZLZGUAfRRSkhCr
	vEiGxmt1WApQzZHw7lm9T/y8Ty7U19Tj29ekMSUSXFDU8/KmHHOeUPOsIb+fexk+qEpuj5rClPo
	nm/vIPgbUH+C5n//6xrDANqwaX0sxX9S92ou6B18QS452lIVCSMRzcVE/21Z9DJSET
X-Google-Smtp-Source: AGHT+IEKiTiEILG9/k5hGzXMbUCv3RHTUMxdwxkvsOek4vGUOxAPJpYVSI79u8j4athEIFz3RYeUUA==
X-Received: by 2002:a05:600c:350c:b0:45b:47e1:f5ff with SMTP id 5b1f17b1804b1-45b517dbf8amr83355555e9.35.1756070473733;
        Sun, 24 Aug 2025 14:21:13 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5f9b9dcdsm20820075e9.22.2025.08.24.14.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 14:21:13 -0700 (PDT)
Message-ID: <a7ad575ddd0584383f6f506f0723d807cae751de.camel@suse.com>
Subject: Re: [PATCH 00/15] Improve mpathpersist's unavailable path handling
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 24 Aug 2025 23:21:12 +0200
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hi Ben,

On Thu, 2025-07-10 at 14:10 -0400, Benjamin Marzinski wrote:
> A problem that mpathpersist has with making SCSI Persistent
> Resevations
> to a multipath device work like they do to individual SCSI devices is
> that some of the paths to a multipath device might be down or missing
> when the mpathpersist commands are run. Multipath handles registering
> a
> new key pretty well. If paths are unavailable at the time of the
> command, the key is registered when they later become available.=C2=A0 Bu=
t
> if
> the multipath device is also holding a reservation on one of its
> paths,
> things get trickier.
>=20
> If a persistent reservation is being held by an unsuable path of a
> multipath device (the path can either be down or completely removed),
> libmpathpersist can't change it just by forwarding the regular
> persistent reservation commands. This can cause problems both for the
> RELEASE command and the REGISTER and REGISTER AND IGNORE commands if
> they are used to change from one key to another. If the path holding
> the
> reservation is unavailable, the reservation won't be released or have
> its key changed, as expected. I wish the problem of having a
> reservation
> key changed while it is holding the reservation was simply a
> theoretical
> one, but there are enterprise users of multipath that need this
> capability.
>=20
> This patchset deals with both of these problems. libmpathpersist
> always
> had code to handle releasing a reservation held by an unavailable
> path,
> but the existing method is broken. It relies on poorly supported
> optional features of SCSI Persistent Reservations: the READ FULL
> STATUS
> command and specifying Initiator Ports with the REGISTER command
> (SIP_C). Also, fixing its current issues would additionally require
> supporting the All Target Ports option (ATP_C). This existing
> workaround
> has been redesigned to use the PREEMPT command instead. Key changes
> where the path holding the reservation is unavailable were not
> previously handled by libmpathpersist. This patchset also handles
> them
> using the PREEMPT command.
>=20
> patches 0001-0008 are simply cleanups an prep work.
> patches 0009-0010 redesign the RELEASE command workaround
> patch 0011 creates a workaround for the REGISTER command
> patch 0012 makes this work for the REGISTER AND IGNORE command as
> well
> patches 0013-0014 are more prep work
> patch 0015 Adds a safety check before preempting a key, so that only
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devices that=
 are holding a reservation will do the
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 preemption
>=20
> These workarounds depend on the fact that managing scsi persistent
> reservations for multipath devices has never worked correctly if
> multiple nodes use the same persistent reservation key for the same
> device. multipathd needs to be able to register the key on new paths,
> but the key could have been preempted since it was registered for the
> multipath device. To make sure that multipath isn't automatically
> registering paths for a device that has been preempted, multipathd
> checks that the configured key has already been registered by other
> paths of the device.=C2=A0 Unfortunately, there is no way to verify that
> the
> other paths to the multipath device on this node are the ones holding
> the keys in question. If another node is using the same key for the
> device, those registered keys could belong to paths on the other
> node,
> and there could be no registered keys from this node (likely due to
> being preempted). If multipathd registered the key for this new path
> because it saw another node's keys, then a preempted node would
> suddenly
> gain access to the storage.
>=20
> As far as the workarounds from this patchset go, if there was another
> node using the same key, then preempting the key in these workarounds
> would preempt the other node as well. The safety check in patch 0015
> tries to make sure that this only happens when the current is holding
> the reservation, but this isn't foolproof.
>=20
> I should also note that while working on this patchset, I noticed a
> number of other issues with the persistent reservation code, mostly
> involving changing a registered key. I'll be fixing them in a future
> patchset.
>=20
> Benjamin Marzinski (15):
> =C2=A0 multipathd: remove thread from mpath_pr_event_handle
> =C2=A0 libmpathpersist: remove uneeded wrapper function.
> =C2=A0 libmpathpersist: reduce log level for persistent reservation
> checking
> =C2=A0 libmpathpersist: remove pointless update_map_pr ret value code
> =C2=A0 multipathd: use update_map_pr in mpath_pr_event_handle
> =C2=A0 libmpathpersist: limit changing prflag in update_map_pr
> =C2=A0 multipathd: Don't call update_map_pr unnecessarily
> =C2=A0 libmpathpersist: remove useless function send_prout_activepath
> =C2=A0 limpathpersist: redesign failed release workaround
> =C2=A0 libmpathpersist: fail the release if all threads fail
> =C2=A0 limpathpersist: Handle changing key corner case
> =C2=A0 libmapthpersist: Handle REGISTER AND IGNORE changing key corner
> case
> =C2=A0 libmultipath: rename prflag_value enums
> =C2=A0 libmpathpersist: use a switch statement for prout command
> finalizing
> =C2=A0 libmpathpersist: Add safety check for preempting on key change
>=20
> =C2=A0libmpathpersist/libmpathpersist.version |=C2=A0=C2=A0 2 +-
> =C2=A0libmpathpersist/mpath_persist_int.c=C2=A0=C2=A0=C2=A0=C2=A0 | 505 +=
+++++++++++++--------
> --
> =C2=A0libmpathpersist/mpath_persist_int.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 2 +-
> =C2=A0libmpathpersist/mpath_updatepr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 74 +++-
> =C2=A0libmpathpersist/mpathpr.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
> =C2=A0libmultipath/libmultipath.version=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 10 +-
> =C2=A0multipathd/callbacks.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
> =C2=A0multipathd/cli.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 4 +-
> =C2=A0multipathd/cli.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
> =C2=A0multipathd/cli_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 70 +++-
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 149 +++----
> =C2=A012 files changed, 483 insertions(+), 343 deletions(-)

For the series, except those patches I've replied to:
Reviewed-by: Martin Wilck <mwilck@suse.com>

I have taken the liberty to apply the changes suggested by the clang-
format style checker and the fixes for the previously mentioned gcc4.8
compile errors in my tip branch. I also already added my Reviewed-by:
tags there.

I should add that while the logic of this patch set makes a lot of
sense to me and I've done my best to do a careful review, I don't feel
that understand the possible corner cases well enough to be able to
confirm that they can't possibly have unwanted side effects. Doing so
would require a lot more testing and deep-diving into the matter than
I've had time for. You are more exprienced with PR scenarios than me.=20
Your analysis of the various cases is as solid as it gets, AFAICT.

Thanks
Martin








Martin

[1] https://github.com/openSUSE/multipath-tools/tree/tip
