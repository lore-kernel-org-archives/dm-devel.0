Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.220
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793430959;
	b=br2cwTyrtV2UZQghdbzMx0KU6aRvLCejYShYa4VxOHq4YsXLiGEmXZQ49kliOHxu4zYG
	 0HwEcWI4IXUB3oSGxj5GoDxATCOnkdt+lqb5FYBfMXkTGDGhIfdbQ5S1a/MlrnMcki2SR
	 432y8GvdvjOpyoNjJQ2qNcK3fb8zQucbbbD1kk1GltP6snogBTGzEUWKhUh3Np9cp6iEZ
	 Keobknqo0Qe2CNdC6w4nNWRTyPMtIkRIt6YPCSAoB4jaBZu6JdBJsTf9ldfFonfzolpNB
	 eXMjU6UCMbJ2ApK0nfAPjM5n8vLvt0Y/LQ0E7Ei+UxXLO3Kz6fkwznlOWn0d8DlvXaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793430959;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=o4VAib4sWZJVwEdVvn2PsUOlwVmvvkfLEzixgLq3/94=;
	b=Xc+VAEhWoY3Dc+tL17XF/Cj85762ijMhLAPfQcAY4cgUVW661LhYr/dBlorXJ1TlsLpc
	 2pPbAwHFdZrBpqE4h/w2DoaAW3j3UJaSicv7008L56lCVNwowKti0D+23b67OrA4YLIbE
	 suGfIDHc9C1MHNF0qXAZnWc/lSyLg7R7n9pzkLpSYC7JEWHOPZozVPN2BZkM7hjH+h4Oq
	 Q4CNWM//IOm2GD4DZ8AQHMWoN40WsvpPJ3eqaxtmzuTjY83917IG94yqXjzbxu/etHTRu
	 k3mqBV6ARwR4PZC5+Q8QYIOPkcJQjT41f3yP93MHWb08mXxrg7aHGNosRMO0YE6jolA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=h-partners.com;
	spf=pass smtp.mailfrom=h-partners.com;
	dkim=pass header.d=h-partners.com header.i=@h-partners.com header.a=rsa-sha256 header.s=dkim header.b=T8n7s3Zi;
	arc=none smtp.remote-ip=113.46.200.220
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFC9606A31A
	for <dm-devel@lists.linux.dev>; Sat, 31 Oct 2026 07:15:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EFC9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=h-partners.com header.i=@h-partners.com header.a=rsa-sha256 header.s=dkim header.b=T8n7s3Zi
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=o4VAib4sWZJVwEdVvn2PsUOlwVmvvkfLEzixgLq3/94=;
	b=T8n7s3ZilCeQ/6cccoko5kLoYxL8PSYdLMBz9S8Y6j6gYtpKr8476jizDkAYB9vokyT7DNWbq
	Ekm/0c4gme8GAxQEn7TTCBAJjR3nso1nCAEVKhgzYLJZIBmr/3cl2bf1HwhqN1uYG28zCj886gb
	JcTExZ014FcqJYmFQxM+HXE=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jGq4h3hWzz12LCd;
	Sat, 31 Oct 2026 15:15:48 +0800 (CST)
Received: from kwepemr100001.china.huawei.com (unknown [7.202.195.168])
	by mail.maildlp.com (Postfix) with ESMTPS id 0FD464057F;
	Sat, 31 Oct 2026 15:15:50 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100001.china.huawei.com
 (7.202.195.168) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 31 Oct
 2026 15:15:49 +0800
From: xietangxin <xietangxin@h-partners.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski
	<bmarzins@redhat.com>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>, gaoxingwang
	<gaoxingwang1@huawei.com>, huyizhen <huyizhen2@huawei.com>, xietangxin
	<xietangxin@h-partners.com>
Subject: [PATCH dm] dm-crypt: reject integrity_key_size with non-authenc AEAD ciphers
Date: Sat, 31 Oct 2026 15:15:08 +0800
Message-ID: <20261031071508.1999545-1-xietangxin@h-partners.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100001.china.huawei.com (7.202.195.168)

When integrity_key_size parameter is paired with a pure AEAD cipher that
is not an authenc composite, crypt_ctr_auth_cipher() returns 0 early
without allocating cc->authenc_key, but cc->key_mac_size remains
non-zero because CRYPT_KEY_MAC_SIZE_SET was set during option parsing.
As a result crypt_copy_authenckey() dereferences NULL crashes the kernel.

Reject the contradictory configuration explicitly instead of silently
returning 0, so userspace gets a clear -EINVAL.

Fixes: 4441686b24a1 ("dm-crypt: Allow to specify the integrity key size as option")
Cc: stable@vger.kernel.org
Reported-by: syzbot+ff132cb52bce4f44ecc9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ff132cb52bce4f44ecc9
Assisted-by: LLM
Signed-off-by: xietangxin <xietangxin@h-partners.com>
---
 drivers/md/dm-crypt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 045face6924b..1cab614884b7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2847,8 +2847,11 @@ static int crypt_ctr_auth_cipher(struct crypt_config *cc, char *cipher_api)
 	char *start, *end, *mac_alg = NULL;
 	struct crypto_ahash *mac;
 
-	if (!strstarts(cipher_api, "authenc("))
+	if (!strstarts(cipher_api, "authenc(")) {
+		if (test_bit(CRYPT_KEY_MAC_SIZE_SET, &cc->cipher_flags))
+			return -EINVAL;
 		return 0;
+	}
 
 	start = strchr(cipher_api, '(');
 	end = strchr(cipher_api, ',');
-- 
2.43.0

