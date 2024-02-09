Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F55381B9
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 13:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707484020; cv=none; b=ZsJ+2w1qfH8V1zIy6srCH/RIs3NC3RxlHWnOQQcmMpgXgRZCUlaLlwJtMsaLO/XYBn2PuPayrWDH2uno7LXctQG2vU0MzX4ygqhsathdxrdZtT0bmJHmDKY0TmqJXEIumEdgczj+aiMKOy8TfFIoePFId/xJSqqkfA2nmtfhL4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707484020; c=relaxed/simple;
	bh=mwYnJS0+LzIg/+6UW0BYzQFVsonuXxfV6SfS9yxoSoU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AHUtf4u2Jd7XcHYNSC/kvCQMNDfLW7Kfhoy+enaac4QJ+lWVuDKwUJvObGdJ11Ne+v1P8vrQRIYXQN6ADPh7bKaWCeJqQfELSCl8b7VR+0siI9hcndVMqdyvJX/vDomU1mSG43IFhKmP8EWlHtUmyKiUabpFcz3IyrhrVHKCUHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RRn2soLD; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RRn2soLD"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d0e20b7375so1671281fa.2
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 05:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707484017; x=1708088817; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P1u9lAoZ0ZGyWSyoYfmQa+5dsdTX37Xcv52D6C4iKhA=;
        b=RRn2soLDAEcXCjpcRxAIgMouiL50BsghMmZDyQoDEdjjMrj00hlq0RxJB6b6fHT9g4
         A4h742O7a9ed94L4IjnJXCWX7MMRSbRBn7CY5ewKV+IU2iW2aKex8Scsw2yPzvG3DYGQ
         wSoUvndx52Vt5lNlPyM0ltNdaUpO4AZLrlWFmHdoHWWcuIqCeJaBG1raeCJs+y3re+wZ
         sGEusVeGs8Z4enSQbs0pknWTuM6Ehj+MAxFIbN9cimIYbmc2u8VLUcjWfpoaXFaSolFF
         ijBZvucRX6T6H/QA7YR17zYRcoAQCcd1cqea6eTZMzZpmsNlYIioZmntoUuQpdpOaBME
         kH8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707484017; x=1708088817;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P1u9lAoZ0ZGyWSyoYfmQa+5dsdTX37Xcv52D6C4iKhA=;
        b=gxfk8Yz02IyYDuzcJIOqnJV7QaltJyfVbYaUtEUPz+DDO/zviUIRmow7DmvXCmRnUR
         v0cAc64xEk8NV1lcyLOTomKZQ6HserczDeR7KoA/rONQobo37CFJt0h0OPgFhyzh/+tz
         mmnB3VtyClQZCyzsziUUhOPRLA2QBZCKBLdlNC2PzPNPJLKucBJ+M/P370J+oyIDZeBS
         kubJO5HHseptgdxU6zZXI5aSNx4lEz7JFWs5/5kQR11lT9EnO8PMnU2ILhkCLpkpt6Ro
         HUrRFETS7A0K9dd6PG+OLYdqAzvnA/9G5slUc/kWOj7RLYOVfXDcq0adhMM5OjxdFBJK
         VD1Q==
X-Gm-Message-State: AOJu0Yx5100qRYMtIXMmaEJvc7cnkgeeJfCLLr/g3GmogaUNARFfTheO
	OwQx4d/DxKX6Tj2PswaHXqgIDKMz/B50JtfxWC36DCyLz7vrCQTTJq3b2bB4xWY=
X-Google-Smtp-Source: AGHT+IGiRD7II4F0HfnN7Pjy7rHI3AeopZe7vGIAThjtwDa8zri6h2CRU6gGycqBmSgsfbGuoSixsQ==
X-Received: by 2002:a05:6512:547:b0:511:6b01:4630 with SMTP id h7-20020a056512054700b005116b014630mr1118562lfl.24.1707484016768;
        Fri, 09 Feb 2024 05:06:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWjq9HCHBhQ4h+XcPAECN45BwLm6h/Q2Ucle3khD4K0x5doU8HwOkKDtPxUsENHo4qnE/h9w8dWisE6I7sY651m+6e1M8oLJj0=
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id ty11-20020a170907c70b00b00a36f28baa8dsm734383ejc.111.2024.02.09.05.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 05:06:56 -0800 (PST)
Date: Fri, 9 Feb 2024 16:06:53 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev
Subject: [bug report] dm vdo: implement the chapter volume store
Message-ID: <3673d6ff-920a-4e20-b155-3a18b143ad95@moroto.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Matthew Sakai,

The patch e08b7fe0c6fa: "dm vdo: implement the chapter volume store"
from Nov 16, 2023 (linux-next), leads to the following Smatch static
checker warning:

drivers/md/dm-vdo/volume.c:597 process_entry() warn: inconsistent returns '&volume->read_threads_mutex'.
  Locked on  : 552,580,588,597
  Unlocked on: 565

drivers/md/dm-vdo/volume.c
    542 static int process_entry(struct volume *volume, struct queued_read *entry)
    543 {
    544         u32 page_number = entry->physical_page;
    545         struct uds_request *request;
    546         struct cached_page *page = NULL;
    547         u8 *page_data;
    548         int result;
    549 
    550         if (entry->invalid) {
    551                 uds_log_debug("Requeuing requests for invalid page");
    552                 return UDS_SUCCESS;
    553         }
    554 
    555         page = select_victim_in_cache(&volume->page_cache);
    556 
    557         uds_unlock_mutex(&volume->read_threads_mutex);
    558         page_data = dm_bufio_read(volume->client, page_number, &page->buffer);
    559         if (IS_ERR(page_data)) {
    560                 result = -PTR_ERR(page_data);
    561                 uds_log_warning_strerror(result,
    562                                          "error reading physical page %u from volume",
    563                                          page_number);
    564                 cancel_page_in_cache(&volume->page_cache, page_number, page);
    565                 return result;

This is the only return where we aren't holding
uds_lock_mutex(&volume->read_threads_mutex).  It looks like this
will lead to a double unlock in the caller.

    566         }
    567         uds_lock_mutex(&volume->read_threads_mutex);
    568 
    569         if (entry->invalid) {
    570                 uds_log_warning("Page %u invalidated after read", page_number);
    571                 cancel_page_in_cache(&volume->page_cache, page_number, page);
    572                 return UDS_SUCCESS;
    573         }
    574 
    575         if (!is_record_page(volume->geometry, page_number)) {
    576                 result = initialize_index_page(volume, page_number, page);
    577                 if (result != UDS_SUCCESS) {
    578                         uds_log_warning("Error initializing chapter index page");
    579                         cancel_page_in_cache(&volume->page_cache, page_number, page);
    580                         return result;
    581                 }
    582         }
    583 
    584         result = put_page_in_cache(&volume->page_cache, page_number, page);
    585         if (result != UDS_SUCCESS) {
    586                 uds_log_warning("Error putting page %u in cache", page_number);
    587                 cancel_page_in_cache(&volume->page_cache, page_number, page);
    588                 return result;
    589         }
    590 
    591         request = entry->first_request;
    592         while ((request != NULL) && (result == UDS_SUCCESS)) {
    593                 result = search_page(page, volume, request, page_number);
    594                 request = request->next_request;
    595         }
    596 
--> 597         return result;
    598 }

regards,
dan carpenter
