Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E234635DA6F
	for <dm-devel@lists.linux.dev>; Sun, 28 Jun 2026 04:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782619464; cv=none; b=aGQTnPwk7x11g5ng707eQrsRnjfyxhKE+vHLZWZ107lhrHE1k6QJXzsTOovN2+0ikQ0Y1lKV0A30HkK/Y0rMBAmalrvmPDeDGhhVgfFf+4lzb7yb9HNa7NibQ0MigEAtw+TS+Qea21laZR90joo7kqfwPVj99XJtFWKGWwzBjR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782619464; c=relaxed/simple;
	bh=w5avZ3EhGzBAg2no0Km5j8U6/EuHqB9FmN7RAsBv7VA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=pjgna2pP9YzJ/k6CCdK44ZGsvEcZtEy7NTSJ482n0xNkiXtRnH+tZW8l9rvrUb8jXZeJZnweLwE9zzxH2uj1BL0sG3X7aNn5KIsDFiPaiBp2sgRaU0dLJwg3zjqOK8+VM0dCijYRpb/mZ5JI58igVKoULYqnJwoNPPZsu4oDNM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from smtpclient.apple (unknown [117.182.74.7])
	by APP-01 (Coremail) with SMTP id qwCowAD3j8h4nEBq+V6qAw--.55335S17;
	Sun, 28 Jun 2026 12:04:15 +0800 (CST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.8\))
Subject: Re: [PATCH] fix: md: kset_replay: fix use-after-free after
 cache_key_put
From: WenTao Liang <vulab@iscas.ac.cn>
In-Reply-To: <20260626150845.50456-1-vulab@iscas.ac.cn>
Date: Sun, 28 Jun 2026 12:04:05 +0800
Cc: Mikulas Patocka <mpatocka@redhat.com>,
 stable@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BDB2CB1F-6FC1-4A44-A6AB-F12F7CD625CE@iscas.ac.cn>
References: <20260626150845.50456-1-vulab@iscas.ac.cn>
To: Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev
X-Mailer: Apple Mail (2.3826.700.81.1.8)
X-CM-TRANSID:qwCowAD3j8h4nEBq+V6qAw--.55335S17
X-Coremail-Antispam: 1UD129KBjvJXoW7WF17Cw1fur17Jw4kCF1rJFb_yoW8Wr1UpF
	W7XryYg3yfXrWIkanrXw10vFyFv398Jayvgw4xtw1kuwn3uryjvrW2vrWagry7Xr1fGr43
	AF1UtFs8Wr1qvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBEb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28C
	jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI
	8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2
	z280aVCY1x0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2
	IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r1j6r4U
	McvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIx
	AIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07j5zVbUUUUU
	=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAAMA2pAiooeMgABsE



> 2026=E5=B9=B46=E6=9C=8826=E6=97=A5 23:08=EF=BC=8CWenTao Liang =
<vulab@iscas.ac.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> When key->seg_gen is less than cache_seg->gen, the code calls
>  cache_key_put(key) which decrements the refcount to 0 and frees the =
key
>  via cache_key_destroy. However, execution falls through to
>  cache_seg_get(key->cache_pos.cache_seg) which accesses the freed =
key's
>  memory, causing a use-after-free.
>=20
> Add a continue statement after cache_key_put to skip the subsequent
>  operations on the freed key.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in =
device-mapper")
> Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
> ---
> drivers/md/dm-pcache/cache_key.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/md/dm-pcache/cache_key.c =
b/drivers/md/dm-pcache/cache_key.c
> index e068e878231b..c33d6b37f58d 100644
> --- a/drivers/md/dm-pcache/cache_key.c
> +++ b/drivers/md/dm-pcache/cache_key.c
> @@ -733,6 +733,7 @@ static int kset_replay(struct pcache_cache *cache, =
struct pcache_cache_kset_onme
> 		/* Check if the segment generation is valid for =
insertion. */
> 		if (key->seg_gen < key->cache_pos.cache_seg->gen) {
> 			cache_key_put(key);
> +			continue;
> 		} else {
> 			cache_subtree =3D =
get_subtree(&cache->req_key_tree, key->off);
> 			spin_lock(&cache_subtree->tree_lock);
> --=20
> 2.39.5 (Apple Git-154)

Please ignore this patch. I will resend a proper version after
learning the kernel submission process.

Apologies for the noise.

Best regards,
WenTao Liang=

