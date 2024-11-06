Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288801E0480
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 14:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730905157; cv=none; b=KIvNMRRKAJaZmc+0+3a6XhE4sqDFS/+6O6jX+iAFitH1agXyUrxqSinLZxZFTYLRVq1UVyuHIUy6UdFDdXyHSSJyohAoF+/JgN9IxWvB1nSIw52dwn850cvgu6KHLMzeKLSR3h9H7Ga4M/RePXaR2I4q0XxsEnKidPcHUSwXuRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730905157; c=relaxed/simple;
	bh=ALXDvHXn3Q8wMu3fWsM27h7XTmcxn1SOJ6aDokYeCGg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=vFSbtplPAuaqf5QM111tB0AHs5WKFOQQUpjjj8uy8twZoNKj5lhgyg1k8g7Se5WzV3cEFOpb242zwkt0hu0p4aNwzis8PD0ESf2Tsq6HVpDBLuHa4dBD9PGscFaXueZY2LNAgtFEILkMlhzjGT/uOtjT8+ZTjXHj4iwOYRc56wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PUDd0dW0; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PUDd0dW0"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9eb68e0bd1so248669066b.3
        for <dm-devel@lists.linux.dev>; Wed, 06 Nov 2024 06:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730905153; x=1731509953; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ALXDvHXn3Q8wMu3fWsM27h7XTmcxn1SOJ6aDokYeCGg=;
        b=PUDd0dW05Z0PWzxpag3iNR7KrMFZXdcVvMp0iLBYoHch4yfvMwpWON9abg0oPiB0oX
         VSd9sF/98hfjQEDfLULSgNvdXW+WZd/fWuaGm3Eq4IiALj7Cfk8TRiLhruaZFowMeYt+
         TnGxAfGBgzndzI5U0K9hYkHS24nTCpYM7lsL03q0/6GwAn7jZ39Rs73htcew5GAZECqk
         4JBFk8Wl0nPZhTt6iyJbEFbrrZO1f3d+pG3mALLVAiMpCLVwI2NcRVAgIE7iGdso6elU
         YU57oQB+7O9Dp/VPINi0G9m8vqetIezpEYlCyTNVbcpLAKVZqwOsOKkAz+n1KrnDpDx6
         HRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730905153; x=1731509953;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ALXDvHXn3Q8wMu3fWsM27h7XTmcxn1SOJ6aDokYeCGg=;
        b=Gheho31o++NZUZ2DTeeBxgFLmF4XzNvWob6MDdvv8MNtGJg6p1sethJmoaafKEzzyw
         AdCoewU0PNJHOg0WgbT5VqZu4wA1XJpKkJI9pICxDK7Z9Kht2HxHJMo6V5XqoifkydW4
         u1oYMd4xJqPMqRi0SHGTNQKS4hP8XrjINdpApDyO559vWUIOM0yKLkp+d/wAikrIwzaz
         rDvYcur+ex/2Ggn8G3evDMa1O8bYXrcIg+bPzrwCj7EXGQnRz29ySlT6Nda3pP7Ryv8P
         gDDWSBRsayxDKhT7/RRmzrbS6mXmzyblLlIiMMSF5HOWt3akch70ube8fiooqAhlNfDM
         yLmA==
X-Gm-Message-State: AOJu0Ywj9kJHiaCU/w9NBeNNEqyOc3N61ihmfV8FFQJP8BUgRfwK+oUd
	pRAaqTJjiGh281AErALg3nhqWycMoW8ci5eLS+GiKZNbS4MIkIyCKFgH0eU0dsFS82OPidQac8C
	K
X-Google-Smtp-Source: AGHT+IHuXRs0uKs828sJZE23mq7FCvev2m2r2bXXfcvN9QSSuTVC9BCMKFpggIrBbVqYUqCHGU7AsQ==
X-Received: by 2002:a17:907:7206:b0:a8d:2b7a:ff44 with SMTP id a640c23a62f3a-a9e654fb607mr1848749566b.32.1730905151655;
        Wed, 06 Nov 2024 06:59:11 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb16dbd38sm290037166b.73.2024.11.06.06.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 06:59:11 -0800 (PST)
Message-ID: <dd330f29f6d1af2b6297ad0baff9098fa897a2ac.camel@suse.com>
Subject: Re: [PATCH] multipathd: checker port_state before setting it.
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Muneendra Kumar
	 <muneendra.kumar@broadcom.com>
Date: Wed, 06 Nov 2024 15:59:10 +0100
In-Reply-To: <20240917155858.959835-1-bmarzins@redhat.com>
References: <20240917155858.959835-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-09-17 at 11:58 -0400, Benjamin Marzinski wrote:
> If the rport port_state is already Marginal, trying to set it to
> Marginal causes an error like the following:
>=20
> multipathd[365376]:
> /sys/devices/pci0000:c0/0000:c0:01.1/0000:c4:00.0/host0/rport-0:0-
> 5/fc_remote_ports/rport-0:0-5: failed to set port_state to marginal:
> Invalid argument
>=20
> To avoid causing this confusing error message, check if the
> port_state
> is already marginal before trying to set it.
>=20
> Cc: Muneendra Kumar <muneendra.kumar@broadcom.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

