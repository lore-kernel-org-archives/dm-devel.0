Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C0E2C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:22:59 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-i3m9pJv1NoacGc7tLuA7aQ-1; Sat, 27 Nov 2021 10:22:54 -0500
X-MC-Unique: i3m9pJv1NoacGc7tLuA7aQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6783D1853043;
	Sat, 27 Nov 2021 15:22:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DD9960C0F;
	Sat, 27 Nov 2021 15:22:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 29F35473DB;
	Sat, 27 Nov 2021 15:22:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJw6C000427 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A25332026D69; Sat, 27 Nov 2021 15:19:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E1492026D65
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 849A885A5AA
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:58 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-287-TsRD4druM_i9ATUJVZCYIg-1; Sat, 27 Nov 2021 10:19:56 -0500
X-MC-Unique: TsRD4druM_i9ATUJVZCYIg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 500811FCA3;
	Sat, 27 Nov 2021 15:19:55 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EF6A813AAD;
	Sat, 27 Nov 2021 15:19:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id aCJWOJpMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:54 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:29 +0100
Message-Id: <20211127151929.7727-37-mwilck@suse.com>
In-Reply-To: <20211127151929.7727-1-mwilck@suse.com>
References: <20211127151929.7727-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJw6C000427
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 35/35] multipathd: uxlsnr: use recv() for
	command length
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

If the peer uses libmpathcmd, we can be certain that the first
8 bytes are being sent in a single chunk of data. It's overkill
to try and receive the command length byte-by-byte.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 07a484c..1b3aa95 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -441,6 +441,7 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 		if (!(revents & POLLIN))
 			return STM_BREAK;
 		if (c->cmd_len == 0) {
+			size_t len;
 			/*
 			 * We got POLLIN; assume that at least the length can
 			 * be read immediately.
@@ -449,17 +450,17 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 			c->expires.tv_sec += uxsock_timeout / 1000;
 			c->expires.tv_nsec += (uxsock_timeout % 1000) * 1000000;
 			normalize_timespec(&c->expires);
-			n = mpath_recv_reply_len(c->fd, 0);
-			if (n == -1) {
-				condlog(1, "%s: cli[%d]: failed to receive reply len",
-					__func__, c->fd);
-				c->error = -ECONNRESET;
-			} else if (n > _MAX_CMD_LEN) {
-				condlog(1, "%s: cli[%d]: overlong command (%zd bytes)",
+			n = recv(c->fd, &len, sizeof(len), 0);
+			if (n < (ssize_t)sizeof(len)) {
+				condlog(1, "%s: cli[%d]: failed to receive reply len: %zd",
 					__func__, c->fd, n);
 				c->error = -ECONNRESET;
+			} else if (len <= 0 || len > _MAX_CMD_LEN) {
+				condlog(1, "%s: cli[%d]: invalid command length (%zu bytes)",
+					__func__, c->fd, len);
+				c->error = -ECONNRESET;
 			} else {
-				c->cmd_len = n;
+				c->cmd_len = len;
 				condlog(4, "%s: cli[%d]: connected", __func__, c->fd);
 			}
 			/* poll for data */
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

