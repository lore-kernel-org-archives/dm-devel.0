Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8E1143C54
	for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 20:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721334913; cv=none; b=iDiw9WSKZD5bWOzWXUxYWXr8jAdKA/48aesQVB8g94Zic4u+sBgewJsbeINTNhBcr2tyWqBgM538FyeR7LHkTf/htawfW77LA0pupKWyRVURsCUSW/Ze+TV43yQYfCOsFt5JnyPQmDrdZT1JCSMgT9LasLDrEhDlsnVNXfNw08A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721334913; c=relaxed/simple;
	bh=gcTyiVvCQuj8SmY2rPOxMSZs+m48AR2E7NS357cSTXE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gok3kriRr6n5JrLLVZMqSWszc0RHUjT95SWwZGihH3UNs5HqVFBVXs0Qm2AT5AHrnJSrjp2NkOn499zZZ9InrAMoTvIvzRrNylqE90YgcV/NmqOndRqS9l5BBD8HU3w5k481dnX+uMRWVqeDukfFBsDYiXIziLI+vdjX/zvLNBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SiBeCICd; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SiBeCICd"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52ed741fe46so1194660e87.0
        for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 13:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721334909; x=1721939709; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gcTyiVvCQuj8SmY2rPOxMSZs+m48AR2E7NS357cSTXE=;
        b=SiBeCICdb+HFREgk1RANGlWhdEEmS/POCPKwZqDNB+CEWFtZov5sr3dhgKfnnSpino
         ZZltOertcP34hMa86Xn/XCcVyMeUlkA/DFHl8UENWwGbl8ZF7WidCizqXRxU3GmhMgrG
         iSymJm8isDifOQLd7SpVHP4RVTfwRnnwVwDbZtLlN6VvIVlMllm+V0e0364IGr/LHI8v
         LRrb6MJvN4hprBiZVEaRC9lK8D/9j+dCImf1yauOgMIhA2L/YkW2CqiKnjOgmJRa6qI+
         5eBDm4/gjcPlEfN0qoBfn3DNyar72N/PxTyJf7dSL4wzsIMsoW6cxnj4BZdTfWod0qKw
         URtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721334909; x=1721939709;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gcTyiVvCQuj8SmY2rPOxMSZs+m48AR2E7NS357cSTXE=;
        b=CGAezDds+wOpd+HVZoWIpoTDMEv7ix0kt6i2Cf4molh3UlbJih9lygYSrxx3p+dhZ7
         G9CPLx5LDj3uV1gC5Z++FaJyPtVT5rgNMKn0O2sXaX8hhTIm6dcjRTE1BhiL8l79qNkA
         f8W1Nub+s+eegEr55QmWKJFCLytNbAt/Lk4JtT/rtg8F39ScYAOF9M146JJEMzH8XlXP
         yC9L8PsAggFBpiY7wLVHm+s0qigAcTMcT6b929NZ0h7Q6xT+uibJjsIf4c2Wg3CjWxD1
         MdMVbqKRo1eAIM4DyGhOw6s9HpMJSWWsUypkrZll3man9UuP1jNbpByF52j1kF0AGGiX
         QBXQ==
X-Gm-Message-State: AOJu0YwTg7LtrkYxiaO2USEreo9l5PqlUrvMQq/hgpW7WY/H1yOwZNNh
	dBFgSiOspnDyceSvBP8QAwiIfeDBzUDj6Wq44qGO9HYnJ8daeRSWbZ6hmzh7ibc=
X-Google-Smtp-Source: AGHT+IFbXYLb1pwVb5boGIyIFlEmbfFH7kw9/sSXOjiAyM4KMmo6rql7Z7UUvh6iMN7Vnjp0A+nx4Q==
X-Received: by 2002:a05:6512:12cc:b0:52e:9b92:49ad with SMTP id 2adb3069b0e04-52ee5208ce6mr4261227e87.0.1721334908573;
        Thu, 18 Jul 2024 13:35:08 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc5b7f28sm596563366b.70.2024.07.18.13.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 13:35:08 -0700 (PDT)
