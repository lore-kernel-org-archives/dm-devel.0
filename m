Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4AEDC433FE
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:21:00 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-yr0hUdrVPXaNNlYxxL_gHg-1; Sat, 27 Nov 2021 10:20:56 -0500
X-MC-Unique: yr0hUdrVPXaNNlYxxL_gHg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C396C10168C0;
	Sat, 27 Nov 2021 15:20:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A99875C3DF;
	Sat, 27 Nov 2021 15:20:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8552E4A710;
	Sat, 27 Nov 2021 15:20:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJv8H000417 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A26592026D69; Sat, 27 Nov 2021 15:19:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E5EF2026D65
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 860A7811E76
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:57 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-382-PCt1c1_OOlGQgoyx5hVj8g-1; Sat, 27 Nov 2021 10:19:55 -0500
X-MC-Unique: PCt1c1_OOlGQgoyx5hVj8g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 318AD1FC9E;
	Sat, 27 Nov 2021 15:19:54 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D915713AAD;
	Sat, 27 Nov 2021 15:19:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id SCH/MplMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:53 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:26 +0100
Message-Id: <20211127151929.7727-34-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJv8H000417
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 32/35] multipathd: uxlsnr: use poll loop for
	sending, too
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

send_packet() may busy-loop. By polling for POLLOUT, we can
avoid that, even if it's very unlikely in practice.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 1ebcf10..c5da569 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -447,7 +447,6 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 				short revents)
 {
 	ssize_t n;
-	const char *buf;
 
 	condlog(4, "%s: cli[%d] poll=%x state=%d cmd=\"%s\" repl \"%s\"", __func__,
 		c->fd, revents, c->state, c->cmd, get_strbuf_str(&c->reply));
@@ -527,7 +526,8 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 			free_keys(c->cmdvec);
 			c->cmdvec = NULL;
 			set_client_state(c, CLT_SEND);
-			return STM_CONT;
+			/* Wait for POLLOUT */
+			return STM_BREAK;
 		} else {
 			condlog(4, "%s: cli[%d] waiting for lock", __func__, c->fd);
 			return STM_BREAK;
@@ -538,22 +538,38 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 		free_keys(c->cmdvec);
 		c->cmdvec = NULL;
 		set_client_state(c, CLT_SEND);
-		return STM_CONT;
+		/* Wait for POLLOUT */
+		return STM_BREAK;
 
 	case CLT_SEND:
 		if (get_strbuf_len(&c->reply) == 0)
 			default_reply(c, c->error);
 
-		buf = get_strbuf_str(&c->reply);
+		if (c->cmd_len == 0) {
+			size_t len = get_strbuf_len(&c->reply) + 1;
 
-		if (send_packet(c->fd, buf) != 0)
-			dead_client(c);
-		else
-			condlog(4, "cli[%d]: Reply [%zu bytes]", c->fd,
-				get_strbuf_len(&c->reply) + 1);
-		reset_strbuf(&c->reply);
+			if (send(c->fd, &len, sizeof(len), MSG_NOSIGNAL)
+			    != sizeof(len))
+				c->error = -ECONNRESET;
+			c->cmd_len = len;
+			return STM_BREAK;
+		}
 
-		set_client_state(c, CLT_RECV);
+		if (c->len < c->cmd_len) {
+			const char *buf = get_strbuf_str(&c->reply);
+
+			n = send(c->fd, buf + c->len, c->cmd_len, MSG_NOSIGNAL);
+			if (n == -1) {
+				if (!(errno == EAGAIN || errno == EINTR))
+					c->error = -ECONNRESET;
+			} else
+				c->len += n;
+		}
+
+                if (c->len >= c->cmd_len) {
+			condlog(4, "cli[%d]: Reply [%zu bytes]", c->fd, c->cmd_len);
+			set_client_state(c, CLT_RECV);
+		}
 		return STM_BREAK;
 
 	default:
@@ -687,6 +703,9 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 			case CLT_RECV:
 				polls[i].events = POLLIN;
 				break;
+			case CLT_SEND:
+				polls[i].events = POLLOUT;
+				break;
 			default:
 				/* don't poll for this client */
 				continue;
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

