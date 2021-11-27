Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D7BC433FE
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:47 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-ElQyDKKjO2WWeSwIFjP8kw-1; Sat, 27 Nov 2021 10:20:43 -0500
X-MC-Unique: ElQyDKKjO2WWeSwIFjP8kw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CA971853028;
	Sat, 27 Nov 2021 15:20:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 47B2960854;
	Sat, 27 Nov 2021 15:20:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 21ECD4A700;
	Sat, 27 Nov 2021 15:20:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJrJE000305 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D6FBE404727D; Sat, 27 Nov 2021 15:19:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D33464047272
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCD3685A5AA
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:53 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-330-wNyxJngRNfeOgKwPdSYmIQ-1; Sat, 27 Nov 2021 10:19:51 -0500
X-MC-Unique: wNyxJngRNfeOgKwPdSYmIQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EA711FCA3;
	Sat, 27 Nov 2021 15:19:50 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2476813AAD;
	Sat, 27 Nov 2021 15:19:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id aL/WBpZMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:50 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:16 +0100
Message-Id: <20211127151929.7727-24-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJrJE000305
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 23/35] multipathd: uxlsnr: use main poll loop
	for receiving
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

As a first step towards our state machine, avoid the call to
read_all() via recv_packet_from_client(). handle_client() is now
invoked twice for the same connection. The first time it reads
the command length, and later on it reads the command itself
piece-wise, as sent by the client. This will be just a single
read in most cases, but not always.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 90 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 15 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index bfeb30d..eb1c48e 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -292,6 +292,8 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
 		condlog(1, "Multipath configuration updated.\nReload multipathd for changes to take effect");
 }
 
+static const struct timespec ts_zero = { .tv_sec = 0, };
+
 static int parse_cmd (char *cmd, char **reply, int *len, void *data,
 		      int timeout)
 {
@@ -394,23 +396,78 @@ static int uxsock_trigger(char *str, char **reply, int *len,
 	return r;
 }
 
+static void set_client_state(struct client *c, int state)
+{
+	switch(state)
+	{
+	case CLT_RECV:
+		reset_strbuf(&c->reply);
+		memset(c->cmd, '\0', sizeof(c->cmd));
+		c->expires = ts_zero;
+		/* fallthrough */
+	case CLT_SEND:
+		/* reuse these fields for next data transfer */
+		c->len = c->cmd_len = 0;
+		break;
+	default:
+		break;
+	}
+	c->state = state;
+}
+
 static void handle_client(struct client *c, void *trigger_data)
 {
 	int rlen;
-	char *inbuf, *reply;
+	char *reply;
+	ssize_t n;
 
-	if (recv_packet_from_client(c->fd, &inbuf, uxsock_timeout) != 0) {
-		dead_client(c);
-		return;
+	switch (c->state) {
+	case CLT_RECV:
+		if (c->cmd_len == 0) {
+			/*
+			 * We got POLLIN; assume that at least the length can
+			 * be read immediately.
+			 */
+			get_monotonic_time(&c->expires);
+			c->expires.tv_sec += uxsock_timeout / 1000;
+			c->expires.tv_nsec += (uxsock_timeout % 1000) * 1000000;
+			normalize_timespec(&c->expires);
+			n = mpath_recv_reply_len(c->fd, 0);
+			if (n == -1) {
+				condlog(1, "%s: cli[%d]: failed to receive reply len",
+					__func__, c->fd);
+				c->error = -ECONNRESET;
+			} else if (n > _MAX_CMD_LEN) {
+				condlog(1, "%s: cli[%d]: overlong command (%zd bytes)",
+					__func__, c->fd, n);
+				c->error = -ECONNRESET;
+			} else {
+				c->cmd_len = n;
+				condlog(4, "%s: cli[%d]: connected", __func__, c->fd);
+			}
+			/* poll for data */
+			return;
+		} else if (c->len < c->cmd_len) {
+			n = recv(c->fd, c->cmd + c->len, c->cmd_len - c->len, 0);
+			if (n <= 0 && errno != EINTR && errno != EAGAIN) {
+				condlog(1, "%s: cli[%d]: error in recv: %m",
+					__func__, c->fd);
+				c->error = -ECONNRESET;
+				return;
+			}
+			c->len += n;
+			if (c->len < c->cmd_len)
+				/* continue polling */
+				return;
+			set_client_state(c, CLT_PARSE);
+		}
+		break;
+	default:
+		break;
 	}
 
-	if (!inbuf) {
-		condlog(4, "recv_packet_from_client get null request");
-		return;
-	}
-
-	condlog(4, "cli[%d]: Got request [%s]", c->fd, inbuf);
-	uxsock_trigger(inbuf, &reply, &rlen,
+	condlog(4, "cli[%d]: Got request [%s]", c->fd, c->cmd);
+	uxsock_trigger(c->cmd, &reply, &rlen,
 		       _socket_client_is_root(c->fd),
 		       trigger_data);
 
@@ -418,11 +475,12 @@ static void handle_client(struct client *c, void *trigger_data)
 		if (send_packet(c->fd, reply) != 0)
 			dead_client(c);
 		else
-			condlog(4, "cli[%d]: Reply [%d bytes]", c->fd, rlen);
-		free(reply);
-		reply = NULL;
+			condlog(4, "cli[%d]: Reply [%zu bytes]", c->fd,
+				get_strbuf_len(&c->reply) + 1);
+		reset_strbuf(&c->reply);
 	}
-	free(inbuf);
+
+	set_client_state(c, CLT_RECV);
 }
 
 /*
@@ -553,6 +611,8 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 					continue;
 				}
 				handle_client(c, trigger_data);
+				if (c->error == -ECONNRESET)
+					dead_client(c);
 			}
 		}
 		/* see if we got a non-fatal signal */
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

