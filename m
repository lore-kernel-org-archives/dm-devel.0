Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCDD53E2E4
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 19:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791919010; cv=none; b=pH75vnaHYMFInJxj0TeXJXql8TbAbIeLmsMu6P+LjxZW9Eyue0hV6w2mapqC7M4MOjB85HcNpOKqPlph7cfayE4YLswF00mmuIzdiNIz4gowhaz+/ao0s9fQ11cqio9nXloizRXombqLDR29vOQ6dPkwt8lyxpgypNeWmosBxN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791919010; c=relaxed/simple;
	bh=NZKCsIl+eMG9fGsQjejtk9lf0m8MqeFHKmqySR38f9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AR88rFnKXOxnfr6bH+5rFKj3FE+azpViiHkHbSIJSkhuM2hCkE6uxXf4/MnltRzJeRymQHshehtoM6Y8og04MRGPI3VmQ1bFihOd5GlhW/h9RXe5GP6ofFXPD1qoLs0bWb5kbG4laXLjDwpAhXMXw1zXLfu1XF3dPsaSL6h82AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=VEKPwLm5; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="VEKPwLm5"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6cfed5dd083so192086eaf.1
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 12:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1791919007; x=1792523807; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9LMVzPqyuXj5ApWA2StVi76ci1CLBOXVU23pBi3Y7Tc=;
        b=VEKPwLm5hqA1UzsaEehO0GrLbufuGRnaoqzTD9RpErgcU/DEPRkF0oeL8GUIdMrGEx
         szkWZxFPxusrq/Reh0DPtg5KppDMwK7GSfIt/HWxSp3kClteM2D1gp+9Q9O+/WwIoWTS
         65jnJnP/Z87AcZgQ0o48L467LcdQhC/zfdnDlwUBsWEA43xlNBxxghqAafEYbcMraTh0
         U9svLgwiOC8V2MBnbQmXGP/3D3B6BeLx6q/M+2jgVJ9R7/Svrq8gD4AvtyjsotGu7jk7
         i9x7Ae01mXTw7BzQafzVA6z8prsOao2z6pkOAnkz4UbWpVjLA0RcyZvWQhiVD/0yxtIu
         Qaww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791919007; x=1792523807;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9LMVzPqyuXj5ApWA2StVi76ci1CLBOXVU23pBi3Y7Tc=;
        b=Rvjt6pCx5JEg7w511DrXMnFUzUqGqHZlE8AH9q097jGTWk1eClBk+f8ofm/tgwwkyb
         K7l9ewjnXtK9gHCKve1l1mzOmyGojdPrEogbO8qkXi0WMCEPK9dPmC0RK906vwhVCpAH
         SrycUWILT8/t8nZxItIpjmjO3kl+XZpCbEFznDXXZHaeOAodLD3eosRfnPjC2ZiU9EI4
         6eZnyw9UGrXNgtWG83BxKRTWWCrsA113MFGRQWl7hBtMRfMybQ/0v6YTDowees8Uk5ZI
         ijLZEO2gQ8IbBSiuAd2BY2vpARmIcntZQeaT/eLV9N7X4aJ+46LopcRo46AHgy+4I+Fc
         //FA==
X-Forwarded-Encrypted: i=1; AKwUvBzFvJpgFoLxcUbksgEbBUwsz43QAHS8xd8wEEgHgwtEo3cu9IRCQtPH1vqlqgNKsGd52CLC3AXcwA==@lists.linux.dev
X-Gm-Message-State: AFq9FYI4Qj3YKK7fOZJJIEeTtXXbTNNrmLARjlNh4QOridoNY81cabUq
	i/cp6fbWymR79Bk8Z25pcB2J91Kby1HfSj53sIFVi3lYqeNefK+rkMSKtEg3dkjJmDg=
X-Gm-Gg: AYBFou30/bFeE+Z+S+i3fXm5zbfeqjTUZ2lak/eSCATmCQjXYQajDaw2nTkbuOU5G6F
	T90glQ2CcUc1MjyHHXfJtqIdM8Ak0gNtX9hFo/X2hVcrssFcgc92r3o46//RAMj0x3p/QOcR81J
	cdHsd9eUoulZsG2kVMfOKQWRVadXxFjuYw80yyKOFPgSgwzxmS0gzqKJ8LdLOsGrxuGsbr5D6sm
	KIJ9aCwYLd2AeV24e/Jwd/Vmu52PACiW/fu0Xk7N8ogEPw2lPYWcpdPCs5qVZCQyhHiYQuy9h8M
	asb0mD67mvF/TxjM3WVP/pHxeJvzplNeMAmUeudGgfn3bR4JpYeD0eULmpnhrqm4bm5nr+RzkZe
	UQ06Nu6qEaqCri9F/0fkuiptiB9pXx4Q3ioKiZwM6vTgFc99ixEwwewW4pngRYdaJiqbiGL5Wzw
	1XNWByiah4UqOKdL4IEQ90WkXclVyBIfYuNZiDgdkyYaZoNW19q7hv3RmNRL0wOm15yqRlTtNI/
	g+ac/a5FgsjmBOFQTlpwdtEsj5Hms7ALKNBjwvVkQk471g5BkpzsomOSg==
X-Received: by 2002:a05:6820:c8f:b0:6e2:2dcf:2cd4 with SMTP id 006d021491bc7-6ef0eec73fdmr9825677eaf.16.1791919007140;
        Tue, 13 Oct 2026 12:16:47 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6ef023a1c1dsm12597782eaf.10.2026.10.13.12.16.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 12:16:46 -0700 (PDT)
Message-ID: <baae166a-4464-4065-a642-348034cda28a@kernel.dk>
Date: Tue, 13 Oct 2026 13:16:43 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/13] Add dmabuf read/write via io_uring
To: Christoph Hellwig <hch@lst.de>
Cc: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>,
 Matthew Brost <matthew.brost@intel.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1791336930.git.asml.silence@gmail.com>
 <d00e43fa-8f5b-4a8b-8b83-421d637ba519@kernel.dk>
 <20261013141046.GA12680@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20261013141046.GA12680@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/13/26 8:10 AM, Christoph Hellwig wrote:
> On Mon, Oct 12, 2026 at 02:21:41PM -0600, Jens Axboe wrote:
>> I've queued this series up for some testing, in a separate branch. JFYI.
> 
> More testing it obviously good.  I've been waiting for addressing
> of the Sashiko comments on the nvme patches before doing more ACKs,
> and while I can't really judge the code those in the dma-buf code
> also look somewhat serious.  So it would be useful to get them addressed
> and the series reposted.  Same for folding in the PI vs dmabuf fix
> from Anuj, although making the combination work would of course be
> even better.

Agree on both of those (sashiko and folding the PI fix), but it's been
forever and let's at least get some testing done. As mentioned, it's in
a separate branch, easy to update. But if we were to have any hope of
making 7.4 and also not missing yet another release, then it would
basically have to happen asap.

-- 
Jens Axboe
