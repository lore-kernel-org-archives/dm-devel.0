Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9B6154C15
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 15:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714662386; cv=none; b=YtAouJR4xyQ2jzy2s32VDcymrZKCDZGVQ9h68QHRZVs2PHjWCulvO7m/ysSp+WtgxnOe9JQY22SVGmBY4Qa5198VA44r44sBz/szfobU7plkseh/jv8Jot45eOJfUSxQNqA9Ax5P5UPZL1glDKvwWc4LEMh/tZg4iLx43wSFXc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714662386; c=relaxed/simple;
	bh=VVNXoYHLNEDZXn5ejzXUjJ6p3IxCMOfnIutmCtvSYes=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DdJcoNss8TpYE3WEnMKSurYkAKvTz10IUk0dtxmK8ng/ST1k401Sowbruj1jj963FLY603NHekwg4dUuWIgcEwT7CO0D4ut8u4+kJLfXHW1yDTmhiNskFUeucbhjz29UhA+Gk885U3I9dGG5Eb0Nl/hFq/e5iFJORJIaGWrUG9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GGA+IlNX; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GGA+IlNX"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-571be483ccaso9280909a12.2
        for <dm-devel@lists.linux.dev>; Thu, 02 May 2024 08:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714662382; x=1715267182; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VVNXoYHLNEDZXn5ejzXUjJ6p3IxCMOfnIutmCtvSYes=;
        b=GGA+IlNXP3ImoQfrwVO9pLMWDKMLifGEVFZAGxs2z3BKaVkSoO5k+lSEcZZlTzuF3Z
         h2fzxZn+TWrXSaoF5aIA5ymywO/pvQQwEXfnHLcRd2o45BxentWYkz9Q5Ze18ngBy5EM
         QKzFfiYkxbaS8RT0c+3LSRrCakqdmiZmF9aK2HrLTrDYyih7o0MvHWnkjZ3NcApFX6Ha
         zrU9yn/NPKik9S71zbn/JFArsTnui4Rz3vP+ukz43YFYIMhEUuLd1RFAx06BkWeiiLLw
         LGL/EGG5SH2Bih/PsZMdT7NooFAstKTLROCt1bO3xPXukxVe6I+9djmbtR+70QbFZ1Vn
         B8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714662382; x=1715267182;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VVNXoYHLNEDZXn5ejzXUjJ6p3IxCMOfnIutmCtvSYes=;
        b=hHV5NjKkHXd8zK6LKwjzYeEKqrvy5sulFv4+KU35D3UDkJ/zMxBFYWFDtb+wzEYyeT
         7peaTxc0rdzzzcAVuNctobeqafPs5T+FYm0O9S2+tFypp8Pd+S3e8xzm2w6cyaOTuRwr
         yQQy22j8zPbrCWKay2qmP6dG7TFo3UZKM4hn4P4QiL2T6uKyk74eXc+PsSoygzzHDiu+
         gNQVRZvFmLAwlOWJyYUdomfM1klxlL13ighaMNQaCB6QVvPprT2qtUrWZfonbmafVxE5
         iqkykAybdvKc/CwQo+i4CcQWh96lDRnDKwp+haJjkvz2ICEt0P1DuRAaQMkIuVGtODse
         A+NA==
X-Gm-Message-State: AOJu0Yx4oQS4bAa8il6UteR6a8p45oXHz2rgh1WVStPHV/35fvVaiU2A
	B2UM2n3c5EAXEAnnSwtdR4IIMHHQmfFil7TVrWf1LY4aiGhaBN5Z9tDJsy8gJjk=
X-Google-Smtp-Source: AGHT+IHtJb3VncuT7gkyR9UjwlCYPfLX46KdWWj9BmwrK8F97/gB3vEIaVTiVBZVfNtmUZ7QaOW5yQ==
X-Received: by 2002:a50:f613:0:b0:572:47be:be36 with SMTP id c19-20020a50f613000000b0057247bebe36mr3709734edn.0.1714662381973;
        Thu, 02 May 2024 08:06:21 -0700 (PDT)
Received: from ?IPv6:2003:de:373e:dc00:b298:a6be:282c:8242? (p200300de373edc00b298a6be282c8242.dip0.t-ipconnect.de. [2003:de:373e:dc00:b298:a6be:282c:8242])
        by smtp.gmail.com with ESMTPSA id fi24-20020a056402551800b005727dc26598sm619942edb.13.2024.05.02.08.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 08:06:21 -0700 (PDT)
