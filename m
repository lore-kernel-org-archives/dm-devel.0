Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F31D30B501
	for <dm-devel@lists.linux.dev>; Thu, 15 Jan 2026 21:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768513100; cv=none; b=OXuBRLlhJrAfLPvha72iqmrHPSh2mg7j0L5oviJYXtHjWPh4qIR+nmfHfG2Hu0o00KI/e3oDZ/gn7J5MbjcUCUogfjN1wL7WOVIhviJoIM9kvbYbNg51sd8Drm3xXH7W0cWtyBwUnyMZ38oJSWXR3I7xKjh9HZKXIks9TyYKeCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768513100; c=relaxed/simple;
	bh=m9P223K4ndO21TRmHjkqIe0258b5/ga1xzV0jmWff1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I3qZVn/j6nXb4lz7Vd36Ue2bOcO8+Yl+OF3Vmb+NMkNAOhUVuDNuFobTn4PmDnVv3jG1uORLsY6mbeVtK7y+7ERJxdpKglUynHG0fx/+WHUfMUMdbOtTxOL0v2O0Aa2YYbQg7YVeslF7qyEW6sKJwBagv1IbhtzuJKzJxVHCuBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jUqMumTM; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jUqMumTM"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47ee57c478eso1029295e9.1
        for <dm-devel@lists.linux.dev>; Thu, 15 Jan 2026 13:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768513097; x=1769117897; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m9P223K4ndO21TRmHjkqIe0258b5/ga1xzV0jmWff1o=;
        b=jUqMumTM6FedD46XfmouRIBkAQBtgprUJdjfUxMGIh5+gnFxGZ+r+T5H4JH3RcjaOz
         CWe1riKQUVQ4Onq42h1B7R8hDz2IaBxrXQdyGK/B+ZRCuv70t2WcWV/S65jPcCC+0HLr
         nuif1iUr/3ksW+zuUIHTJub30tgHWwHjUp95M53Pt4NX/clukMl3B1eddGBw9hdJrGRs
         kgPwu+ubFX+YmtbP2lXzodzccL5w5vVLtiHyZZ+KdWR7uvDhtQdIG7XIgKeXFtZ/A2R9
         Ww1yQ+H9HieBEWYpfiwDqysf2mL7dwGb5+OOZMWdpgCKVgi3RrEuBJqpjkKbi42yMrx0
         onTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768513097; x=1769117897;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m9P223K4ndO21TRmHjkqIe0258b5/ga1xzV0jmWff1o=;
        b=gXziU9RZkvmW6O6RF29cBsnb4a8tm4L5yzhCdnm96kOgueofs9vjLl3vIyn91FVUoa
         cbrtQ6MiobVNUl4OgcxAKtc8MpDwI9RKDUl5fUVIk5pKC9wAm19Yb3vYaU09ZOZIIAA8
         1IPMXh9Pt0FZxuVcLm9FXvXTllG9QAeHe2fBNUkKOLTw7UUYGFr/+ATxvLpMBc++4o4/
         SHpKGUgesPVdUtvHze6Ig0DKvz4HtJncsLNzVjN13/NTv5Y8O0JjFlxviEPpcQLWRb6p
         4Sl+oLnJp6Yzs0iG2o+nqiW08Y/teyRs2IG/ul1/TWIPyuyN5w2F+zZEyuVajbpQ+Ix7
         B62w==
X-Forwarded-Encrypted: i=1; AJvYcCVigdhEsIiJHfTpjUyDyhe0pXfYYwjWILyPrlFZQ6eIgNw4Hj1DKRibjf/datx8L1T0dGABaMAgVQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4U7ZG16p2dkc6wwPHgii0bKMpiJf8rP1qVzeBhJy8FZLX5tDv
	5gt2l9DEp1RXVRZnPQbZ2THlod6pOgDlfcehmI7LWaDTvOcDNAZZCZ00jciykgU=
X-Gm-Gg: AY/fxX44LcGp/jKNUMpUy71SU712zNy3uJ1ScmbOBvTK2vF2Ycgmwr3yFFL6NyuxYO4
	lHfXwVEwGsZHneLZDb9b8SUVgch9KMZmcM4V8uHa8RkRSQ1ivd6Fdl9bDoFa/qwPXuENINDU+TI
	53q8TTxhmaBWZXTMTKmOdOvuquMwsoKOdVglJtWdS8nY5LrvtKpV478w4Pig3x5lFeaJpgrQ0Am
	qcrQN5uhgMAcyRGwnCXqGCH24a+E+PfSuv6OzA0a3JL2R/tVA/SSTuKCupRdSi7dtqbHg8WDHw5
	Rm3ZAzapg/mPK59ilrj1IDDXWJrZ4z1nlNkVUADktCzmzQ/0TkkHjEF7jg5m7j2wxyIwChz/2Kx
	TcwJPsazIkQvw2I7exKY1oCUfQTM9F0BwjjplWxh6iKFXY2jxdwnMgb+ELFHJBveWHXKIDvfVkK
	haQULxfHHeksSdnaNReGUgsYklmLBTUKXSPlDfulpqW5tr36nMn21VvNE=
X-Received: by 2002:a05:600c:64cf:b0:477:a6f1:499d with SMTP id 5b1f17b1804b1-4801e33c5ecmr6708125e9.3.1768513096700;
        Thu, 15 Jan 2026 13:38:16 -0800 (PST)
Received: from localhost (198.red-80-39-149.dynamicip.rima-tde.net. [80.39.149.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801ea09747sm3360745e9.7.2026.01.15.13.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 13:38:16 -0800 (PST)
Message-ID: <fdbdda06-c36b-47f5-9492-9c4cd1c4035f@gmail.com>
Date: Thu, 15 Jan 2026 22:38:15 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] multipath-tools: move SPDX-License-Identifier to the top
 of the file
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20260112161607.55522-1-xose.vazquez@gmail.com>
 <1013360c887d3d62b30d6baa832c653ee1456a10.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <1013360c887d3d62b30d6baa832c653ee1456a10.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 10:25 PM, Martin Wilck wrote:

> It turns out that the linker doesn't appreciate C++-style comments in
> linker scripts. I'll fix that, but next time please compile-test your
> patches.

It seemed trivial, I'm sorry.

> I'm not sure if the license tag really needs to be in the
> first line of every file. I only found the recommendation to
> put it "near the top". Anyway,

https://www.kernel.org/doc/html/latest/process/license-rules.html#license-identifier-syntax
