Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F69F28399
	for <dm-devel@lists.linux.dev>; Wed,  7 Aug 2024 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040029; cv=none; b=Sbt1lOzZ+a9uD4T5fOHEqLpPz/sqrtgjlxDu5kdxzUWWyXiNx2G0wKcqszeijXTD3xugpDgDskuyt7EJw6oBSYjzfJBLqk8/qMl6m96bMxdhBbZuaPMKM0uq4U/NDh6ilXF1sq8FkskCf9Apj7SHp9HZLRD/1Cva47VS488S7fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040029; c=relaxed/simple;
	bh=4h3P/21+jGF1Wrn+hHA8d1xVRbX2E2+j9b03qumh0WA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gMIoWlCzzZpHYGAIoq9Z4KVd15BINru+Bu15SfBX1LLoEq8pDljaf9HLb5msbe9p9i09bUgTiqmRU6r20qNHx3wEsXg1NbVx6bqe8ShlqmimmYTPPizQ1tmiW4GS79y++bAHUjg1t/QuvMd/DDun+Iuptr/+eoLXdGyrVmcscxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ipzn69vp; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ipzn69vp"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-530d0882370so1865845e87.3
        for <dm-devel@lists.linux.dev>; Wed, 07 Aug 2024 07:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723040025; x=1723644825; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4h3P/21+jGF1Wrn+hHA8d1xVRbX2E2+j9b03qumh0WA=;
        b=Ipzn69vpIpcr18oqVGipVxKxUftrGIJQZkKcatsE/Owm4TXfhWMIF/lfQTeVWKBp1R
         1pdj4w+qy/i7E9+UOpzMswTessELzKjjvJZfptcLenxVb80bdHaZAhZGSX+py5Fg7bLp
         gF3KiU4ciTvoPKc5xUzSD5SiBHLUncI/DAsD0hnrNm6/ppLJM58O8lMgbUC95CDY4fyU
         nBmu2giFHHxBZRyrebar0wG7G6m4iqh0zo2P0c85fRJdpB4Wbx4FpyhM1PMU/a/HdGHE
         DLl4z+AF1kRh8+ZYbru0WdfF84J0wzqEGAWNsETt3Kddy+wRKQb7jnYB1ze2jZaptNFx
         DEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723040025; x=1723644825;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4h3P/21+jGF1Wrn+hHA8d1xVRbX2E2+j9b03qumh0WA=;
        b=pjM6oH0XMs4uWHw3Ki6KgP6ens0mUsFac4cJHDcWJi7KE+asxdx2fcwztEuAiNkl16
         nyGj3184Ks+CFSGQPyqZYLqaHwY6sqrBoktrN7BSKDUTIB3GNw0hyQy0Mc8cp9+x5Z2e
         fIrpnJkLQOm7AUfcLKsPibeywhKysqIewPUIt0Itoj/gVwaPL2Ueomx5q+I6/QfOQOa9
         chKuRzRm/Co2HFOa42RikrrXsKeAHU4MGh6wov4QLhEczLQxCsAerUvnROTxrtIRoGgN
         DKvZqpFHPBo5UZB4bJeOk7rQPNL3YdHIf0GkgANof30spu8FUZ6HkLfDhR/Lh5Lu5zuO
         8njQ==
X-Gm-Message-State: AOJu0Yxs1b2f6e7djC+jRyrSA9PDtd/7vxgPiAKmRIcLCvQOr2Qnv1EF
	4gPe/RyCVznmV+AKXQ5bZicq/iXRwM2O9gWUWBZoyKW5Hs6GR0AZePteyNue8nU=
X-Google-Smtp-Source: AGHT+IFIS7DfJLgfEIEL9cwxMT3Ew9DcF9i6HTOI4A4nipznsPj8yWg8cHEWwSqAarznYdHvU14TwA==
X-Received: by 2002:a05:6512:ea4:b0:530:ae22:a6ea with SMTP id 2adb3069b0e04-530bb39b006mr14553853e87.40.1723040024635;
        Wed, 07 Aug 2024 07:13:44 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5b83b92b970sm7114003a12.72.2024.08.07.07.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 07:13:44 -0700 (PDT)
Message-ID: <a4e0816c234a574894643e6cd78a8e27756e91c6.camel@suse.com>
Subject: Re: [PATCH] multipathd: show pending reconfigs in 'show daemon'
 output
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 07 Aug 2024 16:13:43 +0200
In-Reply-To: <20240806225441.3227895-1-bmarzins@redhat.com>
References: <20240806225441.3227895-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-08-06 at 18:54 -0400, Benjamin Marzinski wrote:
> Since the "multipathd reconfigure" command simply schedules a
> reconfigure, and doesn't wait until it has occurred, it would be nice
> to
> be able to query multipathd to see if the reconfigure has completed.
> "multipathd show daemon" doesn't work for this. The reconfigure could
> be
> delayed, and the output gives no indication that there is a pending
> reconfigure.
>=20
> Change the ouput to add " (pending reconfigure)" if a reconfigure is
> pending.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

