Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6168F2DE6E3
	for <dm-devel@lists.linux.dev>; Tue,  6 Jan 2026 22:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767739462; cv=none; b=ShD4ZCwR4SiyleHJH8Q2s1QFk9xQ+DhD7WBaJ9UgcjWs/HArDsqA3RMEBDQomCFy4T98asAqLMTo2bnJtsiU03w/+1UhB3yyN0Qlk8br9yYqV/0RxHuaPKbQx7V0Rm28SbPflYVVqtwIqP2feB0rb+8ntvx3KfjQJtK6pRUKF20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767739462; c=relaxed/simple;
	bh=ITjERw4U9PBk41BgCkmU3KS4pePQ4ckaHOWns5arRbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dvRJVZwc3d8xnXXNXDM+kk4EI4DAP90tTK6GBUmYHJM2OYkNRc5/+72qa+Rq0TiY+vw5L8t/bxzon/x0IOymafTZqXpd7oYa6XF0r+wCNg7+pkZUBtD2soc7K7OupNseGN2PCtn7wH1ZAfYbLC7VfeFRzFYX99XogLtMDYijihg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XmjCk4LN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XmjCk4LN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767739459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDfj0So7WZYgW0Csc1gyMZ0casdKBaEPpSS9WF9xG80=;
	b=XmjCk4LNC7oPayOeFJgmp7y//mtTIAPocPp1EPcIRVEpRAzPC18ky7TpwVPCfJ+/tZxBl5
	bxyycf7vX2V7cbdpnWnA1ADK6vrhPcjJAsrSL7E7bIxxCKAOJidhd7Q8bpyUUd2EdnKgvZ
	meTQMuT1eqrDBRVGOTl8T6kzMvcYewE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-R5LW-GeVMqK3DNhv7lJq8Q-1; Tue, 06 Jan 2026 17:44:18 -0500
X-MC-Unique: R5LW-GeVMqK3DNhv7lJq8Q-1
X-Mimecast-MFC-AGG-ID: R5LW-GeVMqK3DNhv7lJq8Q_1767739457
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4f1b39d7ed2so29986111cf.2
        for <dm-devel@lists.linux.dev>; Tue, 06 Jan 2026 14:44:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767739457; x=1768344257;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CDfj0So7WZYgW0Csc1gyMZ0casdKBaEPpSS9WF9xG80=;
        b=TBCid56wOysDw+0dJBS6ABpBgdMjq0uLjz4SF7ZQ2x0W7Xh/mf8zLsRegY/cHdAAsY
         hOwR4fc60thpK44J8CGXowrFSAU+UhgBn9WqYhbZUPc4vCnKK6+sN9hMx267Bv+vmfFc
         Acwn8COWV4bIkrkqRtQapfNuFEam9TTWohsJAyQCG9p/K2RFC1Rc33kmL8hrsZzxmcNO
         uZB0d+Vw9kjsrRk2bZ3C69OTfkQybxDntM6sYgEeFRriBrfnAPLfZ020rkRZf9ppHxvp
         LB2aM4cXD44t5Bl+UbDuNick0yjpe0pKv55hM0TSraZ+9zePugujNqC3x6oNNUXz76Hm
         E7CA==
X-Forwarded-Encrypted: i=1; AJvYcCU8HupOJFZiy3TzH8Yn3LIgixJM458mSIyZSNoK9MLDMv4+dYFDre1peg91AIXVlWn182waYdWoVA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyzvxFxdkeImA5SSRMUM/isoTCCrv39nWjCxrQH185hE0891IIN
	/yUXYdvdefNpmhMpiIY5uR5m8oIguPuJ0S5lB1JjQd+J/T7YvpI/Jy9+3nXu212UePkgCRAjzdk
	xF4NAhErEfq5fcbPKRZLNzKhFJmD2AwM/608/axvaWawIWt2H/qgq4Qh6VYbO
