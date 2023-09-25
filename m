Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B11DCD4857
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 18:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695666976;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IinxxaUcyhKvBpJlhfXVbCTOUvJMC+MRy+23YQuLh9A=;
	b=G0FAYgW6Hpt2GjuXlCyxE64Z3ZCxuNmyelGtKOMeTMUmCrXq8neD1gaDfrbRv6vIGJFBHy
	dTDz95VqFVYIKvc86ob7kkFauJ1k9mIzhBmxwMB00GbFNxly8HD2IpXWEM74DUkFEKQdQO
	IogR3byWZf8wq1cBebI4g4frgArb1nI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-3fhFBO53NaOLwgYwJ6hCBA-1; Mon, 25 Sep 2023 14:36:13 -0400
X-MC-Unique: 3fhFBO53NaOLwgYwJ6hCBA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D2153C23FCB;
	Mon, 25 Sep 2023 18:36:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 36E887B62;
	Mon, 25 Sep 2023 18:36:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0A3F919465A3;
	Mon, 25 Sep 2023 18:36:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6FDEF194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 06:13:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E125711294; Mon, 25 Sep 2023 06:13:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36F97711291
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 06:13:16 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A25685A5BF
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 06:13:16 +0000 (UTC)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-P7XYPIxqNZOZLDIMleM8Qw-1; Mon, 25 Sep 2023 02:13:13 -0400
X-MC-Unique: P7XYPIxqNZOZLDIMleM8Qw-1
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-594e1154756so110904877b3.2
 for <dm-devel@redhat.com>; Sun, 24 Sep 2023 23:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695622393; x=1696227193;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=ycLbAEGjG2OMuy7bZZ7q2QOiJ4YnfeodCoeJEwU0Jy0=;
 b=h1Cz1AjfAkesSPBc/pAzHpxAZaDnNu6b93TW0lxTQMJasVDsmy3iCRV4crOYh1LlIn
 ycPWI6ruqvdbfT5r+ANRKplfLYaq6IperdasbixMQUJm5w4lf5QDofh1RY8lN+STPQiO
 u9yRIXqOtMGe2bh5ZxMGhvfNipJmXvqT5I+NZ141zLe6CwRmPeCnUu0QUCK+S8JMp89/
 0o2GvlK8bTL6KE1EPuqCNztmegLp/AZOfc0m3qWp+K32DT9ORDBSKRfBDmh5FnK5DdW3
 5kKH18i60h2xA2YhTXp25+D81+RDLhDCyKtooKHoIpZ8TE7ZAsXr0CO3ROtO15GR+mHL
 ObUA==
X-Gm-Message-State: AOJu0YzaQK0iuK4O2+0HCW+2TyTRKRsvB7a5qBZgrud4/p5dJCVPXvBA
 RmOm7D6yTfN6mYglDNStJvsNrIea2mh5BKRilw==
X-Google-Smtp-Source: AGHT+IHmy3ncfol/vhb3VkS3Sr/f9jVGajGoTvPFAixf96EbbJPo5Lv4/55OBM836+Q51hnkLnTJ2pEswZHgOcDVaw==
X-Received: from jstitt-linux1.c.googlers.com
 ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a81:4525:0:b0:59b:e1db:5633 with SMTP
 id s37-20020a814525000000b0059be1db5633mr62368ywa.1.1695622393329; Sun, 24
 Sep 2023 23:13:13 -0700 (PDT)
Date: Mon, 25 Sep 2023 06:13:12 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAPckEWUC/x3NwQrCMAyA4VcZORuoHVPnq4iHkGQuh9aRljEZe
 /cVj9/l/3co6qYFnt0OrqsV++aG66UDnil/FE2aIYbYhzEOWKpnXn4obqt6wSQoCZl4VkxaSag
 SMk738AjjTQaJEVpscZ1s+49e7+M4AWGjYUx4AAAA
X-Developer-Key: i=justinstitt@google.com; a=ed25519;
 pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1695622392; l=3897;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=L9/fdUPf3xhTtPuNBdXSMdi4yA/i8QBeE3Azuo4x1V4=;
 b=s7K9oW+wn0ijUhrySteAlkbaAM8X5C4rkp3jki9seVEy0xY+hLk287rA8MGz9tW8TbMwZetUm
 /4fAXWdPvzQAg+tYrQ200y/X9gvS7KkXrTc3YzrqfbEeKZlVPYYe+Tj
