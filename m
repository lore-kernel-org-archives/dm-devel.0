Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C5EAC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 16:10:48 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-klPxbDKhMFOs7qzFBDPEJA-1; Thu, 02 Dec 2021 11:10:43 -0500
X-MC-Unique: klPxbDKhMFOs7qzFBDPEJA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16D631006AA2;
	Thu,  2 Dec 2021 16:10:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F228060622;
	Thu,  2 Dec 2021 16:10:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CE6894A707;
	Thu,  2 Dec 2021 16:10:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2G7Z59006806 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 11:07:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3617E401E56; Thu,  2 Dec 2021 16:07:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32882401E2A
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A4A7106655A
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:35 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-514-kE9M5noFN66H0SCGBGuLqw-1; Thu, 02 Dec 2021 11:07:33 -0500
X-MC-Unique: kE9M5noFN66H0SCGBGuLqw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2E4231FE02;
	Thu,  2 Dec 2021 16:07:32 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E879B13E82;
	Thu,  2 Dec 2021 16:07:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id +NGpNkPvqGGnEgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 02 Dec 2021 16:07:31 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  2 Dec 2021 17:06:49 +0100
Message-Id: <20211202160652.4576-10-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B2G7Z59006806
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 08/11] libmultipath: make
	update_pathvec_from_dm() static
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

This function is called only in structs_vec.c.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 1 -
 libmultipath/structs_vec.c        | 2 +-
 libmultipath/structs_vec.h        | 2 --
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 68db95f..a693933 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -197,7 +197,6 @@ global:
 	update_mpp_paths;
 	update_multipath_strings;
 	update_multipath_table;
-	update_pathvec_from_dm;
 	update_queue_mode_add_path;
 	update_queue_mode_del_path;
 	ux_socket_listen;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 67d3504..cb0ebae 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -99,7 +99,7 @@ static bool guess_mpp_wwid(struct multipath *mpp)
  * - may set pp->wwid and / or mpp->wwid
  * - calls pathinfo() on existing paths is pathinfo_flags is not 0
  */
-bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
+static bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 	int pathinfo_flags)
 {
 	int i, j;
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index fb0e3b4..d33fe98 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -19,8 +19,6 @@ void orphan_path (struct path * pp, const char *reason);
 void set_path_removed(struct path *pp);
 
 int verify_paths(struct multipath *mpp);
-bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
-			    int pathinfo_flags);
 int update_mpp_paths(struct multipath * mpp, vector pathvec);
 int update_multipath_strings (struct multipath *mpp, vector pathvec);
 void extract_hwe_from_path(struct multipath * mpp);
-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

