Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1E0FC433FE
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 16:08:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-7q2pR9ZmNoeBRrCgZoy0Lg-1; Thu, 02 Dec 2021 11:08:54 -0500
X-MC-Unique: 7q2pR9ZmNoeBRrCgZoy0Lg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8560A64A8E;
	Thu,  2 Dec 2021 16:08:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 64AC25F4E7;
	Thu,  2 Dec 2021 16:08:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B9B74CA93;
	Thu,  2 Dec 2021 16:08:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2G7dmg006894 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 11:07:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B2F0B14582F1; Thu,  2 Dec 2021 16:07:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEE9114582F0
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96BAE801212
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:39 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-176-4SVpD5ocOsWBveYeM3uRyA-1; Thu, 02 Dec 2021 11:07:34 -0500
X-MC-Unique: 4SVpD5ocOsWBveYeM3uRyA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE1D02177B;
	Thu,  2 Dec 2021 16:07:32 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8526A13E82;
	Thu,  2 Dec 2021 16:07:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id YF9yHkTvqGGnEgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 02 Dec 2021 16:07:32 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  2 Dec 2021 17:06:51 +0100
Message-Id: <20211202160652.4576-12-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B2G7dmg006894
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 10/11] libmultipath.version: drop some unused
	symbols
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Remove some symbols that aren't used any more, and move
symbols "only" used by checkers / prioritizers to their respective
places in the file (this helps assessing which symbols are used).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 941bd8f..7f845ed 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -48,7 +48,6 @@ global:
 	checker_clear_message;
 	checker_disable;
 	checker_enable;
-	checker_is_sync;
 	checker_message;
 	checker_name;
 	checker_state_name;
@@ -209,10 +208,13 @@ global:
 	verify_paths;
 
 	/* checkers */
+	checker_is_sync;
 	sg_read;
+	start_checker_thread;
 
 	/* prioritizers */
 	get_asymmetric_access_state;
+	get_next_string;
 	get_prio_timeout;
 	get_target_port_group;
 	get_target_port_group_support;
@@ -234,7 +236,6 @@ global:
 
 	/* added in 2.1.0 */
 	libmp_dm_task_run;
-	cleanup_mutex;
 
 	/* added in 2.2.0 */
 	libmp_get_multipath_config;
@@ -257,15 +258,10 @@ global:
 	dm_prereq;
 	skip_libmp_dm_init;
 
-	/* added in 4.3.0 */
-	start_checker_thread;
-
 	/* added in 4.4.0 */
-	get_next_string;
 
 	/* added in 4.5.0 */
 	get_vpd_sgio;
-	trigger_partitions_udev_change;
 
 	/* added in 7.0.0 */
 	cleanup_charp;
@@ -276,7 +272,6 @@ global:
 	append_strbuf_str;
 	get_strbuf_len;
 	get_strbuf_str;
-	steal_strbuf_str;
 	fill_strbuf;
 	print_strbuf;
 	truncate_strbuf;
-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

