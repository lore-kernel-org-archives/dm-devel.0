Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06F32BD906
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747145538; cv=none; b=kDnHYJDNBJ7GNuX8gyOwjnKPfZD7Z0CXmp3cEx1OomePZxpeb9PDrS5cIeetycftHSQCXS52PstQyWXytaEBFQ74BwHgm58C2MaOZlv3xSst39T1XAjxHBGUSmMIgEX3rIKc1ucKCVcakpsO1faF1IP3Y00fUd3T075j2z5trAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747145538; c=relaxed/simple;
	bh=1lStfJjeVm0FxrPk8UeqkxuFpAq6qKS1xBhDRNcsY5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lWfDi8KrexNFA36slLoURGPwn8EEkrxpbZeLlEAK5syUxE7U8Ka7dJ8NBO9aiEsaN717GKPtO0CijmnmDQp8TyUftU1o97EoxDPrK8Dtqy9IwvOgs0zTq1THJXHWxS/Omy128CR3DbtsSSDAbjgvSriC41PP34enZ63/7hnLe/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=X5IzILcr; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="X5IzILcr"
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B7D8E3F826
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 14:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1747145526;
	bh=1lStfJjeVm0FxrPk8UeqkxuFpAq6qKS1xBhDRNcsY5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=X5IzILcr4ExjbNpyCt3k6rzkUUu6I5AaCjriUx6CgaSHyBho0T3AmJbhKkk/3wFDN
	 ln1DIelj4DApV9VK5Yv6wIjF8NzsPGA+EcSZIBcpSgFcbqk8hnuXceGwe+zSip7iB9
	 HeYcnsrR0FbQ9TQRjddPgBVhORKvcJTut1MGSzG9jYkW63JxTUbTddq3L46yusd2nG
	 kVa4GnMvViK0ibW7srVmEPbjwkDaO0mPU/oykmTKEepFgktge6x/mfdX2HmDK1pTe2
	 1D9QNguo6zLckTjAsO9nBZAtABHX4TjxEddkYkq4QwjcVfSuwGXlXOqdnPWVPUwilV
	 o/PNewmkSBQ5g==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ad224fe3745so432021666b.3
        for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 07:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747145526; x=1747750326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1lStfJjeVm0FxrPk8UeqkxuFpAq6qKS1xBhDRNcsY5k=;
        b=WfuFzvVZ0po8PSNZ89wgh2zKDR1YfEgUuIAZWTMXux/hU6atmV1F88EVoTQdgrcDmA
         alwE2yLuqGXC2ZuS8wOz1jFKFDMYd3/W2pRbXqVT6LLp0lFCGbcJq3gnPDzHynPRhn0P
         CuGDeRQpGkUrMBi10nYq4RtYeCvqWTfrXmRfb5Ay/7v0lAbB4B0xjIQTpfedc66m6XGS
         2F4lZ2VOomWzk5LS8HKwV34/OSYOdaoU/GkRCgJdzYdPQYO0RBT+MHOKHB2STSsMCl0Q
         l+Dtpj2QZMp8nKJHxxEyC69mvmFl/svhWFzYk+iQny7PbBTcLcI4eWT5lcZ2Ex96QLLB
         J1aQ==
X-Gm-Message-State: AOJu0YwpC1DfwuqYKJQ0ZpBlmdf94jOf8a3ySJFa86De2Jq8PujqZpWP
	6oH8wH5xVK7bDg0KKAd1t6oOC0BsjMIAE9ZZxTFTD4q7zDW4LDEKPVxqKMSj74FcYemiqiN0pka
	35+riN8DIzDN6/kx1qdJRLah6OmY09VkmoKHNDHnyFfIVhFVocRUFBTg6Vs36gJvFTVKuGl6hcP
	COHk701AC+JveJw97QB8/gpxEr37zzmCHVgtqpIdPh7GrFhsXDptNxc2F0jhKJWZre8A==
X-Gm-Gg: ASbGncvPARXXv63kSIQgWj/AOMU5BSwuyNiIvXzshQIyPSD7L1c3yKF77yTuSW1nkxd
	pLZyn/iHci8pqEYx5OeT0y2FOsaKil4QIUYHHUPoG5Ke1bAjlUJ9YetVmcI6NDLEneiE5pA==
