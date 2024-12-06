Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F82F1C548E
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528205; cv=none; b=tWXDmO1BzBcKr9MM4nrOWBcry0djYGfoUY0yRIzQ4xjwvqLM6/+z1VqFdmZ+ULfRXoCZoOjCh7fKf8gXK1SiYju5Bal837PYpquARAWZZFAMVThwd/I3xt6fzh5v4OqacdmUE9wViTNLPxdqka3LOWCkLcAR2m//AdytlZuJCTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528205; c=relaxed/simple;
	bh=QIzee7sVMinIN1v+8cLwWeN0tz+1JtnlC77e/AQCOxM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nNL1sxOnDl8/WGsfVAWs4ixGiHIVoip0/E+dNxoY14CbNJ8T9Gxgv0eC5HIq9WhiJ4Yre9PRtbhUNzSsUNtU1Uvd1mj6RS5GyCSMmNGWVQKuZvZTPs35vVBoBhhteXFKnCXuN4FcbRJJTN9XMn71qfDYcuASrKnTGCm0IjYHiJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FDkT0TZ6; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FDkT0TZ6"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d3d143376dso1108716a12.3
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528201; x=1734133001; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yW2pfcC35FsdsCgWqmDspIB8diiueQwqDj3a4cWQqgk=;
        b=FDkT0TZ6W8iPnV02azrKxEipbDgcCZVQujAkTUXdJSdpquITjscSeFsMcp0TYz/SKv
         OrGc8e3J6dl2nDoeCjfx/cgZlqIoFRodpZBi+bemWATQlzdd+KJnaa9ZQe7fWMkTItP8
         XZlTt2tJ4xGFAUs486agE4ONpd5q/YmUWY+oVNsUKOJQJrvs0Bc5V6EJsNSf8DMMmVLu
         aklMgd9OIdQ76UgzDN38WR2/sd2UBdsUGlUrEkNq38iiVM8ePD+dCW6kFAoe9bZ7hwAr
         0+QEFBQCtB/JQtibymmadq381sPTfJ5KMjutU+64iAc8uxk/02SHkqbOXBmdnLNUNEnj
         k06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528201; x=1734133001;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yW2pfcC35FsdsCgWqmDspIB8diiueQwqDj3a4cWQqgk=;
        b=gtx2nq1N3Yo10uCikjR2AGECYbWAHCS36G1ATJYyIb6G2XwaUa749rrC5qjmOy8aeJ
         Q7b3gAPwrNcJXxOwdIa2IXBL/vMLe3dBTl3rTPOX1gHzTig7qHDjPbyLB4iTnhTA6eQY
         c+dsVuOsCMuipWdP1c0mxPRvLWDB2mmcqZukarNLriZMNccbFnP6d3j8pLny3Au/BQj6
         6X5+kPsboKPasRUfAWuMbJhERnFZgwAKMZ+rsEFOttkq7zL6+UPsp7Nlq1LchSiFbDcp
         5liAIhMztxMmPAE9Z98XDYg9M/jQTzyuX4Z7lXMD54WJ/0QijH+xU0+oakANcnOEjDP9
         k9kg==
X-Gm-Message-State: AOJu0YzBwoc6SwUoE+rDe30jx2M70iEeC5nmPkrt+HNwN4Jd3klDErnO
	RIa/7SvxnvI1TjW11oG4vpsPdKyqg5c8+6ZZWInxZPp2S3g/2bOE3SxNxzG5N80=
X-Gm-Gg: ASbGncv3UyU2LJwEbr8Aufcj2Kx2L8gQmjQcFk58+z7QCF2JGy+4LGETlCbVkOjOm/E
	JvNJNXsAj9kld0p3n9CxYRmaQ+wHsc9s+DgU3dk0QfwNZH7rHFv1JvvubadZE4qY6Nk7CwmNeTb
	QcKj/qkcaRjhO173DU4YuxFj4LLLpwNt/GlJDsF4Nf0+oTfllRkQZ6Nej0/NOUIJhyABCEKPSlg
	q5XOHUt0bal3qMzNmo6CieEBMqzNFpIUVSWV8jUdpnbcVMRPBCDojMZYAyrhV6nazU1tVfaM6p3
	3+GxyuaM1TLaatRPsnWs60qkYy4JehTUOESR
X-Google-Smtp-Source: AGHT+IHSAecJ6apOg12HsaJXkhC5ncEHBvCpO3zb6bdNZG1GM5GkZo4k9kXkfDXKACdwROKru/kXFA==
X-Received: by 2002:a05:6402:4487:b0:5d0:8664:9f56 with SMTP id 4fb4d7f45d1cf-5d3be680c85mr4784660a12.11.1733528201092;
        Fri, 06 Dec 2024 15:36:41 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5d149a25f09sm2814785a12.1.2024.12.06.15.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:40 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 00/13] multipathd: More map reload handling, and checkerloop work
Date: Sat,  7 Dec 2024 00:36:04 +0100
Message-ID: <20241206233617.382200-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set goes on top of Ben's set [1] for github issue 105 [2].

The first patch implements the remark I had on patch 2 on Ben's set.

Patch 2-4 add map reload logic for the case when update_pathvec_from_dm()
detects an inconsistency: in this case, the map is now reloaded before
the checkers are actually started. If the inconsistency can't be cleared,
another attempt will be made when the checkers have finished.

Patch 5 ff. reshuffle the code in checkerloop(). There is now one function,
checker_finished(), that takes all actions that need to be done with the vecs
lock taken after the checkers have finished. checkerloop() enters this
function immediately when the checkers have finished, without dropping and
re-acquiring the vecs lock. The map reload logic is completely handled in this
function.

The various _tick() functions don't loop over mpvec any more; they are now
just called for a single mpp, and they simply return true if a map reload is
required.  The actual reload action differs: if missing_uev_wait_tick()
requests a reload, it needs to be a full update_map() (which calls
adopt_paths()), whereas in the other cases, reload_and_sync_map() is sufficient.
The last patch changes the reload action for the ghost delay tick.

Reviews & comments welcome.

Regards
Martin

[1] https://lore.kernel.org/dm-devel/20241205035638.1218953-1-bmarzins@redhat.com/
[2] https://github.com/opensvc/multipath-tools/issues/105

Martin Wilck (13):
  multipathd: don't reload map in update_mpp_prio()
  multipathd: remove dm_get_info() call from refresh_multipath()
  multipathd: allow map removal in do_sync_mpp()
  multipathd: reload maps in do_sync_mpp() if necessary
  multipathd: move yielding for waiters to start of checkerloop
  multipathd: add checker_finished()
  multipathd: move "tick" calls into checker_finished()
  multipathd: remove mpvec_garbage_collector()
  multipathd: don't call reload_and_sync_map() from
    deferred_failback_tick()
  multipathd: move retry_count_tick() into existing mpvec loop
  multipathd: don't call update_map() from missing_uev_wait_tick()
  multipathd: don't call udpate_map() from ghost_delay_tick()
  multipathd: only call reload_and_sync_map() when ghost delay expires

 multipathd/main.c | 295 +++++++++++++++++++---------------------------
 1 file changed, 120 insertions(+), 175 deletions(-)

-- 
2.47.0

