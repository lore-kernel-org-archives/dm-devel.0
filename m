Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9300D1C6B4
	for <dm-devel@lists.linux.dev>; Tue, 20 Aug 2024 02:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724122330; cv=none; b=X0tbkJ8BuSaAOxBoC0zArbFm2zQKHPzi7Am51WGLQGXV5RM/iz45RJhEje/8rYxKHN9khqMhlK1mNYTN3r1vhNFoN4MB+IWOJeQzvlA6QTlxfIukGmoJH+WpJpkGMM8iwBRCH2/g2O+y7yNHQ6GKwJphgEl3fSSlZTx19ZIhr1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724122330; c=relaxed/simple;
	bh=ZDr5ZbxqvFQWLLGyxixOKscT+4fsLzUr364GEc8bx4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vFcS0gjlFZfPtUBS0E23+I7Co+3Bn/StPpDay35L/bUVYXqfcfrjhIKgUFfqQhYuf+rnYoYDTNuG0KuxlZU9qeS/iXR+8wqWiq38Jxc+3x9kBm8jleXTI9OkPi2QJYnjfl/Y8vjMn6rqeEpORyku+AbVTZhdSg4PZNEo8iCPL5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=c3JxdOjc; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="c3JxdOjc"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e1633202008so1664356276.2
        for <dm-devel@lists.linux.dev>; Mon, 19 Aug 2024 19:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1724122327; x=1724727127; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMMqIhR8mNN7qbNLvHC3cSRq9saBfgJ6P2Pudx1fscs=;
        b=c3JxdOjctdUq0VFWEd1HVu35bhGlvnLt8lGsMjbHr8aml9bui6rFgp/atBc5jY7J8O
         J8Pts9AqOokh6TUrImva43b/aMyVZFP+qrnMvLiqwCA2WcL7e79keEAJKu2l1lRVgjPy
         f5LVwSNRqOlJkYCF0kqsAm91ukeKFxayvCRQa6mVDGcukk5p4hwjD0JyZ4q+dDDtqZGW
         mrQsouhU329H6kjP5j247xWrh6O/Kd1dtX1nO72PBwUS5zCCtYhlWoVDEjOMcI4MKyZt
         NNP7MpTKmVYMqq8ecy4AKllXe8tuHdbcuFbLM6wf1ikfSGeu2lRTN+unk4SMGIG5ht2E
         r8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724122327; x=1724727127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dMMqIhR8mNN7qbNLvHC3cSRq9saBfgJ6P2Pudx1fscs=;
        b=eSYtn34L683IOa69R9wFwdDcLn4jFBHgVF6ilmSYXcbZD22Mg0zSgg4458z9Jx7xWb
         WYHuygfcCssIe5+cz0awqxzDkDUXowfE4ESnvexjudxDDw1MakgCxQ0FwiBOEhX+dWF7
         Hsdl7oIcGG3BNNSBGkf4LHyZzzs9REQ9lb6ilgHWL48ZOJizJiUa0OAECuJ0W+1h26Qv
         JJm9SkFY8jFBfi9xxGpoHqL4Dm6vGtX+D2+apj7qX3rpGIUCDjPtjUOhCHsEemadiL9N
         O+p2XRUdb3BaYOCqxe10GYYRRnLEdEu5Bc7oCkOxh8Iz6a9cRuVxAYivEus5hLvtfjh6
         jN/g==
X-Forwarded-Encrypted: i=1; AJvYcCWE/7FqTGbNSBX7lQ7hVkuV9DPX2rOFqrys8ILYeq693B+7pFn37CNJbpzImi0Dba9UW5GFvCi0zQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx78ypLJx3Yf4d36FmVypTNhrokoBvZUinQE5xIU+NTApk9OAdT
	hwToraXwg0Go1dnYheSy9Z919wwSqR7nrk9jD7E0etn5sdzgZQqrjsctKBnOLROqC7pwDdsF0lc
	k6kobc8eHhR6M+S7gzHV5AlYsj2JjpJMJiWH0
X-Google-Smtp-Source: AGHT+IGx4BZUDH+LCtHEYeY3Jj6i77Krk/e4mCpEtrxZEdqLSGFNLBDOXv3VOnuXbn9YLa/m+2U6fa38CFBTVrK6h9g=
X-Received: by 2002:a25:d8ce:0:b0:e11:83ac:a024 with SMTP id
 3f1490d57ef6-e1183acaecemr11644146276.39.1724122327544; Mon, 19 Aug 2024
 19:52:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1722665314-21156-1-git-send-email-wufan@linux.microsoft.com> <CAHC9VhQ3LobZks+JtcmOxiDH1_kbjXq3ao8th4V_VXO8VAh6YA@mail.gmail.com>
In-Reply-To: <CAHC9VhQ3LobZks+JtcmOxiDH1_kbjXq3ao8th4V_VXO8VAh6YA@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 19 Aug 2024 22:51:56 -0400
Message-ID: <CAHC9VhR7CEBmzjnruFaHHpepYWSRu0bvPUxYk_jz7oXRS5yJUw@mail.gmail.com>
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

On Tue, Aug 6, 2024 at 4:59=E2=80=AFPM Paul Moore <paul@paul-moore.com> wro=
te:
> On Sat, Aug 3, 2024 at 2:08=E2=80=AFAM Fan Wu <wufan@linux.microsoft.com>=
 wrote:
> >
> > IPE is a Linux Security Module that takes a complementary approach to
> > access control. Unlike traditional access control mechanisms that rely =
on
> > labels and paths for decision-making, IPE focuses on the immutable secu=
rity
> > properties inherent to system components. These properties are fundamen=
tal
> > attributes or features of a system component that cannot be altered,
> > ensuring a consistent and reliable basis for security decisions.
> >
> > ...
>
> There was some minor merge fuzz, a handful of overly long lines in the
> comments, and some subject lines that needed some minor tweaking but
> overall I think this looks good.  I only see one thing holding me back
> from merging this into the LSM tree: an updated ACK from the
> device-mapper folks; if we can get that within the next week or two
> that would be great.

I've just merged IPE into the lsm/dev branch, it should go up to Linus
during the next merge window.  Thanks everyone!

--=20
paul-moore.com
