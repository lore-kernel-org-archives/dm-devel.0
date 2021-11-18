Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9634EC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:06:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3FB8261A79
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:06:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3FB8261A79
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-rnm8oQ4NPmeueuDbMMmlxg-1; Thu, 18 Nov 2021 18:06:05 -0500
X-MC-Unique: rnm8oQ4NPmeueuDbMMmlxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D17831927802;
	Thu, 18 Nov 2021 23:05:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9ADF1980E;
	Thu, 18 Nov 2021 23:05:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 97C041832DD7;
	Thu, 18 Nov 2021 23:05:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxCca002267 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 91179218012A; Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BEB0218014B
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72515811E7A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-139-teKXt4a2PouF4ngYRl8fdg-1; Thu, 18 Nov 2021 17:59:09 -0500
X-MC-Unique: teKXt4a2PouF4ngYRl8fdg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 202F7217BA;
	Thu, 18 Nov 2021 22:59:08 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CB49E13B11;
	Thu, 18 Nov 2021 22:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id uLWUL7valmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:07 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:24 +0100
Message-Id: <20211118225840.19810-33-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxCca002267
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 32/48] multipathd: uxlsnr: use poll loop for
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 multipathd/uxlsnr.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 45fe7b5..6213454 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -447,7 +447,6 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
 				short revents)
 {
 	ssize_t n;
-	const char *buf;
 
 	condlog(4, "%s: cli[%d] poll=%x state=%d cmd=\"%s\" repl \"%s\"", __func__,
 		c->fd, revents, c->state, c->cmd, get_strbuf_str(&c->reply));
@@ -544,16 +543,31 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
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
@@ -686,6 +700,9 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
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

