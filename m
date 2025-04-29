Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620A32472B0
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 20:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745956814; cv=none; b=X1FZuXY4KgZy9SqvpNUa7fI/9IXV7FTsRGDRBz5Ki1qy+Q8a1/AfcR1ISEe1t33B9dmWlYu2dOAw14OnO321CD3YUzFEpXqC56xpi2wMVlqZ+a7jUgrFgh3EIaeAAqSGW5Tw7ky60LIAUECJC6trxoiHomxi0QGDdDWO9Vk01fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745956814; c=relaxed/simple;
	bh=Ce9jSDPmU0Eo+UUz4XDpHFi5jPgG8Nv5X/hH+FzFkmg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X/TEUNzlstMfDRuy0dNzJ2sjBAXh4iiaiRcEf9sL455DJN3HWzzhypBGnW38RyAyOSNurFnltk3VbceX4u/qKGFqQjWYF6cRkdamenhiVh+XiDC4k89YOXo+QeRVbgVUfdT2Et1sD55RXe2fiWv5K7gQIAsR1a0QOEAmLq71cPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L4Rj7NXJ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L4Rj7NXJ"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cf06eabdaso57553475e9.2
        for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 13:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745956810; x=1746561610; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ce9jSDPmU0Eo+UUz4XDpHFi5jPgG8Nv5X/hH+FzFkmg=;
        b=L4Rj7NXJuoXFr9+u7FxyXoCJDZzqjNh/WBvWYYyYlqEM3XcIk/A+fFhyjy2wyFu1Uc
         mqYpNoHrb+L8nqrIAsBWYaBdFhtnPedJ/XpbfXMAwnbkJRzKegR3EdgpiiFVPzS+s6ry
         xEmtoOs3gsUlQCLXS7wV4kz/OerXC0AHwjBDLwUwfGhKJ0ROUlr+MaExGCsww7YcfBrD
         qLJtfkj/H/XfL4wNQQjLWV+a1rdsCVy6bg+XaM/UdzY6TBPcaak6g7wDG39VuTLxtyMN
         7u1+fHgDgFWawxiY12dn6pep40raWZ8gHa9WaWaIH+MB74f3TigO0bBv5PwboDZ6IBml
         7YDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745956810; x=1746561610;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ce9jSDPmU0Eo+UUz4XDpHFi5jPgG8Nv5X/hH+FzFkmg=;
        b=Ff0ZcxTVxjVQYGNmK7QFBFig5zEwRMGGb7sV0pkffd0x3xuRkcutDjBHaPz5qOQ/PM
         AHRIvNc6yL9H1ee9pUHS0YG0R5yZ/yIzIqIrGl0ApULQ9DGZApH3PgRM3K0v0e92arcJ
         o7/AscEOlh+16+MvTbyd0J+XFRNfnvfd1sBLBYaBX6IeZUFQ8vYNkcwYkyy5cEetDS+A
         D8kfRMgX62opRnnSowdK9buJKbQguetHOVICZRRMfVVS2r31HniznWMfzG4wK7r5kYmR
         Xv1OXUUPPqdjYBArRFsWPOmkVVC8LXwPy3I5taaTEDMa1A2pefI+hdVqMrrDK5RO5oKE
         juDg==
X-Gm-Message-State: AOJu0YwejNeU66H4DafX8HYM+8PMgMMckdtimkJ0O2lSM5nQJP0Int1n
	7FDgZFHqyH8MxhfA+zlexbnfMr2kXmyycVEB1SaU8yKfg5RYnyNxkU4XolDj1Is=
X-Gm-Gg: ASbGncsHSmFiD43Vcbrl2f3iZwD5qpnP4+vDldRrfwQ681Qpz9AZCdrz63M59XiXzbx
	DRgMOh5zkMH01/7gmLJZf3Kcea0/hRy3va2Ox8X2ik0QeGBUC7/O277A1Z0lLnD/rg8R5gIGQ3Y
	gunwWo+yJtWhZyce9JujGBxyyGW65JzIBM8edxfnlx9Cc7CC3a1SKPB/1Ibce1tAiTp8gyBI6//
	fS3/pH7b+reD/quBl3a77nbEDWbfe6lE/pje1ck8zlfVoR5roRrhd45CmcAavYSy13uA68GNxZt
	z4m5cPmPo1PZs3CPHz2vzLOv/Z78m/jQnTfKy8WqUYkedZXDgZVmm51QT470dsOs75NiDM3yD0l
	NbFVvV+xtglFWCt9E2M5bX/sh0x0rO3c6n1aawCF6sF7eRHmhm/Xb4BzP27UX10hFoVkvlk22DZ
	k=
X-Google-Smtp-Source: AGHT+IHCb1wi6HJFiaIl6N39Dra87Qq2aKc660vUFw03yJyRMRQpkNk6M/A8fRYmIYJmYl82rzUwEA==
X-Received: by 2002:a05:6000:2cb:b0:391:3915:cffb with SMTP id ffacd0b85a97d-3a08f7a3bedmr594904f8f.43.1745956809591;
        Tue, 29 Apr 2025 13:00:09 -0700 (PDT)
Received: from ?IPv6:2003:de:3740:fd00:677a:2a06:a366:3993? (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441ad813a64sm26480945e9.0.2025.04.29.13.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 13:00:09 -0700 (PDT)
Message-ID: <e18bee85edf64a1cdd54520018023212db994dd7.camel@suse.com>
Subject: Re: [PATCH 2/2] multipathd: disable queueing on invalid multipath
 devices
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 29 Apr 2025 22:00:08 +0200
In-Reply-To: <20250428214514.1905327-3-bmarzins@redhat.com>
References: <20250428214514.1905327-1-bmarzins@redhat.com>
	 <20250428214514.1905327-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-04-28 at 17:45 -0400, Benjamin Marzinski wrote:
> If the multipath configuration has changed and a multipath device is
> no
> longer valid after a reconfigure, disable queueing on it before
> attempting to delete it. This makes it more likely to be deleted and
> if
> the device isn't valid, then it there is no defined no_path_retry
> value
> for it.
>=20
> Fixes: https://github.com/opensvc/multipath-tools/issues/113
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
