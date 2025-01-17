Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753791FC3
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 14:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737123408; cv=none; b=u9koSUF85hmvIQr47lBhbfE32dz5utb43+CPyTASRNseM96sct86hBe1dFJLyJu200yp1RrPncnjOljFyi7miFbbDi+oOxFCpcR1S1KrFgTliBLup09rgH9MblPlb0nWk5fZQfCQe8PfK3hyp0p3yY2Iu6BglYouC1Qo82LcuJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737123408; c=relaxed/simple;
	bh=9KOdyjMtEvSN7fKSEoXDQsqfVqnp+dHGKxVAWZek4I4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qLFpGViaVcUUH1DdJbuRUq+YYeyoyZDXtgE+EH7LNC8IXXzAMj5SL6g/mcpNgaANh0QHCVP417j+FXzhYvxbju6JR8VHnHPc3XO6h7uj9RlGwwH0CczVxezWu88d/nlXpQVTCHErxBcP40kLwU+qylw/zrwaL+i6F+Z0l/zh4Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksnuZUrh; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksnuZUrh"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-385e0d47720so96981f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 06:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737123405; x=1737728205; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O3ueptsQMawWiB8pl/3dtnMuxJsUnP0i/0mTXf4wNS4=;
        b=ksnuZUrhvmlmFSY5kS5Ed2TTxQyLozL/L1urwCtTu0fNQi7Gw+HzQGNOBZbMijo6vD
         8UL7UgrDecROBlvVVm+rfSn2kuT8BLTQL/GZbP/wH6nRHLPo0BEkYRa5kqjh2N7Btfo/
         plxE2yTaZRCU9Dk4oiIQc/jeXK0HUVctQZQoR/lUlBOImo9zr7CUBsGqgNLL5zFf3T6W
         D7qd8uMdcEqERet564vmcWx+ZMS+TldrsNbGWxO+iNEg51g3Vup9eiz2L6dV6EAY1dgS
         jdbKVdfN0CIv3pxCwqteRVSJaTOQiFcmfBVNCz0ikJN5uG9uN0WZDkrm5cQLuh82LwaK
         WU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737123405; x=1737728205;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O3ueptsQMawWiB8pl/3dtnMuxJsUnP0i/0mTXf4wNS4=;
        b=pgosDbBjYZ69WkWG/5or9Opk6QOGApaU9Vvv64mBAjOYDvh6OVQji7zTjJGWEYnE8g
         clZ9mCGUG/7rMvl6F1MVUBNRuMP47vzkDGQgMglJGRg53bspxX7Y979kI2ChrIRJFMG7
         JkkeleHPiB8FGbqG5tscDltRKvGk/RnA7o2KJl7IwFC6z+KtTBcDwteb+EzGhvZgNPID
         7VtQyV+uS6YgfhAMDQabHz6/dtkhtGVgRgn9ffhUWN0EPujh5DX6lf10TwtdeUXotvtY
         N9ZECCX7EY9Ayg6iCFWiyjD67Pu/HYM7yulrzEXXdyBzB8bSDeri+wZ5NCECHZMJ9hCw
         4U9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXFBULQxcypFdH3FmKOgIpi0NOsbrZA74/Y53VnLmktvPzIVEY3rMypu55k7INk1FdegT1f/+IA5Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YwilxWLoS1HbunloM30q3LjT3c+fgm289ut/8i5VUfDXxKQZ4bl
	QAMm8Bl5Pdo0R/KBrgexYATKPwKRPBbOUtVfyCj5+GMxeLLIh++N7NMC
X-Gm-Gg: ASbGncvtHxarPv09ZdAZ7c1B3eUCFodosK66dLck+Gdzlb/HnEJWxoAolVPsXgc6X2A
	nV9j+03fOqIzUtNEabeSbT676OnGMnTiRZLc6gAPyUrBlri1yz9BYJePAsgR1kZij3GxGAeeGHA
	fVOJO0jJi0O16gz4LW3E8ANRYZyOeFRJhMaRnjkn3dgzOG084cIywrkZedrqXyjbpTkTKhH8tGN
	CyWYwQAbacxlwgZlN19cwKmfUeiXwQ61dOEAIuiFkeYsRDv281wMg==
X-Google-Smtp-Source: AGHT+IHjrWPIjban/3tBupO74m5jSXmeXEgzGqAwMP3Zd14ZzLY3L5heRkdAQ5MmocQS6qAQ9Sq4eQ==
X-Received: by 2002:a05:6000:4813:b0:385:dd10:213f with SMTP id ffacd0b85a97d-38bf57a852amr1091330f8f.9.1737123404551;
        Fri, 17 Jan 2025 06:16:44 -0800 (PST)
Received: from localhost ([84.39.177.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3275501sm2681070f8f.65.2025.01.17.06.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 06:16:44 -0800 (PST)
Message-ID: <618c7b05-da75-449f-beae-ec8f0c3d5172@gmail.com>
Date: Fri, 17 Jan 2025 15:16:42 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] multipath-tools: Merge Infinidat with Lenovo in hwtable
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <20250116230427.17740-1-xose.vazquez@gmail.com>
 <5a2e75c50ce9d9e639f60377481adf6bf116460f.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <5a2e75c50ce9d9e639f60377481adf6bf116460f.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/25 2:54 PM, Martin Wilck wrote:

> On Fri, 2025-01-17 at 00:04 +0100, Xose Vazquez Perez wrote:
>> Lenovo to acquire Infinidat:
>> https://www.infinidat.com/en/news/press-releases/lenovo-acquire-infinidat-further-expanding-enterprise-storage-portfolio
>>
> 
> Does our hwtable have to reflect company acquisitions?

Not directly, but it's order by vendors. So..
