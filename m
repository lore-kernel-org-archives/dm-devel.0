Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E70A3D3CF7
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 15:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774451279; cv=none; b=dAHzyQoMBK47By0w510iv1g8o964ApsHlxrIDgQeJl7NzUF4+svZduqd1mW+obWdxu9AXDFvXMUc5GOS03Ys8W4+pWXdgXP0CtPCD3nhBW6XqWJE+mVjXlurN1w9JWQvqs8BzDc44HOHYcrUugmgFtwk9SNYv1XHE53wX2AvKzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774451279; c=relaxed/simple;
	bh=ERTKbMW2EDP8gO2WT3niUZYSBC+7slMKattX6iw7cG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b1i8RTa6rudlyj45ViL2qSxBDHM7RqWynZt/R3EFNWVpnPl/p8o44B3npd7NQ4OQqWOKOZldfcOKUKrysIlE6xBJSP9yUKi++ALsbm8vmz/YuD9fk/TKheJhQMgt8xILN2XOH8+5Z0+nDLXluqkYb9dgA8nuMidGZVRWgnLyoA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G6gF2aiF; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G6gF2aiF"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-439b97a8a8cso5486920f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 08:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774451277; x=1775056077; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ERTKbMW2EDP8gO2WT3niUZYSBC+7slMKattX6iw7cG8=;
        b=G6gF2aiFzcXRz1+aZGz3by0ICizTKOVOwpo/4RC22zhp6jWdJZD0sTRLDC0obe3ZUf
         auM8Qq1n40dzHr+2qFeh2zj4NGMXHjRcyyxrHC/ZyR3VfWSI4W16ZR9gB4OrU+xJrbjD
         EAbDLtxH9mHIa/RH9+8jAMtsr08eDZPT+Jn3ZnDoH8puDj7JG/e+WvoHvON5XZW90xY7
         WZmyDd9RMw8M+2YoNlpBSCSlLsE3ZBO/nn44H/e+Oy1O+8nASE3J5gVYsEQAyPz/Txfa
         Cl/4FC0vL/uwRpUy54K16Rdo25g5rbkVj5d32e9GqUJBcFBOCY7ScfNF05rwL2bgfIWm
         QsfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774451277; x=1775056077;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ERTKbMW2EDP8gO2WT3niUZYSBC+7slMKattX6iw7cG8=;
        b=YjQMGdyk9VlvIpKQlLfzTzkARR+gwpwt/NWtOP1Cd7m4UUOd+Kdpo3V4zMetUMDrBk
         c8MeZHkaIMj1kVqZ+nznbRYGlFWIk+9YUYIU+0ZZwCc6tL+OXNPELQG9rfB8+7KOvFxe
         swwQLVFgwoDKDs+J73jGybzYuh3D9guGpLDrk4++ikPqX1VtQ6gsjxX9059/9KDorusM
         kAs5pZEZeEO6vcSEFk6JScqprbeaY4+BJDh/SIShX9V8ceWdWGVAWJD4lh0pZMmuMwHG
         AbjUdjb6UlKWFcKVBGJhmKkD4Vqmx61xT9GVSemwgWr7UJ7uRalxQVIzA9GMXCZdIyND
         NuBA==
X-Forwarded-Encrypted: i=1; AJvYcCXT8bBEDisC82ua4RqR/GrCw9LmpodmimnTyIxqzs1C/n8CUjza982Hc3HIEupdh6ZFIwLze++znw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyvT+WRU9c4GrxGFZfOnqwZsINSRarj+4LTqni0bj7Foiz1aJbu
	v6roU756na7T4ioVFna4QKxGZ35O0IqXkL74Qc7095cmfvSEhah5ylk6
X-Gm-Gg: ATEYQzzAFh1FY1ku1J51cparYCqbB2CLPgGPUSql7CIQL3wre5IdExARcJ/4giJl1A+
	uIP/JAIrgJ5DE0Wc9LWN4sbrh8DgayTeYHtghZGdStZQ9sF57BRxl1ul62lutaLAkMO60bbcysN
	pZgxcROhgV2bgYdxA9Ja+3BDLbpYGXR0B2zAufc5d9fWM6Uax0pvBNplpcNTCSVmkiLk7xaI/aW
	GzUCFDr8biI8wShptW5p1SAfnPdD3eUUem0mY76A9JFY80jOFSZxvAjlpCeZw/1XMg9mS6Rsxws
	Z+iSu8AmwfdU9OfFVRX40OGbxTGqeRJ5JjgNJl+um1ffmENbkrQcmTbzrcX2J4s4Ae6/+llXpO4
	NnXXAj5jy8NsuwAxhd9WrmXKvDIxCa0qIRfdQvR4ASaTWuZZe4ieWrD/r85oID98gDpTLiTRMz6
	W7vPHz+8bf56ov8gnvcUDLOTbiys6t
X-Received: by 2002:a5d:64e7:0:b0:43b:3c05:d7fb with SMTP id ffacd0b85a97d-43b88a39b7amr5607269f8f.54.1774451276557;
        Wed, 25 Mar 2026 08:07:56 -0700 (PDT)
Received: from [192.168.1.116] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b919cf1c4sm340955f8f.23.2026.03.25.08.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 08:07:56 -0700 (PDT)
Message-ID: <ca0c8b55-a600-4067-9477-79f4664a916a@gmail.com>
Date: Wed, 25 Mar 2026 16:07:53 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] dm-inlinecrypt: add target for inline block device
 encryption
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 adrianvovk@gmail.com, dm-devel@lists.linux.dev, quic_mdalam@quicinc.com,
 israelr@nvidia.com
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <20260304121729.1532469-3-linlin.zhang@oss.qualcomm.com>
 <20260312070110.GD2359@sol> <5a310122-bd7e-d10e-653e-bc7e09681478@redhat.com>
 <7f613001-fc2b-44e3-ac14-7e661cf52fdd@gmail.com>
 <c86ff571-092e-4181-9bd9-3e99f7c4b1b2@oss.qualcomm.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <c86ff571-092e-4181-9bd9-3e99f7c4b1b2@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/25/26 12:57 PM, Linlin Zhang wrote:
> I understood that supporting keyring here is to ensure no raw key exposed to
> dm table. As implied by the name dm-inlinecrypt, the key used by dm-inlinecyrpt
> is a wrapped key, rather raw key. Can we keep the wrapped key inside the mapping
> table?

Whatever key it is, it allows activation of the encrypted device. And it does not
need to be cached inside device-mapper layer (in DM table).

> In other word, can dm-inlinecrypt support both keyring and hex key(key in mapping
> table)?

Yes, support both. There are situations user must use hexkey directly.
But IMO, keyring option should be supported from the beginning.

Thanks,
Milan

