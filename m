Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60B63DBD50
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 19:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772652583; cv=none; b=h7iIS1s024qMmuvJmMQJq5wojIoV8sv0PyXCF3iIbJXEFNzYM3lG7SEua/kY/trmje4Qxx3wQdehELhdf6Iw8oQnS155pk1j+1wHT1XzuCadmDFlkigX3K7HNwjPgusulZbOqmBMbcweboOIcEdbJPih26O5c+OKe4oT9RSL0Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772652583; c=relaxed/simple;
	bh=n2l4vrrM6dQsoB90lrQVmk1taYIK/Whkq+WMNAviMSo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ezmY5g61pka83O3WxdjpMDjtZtYDZCPMRJdFMxNpxVDmB32LpmZfXNwaQe8cswCU2xMYFyvbs7pN+wEy47UHoPSqNbZ4E3bKKKG2TUgPBamSPUvpaqhgRGUpvnH0hODvKqNRerA19tD/RymLbpE6VVZS6CFZLcx0d+T3z1QK2Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ilae/mQC; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilae/mQC"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4833115090dso74033615e9.3
        for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 11:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772652580; x=1773257380; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lm9iACVkQ5rMp3/kUk7A01T0NNR/z5twiFLsa1FJKlY=;
        b=ilae/mQCuPwZuh16y3aybxvDI79IjlAXBU4ZWDkZ7axbSNHWsMMRaD3bhAW6Zvozzg
         aQlM+rP9KJFEerI1yOtqNfasn7E2O9bM3Hoe1zOTd1KdbGfzRoDuHDckd67nfVP1FRtr
         RT9JTWyHFYew2rSx6Tn946qqjq3spd69V4RzLeWk33OWnIHKsMfXZrj2YYnJx4I0CkPv
         8FFPM/gRPmrlayx0cdo+3CFNihhDiT7CL1csKLKTyWqqHdLJC63Wy6TEcUtYrd1OBgJa
         6k7JcnjO6yNSVtW71Vf5YUqUdyTzHn2BfRd2awMXZBUBr7S6Bw1yLaGNdSxlfojQHQ77
         Vg2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772652580; x=1773257380;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lm9iACVkQ5rMp3/kUk7A01T0NNR/z5twiFLsa1FJKlY=;
        b=ssZqzZc5y8UAn5VDnSGgrr+vmssK+r5KGzOaIRTpp6WDOURCs6J/qKuLqHcNYLOcYR
         trq1CKDfodMU2wTnmyaWxLzhHXPqzwszubnHNzmaKOy0r8SmER/D4vSFpjWPS56H6HTF
         WhSikk+KGepooySRMSREKm0oMNUVU8OxEN2gYVEAVO1N70t9Rx/lEqPnjwImHNq1dA5t
         chsOIg+doW7CmTRHtcSKOkmdhhNiyGX+ogXiidiTM+HV98p0hbpvezh+NRks7YBqj65F
         jae+haNbpaFuREjosCBdBfQeH4/zTm66nzCm96wRmMMAko7NU5P1ihGilXiAIxKF30fO
         qIyA==
X-Forwarded-Encrypted: i=1; AJvYcCWsQRd+0i+XVIrA1qkaEcjRPZSoAPIhFUcLRBtX74keBKE9aL7Sh/N7wjOO3qCbiwDZTv4P/3GkDg==@lists.linux.dev
X-Gm-Message-State: AOJu0YycMKUfFp2bXArhdasSMMRcH0/HoZis0VGMuw1mSVKTo0x0hFfK
	gbSotAbnTFy/caCohIYU+jlnHMdHNwdGqIWhoEaiKlIbOlnWU9xHyGnz
X-Gm-Gg: ATEYQzzdeik3NVZfWn86cHUko37YkmsHnI5Y0FBBua/RP4NH5q55PqSb0Hr3Y85K+gO
	cvO/HD6ZZqT10XRpIQKLLXh/brw5A0/zzMMnOF3M+r7kAWBymt6gOb/ghd6D1eWL8rniPy3Agb7
	rxLxL9+KYzs+VgFPkfLpw63cm/th4e+eDLVo/13ltXhcQB5zeUmL9z2muT8Q/FaDFcd/zWSAQVT
	qlYf7v2NErCTw+miNoDvFEWjlcTctAT++03VxMTpvYGYhq4nNjAOumPTC3Sn9dC6WI0L0dsjSYm
	Rb3Dmmy13e7tI7x1srR/MzNVf4YD4vgmqtw1IzduNJedyPpSU3Jk2V/qBtj9Hz0w3eXlmwKmlT0
	QylCXJUMg8Ob+iH2MwVAhZuIte3OJJB2+SMrYA1GHFUbA7SgXVBkhKhcr/AXdcalxr1qVWPlW0I
	n5zLECq6dn9YY8xjggEW2v5CxJhf+UER6ESa5A+MlaqGAn47xR
