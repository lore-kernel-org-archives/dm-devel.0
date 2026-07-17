Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7C73ED5B9
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 11:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287676; cv=none; b=LMwv2l7RAGCOfERRUuAIfn8maOIT4dxQGwDo68yWV737mNRuVIXWqyHhTXRJC9Vz0GSNwPGJx3RpllTvr918NQCfVMYHFofnkMZ9ulTAhx1gkLIQrqRTiPKQBarXjbCetAUjIOVzCYnPqyUuNmm4DEGerLk/gWrX8vjeMXsYwME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287676; c=relaxed/simple;
	bh=7XeQZ2DudffJlBCXiZrwWLm4246uihdAwNor/6AUg1s=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:From:
	 In-Reply-To:Content-Type; b=mNv5cTSzZztYeTlcn9mjlYHW9b6Ch3aCvlTh4tNyzwRNiTPyoRUgdaACCMTWGW0euJ/JCKbxUsX4GfDraWNRERVtf+mjq0CbqxiRvSmESwldv6ff38oqprKxsUsZaMpiI42u2P5BvJ6lzfjpMEDIh9U/TQpqxZfEsWTM8ZjIrTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UnUm1daG; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UnUm1daG"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-472c021a608so823551f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 04:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784287664; x=1784892464; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:subject:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y8C74k/RrBiNpLFnzsZ/yYJeJv0nx8FBD5PSz+38fPc=;
        b=UnUm1daGeCSN0iMRZpf9AskxhnkkYRnWONNVlbTOpfH+wfw976FrdrbbSjG5t8qCkL
         jpTATe1+VgKpnLKPUd8iWppdphXF6YeAQgbB/LeR9zsfRlZK2gtes+8EzsgqRPdvx6qF
         HmKR3gsv874ltJcgOLQz5WsM2DMK6U5kRG3ABKnaZwakZn4qAN2t+wp7SRF+FZolGgur
         //X01RaSOhULW34Q5/37ThptIh4PfVUe7PYiNk3cAAsuPXIyn2kXKKFBbq2GAerx2rvv
         I8qwgcRhoiAxx3YNM4vmZqS8CzJmzpGkMXjlyAtTGqOa3hYEfqag60jWbvZTloNW6F9C
         YyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784287664; x=1784892464;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:subject:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Y8C74k/RrBiNpLFnzsZ/yYJeJv0nx8FBD5PSz+38fPc=;
        b=hOmsk1MjDtLxaywG0GBXeR3ewtm6TzCqxItgxW8WPJgZYJVg51kxGNV3vYisye0zYs
         MAMQB4+l/Z3nIkmed5RCttj9Jcuy6OEstb5egeYruZmSu2QMRakvXn3Uiu/dJXFUBXyk
         Sz7yeg27PQcMu9AmRtkoRA2o0crlROuA5kIX4T50A5qpzHlgYCQJeowxp8JJFERj1axt
         yLqc6lKKFpTItFMM27jrEMRT/jpCJwIARlLhSBMt4kygmQTkAb7caWo54Fy/TfAqN9ym
         YryOuStjhTOEnrRtGwvZo8I0jiudJTGzznDFW3WiV6Ma5Stx8jGEJcZr00GgYMci6QFF
         9Fog==
X-Forwarded-Encrypted: i=1; AHgh+Rr78zw7WGVo8IOM2BSETLmfqaK7hypcgWhlFuRwDsmGH7eoq2DxpNjCu/JK4WB8mZvLmOUdn5pE2A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2hpCcIIYqrHyUcaa8hjMasN5mtLDCrDUb9viPbibf+MTbDOOW
	Tdyg5ze8I8SnycRToXyE10m3O+Ver7K0VnK/qcgJrJTHqG6igWE4PRo=
X-Gm-Gg: AfdE7ck4Fjq9cKuABVPFjMP32tMPtUNSyLqcCWWIWmj5ypCJjyDtbWgkWmLMq3bsXXJ
	gpp09rOlK50iqEkTftYfuNR38HYml0DCcKtT5/giJWFpptuA/orwP7gkREBNSHaqKo0T8LFpZ9U
	Ta5Vm0XTaUy3l3rPYd1s2G26satjyT7W8FSvzhhbl9mj2gW88MrozUax2uKgMEB5OdV/armxDNS
	83+7XWPUjGVtEE0GDTplTEFX4nXEEf2Grdh3uE6LStcIqW7y/qD5Xx6tv20l+TyBEKpUQcAqheK
	1nJezmKCSFAMG2SObgGNhziVe2MOnPHnrTgXpo+P4/YU1GUTSYGXguddBHqhigPfEPl+h91px+N
	y4yUwLdHfOe+Mb1Nn0hM7U5P9AOreqRfSP8mp4tMEcY3bpXhVU1ynx39GwAXmNch2cYM6OolU0x
	vpw1Jn2Do9thQdauQFMyW6TvvSGq9aUcreWQiC
X-Received: by 2002:a05:6000:310c:b0:472:55a:ef95 with SMTP id ffacd0b85a97d-47f622f24b4mr1840986f8f.2.1784287663504;
        Fri, 17 Jul 2026 04:27:43 -0700 (PDT)
Received: from localhost (3.red-80-39-57.staticip.rima-tde.net. [80.39.57.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e52673sm3373979f8f.15.2026.07.17.04.27.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 04:27:41 -0700 (PDT)
Message-ID: <d273e9ae-4a32-42cd-b204-a61a6f030bef@gmail.com>
Date: Fri, 17 Jul 2026 13:27:40 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH tip] multipath-tools: iet prio; update header comments and
 style
Cc: Arnaldo Viegas de Lima <arnaldo@viegasdelima.com>,
 Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20260717111512.63662-1-xose.vazquez@gmail.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20260717111512.63662-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/26 1:15 PM, Xose Vazquez Perez wrote:

> Update the header comment to accurately reflect that the device IP is now
> obtained from udev's ID_PATH property.
> Additionally, move the header comment block to the top of the file, remove
> redundant empty comments, and convert style to c++.
> 
> Cc: Arnaldo Viegas de Lima <arnaldo@viegasdelima.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>   libmultipath/prioritizers/iet.c | 65 +++++++++++++--------------------
>   1 file changed, 26 insertions(+), 39 deletions(-)

TODO: update multipath/multipath.conf.5.in
