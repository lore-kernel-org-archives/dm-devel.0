Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4726144D1E
	for <dm-devel@lists.linux.dev>; Wed,  7 Aug 2024 19:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723059778; cv=none; b=g2t3cAJcV35Fn7XqPhEQ4AvRcv5YNaGbAsK6D4Bp2G1G+Wf1YflmtMWw34tCLrwrNXxv9Rr8emTmZSUYtyeLP5yE46tUTX/0qgdWhCK6Ikvfsm8DheNy7Ov/s0DJc5agFnyGqM4+GLhmSFB6mxx5/Zq5LpbTPzRrZO/0KdmliJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723059778; c=relaxed/simple;
	bh=4vWmcMOGkkyE6SpKOg+lxuJbBZmqhBwk93+K8cVoiVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qg+wrU3SrY5imaI61+2Qc2+2ynlQik5uaauJEulqlhaL7O2PwyIIzT+B7r3zAnfnQ3KHLplk5/UdQYF7iTFD4bwA5GJLQTgM/L7c89i/8xXgJsZPSuaTYqDejOsX+plkpY4jKlooLF4Kmiw7xNLGjG5VZu5WkqP2UjwpztttrVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=ZWGLl+ZK; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="ZWGLl+ZK"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-dff17fd97b3so173644276.2
        for <dm-devel@lists.linux.dev>; Wed, 07 Aug 2024 12:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1723059776; x=1723664576; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ti+dWnafsTGNMHs+vxXfaBVPCpOMl1fNQUR/dBh5t54=;
        b=ZWGLl+ZKZOR3DNZEDgsVkUPY0p5KmYqu+GoSjC+ENdYOhcGDOJJdTRxRfpgBT0Z0oI
         nhUiskUFt4Tqrx05i9X1S0AjmB+AGqkbUWu9uRuUI+xPjBrnber+n7MTKQtfR7UqxklL
         7GucywtkfYApNNmwxELOOweSXnR0VK9M5mcjffkgrt+aKuVFRGB+liD2S3C0w/v5kta+
         Fcays3B5IdCAcFRzcsn8cMP7qJo1nM0vjDmmc9BNuZDki5tYf97HEnSg0cqsZEdYvSxZ
         RSg02/3RB9yufdal9t+NzG3PO34RZ+ZprD1p+5nKVgU+oTJc+w0+HM39EwC9PfTR6wGR
         /6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723059776; x=1723664576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ti+dWnafsTGNMHs+vxXfaBVPCpOMl1fNQUR/dBh5t54=;
        b=fWHctZav2GULBQcne4IkJItvH0pY/u2Tq0eYhecCDOueWU1Fe4CSbOIhgRvPokKwCN
         OqJCVnxgTzmSIix+r0QjiRfCzv7iySTPcderTK5LlohnyNSHaoJpnw+bmj6EXmb06R/4
         BKP0dgk7EqLBSyn5xpibSV8Q9Eni5UWgNias1llo0SQxMuMMnqeCH2LN2pSdKu5jORg8
         DI4d1UnxpRNIvV5r7gtptAnwZI/9KhScX869/NQe5yRA9aaC68Ao/+w/JL7mjtRWav5V
         0dt3fjnn8QT55/WvYwJ37WiotaxMzTmOuiWcZ6zIenwOce6E45x4D5UCtFyW2KHkMvTe
         BanQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyFyrjrExoGIb97l2usEwODx7NLPDQ3g/PBejfahxYTkr5h9iDLZbD1eFg6RywSRfsJsWELhG6Z1ntHb+DUjrXIz0pDaLj4xk=
X-Gm-Message-State: AOJu0YwYFNXcGFONDiq6nT+5v0r6+iguoy3JYrREZw/1G9Cd7yx/n/AR
	tdZWUdWqb1YrZ2RNcJdxe4wrFpzsQC2SoW3P5VoUwCpezcquQk7eEpq/l82cAaTRUZHk0wz9Oga
	MPgK0OEDX8f+GPy7R8q4KKC3W3HlIaJ3cLWHX
X-Google-Smtp-Source: AGHT+IH0uDMTEvlhrjytzwDCCXqiKRWy1dc9NB4WG2rHn2putvbgMZXGt7BbJfYOpwZgKPiHTdtB1n+xOLBh+e8QgUw=
X-Received: by 2002:a05:6902:2b8e:b0:e0b:6039:dea with SMTP id
 3f1490d57ef6-e0bde4ad354mr27003143276.40.1723059775981; Wed, 07 Aug 2024
 12:42:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1722665314-21156-1-git-send-email-wufan@linux.microsoft.com>
 <1722665314-21156-21-git-send-email-wufan@linux.microsoft.com>
 <de7857fb-63d9-42fc-af1e-12ffcdfcdda8@molgen.mpg.de> <CAHC9VhRmcReVM_Le5bYor2deotnSe4OT08UYhL6xhiKCu0+3kA@mail.gmail.com>
 <5880e801-e896-4bf0-9a69-2cf5acb51ec3@molgen.mpg.de> <080c93d1-9c02-478f-a0be-f4bd3869c1fd@linux.microsoft.com>
In-Reply-To: <080c93d1-9c02-478f-a0be-f4bd3869c1fd@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 7 Aug 2024 15:42:45 -0400
Message-ID: <CAHC9VhTNTqK5Q446nQHcbxnV6cakAg0NEnvkvs4Tai+4UXOuAw@mail.gmail.com>
Subject: Re: [PATCH v20 20/20] MAINTAINERS: ipe: add ipe maintainer information
To: Fan Wu <wufan@linux.microsoft.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, corbet@lwn.net, zohar@linux.ibm.com, 
	jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org, 
	axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	eparis@redhat.com, linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 7, 2024 at 2:01=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> w=
rote:
> On 8/6/2024 9:48 PM, Paul Menzel wrote:
> > Dear Paul,
> >
> > Am 06.08.24 um 22:54 schrieb Paul Moore:
> >> On Sat, Aug 3, 2024 at 4:15=E2=80=AFAM Paul Menzel wrote:
> >
> >>> Thank you very much for your patch. Two nits, should you sent another
> >>> interation: A more specific summary would avoid people having to look=
 at
> >>> the message body or diff, and `git log --oneline` would be enough.
> >>>
> >>> MAINTAINERS: Add IPE entry with M: Fan Wu
> >>>
> >>> MAINTAINERS: Add IPE entry with Fan Wu as maintainer
> >>>
> >>> Am 03.08.24 um 08:08 schrieb Fan Wu:
> >>>> Update MAINTAINERS to include ipe maintainer information.
> >>>
> >>> I=E2=80=99d at least mention Integrity Policy Enforcement. As you not=
 only
> >>> include the maintainer information but add a new entry, I=E2=80=99d l=
eave the
> >>> body out, or mention that a new entry is added.
> >>>
> >>>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> >>
> >> Working under the current assumption that a new revision is not
> >> needed, I can fix this up during the merge.  Fan, other-Paul, are you
> >> both okay with the following:
> >>
> >>    "MAINTAINERS: add IPE entry with Fan Wu as maintainer
> >>
> >>     Add a MAINTAINERS entry for the Integrity Policy Enforcement (IPE)
> >> LSM."
> >
> > Thank you. That is fine by me.
> >
> > Kind regards,
> > Paul
>
> Hi Paul and Paul,
>
> Thank you both for your feedback and coordination on this. I'm good with
> the proposed changes and appreciate your efforts.

Updated as shown above, thanks all.

--=20
paul-moore.com
