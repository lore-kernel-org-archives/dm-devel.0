Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8582B33ADA7
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 06:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791181219; cv=none; b=S4E38oWVl8/szlUV0BV2ixEkXERWhdMD/WBdm9gabtvKXI+AHv2UrBvo6/uZIckYKdOHbJbkpejxUpnyBBlHVsX/oShoxKUfDO2yP1754Sqap/Isa65+1dlHUJSqxJUeY/DzyXK9Pl7VkOnXu3nsjlAZurvH5SjEOi1SkHJuGD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791181219; c=relaxed/simple;
	bh=0ExWA1l1yPQaHfCJdCeIV2uvEiOA/vQlQ+Irax5DPyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dostawjwZBNKGR812H6u+34nTGjKsc5/c+GphZRbmFC4XE1Hr8JUSOluWxgFth73n+0AAJGxoBFWr8ctU93K6oQ5EZ+z6YBlQpoPN5BeBlEGrmzaXDU6cRWohbJVC7+UiXe4WxAUJTw524v+7tKkRrAfO8bTOFnFkvpMXMXnOks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OXovDe+3; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OXovDe+3"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccf3ca626so8883865e9.0
        for <dm-devel@lists.linux.dev>; Sun, 04 Oct 2026 23:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791181216; x=1791786016; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l0FuaBTKJktE8SOUhXZCNhOW7/MvZW2r4riGHbubmm4=;
        b=OXovDe+3sQmZcfL3SlC/0UL4LA55jv9ArKIh89wSSxCY5LQxJ7wEzbOUJ5khgNmKHE
         j4u7yOOtbsj7tS5qUNZak9k9u85g33RNgeLHAUPCluv5qZKNEf6igObho8nV4xGuotX7
         4xdNH5LQK4p3eTNoOQpD8ejxwiNp6DGwT3ka+LxYRdvff6Vin75zs98CkDhJMJRDn8JM
         to0kCmogjqzY/TvAyE9fD3DP/J0VC2tfcLM4Kl0KzP8a4iBFUdrtIsLX4v4kKXyJtgqo
         E2HWSaYaoJEeyMVw+Mqj4AI12BFK2qvvYEZV3oUbgNsu2UsiWpq4rEeaN3rdIBkx/yxT
         NV0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791181216; x=1791786016;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l0FuaBTKJktE8SOUhXZCNhOW7/MvZW2r4riGHbubmm4=;
        b=PL0+W1zglSe3pcWrPeWc/hCv8VZD/qENd/A/kVazDZ0BNc7sHSum+TmpJjCsQHTyCO
         WGsEhsLt98fK196LOx3YMmlrEn9cuR7rkMb8QTqHj6JTx+3JqF63cHqt4B8py/jA80bf
         Lelgif2F7lnuVuJVmIIQE95TtJ6CFXeGMLJgDTZzrxGCbmge9/o3i8FLZG/e1IbSUAeY
         HsSk4XqfPIbefsFMnSHJ6hCqKqlEoJS6MX/B6I2mKY/UHuALiKMWC79L7ZNpr9ybZx0/
         HD14uoW8QGUbt7jaNxIREKXdHvCYcy8vuOoFZ+TwziNkaW7C7U0OjIrA++1NjnweZhxr
         teSg==
X-Forwarded-Encrypted: i=1; AKwUvBxhSLQFm0RwXKTKP38sgqG/IPRIk8psyD4cks5YIjuojavlyl9IV7mOOjsTBq3S8KoJ2HYKLwVRuA==@lists.linux.dev
X-Gm-Message-State: AFuF++nCAFOb6OKBySs5WXnOdG2rqKqiqDlRqp1xVHZPlRa0PNXEj0n3
	sINJ/MmGdPxMhCWTyP/uJGu8eFUlBgYY8rtrrNaq0K9uHASErnHj2/Ds
