Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D1B18BB9A
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 20:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730665732; cv=none; b=dCIBSISZ+k/zxX95MOZ2FFEYldde5h+Aj/UFsRiH4kawe7m4H07cNvN62GultscpmmfZL0+e/VbR60QOu8OOwZypmpPOGTNPEn2C25ULPSbhH3WXnmLwhXrPVVuo5FSoOW9B4YAOxG7buVJlmFSkSKXT1u3UZYrR0V7LlEY38Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730665732; c=relaxed/simple;
	bh=uR3bQiyQsWE+imgP0v7xMKesdYi+ADxUAn0ABjg2cJ0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TyRvv+G1bkcE/tT8fpRHfiq5Ytqo8CwlY8WrRl3a8RlxUJyAE2lpbv4+xfJgL2qAZiy/xaJxZizy55AFFDxsTmk7+uHV9aLaU8ZvB+de/pmA24G5pT6nrfTmvefgI4gDvk2b3wztYseSTale3F+YeOJIkj5Cy9fH2gFhLjQ2+n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gGedbDZn; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gGedbDZn"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9a1b71d7ffso634165766b.1
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 12:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730665728; x=1731270528; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uR3bQiyQsWE+imgP0v7xMKesdYi+ADxUAn0ABjg2cJ0=;
        b=gGedbDZnqyDaNpKF2oZWG82/DUF91fe7kjokmj2Zz2MCOqvSY3gLcAjBuzm9fX1wh0
         iErtuzhLp+qE7HVIZpj2pq/lH6gm9+0XWtxo5CSOQPbTyJiE7GPqhb8YL9TS/QtrlQm/
         9ki22PXAcrkDZiZUMeaQVd+hIsVaG4UOMskLWyRQ0CcBK/IkcnJY6ZBU2GR5hIdIygXr
         YOypsW6hl0JVbyLa3WTg9k5HJGdklbF+f3ztjVXGRC+5eNEXLWUytuhDeSwwlCV7RM2q
         pmmzZ3WOo7BgpjT6iNK2WbBZoDJUnTVw8Fz+5AtnWMMcSHu5ZDujp44P1JlZDH0hptaU
         TH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730665728; x=1731270528;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uR3bQiyQsWE+imgP0v7xMKesdYi+ADxUAn0ABjg2cJ0=;
        b=pDBKKyFpbL0GwnWmk1hoSvbDKOwBQEPjDlrExqaG8G5fmNdYNfPLKvLqvWJsN15Xtv
         d08ButieylZ7RXO6p8mXhaj+wGzYU5nf/leF2WzGrwWNUX/6RCQBFxQUHlN5EBqW3i1s
         pqd/gyotOK8dm36LhBu0cRRP4+f/VIV3hxUr040jZGvqQHc3AkYyUJ6tkUy2+J5gJhID
         y8iD1dWMiXXikeS/L7+YOlXs7//58xTukw6lHvBKA7zgLZ1+XivZxiNlT5TC2cnbIh6q
         WrFo9FcCezjtw42bUTK1oRlLoOGSZbXfgUwg45XGQ0PmoSMynbYROgPsEKQa1DVD2nzE
         POXA==
X-Gm-Message-State: AOJu0YwO4VXFc7eMvCbq4tWi/duBCn3ROR6YHdr4LplnA/5z9lEHKxA2
	00ITgWcdT7ks91lUBhz76BWgGYjQ3oCuk/+W57LShUvmhx7MynjzAbxg6pbXHV8=
X-Google-Smtp-Source: AGHT+IHn7v+hi3JfZcXDAgPtze9j62SajymeGPaGavndH5Gn3jUaftRhTAjkGcfsGyyFHeSnTme+PQ==
X-Received: by 2002:a17:907:948a:b0:a9a:238a:381d with SMTP id a640c23a62f3a-a9e3a6ca29cmr1772152266b.52.1730665727958;
        Sun, 03 Nov 2024 12:28:47 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e564c4f45sm464146966b.71.2024.11.03.12.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 12:28:47 -0800 (PST)
Message-ID: <88b9aec2477581faa7fbcbfbbf6040217c2a148c.camel@suse.com>
Subject: Re: [PATCH v5 12/23] multipathd: split check_paths into two
 functions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 03 Nov 2024 21:28:46 +0100
In-Reply-To: <20241015032835.2693247-13-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
	 <20241015032835.2693247-13-bmarzins@redhat.com>
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
> Instead of checking and updating each path, the checkerloop now
> starts
> the checkers on all the paths in check_paths(), and then goes back
> and
> updates all the paths in update_paths(). Since the async checkers use
> an
> absolute time to wait for before returning PATH_PENDING, only one
> checker actually needs to be waited for in update_paths(). The rest
> will
> already have reached their timeout when update_path() is called for
> them.
>=20
> The check_paths() and update_paths() loop over the pathvec instead of
> looping through the multipath device paths to avoid having to restart
> checking of the device paths when the multipath device needs to be
> resynced while updating the paths.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

