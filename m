Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703231;
	b=mYddT7C1D1wChCAn/o2E1wo19+rcdpyAwLVVLHTYdnmhk6C5ejOsXoy4cQcb+mc2axHF
	 +PZ1bDdjec3ClNP1ZkOSAtThGTqMM5SwXyo+fzAdE0GOL0WCEBWh9M2olh0YPltyL+izQ
	 5DB/+u4mYX4KTAkebPDwrc8ezFlHq1dItlcw4+bDDxngbqQY39xJlX/rYn34UaVygezdJ
	 4PB/WRtLm6hydOElkCGAr0ti91dldVfSNZCFP8kSkwAjb/Sg69gPPZYhNEMBYyu1H7CKL
	 07xQgeu5AgW2Mk0JXd00PkGH0mc2bQd75dSUe++VkuNrXo7p5XRD6ZpPMep35zhzDTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703231;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=lUa5DhZx9WKWQsHa9sNTQT9uSwjaE9ND4ZF6lWuR460=;
	b=O/x7MhZnKd3TwnVwHf8mb0okR0w8KZ37xLkzZbgorTCK0i2mHyDKJfeN97/xzk8ktaGC
	 cB06LCDrDDm0kxIFVaZgW+2QE37G1QMH5bZRwW5fc0O+Wg1qXhC/evLA++Uw+uRPF0Q0a
	 MNvCLO6KFWhxxzzwjLVdew3+3avro9gF6P97cuzwyGcOozD1SvlWIi3xlTwR3UB1q6Yyl
	 IeRfhn5VBHjfTaa6Ezt8eN12dR31Nl3DeNtnd95bhTBycHk9iuDGsNb1Bu3+35Dm/+zBm
	 rPXkKfbt1gC+fxUEqAnqcyc/NFPXmWbi1u9wkU59pp8bGzl8uNkSLqblLtiIwRumNjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B08606A33A
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 10:53:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63B08606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJlmr5sBxz5B103;
	Tue, 03 Nov 2026 18:53:48 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 6A3ArdXh088366;
	Tue, 3 Nov 2026 18:53:39 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 3 Nov 2026 18:53:42 +0800 (CST)
X-Zmail-TransId: 2afa6ae9bd3694e-b20b3
X-Mailer: Zmail v1.0
Message-ID: <20261103185342600lmk67Fuw_xX7_kWvJgP-j@zte.com.cn>
Date: Tue, 3 Nov 2026 18:53:42 +0800 (CST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
        <bmarzins@redhat.com>, <dm-devel@lists.linux.dev>
Cc: <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBkbSBsb2cgdXNlcnNwYWNlOiBkcm9wIHRoZSBkZXZpY2UgcmVmZXJlbmNlIG9uIGVycm9y?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A3ArdXh088366
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 03 Nov 2026 18:53:48 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9BD3C.000/4jJlmr5sBxz5B103

userspace_ctr() takes a reference on the log device with
dm_get_device().  When the integrated-flush workqueue allocation fails it
jumps to the shared error path, which frees the log context without
dropping that reference, so the device stays busy and cannot be removed.

userspace_dtr() drops the reference correctly; do the same here.

Fixes: 5066a4df1f42 ("dm log userspace: allow mark requests to piggyback on flush requests")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 3ca35aa4e057..267ae428dde4 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -315,6 +315,8 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 out:
 	kfree(devices_rdata);
 	if (r) {
+		if (lc->log_dev)
+			dm_put_device(lc->ti, lc->log_dev);
 		mempool_exit(&lc->flush_entry_pool);
 		kfree(lc);
 		kfree(ctr_str);