Message-ID: <a686098a14c285146baeb268ebc41406271af57e.camel@suse.com>
Subject: Re: [PATCH v2 2/5] libmultipath: change flush_on_last_del to fix a
 multipathd hang
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 02 May 2024 17:06:20 +0200
In-Reply-To: <20240425233517.2125142-3-bmarzins@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
	 <20240425233517.2125142-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-04-25 at 19:35 -0400, Benjamin Marzinski wrote:
> Commit 9bd3482e ("multipathd: make flush_map() delete maps like the
> multipath command") fixed an issue where deleting a queueing
> multipath
> device through multipathd could hang because the multipath device had
> outstanding IO, even though the only openers of it at the time of
> deletion were the kpartx partition devices. However it is still
> possible
> to hang multipathd, because autoremoving the device when all paths
> have
> been deleted doesn't disable queueing. To reproduce this hang:
>=20
> 1. create a multipath device with a kpartx partition on top of it and
> no_path_retry set to either "queue" or something long enough to run
> all
> the commands in the reproducer before it disables queueing.
> 2. disable all the paths to the device with something like:
> =C2=A0# echo offline > /sys/block/<path_dev>/device/state
> 3. Write directly to the multipath device with something like:
> =C2=A0# dd if=3D/dev/zero of=3D/dev/mapper/<mpath_dev> bs=3D4K count=3D1
> 4. delete all the paths to the device with something like:
> =C2=A0# echo 1 > /sys/block/<path_dev>/device/delete
>=20
> Multipathd will hang trying to delete the kpartx device because, as
> the
> last opener, it must flush the multipath device before closing it.
> Because it hangs holding the vecs_lock, multipathd will never disable
> queueing on the device, so it will hang forever, even if
> no_path_retry
> is set to a number.
>=20
> This hang can occur, even if deferred_remove is set. Since nothing
> has
> the kpartx device opened, device-mapper does an immediate remove,
> which
> will still hang. This means that even if deferred_remove is set,
> multipathd still cannot delete a map while queueing is enabled. It
> must
> either disable queueing or skip the autoremove.
>=20
> Mulitpath can currently be configured to avoid this hang by setting
>=20
> flush_on_last_del yes
>=20
> However there are good reasons why users wouldn't want to set that.
> They
> may need to be able to survive having all paths getting temporarily
> deleted.=C2=A0 I should note that this is a pretty rare corner case, sinc=
e
> multipath automatically sets dev_loss_tmo so that it should not
> trigger
> before queueing is disabled.
>=20
> This commit avoids the hang by changing the possible values for
> flush_on_last_del to "never", "unused", and "always", and sets the
> default to "unused".=C2=A0 "always" works like "yes" did, "never" will no=
t
> disable queueing, and "unused" will only disable queueing if nothing
> has
> the kpartx devices or the multipath device open. In order to be safe,
> if
> the device has queue_if_no_paths set (and in case of "unused", the
> device is in-use) the autoremove will be skipped. Also, instead of
> just
> trusting the lack of "queue_if_no_paths" in the current mpp-
> >features,
> multipathd will tell the kernel to disable queueing, just to be sure
> it
> actually is.
>=20
> I chose "unused" as the default because this should generally only
> cause
> multipathd to work differently from the users perspective when
> nothing
> has the multipath device open but it is queueing and there is
> outstanding IO. Without this change, it would have hung instead of
> failing the outstanding IO. However, I do understand that an argument
> could be made that "never" makes more sense as default, even though
> it
> will cause multipathd to skip autoremoves in cases where it wouldn't
> before. The change to the behavior of deffered_remove will be
> noticeable, but skipping an autoremove is much better than hanging.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/defaults.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
 2 +-
> =C2=A0libmultipath/dict.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 72 +++++++++++++++++++++++++++++++--
> --
> =C2=A0libmultipath/dict.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0libmultipath/hwtable.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 6 +--
> =C2=A0libmultipath/propsel.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 4 +-
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 7 ++--
> =C2=A0multipath/multipath.conf.5.in | 20 +++++++---
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | 39 +++++++++++++++----
> =C2=A08 files changed, 122 insertions(+), 29 deletions(-)
>=20
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index 64b633f2..ed08c251 100644

The spell checker noted a typo ("parition") which I'm going to amend.

Reviewed-by: Martin Wilck <mwilck@suse.com>


