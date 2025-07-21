Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBC52B9A8
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 03:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753070212; cv=none; b=M4HkGADLTEhB0Uy9/8WQksHeWbPaHi8FCGtzDj97j/o0BVLt1xjPnDBvFHxXSEKGFKiChbPLPRPGVCXdMdw5bxdAYgo+dApGCU/zZwbjKZlCUyomi3tirjS2iGCXGAwruPlJF7pjhL4Nki/DtYscPu+FMKN6Om6GST3SsOJiIRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753070212; c=relaxed/simple;
	bh=btpYYUIbFBEp+ktnsXZqqxkPFTnpTlE8q8VnCvyDrII=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=W+pgXuK/EPhG2aRqp8FT9uydwu0TxaPC26xCB0qhARqv8PlUC6i6ba8RCvN1z7ftnNlKdpBR7CO6rcWp545s+CG7Ycnapj7v0uX6UKSieWiRPHS9biewRFcsxyx8tI0VlH6yNlAJX5oobagNUrjEhQttg1g6CWbG4uWYRtjUphg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=dZeU4SL5; arc=none smtp.client-ip=43.163.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="dZeU4SL5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1753070199; bh=sVN/AzOJY5mxP5MAX87gxt0LYQMkeR9l094mDeUFjL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZeU4SL5xVJsq/iycDcuS+nAlQPcanQGhnYSFgBF9Yps8zazy6CUszRcCFAKJIqhf
	 WiceU5hxumi0c+PodF8InixYT4oVTLW8Si0eNHJ2iEUfnj87hcEDOKmopjPN+5/MTo
	 ZxlObq9qqqmgHwli5J0ZSjJgSRFiimqrGCZwwFqY=
Received: from VM-222-126-tencentos.localdomain ([14.116.239.33])
	by newxmesmtplogicsvrszb20-0.qq.com (NewEsmtp) with SMTP
	id E1F824F9; Mon, 21 Jul 2025 11:56:31 +0800
X-QQ-mid: xmsmtpt1753070191t4v69hpdn
Message-ID: <tencent_2633924ADEC79A0D51ECD39670F36EC5FD09@qq.com>
X-QQ-XMAILINFO: Mkw1Oys1xyjC1/Lv+r5o6Q7xO1jo6/WJU9QWFmQnv71aUpxWCPWjFaBaSSfsd1
	 gFqjTbE/j38SjMwFyerFmnoQvnlf09MYhHV/Trr/HFGdl1IUwm2R+Z5kZajA1XICjETckiW/WaDT
	 Mc1uoNfLleH9XMq0Vjl1Foyuia/vPSTIkOxY5M3PvP3N8vmA9UIQi89px8XPj1vuA+cTgEHFOVbu
	 bc7Gi3fiSrnyfpbsPbEJvZiPuhpSIljksLknY6Tigq/pRs5IBxEhW89dOUPqnTaCED4XtdSvuW3c
	 12l9GOStp7CvO14Cyd9NdkFiSttH5xUYM66uMrEpsbn/z0HRy8e7zB6cjJK87+jPBl6En4IseS66
	 061BY0V7QWkPiEH5Y44lIgPlO2wYgT/jZKEk2O8Y+a0WOZ1WcumLcapuAF5xErR+bx/Ol+c2AP6e
	 KhRxSYUVeu5dC/6KHi4qHQa2xIe6OYBqWHtFfGk3Q5vBF8CtY+gPtDiHsV2Wy1Kih6MvTqppio7f
	 9vrku6qQ+JSGmqqlX77qNN9Cppz6voA7syHk9yZ2Ef4I5CYPRl83kbwWoKyDI92VsJgHEDwlEnul
	 nfiJ/+cPTlsMd9aaavYlB9lTAowahFKOiaGpi6sL0xg7cvPF4ubl2vA5YhUV/ktzZOnxFqdayKn7
	 s//HRLoOVzt/4U1rwKhv22x3a8qkyJGuDMwbrinZyeskkw7EDKPfP2SSD0t9vyt1Bfahvvwy6dQj
	 EMLO0PnxGYji2plpA4cOXDSqaG21NlQAk2W3um0pbuApNJ1Ps7VELDxO/agNLGQpEsMTBdqZiZpy
	 ui5M18u7+g6lr04WoGhFa/M8kW0M3SkCNMdCdnvfAsUSVSx4qgCo0mbDUtZDcLEP6GRgBMYntipa
	 yyPzVvuvKdGD0aqxzrMpHQP5TBff+gPLg6iCbDurWn5mzwW0PnTYjEynG2JoqAplq91GtttBWB5Y
	 0bRdeHB/HajuvLjbEy81mBs7cbrnoISu8C3ocEIQ37QZXrBQEN1T3J454MNsAdjzD+F0NcwHZkbi
	 I5FF0ghLHCr0X/Mslkn9LjC2Si6DXO7JMceVRehfNX4u/YF8gbYDWgxCigHZB2QEfHF3luGw==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: jackysliu <1972843537@qq.com>
To: ptikhomirov@virtuozzo.com
Cc: agk@redhat.com,
	den@virtuozzo.com,
	dm-devel@lists.linux.dev,
	khorenko@virtuozzo.com,
	linux-kernel@vger.kernel.org,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	xni@redhat.com,
	yukuai3@huawei.com,
	Siyang Liu <1972843537@qq.com>
Subject: [PATCH v2] arch: fix resource leak in jbusmc_probe()
Date: Mon, 21 Jul 2025 11:56:24 +0800
X-OQ-MSGID: <20250721035624.128629-1-1972843537@qq.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250721034929.374552-1-ptikhomirov@virtuozzo.com>
References: <20250721034929.374552-1-ptikhomirov@virtuozzo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Siyang Liu <1972843537@qq.com>

In the jbusmc_probe function, the device node mem_node fetched
via of_find_node_by_path("/memory") is not properly freed
on all code paths.
This can lead to leakage of device node reference counts,
which may result in kernel resources not being released.

This issue was detected by rule based static tools
developed by Tencent.

Signed-off-by: Siyang Liu <1972843537@qq.com>
---
 arch/sparc/kernel/chmc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/chmc.c b/arch/sparc/kernel/chmc.c
index d4c74d6b2e1b..fd20e4ee0971 100644
--- a/arch/sparc/kernel/chmc.c
+++ b/arch/sparc/kernel/chmc.c
@@ -412,7 +412,7 @@ static int jbusmc_probe(struct platform_device *op)
 	mem_regs = of_get_property(mem_node, "reg", &len);
 	if (!mem_regs) {
 		printk(KERN_ERR PFX "Cannot get reg property of /memory node.\n");
-		goto out;
+		goto out_put;
 	}
 	num_mem_regs = len / sizeof(*mem_regs);
 
@@ -420,7 +420,7 @@ static int jbusmc_probe(struct platform_device *op)
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p) {
 		printk(KERN_ERR PFX "Cannot allocate struct jbusmc.\n");
-		goto out;
+		goto out_put;
 	}
 
 	INIT_LIST_HEAD(&p->list);
@@ -473,6 +473,10 @@ static int jbusmc_probe(struct platform_device *op)
 
 	err = 0;
 
+out_put:
+	of_node_put(mem_node);
+	goto out;
+
 out:
 	return err;
 
@@ -481,7 +485,7 @@ static int jbusmc_probe(struct platform_device *op)
 
 out_free:
 	kfree(p);
-	goto out;
+	goto out_put;
 }
 
 /* Does BANK decode PHYS_ADDR? */
-- 
2.43.5