X-Received: by 2002:a17:907:9719:b0:ad4:d0b7:c990 with SMTP id a640c23a62f3a-ad4d0b7c9cfmr416841266b.26.1747145525602;
        Tue, 13 May 2025 07:12:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEetoG+JbfWfOiBwYC+FLbawuLLmpzkGEBr/6taHEbK7kKvENNxvnISJgi+mRc5zYqSvNK4b+/RvZlmMSINkPg=
X-Received: by 2002:a17:907:9719:b0:ad4:d0b7:c990 with SMTP id
 a640c23a62f3a-ad4d0b7c9cfmr416838466b.26.1747145525198; Tue, 13 May 2025
 07:12:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPza5qfw-ExyCFnWa5JoUE7eUsk_es8yx=H0YDFcY-=J8OtHpQ@mail.gmail.com>
In-Reply-To: <CAPza5qfw-ExyCFnWa5JoUE7eUsk_es8yx=H0YDFcY-=J8OtHpQ@mail.gmail.com>
From: Chengen Du <chengen.du@canonical.com>
Date: Tue, 13 May 2025 16:11:54 +0200
X-Gm-Features: AX0GCFv2JuXVJlE4tYWunqTS8GNjZDnGy0hZca8S17CAcUQVcGriBmOSQHKxCEw
Message-ID: <CAPza5qeh+O+VY6OS025U_7xONTjT5xczFb=j2bLkQvCrLs3WLQ@mail.gmail.com>
Subject: Re: [Discussion][device-mapper] Enabling Block Device Access Locking
 in systemd
To: dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev, 
	christophe.varoqui@opensvc.com
Cc: systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My apologies for not using plain text mode.


On Tue, May 13, 2025 at 4:08=E2=80=AFPM Chengen Du <chengen.du@canonical.co=
m> wrote:
>
> Hi,
>
> Apologies for including everyone in this message, but I=E2=80=99d like to=
 bring your attention to a fix [1], which may require your input.
> The issue concerns a potential hang during the boot process when the syst=
em is waiting for the encrypted swap device node.
> This is caused by systemd-makefs skipping block device access locking for=
 device-mapper devices.
>
> A more detailed explanation and proposed solution are documented here [2]=
.
>
> In brief, systemd-udevd probes block devices for filesystem superblock an=
d partition table information as they appear.
> If another process modifies a superblock or partition table concurrently,=
 the probing can be affected.
> This, in turn, may lead to unintended behavior in programs that rely on u=
dev events.
>
> To mitigate such issues, systemd-udevd normally acquires a LOCK_SH|LOCK_N=
B using flock on the main block device before processing.
> However, commit #e918a1b5a94f (udev: exclude device-mapper from block dev=
ice ownership event locking) disabled this behavior for device-mapper devic=
es, which appears to be the root cause of the boot hang with encrypted swap=
.
>
> The commit appears somewhat ambiguous to me, as my understanding is that =
device-mapper devices should not be deactivated while a udev rule is being =
processed.
> I=E2=80=99ve reached out to the original author for clarification but hav=
en=E2=80=99t received a response yet.
> I=E2=80=99ve also reviewed related projects such as multipath-tools and l=
vm2, but couldn=E2=80=99t find similar examples of deactivating devices dur=
ing udev remove events.
>
> As I may not be an expert in this specific area, I would greatly apprecia=
te it if you could share your insights on the matter.
> In particular, could you help confirm whether holding a flock lock on a b=
lock device while handling udev events might introduce any regressions?
> If this issue falls outside your scope, please kindly disregard this mess=
age=E2=80=94and I apologize for the disturbance.
>
> Since the bug is related to a boot hang, we are eager to resolve it promp=
tly.
> Please don=E2=80=99t hesitate to raise any concerns or suggestions.
>
> Thank you very much for your support.
>
> Best regards,
> Chengen Du
>
> [1] https://github.com/systemd/systemd/pull/37080
> [2] https://github.com/systemd/systemd/blob/main/docs/BLOCK_DEVICE_LOCKIN=
G.md
