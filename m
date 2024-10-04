Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A99231C91
	for <dm-devel@lists.linux.dev>; Fri,  4 Oct 2024 20:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728073042; cv=none; b=ndndAlb1mMiFpwQCKNXkYMELQX78Rmr2X5DSleiD+1I50Gqs3bI8XLsTQSXo4GPwSg4BdA32Y48VNXzWWKVCcvNsRp+F55/R1AHiUMhg5OfMYG+qHvLojf+x3mj6gj/ezxl4uylMGnYbMgFKFnvflRSgu5Hr3qRgsRtpCZxxcGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728073042; c=relaxed/simple;
	bh=R7ofc7BUsJgAI+HbPx78qvcddXfCuxMxe24ralzHk3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=clrM7gk9EgXj/dBTkyqE4/MT1tv/SjL5KUAcXt+PavG4VvNTLQgiY694HISib3dO4OxuizmU4JEp+fsiVg2dCBBpdKjG8yLV8bVk5rGzAK69dnnvmou4hgJruOFI8zrfUmV3aaPC5Y7FmhcPri8KzwxI8Hy4Mc94VxaXSpCI+xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Mvpix5kL; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Mvpix5kL"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XL0Fr1nR3z6ClSq7;
	Fri,  4 Oct 2024 20:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728073038; x=1730665039; bh=lTXL/Dz1oBJXvLrR6pwgSAxa
	29xr1iIqzNXMrLo4jNw=; b=Mvpix5kLc2oIoIqW6o4Vhm+p8em9/ylzV3bVFoUC
	NPoQ/+UmpIxqLYQYV4FgldlcePzY4U5qZ4UBmNwnRPkitT5+WPsCpOWQCGMkF67f
	MusmS54gFpulmGDTn+PitK7+yUPM7wmqdgOZ9OL8pw7QjOmNesdgiLXJm8FBizxM
	xnd/4do5KbvSzqXz3s8ESRb0IISNKtRnKTry6nEhxeVguuFaaCAXFpuVgDmn1avh
	aMaQejNg+a6WDgYY9U4wuKwjia1c8GM2WsC7Z1YPJB/yQqQ2iWuooquw4+eyPKBr
	mQF0sTxKmFQKemUtW47MheXwiEfYHPKJuQC4ylF06iTK4Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MoKYJnH8YtKY; Fri,  4 Oct 2024 20:17:18 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XL0Fn079dz6ClSq6;
	Fri,  4 Oct 2024 20:17:16 +0000 (UTC)
Message-ID: <5af3a653-d4b8-4e73-bffc-5583f17e00eb@acm.org>
Date: Fri, 4 Oct 2024 13:17:14 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] dm-inlinecrypt: add target for inline block device
 encryption
To: Eric Biggers <ebiggers@kernel.org>, dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 Md Sadre Alam <quic_mdalam@quicinc.com>, Israel Rukshin <israelr@nvidia.com>
References: <20241004004152.8845-1-ebiggers@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241004004152.8845-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/24 5:41 PM, Eric Biggers wrote:
> +	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { 0 };

Hi Eric,

Isn't the preferred style in the Linux kernel for aggregate
initialization "{}" instead of "{ 0 }"?

Thanks,

Bart.

