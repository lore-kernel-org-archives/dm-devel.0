Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ACB15C14B
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 21:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730668077; cv=none; b=FZcR6QBcTT4/mf5rZ300TDAXBM4IOTuEzULTGIKIUwGI+ew6lRoG/78cxC7XOmnbYujmzEGL2PNrM859XJItxBlAZ9H0J6xQlIHy7z2FzhtJ8L2lm1/zQOEoZA07x3Uw5ls5F8Pt+qlToUk9xwLoK0b1Qc1r6+6+aw7mUk8ZPXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730668077; c=relaxed/simple;
	bh=OzKejAHVEYDrE08TQ891ojxdG8w/EKcNfTfAwUSIiWo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RkxQdHJF6DKTNFzcauT4+k1vHkYMjUiLztDPMT75Lj+v2UwnbCn4kEM1AE/CGA8VqjW1MAV8+s2Dbb1k/ih+dyWSgGV4x4Q1IvueYEuhQoNMtllE36uWsCKLNkvu9HmtejAnfX1pC09gZSba/rOGtZuH6CGChWFQNjsL8DNJ5QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KB+1Nw2D; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KB+1Nw2D"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9a3dc089d8so605642466b.3
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 13:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730668073; x=1731272873; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OzKejAHVEYDrE08TQ891ojxdG8w/EKcNfTfAwUSIiWo=;
        b=KB+1Nw2DicSmlAcTJ5VQr4Y3QUHlgWbU/A0sL3vp5+cgwFVISMEdjtIp3C70JGrKcI
         RxC/2knBdURQitkazwSJ8xR6PMr14XODzFdXPjUr/hseATRqxWmCgUJiYT6VoI2NkCk3
         FDgEKm9ozXo6zRYhSnOPnugnrb0wke/FUA8Yh8yO/z9xuTQ2F0SbGshvfK3fZl2xKcV8
         2T20eItPq4LPFKA5XMcqWS3ULIRRhjkxPLNQPhycu5y6i1g4OHc4uPD8s9mA7Bcq3hDR
         gU/bWT9VHHUevyzD9C/VJDkCWjbqtzbg1lfQxPRplhYT4KvkLr3G7ODW3dIb4NodjBjW
         a1GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730668073; x=1731272873;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OzKejAHVEYDrE08TQ891ojxdG8w/EKcNfTfAwUSIiWo=;
        b=HP5V4ObK+Q/4sCm/6P4MRJ4hEIVWM0jq25BYs+xFrOli/pUyXgJqQc28+BfzbwLDex
         ob65usbYEhiJDXx298ERtdJsMMpUQAg4CA4KosbopLDs9eJnItXtlEytwOiJvYkXstg+
         1V7QG2xEiJuX/PCP5vYXVYnVk7sHfmk/NCDpo9cX62Nc20H80fqQ5NM2dreK7WRsgQ3K
         Fbpe/0s8DUQW8j2muhR2u2/57LyMm7dCPU9hSl+3htwJJQtU3ZVYaNdMWo3y67IKY+B9
         1J2yl5tjJXDxR+ycpP0/OFpvsBY1E6bDCuPyxO4v6VNLfhLcbcjKf6x/lMKIEp02LDm+
         8iYQ==
X-Gm-Message-State: AOJu0YyozNSwM5FkMzZgQodbxlIsWPIDt1Oi8VyCAKFOgTj+gwGawoG+
	kOLROmWqgeVoLnQZgHch6GRa3gKScpD2D62zNFjNYhqM8Os4Xs4Bbd+ue3geggDue9qdBJirqdj
	K
X-Google-Smtp-Source: AGHT+IGoNUdbQWA2NMJcYnjEfG2dJM2eZ3nlazkDPTsESj+kraktfmKi3u/3WwIFbBagdxDlvrQrPQ==
X-Received: by 2002:a17:906:c146:b0:a99:d6cf:a1df with SMTP id a640c23a62f3a-a9e655b958amr1123316766b.46.1730668073293;
        Sun, 03 Nov 2024 13:07:53 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e5664150asm472108466b.147.2024.11.03.13.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 13:07:52 -0800 (PST)
