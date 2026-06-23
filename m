Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADDB3CF207
	for <dm-devel@lists.linux.dev>; Tue, 23 Jun 2026 08:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205025; cv=none; b=APaS7vQfQNLLVNrY3k6iAf3Yi3AAE5i8tOFuBXWnJM0iOcn8zR4QwYLYsXVU/hklCvMFQxYxdvIvdXdaIUlW+bVr/f6S0B5vARN+h953e/+ZuFuj6fJhrTnqBUxokk8VC596snSnaUDzRjlbZYPfcTEuoc0rKZG28DrzTs1jOrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205025; c=relaxed/simple;
	bh=QH4UVViP3mNVDsMm+E19tqY86XfdXlL8YlbbsvBabtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kgt//LT6hqybmVrbR9BNUydSgt25Vj86xYgwC9r0CnHafkxy0c2A6denbmvpdHSEE/qu1ILIX9KPOJuGvL07MZQihjzKgpzKR7OWHQ12AhkTSJWvl1/29MI8IninzcPZeNQLHde3zT3BOzCbp50+GZwXhzx4/Mto+LiHEhg5jx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AdUdtXrT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AdUdtXrT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782205022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ItLvswZvLtFnJpS91TTxvSnHPqfxs67BvfVfK3aZKOo=;
	b=AdUdtXrTU9/lAHXQoMdtmJhXTps5vsLkg+TalcC/cIla6DaEgN5cW31YKJXKUfrJ46FswA
	BNhJGZOUtCySdY7WTFPAVshasbZBAoIRVzYT6K3UWmELNCv5sZcFX5TLWAeIpqmya7Rfjp
	IpuVotK7wiobDhlHQFo8FHTpv0dMiGA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-KBx1GjVANzi6BKYExcBa5g-1; Tue, 23 Jun 2026 04:57:01 -0400
X-MC-Unique: KBx1GjVANzi6BKYExcBa5g-1
X-Mimecast-MFC-AGG-ID: KBx1GjVANzi6BKYExcBa5g_1782205020
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4629f312a67so4647080f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 23 Jun 2026 01:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782205020; x=1782809820;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ItLvswZvLtFnJpS91TTxvSnHPqfxs67BvfVfK3aZKOo=;
        b=JXh5wVXc7nPOBwRVUt/lW1NSlBU8ItHZvvq0dYH2n1ESLEekQgdIaG65EDV1sKks25
         duVUxjg2bZtravzZxVF4NLy4SHyOJruvIivAUSgi9SSWL798wVOIy/JoaSIIXL7jUVjw
         JVWYVKeNHpSBRWN7O5C72PP28SAnFIpWTd0BtxqLzEVbCQ2Z+Fd4XgjDDSzcXYEtgUaG
         sOh8zDJI8nEjx4RaqaMqBuUlSxTSie6k5p1S5r/GQml2HMywq+sEjFOWWvxmcshEYs9q
         L6ov9GufvUSR5nEPuhfEiXVbxS1m5rVnpr5pYjEqwZwSbCMcl+Pd/Y1kaPWD9PutLlxx
         2jyw==
X-Gm-Message-State: AOJu0YwUZZbG+B+le24GnBBAqNFMGYhBliTynnGEGs5DHpV/lhKuUrTN
	vY10gJUv4QLiOFTAzxyRrZ34RXS6JouiiKS03JjoGSoWSH9thDOrlpsY8zh2uMpk3OxMR0kfzZ6
	K4mOPBpjXlwD3iGEbQAfV+5A1Psc5kREFZ+RuekdJfnEQ2Xp4t+tsitW8FR0=
X-Gm-Gg: AfdE7ck55p+UkP6Ar7kf8NTXb2ptt2YcUX8uyRPuH1Wv7fDk75D2OTIJ3PwBvn1beD5
	HnGpmWrJ97MLiYRd5JH7/1dG1HAUwrj8MJ6tyxo5pwNq/e9wOcx4avecpgxZEF4cYh/VAWsJJcW
	bJBrRQ8DR2BqAY22ICHbMEab1TfQsum82P0gvBDnuk3+CXseVWncK8VmGqnJPQrOj923Erpo1rc
	2LMlfqoHGO1d1VwBe3Jxf16gSSNuPxIv/MDgp563b4RIGV8+aeTg1stlOe0I9NsmXHoLpwODdqm
	SN7zKRShL/8ABRfGgHMKKTsYJ5KqjY1Ta3B2hntqYV3C5m8isZ/4zu8kJ2Zs+SacYb0EeMgbyqQ
	L
X-Received: by 2002:a05:600c:6288:b0:492:4c5d:4db3 with SMTP id 5b1f17b1804b1-4925b389ba5mr24504995e9.5.1782205019767;
        Tue, 23 Jun 2026 01:56:59 -0700 (PDT)
X-Received: by 2002:a05:600c:6288:b0:492:4c5d:4db3 with SMTP id 5b1f17b1804b1-4925b389ba5mr24504605e9.5.1782205019351;
        Tue, 23 Jun 2026 01:56:59 -0700 (PDT)
Received: from [10.43.17.192] ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4924944fbbdsm307985945e9.12.2026.06.23.01.56.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 01:56:58 -0700 (PDT)
Message-ID: <ea67ab0e-a039-460e-ab5b-a448995bbd31@redhat.com>
Date: Tue, 23 Jun 2026 10:56:58 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: avoid leaking the caller's thread keyring via the
 table device file
To: Ingo Blechschmidt <iblech@speicherleck.de>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 gmazyland@gmail.com
References: <ajKwRtP8izwRsMmv@quasitopos>
From: Ondrej Kozina <okozina@redhat.com>
Autocrypt: addr=okozina@redhat.com; keydata=
 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
In-Reply-To: <ajKwRtP8izwRsMmv@quasitopos>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1RD-JvLrQjOI5TyiaSmGAnmhnxVByj78BwE8ie52seU_1782205020
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 17/06/2026 16:33, Ingo Blechschmidt wrote:
> The refactoring in commit a28d893eb327 ("md: port block device access to file")
> accidentally causes the caller's thread keyring to be kept alive long
> beyond the caller's lifetime.

For the record for anyone tracking the issue interdependently.

I have tested the patch and can ack it fixes the issue for block devices 
opened in DM table constructors. But that's not, unfortunately, the root 
cause of the issue. The keys put in caller's thread keyring can be 
pinned via many kernel APIs taking their own reference on current_cred() 
when a process calls into them. That's something I missed when I added 
the feature in libcryptsetup.

For example: while I was testing the patch I got hit by the issue again 
when I had test LUKS2 image in a file. The cryptsetup creates loop 
device in before it opens dm-crypt mapping over it. And voila the thread 
keyring got pinned again, via loop device.

So to fix it properly, I have opened MR also on the cryptsetup to 
manually release the keyring while releasing a crypt device context: 
https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/937

Tested-by: Ondrej Kozina <okozina@redhat.com>

