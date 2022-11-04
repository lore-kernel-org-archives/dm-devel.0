Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F594C4332F
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 08:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667810413;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nrzFJuoFeBRB4vivLhKGnlh9mnwaF1M2QLyXUljHLTk=;
	b=Np2I8C4q0Z27VuFCbrh+tueMxSdZeM3ffn9JMBokRvu+K9Ii76vL9LOt6NetA58mW1999F
	Bhnu31z3u0tYKOD7P9UHxq6PSiBSsP/gGIzoHvW4iEuHoyb4GwxNtt+rfTHFfzUEJw3MXW
	JZjm055AcDGaX6sFvajmqFjEQIn5h9o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-ZsGQfvC1NKyAszWbnU_cFA-1; Mon, 07 Nov 2022 03:40:11 -0500
X-MC-Unique: ZsGQfvC1NKyAszWbnU_cFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C47862804BAA;
	Mon,  7 Nov 2022 08:40:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B5AAF40C2064;
	Mon,  7 Nov 2022 08:40:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A26C61946588;
	Mon,  7 Nov 2022 08:40:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 841FF1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 11:30:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 67C3E40C6F73; Fri,  4 Nov 2022 11:30:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FD2540C6EE9
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45500811E75
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:30 +0000 (UTC)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-172-5kPhyxZmMfmgnHas1HuDHg-1; Fri, 04 Nov 2022 07:30:29 -0400
X-MC-Unique: 5kPhyxZmMfmgnHas1HuDHg-1
Received: by mail-pl1-f200.google.com with SMTP id
 n12-20020a170902e54c00b00188515e81a6so3420703plf.23
 for <dm-devel@redhat.com>; Fri, 04 Nov 2022 04:30:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=s1xZ0vxushGJcgjg7hlatryVRu1/dXqezckzHs4WjGk=;
 b=xo7bhTWylIlEbikralM12kgu+U+GBC5nLxGgfyOb+CYlzJFxvWncnjKnvehaHsRlY6
 CWf990WdhSM1uUsVPk9uujmgKNxC2n/9YgaRKAIMfQ3cVO7GBNmVdoVwawCrpnzpljYA
 Jul8bn78+RC8vJNAUAPd0wJQfed/oML/XVgEGQVW0XSJzJzChL4ATozQuPMZaBRjI0te
 Q5K17zpEI+58Hp2+xeJFOZc61gW8r1cKtthquDKw09zemqHjtyPh/mKOMQtcfnYKWJ1k
 p6tXIrpT1wfAwFdkl890R2HBhKdCKLlUh34YEPtxlu3E/LGveQe3ev7gkI2HDaBNiJb2
 AYnQ==
X-Gm-Message-State: ACrzQf18BbqncitHYxWgLrybo1W6Mouqk59vRn1aFCP2nagl5HfEtLEV
 roDUUTuZ72ZwrL0/2UNA6PCzdMV52+0bqiXTH0+U3jD3S5UXQhJTwbbABDflEUv8sHveZU0RCSl
 LWF+pZyZGsAufks8=
X-Received: by 2002:a17:90b:4f8a:b0:213:48f0:296f with SMTP id
 qe10-20020a17090b4f8a00b0021348f0296fmr53282529pjb.140.1667561428159; 
 Fri, 04 Nov 2022 04:30:28 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6fOg7xKewtpqLLbefucY7Lfg8o27pnyZIU+pw2e82M8AAb+KPN1hlYZS75bLeAcvDS/QbLoA==
X-Received: by 2002:a17:90b:4f8a:b0:213:48f0:296f with SMTP id
 qe10-20020a17090b4f8a00b0021348f0296fmr53282509pjb.140.1667561427911; 
 Fri, 04 Nov 2022 04:30:27 -0700 (PDT)
Received: from localhost ([209.132.188.80]) by smtp.gmail.com with ESMTPSA id
 p12-20020a170902a40c00b00186b1bfbe79sm2429710plq.66.2022.11.04.04.30.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 04:30:27 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Fri,  4 Nov 2022 19:29:57 +0800
Message-Id: <20221104113000.487098-3-coxu@redhat.com>
In-Reply-To: <20221104113000.487098-1-coxu@redhat.com>
References: <20221104113000.487098-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Mon, 07 Nov 2022 08:40:06 +0000
Subject: [dm-devel] [RFC v2 2/5] crash_dump: save the LUKS volume key
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
Cc: Baoquan He <bhe@redhat.com>, dm-devel@redhat.com,
 Pingfan Liu <kernelfans@gmail.com>, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Jan Pazdziora <jpazdziora@redhat.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Dave Young <dyoung@redhat.com>,
 Milan Broz <gmazyland@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
 kernel/crash_dump.c        | 88 ++++++++++++++++++++++++++++++++++++++
 kernel/ksysfs.c            | 19 ++++++++
 3 files changed, 109 insertions(+)

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
diff --git a/kernel/crash_dump.c b/kernel/crash_dump.c
index 92da32275af5..9c202bffbb8d 100644
--- a/kernel/crash_dump.c
+++ b/kernel/crash_dump.c
@@ -5,6 +5,7 @@
 #include <linux/errno.h>
 #include <linux/export.h>
 
+#include <keys/user-type.h>
 /*
  * stores the physical address of elf header of crash image
  *
@@ -39,3 +40,90 @@ static int __init setup_elfcorehdr(char *arg)
 	return end > arg ? 0 : -EINVAL;
 }
 early_param("elfcorehdr", setup_elfcorehdr);
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
index b1292a57c2a5..e7a7433cb951 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -135,6 +135,24 @@ static ssize_t vmcoreinfo_show(struct kobject *kobj,
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
@@ -223,6 +241,7 @@ static struct attribute * kernel_attrs[] = {
 #endif
 #ifdef CONFIG_CRASH_CORE
 	&vmcoreinfo_attr.attr,
+	&crash_luks_volume_key_attr.attr,
 #endif
 #ifndef CONFIG_TINY_RCU
 	&rcu_expedited_attr.attr,
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

