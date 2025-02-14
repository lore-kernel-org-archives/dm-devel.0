Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A62F1FC10D
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 22:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739571033; cv=none; b=f4K/OJ0s+yEOkMQEz3VM0r/BGn74FF+OWQJE0XRdDkyxSJsupmuiCKh1Bi17B9LVHYiZ0UouCzvGsu4zoZ3xWQ9zZLIpSHsOPzFAFyPaac2agSgxd3S4HKC66/HNV8wxXMZEMBrK3fddj/DhTneMoh8VlO4xZDZqEKqt6zalaMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739571033; c=relaxed/simple;
	bh=Na73xDahlZS1rxik68kyYK3WXihqieFSa2MmBb6Oyrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgHlTOZWUbO2hereMAezGj3ulEgLv6r6QZGhcEKhomX6GAcjItBgzwEEubK3WkXpSsVbYC1fdw1MXD08ftt5cEJIw02qXii2VOU/oN2+qnOij2lr5+AXHEXw1SS/92q89ixEwvEDM6F5QuJ2eVAH77xzeiojHtRgMvDUM0gCcBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dRADeHAU; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dRADeHAU"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aaecf50578eso518060566b.2
        for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 14:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739571029; x=1740175829; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gFeUl6XnfeilaPzet7d+57Sh+AWbFP2lvUy3EHTZr4o=;
        b=dRADeHAUeA7cMeNkY/uyjGCkRLt0cbE1LpOdbTqbaz7/15c8L1l4DGfZzqIKrY/pFd
         ZRvo7IjkkXH685RLYbiAEHhEEUAV41OZunsiroGgCeQVDGuwovlUk0vBYksjMxDiVQ2B
         YPqvpNXIBemJUA5YURS5a7fohm72sWFxpyBmGjdW7Hmq9ti2Svm1IvqwAcgvZ3+csv++
         Ruvqoxl4uyow23yjeWQWQPa+OXIJ19pG8/HeYOkwGrFSfg2WFee0qwUM42Y2GSUCzcr6
         q5RTw8iGOyhwE8pEcm997igqsmMw20rfCABdYWVowYgyjtcWd6tjwdLI7isv/o3y/jlp
         2kpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739571029; x=1740175829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gFeUl6XnfeilaPzet7d+57Sh+AWbFP2lvUy3EHTZr4o=;
        b=aAQlZhJHQohQSuBFMxFPee2h7EzPL8Dsu8JAle1Eh8JRVxjUEb1eTcCW75YzUibhmj
         a7QqzcYS3qyYSfQsoa1eHsPiqPkFwEe27OBpqgpWwjDsY9zptJURiRejgIR0pIcLNYjW
         3cVu9U8Xj4ON0uvzpgHC8+ZUcTRuMus4F4Phk9QMfifSCS2BZng9wMRLQwCPvsXJH9d3
         Uu0d24556uQ1AxMU8NpoxYRJV1s2Vj62kkWTW+If/n1QAV4hhkjvDr556eNPpikZzkwV
         rrDD612Chs/5YfwxYRV87P6h/z2x8IuV2EwQeUJ9cy4ROkGckx0WYQB5OGo29Eap9QHM
         +y+A==
X-Forwarded-Encrypted: i=1; AJvYcCVBb3DE+lEHlEFujabD726aheOG2AtteC8PZOM0pl+ze3wULP4FaEfC/X23HkEgZxeXaOJAFSdYkA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzqlzUh6j5Bga+0heik7ojP/f09EzYYv40JGpXZTB0S0OPBGq1N
	hUU3eFJVPdJwQ+hLQt8V6+o6BTA8TWFHOIzkpzB8DlZvPRurDFdhkxhgkdfA1jcngipIOFXYqfA
	P
