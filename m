Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED0FC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 14:26:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-nU-DJGDFN6ycEyTlVQbR-Q-1; Fri, 20 May 2022 10:26:34 -0400
X-MC-Unique: nU-DJGDFN6ycEyTlVQbR-Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF1D41C0CE6F;
	Fri, 20 May 2022 14:26:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BC536403152;
	Fri, 20 May 2022 14:26:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 78937194705A;
	Fri, 20 May 2022 14:26:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 95BAB19451EF
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 14:26:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8960C1410DD9; Fri, 20 May 2022 14:26:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 85B471410DD5
 for <dm-devel@redhat.com>; Fri, 20 May 2022 14:26:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E07638C5C55
 for <dm-devel@redhat.com>; Fri, 20 May 2022 14:26:29 +0000 (UTC)
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de
 [85.215.255.80]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-IPeBC8xtPIScHsGukEq7-Q-1; Fri, 20 May 2022 10:26:27 -0400
X-MC-Unique: IPeBC8xtPIScHsGukEq7-Q-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7nOD9sw/xoauycprg5uef7cgCEpy7sPc="
X-RZG-CLASS-ID: mo00
Received: from USER-PC.fritz.box by smtp.strato.de (RZmta 47.42.2 DYNA|AUTH)
 with ESMTPSA id Y03eaey4KEQIQD8
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
 (Client did not present a certificate);
 Fri, 20 May 2022 16:26:18 +0200 (CEST)
From: Thore Sommer <public@thson.de>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com,
 nramas@linux.microsoft.com
Date: Fri, 20 May 2022 16:26:05 +0200
Message-Id: <20220520142605.270625-4-public@thson.de>
In-Reply-To: <20220520142605.270625-1-public@thson.de>
References: <20220520142605.270625-1-public@thson.de>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH 3/3] dm ima: add documentation target update event
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-integrity@vger.kernel.org, Thore Sommer <public@thson.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The dm_target_update event can be triggered by targets to remeasure their
state to reflect that change also in IMA.

This is event is currently only supported by verity.

Signed-off-by: Thore Sommer <public@thson.de>
---
 .../admin-guide/device-mapper/dm-ima.rst      | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-ima.rst b/Documentation/admin-guide/device-mapper/dm-ima.rst
index a4aa50a828e0..ac9418ea99d3 100644
--- a/Documentation/admin-guide/device-mapper/dm-ima.rst
+++ b/Documentation/admin-guide/device-mapper/dm-ima.rst
@@ -93,6 +93,7 @@ Following device state changes will trigger IMA measurements:
  #. Device remove
  #. Table clear
  #. Device rename
+ #. Target update
 
 1. Table load:
 ---------------
@@ -321,6 +322,38 @@ The IMA measurement log has the following format for 'dm_device_rename':
  new_name=linear\=2,new_uuid=1234-5678;
  current_device_capacity=1024;
 
+6. Target update:
+------------------
+When a target changes updates its table it can trigger an remeasurement of that table.
+
+This is currently only implemented for 'verity' targets to detect measure corruption occurrences.
+Note that the active table hash of the device does not get updated.
+
+The IMA measurement log has the following format for 'dm_target_update':
+
+::
+
+ EVENT_NAME := "dm_target_update"
+ EVENT_DATA := <dm_version_str> ";" <device_active_metadata> ";" <target_data_row> ";"
+
+ dm_version_str := As described in the 'Table load' section above.
+ device_active_metadata := Device metadata that reflects the currently loaded active table.
+                           The format is same as 'device_metadata' described in the 'Table load' section above.
+ target_data_row
+ E.g: if a verity device gets corrupted then IMA ASCII measurement log will have an entry with:
+ (converted from ASCII to text for readability)
+
+ 10 1cc9c660afb7fddd1b7167f0c4e997ebca8b1c09 ima-buf sha256:e991f7692724257701c8e652682bd3246837ed2d655407b9e9f5a5b469e6c75b
+ dm_target_update
+ dm_version=4.45.0;
+ name=test,uuid=CRYPT-VERITY-e0d2a85fd61e41238174adaa32d296fe-test,major=253,minor=0,minor_count=1,num_targets=1;
+ target_index=0,target_begin=0,target_len=8,target_name=verity,target_version=1.8.0,hash_failed=C,
+ verity_version=1,data_device_name=7:1,hash_device_name=7:0,verity_algorithm=sha256,
+ root_digest=8c2eff0b45fc9815b94350f7a913683ef34085c734229bcf1345c31b07ac61b8,
+ salt=63010b7c63e28e6929a2f020dc71c97a0660a9f377a83c674a62feb01c5ca6b3,
+ ignore_zero_blocks=n,check_at_most_once=n;
+
+
 Supported targets:
 ==================
 
-- 
2.36.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

