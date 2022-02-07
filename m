Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E87C3527C
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:34:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-Dpkf1vnnNaSvAjUV1_qnAQ-1; Tue, 08 Feb 2022 17:34:09 -0500
X-MC-Unique: Dpkf1vnnNaSvAjUV1_qnAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEDCB1853035;
	Tue,  8 Feb 2022 22:34:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBCB379445;
	Tue,  8 Feb 2022 22:34:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A2A901832B62;
	Tue,  8 Feb 2022 22:34:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217HIZ61025120 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 12:18:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7522B2166B4D; Mon,  7 Feb 2022 17:18:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 703A72166B4C
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 17:18:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D75EB1C05AB5
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 17:18:31 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-607-1v0AtpGHMl2njz6yzNCbSw-1; Mon, 07 Feb 2022 12:18:28 -0500
X-MC-Unique: 1v0AtpGHMl2njz6yzNCbSw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA3391F37E;
	Mon,  7 Feb 2022 17:18:26 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69F5213C61;
	Mon,  7 Feb 2022 17:18:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 0+PjF2JUAWJfHAAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 07 Feb 2022 17:18:26 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon,  7 Feb 2022 18:18:19 +0100
Message-Id: <20220207171819.7091-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 217HIZ61025120
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH] kpartx.rules: skip MD devices
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

With the mdadm metadata format v1.0 (and DDF), the MD superblock is at the end
of the device, keeping the partition table at the beginning. This may cause
wrong partition mappings to be created by kpartx on RAID component devices.

So far I've only seen ugly error messages, but at least in principle it can
happen that kpartx wins a race with MD, and prevents correct setup of the
MD device.

Sample error messages:

[    4.029490] systemd-udevd[445]: dm-0: '/sbin/kpartx -un -p -part /dev/dm-0'(err) 'device-mapper: reload ioctl on 3600140508dbcf02acb448188d73ec97d-part1  failed: Device or resource busy'
[    4.075666] kernel: device-mapper: table: 254:1: linear: Device lookup failed
[    4.075945] kernel: device-mapper: ioctl: error adding target to table

Skip creating partition mappings on MD components.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.rules | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index d7527d7..1969dee 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -12,6 +12,9 @@ ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="kpartx_end"
 # Create dm tables for partitions on multipath devices.
 ENV{DM_UUID}!="mpath-?*", GOTO="mpath_kpartx_end"
 
+# Ignore RAID members
+ENV{ID_FS_TYPE}=="linux_raid_member|isw_raid_member|ddf_raid_member", GOTO="mpath_kpartx_end"
+
 # DM_SUBSYSTEM_UDEV_FLAG1 is the "skip_kpartx" flag.
 # For events not generated by libdevmapper, we need to fetch it from db:
 # - "change" events with DM_ACTIVATION!="1" (e.g. partition table changes)
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