X-Gm-Gg: AY/fxX7bNSAc/3aAqm6/iLhaJbW+tL3c4Wzab5jW5B3s31DdfVSjGmXLd9tjPimicJl
	RaCFXlKPzr5OpR6h6CFA9uSo2fZJjlerz9o/sgwmZale8HV/+mwhdn2wrjss/A3qQnM7bavE44K
	MbECxI9cUogzUHtsPwJPTLRvIcLrOn4jsHmfa3J0nARLje9Rw2l1fh5lKnnhWIkg6TuGqA911CH
	C83ITTZwUBO7jls+wiPTCn0eAM0J0zwj0Mn3PxtMnPUie3qIfjtn/GtcDae8CsmDj9Di6BL5xT1
	bZCBat4Xx7XH4PNpjatX57X6w7W99R5W47KjKhIiyyFICywkzqElumXm3go3F3B/9W7rRH8PfRu
	rLOTniQV8SYHXz3zuK7vfOG8Ma32p3u741+RSp7Jki+Nq/J/0EjMFghFBww==
X-Received: by 2002:a05:622a:351:b0:4eb:a4fc:6095 with SMTP id d75a77b69052e-4ffb4a29b23mr7065691cf.68.1767739457616;
        Tue, 06 Jan 2026 14:44:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFRfJXac6gimfVw8WekwKPXpdxGtLKbITUtgdjZT8fmoQ+tN7E7EiEHkEoBIIEhgpHFvHJv8A==
X-Received: by 2002:a05:622a:351:b0:4eb:a4fc:6095 with SMTP id d75a77b69052e-4ffb4a29b23mr7065491cf.68.1767739457221;
        Tue, 06 Jan 2026 14:44:17 -0800 (PST)
Received: from ?IPV6:2600:4040:5308:eb00:a77e:fec5:d269:f23e? ([2600:4040:5308:eb00:a77e:fec5:d269:f23e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89077267b9esm23141466d6.48.2026.01.06.14.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 14:44:16 -0800 (PST)
Message-ID: <13e4593c-c061-40cb-a0e8-78764488ca67@redhat.com>
Date: Tue, 6 Jan 2026 17:44:15 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/md/dm-vdo/data-vio.h: adjust function name
 reference
To: Julia Lawall <Julia.Lawall@inria.fr>
Cc: yunbolyu@smu.edu.sg, kexinsun@smail.nju.edu.cn, ratnadiraw@smu.edu.sg,
 xutong.ma@inria.fr, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251230152227.97578-1-Julia.Lawall@inria.fr>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20251230152227.97578-1-Julia.Lawall@inria.fr>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rcexsQC2suBj2lQ16_Ni3S0uUjsci6yeJo0w4f_SfZE_1767739457
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/30/25 10:22 AM, Julia Lawall wrote:
> There is no function advance_compression_stage().  But
> advance_data_vio_compression_stage() does iterate through
> the values of the data_vio_compression_stage enum, so it
> seems to be what was intended.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

We must have missed this comment when we were renaming functions a few 
years ago.

Reviewed-by: Matthew Sakai <msakai@redhat.com>

> ---
>   drivers/md/dm-vdo/data-vio.h |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-vdo/data-vio.h b/drivers/md/dm-vdo/data-vio.h
> index 067b983bb291..58a1ac806885 100644
> --- a/drivers/md/dm-vdo/data-vio.h
> +++ b/drivers/md/dm-vdo/data-vio.h
> @@ -88,8 +88,8 @@ struct zoned_pbn {
>   };
>   
>   /*
> - * Where a data_vio is on the compression path; advance_compression_stage() depends on the order of
> - * this enum.
> + * Where a data_vio is on the compression path; advance_data_vio_compression_stage()
> + * depends on the order of this enum.
>    */
>   enum data_vio_compression_stage {
>   	/* A data_vio which has not yet entered the compression path */
> 

