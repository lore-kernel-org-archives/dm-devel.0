Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DB826290
	for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 21:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756158382; cv=none; b=Ezydf5eUYyRaMB72lmojgU04kW/i2jrJiGxUs01WLxHsDAynj7OMfLJkHDrSmMnf2on3197MJ7M5GV7lZcGyDwiPJ9LhfLbwGf2QrYueMnlwIh16awhGCfeE7teDKiwOeTgdvxyM5lQamHy6L4qwhSula+hhhAj+oJCwFXjWt88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756158382; c=relaxed/simple;
	bh=StnASrcWwcOp6Y8eGyGgxtfrQ9vncyOR1NdkP89B/SQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UFGe6WzCuI8vyMa6jLreTW/hdgw9ZeSJzB2qUe66LlrBZd7PR83KLqcWQDAWqYH5hQntVz+eNMlQWc09qLeN+f2mNMoFVEZVCcsmsi00Dk1+skTtljKD8P30cg1o3zonk++c4ZXJgIMLWz1+VD+tvupQQEpTnL8ZRTwjD1Eexts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WqmxOnF+; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WqmxOnF+"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afcb7a3a085so772574566b.2
        for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 14:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756158378; x=1756763178; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=StnASrcWwcOp6Y8eGyGgxtfrQ9vncyOR1NdkP89B/SQ=;
        b=WqmxOnF+dvm6ihiUtGKY9yK0Y4u/kDN1KcBF6zGfVMR0VKdNNniajEDpwNcWO2SgcX
         mx34sjlu5nOM1T93T4tBWUTT4QQbX8Yr5VeF5QiR9A7xHjXkUAC7MlB4IwHo7hgdrQvh
         Kq0pVGg9Kj9NoWTPuKfzmivefWmhgLX0+yMEKxrqa7Oaq/peaHs0a1H1QiVR9rTjwHYo
         0+xHS5MQ0CIHVOAY31m7XaOs7D6V/m6r0i6Ei50okH0IIj7fefzaWWg0PKoYnOtJtzEA
         37IqMDxbZvEwkpHvRUQ6rv+/R8VY8VlXO7CxnMh6kEfrTiRwPHwQRNBk8TS9gDKo9xGK
         8BCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756158378; x=1756763178;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=StnASrcWwcOp6Y8eGyGgxtfrQ9vncyOR1NdkP89B/SQ=;
        b=REP2sb0tYqcVUVApWtJr/T8oAA/fA3DOM+pNeN78obRp/aiPmZ3g8SOe/vqTMpF73z
         MKYzqegSUIZjwMP8SuTrz7m4Wv8jLfUGW4Kn9NpWmGJxsm2URF9nIPlqcy+mrbv1mzZ4
         oQERrRO6dIZk8mfeI7atjdYrdbVN6WMfVOD2A0idSdkYpVXJUcUD+KtUj4tJwnTZT+pH
         yc0O/G6l9ZrrwSB8Ul2X/EGkUTtS9XYkyLXfEO4773dGqaD5YU5gtloJgCW8rc6k4qyw
         nosV+ZWg2kClzLY9zdMXSJXh3pxY/nQnnLy/EdZnCNG+jgx/iyXZOySrKYP/jKLFwzb5
         AmuQ==
X-Gm-Message-State: AOJu0YwgxxVFg1tVB57a08C7c7GjdNlxC/qX/xWAydYkWZnM4uqdkM0w
	jgyy2wiWCyvk6/KUS8AnLRKpgIb0RcUdNlzNg7r+CHgibV6HFJr2cr9/eF3FuCmLdL8=
X-Gm-Gg: ASbGncsLApLRkJhrRl39Hz0J4xTGYK0WQRhpqFk4V+O9963neOpFXBu75HwYZKV2xn0
	7ck/4ezk92YTD3Q2+eQIDAH6/rRwctOAnUr+VdHlWA8qklx7kjoWGbAZhyrszjouZxHtgP3HBe+
	1FW++xFucuRhmIHSBwKNhLFlscLKHa9mKHcfxbw4m7ahQlpVnA55JjjL7MpYNzYg0SEZI/iARuy
	+gxFIz2WQX1uRV+VTk+IBOoJ7B20G6eOVgy9uInZ/RclXD5fgEldL6bkLTGPOfn/VvRs13qtogK
	knjA+Beoeajv7niI35D1EyF3N/ro8jvQsYfCQev9LRvi03i6KzoOjncB2tfRGz5FSeF9yhjM3UD
	MXE/rnTE1Dp8N1QMVAqhvSHYxIw7lq5CG4Rixat7uAZa3FWciEFKQxRBOgBOwtrIblaXTOCH7q5
	2kE/LsAhG0lXTbKIA0iLpWWRrzdSCbbvTmGVTzoc6FbqZ5SlH58/jDvxWnCMsouriYdw==
