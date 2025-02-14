Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BEB1DDA18
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 22:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739571035; cv=none; b=eNgYux2GEu2yVHNis/Ps0sjXHfY49dmzsVrpqbPWb0Htw+U0tIabaUqrI/JSleW/b1jl4tQcke43Qqt3zGOLu5n6sviaFYPzIOTsNknySAOU8txFG1S5Nv2mF47l+JXp+apWLYEvCRgz/lSkJo0qs0gFKqe8OjwyCCG27Pi2yec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739571035; c=relaxed/simple;
	bh=laFA1nGz9SmuMX0k1eLTe7OfygCzQdAeZPThcooYUWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjIOf2K5lAV/sgtWUTIU9cRonCU8DjSDnig4BG8hofwWRGEtPD63VJinVao8mHp4WRwbw0zsKRSbBe1uRbNp7dGduT2gocvDWInljqlDbTGvDOcBafLANp7bGbtw+5Zam9k+JE8opXGuFIf4ufHqmg91rK+OMjzLUsmLowq7Fd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AJeDp2cC; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AJeDp2cC"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaf3c3c104fso408015066b.1
        for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 14:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739571031; x=1740175831; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ej12EdUAK1b+uk+2L7lCdVv7GMqrT4vqoApBnP0pYnQ=;
        b=AJeDp2cCa2TXY76Oh/FAEBPc7kLfxbLdreuepj3KU0VOHiXx0a6tt6iXKv/cJ7MEa3
         QFhf10hM73K9KV8TxMZXkSjvKSmqxyhDnSfSzaaf8fyXLj7WK+DWXp40J+kpJ+3Kt2xx
         Fe9au2a5nFqxa8MGUoLd2DCsQlumEE1P8sx/dZOqQMLIdiCYCg7INicj3WpsQ+l4lQSv
         aU0lrxpCBX03P7Xdb+OLadDmvvgedqFxYKjp0KkhoYm9/EbhBClyESCiqK38EHi3GDdp
         4xmkbbS21fE86MEiHnI6VyLNdecYsFJUhQaJwN0WpIIEkhlSSgJPAC/pSKeq5Q/pvp6i
         zP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739571031; x=1740175831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ej12EdUAK1b+uk+2L7lCdVv7GMqrT4vqoApBnP0pYnQ=;
        b=qOBHAwA1lU0V1u/4IPkJGtobT8KcfJRfPyTqXP2OtpHoNugXTr/VckDB0at5lY2Byg
         dadLbaevUSoO3EWHInAAqB6dzcKoyWmBikgTd7ujNw9uV2hwZvq8YkA+I5wiz4O+HgSA
         tTK2d0huTlgn0DEvDiPxvx1TTT4Y24AkOESwzFLHD07fBPueJ/P2GYW6tzNJ/AaMI8gE
         x8DLTA/99cRTFepcDSjyV0cyJn6J0yCupCRmgZTYqMor8NTeB+VG//RF/n3ky2wf5TzX
         gTedRecgPvCbByRa6Yq/dmPDcImVKONuYjEc/W7+6JbIKW0xTkt7341KnMVC/rvNKI6Q
         hM7A==
X-Forwarded-Encrypted: i=1; AJvYcCVxT/SaoiSPOZST4ZtZZMTAQ0MIcF5rRITPQ+lCdK6uLw7U8nJoCRQXeTGPHRE3OycddZZXxc24IQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxBSqBRSLgiHcQOH/jgiBWER+Uau0UI4t/W1A/IPB2nmJBKtj9Q
	EZW72Xe4p+w39yf/1pdL4uJWP7teiUWDmkTkS3FUiPHQr/n2r9tzCwozaQDNq9k=
X-Gm-Gg: ASbGncto6Z8QzzOO6kM7LpmUIWKvr930dDmFCHNQ6A9CFiR3qtjnr8IJD08mTEhgIx+
	heg3tKu9U1YWm1HbRxWNpHEtRhJcch4bNC+TB9xTC72Eu6+wHVcNWqAQcHda2fJwSV7rGDbJcLH
	p/M7jigmvfTaDJ7PCsK0OFgumEq1hM5HYL2QnmWUrzJoOU7mJujkv9Tm49NFBVfnOZVoUiy89bq
	Ydp2hIMsVvxJI7Y33+5Q0qMYLcfzRZemm8V067b6OzkXKUcO9wfTstWC9K2rpdE4R6NCMuLJ/jb
	l3HByXk0ZFpAMllhkamPEVf8C0+IDgkePckNV2T2DAKkGa/oAEummL5YJTlauCz9oTqjubEJEfb
	/3Q==
