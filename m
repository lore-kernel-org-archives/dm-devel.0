Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EDA1846
	for <dm-devel@lists.linux.dev>; Thu,  7 Dec 2023 00:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="bWNfkj8Z"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-dae0ab8ac3eso460640276.0
        for <dm-devel@lists.linux.dev>; Wed, 06 Dec 2023 16:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1701909423; x=1702514223; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ku2sfUBBqRmjOusEjPPKSg3scPnZYVUEi+HsErMF7+A=;
        b=bWNfkj8ZkULN8l3rA9255DSRjcpPy4kSafU7efHQHUTAJ2fqeWWnyaH5nLsJZz4fXH
         CNNtK5l/JKAycxYnhwVdkRKbmt/hTDf1Wl+9colnHSr22m8PFsbQax0bEzH158dtDql0
         Ri6+qVVdKJfqx8bN77uTcXEKifElGp08dXl3fzlTm20rxUwtt0ssVHqTJrzQ8h7HUWdk
         rRXQNoGRT0cGqxdwt4AXcI3TM4uT9M2np/jeke3OySxsxw4kynP7pZpC0+nza/gJ7OoE
         79DmUo/62OCsgJ7ytkUAmKiVDYqAbM6Uey/lEcn41lsaxt47SBy8TU+n055ON7n4mu8C
         g25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701909423; x=1702514223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ku2sfUBBqRmjOusEjPPKSg3scPnZYVUEi+HsErMF7+A=;
        b=g4DTvEQE6YNAj5utg0Z6pLcrbNWTg/3aelzpR74BNTRzyskb6MFkrZvxC8ps0qAjpU
         z0fLMn9dr2rbggi3YEorY4ysS6r474u65V4bgiGVPZwcYjoDb5rbVi9ZxQE5AfJNHij5
         1vAcIeBnCn1Mx+NifAguoYpab6JGXjnMPFnUFLeVlOK7HhbYhmyPlInVOHdT4xvA8yfi
         O+0W0iLTydTfAFMosP45ARzsEOyN/hIcAYnKoQRxY0bA1Z7X3qNFtJGrvF1N72hnkP5k
         2umJr6LG0E6yj29NNwVjhfjD27LlEmd2RQOGNX55DD1L9AsQSri0lOOEa8MG3yb0N8Jn
         irNQ==
X-Gm-Message-State: AOJu0YwvjGN9epIDDULsO14i/Qt+AEpdWqqmCtNeVWSmaGkmBzauE26p
	Y9FYT7BZ1BN3TnjYLVgRS2GY2yF5+C2oKPQxfaCh
X-Google-Smtp-Source: AGHT+IG1iYIFG177+3bvYtnhfemiCuwpFKgg3syUJq0tO2kQMOa+CZIi7OJOUpuM/HHKxu3GBd4bnBcpq+XxZYKLOIM=
X-Received: by 2002:a25:7714:0:b0:db7:8141:e65b with SMTP id
 s20-20020a257714000000b00db78141e65bmr1716451ybc.64.1701909423446; Wed, 06
 Dec 2023 16:37:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231206060629.2827226-1-david@fromorbit.com> <20231206060629.2827226-6-david@fromorbit.com>
 <CAHC9VhTP3hRAkmp7wOKGrEzY5OXXJpnuofTG_+KdXDku18vkeA@mail.gmail.com> <ZXD+F5N/3PPSGTya@dread.disaster.area>
In-Reply-To: <ZXD+F5N/3PPSGTya@dread.disaster.area>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 6 Dec 2023 19:36:52 -0500
Message-ID: <CAHC9VhRNS=DvbL_sY5Vi+7twd3uV+WhACaaeJMsBUTYmhjxjVA@mail.gmail.com>
Subject: Re: [PATCH 05/11] selinux: use dlist for isec inode list
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-cachefs@redhat.com, dhowells@redhat.com, gfs2@lists.linux.dev, 
	dm-devel@lists.linux.dev, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 6:04=E2=80=AFPM Dave Chinner <david@fromorbit.com> w=
rote:
> On Wed, Dec 06, 2023 at 04:52:42PM -0500, Paul Moore wrote:
> > On Wed, Dec 6, 2023 at 1:07=E2=80=AFAM Dave Chinner <david@fromorbit.co=
m> wrote:
> > >
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > Because it's a horrible point of lock contention under heavily
> > > concurrent directory traversals...
> > >
> > >   - 12.14% d_instantiate
> > >      - 12.06% security_d_instantiate
> > >         - 12.13% selinux_d_instantiate
> > >            - 12.16% inode_doinit_with_dentry
> > >               - 15.45% _raw_spin_lock
> > >                  - do_raw_spin_lock
> > >                       14.68% __pv_queued_spin_lock_slowpath
> > >
> > >
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  include/linux/dlock-list.h        |  9 ++++
> > >  security/selinux/hooks.c          | 72 +++++++++++++++--------------=
--
> > >  security/selinux/include/objsec.h |  6 +--
> > >  3 files changed, 47 insertions(+), 40 deletions(-)
> >
> > In the cover letter you talk about testing, but I didn't see any
> > mention of testing with SELinux enabled.  Given the lock contention
> > stats in the description above I'm going to assume you did test this
> > and pass along my ACK, but if you haven't tested the changes below
> > please do before sending this anywhere important.
>
> AFAIA, I've been testing with selinux enabled - I'm trying to run
> these tests in an environment as close to typical production systems
> as possible and that means selinux needs to be enabled.
>
> As such, all the fstests and perf testing has been done with selinux
> in permissive mode using "-o context=3Dsystem_u:object_r:root_t:s0" as
> the default context for the mount.
>
> I see this sort of thing in the profiles:
>
> - 87.13% path_lookupat
>    - 86.46% walk_component
>       - 84.20% lookup_slow
>          - 84.05% __lookup_slow
>             - 80.81% xfs_vn_lookup
>                - 77.84% xfs_lookup
> ....
>                - 2.91% d_splice_alias
>                   - 1.52% security_d_instantiate
>                      - 1.50% selinux_d_instantiate
>                         - 1.47% inode_doinit_with_dentry
>                            - 0.83% inode_doinit_use_xattr
>                                 0.52% __vfs_getxattr
>
> Which tells me that selinux is definitely doing -something- on every
> inode being instantiated, so I'm pretty sure the security and
> selinux paths are getting exercised...

That's great, thanks for the confirmation.  FWIW, for these patches it
doesn't really matter if the system is in enforcing or permissive
mode, or what label you use, the important bit is that you've got a
system with SELinux enabled in the kernel and you have a reasonable
policy loaded.

--=20
paul-moore.com
