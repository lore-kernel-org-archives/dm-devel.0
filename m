Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2D2223323
	for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 00:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773362051; cv=none; b=rm3Rs9Ugx9DmtYff1BUAbUiXTu5IVFhGG+vZmg75zrDk/zBBUTI+pyZdvISmDQxwn/50tCaXPOhMQgyBxb5+7tEgzq1yTgZ/Sqh2AJ1i3Sn38vrQMeQDdhUUE6e9ZC+pZkn0F5d/9ZbOBUvOnwopkeJ7dqi5BKluCA6+xLhh+/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773362051; c=relaxed/simple;
	bh=rUBfEUjFw6vNfxkvwg0Q3a+v6jR8wWd8B4icRzK0lE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=G4B8truLYW1n8kbeegex9vy0yadGNws5OWA97FkpdIGMdbgQ22n8YT0hHcFC42w2n4iAmkn9OhY64H8W5vAPfqQNJ7LcV2+ajxCD6B0jUda9ELcfmKVFEnBMNLUertnXBe+AhsHV2VcYbCOv7ejUpBiPXhErvcBZley+DAtfMtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j52O8gcr; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j52O8gcr"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-439b59d56f9so191771f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 17:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773362048; x=1773966848; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lus8bm0LgaipZSRNweVzKZN0nVFmY3GFG6fI3zk+2QY=;
        b=j52O8gcrCGVBHHaHJNhyWtTyy1dXuuMogFl7mwdDxfC09ZPuI3nbj4exwu619lfvEP
         EnuQm2TxqR4GHcRFFKBOP+X3BZtlaMlqnjHDCiiLpp6dLuekVUOs4tYvyWgDIeMChRqC
         RkuAKJUrTl0rCT/hY3wLspd3hoCcpnniPJIhAmaSTwb+CluU9a6jZr71yYhBJogGh0ZZ
         z6e1xT+c5pHBY3LSUBlwRx0e2glT/c/JwtwRpmM3rfkprchJPr0zVOAqlKxc1gJX70k0
         0wedCY8jY2zNE6CeyzfVrL1hd/Srt6TgWZCbN+gU1xjPlS0GOaK+R0uZC2w+Ej8JSY64
         AKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773362048; x=1773966848;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lus8bm0LgaipZSRNweVzKZN0nVFmY3GFG6fI3zk+2QY=;
        b=jXWfwPGxu1FKiMwvzXtvyt+jNOI2J/vNh+UErfEHwUn+GxhMMeDjD/Waof8aX2fOkD
         aOYBTgxNiD5Kr+KlBBOQdgDVj+ipHGfZgvDKrmSDhaEEXs3FuOTgksA7pKM524GBvLdJ
         C1/4W09AP7O+mse2WYPbkGOz8RynfN/a45ygcwtAwwHYsZVeRXfyJp4vpU1BZJyoZV9e
         m/CVnswvUFdmOmQesenv0SsnmY1H9IoYDjdbiB60H3qWyGUTiR9yDF/fZVsgM8g1zAue
         R+ZJ+P++jMLEuwaFRIf7K4x5tpZo4V4l2kzfSJ+l8TmFa+OM5s5aOXOhwyOW6xpR7IRK
         4/5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWmWOIU6cF4dldu2uml1rQsrMlY/71vNi0UEVNa2qpSLjFq6D7wBmvLeIPD3iILm8BwaitPuhaAXA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxTJdkrLNdzyb/m0UEW5gkkzcPgQQc5klZwH7eY6aeanbRROcJG
	k4EFnCY75YV9NqZ9VmTj+iHPKwlO0Hx4NL1ut9WGu9PB6yLGKCpzPTM=
X-Gm-Gg: ATEYQzxIb/739tHLJBz7KdgYwqm9rQfZ9FBrYZCd1+UrbXa+ZiV//W6cG6NoF1UeKY+
	0O8W87ah0nM/+Wg+TQt5aSp6B4xE06M6hDnbQp7hr5ySewV3lV2Ie+Sq/7+58JB+oIXdq4RVw2w
	lz9PQRm594pnV0+ATOAB2XAuh40lUxCFz7GgZtfYxG5Pp8XUyo+kCZQzDXJcR6AE/RNk3yStIKx
	xjjboMU6nOCH/o2+C2yG3ih3TETl4dyVcPlSfT4nVlV31z7YwjUwU5oUMA40JlBFI5URXfKZ/y2
	bwXlpcCoX6iZ1mLYTJdULUwuTeavrHWCljDYYT/aKowQJHUxe1Bc7xeT08MQRzFruyxTrKM5G0M
	jZHlFTEvdPzc63yoNSGHG4VEn9O0RMq2kU1VZgChszvzV/96vRiWsXY4dip4QySaVTAAZZv6PAx
	CG3n9GqdtqK0WQE7M2viVEPRgYbmk35hX5v2g1g3530D/8UDSv9bswlt32WOsmxp155FNq9oJBX
	CxauA==
X-Received: by 2002:a05:600c:6912:b0:485:2af3:3f8b with SMTP id 5b1f17b1804b1-485566e3678mr10001235e9.1.1773362047832;
        Thu, 12 Mar 2026 17:34:07 -0700 (PDT)
Received: from localhost (219.red-80-39-142.dynamicip.rima-tde.net. [80.39.142.219])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe1aa2c3sm10186027f8f.13.2026.03.12.17.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 17:34:07 -0700 (PDT)
Message-ID: <e6f003e6-0469-4d27-a777-e9935aec63ab@gmail.com>
Date: Fri, 13 Mar 2026 01:34:06 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] checkers: add alua path checker
To: Martin Wilck <mwilck@suse.com>, Brian Bunker <brian@purestorage.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <20260312001642.53321-1-brian@purestorage.com>
 <20260312001642.53321-2-brian@purestorage.com>
 <8653507a25c02727037e7e8bad4b2178a9702040.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <8653507a25c02727037e7e8bad4b2178a9702040.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 5:32 PM, Martin Wilck wrote:

> On Wed, 2026-03-11 at 17:16 -0700, Brian Bunker wrote:

>> diff --git a/libmultipath/checkers/alua.c
>> b/libmultipath/checkers/alua.c
>> new file mode 100644
>> index 00000000..cb3d7000
>> --- /dev/null
>> +++ b/libmultipath/checkers/alua.c
>> @@ -0,0 +1,426 @@
>> +/*
>> + * ALUA Path Checker
>> + *
>> + * Copyright (c) 2024

There is no Copyright holder.

>> + * This file is released under the GPL.
> 
> Please add a proper license header.
If the code comes from libmultipath/prioritizers/alua*

For consistency with:
libmultipath/prioritizers/alua.c: * This file is released under the GPL.
libmultipath/prioritizers/alua_rtpg.c: * This file is released under the GPL.
libmultipath/prioritizers/alua_rtpg.h: * This file is released under the GPL.
libmultipath/prioritizers/alua_spc3.h: * This file is released under the GPL.

Otherwise, the license should be explicitly specified.
