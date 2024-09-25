Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E5B1487FF
	for <dm-devel@lists.linux.dev>; Wed, 25 Sep 2024 06:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727246115; cv=none; b=n53GZd73ucFR9tnqVgPm1BNsZG+84oJHAMDJsV/Qad0vuZp/0rFUAjun7xOITfLv1ztFGC8djLvT1u9+9yi4WQVhTaVmhWIZQimiz3+Rm7WiUptZZcdOl84W4fIms3UrIKesNc0CmvAdWu2KYIFaj7hcMcVzXLZB5eTcqXsCf6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727246115; c=relaxed/simple;
	bh=BLjLIOBRx47xvZpfYUVzpJgC1kqF9aRPZHD66e46omM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=srQLClL220j6LcZ9sX+UsHSwGLWSYWVmMvvOpFB13mS4Pk523nmAhnyqahxxrOyP0g3htTAIUF9VRAjUVCPEekaBn8xtqy494hU0t4m9CT0BywRfOQzs0KadpRLRgUmSkbCj5uhMtbGxLSlHI3dP/riWVhMIYwNJUDKO/d2u8w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bYaSazNY; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bYaSazNY"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a8d60e23b33so844685466b.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 23:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727246112; x=1727850912; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3W/mK9Ks7WgheyC8eUQ2uJ1D1LPT+wdpuSq5qOX5+NI=;
        b=bYaSazNYdCb+IwwiKyotqg5HQTBLNwWpECNdEavRhYT0ID0mlMuGDOCNriT+U9rj6N
         qWljk+kGwZm3UNQnpnBtrZti76VQxpQ4fYWYuMjtK1GQGQrEUvoE+FkuZr4kBgJEXzYs
         TOcAUSePOmyHgH1foyYe1q7L5M/523p94cvqiOnmrdHrMQ4V96etL7nlx/Qtb47Qaqrk
         fMBObTPhgv3u9yTZRZtDMQxbpbEuq5yF3vaPUeoV6kt1XMDlBBeUMXo29GPqrfNyJJAf
         tPWxVKCaUfMw4vrQ0gz98oJw/HI7548zkxNMnfEBi8vMDNXvqWnOYLBVroszgS7iWXcD
         JXYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727246112; x=1727850912;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3W/mK9Ks7WgheyC8eUQ2uJ1D1LPT+wdpuSq5qOX5+NI=;
        b=dQgY7ht4OvaaMXGSzIagE3TWCrgufSdhLejxD95FcSkwh7D5IqEdCB2lkjS9GeyUC7
         JaKgjM01D6BMPj4TY68kDdv7sjgU9us6b4iQqnoU1CO3KFHDwwyQjr/oPOGeBgzwBfOH
         XwaDbW1FUtO9CoJxv76C8xN44QIIZj/4AcgCFQjtVW3jPQ7VQEBjoQJyDaxS7fgw5aRr
         5PJLz2//R09MN6dBnBDADiUXp1EMJtavtvOyqPsBFbo2+2hR+b/rrJEo6PW+EbfxqQfp
         tDamIqdF7V0f/5ANY3qUDIeJT45FNdp3c4Bn+HH0VCtJU6E/QjAIOIQHdGYDUhO5n93q
         0SUA==
X-Forwarded-Encrypted: i=1; AJvYcCV0y1SOsRRMBbYa7qTv6+ggx/wSnlqMZqqAUPkJMdNKZatS+C4jY0qvAN7HmdoJ6bCYtOfK/kLM+A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzSA5vutko/hZucI/FvmE+m+1iUnyvGNLUPrVUHnv45l/QPhQ9C
	GNVY1Lxp+teF0jHt6J3G4DcLJNUjKMdIuLain0oq7CDfeKb5w+Of
X-Google-Smtp-Source: AGHT+IHzvHZoaYDBhaJYPDY/qdomOdP52Jiuxzxa+8sHSwiYserKp3z/4E2PrDtB2FL6pw7ysIo89g==
X-Received: by 2002:a17:907:d20:b0:a77:d52c:c42d with SMTP id a640c23a62f3a-a93a03304c7mr143062266b.13.1727246111944;
        Tue, 24 Sep 2024 23:35:11 -0700 (PDT)
Received: from [147.251.42.107] (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9392f50a30sm175785166b.62.2024.09.24.23.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2024 23:35:11 -0700 (PDT)
Message-ID: <3d31625f-3b26-47d7-b933-0bd6a89b748b@gmail.com>
Date: Wed, 25 Sep 2024 08:35:10 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Maxim Suhanov <dfirblog@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
 Akilesh Kailash <akailash@google.com>,
 Sami Tolvanen <samitolvanen@google.com>, Alasdair G Kergon <agk@redhat.com>,
 Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>,
 security@kernel.org, dm-devel@lists.linux.dev,
 Eric Biggers <ebiggers@google.com>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>
 <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com>
 <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com>
 <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
 <b65d67cf-9904-4182-a113-2d9a241dd668@gmail.com>
 <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/24 8:09 AM, Maxim Suhanov wrote:
> Hello.
> 
>> This is a very strange reasoning. I can say that restarting on an IO error
>> (that can happen in normal situations) could cause another security issue,
>> such as DoS. EIO is not a data integrity error; it can happen even higher
>> in the storage stack... and the application should handle it anyway.
> 
> In the default mode of operation, there should be no panic/reboot on
> an I/O error.
> 
> The issue and the proposed patch affect the non-default modes:
> panic_on_corruption and restart_on_corruption.
> Users relying on one of those two modes expect the system to crash if
> something goes wrong [1]. So, DoS is expected here. Returning I/O
> errors to the reader isn't something that is expected here (see [1]).
> 
> The issue allows the attacker to "downgrade" the "panic_on_corruption"
> and "restart_on_corruption" modes to the default one by creating
> unreadable sectors on the underlying media (e.g., through the Write
> Uncorrectable command).

Sorry, but I do agree with this.

Panic/Restart should happen on data corruption (or failed Reed-Solomon
FEC data recovery fail). IO error (and other errors that basically translates
to this) can mean something else and userspace application must process
it in error path (think about network failure).

This is how is the dm-verity flag is documented:

restart_on_corruption
     Restart the system when a corrupted block is discovered. This option is
     not compatible with ignore_corruption and requires user space support to
     avoid restart loops.

It says nothing about restart on other error, that can come from crypto, network
or whatever. You are redefining the policy here.

Milan


> 
> References:
> 1. https://github.com/flatcar/Flatcar/issues/422

