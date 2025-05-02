Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6569622AE7A
	for <dm-devel@lists.linux.dev>; Fri,  2 May 2025 08:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746175909; cv=none; b=WEjIDXqcnx/Rvk2J7qlvdOGVbld/VXE3wW3+JQVyPHqbIhjAq8IhbQbCY4I4pvhqnuUUHNJF4O9RQPzB3zLq5yZk7ET0jg5aETYaq1aqXASabW8cCltUIVVeW/uuspG342NA63xPWW5Ad6JbskXF9ca6zBWLSkqdyAk6BYrcfpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746175909; c=relaxed/simple;
	bh=iYadjrsEqr71stpjo1NQJ2G8MmGJ1DZgCRRrmPlLOyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ul4Qtx8R6sgyIh0FhxEhyGbIPL6WutlnZRQMxyOUIe6FUiGC0yN0LN/FVzxVonFT8WtCoXabFrKOvmOVHfIh0GIcS3UvxhL8quGoIXkILaEnedM4vVuf0qEPHl8vBa0SdtlBV/n2xX5UeQrK/KgSwZj7h6Hq6VYPWf9mpldYsoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ebq1H8rM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ebq1H8rM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746175906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WzygDpuNpJDOcuqsIhWvokemYFy3Ufsz7q5dUPPjzUc=;
	b=Ebq1H8rMpLIOqCAhkU4m8powpGEV0vtbOSpSdZAPfUUcof+NemuspcusyseGXPqZW1btTj
	0MwLhFbfv1EM1Gio0ZTFgT97kGDBPd71xJGtnz4gib/wH/I5ZZa9ZHhMGlSkseDm2VudRW
	YoidXL+/pkwpbqGAVi72SkiuxOLizVo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-xu6cSc89NQONqy-oO6JQYg-1; Fri, 02 May 2025 04:51:45 -0400
X-MC-Unique: xu6cSc89NQONqy-oO6JQYg-1
X-Mimecast-MFC-AGG-ID: xu6cSc89NQONqy-oO6JQYg_1746175904
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-39d9243b1c2so520939f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 02 May 2025 01:51:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746175904; x=1746780704;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WzygDpuNpJDOcuqsIhWvokemYFy3Ufsz7q5dUPPjzUc=;
        b=pAl16xntu5HDaVzGg9lIauzC1qY0IuZe22WK7JnbS0aZqHQyZkH3Q2bSHwil/3eote
         AwFVUdjNVLoyQXcFEpsz8M4NKHhyK+XFsO73AkDzGLEnolW2Rlcm5+VD2fK23DmWZIXJ
         5unM5wu/D67OOzE+AvMz5xIpcnnJio7nF6DwQhu0a4wi9mEFAYcgOvDoIWmTXA1i0seq
         7BnfkD2bpt+L/0evXCL6ruDrWEFCWjZHE7QPkQ6cVQTHo/VFWOMtBtXSOucyjYih2xqA
         +U8o2mP5/o3mtqghXSlb1Mc1GK8PRb6xLawpAasb/0TnvQm90V6Xy+h7pmPAxrqOB3ks
         9HGw==
X-Gm-Message-State: AOJu0YyP7drWingSOd45YeBUJi7E4uwmbBOsOm0/Cax+si3QuHzrBpCp
	KB/5B6ygVENBZijqQQeUJFeEWLugiFa/Cqenc+Luur4F7oRhSh7QH5pzxM5IxvSHjiul6Fe01tF
	1LozW7qJq5BYpjlfDYBdThhYPx53RHdv47i7JvuZHRVwScxJTU5EPhoM1
X-Gm-Gg: ASbGnctWQZeKKfReZnNiXKBFGbxqYeBNdSc8xW1XWSC8hwioc9rzc+7Xqj+GFm8oHzD
	EsxziAPFIRHfn/lQLUG4eSGOHOg0WXgAGfkuWOyU6XF08bdSyIRF4D3vMWZ82SItuPO6OWnpgpt
	UjezA+rE/+UugHibP1SUajWE6wyUbsoF5dbtwYOCQGLbzr+SKYjNH41JJ2uZltnEQyWP3+MRswb
	MXEtbqQh/uRKxvRzRedOOuBPy5nL+fDVR3rRm3++/jl4ljkvcw+cMzlONmLzjqdO9mBXXWfJ7PU
	9S5gnyQePDW7r+HcScP4bgRY3kyLyCVnop5rjLLnOrzeuFS2CVHTR4SHkKWaIRmPx/lLq1EUH90
	aVl2Bfpe25zI8uF8rMilWI6wJTPlIXTw3kvgjGg==
