Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37388528D;
	Fri, 24 May 2024 13:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716558520; cv=none; b=fGZzUziAvKxRcJ1XSKNQhJENbIOKjwh5PG5FDiVGZrYvNSHdXgAEYic1YQDUfl48fGLsg97qe6OEavrEMSdEj7922h0X7vTtHMsN6F7dmN6eA5ECw3DsqUcewLLt25uMmftFoFxN48cRyyUCFaDPJJ41P4Pwiz1wJbizarv+dmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716558520; c=relaxed/simple;
	bh=hueieaLczksDkmqINO5OE5EiLQWKb0+iM/e3znMSFJA=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=SXd5fSLsnForNFeKGmA9d2RAhQKZLS1A7tC2s8fol18m34dzI9g0hbhHpMfLO1rnfNOPhILwtpjjD1xapkzk+DbwzqHJb3ak57KB49kuyF00WRMe34xwI7nF+I1HQUSu8QTBHTJNt2dfLtmqoS4QKXE74lkqUHHJwsNhRTn2OTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=GxaZM0ZS; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="GxaZM0ZS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1716558506; x=1717163306; i=markus.elfring@web.de;
	bh=TKpcU07BCg0puKeOnHmYb8r4j/62KyBnT3gPVl603HY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=GxaZM0ZS8KUk0u8iDKn0jxjQCr6jUGjtxsD+g5VWAGPzgzgx5nuUMHwpdO3RQypt
	 4I19S56RHUNnRpR4jS7kycWLzoHZrxTSipDL+zVPlM/2uZsFw+4GGe5nOP+ZqHsBK
	 yKSiZwxXMkug8jAVV4cxgxz0HAimVO2OLbUdUXwl2QezSXzK8pZ6SXSs7ZghgXT/h
	 nToxtfyG/0fho36ZgO6j8/bGkaE3NA3p6M2TgD9/+CdxJtu7hgFYIflgkiSLQ3bv7
	 fDHZcoEcyF0RNB9nrlLkFps2FPId87VAA2J6Z1LzC9zTn/SfkuOjJ483Gjd31ky4k
	 rRTNxBWG2SgEU1TwpA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.83.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MuVGC-1sSa674Byk-015riH; Fri, 24
 May 2024 15:48:26 +0200
Message-ID: <085b205a-8658-49ba-a8cb-8ffdba9d7a85@web.de>
Date: Fri, 24 May 2024 15:48:25 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, abaci@linux.alibaba.com,
 dm-devel@lists.linux.dev, kernel-janitors@vger.kernel.org,
 Matthew Sakai <msakai@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20240524074109.13433-1-jiapeng.chong@linux.alibaba.com>
Subject: Re: [PATCH] dm vdo indexer: Use swap() instead of open coding it
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240524074109.13433-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:CwR8mjLaFQnjS76aTyIm0LDeX7mE5+Y0DmhvsARq3yofsW07HBj
 XVetph+zxrR1kLjbVa7noUXMRHfLtJRwmog6Kk1KslKiqasrwtVgdbf5ldE1TJD7Ct5ETzK
 eeTWkQ4Qjw7UY/RwRqMy5oA4n6ciG0Oat3nOetnRJx2ZDIanzP/2f8xwwk3LHc7lDUhpcVx
 ZO6H+xEleGpoEf5lhVuXQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:8nYy4xaiB90=;DW86oxmgOlM+5rGN6og4i9f/eqZ
 s29BRMsR8VHowjsb4NBGxcY2vj5do+GfcSahA4BQpSnWvuk6ObrX2kC+qqcc7D5Y0R+yxKuBW
 5BnFZYrE8QO+8e9kyUXV/ng5Ku90FuO8gMVx/Bd9mIuKL/zN8gWjLpZI3Mkx7EMZFlC4cKpXL
 3/1D3dcryc9hiXieTWaUdmT3W6gg6wOPoF+Fu34/Qg/aYxhII69fgFra1lsvJIH2jfL5a28D8
 Bwj8pyymS7u0R6j0ay2UGxBSq4Fxy3T8VAGqOKeu4U9IAHCPJAKic4D9FBj1cXE6Vd/04v3HO
 4g1X77glYRtrxvR3iLti2+HdX9KSN7cYyA3lpjMWyBmIO8/LqLA3V41g9ZDU4wBwK4cJeXFcL
 xVi0fuKW2CsKX+6Lmkno9EcAVtEKSgaRhMHSgISBbdCRToyc5pWVsYzyue/8Fg6TiJHr3H47w
 o99b92X9NyArBUYGPez8go5+Ltw+oSmzkyAQpqnYj/Hv4JqtDgDg/iwX1FUP03yr9cOtlytxB
 aVkZFjxF+Zka0hty/jSMpXc102dxxvToqYw3sGoWTCFdFN/dkMcd7EE6laAkwp57QVktK4b8J
 DKUb7uSHyDTIyPRuOORntHPp3+D01T9cAlO9uAx1w5UJNCDnZlDumLLRPgl43U8vEe5wislEt
 jawv7Ob9bvlm9ivvooBOO2Jl6mmvBNhJn+4ZbiuHHh31axAJUAceU51r3PblbHZ3R7EmlbAJ1
 pflTe+x/G9BHaX9BZdRYl7MlqWl47DUXnOlkkBXVdEFby69FlGq7FByrVtE7ZOSj83LOi2C0F
 JdTpTuxf3Sg0DzB2mIUQuBs3dK4k5SAXE9NRisgW/jbxw=

> Swap is a function interface that provides exchange function. To avoid
> code duplication, we can use swap function.

Would a wording approach (like the following) be a bit nicer
for the second sentence?

   Use existing swap() function rather than duplicating its implementation=
.


How do you think about to apply the summary phrase =E2=80=9CUse swap() in =
swap_open_chapter()=E2=80=9D?


> ./drivers/md/dm-vdo/indexer/index.c:207:43-44: WARNING opportunity for s=
wap().
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=3D9173

Would another indication be helpful for the involved analysis tool?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/sc=
ripts/coccinelle/misc/swap.cocci?h=3Dv6.9

Regards,
Markus
