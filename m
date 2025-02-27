Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264441DF250
	for <dm-devel@lists.linux.dev>; Thu, 27 Feb 2025 17:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740678075; cv=none; b=h1xhaYGN/F1N9BaJhmt66PJWIuIEhdRxpHmTj8cf4eQwVZ/HP/inTw9zGN3HGw4eO1y55R19gfOqePm51HTvuNPb3zHQE4/JJHzCZ8QqF+5JC0NDmDqDLR8PKU9EN6xS9HjxdGQ7FmYvhPKTlyaOZsNaFRiTCwjuH/MgQo/CDQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740678075; c=relaxed/simple;
	bh=OamnMigjZiZHTp5WgGXsnhgvwVWGavFTGkxLt97NIIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DHy2FhPI3Gq6A6LjPgG1EkZzP2mh2+p0m1zdvwWsIOI3N4MHUcIzJ4OZWjdMwNrxXqXnheJOvXvCd6xEFp1RI+FD/e7LJ1Ho/YpRiFnk7P1DJzRAqGzamIqEJAI80PIQzaGw6OCvgPjkzxI1D9p2iy89j7q+byhoF9EGdlq6jsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cK+QaM3z; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cK+QaM3z"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aaedd529ba1so132889166b.1
        for <dm-devel@lists.linux.dev>; Thu, 27 Feb 2025 09:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740678071; x=1741282871; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sAbzlDAlvs4+8flTbVcWrMbblnVcjgIfTKeFqgvSglE=;
        b=cK+QaM3zPX/dsif36AzsMwVrFLXJpKeCiau1RyPgDdwF+433C3k6/YR1uAC1AsC60O
         2Q1xugBHZ15/nqIIoYEgmPVAeq+l8pV8LSIpIN5A7Dic2vgrFVBFtBuAD0+d62LAdHnf
         PQX5VnUry4WSHmsPAWetu9anFg6zi+yCF92PqUpQMVbFNVS4f4JBlU+rLD3NoQ/7u0ag
         WLEJr3fQaxm9TgdGZ41W8JvhPvuUsR9O3RrS18UAwJZUbdiAP0slKb/gZJRUWsBNTErw
         hSXkCJ22ngr2/3W4sjfamTUtVpd2l0YTbj6IIvhc3jcQacWB0UBNX+2nhn4/9ofu05yh
         Ti6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740678071; x=1741282871;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sAbzlDAlvs4+8flTbVcWrMbblnVcjgIfTKeFqgvSglE=;
        b=VZZN6NjKGWiV/umM903esQdCoaC+b1atJqtm3MAtOQ8Pf6WmwxrE89owZrb1O+lAO2
         dieZLBw68I2xbWAVInZp1mNdqP6wj1P6SyPdD4wT4vA6hX59RNBYNXfB3+guqS3EEhZo
         Vq9Z7u/zN7UoNSRAtJFw48P2DczbtVHmS1aN7jn3uosna9f9bUJjTxYuPLa/UV5vtyHJ
         lrXaVH4Tnh51lCZjMY3hU2BcXQueSTQEZUDG59r6cMyboOxOrQ70NR2z8IUAyj+7wKe4
         Gq/9tWp8l9k35KnFtin45u7NM0H2KNwH6WdhRzlH7LO+daN8WDfbnol5hjCqkivpgpyO
         9d2g==
X-Gm-Message-State: AOJu0YxbxKyCmWgk+Wigfk57l+AuJgLu/x05tT4ZgpQWU/LzLQHnNXqC
	XxMmWVnde8CFQH93S0A6JntR/dw5nNl8ek759cHib3nWmeRTI6gzU1n0MFmvRjPqeff22HYRnn9
	9
X-Gm-Gg: ASbGncsSE9ed8Ljs3Tu8fgs7QYmB6v5gH9TviN2b0CJcDhrd98vTe73cDNf36bqgVlq
	jWF4H4g6R4u10knxZjMMXvOKxsaIE8EoqT4ZG2ip40gNKzRJI76N1Tn5DRPPKP2pp+g7bTbBj83
	dav2oKNtkQ5Ujo0+URA8fZE3kVe0G1m4GQ4YBlSctat/2O+t2bXbScGaQ5QkA9comttWaE1R4/A
	R2CVAX/AQq2tTwVv5OrhF5HTjHlWg8RIkD1q36UxBypb+EfYzgRotsDIWwppb8DRZDnhbAuMGvF
	HhuPpV14eWl5nULP6ERQm/MnbI/EmIGy+BNFIn/4a7OAKcB3hKLi9cdT27bdJ5G2ms34KP0yURC
	4Ndh86ZsUXJgw
