Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CDA2773FC
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 18:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983971; cv=none; b=EJv1wi1EGPk3YIUiEaitsXuZvn/FWakCbRoGjJggnYJLpoDu3X1jWSNXbFdRIQOHLk8UW1H7bzqwPgDIwG9LzG4o0eDNGKaTncykQL2IYKWCTLQz6B41KIvz3AcxAlV6qgnPn0ECMEGAdxWw4+bMsiuODhE9IAl91FbKvJ0pOq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983971; c=relaxed/simple;
	bh=eLf+D4kBoJ3wNivserU66T/6bBboi4AtIHdFAUgrly4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=istAcA8eKN/hYeYidFVXgN8HHBW1KvCASQyjhh6L809X82jPe3vk5ecqSSAoSzpAFII9opfaeZmKKUBBSHQbbVzC1N8M2XPrUOFTzi8466nbx4pCnnD+C2HaF684TCiav//ZiPAPlLF6QTz3/T2zAzWo+IH1EHcxPZPBVgLuBwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZbYOiR5K; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZbYOiR5K"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-432d2c96215so1622043f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 09 Jan 2026 10:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767983968; x=1768588768; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eE9HYQiVJ2hT7MpfEalRpryP3iaHrkXLkoyu2/vlIx4=;
        b=ZbYOiR5Kt7U0jtFqFmFBUnxyNqJs0g9A9qUQaRk5cI6SGV4wDSlFudLY7egr933Ywi
         fy60CsxOTw08p8bUp9aRPJsly6a8n2fLmGUQc/xP/R0KXFvSjYNq/16nhO/dG3tjU8uJ
         NSOFYgLcfKB1uBAgA04UoIlsk7sHuC01TcfIhXYGPNqU7Uy5yXqtKvhMWtlDDVkjudRw
         fGWTyroQxg0B4In513rUsp70ddyhea/IkhhRxUxC63pFfCSph7KQNtMqnpHw8hFLE/z6
         G6Y0kSDXofkwNlakNyHO2qcGGcbjxz7VIvtDYwg13vyepQD/HHmr8zkl0m+K29MVkxdy
         tuxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983968; x=1768588768;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eE9HYQiVJ2hT7MpfEalRpryP3iaHrkXLkoyu2/vlIx4=;
        b=XqkuLN2ZOPFxpzHVT20sx+wq5z3CKi06rSPX7px7EQqc8XES7EG5HRNqhLcvEWWGYL
         XfUCwAWHetyn7qYKTIzy7LeiWpcJ0sWG34vSaKid2oiZso5/Uak0ft76OA1H8hVe53az
         6cGuEKNgm71kAy9RaosezFUBsSzzTIikPRjbpMVdVMwdR3nX/XtsnTgqqeSBdfQXrC8s
         pe+PFvONTRe7KvBeu7eargrDB64+mQLpFMuDvgTHrjix4ATLjxszyl2GkAAFk7XFFqV8
         SzuftDzBrc/4SutZkKU3S4AlvEpDRkEcbWUAY2jFiSrr59PIM/BmgRatnLG5cHsGFIxW
         JM5A==
X-Forwarded-Encrypted: i=1; AJvYcCVPGwwEkDJd9hsGo8hQJK28FlRTNY9brmqfYVKJ33i46ct9nI2MSckxR8mVWhEtUIS4VqqCTVCqIQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLpxo9C83xhPfYiZ61Ap0315JlnSaATySB0xOXCB73CvE8JOsE
	OPkegBmOEagHJiuAkczHyAg8fk4I4uSWThJOmovYpUX6lXhpCkpAE1ej4s0OXw3XQPc=
X-Gm-Gg: AY/fxX6zf71PMOWJ51DNYaZzNfCXorziL4T4xqTVPsOMCGaoNtLYlngf6f5yasWyCSz
	zAi3GeE7oFbIcbdP2jA2Lf2tCK/WbOtNlMialgP1Ue1o0jmBZhLnrkGC/nS14Zjg+XbQnRUk0mE
	VZOfZSt88op/cRGIYK0CJ/ZaL2Oh16+KKqf3SxV5jCWVsCSLjlRm1/zfVfvbQgfI/H3wR+OEpiT
	yrfc8YG4zesSk2NFSa/hQO15M9f7TtdAYZQMODEWDCObeXx359WD9VhUEGLsR0TK/3enLxpYh/P
	+U/CvKckKjj0zvnwrb8o5jnK6zv3wDl403UzUQYLxSMoG1LGvo+fu5efHCgSP6woxicjMHDqPjT
	KSkWQ0aCT5x4l1Rh6lLgUO/GdLjhxuEF5zlkYH58Jijd2sKKHF1QkfkW5E6tChk0vp7c4BruWNt
	Ln1rmjch/hfkvK14FP7hlyHGLg8jfpnN7I894eKWASP+LkXtFxCbkRPSGlKwdw7NgYcjNJWU/Qm
	A==
