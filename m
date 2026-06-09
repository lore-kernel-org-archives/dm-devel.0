Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA838374A08
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 20:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781035220; cv=none; b=AvKQow+m6PwE+ObYSqNPgZQX0qq2DSEaPhsFyYtfDdZnahhdybcwn15/vSG9ZMDndv72ZTCpbeKwEZr9V7vEhbubcFmLOOYZ7FMljVJ0JtGm5/id5hVRjPjMBwNPv2SiVOeTblGrqDxe/c2KERGryrb+/M3r9WeMzaM0R46hdOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781035220; c=relaxed/simple;
	bh=d3Ojl2J9Eh6pSzEzSwy4XvpgQgIOLC84iXCdL27OFhE=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=dR5FKXk1xFr5Cy7AMp7WWgBEcgN37qj2dikuFkqh80UeBvgZsTGXmzqQ/hIVrCpKD3K/8qiU47Q3BfJlzYWe/Cbj28aK7J7Y+duxfysOy0ciW8ipq/aB3ktGkJlhaBOgCoVeVoKpAkmvZmQzotWbo+F00a4T01wniBLXJi+RYKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=CIM7dp3L; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="CIM7dp3L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1781035210; x=1781640010; i=markus.elfring@web.de;
	bh=nO25cz23RDi+ks4TKjnLsjpu8ytftuauBdGA+BV+Irc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=CIM7dp3LhnwnycSUfMmktE1ODpJw9W7sGV3gJ06vM1GAvjsIx3Wjj98zymFhTdkk
	 ObMOnGPF4Jqj2umHUHi1nYXtQv6quOkcQo2ZwJyo3z92SKkapeuezMOLndpLJ1bcH
	 kd4rGr5p3ej9WKM2G14m6kSPB6j0Eyn2v5QufYLwPA01dv8LUrt0C2JtV6oMjEW9D
	 CNLYpSm1vmGzZBbjDvfULra1uW/yGkszqj5UXbnLTlWydWeFxmFNkrAxgNZikSVZn
	 Aa4Q2p0UU+ZHeSJkYzSFYRPEjL4aEQaex5RblTx3RzI3pXK728r6SwAEx+eSmcL3A
	 fKYGmB+lxOl3vaKHtA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MnFyI-1wye900Zfg-00iOS1; Tue, 09
 Jun 2026 22:00:10 +0200
