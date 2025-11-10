Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52A72F690D
	for <dm-devel@lists.linux.dev>; Mon, 10 Nov 2025 12:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762777966; cv=pass; b=DaNkSgt9qaPQGUbLnXaDzDdpdGteXd4smY4250nlstdP0ce8NpRQy89Uo2mIE4Suts5vF8viUzIfkVadcc705L8sGG0tFc3Vcg3OnE1OEm93PM/C2n4M22Xqhxq7re2fmk1MPzLcqTMKxrAKYoQY9V0Nt9vihEWWKcIfPn5pPrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762777966; c=relaxed/simple;
	bh=QKxElmVfoiOAXfnBwoTX9K1viGokBpnNvo3nFZSjAOY=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=D02Fp4ljKwYBd5WrRZq53nqvskqk9PNcUgpRJFsf83anh/B3hYp0I6rkhIeRNfiNWN2kyVEG/yfPJ1TMkhxW4aBIN7MEHl9Z1tmPI1DjIUu731BxPDTnb+3nsXDIj7YKB9GoSRS1UcgCZGesc0Ty96WQEPFpFBSSqaioJvFL3xE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=RbriZDXL; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="RbriZDXL"
ARC-Seal: i=1; a=rsa-sha256; t=1762777962; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gwnobjk4ALDFiUj4thJPDJhAOU540WBmZk28myUSmvKs2M1Oe90XiLpLeaIPu7P2lPzRsgz0iBZSGcWmkjuINZOhTg1YWCC3g8eanQPNpmFs7cUwTNGk69g4LI4qp0syvWkKMJfk0GRZ+KcDidxTwqkHEB5f5OIpR1daWxqw/2M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1762777962; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=bJSbfoKTGDKNGAzBm563TFQcPM7duW0xlowY32Azhwo=; 
	b=eGHo4XaAjw02UlJnxxmmq55GBkgVSotvNfF7zQYQl8sS5kokn2Mxqxk5jInWiJXP+Qa/8HoJK55I8EC5JdJ8Wc1tEmslvnXvNxUdvYwnsUAd1tqR4OhKEI8qpOvu9ihpuc3VShGda6VHLLshP5Vjxi7k1P0P28Q/mEfe2/htfms=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762777962;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=bJSbfoKTGDKNGAzBm563TFQcPM7duW0xlowY32Azhwo=;
	b=RbriZDXLEa+ZdFpMgx2Yxnk6gubnYkRZYpvkaFQw+XaIbnlduR5BIyL3JT1q6Jgv
	jKKhS+84lXq/ENOkce51v7ca8OdcrHIfgXpZYeDxCBikLVBSRNrOk7puoB/YGh4cWo+
	TPnevYuC9AxyxLTyRTLlyQXvlAqbtJu2t6v5ptKs=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1762777961320919.5363909379608; Mon, 10 Nov 2025 04:32:41 -0800 (PST)
Date: Mon, 10 Nov 2025 20:32:41 +0800
From: Li Chen <me@linux.beauty>
To: "Dongsheng Yang" <dongsheng.yang@linux.dev>
Cc: "Kees Cook" <kees@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>,
	"Nicolas Schier" <nicolas.schier@linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-hardening" <linux-hardening@vger.kernel.org>,
	"linux-kbuild" <linux-kbuild@vger.kernel.org>,
	"Zheng Gu" <cengku@gmail.com>, "dm-devel" <dm-devel@lists.linux.dev>
Message-ID: <19a6dc11358.18a71ad4233219.5584291515890233315@linux.beauty>
In-Reply-To: <bd04f307-7f83-41f5-a1ad-afcd8d2a9237@linux.dev>
References: <20251105084733.3598704-1-me@linux.beauty>
 <20251105084733.3598704-4-me@linux.beauty> <bd04f307-7f83-41f5-a1ad-afcd8d2a9237@linux.dev>
Subject: Re: [PATCH 3/3] dm-pcache: avoid leaking invalid metadata in
 pcache_meta_find_latest()
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Dongsheng,=20

 ---- On Mon, 10 Nov 2025 19:18:38 +0800  Dongsheng Yang <dongsheng.yang@li=
nux.dev> wrote ---=20
 > Hi Li,
 >=20
 >      It seems you sent the same patch again, shoud it be V2 instead?

Apologies for the duplicate patchset. I mistakenly included pcache in that =
GCC plugin series.
I will send the pcache v2 patchset tomorrow.

Regards,

Li=E2=80=8B