X-Received: by 2002:a05:600c:a0a:b0:477:7a53:f493 with SMTP id 5b1f17b1804b1-48519895542mr56235835e9.23.1772652579865;
        Wed, 04 Mar 2026 11:29:39 -0800 (PST)
Received: from [192.168.2.14] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439ba2a5970sm22063129f8f.33.2026.03.04.11.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 11:29:39 -0800 (PST)
Message-ID: <ea4818ee-8039-4c40-b98a-b9a643f2c0e0@gmail.com>
Date: Wed, 4 Mar 2026 20:29:38 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/22] dm-verity: more FEC fixes and cleanups
To: Eric Biggers <ebiggers@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, dm-devel@lists.linux.dev,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org
References: <20260206045942.52965-1-ebiggers@kernel.org>
 <CABCJKufKYMPcjiviWdGR=h5HVAmavwacsSdMNPQaaXeeL+GoFw@mail.gmail.com>
 <20260303201656.GE2846@sol> <690a74be-4707-4bf8-8c71-685dd8831664@gmail.com>
 <20260304090013.GA2211@sol> <32e6883d-3818-4e7c-b626-4e4f609928a2@gmail.com>
 <20260304174544.GA3342@sol>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260304174544.GA3342@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 6:45 PM, Eric Biggers wrote:
> On Wed, Mar 04, 2026 at 10:34:37AM +0100, Milan Broz wrote:
>> On 3/4/26 10:00 AM, Eric Biggers wrote:
>>> On Wed, Mar 04, 2026 at 09:25:02AM +0100, Milan Broz wrote:
>>
>>> Okay, it sounds like the verity-compat-test script isn't open for
>>> contributions then.  Would have been nice to know earlier, but thanks
>>> for letting me know now.  I'll plan to start some new tests for
>>> kselftests.
>>
>> That's not what I said, just I would prefer adding new test without
>> the need to completely reformatting the test.
> 
> Adding new test cases to that script naturally requires understanding a
> lot of the existing code so the new cases can be properly integrated.
> For example new test cases logically should use the existing helper
> functions, common global variables, and failure reporting mechanism; and
> they shouldn't duplicate or interfere with the existing test cases.  And
> in some cases a new test case may be much more easily handled as an
> extension or fix to an existing one; for example the easiest way to test
> fec_roots != 2 probably would be to just fix check_fec() to honor its
> existing fec_roots parameter as seems to have been intended.
> 
> But with the existing script not following modern shell-scripting
> practices like naming parameters, using local variables, and passing
> 'shellcheck', I found that to be a challenge for understanding the
> existing code and adding new code.  Especially when these practices are
> causing bugs, like the ones my merge request would have fixed.
> 
> So that's why I thought a broader cleanup of this test script would be
> really useful first.  And I was glad to do that, which I did.  None of
> this was meant of a criticism of you; I'm just trying to help.
> 
> But it's clear I wasted my time and should focus my efforts on the
> kernel, kselftests, and other userspace projects.  So I'll continue to
> do that and leave cryptsetup alone.  Sorry for trying to contribute.

Hi Eric,

I actually agree with you on almost everything above.
But this is not the only test script we have.

If we decide to do cleanup, things like ">/dev/null 2>&1" to "&>/dev/null",
or wrap long lines (as in your series), I would like to do this across
the entire testsuite. And actually, I can do that myself; I just need to plan it.
These changes are pure cosmetics.

Then there are some real cleanups, like local variable naming,
that make sense to apply now. If you submit these with real test additions,
I already merged them to the main branch.

This is the diff I am talking about
  https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/890/diffs

It's common for maintainers to have requirements for code changes.
I think we both know that.

I would like to see that both the kernel and the cryptsetup project have good
code coverage for dm-verity. Kernel has none currently.

As we already have a testsuite, it would be nice and probably much easier to add
new corner cases to test your recent dm-verity improvements.
But please also try to respect what I said above.

Thank you,
Milan

