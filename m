Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FF237CD37
	for <dm-devel@lists.linux.dev>; Fri, 31 Jul 2026 21:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785531809; cv=none; b=n+kJU9w43xPhqSskB9A7Ucee7OCLGSVUZKr+Vx8l869kbYdm6fX1ONhgO1srgAZPrKQe3IxfWfO3OpEPPLZhAkqeIfEHdZ378X/rb6U0zQjBgyH76gmRoV0iURFJqKVR8xVz/AjrYVrDONNnHfZbsiVjnBAwynCEr3yUlZDHuhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785531809; c=relaxed/simple;
	bh=CUwfhmcNw0RvUYqCknuxoufz7LN848bPTFlt0csmNX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VZq9GUqluaaHVGMSACc1XumoPcnvFLocqpSqzWWFoonKl6wtWF4USmXrSO+DW7sIQOsei20t2aOZXFKpH/oAo11jfnKSWBXrPBIZAvCNXvtGAtKONL5NO7z2KUkSdcmqconFFbAE+6gYdWfWerF6o6H9ifELiUFtOSDgd3rsro4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W5eeeFsu; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5eeeFsu"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39c94fccf3eso12001481fa.0
        for <dm-devel@lists.linux.dev>; Fri, 31 Jul 2026 14:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785531806; x=1786136606; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4R4MQhqitPZHCbwSowvGVDgacr1GK+1ohL2DFBB/ACs=;
        b=W5eeeFsuBFINd2NfapSjvaJplkm6TC4JebEs4hokSIuu6o2B+JUVjnzlsIhffWY9zE
         xULcyK1KtMnzwIpzYCgtd8eAQ6d1tZFCqgFx/wcGstXtAzewvyZb3GgPL/ji5KYmGq1X
         8WdJXZT9mnvulHPjfeUKsw7wsTc0Kd5jEXDdCz+j5DbPvbW6a/TKSkdTmLGG5YQjPLsD
         mRlBm3O3qidP3LXFdhm1IfwidIEbDKnI0LhHb2MMg2/PNicj3fvFG1zoSHTvGXM/tzCn
         Ogm8m1jyK/T/5PWjCPVFGbuf4JjOVQ2N5jhBv47k3m2TF9VoEvyFX17WHnvtV4r/qvha
         n8NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785531806; x=1786136606;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4R4MQhqitPZHCbwSowvGVDgacr1GK+1ohL2DFBB/ACs=;
        b=iOrz8kniPz6gay7oifenYr1rh8BqIcsGeGZBVLMxzC842mIqgZCR7wFU9kjJQgBnPn
         ncCRNtqP6lNm+6i+sho7BwY7dR7BbkvR/Jr0eRLiCDI/vRDbak86ydUiaeAGRHUwLknt
         nnwyXHIkIk3Iusfa5ght8nPOFGusp3nHV5tVDa8SQ3D85jfvbmpZq3pSC9fHF+KG8DXr
         qTmm+RKGP/zXAuZ89ObYk6FC29FrDWaJje9ruzYE8GjZnKBvN+K2rUHKSOPeiFqGcGxN
         IjnhC6gj2ZHNmcabgAwMVxjs4NR1GBC202SF3CCCH0vJn8m38FoAUSZl6v31b2TcynHU
         8p9g==
X-Forwarded-Encrypted: i=1; AHgh+RphoJCkIU+34Zn7wzqA7bHyxHCLjvqKAgOP5OD7y0TSVAtpIeEYQdoqqcqmqr+INt2jl/qX8BNpFg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwkVBV47hGWt46svOGTFGIL0TjZF7aHBLc6OlEejxaNOoM7M/Xx
	6fMysEK/MVpcHOrRwWh5dTHjREFOmRfnFrGgCSLIy7w3PhmV86jZOI9t
X-Gm-Gg: AR+sD11nDyDzHS+ZaEwvaHo1ok2Qp6EGxKc5qfuOUyPyEkqaCxSidZCuN+8LR1OuuCX
	1T/PBye8IVwP2Ch/L5BnOSLWfkOOLSSiIqOyqwWnCGFrJKvFAPtUwykAJeAXFmARs3b7KNe59GD
	20A0f3PYzS56gKTZxk7OeqBbu1s2xi8S53G99LstSPFty2vLZ0ukYK6mEVDOY63PLIO8mUgnaiT
	MyME21wPbn0VhKOeP57MdF1+cwmZwPx1AfwD//l2rjhR9RImGQLQqSbbHyakJyZOOtAnNf7RG8v
	8mDCu+3oCvNDrJQiN90I+zagHuAUhtosJmKM73pWKQnGkFhPB92FZ9wpO3bU00qRWLDfuiqn/Kl
	iiExhwR6DF3LCqux4yDD60xxYs5PmntDEYKPuve0j3TveqfkZnP7n9WaIPqMWCyY3L4iuYUiSYK
	CUBgBC4j78DZ6O+dCFQZNWHON47qcWgnzVx2fg+SWFj5FQPY3JgzHz0Q2Ip6xp/9tW
X-Received: by 2002:a2e:a9ab:0:b0:39c:7ef1:a640 with SMTP id 38308e7fff4ca-39f86175166mr1893581fa.12.1785531805649;
        Fri, 31 Jul 2026 14:03:25 -0700 (PDT)
Received: from [192.168.8.101] ([109.183.8.210])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39f812aee0csm3300151fa.21.2026.07.31.14.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 14:03:25 -0700 (PDT)
Message-ID: <2d413e76-2709-4d11-8bd8-b34bb7465368@gmail.com>
Date: Fri, 31 Jul 2026 23:03:22 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] dm-integrity: replace forgeable discard filler
 with a keyed sector marker
To: Mikulas Patocka <mpatocka@redhat.com>, Shukai Ni <shukai.ni@kuleuven.be>
Cc: agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
References: <20260728143350.44279-1-shukai.ni@kuleuven.be>
 <20260728143350.44279-2-shukai.ni@kuleuven.be>
 <5a838e63-f772-7ef9-ab45-8bc2c1ccae87@redhat.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <5a838e63-f772-7ef9-ab45-8bc2c1ccae87@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/26 5:29 PM, Mikulas Patocka wrote:
> Hi
> 
> I accepted the patch (and made some small modifications to it).

Mikulas, you added this part to constructor:

+	if (!!(ic->sb->flags & cpu_to_le32(SB_FLAG_DISCARD_KEYED)) != ic->discard_keyed) {
+		r = -EINVAL;
+		ti->error = "Mismatch in the discard_keyed flag";
+		goto bad;
+	}

Unfortunately, this is not going to work.

In integritysetup, allowing discard is an active flag, not a format flag.
It should be ok to activate discard later, but this check blocks it.
It should also allow to activate the device without discard (even if it
was activated before with it).

IMO, it should upgrade the superblock if allow_discards_keyed is set
on activation (and then do not allow it to revert back).

With the current approach, I cannot add this option to integritysetup.
We just have no way to send allow_discard in format action (as it is
an activation flag only in our API).

Milan

