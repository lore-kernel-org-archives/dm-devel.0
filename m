Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B74741C94
	for <dm-devel@lists.linux.dev>; Wed, 25 Sep 2024 05:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727243344; cv=none; b=r7Y9PC45s0htlAJ4B9iDXK6BTUypFlRO4q4M9DLGU7ciWRPGHFe3StZVtYLCFucqmFK1NFSLSSpsUKPPbT4lN4cbmlEWWsYx/0sxf+E+AaL+qqZH+GSiqkvPdl5KUMlIqOLAQYXpAA2h87Z5MyDEsnJm5WWDNE/6UMmf6ZGgmCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727243344; c=relaxed/simple;
	bh=1ujCjcxUi3sLGlNtt4c8QQHxHojrGhB0NAM2gII8b4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MqjR59kdRpjKgRQLHwusq+xsIKBRxTxtH6d8fyypyQy3rIpimChgBHP2KvDLe8azBpFrLZauycun80ejkASCdfjZamU2ekbMUICLCvUcTrdsJIRw+ev+JnvqxzWXT7ukECzjFbpz2e7pHP7FnjLA1YPqMRAoL1iShMiei/veT6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ihS+taMj; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ihS+taMj"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5356aa9a0afso9929052e87.2
        for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 22:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727243340; x=1727848140; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yzhxUVMJku0nQ3jE5qy1WQYrFXyJoRSDOr4hJqbzmts=;
        b=ihS+taMj0EufHGL4GiouMoUKvs/4BMdnPI7d1hzwDqiKk+dYtuKZihdbRCviirfUjm
         lf3sPe2pqdDUb7EcgfBMKLNhNBIMpeKXTXeeC8H4z6HzF5AlokVZbreotftYgxv4fh7s
         CL4e8PlAqwsAj2wt+Vd7trn+qU1fu7u8Dfpm8EK9S7UH1Zik22pyYRu0xJBEMh2X/AM0
         QKXnANbkx/ScUunvSQFXU7EsHEuh218GID2h5Lks7dYA8pHL4IWWbVpKKKNW+TJp8c3L
         XLPuxzrddzIRVAT+5z7KxGk2mgMyWBZp5d8HHlbpo56Nryn+YamyRbumz6xSZvVBv31E
         TPjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727243340; x=1727848140;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yzhxUVMJku0nQ3jE5qy1WQYrFXyJoRSDOr4hJqbzmts=;
        b=Zbu9Hkh/wJOz+OyWc88FqibT+VyAc9f9V4c19EZ60IvF8JX7sM0gNJBQlZ5Q9aT1ar
         CZQM76jyBr4qQIwDdM4LQEzRhxgTGjmdwZpldd3xIaLsYsjMaiGuG/QPV13aFOpDYOTk
         pakrlIc+uWW2pDcL/8qUeEygM2ATEICTrDfKtAaUjMlS0sCa6X+XfwmmFdUe4dGvs2Qd
         bBjqGmHsizjikAl8w5N7EjzQroAlvpzY4yXzC7zvU5HAsR10X21F9GsKaZfy9Rf83AXk
         TOdhGoOgT1GENbwKFliiILUShQzTUX63jot6a42AvfBkXNBPR9+JGxmtZGyUSr8pJRvG
         M4kg==
X-Forwarded-Encrypted: i=1; AJvYcCVccLTAS1JK8RTUk3BB8kICkBGFdkeaVwJMdxL7Lb034W5wpnu/7XhOa5A/9ErP855xCrndyxQ2kQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyVYSGrz3osrHPT1AnZIlKHESVKclSf9EdVLmoEHicfCAwivFC9
	Un7y6dYG3/LIFQ86kcG1P4xLJXrs5ZwleZaZsQ+F7YrEBFuGrV9m
X-Google-Smtp-Source: AGHT+IH7a84/iaLaN/Q33sQFE4krlR5w8Cpscl3lRf2ApcuAKOwGcX7YhVJM8zo8X0nHlWkQVVoT5w==
X-Received: by 2002:a05:6512:3993:b0:536:54bd:8374 with SMTP id 2adb3069b0e04-538801a69efmr781918e87.60.1727243340087;
        Tue, 24 Sep 2024 22:49:00 -0700 (PDT)
Received: from [192.168.2.30] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9392f34922sm169601266b.34.2024.09.24.22.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2024 22:48:59 -0700 (PDT)
Message-ID: <b65d67cf-9904-4182-a113-2d9a241dd668@gmail.com>
Date: Wed, 25 Sep 2024 07:48:57 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Mikulas Patocka <mpatocka@redhat.com>,
 Akilesh Kailash <akailash@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
 Maxim Suhanov <dfirblog@gmail.com>, Alasdair G Kergon <agk@redhat.com>,
 Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>,
 security@kernel.org, dm-devel@lists.linux.dev,
 Eric Biggers <ebiggers@google.com>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>
 <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com>
 <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com>
 <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/24/24 8:36 PM, Mikulas Patocka wrote:
> On Tue, 24 Sep 2024, Akilesh Kailash wrote:
> 
>> On Tue, Sep 24, 2024 at 10:44 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>>>
>>> Hi Mikulas,
>>>
>>> On Tue, Sep 24, 2024 at 6:18 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>>>>
>>>> Maxim Suhanov reported that dm-verity doesn't crash if an I/O error
>>>> happens. In theory, this could be used to subvert security, because an
>>>> attacker can create sectors that return error with the Write Uncorrectable
>>>> command. Some programs may misbehave if they have to deal with EIO.
>>>
>>> I seem to recall that this was intentional. We used to restart/panic
>>> on I/O errors with FEC enabled, but the behavior was changed in commit
>>> 2c0468e054c0 ("dm verity: skip redundant verity_handle_err() on I/O
>>> errors"). Akilesh, do you remember what exactly was the issue here?
>>>
>>
>> I looked at the history and the original intent and the idea stems
>> from this patch:
>> https://lore.kernel.org/dm-devel/b004e7c7-f795-77ed-19b9-983785780e92@gmail.com/T/#mec4df1ba3f3cb63846875fb2bfc1f8b3100f31f1
>>
>> I think the EIO should be propagated back up the stack; I think this
>> will trigger panic
>> even for genuine I/O errors.
> 
> Maxim Suhanov's point is that you should trigger panic for genuine I/O
> errors. Otherwise the attacker could corrupt some sectors and let some
> program receive EIO and the EIO could confuse the program to do something
> insecure (for example, to not load a configuration file with security
> policy).

This is a very strange reasoning. I can say that restarting on an IO error
(that can happen in normal situations) could cause another security issue,
such as DoS. EIO is not a data integrity error; it can happen even higher
in the storage stack... and the application should handle it anyway.

Mikulas, could you please describe some scenarios where it causes
security issues? Using bad policy from a file on IO error looks like
a bug in userspace code, not a kernel security issue.

Milan

