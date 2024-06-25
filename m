Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBC117C7AF
	for <dm-devel@lists.linux.dev>; Tue, 25 Jun 2024 18:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340651; cv=none; b=RmBWBTIXcVWxvQsXheKFeTkFI5USdTlH0Q21tYi7KdpT4eJIdtEV5mOt06VXexJDxdQ8CwTruFkyskUuZzDUcqwfcok2wps8X1bWjjK9ao70MCwDK7w5qvNJT4bI2sE0IOUowkbaRqghVV4c0yE3Hp6oD7QoZXSDJGB25kGy6jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340651; c=relaxed/simple;
	bh=xaBiOUCcbhsEiDDlr9ft/ApwQ3CgJk9n92ap/EN2vY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n89QgyqjWZ+s4mNVOkt7Fn9vNBPK3/SHi31Z/gpAtxIp9K07lJNOiwg0A2No7+cYPNA4L6uVzCJMssIo0yok2+m16yWWJpNz3gXTfpkuvdf53jff9wM45hyftNxhxy5Olpq0KZZgMBQRuP7lmhjA4WIsX/Y9IM4znitNDOTAk1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z0im+Bxi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z0im+Bxi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719340648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rjP8zqa9DjMRaFNMcMFYFsi4VJ9TPziW2E5FbrHXUKo=;
	b=Z0im+BxitRMpa3efI7Gc4GXDv6uxULwyAdkPmaMCbIq7S0H5uiVARBoEQnp4tnmEol2cJv
	HDFAdCHpDWzOTZPslsqLVMtzF6VTHEiCwy0W/IbWrPMf6uimpMctrlUVpI9RMYoqM1VAle
	yRRCFJqTg4iH789GEktvq9NaNX+hD2w=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437--50twuzgONe4NFK6YXKe-w-1; Tue, 25 Jun 2024 14:37:26 -0400
X-MC-Unique: -50twuzgONe4NFK6YXKe-w-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-79c07db4b3dso145663385a.3
        for <dm-devel@lists.linux.dev>; Tue, 25 Jun 2024 11:37:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719340646; x=1719945446;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjP8zqa9DjMRaFNMcMFYFsi4VJ9TPziW2E5FbrHXUKo=;
        b=wkIS1ruifTGbjkjfdReHTlAGu4EwXGHcLRZMP8bbvrhrWNJvTCWVEybDvxCLhm66Vl
         Ls/PUK0G9s5vQCutENl9nRsPasWrDmxm1NAGkKoaToh2GXRk1MxD56Sn4L8uTIUUrv4f
         +PEsH2WaDCnK9ohZTaCsgtXrAiRCad+87/zMNpS2MpuO2aF1lAUn9tKAiboAtm6MOlzy
         pl7t1cVg4SezzLUkb0RcrKPYI6NTqDZUjrTU3svSnHIw8TO00oTzuXTTCL1UmXtoDel3
         /hP6jEnLYxxH3P8shAqGfy4xnM1C7eyYRbYvlpxe6F0/6z7FLn23tPiYAsP0ppX+H7fK
         96mw==
X-Gm-Message-State: AOJu0YzbJnlxwzdKWqO/2vNxxuEmBbWdb/q9neXNUShY/wXwaPJi8ua0
	QjGUKDzvHk4HKzt2GqkKWdoQFjy+hHEIBdNl2Ffd2XYq32lj4MpbzztN2BLPdZbbiYsNj1oJs3o
	ZpWRn6NZmlyGNw79fJ/+cBnz1JLS3IZgZRRDUs2Ol4SU+wx2vJAjPJmlc
X-Received: by 2002:a05:620a:838b:b0:797:9c76:32a6 with SMTP id af79cd13be357-79be6f1457dmr796242485a.56.1719340646353;
        Tue, 25 Jun 2024 11:37:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoWPotw+0VrcrvK+GuskbqBpoUwqThBFYkTLju4QKTs3hCDfwBWUdZAosjHkIX634yXoPh6w==
X-Received: by 2002:a05:620a:838b:b0:797:9c76:32a6 with SMTP id af79cd13be357-79be6f1457dmr796241185a.56.1719340646055;
        Tue, 25 Jun 2024 11:37:26 -0700 (PDT)
Received: from [192.168.1.152] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79bce8b3777sm427599985a.54.2024.06.25.11.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jun 2024 11:37:25 -0700 (PDT)
Message-ID: <c08ab47c-944c-7393-d403-e4435cb283dc@redhat.com>
Date: Tue, 25 Jun 2024 14:37:24 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] dm cache metadata: remove unused struct 'thunk'
To: linux@treblig.org, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240523210550.309116-1-linux@treblig.org>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20240523210550.309116-1-linux@treblig.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/23/24 17:05, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'thunk' has been unused since
> commit f177940a8091 ("dm cache metadata: switch to using the new
> cursor api for loading metadata").
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Reviewed-by: Matthew Sakai <msakai@redhat.com>

> ---
>   drivers/md/dm-cache-metadata.c | 9 ---------
>   1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
> index 96751cd3d181..0ad9dc1824fa 100644
> --- a/drivers/md/dm-cache-metadata.c
> +++ b/drivers/md/dm-cache-metadata.c
> @@ -1282,15 +1282,6 @@ int dm_cache_insert_mapping(struct dm_cache_metadata *cmd,
>   	return r;
>   }
>   
> -struct thunk {
> -	load_mapping_fn fn;
> -	void *context;
> -
> -	struct dm_cache_metadata *cmd;
> -	bool respect_dirty_flags;
> -	bool hints_valid;
> -};
> -
>   static bool policy_unchanged(struct dm_cache_metadata *cmd,
>   			     struct dm_cache_policy *policy)
>   {

