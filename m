Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D941B1369B1
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 20:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721076857; cv=none; b=lu8oNjFcjcB/Tfs9ENn+Brh/e3UggJHM+5V4x+nNWCC1Rq4OGA5tSZjvNA7mC6i7TY3DCtSjXRxOigGMT3GaGYF4wqGsxX3UxhNpELeeOQflCwqAiBUNkVdoYmSTHh0Qq0YrU7VjM9qbnlN8cpaEb0MWasDi76LZS3G5fCexj+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721076857; c=relaxed/simple;
	bh=TN9v58QhvxzR3UfeaAZ9qakwpDEYz2+qAmnf1ZXjLmA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b5sIwFMczqW/uttbegv9MG1p3pdIcpGYe7C24SdJhkY/ZsQqN6PLmgb8o4qHY9Bapdpi/JnBaREsPQU4X3C8k7UthR0E+B8LfKr/4XfKohWdmOKmNWpbNy4US/knp5yoOqo8iRrdgaolkDSXmYiLgCNO/tlO4Tmx63W3YXaMaSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BeW8LUOU; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BeW8LUOU"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a77c0b42a8fso885296366b.1
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 13:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721076852; x=1721681652; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TN9v58QhvxzR3UfeaAZ9qakwpDEYz2+qAmnf1ZXjLmA=;
        b=BeW8LUOUUijZUKqNyHIrkJXc5P/EIQC80zmrMhBQkiYLJyOxtwzGWYk5RaPc4/GLn7
         Sw5YepF2K+3fynDDXRcn/G6IsbBiQnS0OhJFp7+bfiXonjLwGg4IGxu7q96pDlG9Ufn5
         Afwku0KbPaOyreauxj/5qc4X4h+EA7+gtJYchDzZk1fPXVh21BAILibfakXvC66GYmUI
         /eCpiMHyCq63jltFXyB0XoYXP4TkM1I2n1U83du0UgiVjgRWQCg+IeZPFnKAfIPGp3FS
         CctPViRXOuPcDkDdLuw/EulMedI4ulO2gjLdzqH4mhxupf2bAvqjVVFOKjMrL5sYpsk/
         L4OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721076852; x=1721681652;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TN9v58QhvxzR3UfeaAZ9qakwpDEYz2+qAmnf1ZXjLmA=;
        b=O1XVQe8YxQb77weloLrCl2dD+8wQJ6iZBXUGylxemY+RIymT7dWpWeaqSFfjIimmNL
         yGZHiOZP6aEArA3P75TO6MvXXHmDgDZuTY/b5lm5uKNesBuz5j93hohym0v2Pm8PhOgG
         +Bo/UzGsU9skmXZbGM4AZeRbbZfoXu1jyFHMdyYEJFWu5rQF0XL47raWWZZlbp1mlbUe
         U1yjwG1f7ZeJoF6wIT8/Af34TarE4cjKPbADllVofBQ/4dhwgx55nm5dRF0tu5BOhVdf
         KBb1n9J45Znhp8Wa2MK2aKQjBwbKKvmDLj0zEGPQexo5YIaALRnCDnoAkRoEVsg9y5EM
         8cMQ==
X-Gm-Message-State: AOJu0YyW8JOSLiE6E+2E0AJKap4BOPoLCw/YaMHZ4AFOcpj2YKp+zWVB
	oMj/9DrHD3kO4V4vXzlFCYliAO7ctLUXRvwTLV2WauO/4n5MB6a2LQR1MzWxjFs=
X-Google-Smtp-Source: AGHT+IFlzysG5ma8XrGd2+2Q5n2H1yetVb4QOCgLIXI78tK9u6SvurOZht7fOgOcrStTr3VSThmmPw==
X-Received: by 2002:a17:906:2dd0:b0:a6f:2835:be95 with SMTP id a640c23a62f3a-a79eb214b34mr3479166b.37.1721076851948;
        Mon, 15 Jul 2024 13:54:11 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc5d00b8sm240371466b.83.2024.07.15.13.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 13:54:11 -0700 (PDT)
Message-ID: <b703c1537917b69189cf6f8409fc32c233c572ff.camel@suse.com>
Subject: Re: [PATCH 20/22] multipathd: factor out actual path checking loop
 from checkerloop
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 22:54:10 +0200
In-Reply-To: <20240713060506.2015463-21-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-21-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:05 -0400, Benjamin Marzinski wrote:
> Move the code that actually loops through the paths and checks them
> into
> a separate function, to stop it from being so heavily indented. This
> will be more imporant when a future patch makes paths checked by mpp.
>=20
> No functional changes.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

