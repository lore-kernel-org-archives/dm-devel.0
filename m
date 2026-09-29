Received: from mail-wr2-f37.google.com (mail-wr2-f37.google.com [74.125.225.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ADA3998BE
	for <dm-devel@lists.linux.dev>; Tue, 29 Sep 2026 07:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790665935; cv=none; b=rap8Yia5ofChs+o9+XOSf9KfdWn9cKIeFGhEFwnv6GuZ6ZJwzKK8YZR2qMJET46mYPuywIPU/zJSFmwxY3YpXfvYOiBF2ZrIsqVWtblt6MYDDGx30BelF4+Op+IIZ9pgOYnHIrOQm89Lp6VPum49iCJXPEWj8lFx/7/nvvCvyzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790665935; c=relaxed/simple;
	bh=u8TQO1UK8XHVE0Vqt/VlT60oO5zfpXd7X/el+fKVDdw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OUP3Ki8nbSynaWxEecLQxkeUhDyYmKR2ORiGnIsyTbSuPq1QNC3joohGVdrNqScOkTL7vQmAY0bbJSjjhFf45lpmV8phCHFgoMxV6P9meAY1TEtnAbOprPvV/N6c7pCOVbHWjcczJzUU2HWjHOCebHBCf8Fne8+xXLtQcMm1nvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M+HL6Hkm; arc=none smtp.client-ip=74.125.225.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M+HL6Hkm"
Received: by mail-wr2-f37.google.com with SMTP id ffacd0b85a97d-4887840c529so1386629f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 29 Sep 2026 00:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790665932; x=1791270732; darn=lists.linux.dev;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OxnpfrZPnSG8Zb7d0SFA6XW6LeRwagGigYoZfwslrbM=;
        b=M+HL6HkmTe9Dg0MGLh/kmeJjBpqEv1f7oySUjEBlen12LsucnpKTVT7GFjJcyfxH2z
         4FoaTrktMxzryMKZZsKUd2Wkp1biXO5h6ROdZ90SqFTiTiwAxZ0Qt0UMA1eW1UcinJcO
         93G2Ap9nTxGU7PoaNbXGVD/Yc/zMWn1q1RHRkmVJJNP+/nQS7Ak3WiTrfTkIHsEXWJps
         WpTZMB+7cEnFkuAd4SjhkkLxIVYEjo9XFVHDXjJQ9OFsehQg18+YiVKLHghclC36rKk5
         QDNjazojGksZqmogTkcUqI5vJZ1b1v/l16Eo4CwkV8hjSuc2EIxpJbtlJnO/qhHsou9+
         0/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790665932; x=1791270732;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OxnpfrZPnSG8Zb7d0SFA6XW6LeRwagGigYoZfwslrbM=;
        b=tjgHLrw6/sI+hqLbMUBI9VuPS7AL9IjLcExwHirGPKKPv4LXk0O2gMk6rz3zQzYA+a
         Hywgcahxpr1EBLP+IaqyQalCJqabb9Cdvd2w1VAUSfeRscMHcXp/mLr6dUS4QnbmLLY2
         1mNuAXmPFYvG8Ayx54NXfg5TYYend2UGT4Uf0dJlPzM8fYvCszCc4GHTra2xaaWZ3w+Z
         gAmoSeA7xK4mrRYeBB9uizQTHr5L0CHJsxwqZMM2B+1ArXNzbwkvXTgPBK6R9bJx3O/6
         xvvQB5QsmhVm5zP4WPmqneCLkP05N91KBxamyXyPCCVnLEXQXF9VURd6I1TZHTgY1Ut7
         ITLQ==
X-Forwarded-Encrypted: i=1; AKwUvBzcRi4e30DU0aCHICzzs1zEvwCbmu5LK3HLl0S1s4/f+Baf09MO65l8oBaf7HuMMNFL+8ubXRIGAQ==@lists.linux.dev
X-Gm-Message-State: AFuF++nJP1qNBxTTZPYIIrbRKrF1MU/YNJp2GnqrvQmvJyjp3oRozJKf
	kzejkYql+kHb5X53pr1GNGX1PfsxnlZxKwjBhzv/2KUC2404msvVXYNMRKfuOg==
X-Gm-Gg: AYBFou2JN8hPTzQ8uuzsywnoxGa7UsTTvecTv1CJPSc+FpwDaxB4PHWTjgFnp3nFQeI
	FHXyIPBvGMC8+3iBv7eyLP+7tMJqRMB8E8fQM0Js+peMX7uuVIg/39HF7u+3UWgM5sSlpUNAzPr
	PXsk1PGpb4IyGC3TW26rOADU9YGU5LblEA71WCF23nLurEAA/Wq+N43lx9DeBaKxltXWPTE0era
	ejb03fCJF/DHkZYASWEjOxX+daLZQeA4lm7UuyJmwiW3eZeC4hF9SFnni+6LNDaHN3ANUrgtJQ2
	6H2UhyT5V11LvFd/NjgCY3oItWIQ4RdXgfErMWhLHk/a50PiekBPUDRIxykrluGqWg1FS9qw7ZP
	sAarZvymoKhP95c0GHadeMBMI5316XdAg4pRhdzOksh1CRhQ5ER+5ruMChk+FQ19hDlaX/7c5AK
	XA3WYKlYvtQvp/dJCql2Ed9WzxLjUZpVvr7kMDPisyh0fiPcNaad4BCwH5+WUyVKaytcKTzRYmp
	5PqEfIprkpMzSPPIRaNknmNq+PxQL0=
X-Received: by 2002:a05:600d:8650:20b0:49c:e37e:4389 with SMTP id 5b1f17b1804b1-4a00d75ad86mr16748835e9.4.1790665932244;
        Tue, 29 Sep 2026 00:12:12 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00cfafa23sm52092075e9.14.2026.09.29.00.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 00:12:11 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: song@kernel.org, yukuai@fygo.io, chengzhihao1@huawei.com,
 magiclinan@didiglobal.com, xiao@kernel.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
 arnd@arndb.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/2] md: add a control device for array management
In-Reply-To: <2026092927-dominion-defeat-eed0@gregkh>
References: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
 <20260928201224.3602262-3-abd.masalkhi@gmail.com>
 <2026092927-dominion-defeat-eed0@gregkh>
Date: Tue, 29 Sep 2026 09:12:10 +0200
Message-ID: <m2ik3o4jlh.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Hi Greg,

Thank you for your review.

On Tue, Sep 29, 2026 at 06:49 +0200, Greg KH wrote:
> On Mon, Sep 28, 2026 at 08:12:24PM +0000, Abd-Alrhman Masalkhi wrote:
>> Add a misc character device, /dev/md-control, with a fixed minor
>> MD_CTRL_MINOR. The control device is not tied to any md device, each
>> request specifies the array in the payload, either by name, by UUID or
>> by device number, without the need to open the md block device.
>
> Why is this a fixed number and not a dynamic one?  There should not eve
> be a need for fixed numbers anymore.
>
>> --- /dev/null
>> +++ b/drivers/md/md-ctl.c
>> @@ -0,0 +1,597 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>
> No copyright information?
>
I will add it in v2.

>> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
>> index fa9000f68523..0bf2870dc191 100644
>> --- a/include/linux/miscdevice.h
>> +++ b/include/linux/miscdevice.h
>> @@ -71,6 +71,7 @@
>>  #define VHOST_VSOCK_MINOR	241
>>  #define EISA_EEPROM_MINOR	241
>>  #define RFKILL_MINOR		242
>> +#define MD_CTRL_MINOR		243
>
> No, please use a dynamic number instead.
>
I will use dynamic number in v2.

> thanks,
>
> greg k-h

-- 
Best Regards,
Abd-Alrhman
