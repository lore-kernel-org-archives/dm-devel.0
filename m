Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6194188CDB
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 20:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736282054; cv=none; b=KK0rocJxm9xEyKb2HQHOFbArjlQNg4nEO38eQMUJWaS4JWjXCgjSOvWOZ3PJoIu7u6CkdBAddhChEvJj0AQtzOC4UTBybgfSBPFCLaUCwP+5cwgY2z9boL9U8KcsCQnmcsWq5GrNggS6g1Pxe6TuBi0cU26X+1UTMoy9yOErH9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736282054; c=relaxed/simple;
	bh=B8JRArmkt3Y6QVgGsvzoWGBv2QNdmirZ0fh678/k+JY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pigg99XU6csyby6N4xvrOKcTQSufs5kp8pysMfNq3c5uRNLZnl2YNp0Q/9Ps6vqwPFgKyPMDGTs4W8zpK9D3QUQZJoSZNpKDFA47fhptwvWUW4wr4Q9R7+z5M5UvO9sV1R4GUDCtMXjLxu5fCPODfagcqtW8Hi1L4NBTFoHg29w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mxcOnnxr; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mxcOnnxr"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6dd43aa1558so117751106d6.0
        for <dm-devel@lists.linux.dev>; Tue, 07 Jan 2025 12:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736282052; x=1736886852; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kht+cFul6vjqpxYKSnTCRGFt60+osMJrA86H74IGK+E=;
        b=mxcOnnxrYkRaIFHUJKzCCzQ6fdNGXmIFnJTUXX5SbPDM8UfbqUWb3mgp8cI6JEOKc0
         yJQ/8hAAIzkHFlBBKbYN9Dcje1K0nwduq98LV0nB/mpuoeyKL9TsmgvinMp8lPSYAKFI
         H6Hv0wjudJeErOJx4kumyvT01JqlfdHv0Ky+U9IHr/h5mFXnoOmddHrBh+LZMsD+QkB+
         ODSjttgJxLN7fAhLcAFEzLK+6S3i0w7lIhr2AmpI1KIibfUisJ4XnRKs8fWf/OMux1YA
         yyDj5Q69h0lvDU18cvVj814oxVcMb2NZRjghJfyPy1+xyRwxsycFQgLIYErjEkkwS20Q
         siqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736282052; x=1736886852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kht+cFul6vjqpxYKSnTCRGFt60+osMJrA86H74IGK+E=;
        b=fkDUGlFz44vbNlN3Jy6GohqioOh2Gh/fJtO4jf458wunsbIcgcM7V3mCyhyffdF18Y
         X4Fr2kT9j3e0s0Fx95txiYpm4SIRPQ1hnDMfz4fbzEvGF4xEm6LXgH7UKDUC2iCgwFGT
         lPZ7TZskBJLFk8TNjlK0PgoyAZPfMEwiRDs/C3TleFgqC57uDTo5/LZtu4fwvg1EmbGt
         /U8pt9RANVIDwVInwMIFQr4rtEOLN6nwEMG4WBwUbSNVWgarO9pmYIgKC9gCOXpEaxWw
         aMTJQ++9YZWFbzJ6zUhunsXxTaR3YNMjOMaEcLhWR/f6GHfa6ylsPTHaNDTynqbRgvrv
         SY/w==
X-Forwarded-Encrypted: i=1; AJvYcCWXsEf9dRnsPdP+WlpK7PDwLUAYNKDBwmixfOXGBnf7iM0zjd4PMdMjbtn7SoJg7jveosqswgKaRg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLhlIGAV/ZnVoQpEm+4qTjh0DH2nQAUshF+LEhFTKfADGL2rr4
	2bLbuLplDGp8xDpEt3E6Z1aFDGAus8fUnkONZsUxGFV6tcL3hTJa
X-Gm-Gg: ASbGncsxninO7KcQIDf41aepuHbVJlmabOs1stxGlGrsdmAJ228oH//wT7b6NNN7PtZ
	9DpabpztOLOeGBkQlWZJ+3lI4rt2bQWvs6/pHWlf7/04aBGMUQkGMA2umtlRCr+J7zGkbJDS6yl
	bVs8ARgziWIQmZngfrvYm97Ut9vuXhMNYPlHRZjUXORrD9gKlNtaktKT6o2LE//j9TGCObIRGEA
	+m+jaNHheB0iQEzgSl3fViNcv83EbPm7/QuqvuVDNDLQfncuAlarHKThvap+TCF/Hep/7/5TQnP
	VtwdqK8uDogEU5uLorlLYH5ltB0IjULO
X-Google-Smtp-Source: AGHT+IGOz7rNoqhUwZIiKYpuUzZKpYvrk4PlgYVUi2XsnYLA78fGvk7mPsKMQW0NrGMii/IrMQNkoQ==
X-Received: by 2002:a05:6214:21cc:b0:6d8:81cd:a0d2 with SMTP id 6a1803df08f44-6df9b2d4f97mr6678276d6.41.1736282051454;
        Tue, 07 Jan 2025 12:34:11 -0800 (PST)
Received: from ?IPV6:2600:4040:5f58:2500:48a3:a7cd:313e:1c7a? ([2600:4040:5f58:2500:48a3:a7cd:313e:1c7a])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dd181d5ac1sm183958916d6.120.2025.01.07.12.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 12:34:10 -0800 (PST)
Message-ID: <13a377d4-f647-436a-806e-c05413cef837@gmail.com>
Date: Tue, 7 Jan 2025 15:34:09 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC md-6.14] md: reintroduce md-linear
To: Mike Snitzer <snitzer@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, thetanix@gmail.com, colyli@suse.de,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, dm-devel@lists.linux.dev,
 axboe@kernel.dk, linux-block@vger.kernel.org
References: <20250102112841.1227111-1-yukuai1@huaweicloud.com>
 <Z31jQT4Fwba4HJKW@kernel.org>
Content-Language: en-US
From: RIc Wheeler <ricwheeler@gmail.com>
In-Reply-To: <Z31jQT4Fwba4HJKW@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/7/25 12:24 PM, Mike Snitzer wrote:
> On Thu, Jan 02, 2025 at 07:28:41PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> THe md-linear is removed by commit 849d18e27be9 ("md: Remove deprecated
>> CONFIG_MD_LINEAR") because it has been marked as deprecated for a long
>> time.
>>
>> However, md-linear is used widely for underlying disks with different size,
>> sadly we didn't know this until now, and it's true useful to create
>> partitions and assemble multiple raid and then append one to the other.
>>
>> People have to use dm-linear in this case now, however, they will prefer
>> to minimize the number of involved modules.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> I agree with reinstating md-linear.  If/when we do remove md-linear
> (again) we first need a seamless upgrade/conversion option (e.g. mdadm
> updated to use dm-linear in the backend instead of md-linear).


Agree with the need for an upgrade/conversion path.

>
> This patch's header should probably also have this Fixes tag (unclear
> if linux-stable would pick it up but it really is a regression given
> there was no upgrade path offered to md-linear users):
>
> Fixes: 849d18e27be9 md: Remove deprecated CONFIG_MD_LINEAR
>
> Acked-by: Mike Snitzer <snitzer@kernel.org>
>
