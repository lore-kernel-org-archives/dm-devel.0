Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51044257D
	for <dm-devel@lists.linux.dev>; Sat,  9 Mar 2024 01:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709946871; cv=none; b=ka+94UQkKTU1Og81pVoW/iaxQIWNz/vEIdBqNrRsKzIAoaMv89wNfXaXbCuS8XRXZx5ZfQsql4uCUC++Hz9U9hNFDnt5cWYBKMKFnfg5jw8yK0oSZSpNuyoCXKNpnVKQIe0RuG7ZER165fQzwMk3GjRz8X621IJ1ku0qZmBnlWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709946871; c=relaxed/simple;
	bh=PVSSW/TRZScbGAXptUtzNMhjOI0JAjP3o2LHf4YtFlE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ufZyJZWL/E8Tu+Y7TOfR3POfg4Z1BJh5pv5KpjavKrUSVf1zpgrfueCRsQhj7gboE1uXJEe071keJWfjo8BKsxyXIazCxWhtUFQuNi8Q3c1nYHIKPi9MuptStJezqSLmhJMOy0fcwYo4iAr22NnKANlIsb+M4ouifCYb4ZvvY18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Qdr+co0L; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Qdr+co0L"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-609fc742044so21169727b3.1
        for <dm-devel@lists.linux.dev>; Fri, 08 Mar 2024 17:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1709946868; x=1710551668; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPz2z6DvnJxq/mvZY2AzEM7nepXgQps0sd3FnWYy8AY=;
        b=Qdr+co0LjsHLewrzFJxi6ShbicCEqMLAg5t8ayPFNx3bL9DmH+Un93W5s0yum87dlA
         mRUxM0Uhy1tyuwe7YT77Sa2J7LytHZ0CMVBhRtKweRJ1PQd3ceDU270En5prNK+Xu+v3
         bUJvbtIz0TD7PqWH+K/rr+Xg3eCcuShI57htZAIRscgWM6tD5kcFbgBkLMFYYpO+8att
         gQinebisAUuS1mVHD5FZRkiUKy2tGFpXxMcQrH+9ax7C5TV14vQMboGXS7R/weNDQbN/
         vF5GirrqlJQ3PHQGCvsTOz/v2jVMise7dvhhWVJtwxyj5//WURcmwGT1fp3PkGgRMwsp
         9lFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709946868; x=1710551668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KPz2z6DvnJxq/mvZY2AzEM7nepXgQps0sd3FnWYy8AY=;
        b=a2GzXIXWmjHQJ/YBqKPCeI8jp9ytxhtbjnAEvR2KcDHuGyqm4qiVIvoXs3t1YHKfkC
         g6Wm4ss55TLk+bsZIRTZQGNkmpS79gBqvz+IRy1V0fYw6r6jCFa+weHJMebmmdArHPnC
         5eyPIsmxo0j/OBCyfsjnrk1CUL5eTkVs/Vag1Lv6WdqxfFMqLvT7wjPLH4Wazaukm8l+
         FUr0klXqMBJQ2M++ocPWnAnFjoye33jZO294eKVSYBQPsqtCxdEVutmxmqirrHgGyYn7
         D6rvlB7bcDxJJagwK0hGKO88NZdIN6C56of72f0mhCzE70ku2Q+Q1Z1lqSve6JQoHVjw
         fYig==
X-Forwarded-Encrypted: i=1; AJvYcCVAIeE4b+73psDB45vVNqvMt7Mw7K7atLtFeksyspJPgW12JcYAFtNwW4zn/LC4WkEZDBJ8r214m9X6sGPA8NdKnQ0+inMn6Zo=
X-Gm-Message-State: AOJu0Yx0GcV9Nm5mVfpDPlXq2d/Xl3PWrMPbh4n/Z61YxEVKsnQ57ju0
	NkRoO0YFn/Q2aYeWYLCGeAG6EBHlCfU1J/u4Cl5gNwiPX4NIRt2ryG0dLgpXfVv3HZvKG2qYjjJ
	YhKQgIaNRb6gDhCSIfhqOmPb12nW5PvsP9rTy
X-Google-Smtp-Source: AGHT+IG/iVw0xp4cUGbrbuHW4JP6YIUG2WhfFnWUrnT+aZkEjbYKTgvQfRu4/7uLG7cpfDOqG4dr9VoK5RFcwZhesog=
X-Received: by 2002:a25:b227:0:b0:dcd:1043:23c with SMTP id
 i39-20020a25b227000000b00dcd1043023cmr780907ybj.1.1709946868255; Fri, 08 Mar
 2024 17:14:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 8 Mar 2024 20:14:17 -0500
Message-ID: <CAHC9VhQ90Z9HbSJWxNoH20_b92m6_5QWJAJ9ZkSR_1PWUAvCsw@mail.gmail.com>
Subject: Re: [RFC PATCH v14 00/19] Integrity Policy Enforcement LSM (IPE)
To: Fan Wu <wufan@linux.microsoft.com>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, 
	tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com, 
	snitzer@kernel.org, eparis@redhat.com, linux-doc@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 6, 2024 at 6:34=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> w=
rote:
>
> Overview:
> ---------
>
> IPE is a Linux Security Module which takes a complimentary approach to
> access control. Whereas existing mandatory access control mechanisms
> base their decisions on labels and paths, IPE instead determines
> whether or not an operation should be allowed based on immutable
> security properties of the system component the operation is being
> performed on.
>
> IPE itself does not mandate how the security property should be
> evaluated, but relies on an extensible set of external property providers
> to evaluate the component. IPE makes its decision based on reference
> values for the selected properties, specified in the IPE policy.
>
> The reference values represent the value that the policy writer and the
> local system administrator (based on the policy signature) trust for the
> system to accomplish the desired tasks.
>
> One such provider is for example dm-verity, which is able to represent
> the integrity property of a partition (its immutable state) with a digest=
.
>
> IPE is compiled under CONFIG_SECURITY_IPE.

All of this looks reasonable to me, I see there have been some minor
spelling/grammar corrections made, but nothing too serious.  If we can
get ACKs from the fsverity and device-mapper folks I can merge this
once the upcoming merge window closes in a few weeks.

--=20
paul-moore.com
