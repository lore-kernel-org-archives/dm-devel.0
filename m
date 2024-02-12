Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4DE51C23
	for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 23:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707781326; cv=none; b=A1lHFugM/CLIeBLga4t6pCb4LCTJ9c6Ac8YuvuH+aKw2hKwoQDfPXL43xARcnt/2kK9HuJrD4Kasyo56rii6IDDhz6f7KWUGZeHx6PBwOZIFxxgX+8Q8dnnr4AGQUCG1Nkn9W2qVzllkAw6REhVmUr/g0g9gRwcW2PPagiPI9do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707781326; c=relaxed/simple;
	bh=bhtnmnkUynIfPZp36SfzJJqiNSimJESUH+JZApeNGFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dIqEZO9MegJxl+uFRhSVDuIIKDshtbNZSN07le7qERqJOhnmksETj1eH8b+YUh98CAokZXERgw16w1xDpkRIIyLU0vum65/kbw0N8+PgF3OH5K85coYfFRonWc1FFzBKqNCZwP0V1AN+WF1PG74PBRDcmNhgLwawOhNhYq2VvBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WFOkRwG6; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WFOkRwG6"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-411b4ba0c3aso1654035e9.1
        for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 15:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707781323; x=1708386123; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sA136wnwOfMm4/eSWKZQUCf0TiAjJBh5j4V8IStF2jw=;
        b=WFOkRwG6EvQitt59EtBeB+SHH0YOjqnY1qtjL9ItStxCOuxgqgHeTPF6J1OUvmVHi3
         dZBFSjh4zUASfRBNNhCiWCJuiD+whDYaHQ4k9/j5NXYqSrqNuJBwM8tO1cDqPJfepy8r
         6beCgwzDZvBtefz3atewfrJ5jQxSZEggXhrRL2fXFTx70qQTW1ogms/k2JbTMXeL+qli
         pnzznJwChKsreC0GWnFSmQp26O9G2iZ3rlpHXVZISFYiswmQxVnShlLLMiFX7+ljd4gj
         s26z3TKEyYOvEdpxb7adWVPaa4TjQlrsgNrP7kYAu4uOlz1zJl5P/L5RXekks7AaRWsO
         Hnhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707781323; x=1708386123;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sA136wnwOfMm4/eSWKZQUCf0TiAjJBh5j4V8IStF2jw=;
        b=qEh2wMOSOOHIvuHLkcaloPhtPxfY71zIo/1Q6GBwR53LEV8iNw7PfWmJJrCZ1SMKI0
         NVOQuRztwbb9SP7nyib5or6O7vYnv8WieMPs1tEZYtyJ1sYE5nGAjTzQVVMrHwEd2PHK
         4pHgw6PyD1Cy+NkkpckVx/REi+ZfTwUWcLl+2uyLI/1OG5p1Ltt1ZDuvrxXf/Ture5i+
         jGiFCR1EwYZGu3RBUCgfNI6oS8BSt/GZx1W4v/MbBE2daiKdxxjkD+BbX/RVGdcZ9bE0
         +cqQGsLBzoAucTXYenfCiPJ8LCYPJeJ4x5SD1mk+suFHMNFEYyHPaOLUOGxUUeo4CE1o
         MwIg==
X-Forwarded-Encrypted: i=1; AJvYcCVghtZ/TjC4MGcCO6sMyH8yX87Fb+rJjHo/55JUkWlFo+MJ3CW3ue7HvjGRWItu1DusDDEw50ZmxCkcNPuUwOajhrrTnarybkU=
X-Gm-Message-State: AOJu0YxZH3Lme0EzwgWQvVwl40WZX3oS9zrptMVkNEcpi9IzWQypADAr
	a8TQ+7qqFNIRynx1Cu6SiIJv4ig8mBqKRFYYy9ch9C/k0MceqeJ8vLEdSeg=
X-Google-Smtp-Source: AGHT+IHc+F6fAJ9midYCWBYGkF1UrwQD3KJSZEOuUHNEBhCgp5w9+70MXvRISMy9S5lj0DOIUJtayw==
X-Received: by 2002:a5d:6346:0:b0:33b:2516:727d with SMTP id b6-20020a5d6346000000b0033b2516727dmr5145925wrw.35.1707781323107;
        Mon, 12 Feb 2024 15:42:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXe30E34sP5Pz/b3PBYg879DU3Qn8qx8Q3c3N/3MN+jLK7rZUX93dCvoHGNyS7h4Pt6QxmqNuAOhCYFc7XNUxthRDymsJqAQ7ar7/BD9UIPievohjN4+cOu1UcP+z8CAJxpoNaD87vPlg==