Message-ID: <20230925-strncpy-drivers-md-dm-cache-metadata-c-v1-1-4b75c7db0cfe@google.com>
From: Justin Stitt <justinstitt@google.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 25 Sep 2023 18:36:03 +0000
Subject: [dm-devel] [PATCH] dm cache metadata: replace deprecated strncpy
 with strscpy
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
Cc: Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: google.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

`strncpy` is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

It seems `cmd->policy_name` is intended to be NUL-terminated based on a
now changed line of code from Commit (c6b4fcbad044e6ff "dm: add cache
target"):
|       if (strcmp(cmd->policy_name, policy_name)) { // ...

However, now a length-bounded strncmp is used:
|       if (strncmp(cmd->policy_name, policy_name, sizeof(cmd->policy_name)))
... which means NUL-terminated may not strictly be required. However, I
believe the intent of the code is clear and we should maintain
NUL-termination of policy_names.

Moreover, __begin_transaction_flags() zero-allocates `cmd` before
calling read_superblock_fields():
|       cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);

Also, `disk_super->policy_name` is zero-initialized
|       memset(disk_super->policy_name, 0, sizeof(disk_super->policy_name));
... therefore any NUL-padding is redundant.

Considering the above, a suitable replacement is `strscpy` [2] due to
the fact that it guarantees NUL-termination on the destination buffer
without unnecessarily NUL-padding.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.
---
 drivers/md/dm-cache-metadata.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index acffed750e3e..5a18b80d3666 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -597,7 +597,7 @@ static void read_superblock_fields(struct dm_cache_metadata *cmd,
 	cmd->discard_nr_blocks = to_dblock(le64_to_cpu(disk_super->discard_nr_blocks));
 	cmd->data_block_size = le32_to_cpu(disk_super->data_block_size);
 	cmd->cache_blocks = to_cblock(le32_to_cpu(disk_super->cache_blocks));
-	strncpy(cmd->policy_name, disk_super->policy_name, sizeof(cmd->policy_name));
+	strscpy(cmd->policy_name, disk_super->policy_name, sizeof(cmd->policy_name));
 	cmd->policy_version[0] = le32_to_cpu(disk_super->policy_version[0]);
 	cmd->policy_version[1] = le32_to_cpu(disk_super->policy_version[1]);
 	cmd->policy_version[2] = le32_to_cpu(disk_super->policy_version[2]);
@@ -707,7 +707,7 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
 	disk_super->discard_block_size = cpu_to_le64(cmd->discard_block_size);
 	disk_super->discard_nr_blocks = cpu_to_le64(from_dblock(cmd->discard_nr_blocks));
 	disk_super->cache_blocks = cpu_to_le32(from_cblock(cmd->cache_blocks));
-	strncpy(disk_super->policy_name, cmd->policy_name, sizeof(disk_super->policy_name));
+	strscpy(disk_super->policy_name, cmd->policy_name, sizeof(disk_super->policy_name));
 	disk_super->policy_version[0] = cpu_to_le32(cmd->policy_version[0]);
 	disk_super->policy_version[1] = cpu_to_le32(cmd->policy_version[1]);
 	disk_super->policy_version[2] = cpu_to_le32(cmd->policy_version[2]);
@@ -1726,7 +1726,7 @@ static int write_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *po
 	    (strlen(policy_name) > sizeof(cmd->policy_name) - 1))
 		return -EINVAL;
 
-	strncpy(cmd->policy_name, policy_name, sizeof(cmd->policy_name));
+	strscpy(cmd->policy_name, policy_name, sizeof(cmd->policy_name));
 	memcpy(cmd->policy_version, policy_version, sizeof(cmd->policy_version));
 
 	hint_size = dm_cache_policy_get_hint_size(policy);

---
base-commit: 6465e260f48790807eef06b583b38ca9789b6072
change-id: 20230925-strncpy-drivers-md-dm-cache-metadata-c-f708096d5d22

Best regards,
--
Justin Stitt <justinstitt@google.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

