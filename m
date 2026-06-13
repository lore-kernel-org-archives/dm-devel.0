Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B503BE620
	for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 10:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781346484; cv=none; b=LTb7s1OfwUWX/52eoa0VSsqibOrhUh7XMBaFvQ3F3d4jSLx+3cwR7eYHCJMEa7GsvwU7EpgtVFKwWp6X5CHKFQffLUOzZq3A779A0ObMvxatH6MacWE1+vBHzcX4D7q6rk04EO+3g2txhmQy3dr2uhjYol30dApbrP5fAu/P8nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781346484; c=relaxed/simple;
	bh=6Zx16SPj4FkilseyQY752k6cP2Ti+mzE/tdi1Qu0aVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cunGjP0UQb6+fWLT5kA3g/YZSW3xJll8Jk5/lACBJM0TlrciPKG5mz5pWpG5xm+11SAa1ip7VjErSXMyQm4Bhp3et0u9tld74qo6olu/QJSs4oeYrhAaehdH+wuNI7ndxn6CQKEzeiAqaSINGlLrpRmW0vRgLeO79TMsmd+g5QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fcFPyQ/S; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fcFPyQ/S"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490ae0812c9so2380625e9.2
        for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 03:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781346481; x=1781951281; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Lh2iJHlPsezJScX0vvJ3ODUb63oJWl1Y99AEKjitzs=;
        b=fcFPyQ/SySNQ9S9NQ2p9jd+RsB9TsLUrug60WQqabiJDc9Kbziu8En/pJAe6QoiXum
         mnalKY5YzoOMO+XE7PSBvF8ZgmoKnmQ+7oDg7eW5loZll6mD0zF6vzSifU4aUJqB6bqj
         rHe2+7zGYCBYD814Woeqgyh0/sEt5pHHhdDoBaYjvl4zIOeOC+tTyuwY7dJFI/7Vk2vS
         PzgSYNvYrKkVWC86FD3LlFCcEgDOCRfzAX3L+OUXa3pL4JPMnILaGGknQC+4j5nIHacf
         aO9YT+qRktNkkPWJvHVF/0JJ+QsD7jIsz1x9Xa6P5eIJK5FpPw0b5VUPKt355lFQ85jP
         w6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781346481; x=1781951281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Lh2iJHlPsezJScX0vvJ3ODUb63oJWl1Y99AEKjitzs=;
        b=phLdlHXHljMGIZxGIZuWvU9izVc4ajBzplYEH2uiap5tCY05kq46U6araSqN3Yys/E
         EJYirVTOJBojRU2gt2097EhIRQTlZBhI7IqN5ZbeHJp0Vp3icKa6XXS5lvlX24D33Nsq
         Jc7gedum2/nOtUb6BTSDAuSst5E4VWDfxV6o/Tfyk8BCpl2CfFgkNLJmJUHvo2Aw6Z8Q
         +2eBAKSH7trO5kT4cWIO7JxFHe02MZ3pyKu8IiD3DOvm8661O1s1oMfeyOZ5b3ASF03v
         z/VuzXElO3xFiRtjpM0lWtqzIyAGTzwUfot8S7vDjy5OgjmBuQCI85sNvx5Ny9FAbe3b
         44PQ==
X-Forwarded-Encrypted: i=1; AFNElJ+FRG3B1U6D6wXLYX8ZwnvAfj8ltMdK3PG2PeiJZffRN/K5l2nRP3npRKRQuflKQrGzSnk4We6Ogw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzZ0+HMXThkJj+r98CA0qo3nZrCLI8NpTMaFC9CAIXP86d/j1p9
	YoNH0UPIOKfsz+Ldzh85qTvI1jeDkYb+aIJ/qVjlZNz9PgBLOmR81vlPH6XnTNZIqA==
X-Gm-Gg: Acq92OEOfx+OBuf29jRUgZetiCAL597xjAGCde5hP3KZp3cpNEefoUy168yDRUcPPnZ
	d3vP+fd8s3CH1lnQgA8QcXsKjY7bfQ3hwZSP4ObBQeet4gcSljhtWXM9jpldJLAGt2tyskbr6Od
	++cKCiaaQIO+hD1pnr/xY88GyGkHwB34FCSI2dteGSr0SR6fBi9h+o0+Z47e4qrgKgQhB5NwkOW
	H0zU1u2i+dowq49JO0/4+OOlGTr6SfKrmQa4SNO2TKjkSn9FL3TD/M/Mpp2LO0K0NGTz+0insv7
	+N7/wW7W321y2A5BTuWp2VX8dzPeWqglpX6ZTxjSIQWzcoDBIw/WT4W6oBSgdQo9qwBCuHFhiAU
	RadgfkgPgRxbB3JkonV1Gcn7xCLnoWlQ3ZCSaD26n3XdtEeNwL/r87hhLiKC6bJKffKTkq5p7Mn
	9xnGWvgtLRL6YIlV2jDIphDEg2l018/6fKzuCrmPX+wKtxWtGrQGFN/OwuCcO+YFcN
X-Received: by 2002:a05:600c:45d4:b0:490:ec79:3046 with SMTP id 5b1f17b1804b1-490ec7930ecmr40733985e9.0.1781346480852;
        Sat, 13 Jun 2026 03:28:00 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922031b21dsm61696545e9.6.2026.06.13.03.28.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2026 03:28:00 -0700 (PDT)
Message-ID: <02efe6db-3a13-4177-a318-eccf95a01c09@gmail.com>
Date: Sat, 13 Jun 2026 12:27:59 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] multipath-tools: delete obsolete information from
 multipath.conf.5
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20260607103831.336833-1-xose.vazquez@gmail.com>
 <20260607103831.336833-2-xose.vazquez@gmail.com>
 <ainpVKRJH91bsAQc@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <ainpVKRJH91bsAQc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/26 12:46 AM, Benjamin Marzinski wrote:

> On Sun, Jun 07, 2026 at 12:38:21PM +0200, Xose Vazquez Perez wrote:

>> @@ -198,9 +198,8 @@ kernel multipath target:
>>   .TP 12
>>   .I "round-robin 0"
>>   Choose the path for the next bunch of I/O by looping through every path in the
>> -path group, sending \fBthe same number of I/O requests\fR to each path. Some
>> -aspects of behavior can be controlled with the attributes: \fIrr_min_io\fR,
>> -\fIrr_min_io_rq\fR and \fIrr_weight\fR.
>> +path group, sending \fBthe same number of I/O requests\fR to each path.

> For the path selectors, we know the number of I/O requests that will
> be sent, and it's 1. So instead of saying "the next bunch of I/O", we
> should probably just say "the next I/O request". And we can probably
> just drop the "sending the same number of  I/O  requests to each path"
> part of the round-robin definition.

>> @@ -1008,10 +974,6 @@ The default is: \fB<unset>\fR
>>   .TP
>>   .B config_dir
>>   (Deprecated) This option is not supported anymore, and will be ignored.
>> -.RS
>> -.TP
>> -The compiled-in value is: \fB@CONFIGDIR@\fR
>> -.RE

> We don't actually specify the location of these files and directories
> elsewhere in this man page (except for the bindings file), and we do
> refer to them by these config option names. We should probably
> replace the references to these option names with the actual file
> locations, and probably also list the files in a FILES section.
Sounds good. I will address both points and submit the updates in
separate patches.
