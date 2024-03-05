Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D825A10F
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 12:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709640381; cv=none; b=Im+XXq5gwVl2/iu8lF/55cPgk4iQsEbxZYJFdO54qywJPfgopQehAxBomzb/Uf6bX/dsVNzm04e98qJg/sy5lrH01EZ5AsPu3JzkaXLoXvW87ELfUg6n7b4FdR3LkeYveq4hMnSgd28kES7E0Q58cKSX85l7UYkks3ownAUj9tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709640381; c=relaxed/simple;
	bh=4WuBZZkdkrzUTOsPWH5mgWOA/0ND9S0xb9dDRZVx40U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCtGK5F374sK/BAmE5TdDMoLa27YJNBTID7zFyxBdwkdmazdQpUsmYzBvtZ9F3LwTqbYvsLUdIGe0heghQHF034dPN+XpfTyu7e7oy3eG8QoaR/8nhLgcQbrnEDLm+l+Ss5OsGFQoV785Xn7q6b2GUahFJHR4ZE9NT3n5sIQCts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bnBdjlTZ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bnBdjlTZ"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-412e84e87e6so10246885e9.2
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 04:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709640378; x=1710245178; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0voxS6ndAZhBFb33yF2RkyYSkNVlLdcUEl396LQqgk4=;
        b=bnBdjlTZLZ1zUpfJs4beSBR5VxQaCjiUCSLk2QjiCUijHgwf8pjJ5EClQVvvu46btM
         E1jWXNS7GF+5hYuqH4pTjfdeNLd8KGxA1O5/MYhgqKx3VzdTyNl2pinpw3x6mmpeDuJm
         6k5/X2AIPt4JDMiiTw2o0ZWEwhNejMmMiuuIP8FO4YVh91H11vWKI8UGnyOTLJfbfO9A
         qsA9npdFxPZVAHafLaqUz0ZmnEeaxmR2MarDJeBPkz8dLCXIUxl+paiqYelYZEWIhbKq
         p72ES0OJQg8aVk9TBklBh2arLBdcyvQqN0DIJUNNDEmLZh8m+6EzqTu7vArTjA67zIrK
         kAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709640378; x=1710245178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0voxS6ndAZhBFb33yF2RkyYSkNVlLdcUEl396LQqgk4=;
        b=oQO0ZLDT7wgIOvYINB1odH26JiiaigFY4lKMqsDgvPmpL8FzzlBv8wKVtCHhGd4raI
         od91/x2HVTloVUxOrV+2T94V5fY4afb2EPeXzMrYlHQyMQBbuJAaZHR6Z2kaD+EdcD3p
         2mVAbS3VhJgcw/d1iaXOBLTZ+CKPAkFGTFueIVr8D4SOTDZsc2iBTCPg1ziOXfV9g+bk
         Paeh+MO6UNyfw2p0Pp8fzdEdW3mR1xRIVbDjxQ+ijNKj4GjeEz7AlC9VPDw00EVWNuUA
         MdKAKKgKWXeq1bRNulTApTVbl+tBijLLeqb9c3c3Y0Xv7lKVdwcwrmgM+2ifXsKTJwyM
         e0Dg==
X-Forwarded-Encrypted: i=1; AJvYcCUf+0J3p1ibX8jsOHHqLdLGKprfcAnD6PwofT0EfARASUrAjH38Do2KEtv+gGjyaoAYqkD1btiK/sO1/C+hrvGndlV7KU5U/eA=
X-Gm-Message-State: AOJu0YybbkCN+XSIdG7/gwsMb/KaDXJ+aj4Q8+YB+MSp5JiIXHrXFA0y
	JZVGQalo0h0LFkSLJhTeu6f041K44mXrLT4fzzAMeeYiFuVrewryOmLdH/bc5iE=
X-Google-Smtp-Source: AGHT+IGEDqwScAiXOsfjPBx2YuOE2F4mbO4yuehbMh7Dl8C8Em2pvwBzMHRcZ36CBWBcMOk1OASefQ==
X-Received: by 2002:a05:600c:1992:b0:411:a5f9:26f5 with SMTP id t18-20020a05600c199200b00411a5f926f5mr9600847wmq.38.1709640377856;
        Tue, 05 Mar 2024 04:06:17 -0800 (PST)
Received: from localhost ([2001:470:6d:10f7:9114:d168:fb53:9a37])
        by smtp.gmail.com with UTF8SMTPSA id g11-20020a05600c4ecb00b00412e293bee9sm6853053wmq.38.2024.03.05.04.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 04:06:17 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Peter Rajnoha <prajnoha@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 7/7] 10-dm.rules: bump DM_UDEV_RULES_VSN to 3
Date: Tue,  5 Mar 2024 13:05:50 +0100
Message-ID: <20240305120550.11617-8-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240305120550.11617-1-mwilck@suse.com>
References: <20240305120550.11617-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bump the rules version in order to indicate that upper level rules
should consume DM_UDEV_DISABLE_OTHER_RULES_FLAG rather than DM_NOSCAN
and DM_SUSPENDED.

Also update the comments at the top of the file that describe the
exported properties, and add a note about internal device-mapper
properties.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 udev/10-dm.rules.in | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/udev/10-dm.rules.in b/udev/10-dm.rules.in
index fccf3bc..0fb2033 100644
--- a/udev/10-dm.rules.in
+++ b/udev/10-dm.rules.in
@@ -12,6 +12,9 @@
 #   DM_NAME - actual DM device's name
 #   DM_UUID - UUID set for DM device (blank if not specified)
 #   DM_UDEV_RULES_VSN - DM udev rules version
+#   DM_UDEV_DISABLE_OTHER_RULES_FLAG - a flag that indicates that
+#      stacked layers shouldn't attempt to probe the device, and
+#      should try to import relevant properties from the udev db.
 #
 # These rules cover only basic device-mapper functionality in udev.
 #
@@ -22,6 +25,11 @@
 #   11-dm-lvm.rules for LVM subsystem
 #   11-dm-mpath.rules for multipath subsystem (since version 0.6.0, recommended!)
 #
+# 11-dm<subsystem_name>.rules may use other DM related properties besides
+# those listed above, like .DM_SUSPENDED. These properties are considered
+# internal to device mapper, and subject to change without notice.
+# Rules that are executed after 13-dm-disk.rules shouldn't use them.
+#
 # Even more specific rules may be required by subsystems so always
 # check subsystem's upstream repository for recent set of rules.
 # Also, keep in mind that recent rules may also require recent
@@ -139,7 +147,9 @@ LABEL="dm_suspended_set"
 # possible future changes.
 # VSN 1 - original rules
 # VSN 2 - add support for synthesized events
-ENV{DM_UDEV_RULES_VSN}="2"
+# VSN 3 - use DM_UDEV_DISABLE_OTHER_RULES_FLAG as the only "API"
+#         to be consumed by non-dm rules.
+ENV{DM_UDEV_RULES_VSN}="3"
 
 ENV{DM_UDEV_DISABLE_DM_RULES_FLAG}!="1", ENV{DM_NAME}=="?*", SYMLINK+="(DM_DIR)/$env{DM_NAME}"
 
-- 
2.43.2

