Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56710346AD4
	for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 08:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771836858; cv=pass; b=BGhED+9rwLbNzJuBWfbWlrFBHXFrExn7dOtN/KUe3wPlnN+Nu8JvdZrNt/kjcH7rJi5nhpxbQnJkQqMERiQ/3F6ZvftO9jSq6BmxXsw6Uxt1xsWQQl4YwpUXIiRrdRLyAvhpe2FoHJbwKFgt9HEtsqGWlekuT66Nzi2USIGXm00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771836858; c=relaxed/simple;
	bh=xxBLnEEufa92a8CFyCGVUFkK90pRNQ2r1tiXqa4vkQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dKm8vqO0CGMhkdRwyTD3o3K5jgUIKg+Xk9YFTMM8GmEipX4HDX5B8omNSlyK/3q8aBp9nioV0YOOtTMmPTCcyZitd2Run0CRdrk6mXwfdOzis5GKJpXuFo8qtCstY84B5CR/MZz5iyU77kzO8fz9nR85tW5pML3884ev/TcRCFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=arJI6UfZ; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="arJI6UfZ"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6597a7bd7d6so5320744a12.3
        for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 00:54:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771836856; cv=none;
        d=google.com; s=arc-20240605;
        b=eAwcodnD00W4Vpdh/bsPoeGpt1YLQr4X1zJfIdD4ssQtv3go6ddQAgdQaDNzVIlQwx
         XvcZkBmf0fjQLzKMTqBS3PesQSjsiCKsQlE18mxGOleSuW96UWz/nagSUfg3L39S5UHX
         d+Fl0rG6AcjvzlnmY24q9fsNeh/OQR7kylCw+1WseZ663QIelOFbYgc1a1E/lwu5UcH4
         8FLlSyqJaBiFFeMUEUURhCJ33C19fUZOtQ5SMbVagJ1po33CR2pmdufQCDjDqAwnZy91
         X8ZzYgz7z6l5qkUzajk2uMFwTRfCdkxeggs0ltPwfWIeu5co5BzjdkHo/D+q6SvLY8v1
         o5Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zOHjvQNmMMpWpRLZPoxktX3dEnoeJpxMTXCbDZl3BoQ=;
        fh=GcaT7r7EDUzd9H7UUJFZTIjukqWKGoDjYShDJ1ybPqg=;
        b=CACoY2OWjR1nuFSeWJIJHrk/WBBIbSw72lofHmbSY929A6C/KECotce9Q66k4Mqfk2
         DTNYUfJDerhS8NsT6Q570jHvKOzcraXtrX3/ZGGhWAX5jhWJNtnPjhP+wInkq+4d2LDj
         OE9isg7sVl0w/8VauFK3BLb6NgoamgZMOWIO02Eydvb75MsiZSha+dS3O38QHy77TaLO
         vo6zcndP5Nn6hlbcV2TTov52umIkGZtAgUg2G5GmtW7KC/AkPoWznZe0W0WbH3c3tNw/
         J6XzU1BPIQkBMyclzT35h71TwFeMUxTl4DyUn8swqOYTjmxwPTx8Cz5+vNHflo7FZDbZ
         2LLw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771836856; x=1772441656; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOHjvQNmMMpWpRLZPoxktX3dEnoeJpxMTXCbDZl3BoQ=;
        b=arJI6UfZ4pIt1JoztJHhO9iW2gxKmXmiQDm1LjXp5A4msvlztpjGaOeHYkWQpPCpeb
         awgwvqXQgBljp0v3pNrb76ur4xBqFUznZ0JamROHaENX8ask6fjfy2Pzm3tSPzIvtK/B
         9iiB6TEHHqcClalO3tPy98T4p/7y5tpRJ6c70T8+sbi+8xBKTXLKEZxdMUgjSoZ73gon
         FFgsKJ4scIKluRzIy+vSbtUaTCZ7SrHC8wU2txHSKDz0M5BzJxyQPUs+qiHNLzD+IjQD
         r9FfaCLko8eAAzSa67R5L5sYGYOO9FwtzoZuG4I7/GrxcGs5s+fAAe67z0Y9x2rIxqYo
         esUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771836856; x=1772441656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zOHjvQNmMMpWpRLZPoxktX3dEnoeJpxMTXCbDZl3BoQ=;
        b=Dk/xyBAxNk6XsAwCzcFSdRUhX4P2wzN4Svg71r4miEhWTToZ/8s4sYzHulFhcQaJ+h
         iJON8eI+tvABJeL/QWbuaP8UCg+xepAXg00fvrVPSXCEFH9CZhpkftOeQQN0EOCbNEwx
         3j0EOCNNAy697xNsDOdbCgLEX3qAR1x1RsYJoUjWzage336mrCE+4RSFgyc2aGPzQWiR
         E5oAsw5yrTx8iZ7hUOdj+e0U1n7Asz6NSLYA5jobCEBclOG7/GqFKiLx9c9Pu++CiDSE
         gy3WXgEXXLw+qZ8NP3VgpUlHBhETjfDR8F9LI/6o7LDthtQOQS3S2q6zME3EgpTAf8XB
         ooyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUg0+5LtyVKN530ztQaxce6OIUyPNjIERKbiAQ5ylaYl6sEEFJ0yLL5TVG2H+s4T+Mzz5a6Yh8i+w==@lists.linux.dev
