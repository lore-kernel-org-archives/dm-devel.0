Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827A41494A8
	for <dm-devel@lists.linux.dev>; Wed, 26 Feb 2025 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740578563; cv=none; b=lA/JCzg1GYMwEgE2LMsZI7ajQHFDexMGZ9Hwoxc2LfE76Pdo8q2iNE5xpaMkaZqabGmm7uifeo2J2U1rBE9GeZYv7IUvNUsvCmkY8UC09AjWRAZ7MkdnvyyNIUYg3nbcDKeX0ko64zATMBAD1aqTzjfDDLBtzClV//ySZ7aD1lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740578563; c=relaxed/simple;
	bh=S1lHlyUQafAmKbfboeIeWCRRxWZDIdnxB101v6/key4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MFhIFh7fbUu2wXx2jC5tmcMGKYp0MOO4LWFEjql8Fa/TqezCFqnNqMBPWeg9ov+DU1yWp2HGM4nilzMsyIJDkH6JIuvVb1iPyJ8aMNy9kxNLbP23M6o5s4M7G4FNCshNcI/8hEboM+MUaPaJzlO2Z3fOJEoA46+XyTaruzOnh2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N90CBAdO; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N90CBAdO"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5461a485a72so6610484e87.0
        for <dm-devel@lists.linux.dev>; Wed, 26 Feb 2025 06:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740578559; x=1741183359; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=y7JxiN7/EaEpIk9akFz/BbN5BWXCHDt089MmPz7SjqU=;
        b=N90CBAdO0cSd4eRMQ7OeIaHIdtpfYoeR4z06aedsYbyg0r5F6EJaA2tuq3/egP9Di1
         t/5WvT9p8I1TltCC3RxHWXTyg9GGcrmeZcooKAyOajhcrhYGmOfFb5k1s672eq/q+xyw
         LiGHi4dKnjo9EgA4yBxqpY3TgBcYdwVLbuObBFxVwGw8s1R/4sxt5OzS5Cvkki7NMK78
         QPwVRh3JpmKlcyFzigFeZql1h2pWRq/8yWCiJp17Qjow9VTLhuJvkf6t0fqWTjk2GL2s
         azRfY632p4TotD4zw20VVySL8DX5LWua5lrCkep7Jdt4E+T2l1o3huRJrd/dgfmX1ETw
         Q1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740578559; x=1741183359;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7JxiN7/EaEpIk9akFz/BbN5BWXCHDt089MmPz7SjqU=;
        b=Kfb8OkleV9Jr+NCTqrjcDMb9a7ASKN1g7E3z+aAO7m2cxHAnrxJTJclM5WSCHH4SQP
         DuKmbtNjE02rp5EqSz+fHsY5XhiQvipnikFpv3/PyjJYY/uBOO4mJQeMUxw5AW/vKtUd
         4FLyAOnV9okuDp7083r+MnTOhIevTtRwjS61ohBXRklTXQPK5p4hakJKXttPmzK8Tycx
         1ZiRTb+IzTSot18ukMIpe7kS71CGYCyOccq6gaQ7G8UCAYfIeAOnu7vif53fGBDEjutc
         bSQv94QWOgmzFffE1SMvjX11qsRMFnVvwNyV9Grn4gXvaobRuq3Q+YZ6LucrI6bFQ9Z+
         iakg==
X-Forwarded-Encrypted: i=1; AJvYcCXaCoViEVehGdjM1Ku3smMM7z8CuVPNf0Hy4MqnRuXVbArUmR3euOCrO8lkmeBOjTABQ7x42X1tMg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyPl6zip2iOiG3RT1fZUnRgw4kkwUnNUitt+v1/NE1WsMKVtAj8
	73ehAQaRqZb/O+aNjvPn781bZfwycJSI4FW4IK/3NxlVLaVw0k2I
X-Gm-Gg: ASbGncuZdwxzL51pWdVCqsfopiWoR+J0x4wn1uy7xSRse76TmjmLQUSnrKekOmCN78g
	ICJzcrhQMdqf2/FLk/Mc5Tcqxsmh4w6y1+l7n8R4BXZ70eW5EzgBG3RdLJrbFhEbTjKp+0tLTQg
	XXj5+eIqub5ZHedj1IU5EBWdPq7PjtZ2zl2L3OhNUnZpYyR8DbIjIfpHuerN7KYCY/iwbNkPxos
	17Eig0Yi8txNZ5m+/S150MM95bwO4fzfUPT+1aXcvmXo/5owYpPnJPq5OMrYZJesJWkEbbFR3m8
	UqKwCk54EWj+F0E+U2bMyGdfl1o/DlWMGYectl6u9x1noiBMMg==
X-Google-Smtp-Source: AGHT+IGXWamPbQPXS3dI8k6M6UXIynN28WUm/uuCdIbiS5UuEnsUgJoVw3J96Lagzn8R1Hqjf9cG3w==
X-Received: by 2002:a05:6512:31c9:b0:545:243e:e2dc with SMTP id 2adb3069b0e04-5493c5b88f2mr2832301e87.39.1740578558987;
        Wed, 26 Feb 2025 06:02:38 -0800 (PST)
Received: from [147.251.42.106] (fosforos.fi.muni.cz. [147.251.42.106])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abefe713bbesm47387366b.69.2025.02.26.06.02.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 06:02:38 -0800 (PST)
Message-ID: <bc9d0c28-3712-4315-a582-9dbce9f9f05d@gmail.com>
Date: Wed, 26 Feb 2025 15:02:37 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: sysfs integrity fields use
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block <linux-block@vger.kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
References: <67795955-93a4-405b-b0b7-e6b5d921f35e@gmail.com>
 <Z73kDfIkgu4v-c9W@infradead.org>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <Z73kDfIkgu4v-c9W@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2/25/25 4:38 PM, Christoph Hellwig wrote:
...
> 
>> Then we have new (undocumented) value for NVMe in
>> - /sys/block/<nvme>/integrity/metadata_bytes
>>    This contains the correct 64.
> 
> Yes, this contains the full size of the metadata.  And besides
> documenting it we should probably also lift it to the block layer.

yes, this is exactly what I need, just it should be present
for all block devices.
  
>> Anyway, when I try to use it (for authentication tags in dm-crypt), it works.
>>
>> Should tag_size and device_is_integrity_capable be set even for the "nop" format?
>> Is it a bug or a feature? :-)
> 
> It is expected.  The only issue is that the block support for metadata
> is called integrity all over because it was initially added for PI only
> and then extended for non-PI metadata, which makes things a little
> confusing.

ok, that make sense. Maybe the note should be added to sysfs doc too.

Thanks,
Milan