Message-ID: <5f9e6aba7c782c0688158e0c9990c4b98c8d48d2.camel@suse.com>
Subject: Re: [PATCH v5 00/23] path checker refactor and misc fixes
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 03 Nov 2024 22:07:51 +0100
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-10-14 at 23:28 -0400, Benjamin Marzinski wrote:
> This patchset is based on discussions I had with Martin Wilck about
> my
> last, partially applied patchset.
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
> Changes in v5 (all from Martin's suggestions):
> 19: Changed checker variable name from ct->waited_for to
> =C2=A0=C2=A0=C2=A0 ct->checked_state
> 23: New patch to change the directio checker to use timestamps to
> =C2=A0=C2=A0=C2=A0 check for timeout.
>=20
> Changes in v4 (all from Martin's suggestions):
> 09: Changed commit message and fixed incorrect comment
> 10: Moved getting checkint from config to the if clause where its
> used
> 11 & 12: Moved setting pp->checkint from 12 to 11
> 14: Added comment about when refresh_all is set.
>=20
> Changes in v3:
> 0: adapt to 27053732 'fixup "libmultipath: use libmp_pathinfo() in
> =C2=A0=C2=A0=C2=A0 update_multipath_table()"'. This is identical to 1d564=
df4
> =C2=A0=C2=A0=C2=A0 ("multipathd: adjust when mpp is synced with the kerne=
l") on
> =C2=A0=C2=A0=C2=A0 mwilck/tip.
> 11: fix commit message (Martin)
> 17: use symbolic return code (Martin)
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
> Benjamin Marzinski (23):
> =C2=A0 libmultipath: store checker_check() result in checker struct
> =C2=A0 libmultipath: add missing checker function prototypes
> =C2=A0 libmultipath: split out the code to wait for pending checkers
> =C2=A0 libmultipath: remove pending wait code from libcheck_check calls
> =C2=A0 multipath-tools tests: fix up directio tests
> =C2=A0 libmultipath: split get_state into two functions
> =C2=A0 libmultipath: change path_offline to path_sysfs_state
> =C2=A0 multipathd: split check_path_state into two functions
> =C2=A0 multipathd: rename do_check_path to update_path_state
> =C2=A0 multipathd: split check_path into two functions
> =C2=A0 multipathd: split handle_uninitialized_path into two functions
> =C2=A0 multipathd: split check_paths into two functions
> =C2=A0 multipathd: fix "fail path" and "reinstate path" commands
> =C2=A0 multipathd: update priority once after updating all paths
> =C2=A0 multipathd: simplify checking for followover_should_failback
> =C2=A0 multipathd: only refresh prios on PATH_UP and PATH_GHOST
> =C2=A0 multipathd: remove pointless check
> =C2=A0 multipathd: fix deferred_failback_tick for reload removes
> =C2=A0 libmultipath: add libcheck_need_wait checker function
> =C2=A0 libmultipath: don't wait in libcheck_pending
> =C2=A0 multipathd: wait for checkers to complete
> =C2=A0 multipath-tools tests: fix up directio tests
> =C2=A0 multipathd: use timestamps to tell when the directio checker timed
> out
>=20
> =C2=A0libmultipath/checkers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 47 +++-
> =C2=A0libmultipath/checkers.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 10 +-
> =C2=A0libmultipath/checkers/directio.c=C2=A0 | 177 +++++++++----
> =C2=A0libmultipath/checkers/tur.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 79 +++---
> =C2=A0libmultipath/discovery.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 97 ++++---
> =C2=A0libmultipath/discovery.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0 6 +-
> =C2=A0libmultipath/libmultipath.version |=C2=A0=C2=A0 4 +-
> =C2=A0libmultipath/print.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0libmultipath/propsel.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 21 +-
> =C2=A0multipathd/cli_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 409 ++++++++++++++++++--=
--------
> --
> =C2=A0tests/directio.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 182 +++++++++----
> =C2=A013 files changed, 676 insertions(+), 360 deletions(-)
>=20

Sorry again for the long delay. I've applied this series, except patch
23/23, to my "queue" branch.

Regards
Martin



