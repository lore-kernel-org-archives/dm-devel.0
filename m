Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA71C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 16:08:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-Uf-U7FTRPvGObO8QI4R8Rw-1; Thu, 02 Dec 2021 11:08:48 -0500
X-MC-Unique: Uf-U7FTRPvGObO8QI4R8Rw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F18D83DD20;
	Thu,  2 Dec 2021 16:08:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56B1F5D9D5;
	Thu,  2 Dec 2021 16:08:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 338221809C8A;
	Thu,  2 Dec 2021 16:08:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2G7aPw006839 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 11:07:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 866FE401E2A; Thu,  2 Dec 2021 16:07:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82AE7401E5F
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B589185A7B2
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:36 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-238-J3QU93kXOm6s2_TZc_8ctw-1; Thu, 02 Dec 2021 11:07:33 -0500
X-MC-Unique: J3QU93kXOm6s2_TZc_8ctw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 91FFA218A9;
	Thu,  2 Dec 2021 16:07:31 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 59EB013E82;
	Thu,  2 Dec 2021 16:07:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id yFjVE0PvqGGnEgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 02 Dec 2021 16:07:31 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  2 Dec 2021 17:06:47 +0100
Message-Id: <20211202160652.4576-8-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B2G7aPw006839
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 06/11] multipath-tools: .mailmap: add some more
	entries
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .mailmap | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/.mailmap b/.mailmap
index 2c04cb0..14996ab 100644
--- a/.mailmap
+++ b/.mailmap
@@ -9,9 +9,13 @@
 #
 # Please keep this list dictionary sorted.
 #
+Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
+Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
 Benjamin Marzinski <bmarzins@redhat.com> <bmarzin@redhat.com>
 Benjamin Marzinski <bmarzins@redhat.com> <bmarzins@sourceware.org>
 Benjamin Marzinski <bmarzins@redhat.com> bmarzins@sourceware.org <bmarzins@sourceware.org>
+Chongyun Wu <wucy11@chinatelecom.cn> Wuchongyun <wu.chongyun@h3c.com>
+Chongyun Wu <wucy11@chinatelecom.cn> <wu.chongyun@h3c.com>
 Christophe Varoqui <christophe.varoqui@opensvc.com> <christophe.varoqui@free.fr>
 Christophe Varoqui <christophe.varoqui@opensvc.com> <cvaroqui@cl039.(none)>
 Christophe Varoqui <christophe.varoqui@opensvc.com> <cvaroqui@hera.kernel.org>
@@ -20,5 +24,8 @@ Christophe Varoqui <christophe.varoqui@opensvc.com> root <root@potab.(none)>
 Christophe Varoqui <christophe.varoqui@opensvc.com> root <root@xa-s05.(none)>
 Christophe Varoqui <christophe.varoqui@opensvc.com> root <root@zezette.localdomain>
 Christophe Varoqui <christophe.varoqui@opensvc.com> <root@xa-s05.(none)>
+Hannes Reinecke <hare@suse.de> <hare@acerbis.suse.de>
+Hannes Reinecke <hare@suse.de> <hare@suse.com>
 Martin Wilck <mwilck@suse.com> <Martin.Wilck@suse.com>
 Martin Wilck <mwilck@suse.com> <mwilck@suse.de>
+wei huang <huang.wei56@zte.com.cn> wei.huang <huang.wei56@zte.com.cn>
-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

