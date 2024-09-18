Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF39F9CB;
	Wed, 18 Sep 2024 14:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726668634; cv=none; b=dPT110NgJnGTGwccv5MW4W53VbOHw8XU/9i2+x3TB9daud1gcoKRQ5BQBz3N5rYX4lVxbjrF0J4ibVr5TtLn7lEv15b3kVsmf/1V3F3uZjAvzG030YKnTopnNGPVXPxsV1ug/aki+YxaQCh5oOOOgYfhFxQvw9HcCOri0OhU0Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726668634; c=relaxed/simple;
	bh=3C11Kerkn3JS+3RbT9u+i6u+X/3/5jlEtqqKJ7FtdUM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=QT/akZ9UMsV5/YlRh9TpEJcI7zIJDj6z+zkByUthXgJQse5C28PP5wJTmoWSs82Loiq22ZDicy4e6dOMXE6kSmtk4S0ngIrhk+gTBrba9IDBSiqA5I/zS7i0IZKOfMDgN6eA/iKtlW/vqUW44fZ9mK0pFg50ljfrYV105QPHZLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=gP7FDy/F; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="gP7FDy/F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1726668623; x=1727273423; i=markus.elfring@web.de;
	bh=xAF+viKco1ExEDRgTKCRdN6qb3Zg2cFwCgxgzdw6C5s=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=gP7FDy/FqBlxA0ipHExjNeeRdZevc8cUBYy25ONkVvC0LvQ4L+OOAdB3e32Yi1Ox
	 qZ/jvYzZLV2jS4aSh5OXUvZXj9i8T4NlWNH6t7ME4deJk1+NZwG5DNQgrnXnDaxuM
	 RIzHZoo5FVnmnjMbahdTmRMHQp4yAmEjxijL3RAlXn7rqXDjugm9pVfp0Hg7I/SzG
	 lMtrwVFdvaCUnNu+zVjplpKS7Igp0YJsTOWk/NtZOwH6zps1adjslKbUioXN1/+57
	 ZnDDAIFOotFEKKMdRUbPhDZczdEm6iaED775v0uCjJ3/7aOpypiUkHAfOA2Z2rsN/
	 9DOK1bW1p8eSo1Jmdg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.85.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1McIki-1sGTdT0Q4i-00oU3u; Wed, 18
 Sep 2024 16:10:23 +0200
Message-ID: <4b4379e6-e341-46da-a951-57b31edf3997@web.de>
Date: Wed, 18 Sep 2024 16:10:22 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 2/2] dm-crypt: Use common error handling code in
 crypt_set_keyring_key()
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
X-Provags-ID: V03:K1:w5sHG1W3937bh0DSYJK74Szc821M+zZ4Rw2ntxxIeCFCxP87JxB
 nr7dwCiFo1hcByuH72ANjxTEsIGcTzFKs5SF85MTkYFXTmxCF+8SHv2hBaXDR2/80np7LWx
 Z6sZXggO3QhkQlhO8BBjpXxAOJTXBD2LK0Ns4FjgX6/ZaDF/6DGSjB15hCKYCPI3TJvE6/G
 ALq5tXc/+VMo9uOpQuGVQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:IFEZA55noi0=;5rQ29AH+BopRb54oFLdibqhwmv1
 LDPCdKnhSd5vraldLehnUEWgTq25jQoOzHHTGn3GHUr2iwnIgy3ZHPPVTD1J27ieWrPRlySPJ
 yV6DE5yKOWuF2iEAoSdkMRpzXGSJjpfdMqTdTYy19UKSafLYqWiKqtbd7x5HJYp5fZ9kvJXRY
 wuDjnMe8dpuGAifK9BIA6h4j9dLKURdNanY3poflL/WySuY/4g3pylb5P8trw2TZSWbZn5YJw
 a4nghBe5YC2YX8SLk80HKtxHYWvpLiI0qUTugKBGVpb8hY7RS81LyX4PGf7lmher5U2QFLkJG
 oHIQGqBuMV4V6IHx7tkfIh69SnBgHBWtkATmkKpHg8qyqY81bKzkxuQhC8E6SlYboToKV9jGL
 jhMYqSEUDOrr87eZRVYFwpDjekNctJ42NrmuoRYX8eIWQmQYJ4eR9WtXzRaelalBj5tvynWT7
 JEEFKIl5ZupPMYDrdG8ipz4Q0+7SvwPkXBDzT4O/vlmWDNynmTWoR4YOyz8t4PFZA01fEW2QR
 81K+AnNLLTdT7nhhL9qLhIvA1gONtj6plxGwGYJasnMNYx0VY1ExKvmsEDYy2twcoPFgSuerd
 5Di3H0JfVj2nz071k8SAQtd5GzHumxGFdbZKLJZ5ym5FIg0hSJQZ8MRDLkFxompXTaDasqN9l
 s/PB9dvz3xCB5NJJMBMC9+X6ZCPKB2JvoksFdyqwMWjSYn6+1OtKHkepFuKm8RsK/r75M/1/y
 FCXqv48SzzMAQjgIwz8cSyP41TWqIPW8QqJix6XSGw07okiAhaNq5GmcQ12bOZPvMoqG+82tk
 Y1lYbEwmlt4hcHHwtrzaT7ag==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 18 Sep 2024 15:34:45 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/md/dm-crypt.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index dae2fe3cb182..3d2247cfd42b 100644
=2D-- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2614,8 +2614,8 @@ static int crypt_set_keyring_key(struct crypt_config=
 *cc, const char *key_string

 	key =3D request_key(type, key_desc + 1, NULL);
 	if (IS_ERR(key)) {
-		kfree_sensitive(new_key_string);
-		return PTR_ERR(key);
+		ret =3D PTR_ERR(key);
+		goto free_new_key_string;
 	}

 	down_read(&key->sem);
@@ -2623,23 +2623,23 @@ static int crypt_set_keyring_key(struct crypt_conf=
ig *cc, const char *key_string
 	ret =3D set_key(cc, key);
 	up_read(&key->sem);
 	key_put(key);
-	if (ret < 0) {
-		kfree_sensitive(new_key_string);
-		return ret;
-	}
+	if (ret < 0)
+		goto free_new_key_string;

 	/* clear the flag since following operations may invalidate previously v=
alid key */
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);

 	ret =3D crypt_setkey(cc);
+	if (ret)
+		goto free_new_key_string;

-	if (!ret) {
-		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
-		kfree_sensitive(cc->key_string);
-		cc->key_string =3D new_key_string;
-	} else
-		kfree_sensitive(new_key_string);
+	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
+	kfree_sensitive(cc->key_string);
+	cc->key_string =3D new_key_string;
+	return 0;

+free_new_key_string:
+	kfree_sensitive(new_key_string);
 	return ret;
 }

=2D-
2.46.0

