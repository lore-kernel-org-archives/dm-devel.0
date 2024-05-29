Received: from mail.schwermer.no (mail.schwermer.no [49.12.228.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCC038DE8
	for <dm-devel@lists.linux.dev>; Wed, 29 May 2024 06:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.228.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716964286; cv=none; b=mAsWeH1lxBvIgluLwtjIX+hlaoQNx0zZTpoZTjFlAiPIfLnr7BhaAt9MYZmvwMBaqQoMQWBm1YS7p607nViVOV3Wdwn3T4orse/O1OXAYCe48/l3DJdD4dLnPFx4138+bJLeS5k8xRBrK89zATwp8Tsx7ZcAH+KTCuntD6EklqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716964286; c=relaxed/simple;
	bh=GHAXYLBYZPybUxhduyK+F2bwiz2flz5XYfqXXlub0Kw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Aa/LNcK+k0FghojsEPGVHFn6hri6/Uk9jv0A1CV2mQAeYvIpBfRLqv31HhHFWu6qDKlftYTcHSdg6NJ63970TcNC/m/QFaPng7nc/L3fCBeBfY45UQQa6ReQSwHafbaCHXs8mCjvwi3C1ADXRLyX8jHT0Vk/QCYjA1fP1LbxhTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no; spf=pass smtp.mailfrom=schwermer.no; dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b=BtMXhNpC; arc=none smtp.client-ip=49.12.228.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schwermer.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b="BtMXhNpC"
X-Virus-Scanned: Yes
Message-ID: <eb743a8f-91e4-4d2a-8b75-3e2c7bcca70c@schwermer.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schwermer.no; s=mail;
	t=1716964280; bh=GHAXYLBYZPybUxhduyK+F2bwiz2flz5XYfqXXlub0Kw=;
	h=Subject:To:Cc:References:From:In-Reply-To;
	b=BtMXhNpCmf9nU94kQ1YVMmOp60l//EBcSpCdYFpigv0W8Qs8NgAQmJoxmWY0wNWL6
	 AlRgbc/5uxZcVxmpmGC3nNo3C/AVYimQED1SB6oybozb0JLzvfn4cpwWqambj21MZc
	 N/deUTWaReh9KjyfYNWhtddotnv7lM8XsGVMZ9F50povKJvqfPgBLpYf7uTXlqSiqU
	 og3atGkyUrYGC3PWXptcqh7JAdLdgxQIsvMUwEKuR177kT2IjoHj/+Z0OuJTPhFQjP
	 eVdlQTXRkTDWc7hRqa+4iKPlLG9f8LX11tFnHJwojcOW7phc0B6R6wmpNd1uzy0/cj
	 sgm8yIBBStjYA==
Date: Wed, 29 May 2024 08:31:19 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: dm-verity requires WQ_UNBOUND with mxs-dcp
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, marex@denx.de
References: <296810f8-367c-4a33-b315-3074690d4c36@schwermer.no>
 <20240528194201.GA1201@sol.localdomain>
Content-Language: en-US
From: Sven <dm-devel@schwermer.no>
In-Reply-To: <20240528194201.GA1201@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

> Does this happen with software SHA-256, or is it specific to the sha256-dcp
> driver?

This is specific to the sha256-dcp driver. It works without issue with 
the software sha256 implementation.

> Does this driver pass all the crypto self-tests?

Not sure. I don't have experience with those tests. I'll do some digging.

Best regards,
Sven