Message-ID: <be375668-6d07-4070-9b08-d6445afa324f@web.de>
Date: Tue, 9 Jun 2026 22:00:08 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] dm: Use common error handling code in three functions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:g5g8qXkMeHknVOK+pyp1K/1sRqq/3kceRGAd77LAtEz728NraP9
 o2ZTSwPoNDnJvAVbwjhUzkV7UbrvZ82G3uQXVmh84OvG4yoYy+KhtbeXtn1Lh2JDXaOoYwF
 0695gI+W6OrLAnEW+JGi9pwvlv+2SoKDOkxKIZQaTFggYH7ERCmII0ZUp21CJUW1AMlyq7Q
 vi5IoP8HDKZgzqF2y0ovA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qW/y4EnzFTM=;oj30uSEH3YAmMDzecebNeGVbMd3
 QLaRa9Q7RxvIfd+bTLWSffQ3uAywaO2BcoPwpslIJRPtUWYARahvSyUoCquxVyM+U/SPNc2mU
 uzaVWC57EU0sy5MW9nPhVLPKrwbWxNcl83K5t/32Itg8a9skzF8EQY5yAb8QuE8YpHlk/P3aC
 tVmALZstT5HGbDoiSSwzWlLEcVMNzk2uL4ZFrdx5Q+1dWFhvQKtMnn2lPWHaC1gU9WEHRkPBe
 c+Y0NQ4yg6pwoIeMK9VD068e53gLrwu3X8FZeigWOPLsIBr+ItmIeaZucPTybAExyPOGHH7rn
 /QUURJiY9h/wuJg2kqSA/2CDQwL7Od9fUCldtpwcH/iXDiUPPwXtvh60IZMeDJFm2NxKOY5gt
 +/b1eXYvEcYogAdw+H7DjS5N1KE2IwwvGl2Rw0taNFdJgKHJs5Zge9H4TU6K7aA0Zpkv8/VVK
 D49RDRKKVvyBtzkZCuBNjBDcBqEAKBPZxC3+YCyXITgIzf2ZZSUt9drHmL16vRJcNBie8EKyu
 tBWiIEdHLe1sePlmU6JuXoUqA21ib58ab/dTOSezy2jhdHQRolToDdOvypUvgYtGaooOHhtyG
 adW8uBAx6rLbdRKNRwRmwy3Tyn0nPEYUbWsVs9rApEnHRpDUUVmA4+dVnZsIk+K5PEFgSNeGY
 erMK8iacZYlfeuhVBaAMxMN/otvqAuTXhmHB/6c0mDBA92xwNc8YfAz4S6Ie+kmju+LlCQ4rt
 oBBnaQlbS3cgEnqWaQroYD1oGvCj6HLDxwRukhNdkz6QYB53/mvah87L7aNRHg5d6LAKaHJ7P
 R4WWHYHanetfTrjioB1SAskSCu80DVI2XlvGQc+0gQE2WXDpEISkGe0axPBYNPbNqzZBhUh55
 8Iv3smYTmsK8blKf9jHBqG5EAMU3Un/OVkyuKGpbob3G4GWkPivUXXl+pXKhtj1S433uCQnFn
 pFzCGSRZoySpKszpUhK8+ZO6g+Gk70ueil9RsGXyXKk2C9oKtPLVKYoiQGiSCZJYsvlJ6gcVM
 JTPrSCkVmxcYdO0cuTvSR2FPYo4KbHjyOVWDeV31vc7EBOq+wh3GeZ63lN9MeHsIiB/JuLkGH
 xqMXSYLDQKuD5Wk52iWtKVKvCCoL469Mt8xsCtFEqC4FHWozuQ+BIempVkRdhLHj1/CUZOwHa
 dYsC/Snu4D9Xf+tZCoBlPGClX0Vvw9LgFgmzud28bmpR5jBWI9H/SETl8i0JbL29UdH3qLxx9
 3PEgkn+IHdHM4YaYfIf+U+NspsTQIbygBL2edYGkJ2Cr8yNtEZvqdx/r2GcTcW0OpOzrE9LW3
 i+eRmw+YksnoifHJY6hYp2ENafGeXnhbiM1vm7L0QIOCim6XWnR1Mxibn4xpqvDp8qe/2tMf2
 8/vrGpHHKcfGG+QXacXcKiAadC3d/VJyNiZtiSep3dhRKg/ejMBTgc+7nNyVQLiAarq2XdBBc
 Vww3CasrOKvCqf1iqs4QYsMcX90+4kr0o2xZAXSAk/PFC0BCNHD5fWxvi3uBBRSFyU5NaEWjX
 ycOQIw2DSSHvZqccQP9jTjsnpt6aU1TjYpR7VSOEP1qHDmkOoQqMTzd2bnGZC5stR5SY5uarG
 pKMCg33k/oci54iLeXUAy3Kz59xeiQhkixwU2csYNji8Eun9FRGhVkERyRTs24lAXkNYO2P2I
 a28O/2iQmnNkNYfi3TVqQglGzD61Yape9/tIYpiAkmcZKldlCFbVXbR2tvzcPaJaV6NdE1Yer
 eh36mxmC8mDaQ6ykNbusJ9qX1csfvJfknYlSl4WuhqFzgZgr4A/oIcrjpvVxXDjGdjr4yVStt
 HqmuwqFLqHgPd6WpuXm8SfGa2mf55sen/wjp1ppJQJPaCeIHAFZxigIoWhX3orTC2YiYNeLSJ
 NfMO8ljACSV+TP0iMSPUJH2NgSPsJywokbBmLcrsAXz6ZRQV+00bKdIoBHTo8gvAv3QZtMdZJ
 KcH0ZKZ11fwAqFFPEwH3sXGvxGiF7l4sdKARQTnKBk53LfnTc1CW4vZdabluxm+7VxiS/duW3
 fPGrWqYNHO9yHIkDfbAQjRaC+JNbIKwIMVV8eEWy+l/AYWdAS55FEzE7kvpqj54zHB2z4EUth
 LPEttqiqgrrcBncTAMZThkucdB559AgFO+nM1m8+PqHQn4fpTNcQVeNuo5mY3GPn6VFu2mcBb
 hSwkJ4wakhC5bn0tkq7scjsOntYou/HZzK2UfhCrF/iGTMJetVFhlYH184d9UQL9lRwl1+kaA
 1ulRQXbuAtHaFj9aXEOmRqjbXHi1kXC3aVXaSopiUJStGux6jjNz91oZ5Cvmw2qL7u85w2Nn/
 rLW/5EipbwBY7VM63hbV4gpYnmw6r9HlfjC1b4LiqfMOR8LieVMuZA0r3jpb2CK/o7+SWetA+
 iIVsVATE3THbzAcjVFQKxN1PgSFC8uEefWx/j1Y10gAsTEp4moMFIk3qtmU7Iblb3HR/RdJ+8
 o7ndpiVxoDmerlaD7aVustyCcSbi53jaHhAEICT1N3BYCHmXPNo5fmQJDWCDqpSiLoG0FxPNd
 jePtdKa9+41Q4sC6FglhEZ0FJCm/lhCk16KX47PYEp/afOrr4GN6kVEQvCrRoxKr2oeYnOIQR
 yE8zIuPhbwPXaKMBUeFG9XJBPbCXab/8lrl0wFKfjQ8fy9d+XcJvkpI2+9GsKPaSX3j7xPvEF
 uzZSGEc3LEfDoWh08d9SxCmDStIbStvQbwL5HmxmpkdSsR49zLdGwUd0GPY/krGYhbbuI04YD
 woXVtQ+wAOpLqv7kxgLrvMvo0tp08JfsrU7jcrPW5PdEltuxz9Zv2WLeqsqT/NcNLBfLalqil
 vcZrxwYmd5N6gwh9f9OKYT2esekcmiquL76r0lsax1rEX3jOJUq/ol9JBb0nGPrl3WqZXeOq4
 JSExYaxtl7TSZTDxG7uD0lmLy+bOmgyYTpXV06ueuVIbGHutIu2to3YQ2McwnsscciZyu73Db
 1nFOlpc73k34S/cmD8GCfXlNJzzd9Q7m1GtoLTQEvV83RC+Qzpxt8HRrV0jAI9dudt8PCB4B3
 /8zJhnfS82MY6tIDTjvNt1WvOsw6/dloBVITUitkvlC1PsJYNVFqObuP4lCW+SDN2w6tkYNJG
 HSW/YPOkDRHpLzMpiRKs2jbJBUtwFco7VCSHXvM+0KxJ6OQd1q/M0TxULo994ICHinsOCxFXN
 rTzLbCDGjzyQDp/iQa+G4ZU/2DJcx7gIyZrRAk4yud9bU3xfYEairGp2D1+RZ3TUwffcFX85C
 RU5x9chPe//7MVHZu1xyzrplmwQ79/dyAYfMyoCZo3RlkwIyrYamRN8DB76SLaUUJI27velOv
 aHEsdKI7nCzwJ7f1ySa4eTVQ4ZcDd8lqfKw1q1GeEZKJqQU4oemE4uJ7gtMjTIPWzS8LC3ec9
 RusrmWRGDyboO/OvdjONn+BmAkxSC4HBQiAdjT8Wek8m74aWEDbtGySN1pfGFYVHimDyppVk9
 TgTpfDmQNtBSoIHywzuH6TB4CO2Wx2HhF8W9xRtB2SMOxTLMhSbUWBThCubfpVfQP5ZjeVqKk
 qU7zXNROwTCdoIB0IZfMuVI9Q4TczhDVSK7nSfMAMmXUKH8Kuv33Yswf2d18GMhuZ9TejubkF
 PwUw2UhMyBDTF3Uq9gsqsXtUwz66u7yMj+nrG2YaUgRJ9ofy0F5i1bBemiO/SyI8TCOSn/APz
 YZ3jC9Yl9mipJxxk9gvA69qKdtGEbe12rOfWpaHRYihU1Lh2wSdJVzJBCCEQMGNuLekukyM90
 0ki9dcw5PSxSn/hUgpRMXXRnPA0tTpnN0igy1NUDNl2GTvfJH0MiHfJY6S8IE7a/hUObv57Gy
 4+uSE2jHSMeXjrI4QDcPlp9yr2b0rxI4ccPpWvmYYLvFhVaHLklTlrO7TniFgthCHuI+15v2h
 37CZPkT5VR9X7pbeNttqMREIdmrT7ys044v0K5pmhjAh8EFGTLNK1bs2eQm9hdQ3tOyZubPVO
 WIoqsKLKqdTWlSEAu/DY/jt6fMd7q5odfGgT/tAdD6NH+ZK254lBbBGOUugNvHhVHgYYVHQa5
 jwjIUweRpsWss5RVIVIHQZ8kBjaNI6QVNmeImwefzGa5on8HQX6TtD4u8v6Xig1uwqgurWeZi
 9ut5zdD4UynYHENWmTYN96TnZCbITYde8rL62uzAcsmFEiCLcyMSt8O9tTqinwS5v7nU/JFI3
 wplXZHR8MSyuxlTHbnYa8xaXD28EZVKTxE76e+p/uNBVNDFdpaQQF2dStpAjCmGUBnXtQv3dB
 GT4qZ6GWMPcJRatAQ6Mix9pLRam2rh36I05mMhLVaze5R1vkwvinTycWru9drPAMNXIEcATYM
 Z+Bi1FsQSce+ul6s+ha1gFV0VAalNvskeNj1s5toCFNNPgJAjuPDjA9uTxp2cU/Bh+GntP7Uv
 jF05/HCwve7bvt3eNkS3tLYGfPJ/67X+XO9uL4NAyM/TdnV4+cSBRGy+nnDAoUP+mVIOvjrE2
 rwbp7+4HEZ+aNeWWQfCjwsJOgiPcQ6cRaAXfWOm6SJtrSj3FQMYTP/GaSBK9Eq44TCAUCHqjU
 X+tH698phjnFlGfE+kgibv40nZWEo+FALkC/UUV/th6e/AbS7S7xmChyizxgIDDjrw47tT7+2
 TcvpvgigUlabaPQwhRgRyawVdAOqBPvDBO2ICgwJxlipvsptDiE67XnfrItcoYqiV6evJEeu+
 cerr+HF+oHguq7iDzAweUEuiyGCBz3e6+eQTYgB9V5EJHOepuyB/Q2tVdroQb2/96WVcTgpPg
 B6NvblpFZNHwvCKbccyO2cccSrYVADivXUh3luUrYOQuTgLyNpqXOMlk/Zp1mkB92luHJfS+p
 8yddvtEuBqIgDNMew9m+IopyfpOknhJ6jAYwMH1OeTmXokcF1KKE2JO9wHyFLizRnxsKhSZog
 +pDXN3nSYMmWGHwuY5liF2RU65JWALoz+H1f/gsE4TciWIIaxTlhnfFBBo1N6ilDSBCnhmXDE
 vyQTJtnmX0vxiIc0VmptZdUrlyVDS4DInAggXP+d+8ahJHvSHBa3hk/OrSig0x/sC6SgH1jwL
 gVCGIxZBywmxisq14AJaWlbNa1toVI5HrhdWIAE7Fuz8z37f9gK7Nwr/Foaqtlid/sGfRHFRz
 gAHLDCwCk9F6KbjurMty3X4/ofEUyDENznM+aHkgKUGiYKVQhePwcCvsSoXSCNFwHsLHxOCE5
 mQ2CesZjPlY9I9fsi+stHR7aZKrGao9FVpqPc9nwIPGvCL79WwhmLKRyXbSeqnOfL8+Twh+SW
 2ojQpb30RLpyfStlGOrY7hEacunIS79qJLfnLUouBUE7RqUPX/vu5KnX6+WWNJXFdIA3yg/hi
 EkpahRY/41IAVVbt0QV1no3qGvZnviJLrvlA0RH1rvXJu45vE7PPTlZO8r6NQCsjxR6Vx6ER6
 GmtjGZn+1I3QQYFP/1nDu5R7Rg5sW55lrGXpjdsR82RThlP58IDT4GogoK6KiE4oek6WgflV7
 VKo2M7WuVflXJjeQEp+gZhI5wbgl8rTkX4lojHYhqpVpQIarMR+hKMoCm3oM/TpFugjR+6HfO
 ouC9jju8oOmA+0az2/bkqtkZH+gsP3+nOTQtjQ4zUd/Ra50/

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 9 Jun 2026 21:54:38 +0200

