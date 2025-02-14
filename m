Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2C81FC10E
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 22:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739571036; cv=none; b=P5ElV3MLI3h8/dZuboi3pn1v6eaOsjrTX07w+0P0pGA/RmlVxm7SirMEMwY/cvJR7/f0HjW7MSMABs3d6nOa3th77ehjJp5otdtNuZGyKSIOocUvcl6J/VWxJHW8s2BsMrpGY/Jx7ZWn/dAT4vd6p5/QYFDc7p8b6buJZBRivTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739571036; c=relaxed/simple;
	bh=DYrMSk4AQU1u4X9YborFmHHmLE57qCojBRuK8ma87e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFieiWuDZAkD34rRdGMYV/oIgmXhMdcQFYk+yuo9qJc5Cx9xeU5RuB7UdJwwq8CikcPv97LzdIKbrv+yeKFEvS065r6sQttDDAdgRdTE4BwS8Svot6LQHbo1PCDAMWZi66XVwWDka4Yf/hMss/KWxrflaXOPWOQjUeiC0odocVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FvygshSH; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FvygshSH"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso428794566b.1
        for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 14:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739571033; x=1740175833; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=578YEZjvQAxwKHK6SmUl2Er8XRp1rjU3E8RBIObEcbQ=;
        b=FvygshSHoddJL69Bow2cYDMvzBJV1ADlM5KT6eVM3xDLY5wm1rh7Q2Fb7GrNrm1k/t
         0++Rk/qf270u8ArM2YBWEK4opTNTjngT2zCZJLLb6ylHCUwIP2PjBTxxsI20JgpWpQV6
         +7ryrPcAPdtdBewAGovG8hIY7tSpuXBEebKm5wRQutF1VV/vvWQRPbmRAto43mcjVd20
         we5toadlAz2f+CrvgLihWQ7ZMhgx8k0d8Ul3zWVIDTr3Q0E7lL6zkHS6pghLsDsdaFSN
         gDd3fKfh1U1EhQ09x1TkH7BphYBPkPPuMzyDwgVd0vn1Y/n0K8oq3M4yvKc9NWmgy0g8
         5aow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739571033; x=1740175833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=578YEZjvQAxwKHK6SmUl2Er8XRp1rjU3E8RBIObEcbQ=;
        b=i9soUMwvqTulQ4KfFRgKwFRW0NjVkYl8BqQ3VtHyNsPPzhNa3nswc6mR3QyGEBP3yl
         22UT4V8afdAIV0OqElPX4q5Wwh804zaABUuc1X81IvE3TXWuN5JFJdWIW0m0wFHvWuWS
         ZWjA+Hg72wxevhr2pJIb5jUdGJm6yKPrWzwEuj8yAHcgx0BWTEcIUsVMeA0MWNA29Fm+
         3lzsEuIVS/SnVQHJk84SXq35tL1kWb64LOZ8DgUZX0X2mDdoieL0ryClakNrEGkTkxR6
         iHXNU+qWvWdCcdeQwAjvy82cXGFrj56kgMWFJlrv8oK1ONRoDR5J5cdcvZYWj7a09JPx
         2LNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRstMnSqKc7JjGlGn2LjZ7Z2ylPM+Sj2y3CbuD3zAZHUVqDcahatuW4yLjVGEQzHWj5Ts1Z78uWA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0KvVi06oFqs+Oc7ZL6hENbu9s+U/I5Ol+qwzW2iUYq9KBT0+j
	Mo/kdqTQfaQykovu+XpJy8L9JmiwuqWYBHK1gaoAR3jTPfkyOocoxXix9PZr9ys=