X-Google-Smtp-Source: AGHT+IEQW25EwDJk5446njS4JqXJS//o6ekn+Hw3WFHdFT4EwBqXiBkMwM4hYM6ltMeHpzeDtp/kRw==
X-Received: by 2002:a17:906:d54f:b0:afe:82f4:f96b with SMTP id a640c23a62f3a-afe82f500d1mr438732366b.46.1756158377670;
        Mon, 25 Aug 2025 14:46:17 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe89bd7acesm206170766b.73.2025.08.25.14.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 14:46:17 -0700 (PDT)
Message-ID: <954307f37368994761f71df92dc9ebafc5344987.camel@suse.com>
Subject: Re: [PATCH 00/14] Additional fixes and cleanups
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 25 Aug 2025 23:46:16 +0200
In-Reply-To: <20250726035855.363290-1-bmarzins@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2025-07-25 at 23:58 -0400, Benjamin Marzinski wrote:
> This patchset builds on top of my previous libmpathpersist patchset,
> ("Improve mpathpersist's unavailable path handling") and add various
> fixes and cleanups to multipath's persistent reservation handling.
>=20
> The issues handled by this patchset are:
> - Handling removal of keys from paths that were down when the
> multipath
> =C2=A0 device was unregistered.
> - Changing how conflicts on key registration are handled. Instead of
> =C2=A0 the current rollback method (which was broken anyways),
> =C2=A0 libmpathpersist now retrys with REGISTER AND IGNORE, as long as th=
e
> =C2=A0 REGISTER command completed successfully down some of the paths.
> - Changing when the reservation key is set to fix corner cases on
> =C2=A0 failure and registration while paths are coming up.
> - Retrying on conflicts in mpath_prout_common to fix corner cases
> when
> =C2=A0 a path is coming up while a doing a reserve, preempt or clear.
> - Allowing registrations to succeed when there are retryable errors,=20
> =C2=A0 if the paths are actually down.
> - Fixing the reservation key validation code
>=20
> I realize that a number of these fixes are dealing with races between
> libmpathperist and multipathd, which points to shortcomings with the
> current design of libmpathpersist. The code could likely be simpler
> and=20
> more robust if limpathpersist was a thin wrapper around commands to
> multipathd, which handled issuing the actual persistent reservation
> commands. However, we have customers that need persistent
> reservations
> working well on currently released versions of the mutipath-tools,
> and
> redesigning how the libmpathpersist library works is a much larger
> task,
> and even harder to backport. I'd like to know if people think that
> would
> be a worthwhile task for later, however.

Difficult to say. It seems to me that you have eliminated most obvious
races. But yes, it would be cleaner to have a single instance
(multipathd) deal with PRs.

It is awkward that libmpathpersist contains code that sends commands to
multipathd, while multipathd itself links with libmpathpersist. This
begs for a separation of libraries.

Also, I think there are still too many instances of condlog(0, ...) in
libmpathpersist. But then, there are too many in our code in general,
so we can clean this up later.


>=20
> Benjamin Marzinski (14):
> =C2=A0 limpathpersist: remove update_map_pr code for NULL pp
> =C2=A0 libmpathpersist: move update_map_pr to multipathd
> =C2=A0 multipathd: clean up update_map_pr and mpath_pr_event_handle
> =C2=A0 libmpathpersist: clean up duplicate function declarations
> =C2=A0 multipathd: wrap setting and unsetting prflag
> =C2=A0 multipathd: unregister PR key when path is restored if necessary
> =C2=A0 libmpathpersist: Fix-up reservation_key checking
> =C2=A0 libmpathpersist: change how reservation conflicts are handled
> =C2=A0 libmpathpersist: Clear prkey in multipathd before unregistering
> =C2=A0 libmpathpersist: only clear the key if we are using the prkeys fil=
e
> =C2=A0 libmpathpersist: Restore old reservation key on failure
> =C2=A0 libmpatpersist: update reservation key before checking paths
> =C2=A0 libmpathpersist: retry on conflicts in mpath_prout_common
> =C2=A0 libmpathpersist: Don't always fail registrations for retryable
> errors
>=20
> =C2=A0libmpathpersist/libmpathpersist.version |=C2=A0=C2=A0 1 -
> =C2=A0libmpathpersist/mpath_persist_int.c=C2=A0=C2=A0=C2=A0=C2=A0 | 363 +=
++++++++++++---------
> --
> =C2=A0libmpathpersist/mpath_persist_int.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 2 -
> =C2=A0libmpathpersist/mpath_pr_ioctl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 12 +-
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +
> =C2=A0mpathpersist/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0=C2=A0 2 -
> =C2=A0multipathd/cli_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 11 +-
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 132 +++++++--
> =C2=A0multipathd/main.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0 2 +
> =C2=A09 files changed, 311 insertions(+), 216 deletions(-)

For the series, except for the patches I replied to:
Reviewed-by: Martin Wilck <mwilck@suse.com>

As for the previous series, I have applied out clang-format formatting
and fixed a few typos, and pushed the result to my tip branch [1].

Regards
Martin

