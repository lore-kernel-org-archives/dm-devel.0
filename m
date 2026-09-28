Received: from mail-dl2-f39.google.com (mail-dl2-f39.google.com [74.125.229.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F264D4D90AF
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 16:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790614519; cv=none; b=l3giMyHRGCsRCR4zGKBlzpAyNg7AP1ezUMQhnaFpKl5+8CX5mqrNWtagpKqbMEms1j08on5nkBomagfyKEt026/tVcPbzmra7tgKXQxU7kiPNT4bDXfpSVuFTdDrNLDko5MoE0Y9jm01mtG+QHL/tX4jz9uCxm78t494RjcxDtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790614519; c=relaxed/simple;
	bh=iLHsrKgD4Ui9Ww7G8RWUVxqM9X/4h425LUDJG4tnuEo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jVMhNgOUYbRLFnZnD7Mn6ly+L5Do1djLk20SA8SCloiD9gUWfEia/EVl1RNOs2wAOPlFqk82e+bfUdpuTHJ0pDfA8D3mlWfV18UzhYrGdd2Lu1ZbUeeQr0Ynx0Gkrp6iJjKnOW4BICSagRBVF7gfTWfBEBT3qkIe/Ss4givAOdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=gzvDoSxg; arc=none smtp.client-ip=74.125.229.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="gzvDoSxg"
Received: by mail-dl2-f39.google.com with SMTP id a92af1059eb24-1438cb9b3a3so2007014c88.2
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 09:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1790614517; x=1791219317; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gy2zS9s/y3l9Qy9s6dEnIMeYLVXogQjVzvnS6e25Nmw=;
        b=gzvDoSxg4mYgmU3FMg7co85bkLqF+mmDJXx9ZAGJv0dFnznQ3XSFegnSrNJAfHnDlV
         7iKKlA/efZF2NwLteZwTpkVNME9qEs69p7lUBfL9OzUsAiQcSERtcVLQWSC4IpZdcdtJ
         3puIxCCKYW6mrqOvCjAr4xQSsH/9ypyvIWt5ur5h/HJtYa2vsuiQmWoFicXsWIWbhEXT
         9zFUh9Bw4maN/ZLDTqHw5vLuVMAS4PtW3Q4ecbmuaQP6mW7c1Gv/kC4L4fbkObxEnIcI
         I9RTn89jqP1OqbVwROBLnkVFBGlwQFIzjsiiBMrosYw2+jFegfsvXfUZRneZP7Euf+z1
         EGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790614517; x=1791219317;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gy2zS9s/y3l9Qy9s6dEnIMeYLVXogQjVzvnS6e25Nmw=;
        b=ZGGPNH/IZq7IF78FrYh6TrvJn/yP5erR0H/QY/tjcEMHSsp+Sc9evoN3L3YwUEmIKP
         FwffzuFl9/pRN66g4R2j0Zwkku6nqTZ5ntdb1L7ACP5tBTjJ73sIM5jVAa9HJ4jTiEjJ
         Q0oIMmEwLH1PI0gtYe32bYOKTgL2bh9sOS8uAVshi0R5BFuOoLbUtcclBdXwLtr+45t0
         TOZ0ud1bikc05aixjHcmj28PDfPPhDcboO+e16Lr/vUL8TctQVuUZaEE8iHOVXI0BBzn
         HnEnkvyLGoGepGrYXdOxj2n2cBIAPeDOajM6Kg4rHqM3deyNcGNlr9WFLE0B6h2Gbahk
         kgGQ==
X-Gm-Message-State: AFuF++mIRgfGNkEetzLrPuo6yNGErRLV5/l08zYa28jG58wrzQDvgWPc
	3JbevoAuVqdBEdTPY1fH9fnNkXdEmZnqDPatQYkpAmG88N6Z8F4Wow14n2mTz6+AbxRKxEtMiB9
	2VwyA/Zk3XqZ0+sgMgpi1cv7nYvvlCwQuiDHKj/l+NWOkYzkfJ2XgHw85stN7jJmpOfq0baI54a
	ZP1EwhIVhutBOAyyFMZPG+vnZjshmtna4qCvyhGyjKY8N+LTE=
X-Gm-Gg: AYBFou3p+Sj5nPvmh5oD6G/6W6AW4ApbrZ+Ee8MEXmW96GIIJjQyWEypDalIP/8uCy2
	iT2t9G6Is1nZqRXPJx/+DWpopeZq6viCt+OyyddsNZ/g4kqqvDZmnH9BWQdTcV8/aEF0D1nLY4P
	SlPiPqzJFbE6sf/jDtmyPlBIgC+uzxXs66JHMAH5HJJhyJCWndujN2/+NMhrHdNSKmKlFsP4fIu
	M9vkGD0e+DSrDI9uRpWdPx+hAHmvOsjFfO4G4kQZsoeuGJimNXRV1WHASUo+YgitKENoF2QxW2e
	qWX6+VjWtGFR1K3VIQxyJ59bqJiPN4y9inNRcvY42D85//CEYXab1B28Q3e7pNWr2Aa3hI68yJ5
	JcetHZ/rmPPfgP1C61wHSiqrduQU3SpedjmPf2tixP0FMvqncnaespkvO2FcuwQGCm9sQ95rer8
	YyfDgW5oSN0t4n1iWKHC6P6l1jf6HtB/8hfdXtKB7QkKhlNRJ30fr+pwojrDO0yqkyRmRlpMk4X
	3Ubhm5Lh3/M4iEjhq2gkmWiTxPyqAfvMg2cfOT+4SAiuAHBnvOTXK+mqrcMyFd53i0YVH/s8tzE
	h9kYgf0XCvOF7tQcpNmNaUxWG1OQk5snkmX1bJWXTbFY3/0ddtTHVd9eQc+1PMePmzp77Q==
X-Received: by 2002:a05:701b:271b:b0:148:4522:5601 with SMTP id a92af1059eb24-1484522576bmr6523762c88.18.1790614516584;
        Mon, 28 Sep 2026 09:55:16 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145ac67c505sm25537557c88.5.2026.09.28.09.55.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 09:55:13 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Brian Bunker <brian@purestorage.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/1] multipath: fix "multipath -f <path>" regression since 0.9.8
Date: Mon, 28 Sep 2026 09:54:42 -0700
Message-ID: <cover.1790610404.git.brian@purestorage.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 0.9.8, "multipath -f" fails with "device not found" when it is
given a path to a map, such as /dev/mapper/<alias> or
/dev/disk/by-id/dm-uuid-mpath-<WWID>, while multipathd is running.
This patch fixes it in the multipath command. Some background that
doesn't belong in the commit message:

How it was found
----------------
OpenStack os-brick's Fibre Channel connector detaches a volume with
"multipath -f /dev/disk/by-id/dm-uuid-mpath-<WWID>". Every FC detach
fails on distributions with multipath-tools 0.9.8 or later, including
RHEL/Rocky 10 (0.9.9), Debian 13 and Ubuntu 26.04 (0.14.3), the tested
platform for the next OpenStack release. It is tracked as
https://bugs.launchpad.net/os-brick/+bug/2167932. os-brick is adding
a workaround, but fixing "multipath -f" also covers existing os-brick
releases and other tools that remove maps by path.

Why in the client
-----------------
Commit a4dbdcec made cli_del_map() look up maps with find_mp_by_str(),
like the other client handlers, so I didn't want to bring device-mapper
lookups back into multipathd. get_dev_type() has already stat()ed the
argument, so the client can resolve it to the map name before it
delegates. This leaves "multipathd del map <path>" unsupported. If
you'd rather have multipathd accept paths, I can rework the patch that
way.

Testing
-------
Rocky Linux 10.2, device-mapper-multipath 0.9.9-18.el10 with this
patch on top (it applies cleanly after the RHEL patches), a PURE
FlashArray LUN over iSCSI, multipathd running:

- "multipath -f /dev/disk/by-id/dm-uuid-mpath-<WWID>" and
  "multipath -f /dev/mapper/<WWID>" fail with "device not found"
  without the patch and remove the map with it.
- "multipath -f <WWID>" works as before; the argument isn't changed.

multipathd's log, before and after, for the by-id path:

  disk/by-id/dm-uuid-mpath-44BE9D5DF0A14AFE000113E9: remove map (operator)
  disk/by-id/dm-uuid-mpath-44BE9D5DF0A14AFE000113E9: invalid map name.
  44BE9D5DF0A14AFE000113E9: remove map (operator)

On master, the patch builds without warnings and "make test" passes.

The regression is in every release since 0.9.8, so this may be worth
picking up for the stable branches.

Brian Bunker (1):
  multipath: resolve map paths before delegating -f to multipathd

 multipath/main.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

-- 
2.55.0