X-Gm-Gg: ASbGncuvSlXYVP7LUkCShDJpEbYAmf94DbafeWQq//1S0A8CO9pjqT5pvR7OuEFTjQQ
	h7Zvh6TiRjNbZcuTSScNcW0YocBr8jxvRT56o0pygK+j/VWFn/N164rkeDjJ9XDQkGyjPeKUMz3
	3mBG5vASxKfymLCRiE9DzYhAAskmfcEtFevtEsOTpwXn8Pd4sEdDdLTam+GQGSG16Ms7e+ebu3k
	vyQqFP4+NuCm3Aebfc9KQjY5rD9XhTcmAZVnIT5XQE8WLjb7Q6Zixt3zt/VEsLbtuCeACP8LGJY
	yMwm8QXxoG8R/y1GInIJL8+FMI709Dv4r2bnDUH0rpjk/GddUTjRiM1NlmYAbG9aETnbTPSe4e2
	CLw==
X-Google-Smtp-Source: AGHT+IGtSvvU3m6U5nA6BfW0izenQ7l/evdQGm0vPKeoRw6c4PPouExRIwsjgBUgK62RjTmZQX68gA==
X-Received: by 2002:a17:907:9802:b0:ab7:bcc0:9067 with SMTP id a640c23a62f3a-abb70dd72f8mr81775566b.40.1739571032498;
        Fri, 14 Feb 2025 14:10:32 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aba53258215sm415720266b.53.2025.02.14.14.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:10:31 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v3 07/10] multipathd: listen on pathname and abstract socket by default
Date: Fri, 14 Feb 2025 23:10:08 +0100
Message-ID: <20250214221011.136762-8-mwilck@suse.com>
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

Pass both ABSTRACT_SOCKET and PATHNAME_SOCKET to the compiler at
build time, and listen on both sockets by default.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc            |  2 +-
 libmpathcmd/mpath_cmd.c |  2 +-
 multipathd/main.c       | 11 ++++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index d0fecc3..9e3dc46 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -118,7 +118,7 @@ CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(TGTDIR)$(configdir)\" \
 		   -DDEFAULT_CONFIGFILE=\"$(TGTDIR)$(configfile)\" -DSTATE_DIR=\"$(TGTDIR)$(statedir)\" \
 		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" \
-		   -DDEFAULT_SOCKET=\"$(abstract_socket)\" \
+		   -DABSTRACT_SOCKET=\"$(abstract_socket)\" -DPATHNAME_SOCKET=\"$(pathname_socket)\" \
 		   -DWSTRINGOP_TRUNCATION=$(if $(WSTRINGOP_TRUNCATION),1,0) \
 		   -MMD -MP
 CFLAGS		:= -std=$(C_STD) $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 5a39471..c7cf954 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -113,7 +113,7 @@ int mpath_connect__(int nonblocking)
 			(void)fcntl(fd, F_SETFL, flags|O_NONBLOCK);
 	}
 
-	len = mpath_fill_sockaddr__(&addr, DEFAULT_SOCKET);
+	len = mpath_fill_sockaddr__(&addr, ABSTRACT_SOCKET);
 	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
 		int err = errno;
 
diff --git a/multipathd/main.c b/multipathd/main.c
index ac204b2..b41c181 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1899,13 +1899,14 @@ uxlsnrloop (void * ap)
 	pthread_cleanup_push(rcu_unregister, NULL);
 	rcu_register_thread();
 
-	num = get_systemd_sockets(&ux_sock);
+	num = get_systemd_sockets(ux_sock);
 	if (num < 1) {
-		ux_sock[0] = ux_socket_listen(DEFAULT_SOCKET);
-		num = 1;
+		ux_sock[0] = ux_socket_listen(ABSTRACT_SOCKET);
+		ux_sock[1] = ux_socket_listen(PATHNAME_SOCKET);
+		num = 2;
 	}
-	if (ux_sock[0] == -1) {
-		condlog(1, "could not create uxsock: %d", errno);
+	if (ux_sock[0] == -1 && ux_sock[1] == -1) {
+		condlog(1, "could not create sockets: %d", errno);
 		exit_daemon();
 		goto out;
 	}
-- 
2.48.1