X-Google-Smtp-Source: AGHT+IE2vWcJPkjsJUcg6VKr4rTFaKINwpovQ4RCb/nrr7vz/Cfca13GLMjbq+ikEoip6suwCC6LVg==
X-Received: by 2002:a17:906:3b56:b0:abb:4802:709e with SMTP id a640c23a62f3a-abb70d67bbdmr71652866b.42.1739571030858;
        Fri, 14 Feb 2025 14:10:30 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aba533bce23sm411999166b.161.2025.02.14.14.10.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:10:29 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v3 06/10] multipathd: allow receiving two socket fds from systemd
Date: Fri, 14 Feb 2025 23:10:07 +0100
Message-ID: <20250214221011.136762-7-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250214221011.136762-1-mwilck@suse.com>
References: <20250214221011.136762-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add another ListenStream directive in multipathd.socket for a Unix pathname
socket. In multipathd, read both socket fds from systemd, and open both
when they are defined.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc                    |  4 +++-
 multipathd/main.c               | 18 ++++++++++++------
 multipathd/multipathd.socket.in |  3 ++-
 multipathd/uxlsnr.c             | 33 ++++++++++++++++++++++-----------
 4 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 4015006..d0fecc3 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -80,6 +80,7 @@ kernel_incdir	:= /usr/include
 sysdir_bin      := $(sys_execprefix)bin
 
 abstract_socket := @/org/kernel/linux/storage/multipathd
+pathname_socket := /run/multipathd.socket
 
 ifeq ($(V),)
 Q		:= @
@@ -172,5 +173,6 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
 		-e 's:@SYSDIR_BIN@:'$(sysdir_bin)': g' \
 		-e 's:@RUNTIME_DIR@:'$(runtimedir)':g' \
 		-e 's/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g' \
-		-e 's,@MPATH_SOCKET@,'$(abstract_socket)',g' \
+		-e 's,@ABSTRACT_SOCKET@,'$(abstract_socket)',g' \
+		-e 's,@PATHNAME_SOCKET@,'$(pathname_socket)',g' \
 		$< >$@
