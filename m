Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEB6DC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 12 Jan 2022 16:51:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-sxtNRIm3PaSEOBcY1433UQ-1; Wed, 12 Jan 2022 11:51:49 -0500
X-MC-Unique: sxtNRIm3PaSEOBcY1433UQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5923A18A08D6;
	Wed, 12 Jan 2022 16:51:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C524E34D50;
	Wed, 12 Jan 2022 16:51:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1B7F04CA93;
	Wed, 12 Jan 2022 16:51:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20CGpfh3030018 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 Jan 2022 11:51:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E6E5C1400E73; Wed, 12 Jan 2022 16:51:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2AF8140EBFD
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 16:51:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C919C805B25
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 16:51:40 +0000 (UTC)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
	[85.215.255.24]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-7-vCSCKbDsMwCNNy20kbyyWg-1; Wed, 12 Jan 2022 11:51:38 -0500
X-MC-Unique: vCSCKbDsMwCNNy20kbyyWg-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7nOD9sw/xoauycprg5uef7cgCEpy7sPc="
X-RZG-CLASS-ID: mo00
Received: from USER-PC.fritz.box by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
	with ESMTPSA id k3f463y0CGpTRQi
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
	Wed, 12 Jan 2022 17:51:29 +0100 (CET)
From: Thore Sommer <public@thson.de>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Wed, 12 Jan 2022 17:51:17 +0100
Message-Id: <20220112165117.2030908-1-public@thson.de>
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
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, Thore Sommer <public@thson.de>,
	linux-doc@vger.kernel.org
Subject: [dm-devel] [PATCH v3] dm ima: updates to grammar and some details
	in documentation
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
v3: fixed missing spaces
v2:
- include also device name and uuid in grammar for no_data
- fixed spelling mistakes

 .../admin-guide/device-mapper/dm-ima.rst      | 32 +++++++++++++++----
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-ima.rst b/Documentation/admin-guide/device-mapper/dm-ima.rst
index a4aa50a828e0..b9f80c543350 100644
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
+ dm-device-name := Name of the device. If it contains special characters like '\', ',', ';', '=',
                    they are prefixed with '\'.
- dm-device-uuid := UUID of the device. If it contains special characters like '\', ',', ';',
+ dm-device-uuid := UUID of the device. If it contains special characters like '\', ',', ';', '=',
                    they are prefixed with '\'.
 
  table_load_data := <target_data>
@@ -175,8 +178,9 @@ The IMA measurement log has the following format for 'dm_device_resume':
 ::
 
  EVENT_NAME := "dm_device_resume"
- EVENT_DATA := <dm_version_str> ";" <device_metadata> ";" <active_table_hash> ";" <current_device_capacity> ";"
+ EVENT_DATA := <dm_version_str> ";" <device_data> ";" <current_device_capacity> ";"
 
+ device_data := <device_metadata> ";" <active_table_hash> | <device_resume_no_data>
  dm_version_str := As described in the 'Table load' section above.
  device_metadata := As described in the 'Table load' section above.
  active_table_hash := "active_table_hash=" <table_hash_alg> ":" <table_hash>
@@ -189,6 +193,11 @@ The IMA measurement log has the following format for 'dm_device_resume':
                events for a given device, the hash is computed combining all the event data
                i.e. (<dm_version_str> ";" <device_metadata> ";" <table_load_data> ";")
                across all those events.
+ device_resume_no_data := <device_name> "," <device_uuid> ";" "device_resume=no_data"
+                           If device metadata and hash for the active table do not exists, this value gets measured.
+                           Note: the hash should always exist if the device metadata is present.
+ device_name := As described in the 'Table load' section above.
+ device_uuid := As described in the 'Table load' section above.
  current_device_capacity := "current_device_capacity=" <N>
 
  For instance, if a linear device is resumed with the following command,
@@ -213,10 +222,10 @@ The IMA measurement log has the following format for 'dm_device_remove':
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
@@ -225,6 +234,11 @@ The IMA measurement log has the following format for 'dm_device_remove':
                       The format is same as 'active_table_hash' described in the 'Device resume' section above.
  inactive_table_hash :=  Hash of the inactive table.
                          The format is same as 'active_table_hash' described in the 'Device resume' section above.
+ device_remove_no_data := <device_name> "," <device_uuid> ";" "device_remove=no_data"
+                          If device metadata and hash for the active and inactive table do not exists, this value gets measured.
+                          Note: the hash should always exist if the device metadata is present.
+ device_name := As described in the 'Table load' section above.
+ device_uuid := As described in the 'Table load' section above.
  remove_all := "remove_all=" <yes_no>
  yes_no := "y" | "n"
  current_device_capacity := "current_device_capacity=" <N>
@@ -254,9 +268,15 @@ The IMA measurement log has the following format for 'dm_table_clear':
 ::
 
  EVENT_NAME := "dm_table_clear"
- EVENT_DATA := <dm_version_str> ";" <device_inactive_metadata> ";" <inactive_table_hash> ";" <current_device_capacity> ";"
+ EVENT_DATA := <dm_version_str> ";" <device_data> ";" <current_device_capacity> ";"
 
  dm_version_str := As described in the 'Table load' section above.
+ device_data := <device_inactive_metadata> ";" <inactive_table_hash> | <table_clear_no_data>
+ table_clear_no_data := <device_name> "," <device_uuid> ";" "table_clear=no_data"
+                        If device metadata and hash for the inactive table do not exists, this value gets measured.
+                        Note: the hash should always exist if the device metadata is present.
+ device_name := As described in the 'Table load' section above.
+ device_uuid := As described in the 'Table load' section above.
  device_inactive_metadata := Device metadata that was captured during the load time inactive table being cleared.
                              The format is same as 'device_metadata' described in the 'Table load' section above.
  inactive_table_hash := Hash of the inactive table being cleared from the device.
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

