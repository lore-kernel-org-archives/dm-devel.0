Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BAE382F10
	for <dm-devel@lists.linux.dev>; Tue, 31 Mar 2026 12:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774960832; cv=none; b=g5Eyc2lMiUYvMKzz57gkb4Wo2qG0k64sInL4u/SfAw7wxBD49DWKaWgyo5boyfYg4mCnn6CjJjf/v9j4Isi7XBdXL4oht2TMYAGfW8cPd0u1/g5TDEqFLpphh+AQ9OziCMDBpTj2ZBL5cpfWJqtOF2DlQYjF1TNW19WRtYV1r/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774960832; c=relaxed/simple;
	bh=8pRQ3eacAOC2POnpW0I7/i/Sp8gs+ggqFZSKHlfZdKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eJneOkc1zyCGsj4TNvADAl22U9xpJ1CmefSmMlehrXLmeDTlSySM860DtVikLnGfS4RKDznvXrcdj/5wDavfOjKjJ72d50QrVcGpLVPmgOjnBoXDdQ1UqQ683qdMCB/SOVTOfOLlZDECzlfdmptQZo4nbNjr6ZdCc0MfpkF3O7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tr0vnnIw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tr0vnnIw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774960830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S8NjDAbsu+6RKz2WffUnh7lNrSqDMbfpxA63M0QQ7pQ=;
	b=Tr0vnnIwtLqZ3K0D4X2sCHCrKONrC2P7U/A4/tFhOJh3ZhR5eUmdBSP+V594z5+S7qlgbR
	hF28q9fu1v2txxnbaqYfdy2vEElh3mkLMpQ3drvHqtPcG0PQ/yh1NKDPjc4bCnt0lRbkGU
	0R7wI40NaIPA9AApQSuT01koS1ihKf8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-k0wv5QHNN6WuTBK_cSeX_g-1; Tue, 31 Mar 2026 08:40:28 -0400
X-MC-Unique: k0wv5QHNN6WuTBK_cSeX_g-1
X-Mimecast-MFC-AGG-ID: k0wv5QHNN6WuTBK_cSeX_g_1774960828
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cfcebeb1f3so1191724185a.0
        for <dm-devel@lists.linux.dev>; Tue, 31 Mar 2026 05:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774960828; x=1775565628;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8NjDAbsu+6RKz2WffUnh7lNrSqDMbfpxA63M0QQ7pQ=;
        b=nwMj1D733r/r73tILX/15fBQWGHVKULIExnlHaB32IK9XaLRWpfQ1p1rYsOclEudXR
         sn5B0asRHKpzet1xZ6XMDsSlDqmGtfJc1R7eXo8ezxp/sBXDb+pHttCXFOJ6CFNKUKAY
         ljnrfsfR5dcAjeCqGBXrlf7zxInBd4RNbteTuS0hob0dISzsCmnprYACydP3uEaWcl60
         VmnUKxN7YU4sqcU5dreTAdldLZzFbMaRFkmV7ET6YxVl/3NVB5whPOi5NaXOUSXp9KEt
         Kp9A/HcuKzQ68u0fJpmNlyc45nZHLg4MwjKf1zDuL23FYxmW61/ikedHcAD1Qqi/nR2A
         +pkA==
X-Forwarded-Encrypted: i=1; AJvYcCVhiFVPvW+MW43K1oKnmJPsdHdV6AppvApRsALBoYOvYUiQ7Ry0J4ttFReYY3P8Z8yTnmKd5cdAuw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwJcyguKuk3xErN57wosG8JMiyc7/kCZ8FCmpP74i7Bkb8afeFT
	FjnSlF2l0CYn+t+Gm7F8QIWkn92RreF+5c7jtVt3I2+zUDFA78yxho9lK5574RmUcsfPPgeEd5p
	fShh4YuYMgZRNLSwcRYL5z8aV2YDgsds3iQN+nu6IvYDmSMRyLUNeJMFq6TOj
X-Gm-Gg: ATEYQzxUqVM39aW7T0roists67dhzjezgWlxk2HlEnrCHcKX/CtMH4QDzdM2hTH0T+q
	aYkQTEpGHfHXD7UMtFw3FGSZUcsqQmeGYeTSuCQv6NNZSZtQu8VA7pbhOmyz0MyE82+kf5Oo5Qe
	a5BF2i3zWIutPyTDysZZofW6oZCw2nIIdAFzeuTOxNMyDkUaXIUWG4pk9cujI6747ogTd+ENOiY
	9aCo03+OmlBtx4FOGsYkl6gvm7748wAYhJdXXoTYLt5I7ADfSlgIjW679fIZsu0mYJ/WJGKXNUm
	roGxSAeokTdROVPXY4B6ZwsnPujNPYvgFNLTvrIxF+JmAUfvohTgcT63t3FbhbCK0B1KsxV89vM
	JeCiaY7o85ZSXu34wUgPvp3V5ngPHW9T3IfLvyspss9wnIhTQFYTps/WHnnSrCugPmBLfRg==
X-Received: by 2002:a05:620a:170f:b0:8cf:be85:ba84 with SMTP id af79cd13be357-8d01c7dfce9mr2000972385a.54.1774960828130;
        Tue, 31 Mar 2026 05:40:28 -0700 (PDT)
X-Received: by 2002:a05:620a:170f:b0:8cf:be85:ba84 with SMTP id af79cd13be357-8d01c7dfce9mr2000968085a.54.1774960827621;
        Tue, 31 Mar 2026 05:40:27 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:2500:540d:8da2:f197:6711? ([2600:4040:530f:2500:540d:8da2:f197:6711])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d028095097sm864634485a.46.2026.03.31.05.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 05:40:27 -0700 (PDT)
Message-ID: <854702a9-a3ae-46c8-a3d6-88dfbc4fe97b@redhat.com>
Date: Tue, 31 Mar 2026 08:40:26 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] dm vdo: Fix spelling mistake "postive" ->
 "positive"
To: Colin Ian King <colin.i.king@gmail.com>, dm-devel@lists.linux.dev
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260328123320.657837-1-colin.i.king@gmail.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20260328123320.657837-1-colin.i.king@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -Gilln06h6bItTi2O8vKMF7OobQCCqY63ZhgabGlzUs_1774960828
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/28/26 8:33 AM, Colin Ian King wrote:
> There is a spelling mistake in a vdo_log_error message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Reviewed-by: Matthew Sakai <msakai@redhat.com>

Since this is a change to Bruce's recent series, it might make sense to 
fold this into one of those patches instead of applying it as a 
standalone patch.

Matt

> ---
>   drivers/md/dm-vdo/dm-vdo-target.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
> index 0135a6f941fd..1d8375cc3c3e 100644
> --- a/drivers/md/dm-vdo/dm-vdo-target.c
> +++ b/drivers/md/dm-vdo/dm-vdo-target.c
> @@ -412,7 +412,7 @@ static int __must_check parse_memory(const char *memory_str,
>   
>   		result = kstrtouint(memory_str, 10, &value);
>   		if (result) {
> -			vdo_log_error("optional parameter error: invalid memory size, must be a postive integer");
> +			vdo_log_error("optional parameter error: invalid memory size, must be a positive integer");
>   			return -EINVAL;
>   		}
>   

