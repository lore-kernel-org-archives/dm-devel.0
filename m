Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65567170A11
	for <dm-devel@lists.linux.dev>; Tue,  6 Aug 2024 20:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722977974; cv=none; b=vE7GWZujhEENOCT4VI+er2AbYsHAxIJwxXUkC1YKrAMu4sJhq1zz1w1m0jfeRS+nBVWQG8SQIEyKQP3RH0GNbc1DUJdE5bScklcko8hznr0h6bKUsU2tjv07BxLRcOQZEwVkACnObDgLDOTdRW0hZSjZ6B2BFs1s/yuwwTxKTGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722977974; c=relaxed/simple;
	bh=qyUz9Qqv5k5SudOvCxQPX4RBki5RQXyIqfhgrvWKdyk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pjSUaT/CRBqs1986reTQIKiJs7ukoVRmnNAvCl6skQ3PLNFllXX+lj+thvHjYzTUuOgTqK7s1+u9/uJvKPefdUdRGCL89uK2dp2wpr8aD/ljpttaQ8Vk4Gctuu6D/AyGNOWLV/fPPNql61U71yEXGc/v9xFzKKsvzosl3lGozJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Bzs+lHYo; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Bzs+lHYo"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-65fdfd7b3deso11623347b3.0
        for <dm-devel@lists.linux.dev>; Tue, 06 Aug 2024 13:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1722977971; x=1723582771; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hqRA/CX/CVDKRMnMKUkE7btXGpws1I/eaVA/YpB62Hc=;
        b=Bzs+lHYoSpPH1AGzW3XS+axg8K+gj11RQITRDPJbE4KqQszGOLwGJOmdSaWZs9GF1z
         TchDMi9M3w761mMcUOTNjzir5jDFZxmC/t8mWPrMbW/aK38vxxPjbzR4+fzyCCFbyDf3
         rXSAjPYNxG9JrNqxtFZqYR9ECZDtrkO4XE3xpgyYs8lsHtoXKDAuGlVSx3bsJmkd3iK/
         g1liiTsXfS2gZJ9jUmmdOhZoshK8fbzwlWkOOT6+0iu0uJFwDgD4ZImmLZ7k4FZTICtG
         kIJ2R8WL9bLIoKLAqQwkmKOzv3Y1qlvq9mtsRdre8FCklJJEpBx810tUcqZaPy/3KxxH
         lbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722977971; x=1723582771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hqRA/CX/CVDKRMnMKUkE7btXGpws1I/eaVA/YpB62Hc=;
        b=KUON4bf5dHHiadtNttPG/h4JqJWXu8SCY5Hw8sf3apMlhscDTbvWGLKImTW+cFE8Np
         rLCmuaymq/inSMYoYkkT2Dc+cPf7Wh+hQp9xXAESJbFQN0cit47l1xYokchJQQtSgXe8
         LiLSJ3sHpWg3n4ametCiHS1Eh4yx2eqOOXYFD3Smg+d2egxuwk94HaDEoiJ8rDu3sZxi
         XXfoMJC0FZNv38wN/fn3WIA2nJ0OkGe/eEITnvyqe+cB2bZw11yLyCqqEwld+nuBWZ6u
         0n0jrWGxQROP9PzsuAgNX7QH0e9lMfCVwbfZXeqQ+aZldSUauoUM7RUhO0YdAqEiJF7r
         hLkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHW0BEhiyusmQimp5YbFcwerfcYJz5u8TfMYdIvN3oo0yh0BCww8aH/HYkC/vrX+6/Tq+mzNmzBxAfo19Oql/84k6DT+N75NM=
X-Gm-Message-State: AOJu0YyYKyOgZFZPQwo3TvSzgj/96eA2juKjovhL6NqjsuwwyRvUyvIV
	R6qqQWBVspd2ssvwHDZqZc9IuYuHf+SRubNFDhgHois+YrXoYYLuOaEzrvxQe2kqKZAwIqvidDS
	IrnlHovZMbLCYUaUm1J6060WKRlr133SKGqBs
X-Google-Smtp-Source: AGHT+IG+g9ZPIj3c+gMV8h9nbV6S0gFWlT866BH5MDCEFMia55H31Vc+W1m/exuwqdaE7fTnf6/iUgbwZyFG5W1FJkM=
X-Received: by 2002:a05:6902:15c5:b0:e0b:e2ed:b6c9 with SMTP id
 3f1490d57ef6-e0be2edba28mr17255194276.9.1722977971481; Tue, 06 Aug 2024
 13:59:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1722665314-21156-1-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1722665314-21156-1-git-send-email-wufan@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 6 Aug 2024 16:59:20 -0400
Message-ID: <CAHC9VhQ3LobZks+JtcmOxiDH1_kbjXq3ao8th4V_VXO8VAh6YA@mail.gmail.com>
Subject: Re: [PATCH v20 00/20] Integrity Policy Enforcement LSM (IPE)
To: Fan Wu <wufan@linux.microsoft.com>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, 
	tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com, 
	snitzer@kernel.org, mpatocka@redhat.com, eparis@redhat.com, 
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 3, 2024 at 2:08=E2=80=AFAM Fan Wu <wufan@linux.microsoft.com> w=
rote:
>
> IPE is a Linux Security Module that takes a complementary approach to
> access control. Unlike traditional access control mechanisms that rely on
> labels and paths for decision-making, IPE focuses on the immutable securi=
ty
> properties inherent to system components. These properties are fundamenta=
l
> attributes or features of a system component that cannot be altered,
> ensuring a consistent and reliable basis for security decisions.
>
> ...

There was some minor merge fuzz, a handful of overly long lines in the
comments, and some subject lines that needed some minor tweaking but
overall I think this looks good.  I only see one thing holding me back
from merging this into the LSM tree: an updated ACK from the
device-mapper folks; if we can get that within the next week or two
that would be great.

--=20
paul-moore.com
