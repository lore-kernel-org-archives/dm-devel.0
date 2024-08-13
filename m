Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F49183CA6
	for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 09:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723542106; cv=none; b=CZoGEnzyv50xqEI+B3QrGGl1cxngpDNy8De/ez0koT6o/2R5AbzEwe18jjnxifEXv+KgFPTo/3JuHCGrc4+1zEx6IJAtbzeAB7iF8j2orBzK2kAicISWFNWiWy+isntoIsPgUVjYyMWXZoR8WHdSC5J1M8ANiOKYVPqYgBxk4bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723542106; c=relaxed/simple;
	bh=sRvN9XgyXiTZOpKlVkafyP1TCYvXGNj3L41j51u9WmA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CQwDSUta4mHmMJf9H7Qxv+9echg53eeenlMjvDx1MMjsathvnjBVeNQCaRWiuCDiPXqijMHVmwa1DcOSn6Nct14mkYyBmnK1nsXX0IlzzF3y1KmeiT0x+lJWlCbbwoCyMHsa0RCj7GMVKW9870Om6esyc3x0xMyh7AeQ5zFVDSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BSayWTRl; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BSayWTRl"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a7a9e25008aso68895766b.0
        for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 02:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723542102; x=1724146902; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4Fo9LICpxTPtb/Y2ahPZj5XEhi6E/QzStAAryutPs9Q=;
        b=BSayWTRlw5eDblFVbkC+8r8YZQhK/gn718F3CNa6ULWo0XUtRZ1KyZSxIRR6kljS8F
         Az9xEsuI0C7df9yE3Z9CirBYpK1/0rhHpqqTQj/NtNAiArD8zoifHO3/9O1Ph+fh1O1h
         qNpvhdF6d8I0e831NfI79HlCugZl80UvQ29k5zdHgWy6sMM+YtxahePlf2QlCZaUykMH
         N9Ub6vPSWI1d+llCNbJ1TC84vpvHxvwq1PNd8eBju8O//HOyaq5ZBN7kacUmErjnxeo5
         L/jWq2TEP+UFxbiqqsl+gNRdsVyXIsNbhhaUfGnDZncB1AfRkl6EvjfjvKAW9LmGa7md
         v4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723542102; x=1724146902;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Fo9LICpxTPtb/Y2ahPZj5XEhi6E/QzStAAryutPs9Q=;
        b=Xh+7ajEi/nxd8whDacI8zbn68FyjTX2a4nWCJZpdRBQOsZBRKpkjuIzuCLztnE7P5s
         zw1jHFYHjTosCSR0/C5BV0vFAglt4bqXn3Gp5gMEYO9jcagk/owyW5eaiQWc1wsvFQCF
         z50Dv4zhGt73oDXG5xOtnmQX0MSqx8ZcUvXDzEKE8NGTBzQAtB4JLjyDjTfNCqaA8tKA
         7KlN4qldQdvicTgtzGOpDjsHvdAvWYlu8rRMrv72fcSpivMnSN75rv5WzuPW+P8qLq5e
         axyV2Zcw6uCq3y6Xpfpa8iwu2PN8hVbOBAk4FzAmjyOFFwl6HdUYElvF4M0SKdCHxlil
         ZKcQ==
X-Gm-Message-State: AOJu0YwI96TnTetkSGdGirnHINesaj5BgEd9LAxHdPeqOWYqH560UcIw
	sIn6tynk4NsAK4cAv4D7/HNwtLiDuuSW3AxRrq+xnqPcLVr7x00saxxr/K2NfLc=
X-Google-Smtp-Source: AGHT+IGLIoniWN9zhXX/4urfnI67oySg7LJ+wg+D1wIqvemqtwxSv5tkcdtwysLdf4WBXNf9QGA4OA==
X-Received: by 2002:a17:907:7f27:b0:a7d:e84c:a9e7 with SMTP id a640c23a62f3a-a80ed2ca9a6mr235037966b.53.1723542101757;
        Tue, 13 Aug 2024 02:41:41 -0700 (PDT)
Received: from localhost (p200300de37360a00e6b318fffe37a690.dip0.t-ipconnect.de. [2003:de:3736:a00:e6b3:18ff:fe37:a690])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a80f3f47b4asm54827166b.36.2024.08.13.02.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 02:41:41 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/2] libmpathcmd: reinstate ABI 1.0.0
Date: Tue, 13 Aug 2024 11:40:45 +0200
Message-ID: <20240813094046.21644-1-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__mpath_connect() was part of our public ABI. Instead of removing
it completely, define it as a weak alias of the new mpath_connect__().
This way, programs linked against previous versions of libmpathcmd
will continue to work.

This shouldn't interfere with general symbol naming rules, as a weak
symbol won't override a library symbol of the same name.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathcmd/libmpathcmd.version | 12 ++++++++----
 libmpathcmd/mpath_cmd.c         |  3 +++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/libmpathcmd/libmpathcmd.version b/libmpathcmd/libmpathcmd.version
index a786c25..81bdb2b 100644
--- a/libmpathcmd/libmpathcmd.version
+++ b/libmpathcmd/libmpathcmd.version
@@ -10,16 +10,20 @@
  *
  * See libmultipath.version for general policy about version numbers.
  */
-LIBMPATHCMD_2.0.0 {
+
+LIBMPATHCMD_1.0.0 {
 global:
 	mpath_connect;
-	mpath_connect__;
+	__mpath_connect;
 	mpath_disconnect;
 	mpath_process_cmd;
 	mpath_recv_reply;
 	mpath_recv_reply_len;
 	mpath_recv_reply_data;
 	mpath_send_cmd;
-local:
-	*;
 };
+
+LIBMPATHCMD_1.1.0 {
+global:
+	mpath_connect__;
+} LIBMPATHCMD_1.0.0;
diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 1fa036c..a38e8b6 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -133,6 +133,9 @@ int mpath_connect__(int nonblocking)
 	return fd;
 }
 
+extern int __mpath_connect(int)
+	__attribute__((weak, alias("mpath_connect__")));
+
 /*
  * connect to a unix domain socket
  */
-- 
2.46.0

