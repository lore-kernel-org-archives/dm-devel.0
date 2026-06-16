Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B863AA1A8
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 07:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781596034; cv=none; b=MBamUekc6jJHoeB9w4E+WALY12CjY6NvuHsu0Fi+T24AASEjuHyVYtBIMX3RalrNUwyGM33mrGoTV/AggDjEtFotJnHmn4Va9hCLZl6NzzUkPAiqApUB5lbh52ImDPop55jvUBW9GJijynhAC+qVBmfOq0xhMtoyi6Oet3vXVPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781596034; c=relaxed/simple;
	bh=IRvFERitfY0Hwl+Fgv335wXSBhuBwzgqB+TBJ1nDs1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lH3CkqgeQUlYDY+K+dq0dsU1ExYneyjQQm04xuZ2UmOIrOq+Vq9I1PZH80uUD35UREWBjb7rj9+vZ+HSYArRutxTWtMqMdzhwl51cuAr33FfkrENUp/38c1QW2cxtLTA76XPmO4rBrqoMC9Ab2RnJw58wj1971VsSlB+yLk843U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QlBWACrj; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QlBWACrj"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490ae34298aso2954675e9.1
        for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 00:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781596031; x=1782200831; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Ud5fJugy9pFMSGRTElA5t1XoctUskniX/eTNx5DRUA=;
        b=QlBWACrjcABPAeEXGev893BhJQp7rhNas2yfdFC+EPIqjCHeQMWPRWWOI8bb8Y6xGl
         tpo4Sb8/vj0PaFBn4tfZtyTXI0JgWQBPpA4+EWUrQpNwpJQleCPs0Qqk1MSxYKVsgovm
         KItcD1JyYXBmHMiXwUYsyHDDVgAYpf78wOBu9X+8yQzRq9mXLiHu7tHUyYUcJfysHSGf
         qwTQUaRYO+KQ9q0KcfadoueH5rEn8GmjgPwBx85z7m0/tslD29+BJGmhM4YiLjr42gv3
         B0Vj/HdQDAJwuMtiuuy3ZCn9QY9d32t2DyiXYZs73o2+q3Jy3SZny0X1vShMOl+54fPY
         pXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781596031; x=1782200831;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Ud5fJugy9pFMSGRTElA5t1XoctUskniX/eTNx5DRUA=;
        b=e6b7uQlV6XOBFIVtNLG8OP3dBaQ0tFmgB6aChXdCqTKtFhdoXA9VRI95udOzChk2l+
         mKRjFoDJZraKCEAFuks3Zgpl46CPzbhgjRUPgQxI2wYXWUAmmnxRSYOIVRTyT2migCyL
         ZOZYLaNg8/XvNoX085MwUQlwIUd4Mt767fdAsO1Pjh37h74jBWdXj5JpRf2jcJzPz8n/
         wtCAQgcJq69oEe4MUtSzsC/JiHQ/PxcqmiQAo3RE4XQ5dKP2Wn1kCuuwJc5Dxbaym0aC
         nDICoiaMxZOKlmAvQqKBELvH1YWK4XhoJHMyEdO0xR8nh7VoBIavjuDzVdDV1/n7T/ZK
         g01Q==
X-Forwarded-Encrypted: i=1; AFNElJ+5x+YmhfOqMoHDRm0nqS74hx69GIaaQ0gJnsgiB8XEbmf6/EnrzNJfrN6cWPNL3V4iXrYEZdqVOg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzC/zKrx1YSSTJ+GsiYIk1cIILlI5Ef9VIad4Q7WoR9LAb6jYhH
	KuOvEGmKZrBs+Ci9qVmzugtRR91ddVSabAp4yz4j7UXYNzSd3eADo0jD655OZCRNJg==
