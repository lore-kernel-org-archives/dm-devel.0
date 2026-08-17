Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43693EAC8F
	for <dm-devel@lists.linux.dev>; Mon, 17 Aug 2026 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786961173; cv=none; b=lCYPPmIl5S2iNkIOJPAnObnBFjhCW1TdcuxSevr5tjzi5f+4gtaYIUQ6pcAswbsDt04c2JWuXjb2mj4gk4esxpResK6w2GSKAqhPulBu+OgE2xUnZzznnTZmZ22TjR2GagNmGmyWsOaVSjSw73nw35/9mxZt0BHkb5brGz7LEPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786961173; c=relaxed/simple;
	bh=ELLe/0w3OLP4SKwY7wHYoVEJL4L1FFXkvtejiTQub38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lgy+hLGacN+ehO5f6n+nS75VepRx6U17N/GEqoSyPDO5K0e79zKaU2ejFMdQj28/WHyw49Pt1680664ebldCpbuGfSLo+uXrUEEgdkX4AlsYiC9Etg0rErtbAve4FgCMKdOeY9zMr46mNzgANWycLxdkPElhg4bJpCji7jPcrEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pn7Yd4Pr; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pn7Yd4Pr"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-384c94c9423so342376a91.2
        for <dm-devel@lists.linux.dev>; Mon, 17 Aug 2026 03:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786961169; x=1787565969; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NaEjaX8owKCcCbLs6LhjlQIuaQb3VhH8swaN6sdmbj8=;
        b=Pn7Yd4PrLjKIaPAIEc2cEEa7aocBtZnauxC995FOeNZ4f/Axj3fxsQWJRBZom+uZ3S
         cvgcmFuuslfZvsnNFm+Fbzruzhp3hz/p+zZqPVJ4l1FWGPPX7dMh83b8ZgTxENLIoKV2
         PBa5+3fT3FvCArCMG8Bq4BEPrRnyUiGeBxxGeu/k+MU2m0XSjEq1rj/vDBKtnT0Dobu9
         OYiIWE9IAa9Yd7HiEuYQOEShNAxXeJHD5HN4JpTyyiIywLpvm5tKTg+ANwpS0KnCSao8
         StGILbdxxkKEaBRSjFZwZImjaHn8nq8J+KIdM/WO2KhjIqJrNqeSof6qPVjSIb5YPmSt
         CG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786961169; x=1787565969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NaEjaX8owKCcCbLs6LhjlQIuaQb3VhH8swaN6sdmbj8=;
        b=RryDWtIGqCabLXti4/0O8AIDS1waN5HI7ToAddwGVak2WUr2FI2h2DE/FUf4t3gjsJ
         is+LvfaOOoxKOdCOOE1lKjSF42jDki3gIoCPZq4pQDZmrddSnK8NSGiJRoQy75CK76PX
         fn3ncHTydUJIWe10YGW0DoD+EP9TP7ZuW3UPaPISepQ/pWeug6W7J91Kw0MTWvvkNqww
         UqqBulODgRNlXVT8Iuazi8ltOUR0gkWrpSXKAg+iuskN4m4o8ovWT/yuA3u1PRdAj7C+
         lTh5/JZyTnKw57onyJU0nuQB5SBtvOoCXWM3fQ++vcnVvwhes8Bd9jRr9mrz744cQ99y
         cThw==
X-Gm-Message-State: AOJu0YyO8M9bQJSyPSB9y7iv7RMdCaFedoXFK/sPVpn6/8XcRexkTwot
	Z/v9DjK2wreaUFpOXUU493tBqRCEbQIQqlB7lCL1u/QRC88pJrIrqwWj
