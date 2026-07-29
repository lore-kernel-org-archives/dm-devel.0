Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E373F0AB9
	for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 23:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785368098; cv=none; b=JBK/wnay4MO9WhphXb+OY6jtVMHdSRC3DoN3cBzdzLMiOTLVAVhB6ktw5vykgsH3xJUBK4VgDTdgtNswEdqwggTiw2LBbI4omUiSjFakQ32wQfvXAdj82kXrQn7lma9gqV9mXSJaDq9DkorLvCS7k8OmBlrQqvg91Dk2CAu0axI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785368098; c=relaxed/simple;
	bh=RB9HtFl61EAJfv6VC2+ERAfKhcFBRkXCobO4AlkIj4I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K6bGBtZQ3m/clxbu0Qz3c16OzELwj7njky/GrEpbkrAg2YI6BKcMwMiwqqTh4aal7YT17IAmplzTH5xj0718JhNnr7ADthrbCIgwD2PVm73JaQUEYWTFcWjPfnX8eLhgWHYEIIFJSaBGq56PQHWaBuAu/1d8H/0uy07vmheyVkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=n2/O5Rlf; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="n2/O5Rlf"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6ab021f1daeso619052eaf.2
        for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 16:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785368095; x=1785972895; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6uzflvLSuPG8CH9KOQG8sh8lUY8SKMS16BLacdgskhM=;
        b=n2/O5Rlf9AFTDkveLJTdbhlliqDOjja0tdvzliXtlM23mnHM5tlOWtYNw9z4FCFHOi
         9qtseVevPW3OcG9/fcT/UuPoRBlpJnYdEyXU5P8MFjyvo7AoACYm5ijO/WD/B9JZIKGv
         gFP6BZ90w62htk1FHGVoHUX02lfCBbkQAUtmZrh+UgASPD9SgX7WKwy5aivAQtsBtT5Q
         B99RK4Xu9eDr7v02uZF5wIW8f9kEskv9Zt38WYJJWLkRjXpwlBgYEaugIsqPSpTdhTpi
         RvcW+hxSUT4RzXgkG6VQH3g4bkBhWs+P9u2vogrTACpT6QxHH5ER+xxdHj/4mHtf4F4e
         Lbsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785368095; x=1785972895;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6uzflvLSuPG8CH9KOQG8sh8lUY8SKMS16BLacdgskhM=;
        b=UVVMG0q+t9V5402NpJmpgD/YNoCF+wpKAdyRca1s6RiiCgZitzRXL1KDtI5LS9v0aZ
         qEZCtUsFlHr06uxnzsdYrSQZKC68z4WDmhZFovjcoYuaUtGLRnQ8OCNUTTUiJBgRWgIV
         JJikHT3iW0DMVbZriTtGaVqt5+49Zs4wB9yQiKEoLuujGHrJxjr5s3hteXVm4Cfzm9Js
         osXN4Eu402zxK7R4TA4wiPj1umQSRE2ps+lhk62x5Ld0So3ROYaP/BHdw9zlydVHpoRE
         kGGqKGH8jMPFluYlDY/8QkTPXGtA27R4CtcWh/sW5E0b0YwaSp1GR6r6oZ3VNt3fkVgI
         d/qg==
X-Forwarded-Encrypted: i=1; AHgh+Rpd/jJrds+eGCa5srYBUiSAWFc4INL0zeJ1hjeoNwHffYq/pBoBY9niisWBjQo1dEaZFWUaYQt0uA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyHxaVxgCdLA+Ajjdf9mZ7rG9YANv0bxLwM/8oPlOCga8/AwDlR
	3cFWlScNrsyQO/EaspCwd1i51JEN5I7rM/DBwJGZrLuuoFQFcJDn64GT3rBKF5/9Abk=
X-Gm-Gg: AR+sD10dyIWfszJrBRRLFNFwbYcOAgA+O6Jk4rVkG/fCPDniTDaHMAvubtPUOaemmiI
	gGFOExq3SEN+NhQHfrlP+OqzUf+vGG9qAeMZFX02msMftLC6nGSjsfQu6JFB5es2DoDQ1U2kHN6
	CcScO24bv5a/i77rFXDnqgZoLSOqqjaeVcp0Hnn9UxxqyJsRdSb1t7J1P/4UIWTyF7V4VeUmEvy
	eQNAVXFmlebKPp/Rbn7l6gZMP6RRc/JzhtSZP8h6iD2aAIBFZygIjMTVnvVAUgA6MhpVZav2x/M
	OPoLDKvRwH9URi9KLKhXKwVDXHYdnsQSGLQhPkwCBmrGk3whF+XT3UK/wzdfLTK9PSgCEKF45Hk
	88el9U/KmqPBdppeGlxc9WDwqJhMbwoaX+oIiAYkpz1YPs+Kl11K498jtvJnLDRkz9s4HBtyipW
	J6Ebo2GCpNy+g0qho7dGAGnaIvbi2IEBdbzmdtArHuPNeM67GWS8Fc6G+LTjvn5KmzX9h9vt0zS
	Y/xF4jHmdOxtKer492i08kv/CYvzl74MhQQJd+5elBePsQ=
X-Received: by 2002:a05:6820:80c1:b0:6aa:e844:fb22 with SMTP id 006d021491bc7-6acbbcfa066mr243418eaf.11.1785368095394;
        Wed, 29 Jul 2026 16:34:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6acbc29be1asm222785eaf.5.2026.07.29.16.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 16:34:53 -0700 (PDT)
Message-ID: <831ba530-b6a0-42ed-b636-10b1f89b6142@kernel.dk>
Date: Wed, 29 Jul 2026 17:34:52 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, hch@lst.de,
 brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk
References: <20260720201057.1862857-1-kbusch@meta.com>
 <ampRQyXDbGgeg49V@kbusch-mbp>
 <fbe9e74d-c389-46f4-9874-3e9ffd9c91d3@kernel.dk>
 <ampce7mxSmxAwAiu@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ampce7mxSmxAwAiu@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/29/26 2:03 PM, Keith Busch wrote:
> On Wed, Jul 29, 2026 at 01:18:40PM -0600, Jens Axboe wrote:
>> On 7/29/26 1:15 PM, Keith Busch wrote:
>>> On Mon, Jul 20, 2026 at 01:10:52PM -0700, Keith Busch wrote:
>>>> This addresses the misaligned direct-io problem behind various threads:
>>>
>>> Hi Jens, have you had a chance to look at this one yet? This addresses
>>> previous issues with certain device mappers under direct io.
>>
>> I they look fine, but at this point we should toss them into 7.3. Yes
>> I know there are regressions around this, but from 6.1x days. And the
>> series doesn't apply to the current block-7.2 anyway.
> 
> This series is kind of old at this point, but yes, it's not fixing a new
> regression either. I'm okay if this goes to the next window, and I will
> handle the stable follow-up.

OK good, let's do that then.

> Are you planning to start the for-7.3/block branch soon? I can rebase
> the series if there's a conflict, and would be great to get this exposed
> to linux-next.

Pushed one out - send a new version and I'll get it applied when it
shows up.

-- 
Jens Axboe
