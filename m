Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8C31E8B67
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 20:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725480434; cv=none; b=D2KZIg5sEmbJHy6m34Qos58rk005kpltWDv8GzGh2apK/KAR+5mh3pnMkKlTvFGAB7hExpyAiI8LlRTE3j4+/B8UADKedzXMgi+uV0zMzSJIiLnO5+bG8hinBpLp+vQmWRwpKx7GazssbFBq3fWhjySkjq7KM33dSphVAURf0S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725480434; c=relaxed/simple;
	bh=l9TQWAN1hWfavaOJo2D8CYde5CohMe7omB/yLMmmkew=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Waheu/S0V1yGePFICITqfSPGYu07/WIdmFSrT+4NaOvEpa8PBOIGO92IV6VJ7JeI7fR4BKwxLatd7rfBBnuNhhQS7xqmI7ABQTHU4wm5+Ez8+c+hDwR4gsxe98UfV7tuZxBL08ybhW8Np5c1N5qgOKlIbWheQBSOo8ozkm01l0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L56FLZYE; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L56FLZYE"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c241feb80dso2323526a12.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 13:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725480431; x=1726085231; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=l9TQWAN1hWfavaOJo2D8CYde5CohMe7omB/yLMmmkew=;
        b=L56FLZYEtUpv/RiCXrpkhL/kRjoqdLskLRm4mJ91aBmdv72O32VKmpzYOLFUdM1yTo
         ZAuTisBXKYz7MJL236wbefiLH+jC0VwJI3dpBE7AtdT3EjBGXJ/l1baglqB+UQwjA7G2
         Bv5ecweQjzsWvTagPGyHsPRSiJ3AzW7rnynmzgoSJ+zBtDVoMSJ+qVuUJDlz+0EJ4Aal
         qXak6Le+RhYti9rfYGmURaQwgeE6dlSiRrAYDKSbFyxXtu80y234/L5q/dCIbKiCLi4H
         6Tenbi0HHazZLng+Y4Wdrr304bnS6lXZtKW3egP0RTGFXfN+XW2RKrAVZ9naN0EfY3Lj
         Xkbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725480431; x=1726085231;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l9TQWAN1hWfavaOJo2D8CYde5CohMe7omB/yLMmmkew=;
        b=L5QBsZKf95Lo+f2Jv4NQxJJ2/BIzOdQG4eR0hc4otL38VmPmwlhN/LU1Cf+2OVf9q6
         zXRwWHGulvnkiSc59PHmSlgADTzYCivSiBUjaP3F3sQg+wA94JK1T0tq0Wavr9tJeptX
         VSyYT0QTPsY5Q25C9oiVbRjwsD5GfhslgC7oOngSCVvEu56AJHyzQbcjrdX3F0Kl+vzV
         w8ymbOFmZpOPQpFRyVtNYwEwSJMMQeIo8lK9UzK3rsRCH+kui7pBsCRyPXEwM8vL8x5T
         APkUEGYrnQYIOh96iSZ2XvwEirO3qYCxrZ2IjXMUIPmjU+uTvmwjquePQRFoNnuRey4B
         iRug==
X-Gm-Message-State: AOJu0YzGkBA2wS8wDTJKV0uWOYZdqcrjeBwjf81Y+xUqHBOSvo8f/YkM
	qGylgHp3VTdN/wL801gYvjO0ZH8wlHrdauzLLfuWo3ovu7x8M/h5uMKVHi0jwvM=
X-Google-Smtp-Source: AGHT+IGRoSSqwuqrMt3I7fAcXJ+QnaWgGMeUmmOLc0+Wm9I6aBL6jqQUq5n8fR5GrqoE8Ho1UImiBA==
X-Received: by 2002:a17:907:7e9d:b0:a86:8f9b:ef6e with SMTP id a640c23a62f3a-a8a43037c24mr366661066b.13.1725480430609;
        Wed, 04 Sep 2024 13:07:10 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a62037380sm32385966b.47.2024.09.04.13.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 13:07:10 -0700 (PDT)
Message-ID: <89d2938db859759bc6d730021cf8329fb0363867.camel@suse.com>
Subject: Re: [PATCH 00/15] Yet Another path checker refactor
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 22:07:09 +0200
In-Reply-To: <20240828221757.4060548-1-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
>=20

> With this patchset, the code now first starts the path checkers on
> all
> devices due for a path check. Then it goes back and updates the state
> of
> all the path devices, waiting at most a total of 1ms if there are
> checkers that need waiting for. Once all of the paths have been
> updated,
> it goes through each multipath device, updating path priorities and
> reloading the device as necessary.
>=20
> This allows multipathd to spend less time and do less redundant work
> while checking paths, while making paths slightly more likely to not
> spend a checker cycle marked as pending.

while I've already responded to several of the patches: Thanks a lot
for this!! I've been thinking about a change like this for a long time,
and this is definitely a change for the better.

Martin

