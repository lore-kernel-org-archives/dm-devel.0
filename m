Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6140A379C56
	for <dm-devel@lists.linux.dev>; Sun, 19 Jul 2026 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473025; cv=none; b=ZsguCERy0T7Q9SQvFE6nLecP7KkmG32kg9V85apZX7SH9/dJOkyd3+cyZE3mRMpFeYk4dph0HgsfgMiMSNmWckK7UGn1opAoUOk+fOZwTq8xs6JWPcVedUGDNEurWsfwmJVXY8RGBgKC3NB5CeYfIj30qzdR3xpKHb7aGHKaLHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473025; c=relaxed/simple;
	bh=AzuwxZPCdTbUa2hKW7g/ls3n7G/SiCledKKKqWNFWOc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=RiyhI4t+dnydBJnvMlQ9c0E6OP3/ABwb9W5d7sCY2O42XmT2EuBkBGKfXlGZcYT1C+3zM7Yh5SJx7eBfcDsXXN9+ootwfZwPwjemBh2BHZEV3toYbAtSvciW0OkaQ/KsZc71HRjdjMdF76JO8KNVkIjynRsl0Ui+7s1pawuVuVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eSBGe5Mb; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eSBGe5Mb"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47f6981d244so56177f8f.1
        for <dm-devel@lists.linux.dev>; Sun, 19 Jul 2026 07:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784473022; x=1785077822; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5aqCPz+f2JL9CCXCpVSyUgPRPfXNRPseBAHCmap7ohY=;
        b=eSBGe5MbnG9lBW99RfBTSUf2/9GfSH1UT4HddZPjo+qNmZ11FXyPdCEeyL2LUQqVZi
         7olPw7IAuy2eIJtBUh3DV7VCVrjab94O26wyG2fEITLjgxAUk81y//eoceBuPJ1yDIcA
         eaTI9Dr6+bwr8BPy79DGdGVgShrw8ft3y6T4SW2ntiJsH7Q7VNYgMf9WgTwE4sK9crDo
         tOdc+qdMaglHbYRa7D1umLDCtaX6Qlba+ugm9OQpWbS1lxJINcEA0tVsG6CqLLix4OPT
         vT7vqbc9NQIyatoMtA4sm0Fe4MgS+FENyK81oA1nDEgRT+w9BDC4giIzRKkP7dW0tpER
         2mOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784473022; x=1785077822;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5aqCPz+f2JL9CCXCpVSyUgPRPfXNRPseBAHCmap7ohY=;
        b=UmAEZekcyOtAL8BE9df9HspXvQhgKmdCC4CnGBcq7tdf+WMO9gf1lUPxEk8fCtsPgv
         lEqtFJ0w9AREGaCHr2rB4OwR1GPr1bbCfRUIx/G4nDO2Y+Lai7/xwbvHlPVyvtL2Bjmu
         0tsFW1GfwlyM5gTYnf4MnxujgDyWMxGE2/LVxbHp1Ue9ZjJiqHR15O+Hu+tl1I/VIzjB
         dsCqzTM6rfV8KUqjZxXcESQV2v0qZJUeKZcPwuTMRKYlI6mEFVaRKzKUcVldBZSEKErH
         L/Q0AzE2tnxbFXgSuzY7gc4OmDU2i3Dqu9jyTQmY2dP9efMwTOK9D1z6GYGoRXmaCKQT
         VSSQ==
X-Forwarded-Encrypted: i=1; AHgh+RqJc5hhZN0KYzAN0tjsGEnCmjiIi74TrErEVm/xcSjKp3OYSpYCpsTXCIg6yyIAoGYzgJa6g0LWkg==@lists.linux.dev
X-Gm-Message-State: AOJu0YySPt0teDqFQZJZTkL0eOlJQLHCucg1xSgJ/0rsZtBnSGHW4mOq
	/SSvwm7kDVATZHpYxy73UWVEe83ntakL/Mf/b73uWJ8IugSsby9sfjk=
