Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C86C189914;
	Wed, 18 Sep 2024 14:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726668500; cv=none; b=ezmuE0yZ7U2e63gMPH35PRPGsvHOfBLDGljZj0STlHlUFqKMzkjkO2vqnZ7apAYKkSpgD90es33/j5JXNKG4eUb51YBXBHmDqMxs5iurUCzicLisAXQ971+SmmCQSBYVRxQzWvDXeV3uFpnGJD8vRXeIwriOISjvcwMa7Mjd5G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726668500; c=relaxed/simple;
	bh=SR59Zy5+0H2JkKgz/OJzRShajwpCLZ8pjA8HUTdsCYE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=C9vPQl4u91zffKPkwDvU0AErkYjYhe/Yeijo/eB75t1iuzVO8HiqvuHK+fMiNMs00Zp4k5tin2k80ld4x+kDEqlg2Mku9ailqMRwSUJIUeGSxHwUiUXl1JsHeZP/SGSSd7hAQsQ5kVYCtljMi8l75rgwNz5dWFFeFcfaL4+NAZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=iPidPgVw; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="iPidPgVw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1726668490; x=1727273290; i=markus.elfring@web.de;
	bh=pEmW+piCbVWV20mN7xgHAtfyqql/eYPfht5wyl2LEeA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=iPidPgVwc7e8j1FxRQuKnWlir0Czsek05Gob4msjleTXKIROzBHhZXKPegE5Ozbz
	 zVd+l7wEch3nN1fkVT1SQhKSLxeYObrE98gldx4b8ybrdeI+nmsGwHmE4vxlr4kw/
	 mkA2RfzBgL1RXgPVjFvjXZbh/xDrTG4GnvkCwgTmyt5KxKSgBJ8bVa6JGWXwKls7Q
	 f16fWfnddFTe40fn6UtSDdUi8LuMqn+5SYdplGBAsLovYF4H1Yw/cSUHiHK8RLM0h
	 dKa7b4tBFo6f5PSCzgyzBiDTjUDPgsjp26koJBKM843tU7Af+7hYS0RMV2i70j7ED
	 UjlvQSSfS5mqYWgu8Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.85.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mmymp-1s9dvC3wzH-00h69H; Wed, 18
 Sep 2024 16:08:09 +0200
Message-ID: <ab7f53e6-128b-4c75-8227-b38a10d134b6@web.de>
Date: Wed, 18 Sep 2024 16:08:09 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 1/2] dm-crypt: Use up_read() together with key_put() only once
 in crypt_set_keyring_key()
From: Markus Elfring <Markus.Elfring@web.de>
To: dm-devel@lists.linux.dev, kernel-janitors@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Ondrej Kozina <okozina@redhat.com>,
 Waiman Long <longman@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <68ee5a00-888c-420f-a3a9-a556c19ee6eb@web.de>
Content-Language: en-GB
In-Reply-To: <68ee5a00-888c-420f-a3a9-a556c19ee6eb@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:O5jt9HpoSMIFeehshGrf2vDObu39p8RKz1mnqQeYuS08zJaR/Ao
 C4LWSzrloc+Drx0c72xC8UWRoewf54YhwBgqO1+aGBZAqrrJ+2Hv38H0lZUXu6OHMJn09v+
 eWwW6IDzVi+n3vYl/USLThX48T/lJW6qljSxj58QfFkJtZt06PwuO0r5RezpRjWk5k/xC0z
 O/peMe/I/ENH3bggzlTpQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nuwLnslBJj4=;KwLhJNfMX6ifWY6KIF/utjj9zhF
 3TtHHMvyUoxnw22uyS02ywq0aVEPtz0JFtkcPxiTY9UxCQU+QZAqbru2lipl55cZVQhw+CuG6
 usuA5y0Rcfni41fpzHRSNuzkHH3f01/QKku1BRFNU3m4KHqGfPAeSVEL2ISO27Pnzv0LAxSyi
 NvGD9HfQtXEsDu+y4YttpTDd7ZYeAIVaAxsQNpriNnGRER6cd6P7UqGvya+lUumLIEPAVo6ak
 ZhXS4+CRuKzalxtGXT8hJix6FfiQ1qTeNP75yJX7vNL9l+2KgNUfZWBN2ksxpRNwPxZuSpqhl
 1cLC4WbZd4sCLtkmmdAiKEOTEpO3zqIa7ouz2nNRdwxkMmgRcZer3RCfVU+DppG2HwoO86hAe
 36x1vlwLtU4IsQhOK5Sjrp3klV4HO6OQga4fGhMlq5gJ7uBLlIsAlxoQv4q2LBFPbMWYYzn1A
 HTycWHgmEJPJ2QVPLIP4K6D9oeCupiUHMu2IaSk7AwgJ1cF/sJXRiD1ho1KTP3VbzGQaRzR4E
 i/OViMhx2AOQ3p6L4NyeRVDOShrFTHEAsxOiTODyIHHeNAZ9ou5qtsDTakIC6lFZbkveQey/3
 L1J34nSf9GicTQGp1IJ5M96fQgtIl+sV8ZSdGG1MWVGTThVdhRMUNc45jlPl4JJ1Btd0KX8Up
 qSyhyOQmhQtkTOKcA2sk91QBER4xzbbIFQ//rACgakMb0x8mzNTehWgEcTtzYfHgk/SVFNruD
 j69IEMmKBcvehoeq6PlVLAs+PRTzoA5+sSL3QWjdvTySWWUlmcbvYkFXs8k0tyKOmUjkut3rW
 l3aFd55MyPnkruTtrYyDejKA==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 18 Sep 2024 15:05:29 +0200

The combination of the calls =E2=80=9Cup_read(&key->sem)=E2=80=9D and =E2=
=80=9Ckey_put(key)=E2=80=9D
was immediately used after a return code check for a set_key() call
in this function implementation.
Thus use such a function call pair only once instead directly
before the check.

This issue was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/md/dm-crypt.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d5533b43054e..dae2fe3cb182 100644
=2D-- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2621,16 +2621,13 @@ static int crypt_set_keyring_key(struct crypt_conf=
ig *cc, const char *key_string
 	down_read(&key->sem);

 	ret =3D set_key(cc, key);
+	up_read(&key->sem);
+	key_put(key);
 	if (ret < 0) {
-		up_read(&key->sem);
-		key_put(key);
 		kfree_sensitive(new_key_string);
 		return ret;
 	}

-	up_read(&key->sem);
-	key_put(key);
-
 	/* clear the flag since following operations may invalidate previously v=
alid key */
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);

=2D-
2.46.0