X-Gm-Message-State: AOJu0YwYC95bnUGpubsIjkhUuQzJ6Gohy6Z1U/yx/XiHmKqTup5HK5zw
	pVjlj9G5HHXBsDrJUaGQU+JuiuVvB2lmg62z85UAeeCtINauIaX3ce4oOvOn3SojqsTRFIKOtRO
	WX4soaZbqNMKJFey2TTW0wBtyd9CZpuWZBLpm93QUXGfUJ2TtD3Nc
X-Gm-Gg: AZuq6aKvkNZJ5Nixb7BBDbYLjS4SXRr/VF/wWuq/GCl3jf2oX9P3n9xHg4y0ZaYL7rU
	4LERsDmh8Hwu4uOojXAzCBUtNlHOSYAc/gMCLaP1D2LOLAszx4JNvpX6Ws7xfYQdFvA22pULmIB
	smeuC2uuoqovjhFKqQFUKG6ugwhHUgyoHhkauZDDmfK+sH1Zl1jb8h57D44zXHdan9SAbxY+uZe
	k3QSyV+ZKYv+TZaePiR9yDDtMSxxD2P1KXMXMf0vHCZeqSGFuKpelwYoUIi1A5VKiuqhXJF/2oN
	FYCufmofl3BXX3vpaiUBzhxvagmZ5Hz0dLyBJycR
X-Received: by 2002:a17:906:a244:b0:b88:7431:3942 with SMTP id
 a640c23a62f3a-b9081b4a232mr355662866b.33.1771836855694; Mon, 23 Feb 2026
 00:54:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260113110302.114843-1-marco.crivellari@suse.com>
In-Reply-To: <20260113110302.114843-1-marco.crivellari@suse.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Mon, 23 Feb 2026 09:54:03 +0100
X-Gm-Features: AaiRm52HpgkXEAZ6I77V3ImdQj1KxWO8pLsJSTJvUEaLueLLiXI9MFKL-_bQz3s
Message-ID: <CAAofZF7gneM02R9oHKS-=NmFs47Unk+rO9bjEiW5Gv694GLTvA@mail.gmail.com>
Subject: Re: [PATCH] dm: add WQ_PERCPU to alloc_workqueue users
To: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 12:03=E2=80=AFPM Marco Crivellari
<marco.crivellari@suse.com> wrote:
>  drivers/md/dm-bufio.c              |  3 ++-
>  drivers/md/dm-cache-target.c       |  3 ++-
>  drivers/md/dm-clone-target.c       |  3 ++-
>  drivers/md/dm-crypt.c              |  6 ++++--
>  drivers/md/dm-delay.c              |  4 +++-
>  drivers/md/dm-integrity.c          | 15 ++++++++++-----
>  drivers/md/dm-kcopyd.c             |  3 ++-
>  drivers/md/dm-log-userspace-base.c |  3 ++-
>  drivers/md/dm-mpath.c              |  5 +++--
>  drivers/md/dm-raid1.c              |  5 +++--
>  drivers/md/dm-snap-persistent.c    |  3 ++-
>  drivers/md/dm-stripe.c             |  2 +-
>  drivers/md/dm-verity-target.c      |  4 +++-
>  drivers/md/dm-writecache.c         |  3 ++-
>  drivers/md/dm.c                    |  3 ++-
>  drivers/md/md.c                    |  4 ++--
>  16 files changed, 45 insertions(+), 24 deletions(-)

Gentle ping.

Thanks!

--=20

Marco Crivellari

L3 Support Engineer