X-Google-Smtp-Source: AGHT+IEWFlY/amdqJMFtmG+9quJOsKMiqrHprmQt9MPjE6XcSchrz3O049vnnxAEAJl1FXv6Y883tA==
X-Received: by 2002:a05:6402:1ecf:b0:5dc:7374:261d with SMTP id 4fb4d7f45d1cf-5e4448537bbmr32099252a12.7.1740678071066;
        Thu, 27 Feb 2025 09:41:11 -0800 (PST)
Received: from localhost (p200300de374627004d16a5f447740583.dip0.t-ipconnect.de. [2003:de:3746:2700:4d16:a5f4:4774:583])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5e4c43a7a1fsm1378478a12.80.2025.02.27.09.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 09:41:10 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH] multipathd: fix hang during shutdown with queuing maps
Date: Thu, 27 Feb 2025 18:41:04 +0100
Message-ID: <20250227174104.206721-1-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since c9689b6 ("multipathd: Remove dependency on
systemd-udev-settle.service"), multipathd.service starts very early during
boot, which in systemd's service ordering logic means that it is stopped
late. While this is generally a good thing, it means that, when systemd
unmounts file systems and tears down the block device stack, multipathd
is still running. Therefore our "queue_without_daemon" logic, which disables
queuing when multipathd exits, isn't effective yet. If there are any
multipath maps that are in queueing state at this point in time, the system
may hang indefinitely.

To fix that, add a new service which starts later (and thus stops earlier) and
disables queueing on all multipath maps during shutdown. Similar to lvm2's
blk-availability.service, the service does nothing when started.

Fixes: c9689b6 ("multipathd: Remove dependency on systemd-udev-settle.service")

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/Makefile                       | 6 ++++--
 multipathd/multipathd-queueing.service.in | 9 +++++++++
 multipathd/multipathd.service.in          | 2 +-
 3 files changed, 14 insertions(+), 3 deletions(-)
 create mode 100644 multipathd/multipathd-queueing.service.in

diff --git a/multipathd/Makefile b/multipathd/Makefile
index 61cf1af..4bcee6b 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -41,7 +41,7 @@ ifeq ($(FPIN_SUPPORT),1)
 OBJS += fpin_handlers.o
 endif
 
-all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket
+all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket $(EXEC)-queueing.service
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	@echo building $@ because of $?
@@ -64,6 +64,7 @@ install:
 ifdef SYSTEMD
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(unitdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 $(EXEC).service $(DESTDIR)$(unitdir)
+	$(Q)$(INSTALL_PROGRAM) -m 644 $(EXEC)-queueing.service $(DESTDIR)$(unitdir)
 	$(Q)$(INSTALL_PROGRAM) -m 644 $(EXEC).socket $(DESTDIR)$(unitdir)
 endif
 	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)/man8
@@ -74,11 +75,12 @@ uninstall:
 	$(Q)$(RM) $(DESTDIR)$(bindir)/$(EXEC) $(DESTDIR)$(bindir)/$(CLI)
 	$(Q)$(RM) $(DESTDIR)$(mandir)/man8/$(EXEC).8
 	$(Q)$(RM) $(DESTDIR)$(mandir)/man8/$(CLI).8
+	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC)-queueing.service
 	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).service
 	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
 
 clean: dep_clean
-	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket
+	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC)-queueing.service $(EXEC).socket
 
 include $(wildcard $(OBJS:.o=.d) $(CLI_OBJS:.o=.d))
 
diff --git a/multipathd/multipathd-queueing.service.in b/multipathd/multipathd-queueing.service.in
new file mode 100644
index 0000000..18b0ca6
--- /dev/null
+++ b/multipathd/multipathd-queueing.service.in
@@ -0,0 +1,9 @@
+[Unit]
+Description=Enable queuing for multipath maps
+After=local-fs.target remote-fs.target multipathd.service
+
+[Service]
+Type=oneshot
+RemainAfterExit=yes
+ExecStart=/bin/true
+ExecStop=@BINDIR@/multipathd disablequeueing maps
diff --git a/multipathd/multipathd.service.in b/multipathd/multipathd.service.in
index b6a25b3..eb58943 100644
--- a/multipathd/multipathd.service.in
+++ b/multipathd/multipathd.service.in
@@ -2,7 +2,7 @@
 Description=Device-Mapper Multipath Device Controller
 Before=lvm2-activation-early.service
 Before=local-fs-pre.target blk-availability.service shutdown.target
-Wants=systemd-udevd-kernel.socket @MODPROBE_UNIT@
+Wants=systemd-udevd-kernel.socket multipathd-queueing.service @MODPROBE_UNIT@
 After=systemd-udevd-kernel.socket @MODPROBE_UNIT@
 After=multipathd.socket systemd-remount-fs.service
 Before=initrd-cleanup.service
-- 
2.48.1

