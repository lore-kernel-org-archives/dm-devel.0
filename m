Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313E81DBB13
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 22:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730932784; cv=none; b=bVsRKx8TCxMkKMLtUDEzuso4bZf8F2wtvYbxDCXH9kmYYOv9EPqHcu7xejQ2iHGReZkWQVlZGCXiCPr+p72+76CtR1hjG1fT1TLCOH3ayuxsqHCogoz9h6+5QIcndO8Oe7klO3cRvTpAnYftIyPDwr7pMydlc96PIXavm7X1e8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730932784; c=relaxed/simple;
	bh=eyPNhXYxX5XFgGDZrensIhr661psg4ZuBTgZibVuu1w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WtA9if5O66Nk86LUBS7If8fFhON9vq1vwBvIFJXSqzp+CxPo74EqRLly8PmVc2V/HVvDlAxlgfvrP+FXwiTQtuBO4GX+JkF+ZEfXd3VB/RY5g3z5rnicLAdm/PPMPZTd6xovAuw+jWD6xvXdTQb1b3Hd2m18pnY6b3QtljcuwlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U4CTQQm7; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U4CTQQm7"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5c937b5169cso639324a12.1
        for <dm-devel@lists.linux.dev>; Wed, 06 Nov 2024 14:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730932780; x=1731537580; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eyPNhXYxX5XFgGDZrensIhr661psg4ZuBTgZibVuu1w=;
        b=U4CTQQm7E7awyZsCzyWx5EmxXPVCRpqipOcLlpHpcL2nXEUwvJ6offBa1U36O6ihu7
         GIkMJocFomrX7mQOjSGp1zCuZlYS63TcCmPlZaRJZwyEkR8YJMm57IIU1TL2RsuYVowC
         HHdEJJ7P0f7xS7LqCVGeviFDkpzmw6MpeEy61zTbH63N/4DGOxXyI9FdWjPGDAM19L2o
         9/FDAMyWpWKg/PUC1AEHyLHWW4Ca9rzuV/H+U7qggQP9mJlRDs/H3per998ycdFRbqSS
         gRu6ot80GfDLoxQoUxTVVpaxrQYX7pJkz59jXipwdHJithdG5mINJgVZJcg0GXzvPJkL
         rxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730932780; x=1731537580;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eyPNhXYxX5XFgGDZrensIhr661psg4ZuBTgZibVuu1w=;
        b=XaJ9UmnU8HyGFeXLb/4hZOgFLYIoGQ2tCAgNQfNEfrcxiqncB2TFzC1V9667RcCQcV
         NUd1li1tjH8PeujXys+UezmbQYDzSY5PpgPSzpdVsR0SKtIIyuG1IYBdJHXuflbhnBg0
         oS2avzc8bagKSIbTlOd6/4Z/cWzqAlZBdsqkRPTbQSfZyJILlIDuB6kS6ABFgjpASlie
         hrcsvT4gTTf2rvf0XJkrVnPD+Nap1CIOB2LBjb1bTslOzOcavFPjyKR959zsqS48X68M
         FYO2/8tDpIf8yTrSoc6dHLgrdpOsI2ES54xkIaHMCfiv4N1mrRKjV4hSXok/9TQxx/8R
         M/ow==
X-Gm-Message-State: AOJu0YyU3oZWG2L1gpKK6Jehuo2jiI70rFN5FyuUXjidV33nm69W+pDq
	mJVoPwLkgs7IoEH7XaLrelifCHxmZ8pzoT8VXha1InaM27HyY/hnTCqtwSF/OMD6R+9vOn/pecm
	Z
X-Google-Smtp-Source: AGHT+IEE4rLH9XAWfWKFohxs8kBRxXmNZPd4i0iuqxBg+4xHLzcmcYJJEarRjgBIcUohVDrpMBU2bQ==
X-Received: by 2002:a50:9b59:0:b0:5ce:c7b1:e052 with SMTP id 4fb4d7f45d1cf-5cefc7e09cemr600827a12.9.1730932780170;
        Wed, 06 Nov 2024 14:39:40 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf03b5d76esm2678a12.9.2024.11.06.14.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 14:39:39 -0800 (PST)
Message-ID: <ebbf8fe4ef7500d2ab1e6f73a041b8b0ba75e4a4.camel@suse.com>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 06 Nov 2024 23:39:38 +0100
In-Reply-To: <151dbbdc7bfcd4dd0668bf5d9289f725cf92da28.camel@suse.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
	 <151dbbdc7bfcd4dd0668bf5d9289f725cf92da28.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-11-06 at 17:52 +0100, Martin Wilck wrote:
>=20
> For patch 1-6 of this series:=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>

The series breaks some unit tests. I can fix that.

Martin