diff --git a/multipathd/main.c b/multipathd/main.c
index 602215c..ac204b2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1869,9 +1869,13 @@ static int get_systemd_sockets(long *ux_sock)
 {
 	int num = sd_listen_fds(0);
 
-	if (num > 1) {
+	if (num > 2) {
 		condlog(3, "sd_listen_fds returned %d fds", num);
 		return -1;
+	} else if (num == 2) {
+		ux_sock[0] = SD_LISTEN_FDS_START + 0;
+		ux_sock[1] = SD_LISTEN_FDS_START + 1;
+		condlog(3, "using fd %ld and %ld from sd_listen_fds", ux_sock[0], ux_sock[1]);
 	} else if (num == 1) {
 		ux_sock[0] = SD_LISTEN_FDS_START + 0;
 		condlog(3, "using fd %ld from sd_listen_fds", ux_sock[0]);
@@ -1889,16 +1893,18 @@ static int get_systemd_sockets(long *ux_sock __attribute__((unused)))
 static void *
 uxlsnrloop (void * ap)
 {
-	long ux_sock;
+	long ux_sock[2] = {-1, -1};
 	int num;
 
 	pthread_cleanup_push(rcu_unregister, NULL);
 	rcu_register_thread();
 
 	num = get_systemd_sockets(&ux_sock);
-	if (num < 1)
-		ux_sock = ux_socket_listen(DEFAULT_SOCKET);
-	if (ux_sock == -1) {
+	if (num < 1) {
+		ux_sock[0] = ux_socket_listen(DEFAULT_SOCKET);
+		num = 1;
+	}
+	if (ux_sock[0] == -1) {
 		condlog(1, "could not create uxsock: %d", errno);
 		exit_daemon();
 		goto out;
@@ -1924,7 +1930,7 @@ uxlsnrloop (void * ap)
 	       == DAEMON_CONFIGURE)
 		handle_signals(false);
 
-	uxsock_listen(1, &ux_sock, ap);
+	uxsock_listen(num, ux_sock, ap);
 
 out_sock:
 	pthread_cleanup_pop(1); /* uxsock_cleanup */
diff --git a/multipathd/multipathd.socket.in b/multipathd/multipathd.socket.in
index c0e86c3..11002fc 100644
--- a/multipathd/multipathd.socket.in
+++ b/multipathd/multipathd.socket.in
@@ -7,7 +7,8 @@ ConditionVirtualization=!container
 Before=sockets.target
 
 [Socket]
-ListenStream=@MPATH_SOCKET@
+ListenStream=@ABSTRACT_SOCKET@
+ListenStream=@PATHNAME_SOCKET@
 
 [Install]
 # Socket activation for multipathd is disabled by default.
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 79e28e4..aa6aae7 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -69,7 +69,8 @@ struct client {
 
 /* Indices for array of poll fds */
 enum {
-	POLLFD_UX = 0,
+	POLLFD_UX1 = 0,
+	POLLFD_UX2,
 	POLLFD_NOTIFY,
 	POLLFD_IDLE,
 	POLLFDS_BASE,
@@ -164,9 +165,10 @@ void uxsock_cleanup(void *arg)
 {
 	struct client *client_loop;
 	struct client *client_tmp;
-	long ux_sock = (long)arg;
+	long *ux_sock = (long *)arg;
 
-	close(ux_sock);
+	close(ux_sock[0]);
+	close(ux_sock[1]);
 	close(notify_fd);
 
 	list_for_each_entry_safe(client_loop, client_tmp, &clients, node) {
@@ -614,20 +616,24 @@ static void handle_client(struct client *c, struct vectors *vecs, short revents)
 /*
  * entry point
  */
-void *uxsock_listen(int n_socks, long *ux_sock, void *trigger_data)
+void *uxsock_listen(int n_socks, long *ux_sock_in, void *trigger_data)
 {
 	sigset_t mask;
 	int max_pfds = MIN_POLLS + POLLFDS_BASE;
+	long ux_sock[2] = {-1, -1};
 	/* conf->sequence_nr will be 1 when uxsock_listen is first called */
 	unsigned int sequence_nr = 0;
 	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1, .mp_wd = -1, };
 	struct vectors *vecs = trigger_data;
 
-	if (n_socks != 1) {
-		condlog(0, "uxsock: no socket fds");
+	if (n_socks < 1 || n_socks > 2) {
+		condlog(0, "uxsock: unsupported number of socket fds");
 		exit_daemon();
 		return NULL;
-	}
+	} else if (n_socks == 2)
+		ux_sock[1] = ux_sock_in[1];
+	ux_sock[0] = ux_sock_in[0];
+
 	condlog(3, "uxsock: startup listener");
 	polls = calloc(1, max_pfds * sizeof(*polls));
 	if (!polls) {
@@ -678,8 +684,10 @@ void *uxsock_listen(int n_socks, long *ux_sock, void *trigger_data)
 			}
 		}
 		if (num_clients < MAX_CLIENTS) {
-			polls[POLLFD_UX].fd = ux_sock[0];
-			polls[POLLFD_UX].events = POLLIN;
+			polls[POLLFD_UX1].fd = ux_sock[0];
+			polls[POLLFD_UX1].events = POLLIN;
+			polls[POLLFD_UX2].fd = ux_sock[1];
+			polls[POLLFD_UX2].events = POLLIN;
 		} else {
 			/*
 			 * New clients can't connect, num_clients won't grow
@@ -687,7 +695,7 @@ void *uxsock_listen(int n_socks, long *ux_sock, void *trigger_data)
 			 */
 			condlog(1, "%s: max client connections reached, pausing polling",
 				__func__);
-			polls[POLLFD_UX].fd = -1;
+			polls[POLLFD_UX1].fd = polls[POLLFD_UX2].fd = -1;
 		}
 
 		reset_watch(notify_fd, &wds, &sequence_nr);
@@ -771,9 +779,12 @@ void *uxsock_listen(int n_socks, long *ux_sock, void *trigger_data)
 		handle_signals(true);
 
 		/* see if we got a new client */
-		if (polls[POLLFD_UX].revents & POLLIN) {
+		if (polls[POLLFD_UX1].revents & POLLIN) {
 			new_client(ux_sock[0]);
 		}
+		if (polls[POLLFD_UX2].revents & POLLIN) {
+			new_client(ux_sock[1]);
+		}
 
 		/* handle inotify events on config files */
 		if (polls[POLLFD_NOTIFY].revents & POLLIN)
-- 
2.48.1

