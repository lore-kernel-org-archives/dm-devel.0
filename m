Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BB92F46
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 01:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736213093; cv=none; b=YK8QteEhLgJDIO7xA/Ekk+o88/e0vVBEjCO7CBbqrRoOQrKFOTmSdUqyoasewo88ZIqbu91aTJDzG0bWXcpIcBD6t0Hy0U6WMFff9sTPgCU6YqsfnNGL728Np6MMjhKm5jkci/qQ0Pao2qHXPekQ4IUciF1CoUIj4EKeCvt37BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736213093; c=relaxed/simple;
	bh=EQirzO9PJiBt4zjm8YwXhZ0hhDBJ+X3ZzRCPMVEDFIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G5vdpwzeBA30Cf+H9C+QHPGQ1xkoL9FCAsb2dx5Lf6gODw1AaYJDANL3xj0mFUAKiwEQ+y6FBKtnLUU2HqC69RSXcaPDnMP7XhMUbZewlQzVfrCmWcG6uFUbPBAO/YYPdXgW72OmcRkOrSLY/3n9VXkPIhWMXceVWyftqG3QkhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J6Pq7hyg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J6Pq7hyg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736213088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yg712Yn+z0RJYnuZCNfHYnCS5dwWsWsb5SZxMdPzpTI=;
	b=J6Pq7hygxvvaPWcwJvQcy3oNHZ/tTMr5yPOwrDf8SB0Mx2P2V5vki+V1hOicbsp0U20nVr
	M5BXI4tOOzGMG747s1t1Ni+dfz3uQStCc6WgrvhDFoRY16eFNBov8Qjqs2+YGegVdd2+AL
	sO0x93D++c3YWMj21uyY7KFxrxx5QIQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2--gBFHgVZNmqUZUk8qkOUtg-1; Mon, 06 Jan 2025 20:24:47 -0500
X-MC-Unique: -gBFHgVZNmqUZUk8qkOUtg-1
X-Mimecast-MFC-AGG-ID: -gBFHgVZNmqUZUk8qkOUtg
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b6e852eeabso2222740385a.0
        for <dm-devel@lists.linux.dev>; Mon, 06 Jan 2025 17:24:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736213087; x=1736817887;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yg712Yn+z0RJYnuZCNfHYnCS5dwWsWsb5SZxMdPzpTI=;
        b=u/lxQIZA2CUJNIcSu597ErVtVU8u1zrRD/8z0xt0OQC5CMyqiY0eFfQHgwisj2Azi8
         pMkNVBWQYxM+zJLSnP5PUpZErDZfPD8mjgtZGaTAIF/H16JCe5/JD8pe4eQW0vaVex5G
         UKJp7IBzDy0JbWWnL6hOQ3WFUR2M5/kpqEXnm3e8YTY11Kzbe+56Avoly6vkDqMUECW8
         XyjeQM7+tM153xb2TRtSPjlGTSd6tUqkEpiTFV/kGwjtUhrS0twHFm3XoFKeeY6nkOft
         AEEERCQATaBSouHf9ye9kzmJwHtVOnmRKKzU0TY87gYUNQ7EQxo7cy9aXzYCnXnqca3e
         frsw==
X-Gm-Message-State: AOJu0YzSiXmUNG4/ww6PlXWXDrXtuMsPyHmjeXqNPjV49Nq24TCitiUi
	GZWaiU4V/9oZLQmrpStQoyMSXKEzZ2C0m3Z4Xf450pYa52sn1mTE807SFnbC6WD3EbUcihISW9y
	6QWhGoPYwzgz5kYEzYJ9uCRctvBbYCRzyDqdETTV2Vxg6PbnR41fIUauoK/Yg0q6G
X-Gm-Gg: ASbGncsvbaVd+VqN1R28wT9fIiDZPnuAvYpP8QqJ4WtYglWWthyo+v7isOtIDU/JDm0
	zII3paDSTKEDbEDYFO6PozQtblEasFLQoOJezSQQ8aIXxqQDu3YxL9y4iCPV8rCGFStGLsUBhmh
	5ysFtULAQRqAb0jGS92ZZktUl41yl7msI+vEKHT1Ul50DEKFsieEwVO6tCj5T442AH8lZfLWAel
	Ci0xwhYTu+Rkefle6/IS9Ea7EnDR8NpbATMPK3dgEyzmcmRjq6Aenwg1A==
X-Received: by 2002:a05:620a:284b:b0:7b6:66d0:5ac2 with SMTP id af79cd13be357-7b9ba81f887mr10061128885a.54.1736213087002;
        Mon, 06 Jan 2025 17:24:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEtf4sKQX1YxLWJSLC4ZqDBudsGGWMJ6DcaXDS7XRRyAFIoETiJ89lZv3jcCqwE0+tqC+OboQ==