X-Gm-Gg: ASbGnctjoZv9fxtEEwU0JtThpDeoQDWTZD/eRcw174RIXSeEmX6t6o8gCP30fHNVmci
	KF2d6Pv8VdoJvsTSllXYmrnQi1cmcHlpg4UVTYnGMzBIJ6dKgw0KXBJp3UbkoPKDR6I4qfaiEZi
	+gRXv5fJubBlGuoxeSGEUjpFZnrqenStM6m9GhuIGbO6JSIT3mQkGbaFVtNSaaeEbvDM//wZkMy
	5/I8HRl/fW7lKN5t3pdED7jeGvnlUyJWJX2qbgpfpFDVA+81r8i3RaohX7woW492Sxsfeeh3hdr
	PIZ3UdbHxuuLMDrAdby6b2Fh0D4eA3q89+48PKkITx8z5plpkZMvqNC5+5gwUYRFks4IF+f/zQl
	H2w==
X-Google-Smtp-Source: AGHT+IEeeRUQaopyljr5P+Gv/45y/4bJWxckLM9UbPxmmU5ohiboiN1eWWLT50syCp/WNplXTPUQ0Q==
X-Received: by 2002:a17:907:7742:b0:ab7:be81:894a with SMTP id a640c23a62f3a-abb7091f374mr59878266b.8.1739571029065;
        Fri, 14 Feb 2025 14:10:29 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aba53231ddasm414940166b.36.2025.02.14.14.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:10:28 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v3 05/10] multipathd: make uxsock_listen() take a pointer to fd
Date: Fri, 14 Feb 2025 23:10:06 +0100
Message-ID: <20250214221011.136762-6-mwilck@suse.com>
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

This prepares being able to pass multiple socket fds.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c   |  2 +-
 multipathd/uxlsnr.c | 11 ++++++++---
 multipathd/uxlsnr.h |  3 +--
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 5455bdf..602215c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1924,7 +1924,7 @@ uxlsnrloop (void * ap)
 	       == DAEMON_CONFIGURE)
 		handle_signals(false);
 
-	uxsock_listen(ux_sock, ap);
+	uxsock_listen(1, &ux_sock, ap);
 
 out_sock:
 	pthread_cleanup_pop(1); /* uxsock_cleanup */
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index d74bb35..79e28e4 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -614,7 +614,7 @@ static void handle_client(struct client *c, struct vectors *vecs, short revents)
 /*
  * entry point
  */
-void *uxsock_listen(long ux_sock, void *trigger_data)
+void *uxsock_listen(int n_socks, long *ux_sock, void *trigger_data)
 {
 	sigset_t mask;
 	int max_pfds = MIN_POLLS + POLLFDS_BASE;
@@ -623,6 +623,11 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1, .mp_wd = -1, };
 	struct vectors *vecs = trigger_data;
 
+	if (n_socks != 1) {
+		condlog(0, "uxsock: no socket fds");
+		exit_daemon();
+		return NULL;
+	}
 	condlog(3, "uxsock: startup listener");
 	polls = calloc(1, max_pfds * sizeof(*polls));
 	if (!polls) {
@@ -673,7 +678,7 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 			}
 		}
 		if (num_clients < MAX_CLIENTS) {
-			polls[POLLFD_UX].fd = ux_sock;
+			polls[POLLFD_UX].fd = ux_sock[0];
 			polls[POLLFD_UX].events = POLLIN;
 		} else {
 			/*
@@ -767,7 +772,7 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 
 		/* see if we got a new client */
 		if (polls[POLLFD_UX].revents & POLLIN) {
-			new_client(ux_sock);
+			new_client(ux_sock[0]);
 		}
 
 		/* handle inotify events on config files */
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index a14a667..a331e23 100644
--- a/multipathd/uxlsnr.h
+++ b/multipathd/uxlsnr.h
@@ -5,7 +5,6 @@
 
 bool waiting_clients(void);
 void uxsock_cleanup(void *arg);
-void *uxsock_listen(long ux_sock,
-		    void * trigger_data);
+void *uxsock_listen(int n_socks, long *ux_sock, void *trigger_data);
 
 #endif
-- 
2.48.1

