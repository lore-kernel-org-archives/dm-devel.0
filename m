Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FF1201116
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 15:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730907665; cv=none; b=RBJeP/dW+4fJXHB4A/0buBDs18T4c8VhrCTOp1gWToMtEXbcNL7ksGIjEuZRre7LFyTsD3n4KyI3J/C8Ynxhd8bHD0mXs5Q4Ptbo4oVxizM+d19IbjEvCJ141BhL4vXhxka6JPsLokDas2T+ZFfpjCL5Lp4HueGMhU55Zwwdpng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730907665; c=relaxed/simple;
	bh=NrwUEWnO0zhhmIrodOXpGpMFu/m9s+jOZRSkSqek0rA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B9Z44cpAWbEYURldba2i7HmxnTPS5+Yr1OCK0Z6RzuYuqdGR6U99qo6r5QdNNsuyLPouqyV7wyTdFPBBfl2LQjuEoeKtP+8I9XF8nuUAOI2bdH+d33HcAM2E8sa09vu6pba6NQLXpgmrn1ckEK7Gm5UYLnI4TkbObaf8gskF+g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HF0w/0hZ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HF0w/0hZ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5ceb75f9631so7397770a12.0
        for <dm-devel@lists.linux.dev>; Wed, 06 Nov 2024 07:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730907661; x=1731512461; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NrwUEWnO0zhhmIrodOXpGpMFu/m9s+jOZRSkSqek0rA=;
        b=HF0w/0hZxOHfZlO13d9yKT2gUtMdz6Qb2IcpIwAgcASwh7Pfd/wAoB93aetRXmnVLn
         BWCd8ErGaU2FVJpA+IFHqyhP1XB8Pb28TzHLurwpO446DLJGx8OtQlY3S2U50dXD9DIF
         4cNMuuMZWOQkYkyDsMoXkY9iqcB949wePZXyoMAtj3WA6ZcTHj9vPrUIIDSX+XHM/MIx
         DG8k/gf1aUHKeIT1nQGBy/xUhJVMo3h0Lv7eCyllyQNsT6v9jvtfUOh8nsZHC3yjkxYz
         NDgQHP2Nuuyl3ly9+c7zvxPv8SY8S2NmykvogKZBRanm4cazKqK7IkEZVDnyVdMwtUzH
         5raA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730907661; x=1731512461;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NrwUEWnO0zhhmIrodOXpGpMFu/m9s+jOZRSkSqek0rA=;
        b=cV8RPipa6Ua9iYf0mJsQCZGl4KW/Nm4OZ3kwT/wuGiPNioMVpCk/EyYLLgJpiXs8mZ
         kg+MKGGI7pUwDFVEGUsvWrfj3pwL3S1t3UIE55ykvzVFFWuosm/Abt4Po/eR+VYqXCJA
         p2i6aPZxhjgGcf7FVIJ4UC35NxTvNhy8XM83KXeYT0I9yE1LIWcld7fvNMXZKNGH1eJ/
         uHXHqtXAcotE5LeDJtzMKQ6GFumxU1VnopzxmSBPnEY+HFUNty82OuNURDLW0zzg2mAu
         Ecj9x+NVRcvtpB7ZuIzWRLek93YSGwerKDO9LpTgxdqiD+BGgs905Oc75J0df5FQSz17
         juhw==
X-Gm-Message-State: AOJu0YyaWpf3XPPU/aihSfvwBHmLNbwZGR7+NYA5OJvd9wiyoElFoi4t
	un9dOOn96LBJhJcJjDHOUmB6vSvh/EekdHAYZvEOhGiegYaz6OWo+h/NxexzGHqtzrzvYo5GNWL
	T
X-Google-Smtp-Source: AGHT+IGEVurJf266AaYlR2jspV9J642kYYJqLMJoO6kKrQLq/fCWI3oAaBd5rNT4qI+RBqMDrd1Z/g==
X-Received: by 2002:a17:907:6d0d:b0:a9a:147d:fe9c with SMTP id a640c23a62f3a-a9de61d5d59mr4181668666b.43.1730907660470;
        Wed, 06 Nov 2024 07:41:00 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb17f9806sm296383466b.157.2024.11.06.07.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 07:41:00 -0800 (PST)
Message-ID: <2155d4f779ec35ff9c9915ab8fc6408e59402ee3.camel@suse.com>
Subject: Re: [PATCH v2] multipathd: use timestamps to tell when the directio
 checker timed out
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 06 Nov 2024 16:40:59 +0100
In-Reply-To: <20241105025739.450449-1-bmarzins@redhat.com>
References: <20241105025739.450449-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-11-04 at 21:57 -0500, Benjamin Marzinski wrote:
> Instead of counting the number of times the path checker has been
> called and treating that as the number of seconds that have passed,
> calculate the actual timestamp when the checker will time out, and
> check that instead.
>=20
> Suggested-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

