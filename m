Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2340036683D
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 03:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772595310; cv=none; b=SKhWvGC2GoeO7IIOXmMqAM6Zl/+WFJEShtSO5W8hpl5vmDFIUS+rInG9Bq4TCBr1a4RI3GcMf+BV2ilHlno8cnnQhohiZVzePBtTclU+ZVX4NOaK1XBrhdhPLYV2YcTbr6ZoZZhvxx5yP9tHAglM2kRT+Mronim3v5gC+tm4OaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772595310; c=relaxed/simple;
	bh=XLiJ2nD8DJIVsSYbftRzQJ/qqbqmFgul82tptWrTWOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FLYgtUtzgQw/Cy6q3zLT5Q8xAcePEW+vJ0VwrnJwlqgD+zdGma6Ov6s+6otTpNvAuE9U6XbzTsiCSKSLnsmVPw+sb4OstljY9QZgnxjLWPuOK6SbbO5j86SyRVHfyYR95v0KX23Y3vqaBlyvPNRkGSI7sn2EI4pCbbe9PyhJ79o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QHE4RM62; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QHE4RM62"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d4c383f2fcso4377081a34.0
        for <dm-devel@lists.linux.dev>; Tue, 03 Mar 2026 19:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772595307; x=1773200107; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NrE0zI+7ilR1NedBJHHio8t27882PDymrHrpls6UPoo=;
        b=QHE4RM62ShmC9lkYBjI9BTR61WUA9T4Vs0ivgp/Wt9OxDzDmewU11m8TnHYRqeKNik
         qTU3GSlU+AOMYC6oZoW1fwF/WSipxsmrzao959qmDvz3IrjtLyP8C9NfKOSEnuvAGdIA
         PF8UhVYUZQoMy/RSmrgeZHYmkxqghuzD7bc3hAtlqgz3+QwYcvwogaIr3j8U0BktD89/
         NccLyWS40wcykSXmvE5hyZ0yYpmm71Np4XoFq0dPZ+7DOB/4vJW7t2XiqLMGS075pLs8
         RAzKhuriSCjvqOqd64AXiES81pF1x5KuNybaAyvnsVPRQAxs04zQFpPReNbYc641VK0Z
         +31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772595307; x=1773200107;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NrE0zI+7ilR1NedBJHHio8t27882PDymrHrpls6UPoo=;
        b=ihQrXlbd/G4lYoX3EJIAMNoL+sB7oaPagU1urj8IIrVWiNu1O+zMOufhkv8DxfEI+y
         lC80bwAP/PBOGLMGInSt9LqiKuJsfAyx2Et775isZ5yH34VsqwSlmVTlY+lKIKNwa8yh
         hqDppQUihs18A1aPPZrQhjyrCDe2bc9ACB3hJn5HesU5/qke5GiTt2EguJ29/yhaWOgY
         psQ5KjckWKa4TdZMP4hdSXH5HguW1j7/5tuGvJEVFgmA/I+0SAeuZ5xIFpNkSdNNfei6
         hUAZgfFPze6DLNhDmBNfQH5Pvb5FgcVNzvOXaHNOpCbNG3rUs6277JyS7oTm/g3f/ZKC
         JX7w==
X-Forwarded-Encrypted: i=1; AJvYcCXGep+C7OsNySIKbuqoSff9pZRLxiA7DyRWCtZbvkh3Y8LplVBp0az2xYqkJ6aRLdr9jFF+gtID2A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyvHmZ9fRXxlmdTUBNYMvHM9B/ftYbtlAlo2fLLjVysA3lc4Psc
	GgwrmPo+omSTxh5FlxBky6E80F86an2gHl/XTGitDjGtS/1jn5sVdBYL5sNPMSIctUQ=
X-Gm-Gg: ATEYQzz5Zt3nfFgBpx0gdikwlRUBMmpccI9sJJzdSyxfL35yx3BFj9skf1modOosRJu
	THXyNogm95bboIKfT8l5CDkOkrCi1vlOs+oyGgWZQubKaiDiBT1NJfSLP6PkdW3hwdcMSUH+mp3
	oMRkQT5sGOiZ71AbdSVRZoi8k6BfVYB5ybkLtRJSoxyQp6bE3SXxGtfmEev5shzZ44FBbEtGFu5
	hxpY1fVNh+8KpuY66ePsnRMPddkW1OMbXX4HRQq0CPQqIN3dMpIZzVcjkBqPDckoZ1HOgAyPAPh
	aQT2ik44ewilAeOqydeXYIlSDf1rNesbrr/Rh5X6DW+inK6nGMSrWacYCsCNFnuIPq5k/CBfm3b
	d7VlFG7UNfItaIM0UYoMNpr/i3nBM3fd6X+3x4XDaeh+QUUSIRTSxGh8rVVFZkPuLqkGr7P7pO0
	lFYeQbZnp5WoDYxNrwxzqReCjFtn+W/Cb2lgpPnrnufceknWh7ua7Cc07PDINETLlnzLJYpoW5S
	GEiy1keaw==
