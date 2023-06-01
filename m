Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1908C77B7A
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 05:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685684384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jIiWOFe5r2TV7/Wc5ie2VjTvWigp5Q0aiqLxD3FtBA8=;
	b=RADc4QJweUSKnCbXmHem7sjiND8L8YT+Jy4RYi9K5CRbBz7DrEjHdwKxbOBVtee9gfi9o5
	3sZS/9bynA9KS67YdTK6yYqa9yeCKHxkl9Zx1rbexCZFWgJ8ehRqnKfLfruhMLewUtw09i
	BBZcr+vqsYnfPllk89QC3J+xDZu2OI8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-tkWqabiUPBGjjxEHVcHZLw-1; Fri, 02 Jun 2023 01:39:40 -0400
X-MC-Unique: tkWqabiUPBGjjxEHVcHZLw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC3612A2AD5C;
	Fri,  2 Jun 2023 05:39:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D3D98492B0B;
	Fri,  2 Jun 2023 05:39:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 907661946595;
	Fri,  2 Jun 2023 05:39:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E49D319451E5
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 07:24:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C8AEB421C3; Thu,  1 Jun 2023 07:24:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C161D9D73
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:24:59 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1C443C0CEE9
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:24:59 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-uTriWEaaP5qwtvQDN_bwaw-1; Thu, 01 Jun 2023 03:24:56 -0400
X-MC-Unique: uTriWEaaP5qwtvQDN_bwaw-1
Received: by mail-qt1-f197.google.com with SMTP id
 d75a77b69052e-3f83058a849so5184731cf.0
 for <dm-devel@redhat.com>; Thu, 01 Jun 2023 00:24:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685604296; x=1688196296;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=AVNhkRwZAfrMBhKh//wi6Z59DrttLTByCXwnmuvQ7Sk=;
 b=iM9rzw2XVbjB3ijP3/O+DQZswl+OvrkUneoPtx5Pza1eWqgSkD+Lhi5cyG1Yi1N3fA
 PH6sB8HbFgq8Ff4UWgm+aWk/pHVi4h3WpoNz0Y30Gv6NrK46QIxSMzQGuY7MAYqdIOww
 Kyr+ryKooruZhPO5HW4jwU9djiJq9qIkZR8jeR1No0c6fu30SDWNI1UBAYWlpwBs2Nj2
 oD2eSz7HrFchJ6aCZWcCQNvIyv3erSDcOZGwqzTD2tvzh00BAZPc7vSDW2b1QHMys4Nz
 rVQsRBFa8g7qrdTwUo/hII1NuQRhqJ1FW4orQriB16Uw91Glyf6XaIK2lfy9S7oy0s3b
 nGQQ==
X-Gm-Message-State: AC+VfDxZjBafC4As0jAATrsXOwnqvnIQPHZVOF72LDWiVRqkQNSfmZ2v
 VpPwYyemxYt3wrhj2jQnWhMQ+tvoKnzRvCMRpTt8WYSCeyo4wlJ/0niPHS/CN32/3GMR66AcDT2
 BIgKMdxee28Slxn4=
X-Received: by 2002:a05:622a:3c7:b0:3f4:eb26:6d42 with SMTP id
 k7-20020a05622a03c700b003f4eb266d42mr7982588qtx.63.1685604295826; 
 Thu, 01 Jun 2023 00:24:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6UZAxm2RuiVCtGixZ0U45XGL7fm+89xCNa6kmGqARldADNGbnk+xAiazKcrMefCa2tIl3eZQ==
X-Received: by 2002:a05:622a:3c7:b0:3f4:eb26:6d42 with SMTP id
 k7-20020a05622a03c700b003f4eb266d42mr7982558qtx.63.1685604295538; 
 Thu, 01 Jun 2023 00:24:55 -0700 (PDT)
Received: from localhost ([43.228.180.230]) by smtp.gmail.com with ESMTPSA id
 i28-20020a63541c000000b0053efb8fae02sm2465297pgb.24.2023.06.01.00.24.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Jun 2023 00:24:55 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Thu,  1 Jun 2023 15:24:41 +0800
Message-Id: <20230601072444.2033855-3-coxu@redhat.com>
In-Reply-To: <20230601072444.2033855-1-coxu@redhat.com>
References: <20230601072444.2033855-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Fri, 02 Jun 2023 05:39:36 +0000
Subject: [dm-devel] [PATCH 2/5] crash_dump: save the LUKS volume key
 temporarily
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
Cc: Baoquan He <bhe@redhat.com>, x86@kernel.org, dm-devel@redhat.com,
 Pingfan Liu <kernelfans@gmail.com>, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@intel.com>, Kairui Song <ryncsn@gmail.com>,
 Jan Pazdziora <jpazdziora@redhat.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Young <dyoung@redhat.com>,
 Milan Broz <gmazyland@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

After having the volume key, crytpsetup/systemd-cryptsetup saves the
volume key as a logon key to its thread keyring and this key is
destroyed immediately with the terminated thread. So a temporary copy of
the volume key is needed in order to later save it to kdump reserved
memory when the crash kernel is loaded later.

crytpsetup/systemd-cryptsetup will write the key description to
/sys/kernel/crash_luks_volume_key so the kernel will read the logon key
and save a temporary copy for later user. kdump has 1 hour at maximum to
get the temporary copy before the key gets wiped. And after kdump
retrieves the key, the key will be wiped immediately.

Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 include/linux/crash_core.h |  2 +
 kernel/Makefile            |  2 +-
 kernel/crash_dump_luks.c   | 90 ++++++++++++++++++++++++++++++++++++++
 kernel/ksysfs.c            | 19 ++++++++
 4 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 kernel/crash_dump_luks.c

diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index de62a722431e..596d83b8f362 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -83,5 +83,7 @@ int parse_crashkernel_high(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
 int parse_crashkernel_low(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
+int crash_sysfs_luks_volume_key_write(const char *key_des, size_t count);
+int crash_pass_temp_luks_volume_key(void **addr, unsigned long *sz);
 
 #endif /* LINUX_CRASH_CORE_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index b69c95315480..8412afa4a9f0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -118,7 +118,7 @@ obj-$(CONFIG_PERF_EVENTS) += events/
 
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
-obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
+obj-$(CONFIG_CRASH_DUMP) += crash_dump.o crash_dump_luks.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
diff --git a/kernel/crash_dump_luks.c b/kernel/crash_dump_luks.c
new file mode 100644
index 000000000000..2d88b77a93f8
--- /dev/null
+++ b/kernel/crash_dump_luks.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <keys/user-type.h>
+#include <linux/crash_dump.h>
+
+static u8 *luks_volume_key;
+static unsigned int luks_volume_key_size;
+
+void wipe_luks_volume_key(void)
+{
+	if (luks_volume_key) {
+		memset(luks_volume_key, 0, luks_volume_key_size * sizeof(u8));
+		kfree(luks_volume_key);
+		luks_volume_key = NULL;
+	}
+}
+
+static void _wipe_luks_volume_key(struct work_struct *dummy)
+{
+	wipe_luks_volume_key();
+}
+
+static DECLARE_DELAYED_WORK(wipe_luks_volume_key_work, _wipe_luks_volume_key);
+
+static unsigned __read_mostly wipe_key_delay = 3600; /* 1 hour */
+
+static int crash_save_temp_luks_volume_key(const char *key_desc, size_t count)
+{
+	const struct user_key_payload *ukp;
+	struct key *key;
+
+
+	if (luks_volume_key) {
+		memset(luks_volume_key, 0, luks_volume_key_size * sizeof(u8));
+		kfree(luks_volume_key);
+	}
+
+	pr_debug("Requesting key %s", key_desc);
+	key = request_key(&key_type_logon, key_desc, NULL);
+
+	if (IS_ERR(key)) {
+		pr_debug("No such key %s", key_desc);
+		return PTR_ERR(key);
+	}
+
+	ukp = user_key_payload_locked(key);
+	if (!ukp)
+		return -EKEYREVOKED;
+
+	luks_volume_key = kmalloc(ukp->datalen, GFP_KERNEL);
+	if (!luks_volume_key)
+		return -ENOMEM;
+	memcpy(luks_volume_key, ukp->data, ukp->datalen);
+	luks_volume_key_size = ukp->datalen;
+	pr_debug("LUKS master key (size=%u): %8ph\n", luks_volume_key_size, luks_volume_key);
+	schedule_delayed_work(&wipe_luks_volume_key_work,
+			      round_jiffies_relative(wipe_key_delay * HZ));
+	return 0;
+}
+
+int crash_sysfs_luks_volume_key_write(const char *key_desc, size_t count)
+{
+	if (!is_kdump_kernel())
+		return crash_save_temp_luks_volume_key(key_desc, count);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(crash_sysfs_luks_volume_key_write);
+
+int crash_pass_temp_luks_volume_key(void **addr, unsigned long *sz)
+{
+	unsigned long luks_key_sz;
+	unsigned char *buf;
+	unsigned int *size_ptr;
+
+	if (!luks_volume_key)
+		return -EINVAL;
+
+	luks_key_sz = sizeof(unsigned int) + luks_volume_key_size * sizeof(u8);
+
+	buf = vzalloc(luks_key_sz);
+	if (!buf)
+		return -ENOMEM;
+
+	size_ptr = (unsigned int *)buf;
+	memcpy(size_ptr, &luks_volume_key_size, sizeof(unsigned int));
+	memcpy(size_ptr + 1, luks_volume_key, luks_volume_key_size * sizeof(u8));
+	*addr = buf;
+	*sz = luks_key_sz;
+	wipe_luks_volume_key();
+	return 0;
+}
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index aad7a3bfd846..cc64a895c334 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -165,6 +165,24 @@ static ssize_t vmcoreinfo_show(struct kobject *kobj,
 }
 KERNEL_ATTR_RO(vmcoreinfo);
 
+static ssize_t crash_luks_volume_key_show(struct kobject *kobj,
+					  struct kobj_attribute *attr,
+					  char *buf)
+{
+	return 0;
+}
+
+static ssize_t crash_luks_volume_key_store(struct kobject *kobj,
+					   struct kobj_attribute *attr,
+					   const char *buf, size_t count)
+{
+	int ret;
+
+	ret = crash_sysfs_luks_volume_key_write(buf, count);
+	return ret < 0 ? ret : count;
+}
+KERNEL_ATTR_RW(crash_luks_volume_key);
+
 #endif /* CONFIG_CRASH_CORE */
 
 /* whether file capabilities are enabled */
@@ -255,6 +273,7 @@ static struct attribute * kernel_attrs[] = {
 #endif
 #ifdef CONFIG_CRASH_CORE
 	&vmcoreinfo_attr.attr,
+	&crash_luks_volume_key_attr.attr,
 #endif
 #ifndef CONFIG_TINY_RCU
 	&rcu_expedited_attr.attr,
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