X-Gm-Gg: Acq92OFb/oVuXMZftJ3Z+8Dn1V62zlXeDjGtyXSI3Yqzq2sdAKeya2AUcMHGWnd+gRP
	gHE7yPugZpqcolAstKKMXi4U0LV1hA1YYdvDYhFMVXNMQCjFJLgFYc4LdG1gGeqlLZn2NHDCtck
	Q23Vy10CL77qy9S/QbzsxMcyqqYv8y3RC5sqA9KGbgwFb3wNFOF27IO1XTm4BlYVPv9xhtSsKRL
	Uv56LikyYMltuI5gppBCaTEYcIQE8mWiwMS2n8XrVq4j1bIlAFQrGNozYv9upmW9mnOnANboxxO
	fg0kVkwBWA6sgVGqzD6utEEsU2350rnnE1yIGo5dBlQ86QV+Qm0AA/J51Vte7jXvSFk8Z/kTOZ1
	0icCgaL/+i2QjVAtgmAFMXMxdhAc6i3/qM7+gbNLrYunXovtzeyvdDzcoWRHD9X2E+vNLGQKofv
	x+FR25lMqrUshkkfBqav8IFExhpt2/Pc6/A7xfvVCyR8X5RGi+HUHDllcQBgXBF09gicMh/ohZC
	fQ=
X-Received: by 2002:a05:600c:3b8b:b0:490:b2f9:d9a4 with SMTP id 5b1f17b1804b1-490ec4a8331mr145156515e9.1.1781596030887;
        Tue, 16 Jun 2026 00:47:10 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa5120esm56390235e9.8.2026.06.16.00.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 00:47:10 -0700 (PDT)
Message-ID: <50a665f3-8bcc-42bf-ab33-5cdafa70440b@gmail.com>
Date: Tue, 16 Jun 2026 09:47:09 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] minio cleanup patches.
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 device-mapper development <dm-devel@lists.linux.dev>,
 Martin Wilck <Martin.Wilck@suse.com>
References: <20260615190711.797573-1-bmarzins@redhat.com>
 <8b715fda-3e14-4a6d-bba0-a3e53481f567@gmail.com>
 <ajCDBM2lH7NvcuX8@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <ajCDBM2lH7NvcuX8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 12:56 AM, Benjamin Marzinski wrote:

> On Mon, Jun 15, 2026 at 11:00:48PM +0200, Xose Vazquez Perez wrote:
>> On 6/15/26 9:07 PM, Benjamin Marzinski wrote:
>>
>>> This patchset is to deprecate the rr_weight, rr_min_io_rq, and rr_min_io
>>> multipath config options. It's a companion of the patchset to handle
>>> their deprecation in the man pages.
>>> https://lore.kernel.org/all/20260607103831.336833-2-xose.vazquez@gmail.com/
>>>
>>> It does not completely remove the minio setting code, since there are
>>> ideas for reusing this in the future. The final patch is simply a change
>>> to avoid a kernel warning message that I hit while testing these
>>> patches.

>> Ben, thanks for this cleanup.
>>
>> I ran grep to see what remains of these options in the codebase.
>> Could you please check if any of the following occurrences should have been
>> removed, or if they are intended to stay for now?
>>
>> 8<---
>> $ git grep -Ei "rr_weight|minio|min_io" | grep -vE "multipath.conf.5.in|deprecated"
>>
> 
> Good catch. It appears I misses some things.
I ran the following command to locate previous "deprecated keywords":
$ for i in $(git grep -h  deprecated libmultipath/dict.c | grep install_keyword | sort | uniq | awk -F\"  '{print $2}') ; do printf "\\n\n--- $i\n\n" ; git grep -i $i | grep -vE 
"install_keyword|multipath.conf.5.in|\.md|deprecated_handler" ; done

It looks like there is some leftover code that could also be cleaned up, such as:

--- disable_changed_wwids

libmultipath/defaults.h:#define DEFAULT_DISABLE_CHANGED_WWIDS 1

and also some checks in tests/hwtable.c.


Could you please take a look at these as well?

Regards.
