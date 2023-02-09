Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A498C636D6
	for <dm-devel@archiver.kernel.org>; Thu,  9 Feb 2023 17:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675963723;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3Jl3xhscjMgrSr1Q8ove4qSW2Aagi4ABKiQ4JAgVl/k=;
	b=VVm/bHkYSQUS/LcVP2/5LyTz6GZAK+x2NKETjA1Uoj8ENFhFlnBZvm52N88AqFSFHil19T
	RVdX2/41jI6zXyQRlqO97GZBDmJ7MWtT7jut5LcWd+vJHd2yakDTrZ5wxlNU3YEkgIqPdE
	8urEqOpwDnGIPluycLZrWsa//9Hx5Uk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-XN3BzqS4OnGNolkt55LjDw-1; Thu, 09 Feb 2023 12:28:39 -0500
X-MC-Unique: XN3BzqS4OnGNolkt55LjDw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEAE73823A03;
	Thu,  9 Feb 2023 17:28:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 907F7140EBF6;
	Thu,  9 Feb 2023 17:28:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 70168194658D;
	Thu,  9 Feb 2023 17:28:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8A9B71946589
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Feb 2023 17:28:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6913CC16024; Thu,  9 Feb 2023 17:28:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 44C01C16023;
 Thu,  9 Feb 2023 17:28:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 319HSWCL022762;
 Thu, 9 Feb 2023 11:28:32 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 319HSWgF022761;
 Thu, 9 Feb 2023 11:28:32 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu,  9 Feb 2023 11:28:31 -0600
Message-Id: <1675963711-22722-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH] libmultipath: limit paths that can get wwid from
 environment
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently, whenever getting the uid_attribute from the udev database
fails, multipath will try to get it from the environment variables. This
normally isn't a problem, since either multipath -u is getting called
from a uevent and the environment will have the correct value in that
variable, or something else is being run and that variable won't be set.
However, when find_multipaths is configured to "smart", this causes
problems. For maybe devices, multipath needs to get the WWIDs of all the
other block devices, to see if they match the maybe device wwid.  If one
of those devices doesn't have uid_attribute set in its udev database,
multipath will fall back to checking the environment for it, and it will
find that variable set to the WWID of the maybe device that this uevent
is for.  This means that all devices with no WWID will end up appearing
to have the same WWID as the maybe device, causing multipath to
incorrectly claim it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 2 +-
 libmultipath/structs.h   | 1 +
 multipath/main.c         | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 67ac0e6d..3a5ba173 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2093,7 +2093,7 @@ get_udev_uid(struct path * pp, const char *uid_attribute, struct udev_device *ud
 	const char *value;
 
 	value = udev_device_get_property_value(udev, uid_attribute);
-	if (!value || strlen(value) == 0)
+	if ((!value || strlen(value) == 0) && pp->can_use_env_uid)
 		value = getenv(uid_attribute);
 	if (value && strlen(value)) {
 		len = strlcpy(pp->wwid, value, WWID_SIZE);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index e2294323..a1208751 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -368,6 +368,7 @@ struct path {
 	unsigned int dev_loss;
 	int eh_deadline;
 	bool is_checked;
+	bool can_use_env_uid;
 	/* configlet pointers */
 	vector hwe;
 	struct gen_path generic_path;
diff --git a/multipath/main.c b/multipath/main.c
index b9f360b4..90f940f1 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -607,6 +607,8 @@ check_path_valid(const char *name, struct config *conf, bool is_uevent)
 	pp = alloc_path();
 	if (!pp)
 		return RTVL_FAIL;
+	if (is_uevent)
+		pp->can_use_env_uid = true;
 
 	r = is_path_valid(name, conf, pp, is_uevent);
 	if (r <= PATH_IS_ERROR || r >= PATH_MAX_VALID_RESULT)
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

