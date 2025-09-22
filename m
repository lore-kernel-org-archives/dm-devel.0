Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4378F310645
	for <dm-devel@lists.linux.dev>; Mon, 22 Sep 2025 18:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758565576; cv=none; b=H9sHUhxsnT2BZsLHHKaTJU/Nb3Q5C0VtbXOHVG2wfBmFH0N6087UHFCrnNeIVwZojk26HJV1syrwgig97weLxwjCs6FCD4eVJ0PDZNOqrIErrw2fMS4cpRqB3K1O/d97fkzqCKxhLh9gCGSXS9RB3orMjX6HoolMhVoUx7eVf9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758565576; c=relaxed/simple;
	bh=SWkHXnNrGopmqLLPbUNbnqX2+qT2MJ51zQ2Hk8Xfebk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B5704RWM4XEB1IXY0i3BdncIwBeloQITn0gdEMERnec71TD4nfAveSstxe2gh8MTFO7w/jxGpunnA1H/RUupMow6pEg5DtLjgz2onJ/RIEdPIDcwkyKvlO/WWpHKXDeq4g1lknGzN0CkjcZsVkfw1qr7wzT2cF42dinh3sUCIow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fw3SGkPp; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fw3SGkPp"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b07c28f390eso871064166b.2
        for <dm-devel@lists.linux.dev>; Mon, 22 Sep 2025 11:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758565572; x=1759170372; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SWkHXnNrGopmqLLPbUNbnqX2+qT2MJ51zQ2Hk8Xfebk=;
        b=fw3SGkPpJl1RTMGgmBqJaQ3+cR9lyypX+7T8pgSvnCs2JY0p02Adfv+d0jGLXv46E8
         vuk21kOzF3uagHcVBR4brLwEcJKc3SxhTkWlV98bB2RUpYLkiEoQWgogL2QcXWeOxIgO
         cqkoNucnuNIaGKGNCwITRtyQGnZjdak4ImVcpUvXK26G/cX8aqz/orCkv9/45Mg/KF8e
         MF0BAIpMwv5tGJqB0hWsVc9a+N1f/9+JIxMQR4I6yTuWEHLadVmk8QXPP6mxXFptpZvp
         KVp+CbD2qQiGbB2iO/RIghUUOuXJIqzDxcXoLNbpihoGMJnNQBO7hHZBFJAFjYB+jEuV
         lxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758565572; x=1759170372;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SWkHXnNrGopmqLLPbUNbnqX2+qT2MJ51zQ2Hk8Xfebk=;
        b=pJf2jBxhsF7v+ywDZixLFvHKAzbabhcUu2JXy0wrYKZYpmx5aJqiz4O3F+cuu3aeF3
         B6AHLZ95duWuIYn8L7H2Q46B2LbgFw0wzsckfXyEhVHgVIBHUQ2WonlgEmrfOXnWSnIb
         bOcXgOz3xD33pp5Ehw/m9ZFZCrq9ZvjAi5O9bwht4kv2p2okjEs37CN8Qq6Q14SB8ufs
         eQy4HxIiHYPP/6CjsqcqsmNWGYVrJEKhyysvM6UEAc2niePwhlht+pPByRyXmDi12/4w
         abm32KMYy0ZJHiUlNWp+UCoqzw7zxR30LK24WPmRbffFdN3J26vRW1/TvXwyI8dpzYHI
         7DWQ==
X-Gm-Message-State: AOJu0Ywn+z/GbhMiIKYD4Hu1yS1jIhwJgZfFwtyPyGLyj6PYmXBhUjOG
	RIZ+zi1SSkU9gIbjwqnrRY38HiQeIBcTHxtv42sviXtTKIEVftH6MMHgWKvnqcYQHcI=
X-Gm-Gg: ASbGncsf7ZbdJqjzu0b6IghVv7JP/8thhQbbEx9iG/jQ9ddvIhZgnBQeZR8Qp3hxgfO
	HPBiNBzr0KtWMuYylTd9bZblzUTs/khHpufEI454Z/XT4/iIZ1h++8+AVI3IiraGdUlb5m2GOrO
	QS/C0h1mvjKq/I8f9c7dYDBa/9FbfEmTxSRE7XUMSw01dzFwuJmZITMnlNsejBBTP/ispAC811c
	x3s1kdmaH8UqBXpvGS8GccFCbUKTY3TzWXtN2+LrynvjybD/RK8PqiQxTXx9i7Q2wKqpuA1ayEn
	j2bYzi30wUe6+OTquZh4vvZx55niwLI5S35cOIcleUbjuHKPoT5xa6XgOqLPA6Clwv+ZJBuE6VW
	LA3GIxi8RpSgRP5Zr7g6oL2g39tj96ank6d5PSJwUTP4wg20KF9VSDJY5JSbzXnaGLA2f1q/EVJ
	CsbkXK+ITUFxlLAW9b2vxZIZfwXGAkFdn5+a4xqSzxNenhkCui3E0nX031JA==
X-Google-Smtp-Source: AGHT+IFZ+r/lU8q9fRtay0Z6VoUmSlZ8M4xZ9Tndn8hXcrqkrogAg3qGtZERAqNlEeJVnML+7/0osA==
X-Received: by 2002:a17:907:969f:b0:b2c:8ff:87ff with SMTP id a640c23a62f3a-b2c08ff88d7mr441492566b.22.1758565572288;
        Mon, 22 Sep 2025 11:26:12 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b264fc79404sm807310766b.10.2025.09.22.11.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 11:26:11 -0700 (PDT)
