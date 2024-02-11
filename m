Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF94F5DF08
	for <dm-devel@lists.linux.dev>; Sun, 11 Feb 2024 20:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707681612; cv=none; b=thvG3h4eKVNhiyoVSSnLxofNYQl0LFBhsLQYSvf7+iZzI+Wactyc86E8wJmDy0O60ALPczdyKtJYnsgBIQixM73LkwNvTOJtPac6rx6Iqb5Ds956IjV8cNC10M/Qckk/TiylmD+T3J+1jyrAwkgj9BdW3YpW7tYgwIZHBHiBV6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707681612; c=relaxed/simple;
	bh=P25GHaShCC2hjJXtptwknbkQrVxZEF1kimKcMsMonHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gK1hnjyKcepoV9A/zpfiiDm+fzMuXXptAJ/3cYj6iXTe1zSUPSPc3gMqODN3ENPMTLqjpdevTJ7HVMMcND7OWuTpPuCi6x45pcc6padwRiyUG/A7Hcfl4R7t94rYI/spoEHGgORdplbbXO2hjGOtZTshbirLsQNmB5DMyIc9lT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-42c6b6ec76eso12751711cf.1
        for <dm-devel@lists.linux.dev>; Sun, 11 Feb 2024 12:00:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707681610; x=1708286410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZZIjxfGVo1kd2yWlmA0sobKpSUPDEilantKXc6s/QY=;
        b=fywxpskTnyAJO2zS5YKYBsjiYPbnW7BHn7wxOnsqZPv/i0HAjnvvqDBj0l/7j18cl3
         ToCJ4kqZCFNbK9BYL9rzCm8FhkXbo3kRl5tsabe8ipggTGCuAI8rCpCmGKyIP07nzOas
         LOl615ig2LLnb1z1HPb2zZOfQf6Innv6xNBqLxh2dgUqa1BAueXBKi9bxuLD1Tb3bV2G
         3fyrpRF47YBg7IkAaVB5YFs3JrvfRQbc4Z2PHYIeQkAVHGPNsqqsY24SD17SuZcddHmL
         nz1S2Gp+8xmc/J4Ef4No0LNTH4pxyaEjhDpT05iCEJdALLARAkCUXSHK8pMhz4qOhMEZ
         VINg==
X-Forwarded-Encrypted: i=1; AJvYcCUWoIyFSLLeOGFd1X560MJlNy83qRfb6R5mW2OHXf04D/NDUnG1wZXfsRP/3FqPCKfygFpxDbOX6RtXMOOQJsogHSX8FY7tphE=
X-Gm-Message-State: AOJu0YyMgSfPbffqETtWUaqPbmuvhdkGMkA/zh7giJac7vJwQwQqB7eu
	fJHGJoNaOAlYVbs9Q1hGCkTaW+/pyDVL5Y6Dsz7knnd2AoFcIXeJrgSHIks8aw==
X-Google-Smtp-Source: AGHT+IF63xrN+MjQdshUSpJb/Fh06Y7l7b938wIec3E4pTFFNtGpYD39/aXS6eBfqGQjdf/ojXxTBA==
X-Received: by 2002:a0c:e38c:0:b0:68c:c38c:a2e2 with SMTP id a12-20020a0ce38c000000b0068cc38ca2e2mr6533473qvl.59.1707681609801;
        Sun, 11 Feb 2024 12:00:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVa3ARRgmFzXmiLS/vH0WhxCnXgdkuJ68bAcCWEVSi+ce47oxu3WaIZi2ODBaVma7dBN5YOwlEdQ4dSwx5QEpCT8xVJBQr7QPM=
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id ol6-20020a0562143d0600b006819aeb62d6sm2952785qvb.136.2024.02.11.12.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Feb 2024 12:00:09 -0800 (PST)
Date: Sun, 11 Feb 2024 15:00:08 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: msakai@redhat.com, dm-devel@lists.linux.dev
Subject: Re: [bug report] dm vdo: implement the chapter volume store
Message-ID: <ZcknSBGUKMi5RxE1@redhat.com>
References: <3673d6ff-920a-4e20-b155-3a18b143ad95@moroto.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3673d6ff-920a-4e20-b155-3a18b143ad95@moroto.mountain>

On Fri, Feb 09 2024 at  8:06P -0500,
Dan Carpenter <dan.carpenter@linaro.org> wrote:

> Hello Matthew Sakai,
> 
> The patch e08b7fe0c6fa: "dm vdo: implement the chapter volume store"
> from Nov 16, 2023 (linux-next), leads to the following Smatch static
> checker warning:
> 
> drivers/md/dm-vdo/volume.c:597 process_entry() warn: inconsistent returns '&volume->read_threads_mutex'.
>   Locked on  : 552,580,588,597
>   Unlocked on: 565
> 
> drivers/md/dm-vdo/volume.c
>     542 static int process_entry(struct volume *volume, struct queued_read *entry)
>     543 {
>     544         u32 page_number = entry->physical_page;
>     545         struct uds_request *request;
>     546         struct cached_page *page = NULL;
>     547         u8 *page_data;
>     548         int result;
>     549 
>     550         if (entry->invalid) {
>     551                 uds_log_debug("Requeuing requests for invalid page");
>     552                 return UDS_SUCCESS;
>     553         }
>     554 
>     555         page = select_victim_in_cache(&volume->page_cache);
>     556 
>     557         uds_unlock_mutex(&volume->read_threads_mutex);
>     558         page_data = dm_bufio_read(volume->client, page_number, &page->buffer);
>     559         if (IS_ERR(page_data)) {
>     560                 result = -PTR_ERR(page_data);
>     561                 uds_log_warning_strerror(result,
>     562                                          "error reading physical page %u from volume",
>     563                                          page_number);
>     564                 cancel_page_in_cache(&volume->page_cache, page_number, page);
>     565                 return result;
> 
> This is the only return where we aren't holding
> uds_lock_mutex(&volume->read_threads_mutex).  It looks like this
> will lead to a double unlock in the caller.

I've fixed this	and added your Reported-by

Thanks,
Mike

> 
>     566         }
>     567         uds_lock_mutex(&volume->read_threads_mutex);
>     568 
>     569         if (entry->invalid) {
>     570                 uds_log_warning("Page %u invalidated after read", page_number);
>     571                 cancel_page_in_cache(&volume->page_cache, page_number, page);
>     572                 return UDS_SUCCESS;
>     573         }
>     574 
>     575         if (!is_record_page(volume->geometry, page_number)) {
>     576                 result = initialize_index_page(volume, page_number, page);
>     577                 if (result != UDS_SUCCESS) {
>     578                         uds_log_warning("Error initializing chapter index page");
>     579                         cancel_page_in_cache(&volume->page_cache, page_number, page);
>     580                         return result;
>     581                 }
>     582         }
>     583 
>     584         result = put_page_in_cache(&volume->page_cache, page_number, page);
>     585         if (result != UDS_SUCCESS) {
>     586                 uds_log_warning("Error putting page %u in cache", page_number);
>     587                 cancel_page_in_cache(&volume->page_cache, page_number, page);
>     588                 return result;
>     589         }
>     590 
>     591         request = entry->first_request;
>     592         while ((request != NULL) && (result == UDS_SUCCESS)) {
>     593                 result = search_page(page, volume, request, page_number);
>     594                 request = request->next_request;
>     595         }
>     596 
> --> 597         return result;
>     598 }
> 
> regards,
> dan carpenter
> 
