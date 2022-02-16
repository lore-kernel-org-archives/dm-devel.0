Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6515DC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 21:02:19 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-1SdybzjiOZyfyBFDtykSIg-1; Wed, 16 Feb 2022 16:02:14 -0500
X-MC-Unique: 1SdybzjiOZyfyBFDtykSIg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AB531091DA1;
	Wed, 16 Feb 2022 21:02:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E10B8452FA;
	Wed, 16 Feb 2022 21:02:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B0CD4BB7C;
	Wed, 16 Feb 2022 21:02:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21GKxcW6023991 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Feb 2022 15:59:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AE6EC5361F5; Wed, 16 Feb 2022 20:59:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB1755361EC
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 20:59:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91BE680120D
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 20:59:38 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-515-gnYr3shENKKN6PuItK-Dzw-1; Wed, 16 Feb 2022 15:59:37 -0500
X-MC-Unique: gnYr3shENKKN6PuItK-Dzw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC63721135;
	Wed, 16 Feb 2022 20:59:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 463E613B31;
	Wed, 16 Feb 2022 20:59:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id nR5vDrdlDWIWOwAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 16 Feb 2022 20:59:35 +0000
From: mwilck@suse.com
To: Jes Sorensen <jsorensen@fb.com>, linux-raid@vger.kernel.org
Date: Wed, 16 Feb 2022 21:59:14 +0100
Message-Id: <20220216205914.7575-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21GKxcW6023991
X-loop: dm-devel@redhat.com
Cc: Coly Li <colyli@suse.com>, Peter Rajnoha <prajnoha@redhat.com>,
	lvm-devel@redhat.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>,
	Heming Zhao <heming.zhao@suse.com>
Subject: [dm-devel] [PATCH] udev-md-raid-assembly.rules: skip if
	DM_UDEV_DISABLE_OTHER_RULES_FLAG
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

device-mapper sets the flag DM_UDEV_DISABLE_OTHER_RULES_FLAG to 1 for
devices which are unusable. They may be no set up yet, suspended, or
otherwise unusable (e.g. multipath maps without usable path). This
flag does not necessarily imply SYSTEMD_READY=0 and must therefore
be tested separately.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 udev-md-raid-assembly.rules | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index d668cdd..4568b01 100644
--- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -21,6 +21,11 @@ IMPORT{cmdline}="noiswmd"
 IMPORT{cmdline}="nodmraid"
 
 ENV{nodmraid}=="?*", GOTO="md_inc_end"
+
+# device mapper sets DM_UDEV_DISABLE_OTHER_RULES_FLAG for devices which
+# aren't ready to use
+KERNEL=="dm-*", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="md_inc_end"
+
 ENV{ID_FS_TYPE}=="ddf_raid_member", GOTO="md_inc"
 ENV{noiswmd}=="?*", GOTO="md_inc_end"
 ENV{ID_FS_TYPE}=="isw_raid_member", ACTION!="change", GOTO="md_inc"
-- 
2.35.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

