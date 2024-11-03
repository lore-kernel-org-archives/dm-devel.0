Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3872833FE
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 20:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730664455; cv=none; b=e+fL7ICizAjd3I9Esz8xnwgUKQ1anGoq/+SRMW63YUAJawhtp8SDoU635EUU8oVTZXIwGRUJuNI85e01PboqpvxEaOenNd78DecszfwEGFn8M/ALvIQ3F268PLSvaVo+E1C4ud50Uidp8X267vjjD8m/F61Ly6ShCltR/1dpt0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730664455; c=relaxed/simple;
	bh=QXKf/nfllV+TFIEW+EdiasRrHGJq6ryLjFZapUZeuD0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c5PUeq6bBGFee9sQHKcOjBwm3vtlDdKxGQjkV0VCB+SH88d0af/d+gjS0r3ZL8Fwi09TRh4HCpLxLTKKPNK2VHFHsJxw/b2JIyMBEExMIXhLkPQe5bAe9cQVLRYGkEexl6qCw0y++qBZPgRIclwen4bhR6384PpFxg8X++HlYz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QE35UnGF; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QE35UnGF"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c9693dc739so4712929a12.3
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 12:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730664449; x=1731269249; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QXKf/nfllV+TFIEW+EdiasRrHGJq6ryLjFZapUZeuD0=;
        b=QE35UnGFh+zzVfpOUAq5ohFA1fAh1mJHGQyyEHMfa1S/Louh34IlKS0+44WJfUyoLF
         5HZ+Cv/bXvV9q1L2AO2qHN/TMKtSJyZgjYXqi3abwlSa9HaLHgB06R5eGJU33FPPZIAw
         o21YZtw/kmCUhKwVNzQ58aa5Wo2loTmHQ3n5M+h0n3rFoF8MfcMXrhGsRzBi2QbtAB4z
         o247H6nLfSyXtmKq7WqYuF4NWe41WjlBBERoiGe61uBWZ3MjzwFhOHagLaqU1cvusXEc
         kaHje+ZM6Dw9bKR4WQEEXQILH2KotR797HDl0pA7+LN/caFsRloobuXa2DB0Ra3WRjtm
         p3Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730664449; x=1731269249;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QXKf/nfllV+TFIEW+EdiasRrHGJq6ryLjFZapUZeuD0=;
        b=JwwZYUnJStsputF4LV/4X0jJV4TVXsx280qSahfTfte+n7TAO7QR/pk7/nYdrFhk49
         OpzrgHFy+xkVU2rd2Pjwd/oFqitikqEw7ZtwCGdwonM4BRrImLPPoRsjDmR2PTHKfeAy
         o/QqZyp/kA4/bjGth6NpczhWQ6uBBjbQLSrfI+tYesggO/2E1/f/erDmbQxgNBQoChz2
         MU90axKFtU1j/0At2e96qI3JAUUAmJy/of8Yo87paTSIk1/17GDCIqjh58eeNkXGvb9A
         k2GgX6c83hpmAp5xvkmjDSxIVFqUSfDTTsuh2rhz2NIbs8vo2OIvm9gJXM4ZV2YPhkeJ
         QPzA==
X-Gm-Message-State: AOJu0YwwIWlB+6szWwIJjNroHWOLBfn7IFoqBElw7Fr84BAvv+llR82u
	jG543CeLExIzHp9LwvbLvikarlHpwjBcrKInNk0y6JTSLBld70FUHdvCNZ5REm8=
X-Google-Smtp-Source: AGHT+IEXJQLT5QzHOvF+QLPGYEENCEUIdpXnC0bOO1exafsXKYxPtybK9jAGlguA0OUztLUNy0kCfQ==
X-Received: by 2002:a17:907:728b:b0:a99:b2c5:86e9 with SMTP id a640c23a62f3a-a9e65494ea1mr1103877066b.11.1730664449207;
        Sun, 03 Nov 2024 12:07:29 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e566992d6sm459818166b.224.2024.11.03.12.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 12:07:28 -0800 (PST)
Message-ID: <178837dc2b03b6d2a0af27d3cc676cbe5d4a2045.camel@suse.com>
Subject: Re: [PATCH v5 09/23] multipathd: rename do_check_path to
 update_path_state
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 03 Nov 2024 21:07:27 +0100
In-Reply-To: <20241015032835.2693247-10-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
	 <20241015032835.2693247-10-bmarzins@redhat.com>
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
> Move the code that starts the path checker from do_check_path() into
> check_path(), rename the remainder of do_check_path() to
> update_path_state() and call that from check_path().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
