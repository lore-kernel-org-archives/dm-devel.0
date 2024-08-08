Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F7D18FC6F
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130808; cv=none; b=RbFiUDWuEgEYHRqiehn6JbPGA4MJqIhyjs8l3+MmslPSYCco81LsoU9i5u0GVjZ+YGF2EfvCtnD8zNmNfQJOJ+InZn8raOY5jBmd+CprNx6/GzQnCBH06Y4m4H+YPX/KtvSMsBxOvBifQMfb9IQlJUUbHCsccAV1+104tlGS6MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130808; c=relaxed/simple;
	bh=DAtJEXT1ojAh3hFDQXQtASaKqCJi4njDa+4jclXZDeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQauWXFxVYTyybZhzy2pnDAonNmVGGbEudnoXo8hPYI3Sk1hvQ/+5z2E4rSzZuraP+h9g5C43+P567fb846nlHTASj5KRnP7emLvlhDv9eDHcwXseEKeZSfenQaRCpMo3AUeB+DRNxTi9dvySoYFGjH3FCxj7n8r/8UHGSvg3r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VKJ8Frnk; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VKJ8Frnk"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5b3fff87e6bso1186224a12.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130804; x=1723735604; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EmmZyOAsa+s5ItxmejNGsvmjsNNyByWDgiAAI0e2I0=;
        b=VKJ8FrnkfbNihJnxEW14KWBG9z9tsIqkG5N7H9H2h3Ib1GKn8JVjct1AZObuCxfbmm
         JV3jFWQ/0UqLwjsjIw/iFfvXIrqqHWUsRR98MrVTFQHsH/gzllfYP2OoRxLROoFETJRA
         gmWIF2I2S+bUb3U58bdzkn4spTuwT9vAJiA1R8DJiP/WYVEMQ915ghQ5MC3ceQa74wja
         f1eMWVL+iCPNOZxjkzxJ8euZfOl+GAUWzbDIY/K68wU42Aqf//p3tkcX4nMHKbiHRa+6
         +oES5vE/jzLnqLqt34Z8bgRQAPcMJnESNqvbrL6tRB669n2GV1qrsY5eEQvzaBjT2qT8
         vK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130804; x=1723735604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6EmmZyOAsa+s5ItxmejNGsvmjsNNyByWDgiAAI0e2I0=;
        b=I0fQHG6EWCBMCo+DEkCG1zfrQNbJK4ZYEfT3WK+wSFGDaBvAW+09d/0jQyWt9ZCgFB
         OrxtJz1vrb5AmboYkmAy24wX3Jtz2QbTXg/XynyT2NcNawpqP0z8S9IZHqj5rtGfWdv5
         msdC/QmlMSW0+JBJgF/lKE9iehQaZvoVYw5sbXFI1KSrey7dyftO8JT7j2w74DFsdy9V
         IV3FSiasOOT7PovzzY5MNDoWkbG/ue7yGkXvSDbG8y4TPWmvX/7Gt61Vlu5614dp8NPB
         lNrZQ6qNM66rHQfr+4rV6vYkuEQvurGMZoEUEKcYhr5XzIq+QM2OBSHzeysheS/34TIN
         aFmg==
X-Gm-Message-State: AOJu0Yz+SIKo2LqL9MWEe3/1t7NNb871q+3B47HT5QPeRf5T1N58TG72
	9nFyDKnDis2qo5aMTW45tYwP9XLlpg2mOYZcpgxC1ob7CrM1TbFVUbYlA1/3kBM=
X-Google-Smtp-Source: AGHT+IGNWcNxadhXIsme1tPaqrNK6DC3H48EZiqVJig6G/dDzJ64brwtRxlF9trXuMsav4UQQ1TRVg==
X-Received: by 2002:a05:6402:909:b0:5a1:61a7:56ce with SMTP id 4fb4d7f45d1cf-5bbb2356e1emr1909151a12.35.1723130804277;
        Thu, 08 Aug 2024 08:26:44 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2d35704sm729954a12.66.2024.08.08.08.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:44 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 10/41] libmpathutil: rename _MAX_CMD_LEN
Date: Thu,  8 Aug 2024 17:25:49 +0200
Message-ID: <20240808152620.93965-11-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libdmmp/libdmmp.c     | 2 +-
 libmpathutil/uxsock.h | 2 +-
 multipathd/uxlsnr.c   | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index fcfba06..1bfdbed 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -46,7 +46,7 @@
 #define _DMMP_JSON_MAPS_KEY			"maps"
 #define _ERRNO_STR_BUFF_SIZE			256
 #define _IPC_MAX_CMD_LEN			512
-/* ^ Was _MAX_CMD_LEN in ./libmultipath/uxsock.h */
+/* ^ Was MAX_CMD_LEN in ./libmultipath/uxsock.h */
 #define _LAST_ERR_MSG_BUFF_SIZE			1024
 
 struct dmmp_context {
diff --git a/libmpathutil/uxsock.h b/libmpathutil/uxsock.h
index 8157060..1726a96 100644
--- a/libmpathutil/uxsock.h
+++ b/libmpathutil/uxsock.h
@@ -6,5 +6,5 @@ int ux_socket_listen(const char *name);
 int send_packet(int fd, const char *buf);
 int recv_packet(int fd, char **buf, unsigned int timeout);
 
-#define _MAX_CMD_LEN		512
+#define MAX_CMD_LEN		512
 #endif
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 185e0a0..198f382 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -59,7 +59,7 @@ struct client {
 	int fd;
 	vector cmdvec;
 	/* NUL byte at end */
-	char cmd[_MAX_CMD_LEN + 1];
+	char cmd[MAX_CMD_LEN + 1];
 	struct strbuf reply;
 	struct handler *handler;
 	size_t cmd_len, len;
@@ -477,7 +477,7 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 				condlog(1, "%s: cli[%d]: failed to receive reply len: %zd",
 					__func__, c->fd, n);
 				c->error = -ECONNRESET;
-			} else if (len <= 0 || len > _MAX_CMD_LEN) {
+			} else if (len <= 0 || len > MAX_CMD_LEN) {
 				condlog(1, "%s: cli[%d]: invalid command length (%zu bytes)",
 					__func__, c->fd, len);
 				c->error = -ECONNRESET;
-- 
2.46.0

