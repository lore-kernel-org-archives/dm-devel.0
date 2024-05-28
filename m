Received: from mail.schwermer.no (mail.schwermer.no [49.12.228.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF86F3BB59
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 08:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.228.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716886719; cv=none; b=BmLO1koZmMxXgLi7BxzvHnR7b2JSFXibZjRT1+sWBVLy4/IkpwtR6jGfKheHkOGhrlyheUYFn/Z2rGJh/C9VwVPpNtMltiIXrmaDJKbl04iWscqz2beXjRO3cAXvKU0PKDGakPXUkPV2gMFMDYNY/StOZpfHGFl9dX+91C2SJzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716886719; c=relaxed/simple;
	bh=yvHagJeH+mN4aUo8DzLlPH1RCV5V8Mrv+qcNUeozSKA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=LGSHcWt5Et/kqkROFq9F12osbpIxZKNHi2HBpDVO+A4T4taH/B7n6wghH1ZVppDq6L17G5HZRqg1+bqSPBy6y+mGgeDvLJNvxkO9pLm3LpUtuQQAV9xwml5pXjL8idQr6qDWzkzr8hTdCn4AoVD0+wZVZdVzE/5DVMC/vmIb+Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no; spf=pass smtp.mailfrom=schwermer.no; dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b=hzZyW4MS; arc=none smtp.client-ip=49.12.228.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schwermer.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b="hzZyW4MS"
X-Virus-Scanned: Yes
Message-ID: <296810f8-367c-4a33-b315-3074690d4c36@schwermer.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schwermer.no; s=mail;
	t=1716886714; bh=yvHagJeH+mN4aUo8DzLlPH1RCV5V8Mrv+qcNUeozSKA=;
	h=To:Cc:From:Subject;
	b=hzZyW4MS1hF6fgebTt14/6JkU3Fm0s+KNkKz/yB9+YAH+xP5/GKGRIR2AI0n5PP+C
	 7Gs5nqK7xL5rapsrwt0hN52vGWake5AE95lLZEUycp/aYp/lkYUkS/UvW8IvNLKxeE
	 7Fndr7Mzpw9z0poFXr3uEbC9PXfBmZq8dvXALgFasthVwnNSkyyo8B2Pa8Pek84qxw
	 yAEElxmbOMUc32Og88qRozOJ/Ob+Cv/USmMO08ag4cTkplA/qRCZbQnXLc6nlPGyHp
	 hr78IY+CN9pHPiSaCO/o5cxY+AwczZRPdU2A3ZNkHGNhZZg7X+xEHrvhlxuK1h3Jmk
	 0PLHk3hB/Btvg==
Date: Tue, 28 May 2024 10:58:33 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
To: dm-devel@lists.linux.dev
Content-Language: en-US
Cc: marex@denx.de, nhuck@google.com
From: Sven <dm-devel@schwermer.no>
Subject: dm-verity requires WQ_UNBOUND with mxs-dcp
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I'm seeing a problem using dm-verity with the sha256-dcp driver 
(mxs-dcp). Specifically, I'm seeing corruption errors a la

device-mapper: verity: 179:2: metadata block 76823 is corrupted

This is a regression that has started to appear with commit

c25da5b7baf1d dm verity: stop using WQ_UNBOUND for verify_wq

Reverting that commit while keeping an identical rootfs fixes my issue 
and I don't get any warnings anymore. I'm using an i.MX6ULL SoC which 
only has one CPU core so I don't really understand how WQ_UNBOUND can 
have an affect here. However, there might be side effects that I'm not 
aware of.

It might be worth noting that I'm using the dm-verity device as my root 
device without initramfs. I'm seeing this on both v6.6.23 and today's 
master (v6.10-rc1-13-g2bfcfd584ff5c).

Does anyone have ideas, how WQ_UNBOUND could be required here?

Thanks,
Sven