X-Received: by 2002:a05:6830:6185:b0:7c7:6977:17cb with SMTP id 46e09a7af769-7d6d139f788mr450044a34.21.1772595307034;
        Tue, 03 Mar 2026 19:35:07 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d586653f6asm15202012a34.19.2026.03.03.19.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 19:35:06 -0800 (PST)
Message-ID: <e96e851a-9050-4d8c-b1e5-bc3b5d91a84c@kernel.dk>
Date: Tue, 3 Mar 2026 20:35:01 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm: globalize rest_of_page() macro
To: Yury Norov <ynorov@nvidia.com>, Sean Christopherson <seanjc@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, "Michael S. Tsirkin"
 <mst@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Duyck <alexanderduyck@fb.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Alexandra Winter <wintera@linux.ibm.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Anna Schumaker <anna@kernel.org>,
 Anton Yakovlev <anton.yakovlev@opensynergy.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Aswin Karuvally <aswin@linux.ibm.com>, Borislav Petkov <bp@alien8.de>,
 Carlos Maiolino <cem@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Yu <chao@kernel.org>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Christian Brauner <brauner@kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, David Airlie <airlied@gmail.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Dongsheng Yang <dongsheng.yang@linux.dev>, Eric Dumazet
 <edumazet@google.com>, Eric Van Hensbergen <ericvh@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@redhat.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Jani Nikula <jani.nikula@linux.intel.com>,
 Janosch Frank <frankja@linux.ibm.com>, Jaroslav Kysela <perex@perex.cz>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Latchesar Ionkov <lucho@ionkov.net>, Linus Walleij <linusw@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mark Brown <broonie@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Miklos Szeredi <miklos@szeredi.hu>,
 Namhyung Kim <namhyung@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paolo Abeni <pabeni@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Simona Vetter <simona@ffwll.ch>,
 Takashi Iwai <tiwai@suse.com>, Thomas Gleixner <tglx@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Tvrtko Ursulin <tursulin@ursulin.net>,
 Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>,
 Yury Norov <yury.norov@gmail.com>, Zheng Gu <cengku@gmail.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 dm-devel@lists.linux.dev, netdev@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-crypto@vger.kernel.org, linux-mm@kvack.org,
 linux-perf-users@vger.kernel.org, v9fs@lists.linux.dev,
 virtualization@lists.linux.dev, linux-sound@vger.kernel.org
References: <20260304012717.201797-1-ynorov@nvidia.com>
 <20260303182845.250bb2de@kernel.org>
 <f8d86743-6231-414d-a5e8-65e867123fea@kernel.dk>
 <aaedwFwXh9QXS3Ju@google.com> <aaen2pGs0UeiJqz1@yury>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aaen2pGs0UeiJqz1@yury>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/3/26 8:32 PM, Yury Norov wrote:
> My motivation is that it helps to simplify constructions like this:
> 
> -               loff_t cmp_len = min(PAGE_SIZE - offset_in_page(srcoff),
> -                                    PAGE_SIZE - offset_in_page(dstoff));
> +               loff_t cmp_len = min(rest_of_page(srcoff), rest_of_page(dstoff));
> 
> Or this:
> 
> -               if (folio_test_highmem(dst_folio) &&
> -                   chunk > PAGE_SIZE - offset_in_page(dst_off))
> -                       chunk = PAGE_SIZE - offset_in_page(dst_off);
> -               if (folio_test_highmem(src_folio) &&
> -                   chunk > PAGE_SIZE - offset_in_page(src_off))
> -                       chunk = PAGE_SIZE - offset_in_page(src_off);
> +               if (folio_test_highmem(dst_folio) && chunk > rest_of_page(dst_off))
> +                       chunk = rest_of_page(dst_off);
> +               if (folio_test_highmem(src_folio) && chunk > rest_of_page(src_off))
> +                       chunk = rest_of_page(src_off);
> 
> To a point where I don't have to use my brains to decode them. I agree
> it's an easy math. It's just too bulky to my (and 9p guys too) taste.

The thing is, now I have to go lookup what on earth rest_of_page() does,
whereas PAGE_SIZE - offset_in_page(page) is immediately obvious. It's a
classic case of "oh let's add this helper to simplify things" which
really just makes it worse, because now you have to jump to the
definition of rest_of_page().

IOW, just no.

-- 
Jens Axboe