Message-ID: <5f82e12c4404a3be9d51cb6656fd725597f080a8.camel@suse.com>
Subject: Re: [PATCH v2 00/32] Multiple mpathpersist improvements
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 22 Sep 2025 20:26:11 +0200
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-09-08 at 19:59 -0400, Benjamin Marzinski wrote:
> The mpathpersist code has many areas where it does a poor job of
> mimicking the behavior of setting up persistent reservations on an
> individual device, especially if paths to the multipath device are
> missing or unusable. This patchset is aimed at fixing a number of
> them. It is a combination of my two previous patchsets:
> [PATCH 00/15] Improve mpathpersist's unavailable path handling
> and
> [PATCH 00/14] Additional fixes and cleanups
> along with additional patches.
>=20
> Issues handled by the patchset are:
> - Changing or unregistering a key held by an unavailable path that
> also
> =C2=A0 holds the reservation. This is done by preempting the old key
> =C2=A0 (after verifying that the multipath device is holding the
> reservation)
> - Releasing a reservation held by an unavailable path. This has
> always
> =C2=A0 had code to handle it, but it relied on optional Persistent
> =C2=A0 Reservation features. The new code preempts the key and then
> restores
> =C2=A0 the removed registered keys (while the device is suspended).
> - Handling removal of keys from paths that were down when the
> multipath
> =C2=A0 device was unregistered.
> - Changing how conflicts on key registration are handled. Instead of
> =C2=A0 the current rollback method (which was broken anyways),
> =C2=A0 libmpathpersist now retries with REGISTER AND IGNORE as long as th=
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
> Changes in V2:
>=20
> First set (as suggested by Martin Wilck)
> 0009: Added a comment explaining the select_skip_kpartx()
> 0010: use all_threads_fail variable instead of rc.
>=20
> Second set
> 0003 (now 0018): Remove noisy variable from update_map_pr
> 0007 (new 0022): Added comment explaining why we won't fail syntax
> error
> =C2=A0=C2=A0=C2=A0=C2=A0 checks after updating the reservation key, as su=
ggested by
> Martin
> =C2=A0=C2=A0=C2=A0=C2=A0 Wilck (for patch 0012, but it made more sense to=
 change it here)
>=20
> 0030 new patch to not attempt workaround when a release fails due to
> a
> =C2=A0=C2=A0=C2=A0=C2=A0 mismatched type.
> 0031 new patch to fix an issue with issuing a RESERVE command to the
> =C2=A0=C2=A0=C2=A0=C2=A0 path that doesn't hold the reservation.
> 0032 new patch to fix an issue with a multipath device preempting its
> =C2=A0=C2=A0=C2=A0=C2=A0 own reservation key.
>=20
> Benjamin Marzinski (32):
> =C2=A0 multipathd: remove thread from mpath_pr_event_handle
> =C2=A0 libmpathpersist: remove uneeded wrapper function.
> =C2=A0 libmpathpersist: reduce log level for persistent reservation
> checking
> =C2=A0 libmpathpersist: remove pointless update_map_pr ret value code
> =C2=A0 multipathd: use update_map_pr in mpath_pr_event_handle
> =C2=A0 libmpathpersist: limit changing prflag in update_map_pr
> =C2=A0 multipathd: Don't call update_map_pr unnecessarily
> =C2=A0 libmpathpersist: remove useless function send_prout_activepath
> =C2=A0 libmpathpersist: redesign failed release workaround
> =C2=A0 libmpathpersist: fail the release if all threads fail
> =C2=A0 libmpathpersist: Handle changing key corner case
> =C2=A0 libmpathpersist: Handle REGISTER AND IGNORE changing key corner
> case
> =C2=A0 libmultipath: rename prflag_value enums
> =C2=A0 libmpathpersist: use a switch statement for prout command
> finalizing
> =C2=A0 libmpathpersist: Add safety check for preempting on key change
> =C2=A0 libmpathpersist: remove update_map_pr code for NULL pp
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
> =C2=A0 libmpathpersist: update reservation key before checking paths
> =C2=A0 libmpathpersist: retry on conflicts in mpath_prout_common
> =C2=A0 libmpathpersist: Don't always fail registrations for retryable
> errors
> =C2=A0 libmpathpersist: Don't try release workaround for invalid type
> =C2=A0 libmpathpersist: Don't fail RESERVE commands unnecessarily
> =C2=A0 libmpathpersist: reregister keys when self preempting
>=20
> =C2=A0libmpathpersist/libmpathpersist.version |=C2=A0=C2=A0 3 +-
> =C2=A0libmpathpersist/mpath_persist_int.c=C2=A0=C2=A0=C2=A0=C2=A0 | 817 +=
+++++++++++++--------
> --
> =C2=A0libmpathpersist/mpath_persist_int.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 4 +-
> =C2=A0libmpathpersist/mpath_pr_ioctl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 12 +-
> =C2=A0libmpathpersist/mpath_updatepr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 74 ++-
> =C2=A0libmpathpersist/mpathpr.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
> =C2=A0libmultipath/libmultipath.version=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 12 +-
> =C2=A0mpathpersist/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0=C2=A0 2 -
> =C2=A0multipathd/callbacks.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
> =C2=A0multipathd/cli.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 4 +-
> =C2=A0multipathd/cli.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
> =C2=A0multipathd/cli_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 66 +-
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 237 ++++---
> =C2=A0multipathd/main.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0 2 +
> =C2=A015 files changed, 755 insertions(+), 488 deletions(-)

For the series:

Reviewed-by: Martin Wilck <mwilck@suse.com>