X-Gm-Gg: AYBFou02zYvNp92p7HiUAul6h9u1MLWGrhVQXxJHjga2LBGpSM6J5Vzu4dKMcDH+WMZ
	peCSOQDnD3KrbMsLmy+SXEKQ6ZIZZd9lVecOvKCsoANgcn3Xfi5GkW8uFbbP67w3scMOLSn6EKM
	hWBBoWK9QIwldBmW7InnZ/DlH3w/153dEVyUDUyzRs/KJpw1arYP1hrQzu+pq53mWRNCCaeWPC0
	O3Ih30bRDlPToBC93XINq9zbl0xcquUuO03IGEPE8OaKa3GE/kVsLsRU+Pg3lDXa0NKRmozj0z2
	ah2lGHmUTXqGwxaRRkvOsq+kWPgZ5hhT0E/OFenKnIcpp8uHDuqy3HL5/in80ytgiidAywmDM3W
	1/4ra6lYOAROUCFcUm3CgOI2PkhS36i6XYSxTqDAFWGTTs918UDi+E26PVaxg/lqa87gdPU7HVN
	4jTbB4cxitwX4h8frLlVccbyMILu/Ot8UYM/0P/nNH8dfKIWaCxpK/NmgJNLn4ZKSC478vLfA=
X-Received: by 2002:a05:600c:1e0f:b0:49e:6249:268b with SMTP id 5b1f17b1804b1-4a027697ef2mr157549445e9.32.1791181215479;
        Sun, 04 Oct 2026 23:20:15 -0700 (PDT)
Received: from [192.168.1.109] ([178.17.7.30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c622704a5sm3189409f8f.15.2026.10.04.23.20.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2026 23:20:15 -0700 (PDT)
Message-ID: <ff601118-7ef4-4ece-94a3-9671e78fa3c8@gmail.com>
Date: Mon, 5 Oct 2026 08:20:14 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] dm-integrity: support keys in the kernel keyring
To: Eric Biggers <ebiggers@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
 Lorenz Kofler <lorenz@sigma-star.at>, Mike Snitzer <snitzer@kernel.org>,
 Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 upstream+dm@sigma-star.at, David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
References: <20260928062734.3805458-1-lorenz@sigma-star.at>
 <20260928062734.3805458-2-lorenz@sigma-star.at>
 <6e7bd72b-6f1a-211d-16a8-a35a530af408@redhat.com>
 <b0f8f47a-beb0-426e-bdee-5d0d80ade8ad@sigma-star.at>
 <1e53661e-42f4-72b2-3331-33af21e9fe0f@redhat.com>
 <20261002201419.GA205250@google.com>
 <d737b17e-7872-4afb-b4c2-bfa8f4e119df@gmail.com>
 <20261004172934.GC1906@quark>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20261004172934.GC1906@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/26 7:29 PM, Eric Biggers wrote:
> On Sun, Oct 04, 2026 at 09:44:57AM +0200, Milan Broz wrote:
>> On 10/2/26 10:14 PM, Eric Biggers wrote:
>> ...
>>>   From what I understand, the point of the keyring support in
>>> dm-{crypt,inlinecrypt,integrity} is:
>>>
>>> - To support "trusted" keys.  But that is not what was actually
>>>     implemented in dm-inlinecrypt.
>>>
>>> - To avoid having the key be readable with STATUSTYPE_TABLE.  But that
>>>     is not what was actually implemented in dm-inlinecrypt.  Keyrings are
>>>     also unnecesary to solve that problem.
>>
>> There is more to that
>>
>> - to avoid key cached in dm-crypt (or other target)
>> (dmsetup must be able to retrieve mapping table in the form directly
>> reusable for recreating DM mapping, so raw key must be available)
> 
> It's of course still there anyway, so that the data can be encrypted or
> decrypted.  crypt_config::cipher_tfm for dm-crypt, inlinecrypt_ctx::key
> for dm-inlinecrypt, or dm_integrity_c::internal_shash for dm-integrity.

Raw key is then not part of internal dm-crypt structures, that was the point.
Crypto API needs key, obviously. I did not check recent dm-inline crypt, though.
>> - to avoid inclusion of key in DM ioctl calls (mapping table again)
> 
> Unless the "trusted" key type is being used it just makes the raw key be
> passed to the kernel using a different syscall: add_key() instead of
> ioctl().  It doesn't seem fundamentally different.

Technically, yes.  Just the key is now sent through ioctl that (should)
be designed for it, not in DM-ioctls that are used extensively for all other
parameters.
We had to add wiping of all buffers there exactly for this reason.
And I think the split is better also for tracing calls etc.

And while all these subsystems are not perfect, they are compatible for many
years. IMO this is very important. We are not in Google monorepo environment
where anything can be changed anytime as you know all users.

Milan

