Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA3F12CDB6
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716563395; cv=none; b=AucZC4dNd//RpMPUez/DUlmU4jOcaOjfkV+l7t+3qgcHN76Ns7Gzl9FuT6FoO06z7qgBF7pwHOWD0+XBJiRuDvHAuqntxnFaFKBz36pJm3NCT2d+bcXEL/WGXAKg97HcWNAtTG13NiiYjQDFdJlLPos8ZyVcIPuPk3iep43Q9fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716563395; c=relaxed/simple;
	bh=zxVEMgI09UQfjFM1R4pyiHL6OkU1AyAqLPk40WkZOmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhpKX1auiHvRof8XS36WgzPV70Bku3IsHyMJyiS2mN7HvjXItjXLhecV8Ng1/Ej9QJkAUMaacFuqCXz2VdGh4S9pe2QxRmgNMM6DRlnOxTI4ViwIJFNTgkB6O+q3t8JedMImrzZumDkvbwcG7yuJCrZWe2N+NKV5FR2WgNQV+pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-43fb0f2daadso4520351cf.3
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:09:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716563393; x=1717168193;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rdkc0qj1QfAURfQU2OpxmXvtxGpBJsgq5A22WLnsFyg=;
        b=Ws3lofUebzGCGFCn0c5eOR6R+my2ieUO9u7RKNlIVQuiJduwDkA37UT4ZLW6EUFrRW
         lhW7zrJgFh1p8LT7IXuAWROzHwWOH4/XStOsZt65hKlOUHYCL1vR6e2I9chF31Xr1Qdw
         t0MtTuFt/elclSnH7KWLoEOvbqpOSfP2bPqCyF2jVAHNgIIoVFV2YiSLd/PBfx5/la4w
         FCDzNQkQrj33ZTYkkaMkqYxUswB+2jAb+PjJ8EhBINDftT32CwW+9W86P3r0oTG2k87O
         dgxLV7IBcDfYLDPGMvGvUmJXSUzi87EDkv6uNcHLoeJGtxWMpj1PnDZMtMQ/oS0Lyn4y
         jpCw==
X-Forwarded-Encrypted: i=1; AJvYcCU9VCPNEJADUpfo9xsJgqRPyBYrBV1wfRYQUNUBWRFrGB0ut/OYVGku9z1dOK52spngEtEZOJecSxGKUCXua8JXJF81DGGUnAQ=
X-Gm-Message-State: AOJu0Yy4DaJt1nlb+VBIewPxztc4lXBI6S8A/w9FN3e15WNC1K6odsx1
	cR6gJRqiXvWx4OAu5MFKEb23j64Zn4wHNpnxgb2cSrxX71jlpv3NLwFqe04i4ukYSs62ktx/DEX
	39gkaug==
X-Google-Smtp-Source: AGHT+IGLHO9oq7tqKD8/icYnVkNsh8ZMUBaSthC9tqQqno2sMecPNHiz/kQgN/zX6NReNQhJM0Umfw==
X-Received: by 2002:ac8:7f91:0:b0:43a:b2a0:6e01 with SMTP id d75a77b69052e-43fb0de1a2amr29718201cf.21.1716563393278;
        Fri, 24 May 2024 08:09:53 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43fb18c3f46sm8650681cf.85.2024.05.24.08.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:09:52 -0700 (PDT)
Date: Fri, 24 May 2024 11:09:51 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/3] dm: remove dm_check_zoned
Message-ID: <ZlCtv8Z0_D2pLW80@kernel.org>
References: <20240524142929.817565-1-hch@lst.de>
 <20240524142929.817565-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524142929.817565-3-hch@lst.de>

On Fri, May 24, 2024 at 04:29:10PM +0200, Christoph Hellwig wrote:
> Fold it into the only caller in preparation to changes in the
> queue limits setup.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