X-Received: by 2002:a05:6000:184b:b0:397:3900:ef80 with SMTP id ffacd0b85a97d-3a099ad7a5amr1253224f8f.22.1746175903815;
        Fri, 02 May 2025 01:51:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtQdxRjllyDZVHW8bcNWlSLTeldE7+72yIDyX6Iyt6gIVZKJ40FsbxQM3Lmh/WBTcBwNtB/A==
X-Received: by 2002:a05:6000:184b:b0:397:3900:ef80 with SMTP id ffacd0b85a97d-3a099ad7a5amr1253208f8f.22.1746175903480;
        Fri, 02 May 2025 01:51:43 -0700 (PDT)
Received: from ?IPV6:2003:cf:d71d:1526:111:3b5c:65a9:6b85? (p200300cfd71d152601113b5c65a96b85.dip0.t-ipconnect.de. [2003:cf:d71d:1526:111:3b5c:65a9:6b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099b0ffb1sm1509895f8f.73.2025.05.02.01.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 01:51:42 -0700 (PDT)
Message-ID: <3282af63-9523-4ab4-b9de-66ec69053bea@redhat.com>
Date: Fri, 2 May 2025 10:51:40 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-mpath: Don't probe paths that are getting initialized
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Kevin Wolf <kwolf@redhat.com>
References: <20250501050624.2475903-1-bmarzins@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20250501050624.2475903-1-bmarzins@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y2DE_XSIGTA4UeO78oR5AF2Y_aG5HdeAtlb4_nrCUQM_1746175904
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.05.25 07:06, Benjamin Marzinski wrote:
> __switch_pg() sets m->current_pg before initializing the pathgroup. If
> probe_active_paths() is called and pathgroup has not been fully
> initialized, IO to the paths may fail, even though they will be usable
> when the pathgroup has finished initializing. Instead, skip sending IO
> in this situation and just return the number of usable paths. The next
> request will wait for the pathgroup to be fully initialized.
>
> Fixes: d5d16fabe431 ("dm mpath: Interface for explicit probing of active paths")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>   drivers/md/dm-mpath.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)

Reviewed-by: Hanna Czenczek <hreitz@redhat.com>

> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index af17a35c6457..53861ad5dd1d 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -2068,19 +2068,28 @@ static int probe_path(struct pgpath *pgpath)
>    *
>    * Return -ENOTCONN if no valid path is left (even outside of current_pg). We
>    * cannot probe paths in other pgs without switching current_pg, so if valid
> - * paths are only in different pgs, they may or may not work. Userspace can
> - * submit a request and we'll switch. If the request fails, it may need to
> + * paths are only in different pgs, they may or may not work. Additionally
> + * we should not probe paths in a pathgroup that is in the process of
> + * Initializing. Userspace can submit a request and we'll switch and wait
> + * for the pathgroup to be initialized. If the request fails, it may need to
>    * probe again.
>    */
>   static int probe_active_paths(struct multipath *m)
>   {
>   	struct pgpath *pgpath;
>   	struct priority_group *pg;
> +	unsigned long flags;
>   	int r = 0;
>   
>   	mutex_lock(&m->work_mutex);
>   
> -	pg = READ_ONCE(m->current_pg);
> +	spin_lock_irqsave(&m->lock, flags);
> +	if (test_bit(MPATHF_QUEUE_IO, &m->flags))
> +		pg = NULL;
> +	else
> +		pg = m->current_pg;
> +	spin_unlock_irqrestore(&m->lock, flags);
> +
>   	if (pg) {
>   		list_for_each_entry(pgpath, &pg->pgpaths, list) {
>   			if (!pgpath->is_active)

