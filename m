Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB015EEB594
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450376;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ejlfXJuAq/JC4YIlYEUCUR/eLfPJ9sY46EbLMxmpqak=;
	b=h3kCZthS8IIGEqNsC+YrU6jOd11hHYGwbj4yaslF2268oUAqksBfhdZL1JhKW/AFtxpsY0
	lAup7+Rv5Cc3pyJh29DLraFpeP7R45KZi9HtnXdYqBYQnCFuwE+wQLVIonp+5XHLimWcsv
	a2tdbqdb0gOXzjQUKm8XgEeUgb73m44=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-54-E9CTZOsmpr_aIVHQ1Uw-1; Mon, 11 Sep 2023 12:39:31 -0400
X-MC-Unique: 54-E9CTZOsmpr_aIVHQ1Uw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 858E7928B83;
	Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 73B7B40C6EBF;
	Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 425D819465B3;
	Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 618B419466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 433052156711; Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C36D215670B
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 215AF928B84
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-106-VsWX3DzsNsO5Fhb1uC1sgQ-1; Mon,
 11 Sep 2023 12:39:19 -0400
X-MC-Unique: VsWX3DzsNsO5Fhb1uC1sgQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 657F11F8B3;
 Mon, 11 Sep 2023 16:39:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 34DDA139CC;
 Mon, 11 Sep 2023 16:39:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id yAhCC7ZC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:18 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:24 +0200
Message-ID: <20230911163846.27197-16-mwilck@suse.com>
In-Reply-To: <20230911163846.27197-1-mwilck@suse.com>
References: <20230911163846.27197-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v2 15/37] libmultipath: update_bindings_file: use
 a single write()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Save code and syscalls by assembling the content in memory first.
write() may return less bytes written than expected. Deal with it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index ae7bbd2..bd34466 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -118,22 +118,30 @@ static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
 static int write_bindings_file(const Bindings *bindings, int fd)
 {
 	struct binding *bnd;
-	STRBUF_ON_STACK(line);
+	STRBUF_ON_STACK(content);
 	int i;
+	size_t len;
 
-	if (write(fd, BINDINGS_FILE_HEADER, sizeof(BINDINGS_FILE_HEADER) - 1)
-	    != sizeof(BINDINGS_FILE_HEADER) - 1)
+	if (__append_strbuf_str(&content, BINDINGS_FILE_HEADER,
+				sizeof(BINDINGS_FILE_HEADER) - 1) == -1)
 		return -1;
 
 	vector_foreach_slot(bindings, bnd, i) {
-		int len;
+		if (print_strbuf(&content, "%s %s\n",
+					bnd->alias, bnd->wwid) < 0)
+			return -1;
+	}
+	len = get_strbuf_len(&content);
+	while (len > 0) {
+		ssize_t n = write(fd, get_strbuf_str(&content), len);
 
-		if ((len = print_strbuf(&line, "%s %s\n",
-					bnd->alias, bnd->wwid)) < 0)
+		if (n < 0)
+			return n;
+		else if (n == 0) {
+			condlog(2, "%s: short write", __func__);
 			return -1;
-		if (write(fd, get_strbuf_str(&line), len) != len)
-			return -1;
-		truncate_strbuf(&line, 0);
+		}
+		len -= n;
 	}
 	return 0;
 }
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

