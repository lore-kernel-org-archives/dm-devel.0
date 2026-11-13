Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574678;
	b=x/jDVEhZ3ciobWVvZ+IHfvNOCfiNJOHiQX7QxLaxdXm/wLRAP59m341tl7nEKni8/Pa2
	 1vKlvbgaJrNwlfjCsQ+jjWQnOhLb3ZkD83ueslHC8JHeRvbUFFRTLJZpX9cZVf3ggcJfw
	 DHAWjXdJ1S6N1N/HN56moqjcIzZeMpWMznZdDfE4S/PLiR0ph77PJl3mXJSQP6ruxOQKX
	 QAWEERRWbYVqo8pXq68qeQesFdqCipGxgKEt50rb/3kzZ9/lvgfBETdOQ1cMqWlwVCTYi
	 3rh+2ru4JrPFqGHW4cz8PokpPEdoYN9f/x544VVAhmbhB/jXIIKZg8q1a/q0k8CeyIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574678;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=efR+s4LJDVQep7RV0zc8eCSphgxsWu8QlR7Oau/c+Os=;
	b=X7GM8w9GvzNaachajWHBsbsk2BUrac26IbpP9Xd4lMGXxiIZUbhKgq7emjK1JBe1e8ze
	 N0Mr5n8mRoNFmvT1FYKTxQ7pUAz+2vvSJCSTBWYCCqr7BmSKuIjNYn3X82oNqw+RQ8I00
	 bAX3AkYw+GzVHzoc1CuRwraAgrJDDktXr5qeTUMwbfLy+eVMbR2kpZHa7cuOVPN4Mrtn8
	 sIKRej6EuleDm6OWTuqeEXYEXhORb/ym9yz7aRkPO2p4LcJlX2bflpZf47s5bkfw00Lau
	 XZ4xrGF6ovfq5WCi8WSL2fAyDvWs2YP39/ClG8vHkB9hRtekFV+WbkmHf1uMgq8VtBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VL2+Cn3K;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14D4606A327
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:57:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E14D4606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VL2+Cn3K
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb5d38264aso278475e9.2
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574676; x=1795179476; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=efR+s4LJDVQep7RV0zc8eCSphgxsWu8QlR7Oau/c+Os=;
        b=VL2+Cn3KQ80cQN0GgKZfgLsDPuQEPwd8MoV6CIyfCwV9cUCn8j3SNnhpwkFSiL0I6o
         33fb4XbCweYzDUkXcfHhxlIaUhVzNK3Tv7yp/cy4Q1XZTBmMT5qDiYL++kSSo3t1kwZG
         l/xOnw8988a70j7+CH69sB1E6sJsplcw+EC6aWmHuMMyrqmqjbGkGFguitQMdfgB0qkk
         EJWnCGm1q1eq7YXnUkr8Zy0lTOCgXFoF7RWVBzjWZlOzgf1oaoHnNeIfXWN1i+sRELLA
         WI2uLxl0TvPmiiU8bZYT1XuHQbtMdfSJXVekgmOdkHknwX1bTsL9GN1Pq0TeMnKQapVC
         ZolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574676; x=1795179476;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=efR+s4LJDVQep7RV0zc8eCSphgxsWu8QlR7Oau/c+Os=;
        b=ci/O0QGSTC3QjL4h3oI3DrB0uQ9Zg2JQeVp1kZO760TU2PrtVIFmLJY83NFk8KMfsq
         9LC3/NseuhRb5rVX0A9dC5ZlDz76y6/xODrw67K3Mv0sDP5q8n9hYNgOYRiChkIl2kMV
         xe+BHJkplVZXwMb8/HbTM340sXF98/JIh6LKZe9LRWQs70wcq0y9ng+o9fQTJi0uG2Vr
         hiPsEVYkDxw6QoYFYUvvMxEG+HjYXsVhVlrzz7dD+iB9FeMCgUVLl6q8JsJLxMu8WzWK
         GLhHfl23ntJAVpkJaY90nZnqzbT5Psigz74ZlmS+AEHFOZ0iw7ukH84jW7hGsiIh34Cy
         gXig==
X-Forwarded-Encrypted: i=1; AL+hErHf+gzozru9sCxm/D0jc1bTjSudyaYl8VrTpjtFGdAXZLWLXVTa7WDS28L52mZp6DoX77IF3zuo1w==@lists.linux.dev
X-Gm-Message-State: APuU4Z+s3skbsy/1xFukQVX2hLmj0y+UVVXnuqcvf1Ga1HN66Py8g+wr
	PgDA1sU4tBq/OmChtiqD6UajgmbISevdHs61lauCJULP4xnUxCUSLno=
X-Gm-Gg: AYBFou1vvnWmF6596xbFc8lpxce4eiE/0O8WAp5+YKg5OKDpfN//6dk8JtiOFCOuPmf
	PjQpq9I50JPBqkNcz+WCKCsgapX+BbQWXeRZUGkk/Vmufd/HwzfydDcdSiQPNqhSMD24h+jYVLX
	Lk8Qui2oib9Bv+KN6j5bPrGHWEto+VFipwG1X1wgsIvPujgTbhhweRsdDRuNMz0EHjZri8bJox8
	NNfvvpMQ2lAdB2GqU6kkcsLIYlDBbSy5bXQiOujPGij8PKgfDetcCZkDEdUrmBkAQFkyX0ipUsc
	WwLoKMZ6nLHeKAeyju4H1TEMFXYf/XneQRYmCpn5t+mL17vdItsTykFEhcdw2Kg0SMmbhd/J69l
	Kp4DGSQjhX0xT0G1IhjuxhoTshukdmGkWcaGhszElMZS5WTWoBCxEFyZmcT3N3mo6RWfvqXGC/4
	ZzPU/LuI1ZOuWimRe2i1hxzhmxxhyHGLkLtUzZiIc22CGv00csSzMI2zRvjEdjzhqbdrlHF8XkI
	O7TeFmB6YWhHupp2z8dBNsIxfyGLenUoBvh8CxvkERL1pPC8Gw1IJRUL4tEq2vAkjFCmHhyX73H
	Mzl9AqOcS7vP2eh+qJWoyqf37Q5e/rC48oYy+kOShODcIuwq0aS7XelBDbnD4iigcg==
X-Received: by 2002:a05:600d:644d:20b0:4a1:b027:99ef with SMTP id 5b1f17b1804b1-4bb55a3f05cmr41433585e9.2.1794574676250;
        Fri, 13 Nov 2026 04:57:56 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55ae5299sm67056285e9.11.2026.11.13.04.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:57:55 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 08/13] multipath-tools: hwtable: add EMC/Celerra
Date: Fri, 13 Nov 2026 13:57:54 +0100
Message-ID: <20261113125754.504990-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

From "Dell Technologies Host Connectivity Guide for Linux" (May 2024, #102):
vendor "EMC"
product "Celerra"
path_grouping_policy "multibus"
path_checker "tur"
no_path_retry "30"

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index aab7bbd2..41e7e0a6 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -411,6 +411,13 @@ static struct hwentry default_hw[] = {
 		.product       = "100E-00",
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 30,
+	},
+		// EMC Celerra
+	{
+		.vendor        = "EMC",
+		.product       = "Celerra",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
 	},
 	/*
 	 * Fujitsu
-- 
2.56.1