X-Gm-Gg: AR+sD10oXGzKwHH9gSDfxYiacwG8eKE0tIh7wM6zC2gpCsXMHidB8wp57AeahVS1WBV
	bVVpYa4NJjdELMAnXKBGdI16mglF9m7rNkbYckifO3639J03ykNCsIt7FTRJkeU0KU9WyaJwNzD
	g/ztIXpDb0eUx6aFyAjisauQg2e4IxrO0p/WaZ28P8wmp1Pnb6W2jQEXF2x/++2/2pHpZZ/k9Nb
	NuNNqzQ6zqd7PfjGATkvR9Te5oY40AJIyxAIeyv52XSmg4lYnpfRuOEvSkJatYWKWmGd8qkLnsr
	30SvZowmevps/HFFCYoMRw9h0FjPJeT0IPF6VP4WbyhwkEXDMqOtpVEPfoX3xz7QAdigzf7BPbf
	L0zra+h8Db0Hb6nsE9THnUhcP0t3bC6fiMaw9Rk3xm2tvTvVMAFHpEHj0UFjdxB01tVofPR9W+T
	MOU6RgBr5sxhX7JbJ6OS1X6wcSjxSMJTaeRoz8t/n/VZCuqvbaATa39LvRVku3/5npeNUG27Uli
	A==
X-Received: by 2002:a17:90b:5444:b0:381:bcfb:e710 with SMTP id 98e67ed59e1d1-3933b8e2befmr17511617a91.3.1786961168939;
        Mon, 17 Aug 2026 03:06:08 -0700 (PDT)
Received: from localhost.localdomain ([175.159.181.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954d3b3b91sm1767284a91.13.2026.08.17.03.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 03:06:08 -0700 (PDT)
From: Yu Junzhe <junzheyu1@gmail.com>
To: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [BUG] dm-integrity: mode R resume NULL deref when DIRTY_BITMAP is set
Date: Mon, 17 Aug 2026 10:06:04 +0000
Message-ID: <20260817100605.292-1-junzheyu1@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Hello,

I am reporting a null-pointer dereference in dm-integrity resume: recovery
mode R skips journal allocation, but dm_integrity_resume() still issues
journal I/O when the on-disk superblock has SB_FLAG_DIRTY_BITMAP.

Summary
=======

create_journal() runs only when mode != 'R', so ic->journal stays NULL.
Resume treats DIRTY_BITMAP as "journal pages hold a bitmap" and calls
rw_journal_sectors() before any journal/mode check:

  if (ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP)) {
      rw_journal_sectors(ic, REQ_OP_READ, ...);  /* uses ic->journal[] */

rw_journal_sectors() then passes that NULL page list into dm_io():

  io_req.mem.type = DM_IO_PAGE_LIST;
  io_req.mem.ptr.pl = &ic->journal[pl_index];  /* NULL in mode R */

list_get_page() does *p = pl->page with pl == NULL (KASAN range [0x8-0xf]).

DIRTY_BITMAP is set while bitmap mode (B) is active and is cleared on a
clean postsuspend. It remains on disk after an unclean stop of mode B
(crash / power loss). Reloading that device in recovery mode R is a
documented recovery path and hits this bug.

Affected
========

- Confirmed on Linux 6.6.144 (da47cbc254661aa66d61ef061485a7080305c4be),
  KASAN guest
- Still present on torvalds/linux master as of 2026-08-17: resume still
  calls rw_journal_sectors() under DIRTY_BITMAP with no journal / mode-R
  guard
- Files: drivers/md/dm-integrity.c
- Config: CONFIG_DM=y, CONFIG_DM_INTEGRITY=y (KASAN for the report)

Crash excerpt (from minimized PoC)
==================================

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 234 Comm: repro Not tainted 6.6.144 #15
RIP: 0010:list_get_page+0x7e/0x150
Call Trace:
 <TASK>
  dispatch_io
  sync_io
  dm_io
  rw_journal_sectors
  dm_integrity_resume
  dm_table_resume_targets
  __dm_resume
  dm_resume
  dev_suspend
  ctl_ioctl
  dm_ctl_ioctl
  __x64_sys_ioctl
 </TASK>
Kernel panic - not syncing: Fatal exception

Full oops and a self-contained Docker/QEMU reproducer (poc.c + KASAN
guest) are available on request.

I am happy to test patches or send the reproducer package.

Thanks,
Yu Junzhe
FuzzAnything <fuzzanything@gmail.com>
