Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDB413B791
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 20:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730666815; cv=none; b=WSP5Np7Bq3l6uZa277J/CB5Ux7b7l7Hhyl9YFAEHQYDyNRtMPc3E5uzW4y9fz8sSTegFadWlydKm8WFUwJU2JG1rSi4YuhF3WmPv44yZVkGwn2ccXxuZft3xeNipVIYrw904cvLI2Bmh4HnEBMFPATH6LuKJHp2CerH0mNRVbfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730666815; c=relaxed/simple;
	bh=edIK6cDNUQY2eMbwN/NkZIqbZVwQ6r1BE7Hc65ZoTgw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EYaURwar3irRpXkzhdkqKW3FQlHQC8G3B8YjHFKJ9wd0Q0m/Psw0gAbErhk+MuPag5rxEa1l9HVJiFRmfX/uFolkqyX9grgdf1u8cLRrZbNpPOY5JT8G0XVAGldtEMAePBrBz5S6uym3BlRAP1AgMLRtEma5nNKUM8WXC2AayCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ekVYEodW; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ekVYEodW"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c9693dc739so4738743a12.3
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 12:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730666812; x=1731271612; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=edIK6cDNUQY2eMbwN/NkZIqbZVwQ6r1BE7Hc65ZoTgw=;
        b=ekVYEodWsQmSkwgAi3jUvnj4HkYgmLScBPcSzrifAzNWJfqTFonoWOPV4pj7vDIRFK
         YH0Efbm7PMbWvhShNZqAewmz18icD//5dOpW6HPOH+xPFMhSYUSFxnS+z3VPxIWYeZdv
         Z5/62VVI7NDTZmCerqLHAZKuhuZ8aWbxgy3WVRYZE+K0CBs55JQW8Ws1hdPv1GXL1n+a
         lIZEYLbnSFX5DZ2i8v/TtKBAlRLviGKr/TK988b6p1jpf19Jbr3/gDVche0dEFAgHQB5
         BJ6UGzQEpKMsJAk0GdXadPFSJxGywvfC1VaGI8EoZdXNjUpYbgXJLWkFQ0cEgVkweis+
         6Hvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730666812; x=1731271612;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=edIK6cDNUQY2eMbwN/NkZIqbZVwQ6r1BE7Hc65ZoTgw=;
        b=oUprvR4xOfEtqUhuCBWTxtPOJFypqPnX/CkcbpaJ+V1dLrNwxvVkpr0P+kaAZkrRNS
         B7CeyOYAzZ4w7G8X2jCVJMTF89uwwCW6liSBUjsQKOkC843+ndeAy5Yu87Eb2EOSle4A
         5TYL7+a9MB7VxCCXJzUDhNbnrpCJG9T6orW54iN+e9UpL92EZGoPJeViyTBc4N9nYmNB
         FytVjiKomAzxhEzhuU/xtNsmAqGSgjlJKbLEtb9x3IiUHxeN2svJiUGTWmnks7yTSU4U
         V+mvRK55JmFCLIzUtS8hPCZ70N8up/ObH+YXBVaw3Nr5hD+7Vy4DOxwFx+lGpji53P9M
         pUVg==
X-Gm-Message-State: AOJu0Yy16dIquf7CGQQkjrTTQzPWo2KFZYaxvfI9ujcsCp2vieyAdoJg
	Wp/DdT4gKjy38NHLetKoMMAwDo2dSwSxiGjpsR+xFmH134712bb82S4N9R0KpzQ=
X-Google-Smtp-Source: AGHT+IEWBCYBv61jjEQ9jUnI1N2pdBLsPw8j8pBo5w3OYRA5S3PB3herhRJA7pgiyelG//IQorJ9UA==
X-Received: by 2002:a17:907:3ea3:b0:a99:d797:c132 with SMTP id a640c23a62f3a-a9e654cdcedmr1129523966b.16.1730666811462;
        Sun, 03 Nov 2024 12:46:51 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ceac770057sm3739997a12.22.2024.11.03.12.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 12:46:50 -0800 (PST)
Message-ID: <df96b3521ca3d29d816d307b3f601e847907acaf.camel@suse.com>
Subject: Re: [PATCH v5 19/23] libmultipath: add libcheck_need_wait checker
 function
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 03 Nov 2024 21:46:49 +0100
In-Reply-To: <20241015032835.2693247-20-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
	 <20241015032835.2693247-20-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-10-14 at 23:28 -0400, Benjamin Marzinski wrote:
> Add a new optional checker class function, libcheck_need_wait() and a
> new function to call it, checker_need_wait(). This can be used to see
> if
> a path_checker is currently running. This will be used to determine
> if
> there are pending checkers that need to be waited for.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

