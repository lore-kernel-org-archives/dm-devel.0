Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC96C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 16:08:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-uenbbcCAOjWixi9cSkGyEA-1; Thu, 02 Dec 2021 11:08:02 -0500
X-MC-Unique: uenbbcCAOjWixi9cSkGyEA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA70A10144E1;
	Thu,  2 Dec 2021 16:07:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1E3245D62;
	Thu,  2 Dec 2021 16:07:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8A83D4BB7C;
	Thu,  2 Dec 2021 16:07:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2G7gWv006911 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 11:07:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3929A401E2D; Thu,  2 Dec 2021 16:07:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 34F5D401E5D
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D8CA181E071
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:42 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-226-twzNecYcPOmtAGEpoELK2A-1; Thu, 02 Dec 2021 11:07:34 -0500
X-MC-Unique: twzNecYcPOmtAGEpoELK2A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7772B212C6;
	Thu,  2 Dec 2021 16:07:32 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3C37713E82;
	Thu,  2 Dec 2021 16:07:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id eFOMDETvqGGnEgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 02 Dec 2021 16:07:32 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  2 Dec 2021 17:06:50 +0100
Message-Id: <20211202160652.4576-11-mwilck@suse.com>
In-Reply-To: <20211202160652.4576-1-mwilck@suse.com>
References: <20211202160652.4576-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B2G7gWv006911
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 09/11] libmultipath: remove
	recv_packet_from_client()
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

This function became unused after the late uxlsnr patches.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 1 -
 libmultipath/uxsock.c             | 5 -----
 libmultipath/uxsock.h             | 6 ------
 3 files changed, 12 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index a693933..941bd8f 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -140,7 +140,6 @@ global:
 	_print_multipath_topology;
 	pthread_cond_init_mono;
 	recv_packet;
-	recv_packet_from_client;
 	reinstate_paths;
 	remember_wwid;
 	remove_map;
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index 0ccd1fa..2135476 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -128,8 +128,3 @@ int recv_packet(int fd, char **buf, unsigned int timeout)
 {
 	return _recv_packet(fd, buf, timeout, 0 /* no limit */);
 }
-
-int recv_packet_from_client(int fd, char **buf, unsigned int timeout)
-{
-	return _recv_packet(fd, buf, timeout, _MAX_CMD_LEN);
-}
diff --git a/libmultipath/uxsock.h b/libmultipath/uxsock.h
index 8e7401d..e3d28cf 100644
--- a/libmultipath/uxsock.h
+++ b/libmultipath/uxsock.h
@@ -5,9 +5,3 @@ int recv_packet(int fd, char **buf, unsigned int timeout);
 
 #define _MAX_CMD_LEN		512
 
-/*
- * Used for receiving socket command from untrusted socket client where data
- * size is restricted to 512(_MAX_CMD_LEN) at most.
- * Return -EINVAL if data length requested by client exceeded the _MAX_CMD_LEN.
- */
-int recv_packet_from_client(int fd, char **buf, unsigned int timeout);
-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

