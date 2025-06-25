Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF7202987
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 12:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750853551; cv=none; b=u9uhJ6guVr8N8h/CGL3OxGMoGy0wjz8TaHjP0rWh4LemSktB60x+R4Bz5B0KWdqO8So5YilrX+cfoeFSGVs9en1LZ8qqSvyLD/7JaftREptTUkjopMmhBR0BQ7NoEPG2/QyFpYhlCsmbuddl0XKcOfzfZMWbqBIWdO+3nkd5kZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750853551; c=relaxed/simple;
	bh=GaGCVNnrs049twokdApTJpYwHf0SAp2qsLwoXn4B0aQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZ6aCoZdUQCaDcBdH/B5V0maQczXcPRGPgbt49/XwjclXXCksucabv23Li2NeYDg47ooZyUo4gHIYfws+9Pa2TyWwiUJAHkyNI7y58NSbRmTv0pKX937lHf/mFFfs0l75VCDUE+gEa5M36jrcPZ68oGZwcL9IJUiVdYlfPKmk18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ZMSLbLku; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ZMSLbLku"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-234f17910d8so16010945ad.3
        for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 05:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750853549; x=1751458349; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ANo+Owi2IwINUCllKBT2m+pMoITuQHrikto8dDxBvQE=;
        b=ZMSLbLku/JsLemtse2UwNbxCc/qjptaerFvFXgWgbrX9OfWeuXkTRa1GRiZQ8OTWti
         9aGxGdJ2+8xzxw2x8jYvWsEbp3zvsDKezFNqsD38F4kcsYu92vlgorEoFPk9ZjSq2rSC
         /GVstbtplBUiINS/nExEqXGnrPgk/PTWK/4DGIn0Tll3tWKcQdwliGeVMx7KsxQXyYYN
         uDGk/L42IMH3wBJt0OtRfsVMKCP6egYEJnrE9sM7GI5QGhiDfBj/N7ut08Uj8rZO/Lpi
         HmxaUl0suwgOSaQc2pYkThhAd21w07FxQpzXtBfQz//BqbN/cVTcaV8VtymduDHo7oNB
         /lzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750853549; x=1751458349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANo+Owi2IwINUCllKBT2m+pMoITuQHrikto8dDxBvQE=;
        b=QS2BoECWugNZuk2s9E0dLhzVnWxLZjiJ89080BA5bE7XO57/BFN4+hUR7Z/nTvhmYX
         aPP46/lEP/fDokxU1f7eDymM4GTxbgLc2MdPNg68+qwRztJkoFWWRDqWYKfJjq4VZPTe
         AKS7WIGxfTsxfSGWkPuBQcAoR0zMP9yy+mUVFzPoE+jSggwDYD7oq+zSIBa8HCZ7EiwN
         fap7+nFjtBPNCyVh1yVhXsfjIKzUl7KPwh7VFn0Lch7z75dcviETVweQl5cc07cjYink
         j+j6Rvpr2lpWNqxYDcYAdAL8O5esA/SiXO2g5G9T2NcgRV6Ztjs9RtaAHguPaISnFwD2
         0e/w==
X-Forwarded-Encrypted: i=1; AJvYcCXujYrhLQdXzhJe6sTcdlt3uW8oB1Q4CHyiBnZCCSYBkVIHy7GU4UGGKnLjKDhrXAlvNFdxuCQOZA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzL9QX5JA/dE52MqVCBLa4BTHZdZAWD4xKYKkk+TT5yR1PqPdNg
	NupqUDJW6XI3qdtPzKeQGyEJp5B+QJ0EWb8U/9Ba1qjF/qsNciJzWwKmFe/DoK//Yl0=
X-Gm-Gg: ASbGncsW8kn97dbM5asz3xipXifFKfKUTcAUaM/9s5BnAJDriS6Eszri/7ohkrNYOE0
	Iu1xZ3tKXBImzOgM+1wFwSoxLZyT5HTv29FbnxgsLY/vfGfJ/TjIezMMMli1RTtmoJoB8J50vXk
	KGP9Av85/xRCAEuOjal2K6Ob72koAj9yS95OaYNwtx1ueWX5TDzDiFAhPAM7OTw2TqD37eGSjRO
	X5rUYbdC4pU1iepHqYnRgMoGBC7D6YS36EdhOPSjg35any8Rfp8y/C556zx3HAE9SkyQTFYNIh2
	LKmia0gk7Z3GM45bMHuT0F+RHWSmJrugYn8o3jM156c7HUnU7ASExTvcBenqDlJgGtvkGdJpyrf
	j49eHOTGE2xp4gOLWgoUnCtsEmGp6JDsZnhgKk5PDVCfe4Ypp
X-Google-Smtp-Source: AGHT+IFsWudnfojrg6arN08dw23V0B/7VU39ASGj4uWkOJeXH09JGPtPTIbodbPCaiNIWH5xF0rUTw==
X-Received: by 2002:a17:903:32c7:b0:234:bfcb:5c21 with SMTP id d9443c01a7336-238240f42bbmr51536505ad.19.1750853549402;
        Wed, 25 Jun 2025 05:12:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d83eefc9sm132360405ad.74.2025.06.25.05.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 05:12:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uUOzJ-0000000340m-3yC6;
	Wed, 25 Jun 2025 22:12:25 +1000
Date: Wed, 25 Jun 2025 22:12:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [WARN 6.16-rc3] warning in bdev_count_inflight()
Message-ID: <aFvnqZEHCkikG6xM@dread.disaster.area>
References: <aFuypjqCXo9-5_En@dread.disaster.area>
 <aFvdRm4Ec8Oi3uBT@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFvdRm4Ec8Oi3uBT@infradead.org>

On Wed, Jun 25, 2025 at 04:28:06AM -0700, Christoph Hellwig wrote:
> There's a test patch for this on the list:
> 
> https://lore.kernel.org/linux-block/aFtUXy-lct0WxY2w@mozart.vkv.me/T/#t

Ok, so when is this planned to be fixed? I've hit this at least a
dozen times in the past hour with check-parallel - it's causing
significant problems because random tests see this trace in dmesg
output and fail, even though the tests themselves have passed....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
