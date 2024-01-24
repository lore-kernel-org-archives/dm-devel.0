Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0129113175F
	for <dm-devel@lists.linux.dev>; Wed, 24 Jan 2024 19:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706123145; cv=none; b=b2tqo1dGfMHfaQdgDbUJopRy7ZpKQS11lYM6nloqKu4i6e8v+4UpE88rFXjLb2sEMIx+B3Ltux+gsXod0QEnHmeZmvaOV4X6k7BwLykPDbMYUOCHVR0IEGncntqoR4tkMImX4ExT4wDtd32H/rvXiERCqrGD6qSnteq+nyQEFUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706123145; c=relaxed/simple;
	bh=pTtp92qCGvPYravaL+YYgJf3V63dnVeUgocRgZoJNkM=;
	h=Content-Type:From:Mime-Version:Date:Message-Id:To; b=KFeHYgSEONMalVcGqdN4as+lFubTNo36+vQJF8ydrcExGC5ivNKJhThjXSbfuQ1rPpHGVB+5lCyy7ow257JjiwjAEb3PavEx7oD1HkURaH6UTSNEG00OI/KSn/sKwEEvCxXCYSWhOu0qUCMRLzHWsxLLtCxYaDEtnRUIV5ayCSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RGsvKPos; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RGsvKPos"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-68192840641so25079896d6.1
        for <dm-devel@lists.linux.dev>; Wed, 24 Jan 2024 11:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706123143; x=1706727943; darn=lists.linux.dev;
        h=to:message-id:date:mime-version:from:content-transfer-encoding:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ORBc/fxSASPD7gQcyVkV1dzKlx4O/lvsxtuIgVAPYL0=;
        b=RGsvKPosINL2oYxLN6iJQDmXkZQnADkfz+J2cpijQn9sEl8H1H+5nmgjgtnq7WUErV
         iV9HCE+MK+M3s9gPDjUf3WOCuzvVUajyJksAnQEL4xq3jfWgwaRP9tph+ITUiWq5Kryq
         IkD9euKWpEAUYezH+bDRVF6TIkUAHNGNSdsp4XEganIDwF8UgcZoEq8t6JOJbg7tdgUz
         ey0+ATnzmtCAB257x1gpmEwosM+CbVMgMRR+n2WzOw7oRLnWxVPxKd6XoHrqnaCrlpU2
         0JnEsDDdV/11IKgN/WrFbkzoTMysTyLcbe7ceG7MPuR2iz+9lO7t287jYP3nry5zV7yX
         rq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706123143; x=1706727943;
        h=to:message-id:date:mime-version:from:content-transfer-encoding
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ORBc/fxSASPD7gQcyVkV1dzKlx4O/lvsxtuIgVAPYL0=;
        b=nV1HO0MkEZV+laLlN74syzbmD9wCTTWeQM1CNMqqlbnxwjW5fnh63F7XgMQ2SN2psD
         RxY0SK6P67jaVS5wQOvw1PeH0fyUs6A2uOWBXTtgDx4ufbUUm0hyjL9tS7MqYkTVnoKP
         kppai6X0aWIQXX/ER2YfaFOudNHHziD3q+FQEwJCuIavtU77AHZlU+Ayn5XjTzb3U5hR
         CbU8ZAyZ3QfbPPtPedcSHWgHsRDcBA7MUth9pHTC9OHT1Mh8TvMiSt+/dAW+ABlD9wHX
         8IO7SlMEkB0GuuIdyJZ56meolc0Iy/Hfm9PIDRYeVwriAFXg1csPxcQteHaNmtvRbuzb
         fwSQ==
X-Gm-Message-State: AOJu0YzsUU9VSgl4x4hG/0wXMvfsIAolPwlqpNBKXqef0e4JyF4NCJSj
	b07AclSTdCkc0JILTYOQytNzf/CPn3Fimf+DzaMpy7QDjNUgC4bb0AG9IaNKJus=
X-Google-Smtp-Source: AGHT+IHB30JI3gYQYghqDRg6om0ddXJwH4MVuKkXBRBZUHbN7h249K6yL3UttqAn1BXooBd+vxrUeQ==
X-Received: by 2002:ad4:5c6e:0:b0:67f:85ff:3dfd with SMTP id i14-20020ad45c6e000000b0067f85ff3dfdmr2473030qvh.82.1706123142590;
        Wed, 24 Jan 2024 11:05:42 -0800 (PST)
Received: from smtpclient.apple (2603-7080-880d-3a4e-1147-da66-ae24-a5aa.res6.spectrum.com. [2603:7080:880d:3a4e:1147:da66:ae24:a5aa])
        by smtp.gmail.com with ESMTPSA id x11-20020a0ce78b000000b00680d39626fcsm4723797qvn.47.2024.01.24.11.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 11:05:42 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Kathryn Warren <cococataffo@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (1.0)
Date: Wed, 24 Jan 2024 14:05:11 -0500
Message-Id: <12E5FB5F-597F-4401-8BE0-52E4B41B0FE9@gmail.com>
To: dm-devel@lists.linux.dev
X-Mailer: iPhone Mail (20G81)

Return path 

Sent from my iPhone