X-Received: by 2002:a05:620a:284b:b0:7b6:66d0:5ac2 with SMTP id af79cd13be357-7b9ba81f887mr10061126885a.54.1736213086695;
        Mon, 06 Jan 2025 17:24:46 -0800 (PST)
Received: from [192.168.1.165] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b9ac2df39fsm1555027385a.38.2025.01.06.17.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 17:24:46 -0800 (PST)
Message-ID: <1d3beb46-c244-4ecf-8bd6-1895954c8e4d@redhat.com>
Date: Mon, 6 Jan 2025 20:24:45 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm vdo: Fix W=1 allmodconfig build error
To: John Garry <john.g.garry@oracle.com>
Cc: dm-devel@lists.linux.dev
References: <20250106141731.1341034-1-john.g.garry@oracle.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20250106141731.1341034-1-john.g.garry@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 12S8fNlU_v0Lq-GIwpctu1h6_Oh4ebH7a7Qk4F_mT1I_1736213087
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi John,

I'm all for getting rid of warnings where we can, but I'm not convinced 
this is the right approach here.

First, we use snprintf here because we really do want to limit the
string to 15 bytes. Making this constant larger doesn't maintain that. 
This change also increases the size of struct vdo (in vdo.h) by about 50 
bytes. While that's not a lot, it does seem unnecessary.

In practice, we know that the our module name is only about 6 bytes, and 
the instance number will never be more than 3, so snprintf will never 
actually truncate anything here. Would checking for a non-zero return 
value suppress the error?

I'm also confused because I don't understand the difference between this 
line and the similar use of snprintf at 
drivers/md/dm-vdo/funnel-workqueue.c:430, which I presume does not 
trigger a warning?

Anyway, I'd be happy with a version that suppresses the warning without 
changing the size of any structures.

Matt Sakai

On 1/6/25 9:17 AM, John Garry wrote:
> For an allmodconfig build, I currently get this error when building with
> W=1:
> 
> $ make W=1 drivers/md/dm-vdo/vdo.o
>    CALL    scripts/checksyscalls.sh
>    DESCEND objtool
>    INSTALL libsubcmd_headers
>    CC [M]  drivers/md/dm-vdo/vdo.o
> drivers/md/dm-vdo/vdo.c: In function ‘vdo_make’:
> drivers/md/dm-vdo/vdo.c:564:5: error: ‘%s’ directive output may be truncated writing up to 55 bytes into a region of size 16 [-Werror=format-truncation=]
>      "%s%u", MODULE_NAME, instance);
>       ^~
> drivers/md/dm-vdo/vdo.c:563:2: note: ‘snprintf’ output between 2 and 66 bytes into a destination of size 16
>    snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      "%s%u", MODULE_NAME, instance);
>      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix by defining MAX_VDO_WORK_QUEUE_NAME_LEN to be sum of MODULE_NAME_LEN
> plus 11 - 11 comes from number of characters required to print max unsigned
> int plus NUL terminator.
> 
> Also relocate the include of sched.h to the only c file which it is
> actually needed.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
> index ae11941c90a9..7e42342263ab 100644
> --- a/drivers/md/dm-vdo/funnel-workqueue.c
> +++ b/drivers/md/dm-vdo/funnel-workqueue.c
> @@ -11,6 +11,7 @@
>   #include <linux/err.h>
>   #include <linux/kthread.h>
>   #include <linux/percpu.h>
> +#include <linux/sched.h>
>   
>   #include "funnel-queue.h"
>   #include "logger.h"
> diff --git a/drivers/md/dm-vdo/funnel-workqueue.h b/drivers/md/dm-vdo/funnel-workqueue.h
> index b5be6e9e83bc..3447aac5b188 100644
> --- a/drivers/md/dm-vdo/funnel-workqueue.h
> +++ b/drivers/md/dm-vdo/funnel-workqueue.h
> @@ -6,12 +6,10 @@
>   #ifndef VDO_WORK_QUEUE_H
>   #define VDO_WORK_QUEUE_H
>   
> -#include <linux/sched.h> /* for TASK_COMM_LEN */
> -
>   #include "types.h"
>   
>   enum {
> -	MAX_VDO_WORK_QUEUE_NAME_LEN = TASK_COMM_LEN,
> +	MAX_VDO_WORK_QUEUE_NAME_LEN = MODULE_NAME_LEN + 11,
>   };
>   
>   struct vdo_work_queue_type {