Use additional labels so that a bit of exception handling can be better
reused at the end of three if branches.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/md/dm-ioctl.c  | 7 +++----
 drivers/md/dm-raid1.c  | 4 ++--
 drivers/md/dm-stripe.c | 7 +++----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index ac77dc0ca225..9537e60f94c3 100644
=2D-- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -227,10 +227,8 @@ static struct hash_cell *alloc_cell(const char *name,=
 const char *uuid,
 		return NULL;
=20
 	hc->name =3D kstrdup(name, GFP_KERNEL);
-	if (!hc->name) {
-		kfree(hc);
-		return NULL;
-	}
+	if (!hc->name)
+		goto free_hc;
=20
 	if (!uuid)
 		hc->uuid =3D NULL;
@@ -239,6 +237,7 @@ static struct hash_cell *alloc_cell(const char *name, =
const char *uuid,
 		hc->uuid =3D kstrdup(uuid, GFP_KERNEL);
 		if (!hc->uuid) {
 			kfree(hc->name);
+free_hc:
 			kfree(hc);
 			return NULL;
 		}
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index de5c00704e69..359ca80a67b3 100644
=2D-- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -915,8 +915,7 @@ static struct mirror_set *alloc_context(unsigned int n=
r_mirrors,
 	ms->io_client =3D dm_io_client_create();
 	if (IS_ERR(ms->io_client)) {
 		ti->error =3D "Error creating dm_io client";
-		kfree(ms);
-		return NULL;
+		goto free_ms;
 	}
=20
 	ms->rh =3D dm_region_hash_create(ms, dispatch_bios, wakeup_mirrord,
@@ -926,6 +925,7 @@ static struct mirror_set *alloc_context(unsigned int n=
r_mirrors,
 	if (IS_ERR(ms->rh)) {
 		ti->error =3D "Error creating dirty region hash";
 		dm_io_client_destroy(ms->io_client);
+free_ms:
 		kfree(ms);
 		return NULL;
 	}
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 750865fd3ae7..58fa0badc90f 100644
=2D-- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -148,10 +148,8 @@ static int stripe_ctr(struct dm_target *ti, unsigned =
int argc, char **argv)
 		sc->stripes_shift =3D __ffs(stripes);
=20
 	r =3D dm_set_target_max_io_len(ti, chunk_size);
-	if (r) {
-		kfree(sc);
-		return r;
-	}
+	if (r)
+		goto free_sc;
=20
 	ti->num_flush_bios =3D stripes;
 	ti->num_discard_bios =3D stripes;
@@ -176,6 +174,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned i=
nt argc, char **argv)
 			ti->error =3D "Couldn't parse stripe destination";
 			while (i--)
 				dm_put_device(ti, sc->stripe[i].dev);
+free_sc:
 			kfree(sc);
 			return r;
 		}
=2D-=20
2.54.0