Received: from localhost (36.red-81-44-158.dynamicip.rima-tde.net. [81.44.158.36])
        by smtp.gmail.com with ESMTPSA id by16-20020a056000099000b0033b75e5bc13sm6661154wrb.1.2024.02.12.15.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 15:42:02 -0800 (PST)
Message-ID: <0f83bbbf-2b64-44cc-b8af-371a965f32c7@gmail.com>
Date: Tue, 13 Feb 2024 00:42:01 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] multipath-tools: update no_path_retry value for IBM/2145
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <20210825222413.2822-1-xose.vazquez@gmail.com>
 <6123dd27bfaa10641c45d0477516e068bc7c8ecb.camel@suse.com>
Content-Language: en-US
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <6123dd27bfaa10641c45d0477516e068bc7c8ecb.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/26/21 8:47 AM, Martin Wilck wrote:
    ^^^^^^^
It is never too late!

> On Thu, 2021-08-26 at 00:24 +0200, Xose Vazquez Perez wrote:
>> Based on current configs:
>> https://www.ibm.com/docs/en/flashsystem-9x00/8.4.x?topic=system-settings-linux-hosts
>>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: DM-DEVEL ML <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>   libmultipath/hwtable.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index 2a896440..58554cbb 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -662,7 +662,7 @@ static struct hwentry default_hw[] = {
>>                  /* Storwize family / SAN Volume Controller / Flex
>> System V7000 / FlashSystem V840/V9000/9100 */
>>                  .vendor        = "IBM",
>>                  .product       = "^2145",
>> -               .no_path_retry = NO_PATH_RETRY_QUEUE,
>> +               .no_path_retry = 5,
>>                  .pgpolicy      = GROUP_BY_PRIO,
>>                  .pgfailback    = -FAILBACK_IMMEDIATE,
>>                  .prio_name     = PRIO_ALUA,
> 
> Ref: https://github.com/opensvc/multipath-tools/issues/6
> 
> The question is on which basis IBM came up with this recommendation.
> 5 (aka 25s) is a rather low value. Some users may encounter unpleasant
> surprises if we change the default this way, as it used to be infinite
> before.
> 
> Using 5, the IBS 2145 would have the 2nd-lowest default in hwtable.c
> after Dell PowerStore (3). Symmetrix has 6; all other arrays default to
> 10 or higher, many default to "queue".
> 
> Observing that the above is the documentation for the *Flashsystem*
> 9200,  I consider it likely that the value ".no_path_retry = 5" would
> apply to flash-based IBM storage products, but not to the older
> products such as the V7000, which unfortunately use the same device ID.
> 
> It'd be helpful if someone from IBM could jump in here...
> 
> Pondering the pros and cons, I vote for keeping the current defaults
> for now.
> 
> Martin

Some history:

first commit 3eb8c380a :
        {
                /* IBM SAN Volume Controller */
                .vendor        = "IBM",
                .product       = "2145",
                .getuid        = DEFAULT_GETUID,
                .getprio       = "mpath_prio_alua /dev/%n",
                .features      = "1 queue_if_no_path",
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = GROUP_BY_PRIO,
                .pgfailback    = -FAILBACK_IMMEDIATE,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = DEFAULT_MINIO,
                .checker_name  = TUR,
        },

NO_PATH_RETRY_UNDEF was removed in b7c3cf014 because it was the default value,
and later "1 queue_if_no_path" was replaced by NO_PATH_RETRY_QUEUE in 87ea76f99

IBM docs recommends:
no_path_retry 5 # or no_path_retry "fail" for some current linux distros

IBM Storage FlashSystem 5200, 5000, 5100, Storwize V5100 and V5000E:
https://www.ibm.com/docs/en/flashsystem-5x00/8.6.x?topic=system-settings-linux-hosts

IBM Storage FlashSystem 7300, 7200 and Storwize V7000:
https://www.ibm.com/docs/en/flashsystem-7x00/8.6.x?topic=system-settings-linux-hosts

IBM FlashSystem V9000:
https://www.ibm.com/docs/en/flashsystem-v9000/8.3.x?topic=system-settings-linux-hosts

IBM Storage FlashSystem 9500, 9200 and 9100:
https://www.ibm.com/docs/en/flashsystem-9x00/8.6.x?topic=system-settings-linux-hosts

Therefore, we should change this value.
