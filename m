Return-Path: <SRS0=J1Yh=NE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB67C4320A
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:38:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D2FC60EE4
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:38:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0D2FC60EE4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-uttCcuc7O2Chelhwi0Ajtg-1; Fri, 13 Aug 2021 17:38:40 -0400
X-MC-Unique: uttCcuc7O2Chelhwi0Ajtg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7469F1082924;
	Fri, 13 Aug 2021 21:38:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 500F5282DC;
	Fri, 13 Aug 2021 21:38:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CD97C181A0F2;
	Fri, 13 Aug 2021 21:38:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17DLcK7k015536 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 13 Aug 2021 17:38:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EA114205B065; Fri, 13 Aug 2021 21:38:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E497921623A9
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBDEC802700
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:16 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-303-L4iiGYQyPR-uxsn9hSOmuA-1;
	Fri, 13 Aug 2021 17:38:13 -0400
X-MC-Unique: L4iiGYQyPR-uxsn9hSOmuA-1
Received: from Lenovo-Legion-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6C91520C2935;
	Fri, 13 Aug 2021 14:38:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6C91520C2935
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Fri, 13 Aug 2021 14:38:00 -0700
Message-Id: <20210813213801.297051-6-tusharsu@linux.microsoft.com>
In-Reply-To: <20210813213801.297051-1-tusharsu@linux.microsoft.com>
References: <20210813213801.297051-1-tusharsu@linux.microsoft.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17DLcK7k015536
X-loop: dm-devel@redhat.com
Cc: sfr@canb.auug.org.au, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	public@thson.de, tusharsu@linux.microsoft.com,
	linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH 5/6] dm ima: update dm target attributes for ima
	measurements
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

Certain DM targets ('integrity', 'multipath', 'verity') need to update the
way their attributes are recorded in the ima log, so that the attestation
servers can interpret the data correctly and decide if the devices
meet the attestation requirements.  For instance, the "mode=%c" attribute
in the 'integrity' target is measured twice, the 'verity' target is
missing the attribute "root_hash_sig_key_desc=%s", and the 'multipath'
target needs to index the attributes properly.

Update 'integrity' target to remove the duplicate measurement of
the attribute "mode=%c".  Add "root_hash_sig_key_desc=%s" attribute
for the 'verity' target.  Index various attributes in 'multipath'
target.  Also, add "nr_priority_groups=%u" attribute to 'multipath'
target to record the number of priority groups.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Suggested-by: Thore Sommer <public@thson.de>
---
 drivers/md/dm-integrity.c     |  1 -
 drivers/md/dm-mpath.c         | 26 ++++++++++++++++++--------
 drivers/md/dm-verity-target.c |  2 ++
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 40f8116c8e44..6e0b2f2f5911 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3328,7 +3328,6 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 		DMEMIT(",journal_sectors=%u", ic->initial_sectors - SB_SECTORS);
 		DMEMIT(",interleave_sectors=%u", 1U << ic->sb->log2_interleave_sectors);
 		DMEMIT(",buffer_sectors=%u", 1U << ic->log2_buffer_sectors);
-		DMEMIT(",mode=%c", ic->mode);
 		DMEMIT(";");
 		break;
 	}
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c3c514a9edbb..694aaca4eea2 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1790,7 +1790,7 @@ static void multipath_resume(struct dm_target *ti)
 static void multipath_status(struct dm_target *ti, status_type_t type,
 			     unsigned status_flags, char *result, unsigned maxlen)
 {
-	int sz = 0;
+	int sz = 0, pg_counter, pgpath_counter;
 	unsigned long flags;
 	struct multipath *m = ti->private;
 	struct priority_group *pg;
@@ -1906,7 +1906,12 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 		break;
 
 	case STATUSTYPE_IMA:
+		sz = 0; /*reset the result pointer*/
+
 		DMEMIT_TARGET_NAME_VERSION(ti->type);
+		DMEMIT(",nr_priority_groups=%u", m->nr_priority_groups);
+
+		pg_counter = 0;
 		list_for_each_entry(pg, &m->priority_groups, list) {
 			if (pg->bypassed)
 				state = 'D';	/* Disabled */
@@ -1914,21 +1919,26 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 				state = 'A';	/* Currently Active */
 			else
 				state = 'E';	/* Enabled */
-			DMEMIT(",pg_state=%c", state);
-			DMEMIT(",nr_pgpaths=%u", pg->nr_pgpaths);
-			DMEMIT(",path_selector_name=%s", pg->ps.type->name);
+			DMEMIT(",pg_state_%d=%c", pg_counter, state);
+			DMEMIT(",nr_pgpaths_%d=%u", pg_counter, pg->nr_pgpaths);
+			DMEMIT(",path_selector_name_%d=%s", pg_counter, pg->ps.type->name);
 
+			pgpath_counter = 0;
 			list_for_each_entry(p, &pg->pgpaths, list) {
-				DMEMIT(",path_name=%s,is_active=%c,fail_count=%u",
-				       p->path.dev->name, p->is_active ? 'A' : 'F',
-				       p->fail_count);
+				DMEMIT(",path_name_%d_%d=%s,is_active_%d_%d=%c,fail_count_%d_%d=%u",
+				       pg_counter, pgpath_counter, p->path.dev->name,
+				       pg_counter, pgpath_counter, p->is_active ? 'A' : 'F',
+				       pg_counter, pgpath_counter, p->fail_count);
 				if (pg->ps.type->status) {
-					DMEMIT(",path_selector_status=");
+					DMEMIT(",path_selector_status_%d_%d=",
+					       pg_counter, pgpath_counter);
 					sz += pg->ps.type->status(&pg->ps, &p->path,
 								  type, result + sz,
 								  maxlen - sz);
 				}
+				pgpath_counter++;
 			}
+			pg_counter++;
 		}
 		DMEMIT(";");
 		break;
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bfefa100c265..22a5ac82446a 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -794,6 +794,8 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 
 		DMEMIT(",ignore_zero_blocks=%c", v->zero_digest ? 'y' : 'n');
 		DMEMIT(",check_at_most_once=%c", v->validated_blocks ? 'y' : 'n');
+		if (v->signature_key_desc)
+			DMEMIT(",root_hash_sig_key_desc=%s", v->signature_key_desc);
 
 		if (v->mode != DM_VERITY_MODE_EIO) {
 			DMEMIT(",verity_mode=");
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

