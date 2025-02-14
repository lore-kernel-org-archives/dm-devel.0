Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D81A1FBEB0
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 22:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739571026; cv=none; b=pjbyJrKm6X6bskMbVvr2ww/aCMNraqWeYsK4DgP4T6KaEX+4u4PdC0V6IobRLamIU+Q47/bCjIsXjMeuV/ZNSlcjaZu7Wt8tqZgw04g+VdUqZ5eXC+/UPZl0ijDLq0mFioNjJhtuAaBPTwvNbqYlLdGGg5iP9lAeF7eaC3+nZog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739571026; c=relaxed/simple;
	bh=9HesVorK9f5AC9YoOYDOenw9ykHgKsqPqjAnX4HSmzs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fjoq7YK4WSJoAeBbBj6oTiSa4PvknAI6rSP2e4ArH+zL/FDcmjRglSEbROC3Kjlfe4TsNEh3Hr+nkMAxY0GWYnWpYspuHjwKJWTYx856YmiGGrslfo+7RHqKhyM4RIxKUeLUBfld/fQp+kxC16EI7p1E+nVLWZ5tYVgld46NYmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OgMtxSma; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OgMtxSma"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e033c2f106so705828a12.3
        for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 14:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739571022; x=1740175822; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ewvLyVTicvnN6hL/a+0tKgC/j3wLIDuYc3SdY+rOG5w=;
        b=OgMtxSmaxdXETjyova4JxPbiVEM0tPAnSC6KTaNdcRucj0GRIibH1SvXFl9U/zNJH2
         pYOeUP4IQ1uNDS0yDJnZSoZ5Di2cWeRhrM/7kPw8uwEmheIJ1Hez8rDm+5fCUCFpjmjk
         uuQi+82qAHyZDpJcZl6DZdsjkMX4A4MQUeoS5sB2l3EKUzxtzrE87un6XozNxDGN6XMp
         ifE4unwdgAFal24kFmlMJaFSXMzmTDwyE5Mz3L+lr30xB8rIJPVb3SRJ6RRlvBxgs+yl
         Mcbzp08oORwbwjKMcimiBK47DEpwt58r7Y72O+0Dz+kRy1GY7SVebVqD3aowYcWKJH1R
         DmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739571022; x=1740175822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ewvLyVTicvnN6hL/a+0tKgC/j3wLIDuYc3SdY+rOG5w=;
        b=FUXC3efRFA/FKSfonsWwcTahrxAbgWUlxtmyIJRDSmhIq/eSE03eDy9t1p3qqutq9N
         3dsDQOZuKCdpAyUXd54CaU9U/d7zcoO43DlUtNC2lxfiqaFMtdx4rZz8W/p0PeobviMz
         VCLAm6kgOQvFTag26RmnLNOWkGpaD8qZBb0KQqFwCskTypJBfv7VPUPWfn+KWLdcw1KZ
         P1AcDd7ys5wfCXL/s6JgwG6HIGCyjZMs49y6aVAAQBurU2oS9tQtOb7XfqwVKcrKmaju
         bj9lJbdopXzKp96Ddk0o+MFlhd+Xki9gnRxdMI5r538BxZIfbFhHmPS72sp7UHJgb401
         eWcQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9o0RfF4wMIFV7cM6IgkiD16wAXIDTMP1aSWIoSLAIgcze8EWGsPSpLHIxF6jqr6bSHnDEeyCpPw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxs+ARCx7jJnqpsOKdToohft4mO7mABvQfXIzTIng9M4DYNdFaW
	OfeSkeYNfAx/C8l/YtAfH1sd74Hw86UhqdPLb7BsoshLTzltfUYdFLttEohBRWk=
