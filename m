Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74738C156
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 16:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721059239; cv=none; b=IdUEaKDnobzvdAe5PyzPyeIndEI32wD7BmclEZf76opuhkzcnLaavHlPKBSBzDw3Juqg7ZFp7ajmrZV6p7yhtf6XTUcm5QdfK4SA8sebVNmFK/7rL92Bsn1Wk2W2zagnYGLH7BKLdx7FVtReas3HvjRCu1JRvz4XJPLJEcUXnsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721059239; c=relaxed/simple;
	bh=wDm4IFUP2Z6/jQXbyNuMcyRH03LklVpAvKsNMEWjkXw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kEOcQoZZpb3T9Yb7yVSZX+wo+Xe1kqlaxwMJ8XFs1cHI5KqKmYwlPgz7f8bqg5jl42fdbjh38Rq5nXwZZzcsfmqMbAAwJYyRDosVUi5bFSqGnltpzpr3fx7f72gBOea4zsE8hOfZqX8Hvkw62fBNthvc8JPiyC2sMlhaOLzKbV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RoFSNhTT; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RoFSNhTT"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4266fcb311cso31199965e9.1
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 09:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721059235; x=1721664035; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wDm4IFUP2Z6/jQXbyNuMcyRH03LklVpAvKsNMEWjkXw=;
        b=RoFSNhTT2Hxda0JooHBAqoACa3l+pWlGOfcKkzz++IZYzPIV65gXG911wla1VIlg+e
         c6BDEDrJ/KztK63Y3IyesOZ9qNZAbq6hHmZTdNiOTRpeLNyeNhdcBb40G6qGMMQq5ZWA
         61HDEPEWXts/Hjwpe4yMFcA/XzmwNSyjO6u8Y+nEAxLAYGXzvhaJxYp1SZeb5fXOBPRx
         OvLjyz7WpMLp9COVjD+ApxMsbfp5BvBL7iU/j1cKFFYiGYyGPWb4exYAyNgJBNGD7znj
         x7yiYebAVTX+ULrRRsxYwZmFNmqG8Dwfmxt3pknkYCIs1llX+zVo1hTFpHWXa4OFRFUt
         zQ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721059235; x=1721664035;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wDm4IFUP2Z6/jQXbyNuMcyRH03LklVpAvKsNMEWjkXw=;
        b=tOOc9NDRWCt/RZp+HGG/kVHwLhT5OUyiJI9C6dslE0UJ8AQfxN4zpl+07jZ72k8NQn
         e5k/vmtnYFsb6I2O5YMDdiLBdJeWKt6fzd9ANJUfP35UWbfKfhJiGcPSn22GjsDtht/3
         fFq6KPUimr4ns6t2gpuC4QyL/p5wKc4yu2KEc9HGHhwsuTkvC0w1Ml9ZzfOuhUE+cSua
         syzP64RsSHE5DdyuEep9mYyScR+U5EXTONNAYOhgvlIPmQpcmey0wONVn+HeOxedBvu0
         4KZul2+x85pZv/EGk/sia7dC7AfT/IXgWMZ65rlOcWBymESLAgXXx+790dSiwJbiKmHP
         nbMA==
X-Gm-Message-State: AOJu0YyETdxd7wt6OjTZp2zEFjZVlQs2aL51pYdVViir2Z7sdzcpyry8
	HaApJY0WtLza2MH26p++vKbCQ79Sk2908ShALHQWEab8AGZtwGswYvZo7L8lr9o=
X-Google-Smtp-Source: AGHT+IG93hxU/ebh1Nz5oRPF5FYN2Sbib5l73hKYNbiqD20RdMmI0hTkN6KCASxwvKHN60XmREYehg==
X-Received: by 2002:a05:600c:3d8d:b0:426:6822:855 with SMTP id 5b1f17b1804b1-427b88ce4admr378255e9.36.1721059234618;
        Mon, 15 Jul 2024 09:00:34 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3680dafb9aasm6764349f8f.67.2024.07.15.09.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 09:00:34 -0700 (PDT)
Message-ID: <eab659b313c56abfb6f6bb8780bebdf656cd2994.camel@suse.com>
Subject: Re: [PATCH 09/22] multipathd: set pp->tick = max_checkint in
 handle_uninitialized_path
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 18:00:33 +0200
In-Reply-To: <20240713060506.2015463-10-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-10-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> When handle_uninitialized_path() checks a path, it will either:
> 1. trigger a new uevent to initalize the path, in which case it won't
> =C2=A0=C2=A0 check the path again until that uevent is processed and upda=
tes
> =C2=A0=C2=A0 pp->tick
> 2. blacklist the path, in which case the path gets removed
> 3. intialize the path correctly, in which case it sets pp->tick =3D 1
> 4. fail to initialize the path, in which case it was supposed to set
> =C2=A0=C2=A0 pp->tick to max_checkint, but instead it set pp->checkint to
> =C2=A0=C2=A0 max_checkint, which never worked correctly.
>=20
> By setting pp->tick to max_checkint at the start,
> handle_uninitialized_path() will continue to work as it previously
> did,
> except in case 4, where in now works correctly. There's no point in
> messing with pp->checkint for paths that haven't been initialized
> yet.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

Q: I suppose it makes sense to backport this to earlier releases?

Martin

