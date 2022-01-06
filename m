Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2FAEC433FE
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 16:44:04 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-ylS4ULN-NgiC8B2lG-AJCg-1; Thu, 06 Jan 2022 11:44:02 -0500
X-MC-Unique: ylS4ULN-NgiC8B2lG-AJCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D57F9190A7A0;
	Thu,  6 Jan 2022 16:43:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56E2C838D0;
	Thu,  6 Jan 2022 16:43:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 049481809CB8;
	Thu,  6 Jan 2022 16:43:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 206Ghrvq005219 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 11:43:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EE0BE1121334; Thu,  6 Jan 2022 16:43:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9D581121314
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 16:43:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2048D85A5B9
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 16:43:50 +0000 (UTC)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
	[85.215.255.21]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-633-vU5uFGkCOWeaARGepq8v5g-1; Thu, 06 Jan 2022 11:43:47 -0500
X-MC-Unique: vU5uFGkCOWeaARGepq8v5g-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7nOD9sw/xoauycprg5uef7cgCEpy7sPc="
X-RZG-CLASS-ID: mo00
Received: from USER-PC.fritz.box by smtp.strato.de (RZmta 47.37.4 DYNA|AUTH)
	with ESMTPSA id u2923ay06Gbe8Gt
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
	Thu, 6 Jan 2022 17:37:40 +0100 (CET)
From: Thore Sommer <public@thson.de>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Thu,  6 Jan 2022 17:37:31 +0100
Message-Id: <20220106163731.165391-1-public@thson.de>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, Thore Sommer <public@thson.de>,
	linux-doc@vger.kernel.org
Subject: [dm-devel] [PATCH] dm ima: updates to grammar and some details in
	documentation
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

The grammar for the events dm_device_remove, device_resume and
dm_table_clear did not include the no_data entry when device data
and hash are missing.

For the device uuid or name "=" is also escaped with a "\".

Add a note that dm_table_load might split its target measurements over
multiple IMA events.

Signed-off-by: Thore Sommer <public@thson.de>
---
 .../admin-guide/device-mapper/dm-ima.rst      | 26 ++++++++++++++-----
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-ima.rst b/Documentation/admin-guide/device-mapper/dm-ima.rst
index a4aa50a828e0..fb6e4148b426 100644
--- a/Documentation/admin-guide/device-mapper/dm-ima.rst
+++ b/Documentation/admin-guide/device-mapper/dm-ima.rst
@@ -100,6 +100,9 @@ When a new table is loaded in a device's inactive table slot,
 the device information and target specific details from the
 targets in the table are measured.
 
+Note that if there are too many targets to measure at once multiple IMA
+measurements will be generated.
+
 The IMA measurement log has the following format for 'dm_table_load':
 
 ::
@@ -118,9 +121,9 @@ The IMA measurement log has the following format for 'dm_table_load':
  device_minor := "minor=" <N>
  minor_count := "minor_count=" <N>
  num_device_targets := "num_targets=" <N>
- dm-device-name := Name of the device. If it contains special characters like '\', ',', ';',
+ dm-device-name := Name of the device. If it contains special characters like '\', ',', ';',"=",
                    they are prefixed with '\'.
- dm-device-uuid := UUID of the device. If it contains special characters like '\', ',', ';',
+ dm-device-uuid := UUID of the device. If it contains special characters like '\', ',', ';',"=",
                    they are prefixed with '\'.
 
  table_load_data := <target_data>
@@ -175,8 +178,9 @@ The IMA measurement log has the following format for 'dm_device_resume':
 ::
 
  EVENT_NAME := "dm_device_resume"
- EVENT_DATA := <dm_version_str> ";" <device_metadata> ";" <active_table_hash> ";" <current_device_capacity> ";"
+ EVENT_DATA := <dm_version_str> ";" device_data ";" <current_device_capacity> ";"
 
+ device_data := <device_metadata> ";" <active_table_hash> | device_resume_no_data
  dm_version_str := As described in the 'Table load' section above.
  device_metadata := As described in the 'Table load' section above.
  active_table_hash := "active_table_hash=" <table_hash_alg> ":" <table_hash>
@@ -189,6 +193,9 @@ The IMA measurement log has the following format for 'dm_device_resume':
                events for a given device, the hash is computed combining all the event data
                i.e. (<dm_version_str> ";" <device_metadata> ";" <table_load_data> ";")
                across all those events.
+ device_resume_no_data := "device_resume=no_data"
+                           If device metadata and hash for the active table do not exists this value gets measured.
+                           Note: the hash should always exist if the device metadata is present.
  current_device_capacity := "current_device_capacity=" <N>
 
  For instance, if a linear device is resumed with the following command,
@@ -213,10 +220,10 @@ The IMA measurement log has the following format for 'dm_device_remove':
 ::
 
  EVENT_NAME := "dm_device_remove"
- EVENT_DATA := <dm_version_str> ";" <device_active_metadata> ";" <device_inactive_metadata> ";"
-               <active_table_hash> "," <inactive_table_hash> "," <remove_all> ";" <current_device_capacity> ";"
+ EVENT_DATA := <dm_version_str> ";" <device_data> <remove_all> ";" <current_device_capacity> ";"
 
  dm_version_str := As described in the 'Table load' section above.
+ device_data := <device_active_metadata> ";" <device_inactive_metadata> ";" <active_table_hash> "," <inactive_table_hash> "," | <device_remove_no_data> ";"
  device_active_metadata := Device metadata that reflects the currently loaded active table.
                            The format is same as 'device_metadata' described in the 'Table load' section above.
  device_inactive_metadata := Device metadata that reflects the inactive table.
@@ -225,6 +232,9 @@ The IMA measurement log has the following format for 'dm_device_remove':
                       The format is same as 'active_table_hash' described in the 'Device resume' section above.
  inactive_table_hash :=  Hash of the inactive table.
                          The format is same as 'active_table_hash' described in the 'Device resume' section above.
+ device_remove_no_data := "device_remove=no_data"
+                          If device metadata and hash for the active and inactive table do not exists this value gets measured.
+                          Note: the hash should always exist if the device metadata is present.
  remove_all := "remove_all=" <yes_no>
  yes_no := "y" | "n"
  current_device_capacity := "current_device_capacity=" <N>
@@ -254,9 +264,13 @@ The IMA measurement log has the following format for 'dm_table_clear':
 ::
 
  EVENT_NAME := "dm_table_clear"
- EVENT_DATA := <dm_version_str> ";" <device_inactive_metadata> ";" <inactive_table_hash> ";" <current_device_capacity> ";"
+ EVENT_DATA := <dm_version_str> ";" <device_data> ";" <current_device_capacity> ";"
 
  dm_version_str := As described in the 'Table load' section above.
+ device_data := <device_inactive_metadata> ";" <inactive_table_hash> | <table_clear_no_data>
+ table_clear_no_data := "table_clear=no_data"
+                        If device metadata and hash for the inactive table do not exists this value gets measured.
+                        Note: the hash should always exist if the device metadata is present.
  device_inactive_metadata := Device metadata that was captured during the load time inactive table being cleared.
                              The format is same as 'device_metadata' described in the 'Table load' section above.
  inactive_table_hash := Hash of the inactive table being cleared from the device.
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

