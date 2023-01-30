Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57170C38142
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 07:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675151243;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D8L2aZ9B4wzsqJ6ibI4Ic4SvJXkc0SNajhPG0YPjU7I=;
	b=IVsWt847rxxXJqwhtaRNaQoE9+LukAxmy22McROXvYn1RBvR403Hn4Ft6eXxrI20P3JvII
	jY8Z+qz38IRF+Fjo8HZcpiRslhfvxKTPtxWjA9P1exKffSsmKGv+ty6mt1NHPxG4/ajHiR
	8V2HIHknqxQ3ylWBdf2DTNmKD7PPWQc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-SjXINyJZOW6LuP642ooRkA-1; Tue, 31 Jan 2023 02:47:21 -0500
X-MC-Unique: SjXINyJZOW6LuP642ooRkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D668E85D06A;
	Tue, 31 Jan 2023 07:47:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 15F68112132C;
	Tue, 31 Jan 2023 07:47:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DA31E1946589;
	Tue, 31 Jan 2023 07:47:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E19B0194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 30 Jan 2023 23:06:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C5DBB1121314; Mon, 30 Jan 2023 23:06:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF78A1121315
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7066785530D
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 23:06:39 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-526-6D10t59-Mdyrl3ykYh91BA-1; Mon,
 30 Jan 2023 18:06:37 -0500
X-MC-Unique: 6D10t59-Mdyrl3ykYh91BA-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 240E520EA1EA; Mon, 30 Jan 2023 14:58:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 240E520EA1EA
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Mon, 30 Jan 2023 14:57:19 -0800
Message-Id: <1675119451-23180-5-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Tue, 31 Jan 2023 07:47:16 +0000
Subject: [dm-devel] [RFC PATCH v9 04/16] security: add new securityfs delete
 function
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
Cc: Fan Wu <wufan@linux.microsoft.com>, dm-devel@redhat.com,
 linux-doc@vger.kernel.org, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-audit@redhat.com, linux-integrity@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When deleting a directory in the security file system, the existing
securityfs_remove requires the directory to be empty, otherwise
it will do nothing. This leads to a potential risk that the security
file system might be in an unclean state when the intentded deletion
did not happen.

This commit introduces a new function securityfs_recursive_remove
to recursively delete a directory without leaving an unclean state.

Co-developed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v8:
  + Not present
---
 include/linux/security.h |  1 +
 security/inode.c         | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/security.h b/include/linux/security.h
index 5b67f208f7de..479e154a12b8 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1985,6 +1985,7 @@ struct dentry *securityfs_create_symlink(const char *name,
 					 const char *target,
 					 const struct inode_operations *iops);
 extern void securityfs_remove(struct dentry *dentry);
+extern void securityfs_recursive_remove(struct dentry *dentry);
 
 #else /* CONFIG_SECURITYFS */
 
diff --git a/security/inode.c b/security/inode.c
index 6c326939750d..13358e8547e8 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -313,6 +313,31 @@ void securityfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(securityfs_remove);
 
+static void remove_one(struct dentry *victim)
+{
+	simple_release_fs(&mount, &mount_count);
+}
+
+/**
+ * securityfs_recursive_remove - recursively removes a file or directory from the securityfs filesystem
+ *
+ * @dentry: a pointer to a the dentry of the file or directory to be removed.
+ *
+ * This function recursively removes a file or directory in securityfs that was
+ * previously created with a call to another securityfs function (like
+ * securityfs_create_file() or variants thereof.)
+ */
+void securityfs_recursive_remove(struct dentry *dentry)
+{
+	if (IS_ERR_OR_NULL(dentry))
+		return;
+
+	simple_pin_fs(&fs_type, &mount, &mount_count);
+	simple_recursive_removal(dentry, remove_one);
+	simple_release_fs(&mount, &mount_count);
+}
+EXPORT_SYMBOL_GPL(securityfs_recursive_remove);
+
 #ifdef CONFIG_SECURITY
 static struct dentry *lsm_dentry;
 static ssize_t lsm_read(struct file *filp, char __user *buf, size_t count,
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