Message-ID: <235ca7fa8c0054245d14e2ff5a5ba1d1055a8797.camel@suse.com>
Subject: Re: [PATCH v2 00/20] path checker refactor and misc fixes
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 18 Jul 2024 22:35:06 +0200
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-17 at 14:10 -0400, Benjamin Marzinski wrote:
> This patchset is based on discussions I had with Martin Wilck about
> my
> last, partially applied patchset. It's based on top of his mwilck-tip
> branch, 4ef98926 "fixup! Makefile: add targets for test-progs.cpio
> and
> test-progs.tar". These patches are mostly orthogonal to the
> libmp_mapinfo() work. I'll rebase them if further changes to that
> patchset stop them form applying cleanly.
>=20
> The first two patches are reposts of patches from my earlier
> patchset,
> redone to work with the new libmp_mapinfo() API. They make it
> possible
> to add maps by WWID with "multipathd add map".
>=20
> The rest of the patches are work and bugfixes related to refactoring
> checkerloop so that
>=20
> 1. multipath devices get resynced with the kernel occasionally, even
> if
> they have not paths
>=20
> 2. If multiple paths from a multipath device are checked in the same
> loop, the multipath device will only get resynced once.
>=20
> 3. All the paths of a multipath device will converge to being checked
> at
> the same time (at least as much as their differing checkint values
> will
> allow).
>=20
> 4. The times for checking the paths of each multipath device will
> spread
> out as much as possible so multipathd doesn't do all of it's checking
> in
> a burst.
>=20
> 5. path checking is done my multipath device (for initialized paths,
> the uninitialized paths are handled after all the adopted paths are
> handled).
>=20
> Items 1 & 2 are handled by patch 10 and preceding patches.
>=20
> Items 3 & 4 and handled by patch 17 and preceding patches.
>=20
> Item 5 is handled by patch 18 and 19.
>=20
> Changes in v2 (old patch number in quotes):
> 01: change from returning minor number to dm info (Martin)
> 02: adapt to change in patch 01
> 05 (05-07): squash into one commit (Martin)
> 08 (10): fix commit message (Matin)
> 10 (12): rename do_check_mpp amd check_mpp
> 11 (13): move the code that saved the path name to right before it
> was
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 removed (Martin)
> 14 (16): use symbolic return codes (Martin)
> 15 (17): set path state to PATH_UNCHECKED when orphaned, and skip
> paths
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 in INIT_REMOVED in sync_=
map_state() (Martin)
> 17 (19): clear pp->pending_ticks in check_path() if the path is
> delayed
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 instead of pending. Use =
a different equation to check if we
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 need to modify the ticks=
, that can adjust the ticks on every
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 check. adapt to change i=
n patch 14
> 18 (20): adapt to change in patch 14
> 19 (21): adapt to change in patch 10 and 14
> 20 (22): Add fixes trailer
>=20
> Benjamin Marzinski (20):
> =C2=A0 libmultipath: rename dm_map_present_by_wwid() and add outputs
> =C2=A0 multipathd: make cli_add_map() handle adding maps by WWID correctl=
y
> =C2=A0 multipathd: remove checker restart optimization
> =C2=A0 multipathd: refactor path state getting code into a helper
> =C2=A0 multipathd: handle uninitialized paths in new function
> =C2=A0 multipathd: check paths immediately after failing udev
> initialization
> =C2=A0 multipathd: set pp->tick =3D max_checkint in
> handle_uninitialized_path
> =C2=A0 multipathd: return 0 from check_path() if that path wasn't checked
> =C2=A0 multipathd: reorder path state checks
> =C2=A0 multipathd: adjust when mpp is synced with the kernel
> =C2=A0 multipathd: resync map after setup_map in ev_remove_path
> =C2=A0 multipathd: resync map after setup_map in resize_map
> =C2=A0 multipathd: always resync map in reload_and_sync_map
> =C2=A0 multipathd: correctly handle paths removed for a wwid change
> =C2=A0 multipathd: handle changed wwid when adding partial path
> =C2=A0 multipathd: don't read conf->checkint twice in check_path
> =C2=A0 multipathd: make multipath devices manage their path check times
> =C2=A0 multipathd: factor out actual path checking loop from checkerloop
> =C2=A0 multipathd: check paths in order by mpp
> =C2=A0 multipathd: clean up the correct wwid in check_path_wwid_change
>=20
> =C2=A0libmultipath/config.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 12 +
> =C2=A0libmultipath/config.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/configure.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 5 +-
> =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0libmultipath/libmultipath.version |=C2=A0=C2=A0 5 +
> =C2=A0libmultipath/structs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
> =C2=A0libmultipath/structs_vec.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 9 +-
> =C2=A0libmultipath/valid.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0multipathd/cli_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 66 ++--
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 582 +++++++++++++++++++-=
--------
> --
> =C2=A0multipathd/main.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0tests/valid.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 =
13 +-
> =C2=A014 files changed, 432 insertions(+), 273 deletions(-)
>=20

For the series, except 17/20:=20
Reviewed-by: Martin Wilck <mwilck@suse.com>


