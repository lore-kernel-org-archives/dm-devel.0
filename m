Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A139B12E1D2
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713537478; cv=none; b=QyPK7Gw//RUDO3LMILZJhurfetuUnSAGZOcrgyuQtR7BytWeu4FnfsckHqeUj0mp/lMXxGWpiY0iSZRI1XTQR693iIQg3xMQtwRpdiqLqhbxljMUroTGBeTwXFEcY+XePgONRghkqpvwhNZ2Bi7TFQXYPypkRuj3cu8pzyZPU3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713537478; c=relaxed/simple;
	bh=B2KjOBeJYiu/sPhhhgIm5hStOwT0PTL8XKgyZ0RgG7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Aswr/onK4X4nkjXA1Zu2RPLR1BI06XyUwlwAAdHx+mhFkcdkBlcTzETQRVRr1IeyMinCrnMjpZqPQpFfz8GlCo5aQ11ClXf+8MGjWUkK0yQMmGQnmlqOS4W2cG5G0FNKeLAdm7eYNbT9WN3qEQ3tmpNL3ktqPdJoxislWQJxdiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KPIiLyxr; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KPIiLyxr"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-617e42a3f94so23392687b3.2
        for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 07:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713537475; x=1714142275; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B2KjOBeJYiu/sPhhhgIm5hStOwT0PTL8XKgyZ0RgG7g=;
        b=KPIiLyxrc0hrN6wUTECE/5+oQcq8yIoB7xTfz16IxqYhGLis4qa5YDJex0XoTZjalO
         VghlxKXn2O6tBGZ/YMGSLmgQaDUaMzv+h+OSP/bEbneucoD4H94t7NJEwlakq+P61TeG
         WWD6cME0XKm63KPXxz3GkPGQGxlOZocAMRF5ZFdQrPGlFgDXSqjH3WDl0O4WWjkVcM2r
         VnD/bsSDeEqGo8ZhaiieE48ZrBrYp1Q+smmyMIESC+2ZFA8AEoCBaOBWq0XX6sSPIvHz
         3fivTlw9vZrc3IeJDcKgANF79dryWsuHwy1wEFjXX6yze/jUPjzhSCnZ2wHU8XVb37/y
         5e/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713537475; x=1714142275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B2KjOBeJYiu/sPhhhgIm5hStOwT0PTL8XKgyZ0RgG7g=;
        b=K6rW4csj9JPvv5pcNTGDBuS/BmLVjdEvft7mentcEK4yIAl39F6f+fpJZOm7hKOHUX
         nZceThaTzsoa923lqQ7ydhUPNU+Zh7SieRWZi6/G6HCeMzDsozBMCFJcB41rmYHcKXPT
         ePNonQWFITP2EFkMYDH/qhAgs54h2Z9Bj4lZTYpFBzC2haZgPlS6ma9vbOzNO4aL07qw
         G3dPVnyTZCb+uOMA9lfFL9mN3S/wFqeOlK1erzdZlEMdFoMZpB7jp2gKgZQO57oQ99OP
         3MyICPTQZG2kGREZ4yVgN0VfFolysQ2eib4w4LmO6OTf7F1Hy7AUajfxdBMCTYi135x7
         eEBg==
X-Forwarded-Encrypted: i=1; AJvYcCXqZ2cdzBispmsZZg9TJU05smjW1oL52QlB2S9qMRL0JnEuJZWg6A3JVHYLK+OClZXsPngcBddAJvvPP0BRnpgGcgFb7y64hlA=
X-Gm-Message-State: AOJu0YyO5zOuChznzuO1xsIvOYapF/zzS0lI524YD+IJbgz4gn1idO0I
	qj4X2//h2roymGukV43YeVFTogjj0Z6ZygRAS3C4BOxHfM72i27Vu9YWsHD46ylkZ9HVTFJUBh3
	V09SKf4vlqE7zDWUPeKB54xVRJBI=
X-Google-Smtp-Source: AGHT+IG90oqcl+NoAjtlw2Fh2VnLC10TlQeri3zVc1I+pOEhLIngrArDURNQyxAQFLQdx36XZMSVuw8iPTnG11JSDAM=
X-Received: by 2002:a25:6943:0:b0:dcc:383b:e48d with SMTP id
 e64-20020a256943000000b00dcc383be48dmr2105108ybc.26.1713537475582; Fri, 19
 Apr 2024 07:37:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
 <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com> <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com>
In-Reply-To: <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com>
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Fri, 19 Apr 2024 07:37:19 -0700
Message-ID: <CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
Subject: Re: memcpy is leaking secret data through ZMM vector registers
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: libc-alpha@sourceware.org, Zdenek Kabelac <zkabelac@redhat.com>, 
	Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 7:24=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
>
>
> On Fri, 19 Apr 2024, H.J. Lu wrote:
>
> > On Fri, Apr 19, 2024 at 7:08=E2=80=AFAM Mikulas Patocka <mpatocka@redha=
t.com> wrote:
> > >
> > > I'd like to ask what to do with it? We could use LD_BIND_NOW=3D1 (or
> > > -Wl,-z,now) - it mostly works, but not entirely - the key may still b=
e
> > > present on the stack even if we use LD_BIND_NOW=3D1.
> >
> > Since vector registers are saved on stack only during symbol lookup,
> > shouldn't disabling lazy binding solve this issue?
>
> It should, but it doesn't fix this problem entirely.
>
> If I set "GLIBC_TUNABLES=3Dglibc.cpu.hwcaps=3D-AVX512F,-AVX2" "LD_BIND_NO=
W=3D1",
> I still get a failure (I don't get the failure if I don't set
> GLIBC_TUNABLES and set only LD_BIND_NOW).
>
> So, even if we use plain SSE, the data somehow end up on the stack.
>

You should write your own memory copy function and compile it with
-fzero-call-used-regs if possible.

--=20
H.J.
