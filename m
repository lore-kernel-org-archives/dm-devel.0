Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAF0275848
	for <dm-devel@lists.linux.dev>; Mon,  6 Apr 2026 21:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775510052; cv=none; b=k6GiNA6jLDvREmvfkzCu4EEsAIjIioyU9ruR8OMh9MC4Q1dyfIuCS3RwyXE71jey6awDpsdO0Uj9cAVijPa7UPashN5lNV7rF6ogpF0ceuLcgN9UcA3GUZ6r7Dj5uId7FbPmQwGABwcC9rWjowyIyPFvbPcSkYpoLs/CCVctgUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775510052; c=relaxed/simple;
	bh=TJWAiyLjINtrwAQV18kL9fzsN6tGI2KUXAVbKurrjB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lGB2TVix49qWg2WSjPk1pqS2m4/g3r+hhdnfYXNJFO9RiWI4lXY15ILp26ifJY7FRD8yAbL1IHMhYUCY0rE/6i5A95WcCV/SIUItUCPGscpAz7vtwat4zMF0nTdnQZ9D5xMcwckqIn8E1u3hp2HDDro/XcmwWi3GtpGMunQCvWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZNDKnYgD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZNDKnYgD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775510050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u6eiLy0THPzh19v4xRPOdwo1i97CoxO5wof7uqqfnf4=;
	b=ZNDKnYgDs2e5yEH197Ag6agsTZQUbubRIBVQjxnk7aNALXsac9+8hlDGIEAmHmfIiz3onB
	QpJ5MShIVmzXcVOj2ihAfArhv02CEurKHEzsM9Wkv6nvb5wRp31/+YB9G+7VjCMr2Emnee
	zcGAefXuRMvd2sjYFy4H86taW451qoU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-gI2cQ4yqOq6YO2EHlyxOIQ-1; Mon, 06 Apr 2026 17:14:09 -0400
X-MC-Unique: gI2cQ4yqOq6YO2EHlyxOIQ-1
X-Mimecast-MFC-AGG-ID: gI2cQ4yqOq6YO2EHlyxOIQ_1775510049
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8a4f18b1b5aso212352266d6.0
        for <dm-devel@lists.linux.dev>; Mon, 06 Apr 2026 14:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775510049; x=1776114849;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u6eiLy0THPzh19v4xRPOdwo1i97CoxO5wof7uqqfnf4=;
        b=r8DZCYoF2dtHwzBlIHoww2QQtE4irPe8tdTE+itko8zSwnOpiYgJ7PKJnfFFnw2SVJ
         lrUHbJyxnO+1V9ktObu8AuB7JlgPNgcCbULLm5rydqKNtSWbENtPipKDDwimfGK6HKqJ
         gcQ2y8TggUY0M5sdZ/2X3W2QKNVvDpfzPJO1mO8wWNWEfY9zK2mqfL3rVlSLozvRSBCx
         o6OoYFerQROIKqJz0GPYka5DgqyPe4hgpnDzHusw7Vu4UNLgdgPrc/Ye+iM4YCSkzQOT
         viV6XBCSjd4IIZtoJbOkLgjMhhwtWQY8J+0NwErjGmZ6w7OsT72oDJevQJa7Yu7DLfSL
         7m3Q==
X-Gm-Message-State: AOJu0Ywg/iuh5Ug4paQZHKusJ25HjdpgLqEq2yZ4nGupXPvUyxxdZjbK
	6DXeh5Oz8ymNHXhJiMyKspvgaMxXp42LmBBjovdNZ1R4/SUMJ/Ecwog0mxJA3txM1IKo3uGNxsY
	iHvM3eJK1BEoUjuuWb+iV8N2ztvNpOaJkvCtxfKVew6mtR9lflFROpT2N6oKH
X-Gm-Gg: AeBDievNTGcAXFVMUACyQ1ZVUixRQDGE1j9Cc1EmKqOIJ1RK+cyAC/gNIJaLzGrk0Aj
	tCH0iV3KKuoIMEgK08ACXUi3qC6MfDTtiw1C/fJttIp4J0v03ZoM5swy8sQSH/MHNAKdxxDTII7
	JWy+enVwQeVqd40VqyoQ9ocTgDZ/3iC9TkaPsFXfnLkz2HSCYrK6TzsycdE3xKI2kSzUeTcOAjf
	SvVzgSGwxhEa1HBuunrevdQBmU11YPZA5Rpehp5d4a6zYZxPN+zltwtddK0kv1M6zkY5o6s6oUn
	MDUsMY+GGEJkQwsl48FBSnL0fTTusNmG9Ad0tWKkeJrKx7Xt4mLJZrHshxk66t9JrvLFPGWjx09
	m1IajSOccFReJ/uXx93jECv5e141G17zlRcukWY1aG13Hf0YA6MyQZ1knXthVDZ6DnWmKmw==
X-Received: by 2002:ad4:5dcf:0:b0:89c:6b92:1c1a with SMTP id 6a1803df08f44-8a705687d2bmr239681556d6.51.1775510048742;
        Mon, 06 Apr 2026 14:14:08 -0700 (PDT)
X-Received: by 2002:ad4:5dcf:0:b0:89c:6b92:1c1a with SMTP id 6a1803df08f44-8a705687d2bmr239680936d6.51.1775510048210;
        Mon, 06 Apr 2026 14:14:08 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:2500:540d:8da2:f197:6711? ([2600:4040:530f:2500:540d:8da2:f197:6711])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a596e03dc6sm152715996d6.34.2026.04.06.14.14.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 14:14:07 -0700 (PDT)
Message-ID: <0420fb5b-67ff-4322-a121-d0444b0aedd0@redhat.com>
Date: Mon, 6 Apr 2026 17:14:06 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] dm vdo: use get_random_u32() where appropriate
To: David Carlier <devnexen@gmail.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260405154713.4660-1-devnexen@gmail.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20260405154713.4660-1-devnexen@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bofdjSi1E6r9YUAWUDm5SuKp-6_Nfocw8vMCLuvafR4_1775510049
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/5/26 11:47 AM, David Carlier wrote:
> Use the typed random integer helpers instead of
> get_random_bytes() when filling a single integer variable.
> The helpers return the value directly, require no pointer
> or size argument, and better express intent.
> 
> Signed-off-by: David Carlier <devnexen@gmail.com>

Reviewed-by: Matthew Sakai <msakai@redhat.com>

> ---
>   drivers/md/dm-vdo/indexer/index-layout.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
> index 61edf2b72427..8707930c9910 100644
> --- a/drivers/md/dm-vdo/indexer/index-layout.c
> +++ b/drivers/md/dm-vdo/indexer/index-layout.c
> @@ -256,7 +256,7 @@ static void create_unique_nonce_data(u8 *buffer)
>   	u32 rand;
>   	size_t offset = 0;
>   
> -	get_random_bytes(&rand, sizeof(u32));
> +	rand = get_random_u32();
>   	memcpy(buffer + offset, &now, sizeof(now));
>   	offset += sizeof(now);
>   	memcpy(buffer + offset, &rand, sizeof(rand));