X-Google-Smtp-Source: AGHT+IE2pbg3g+W6Kl6FnLrJS3ExLzdh3fC+Eb+qRmnSdG1yafdmBwwENcyg6JGHfeqrD6Mb8sgZLw==
X-Received: by 2002:a05:6000:401e:b0:42b:41d3:daf1 with SMTP id ffacd0b85a97d-432c37c881cmr12901885f8f.38.1767983968337;
        Fri, 09 Jan 2026 10:39:28 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432bd5df9afsm25716888f8f.24.2026.01.09.10.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 10:39:27 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 0/9] multipath-tools: more small fixes
Date: Fri,  9 Jan 2026 19:38:58 +0100
Message-ID: <20260109183907.201250-1-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1 and 2 are minor cleanups. 

Patch 3-5 are follow-ups of the structure-freeing cleanup of my
previous patch series "Multipath-tools: various bug fixes".
The previous series tried to make sure that no freed "struct multipath"
objects are ever referenced by any "struct path" objects. To achieve
that, it nullified pp->mpp links from all paths in a struct multipath
when the latter was discarded in free_multipath(). This is only safe
if we make sure that the path referenced by a struct multipath (either
via mpp->paths or mpp->pg[i]->paths for some i), aren't freed before
the struct multipath itself. Ideally, the orphaning in free_multipath()
wouldn't need to happen if we'd make sure that pp->mpp is set *if and
only if* pp was referenced by mpp as explained above. I think we do
a decent job at that, but it's hard to tell with 100% confidence.

In order to improve confidence, patch 4 and 5 add some logging. It's now an
error if a path which is freed still links to a multipath map. Patch 3/5
eliminates a few cases where this could still happen, even though the path was
not member of the map. Patch 5 is mainly meant to debug cases pp->mpp was
either NULL or pointing to a different map. This shouldn't happen and I
haven't observed it in my testing so far.

Patch 6 avoids a strange behavior that multipathd has had forever - after
grouping paths, mpp->paths was freed. In most of our code, we assume that
mpp->paths and mpp->pg should reference the same set of path devices, and
we have update_mpp_paths() and sync_paths() to take care of it. But right
after path grouping, this is not the case. Subsequent invocations of
update_mpp_path() (usually via refresh_multipath()) will re-allocate and
fill the paths vector. This causes a lot of unnecessary heap operations.

Patch 7 and 8 are unrelated bug fixes which I came across lately.

Patch 9 is motivated by the recent patch "libmpathutil: use union for bitfield".
I did some further experiments with strict aliasing and found that the
multipath-tools code base just should not use it at all. Like the kernel,
we use between low-level data structures that don't comply with strict
aliasing rules. So like the kernel, we should disable strict aliasing.
That basically obsoletes "libmpathutil: use union for bitfield", but having
it doesn't hurt, either.

Interestingly, switching to -fno-strict-aliasing seems to have fixed [1],
which I'd unsuccessfully tried to fix with various methods before.

[1] https://github.com/opensvc/multipath-tools/issues/130

Martin Wilck (9):
  libmultipath: reset pgindex in uninitialize_path()
  libmultipath: clarify code in set_path_removed()
  libmultipath: nullify pp->mpp before calling free_path()
  libmultipath: log error when freeing path that refers to a map
  libmultipath: sync_paths(): print message when fixing pp->mpp
  libmultipath: don't free mpp->paths in group_paths()
  libmultipath: warn only once in scsi_tmo_error_msg()
  libmultipath: find_hwe(): fix gcc errors at high optimization levels
  multipath-tools: compile with -fno-strict-aliasing

 Makefile.inc               |  2 +-
 libmultipath/config.c      | 13 ++++++++++---
 libmultipath/discovery.c   |  3 +++
 libmultipath/pgpolicies.c  |  2 --
 libmultipath/structs.c     |  4 ++++
 libmultipath/structs_vec.c | 26 +++++++++++++++++---------
 tests/pgpolicy.c           |  7 +++++--
 7 files changed, 40 insertions(+), 17 deletions(-)

-- 
2.52.0