X-Gm-Gg: AfdE7cnY12EezZdbm8AMLNcVHJKW/FaKNg2LE1kowFmEr02eK/t68u761v7bYy79tf4
	JjQuzEwqiprUNQ/iTqwjzjaZeR88DT34YlMggmEPF5uliaft09ry+318xzEQ8LDevFjMmnoPmfV
	c1sYKHoqpv7OXBdKRviDxqbZRAsGGOlrmp1YaOnhckSmkAqG8So7L6nKvacsMS7O6svwYVSJuSS
	EVCYgTQlMK/Hmr2yvw3dKgaQdsEFoKNMXHRQNswE746EVrF6Lm5aUUUYnawY5ILl+TqP6RTapiP
	U2a4VIeND6mu1CH1E5Hd2yyW8jbCcK8WTUr1rKzoWSmBqHszLJ2iEHQngDd2wJtAm5g8tVHrycz
	HwaE+CXXuK5O8Ie/4YDfwc2At5RSCJYJSBU8BMqZlC1pH0mtPWO+3NBl9H73kohMOZm1UEjZmpT
	YVn+UQlEAs0hx2kOX7NGb7fivz5f3NyfDgoTJZ
X-Received: by 2002:a05:6000:310c:b0:472:55a:ef95 with SMTP id ffacd0b85a97d-47f622f24b4mr7298711f8f.2.1784473022227;
        Sun, 19 Jul 2026 07:57:02 -0700 (PDT)
Received: from localhost (3.red-80-39-57.staticip.rima-tde.net. [80.39.57.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e496ffsm21474416f8f.3.2026.07.19.07.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 07:57:01 -0700 (PDT)
Message-ID: <467670f5-2a5e-4051-9d24-eafa15e2f565@gmail.com>
Date: Sun, 19 Jul 2026 16:57:00 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Obsolete features (was Re: [PATCH 0/4] minio cleanup patches.)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 device-mapper development <dm-devel@lists.linux.dev>
References: <20260615190711.797573-1-bmarzins@redhat.com>
 <8b715fda-3e14-4a6d-bba0-a3e53481f567@gmail.com>
 <ajCDBM2lH7NvcuX8@redhat.com>
 <50a665f3-8bcc-42bf-ab33-5cdafa70440b@gmail.com>
Content-Language: en-US, en-GB, es-ES
In-Reply-To: <50a665f3-8bcc-42bf-ab33-5cdafa70440b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/16/26 9:47 AM, Xose Vazquez Perez wrote:

> On 6/16/26 12:56 AM, Benjamin Marzinski wrote:
> 
>> On Mon, Jun 15, 2026 at 11:00:48PM +0200, Xose Vazquez Perez wrote:
>>> On 6/15/26 9:07 PM, Benjamin Marzinski wrote:
>>>
>>>> This patchset is to deprecate the rr_weight, rr_min_io_rq, and rr_min_io
>>>> multipath config options. It's a companion of the patchset to handle
>>>> their deprecation in the man pages.
>>>> https://lore.kernel.org/all/20260607103831.336833-2-xose.vazquez@gmail.com/
>>>>
>>>> It does not completely remove the minio setting code, since there are
>>>> ideas for reusing this in the future. The final patch is simply a change
>>>> to avoid a kernel warning message that I hit while testing these
>>>> patches.
> 
>>> Ben, thanks for this cleanup.
>>>
>>> I ran grep to see what remains of these options in the codebase.
>>> Could you please check if any of the following occurrences should have been
>>> removed, or if they are intended to stay for now?
>>>
>>> 8<---
>>> $ git grep -Ei "rr_weight|minio|min_io" | grep -vE "multipath.conf.5.in|deprecated"
>>>
>>
>> Good catch. It appears I misses some things.

> I ran the following command to locate previous "deprecated keywords":
> $ for i in $(git grep -h  deprecated libmultipath/dict.c | grep install_keyword | sort | uniq | awk -F\"  '{print $2}') ; do printf "\\n\n--- $i\n\n" ; git grep -i $i | grep -vE "install_keyword| multipath.conf.5.in|\.md|deprecated_handler" ; done
> 
> It looks like there is some leftover code that could also be cleaned up, such as:
> 
> --- disable_changed_wwids
> 
> libmultipath/defaults.h:#define DEFAULT_DISABLE_CHANGED_WWIDS 1
> 
> and also some checks in tests/hwtable.c.
Is this still necessary in "write_defaults : tests/hwtable.c" ?

                { "bindings_file", NULL },
                { "config_dir", NULL },
                { "multipath_dir", NULL },


Another candidate to drop is the retain_attached_hw_handler infrastructure:
  ( grep -Eir "hwhandler|hw_handler" )
Since Linux 4.3, the kernel always enforces "retain_attached_hw_handler yes".
Because this option is completely obsolete, could it be dropped from multipath-tools?


Regards.
