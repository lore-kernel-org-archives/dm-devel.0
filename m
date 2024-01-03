Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8022A1CF8F
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ebNybJUv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cLy/d9muCNEcWzMofb5efXrkIquHgUkmHHJliJ99pNA=;
	b=ebNybJUviEGMNgqd1KOHKj26l39I2NzZRWEkRtq7HnkESjNm3+FEenbPwBOTvDKZylbmGF
	6iTpbE8WZ9B+JeFz5PUn6Mix4PmK4rS8lGEK7/pywRhh4jjazpbC6gDBEhlaZCTM9cDvs1
	J9aNTarRkd27gpY8Jeuf0Kv84REwDwo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-140-8InfbbjfMBCnKKfPcPYi-g-1; Wed, 03 Jan 2024 12:56:47 -0500
X-MC-Unique: 8InfbbjfMBCnKKfPcPYi-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EB96185A784;
	Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 789382166B31;
	Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403Hukqx018531
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:46 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Hukcn018530;
	Wed, 3 Jan 2024 12:56:46 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 16/18] multipath: Don't locally retry deletgated remove failures
Date: Wed,  3 Jan 2024 12:56:41 -0500
Message-ID: <20240103175643.18438-17-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Now that multipathd is running the same code to remove devices as
multipath, multipath doesn't need to automatically retry the remove
failures. Instead it now repeatedly calls delegate_to_multipathd()
to handle any retries.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index d3b46f3e..83dca8c0 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -741,15 +741,16 @@ get_dev_type(char *dev) {
  * It is safer to use equivalent multipathd client commands instead.
  */
 enum {
-	DELEGATE_OK = 0,
-	DELEGATE_ERROR = -1,
-	NOT_DELEGATED = 1,
+	DELEGATE_OK,
+	DELEGATE_ERROR,
+	DELEGATE_RETRY,
+	NOT_DELEGATED,
 };
 
 int delegate_to_multipathd(enum mpath_cmds cmd,
 			   __attribute__((unused)) const char *dev,
 			   __attribute__((unused)) enum devtypes dev_type,
-			   const struct config *conf)
+			   struct config *conf)
 {
 	int fd;
 	char command[1024], *p, *reply = NULL;
@@ -767,17 +768,17 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
 	}
 	else if (cmd == CMD_FLUSH_ONE && dev && dev_type == DEV_DEVMAP) {
 		p += snprintf(p, n, "del map %s", dev);
-		/* multipathd doesn't try as hard, to avoid potentially
-		 * hanging. If it fails, retry with the regular multipath
-		 * command */
-		r = NOT_DELEGATED;
+		if (conf->remove_retries > 0) {
+			r = DELEGATE_RETRY;
+			conf->remove_retries--;
+		}
 	}
 	else if (cmd == CMD_FLUSH_ALL) {
 		p += snprintf(p, n, "del maps");
-		/* multipathd doesn't try as hard, to avoid potentially
-		 * hanging. If it fails, retry with the regular multipath
-		 * command */
-		r = NOT_DELEGATED;
+		if (conf->remove_retries > 0) {
+			r = DELEGATE_RETRY;
+			conf->remove_retries--;
+		}
 	}
 	/* Add other translations here */
 
@@ -806,7 +807,7 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
 	if (reply != NULL && *reply != '\0') {
 		if (strncmp(reply, "fail\n", 5))
 			r = DELEGATE_OK;
-		if (r != NOT_DELEGATED && strcmp(reply, "ok\n")) {
+		if (r != DELEGATE_RETRY && strcmp(reply, "ok\n")) {
 			/* If there is additional failure information, skip the
 			 * initial 'fail' */
 			if (strncmp(reply, "fail\n", 5) == 0 &&
@@ -1021,13 +1022,17 @@ main (int argc, char *argv[])
 		goto out;
 	}
 
-	switch(delegate_to_multipathd(cmd, dev, dev_type, conf)) {
-	case DELEGATE_OK:
-		exit(RTVL_OK);
-	case DELEGATE_ERROR:
-		exit(RTVL_FAIL);
-	case NOT_DELEGATED:
-		break;
+	while (1) {
+		int ret = delegate_to_multipathd(cmd, dev, dev_type, conf);
+
+		if (ret == DELEGATE_OK)
+			exit(RTVL_OK);
+		if (ret == DELEGATE_ERROR)
+			exit(RTVL_FAIL);
+		if (ret == DELEGATE_RETRY)
+			sleep(1);
+		else /* NOT_DELEGATED */
+			break;
 	}
 
 	if (check_alias_settings(conf)) {
-- 
2.43.0

