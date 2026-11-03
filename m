Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703236;
	b=ycPN1BpHJcFxtWYhrOIpipytxMT8HrDttihPqq1JVKFb0DH5a80r9xJvZnbLSHuBQKI1
	 5KHuzN30TE+alfy/gmUIcD3HE29PqhQamwgE8BJuiRd2utRY+1kTyjKiCyK9GvnKv0f8O
	 SlwTEnKVVKjMYPJmVC3DmiKDwknNQx+NPDLr2oi1arKXmMSuqkMmNqawe/QJ06QkpDo5E
	 HSKCG3p6UUiAHm0Z/JpL49ePU/TpqZoHy/S1Mk/SmLGkbut8bqhFBTumVztbWMngHcMVc
	 JPy6mJ5QYTQiKMIMpJ7RnvFArjq7CSosyVMKEXxY8RDkI/U1hu1M53/Y7HcY7gRFSvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703236;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=i+DHw1eJBnfBYMpsbId+fwdj/ffdvRjE8kTCYAnvm70=;
	b=yHAJUxCiz9Xr/MgNLhh0K4MST0LOV6/FV1XbTSxg++DJGHOY+X1OQDDWfCUuo2tQ2Qlk
	 GEaV7qZedDRKCIHkKiEOdYf3DHFMCrvZC4C0cnPfUwC0qQ8PpaBwOr2bLnjFF/1wPncbm
	 Ckp27QmaqPlcQRXQRzX4uCe8ZhN/pIEyTL0CCXxnd0V3So6QHjTXe273vLC91b/hYtrhy
	 H5N69VuOdTxWomb9Y3ygZapQMj6bCsuEJsEU7lFO8LEHxComehc2Cu5LHFCkcat4p0NO9
	 vglc1KR1DuDOfoP8/H3k6zKzuz4KAmddPTw8+68Iw2F/Df6KVR6jftfUezQvvg05bPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932EC606D81C
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 10:53:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 932EC606D81C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJlmy14Xkz8Xrrc;
	Tue, 03 Nov 2026 18:53:54 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 6A3ArbDm051787;
	Tue, 3 Nov 2026 18:53:37 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 3 Nov 2026 18:53:40 +0800 (CST)
X-Zmail-TransId: 2af96ae9bd34b2d-af295
X-Mailer: Zmail v1.0
Message-ID: <20261103185340382nGk9q5f5TbPSdgcbDLAUy@zte.com.cn>
Date: Tue, 3 Nov 2026 18:53:40 +0800 (CST)
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
Cc: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBkbSBtcGF0aDogZml4IGJ1ZmZlciBvdmVyZmxvdyBpbiBwYXJzZV9od19oYW5kbGVyKCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A3ArbDm051787
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 03 Nov 2026 18:53:54 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9BD42.000/4jJlmy14Xkz8Xrrc

parse_hw_handler() builds the hw_handler parameter string in a buffer
sized with

	len = 4;

plus one byte per argument.  Those four bytes were meant for the decimal
form of the parameter count, three digits plus the terminating NUL.
dm_read_arg_group() accepts up to 1024 arguments and the count written is
'hw_argc - 1', so a count of 1000 or more needs four digits plus the NUL
and sprintf() writes one byte past the allocation.

Size the buffer from the actual string length instead.

Fixes: 2bfd2e1337f0 ("[SCSI] scsi_dh: Use scsi_dh_set_params() in multipath.")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index ae9318f5f21b..2f871a23a8cb 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1085,8 +1085,9 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 
 	if (hw_argc > 1) {
 		char *p;
-		int i, j, len = 4;
+		int i, j, len;
 
+		len = snprintf(NULL, 0, "%d", hw_argc - 1) + 1;
 		for (i = 0; i <= hw_argc - 2; i++)
 			len += strlen(as->argv[i]) + 1;
 		p = m->hw_handler_params = kzalloc(len, GFP_KERNEL);