X-Gm-Gg: ASbGncvnt38HQS8er64nMwjlc0Gz2Xgx+rV4kpM5Xmv5riB/aJqEw3jn/Fw5jAA9x6r
	kqsSS/86sHe9/bigWbsm3WarTT1Q/ybrVWA/XGPrHGqFxhA8qd0c2ilaJ5KzfVN8JoqtkvgORmz
	FSkSqqwZXesRufJ6A3vC3hdeKIshyxmLC/Ry4SmQLFXwiZn+e7fqHh1aFF8JsNZ/gYO8LFqrHEd
	rGbT2mIgHGdeWC47xgg6M534VhpxeJtAUerhFPmlGzx+MK6n2XMdASU2j8lf4MCCXui///MK0Tm
	o7Q4Roc5ZJUGKaXFkvnD+W1pHiYK5wLQdzR/pfYeJOC2omhiAF5v2USR5bkx1qrXKWHK335MeCD
	5gg==
X-Google-Smtp-Source: AGHT+IFW5G+71vO23sZr8rVNpDTglgMUq3GzJjiOArj73lntLeFQ9c1++bpGM/pd2onJ56iOt2HWbg==
X-Received: by 2002:a05:6402:4609:b0:5dc:5a51:cbfa with SMTP id 4fb4d7f45d1cf-5e035ff96f1mr2566154a12.6.1739571022039;
        Fri, 14 Feb 2025 14:10:22 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aba533bf360sm416645166b.174.2025.02.14.14.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:10:21 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v3 00/10]  multipath-tools: provide pathname and abstract sockets
Date: Fri, 14 Feb 2025 23:10:01 +0100
Message-ID: <20250214221011.136762-1-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This set is an attempt to fix https://github.com/opensvc/multipath-tools/issues/111

Changes v2 -> v3:

Many, as a result of further discussions on GitHub. multipathd will now open
both the abstract socket and the pathname socket /run/multipathd.socket by
default, and client programs will try both sockets before giving up.  The
"use_regular_socket=1" build parameter is not necessary any more.

Note that we'd switched from the regular socket "/var/run/multipath.sock" to
an abstract socket in bb89077 ("multipathd: switch to abstract sockets for CLI
commands") in multipath-tools 0.5.0. The rationale back then was that creating
a pathname socket might fail if the directory structure isn't set up yet. As
we now create both, and fail only if neither could be created, and as there is
the early /run directory on modern systems, this argument shouldn't apply to
this patch set. The name of the socket has been changed in order to indicate
that the new approach is different from the old one.

Changes v1 -> v2:

- Introduced the mpath_fill_sockaddr() helper to cleanup struct sockaddr_un handling,
in response to comments from Ben Marzinski on GitHub.
- Fixed double remove of multipathd.socket during "make clean" (Ben).

Martin Wilck (10):
  multipath-tools: move DEFAULT_SOCKET definition into Makefile.inc
  multipath-tools: add helper mpath_fill_sockaddr__()
  libmpathutil: add support for Unix pathname sockets
  libmpathutil: move systemd_listen_fds() support into multipathd
  multipathd: make uxsock_listen() take a pointer to fd
  multipathd: allow receiving two socket fds from systemd
  multipathd: listen on pathname and abstract socket by default
  libmpathcmd: try both abstract and pathname sockets
  libmpathcmd: honor MULTIPATH_SOCKET_NAME environment variable
  multipathd: honor MULTIPATH_SOCKET_NAME environment variable

 .gitignore                                    |  1 +
 Makefile.inc                                  | 10 +++-
 create-config.mk                              |  1 +
 libmpathcmd/mpath_cmd.c                       | 25 ++++++----
 libmpathcmd/mpath_cmd.h                       |  1 -
 libmpathcmd/mpath_fill_sockaddr.c             | 32 +++++++++++++
 libmpathutil/uxsock.c                         | 41 +++++++---------
 libmultipath/defaults.h                       |  1 -
 multipathd/Makefile                           |  4 +-
 multipathd/main.c                             | 48 +++++++++++++++++--
 ...multipathd.socket => multipathd.socket.in} |  3 +-
 multipathd/uxlsnr.c                           | 34 +++++++++----
 multipathd/uxlsnr.h                           |  3 +-
 13 files changed, 149 insertions(+), 55 deletions(-)
 create mode 100644 libmpathcmd/mpath_fill_sockaddr.c
 rename multipathd/{multipathd.socket => multipathd.socket.in} (84%)

-- 
2.48.1

