Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7667C1F171
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 23:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721172904; cv=none; b=mrZRpZUMFneN+56mL6ak2PGpNGIf5Z8paO3O7Pk6SdPiWZREshV7dW4gDeN4QNvi48dx5qqx7KWde/TF08zNLFL2KbtCPVFB5MO/ryZEBbN8Fyal7WN/jU7QGgo8S9lp4QWA0mj/gt7fCvAWgvzflKIh7rUD8/szuxoKqeJOocU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721172904; c=relaxed/simple;
	bh=/jffdEwWn7L2YoivxbrmHOwsLfBS9StmvlJNX8eENl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Lu1iaGZzU13dT8Kl74Z6QlTeErOm3aNumQyrtPXKew0qNmSFdUd8u3ZJbuVNIFzaZ4eu7Sq1ZRWe2A5zwxpB+GZDaTFpZihcrBM48hwoFzyVnssJznSnX0NkyY7+yx6V5axZzIvGVa/vBqp3E7zFxIp9veKBVdQyxzjG/yZs5QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MZmZWxfN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MZmZWxfN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721172901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQGrzrGZSBqaP71cme8W8rwCy5aHO6HxgDl52PBTHNE=;
	b=MZmZWxfNrYdGC6cmlFi4+a/5ax3SxslnYNWeKt4TcAQoGMPai2lsvp+LCTT6Ti8w2+5xku
	/mJjc10Jl2FzQfEsBi9lIWLyfAqrvKzPOJ5m0oT756bo9ThsnjsOjFpGC4ixBKgbk5vVqv
	2zBKg8YlEv3wademubtK+4RJLGjHNAw=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-CSKBqCouMi2XPK96q7cChw-1; Tue, 16 Jul 2024 19:34:59 -0400
X-MC-Unique: CSKBqCouMi2XPK96q7cChw-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-8101da8689fso226518241.0
        for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 16:34:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721172899; x=1721777699;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BQGrzrGZSBqaP71cme8W8rwCy5aHO6HxgDl52PBTHNE=;
        b=LngXtnJeKMFtKmdAeKzJ94oAD6imOimYHtNhR7+iIylgDI2gcWu4oko5UOvArzgWSO
         RaaeJCH3nbkSOEwL4XPOUAnyfN244yz9m0lec1M66VM9LUOEATALDDF0EopPjeZFTmm/
         dCdkivRrkhNjfwavYxY2AXniulq64I3qzS3MIfuSuMW/a6++fZIkHghUReIImXGgtOX9
         tXZFfco8dNcPul3liBJGQjuXUKIsfUdDn6AJazeLr+NzvcsZ4rZK8mJdz3KbRP/UtU+m
         kSRKG17Labsj3WCWjU6S0H0anDfQm8NTP44KBpFdSotWQOKrEfj9aCLBAkpx+fPJirrb
         r/sg==
X-Forwarded-Encrypted: i=1; AJvYcCXtkiCufwWB2oR/vCfwYNIIkX2V/S916xG+8XC7vBGmtLJv9XUXrV6huAeuyE59RBs3mr0QRH5ybzWGiMJEZS33EnA7IkEWo30=
X-Gm-Message-State: AOJu0Yz71pPm2Fme9EoI6SkcEjGwGp0T8ICSBDizJbymDALTrZiK+aSl
	2lmAjaCOTYzORhDM1ENUT0P8a9xKehvi8Idxl22oyJkcUOxLNfm7uVZDVDkp0G9HZpA81muibvo
	p9A/mTSpEJdVNl2usk/NX/s81TA9dbN8BGFHUHoUpkhnyWWVSc7QpRW4G
X-Received: by 2002:a05:6102:3311:b0:48f:e4cd:a877 with SMTP id ada2fe7eead31-4915986a403mr132539137.4.1721172899294;
        Tue, 16 Jul 2024 16:34:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFQAEpD8SgSv+cuWMiBS2GfLPgRtumnhUcF49Kc0TV8z8eMvQOaSBCytTNPujY9rhi+9/YCQ==
X-Received: by 2002:a05:6102:3311:b0:48f:e4cd:a877 with SMTP id ada2fe7eead31-4915986a403mr132523137.4.1721172898942;
        Tue, 16 Jul 2024 16:34:58 -0700 (PDT)
Received: from [192.168.1.152] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-44f5b835173sm40184751cf.62.2024.07.16.16.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 16:34:58 -0700 (PDT)
Message-ID: <2db92397-3d68-64c0-0c36-1160706b9883@redhat.com>
Date: Tue, 16 Jul 2024 19:34:57 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] dm vdo: fix a minor formatting issue in vdo.rst
To: Masatake YAMATO <yamato@redhat.com>, dm-devel@lists.linux.dev
References: <20240716190559.2346663-1-yamato@redhat.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20240716190559.2346663-1-yamato@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 15:05, Masatake YAMATO wrote:
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>

Thanks! I'll apply this with the next batch of vdo changes.

Matt Sakai

> ---
>   Documentation/admin-guide/device-mapper/vdo.rst | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/admin-guide/device-mapper/vdo.rst b/Documentation/admin-guide/device-mapper/vdo.rst
> index 7e1ecafdf91e..c69ac186863a 100644
> --- a/Documentation/admin-guide/device-mapper/vdo.rst
> +++ b/Documentation/admin-guide/device-mapper/vdo.rst
> @@ -241,6 +241,7 @@ Messages
>   All vdo devices accept messages in the form:
>   
>   ::
> +
>           dmsetup message <target-name> 0 <message-name> <message-parameters>
>   
>   The messages are:

