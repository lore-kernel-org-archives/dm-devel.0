Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6847186262
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 14:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560891; cv=none; b=RC/2fpxTBeAbHp9t+cTEq7/Hk7RqmNalPVd20K3VjElwavmEZOREiR/wf0WQP1j87Sq00mSNt+d3Ay8osBv7TYxrBGC5tr5SywZSFRSLZSNxdJscrmtmINNn7SiKSfi4cn9HiBoi4ORxCFSNMK4EvD5NNIZHbGxzyjCQ4y2M8Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560891; c=relaxed/simple;
	bh=v8MwNjiMDIImc+4oz+7j2Vp+8CxXv3XPlr5/PDbeySg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wq2bItIMO7YHtOeP3pOiFsfltN2vozwVhMYnT21CgjSt8dn7ito40XxBx7DmCZQS8u7+JXptowpQIX4pUmT2+dZCbmaw0QxO76FNqwFXqoTv4n2SAPsYkk9pu5d8YGMHSaDbullZFzUy8JyMX5SMNXFQDI2y6nG+QLnFyllBU4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FtIK+QCK; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FtIK+QCK"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5751bcb3139so10515637a12.1
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 07:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1716560888; x=1717165688; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v8MwNjiMDIImc+4oz+7j2Vp+8CxXv3XPlr5/PDbeySg=;
        b=FtIK+QCKDo2Y4iVps9bC314p2s5b6t2GUsqwmTNIqoVA8lk3dUjwwP7AoeKV6r2zo3
         kAe96Aa7r8j/ebGKQrvNZmJTspkrwDrWXRgzbKikhgn5gjQMBmno1e0a9UJFTcB8EK+W
         CqTkjEul3oq3HM/+B6qJmbjxzyoeffo+H250Q7GSVkVLUjvJdaOGcW0jNey1Ueo+0giM
         BckkqqWJKrZrFXgPc27+SQv24f+gWJ7M2Q6cWoK0Y02VHrR2RlPBWx4hKd+5nh0YL+Nu
         +Fglfy1C42XY9mak/e7hUyEq/x2qyvdVet+HHLenTCTD81GZ33lOa6aXXz3tiDIV7730
         iT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716560888; x=1717165688;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v8MwNjiMDIImc+4oz+7j2Vp+8CxXv3XPlr5/PDbeySg=;
        b=KIatovyhvTRTfD9ToGWOKuwPoE7yYtlWxxnrD6rHh95SsT5SgANoJgyZAJjPiBrAJO
         sVbIFY7pzlnyghp2wyxOC2Ynx9EKBzlVL8cJR0dL8qHD7hW/FCg7KIcb1EPcSSNI59wh
         1oCcWWNePV4bmFRqGdtvTqHcHgdCVk15WKWH1qaEPK6Ar4QLgj2WR1c37+9uPgiwzGVh
         lUJ/VYMm9SVIyB2VEQU1o1byFYGeQvEl+88DXPpQbHFxu6cWVC1lNd3VPQfHgGJtYHu2
         HyJT2koh8GUYoEyKlIsdvUq2b6qTRBjZDAJI14Db8AIOwh0/ink2axwp5rqMWoB4p2v9
         g11g==
X-Gm-Message-State: AOJu0YxmcoXSprcrKHE9HH7hGPcZCJbW41gOfYmumsQNNCgL8uF6VOJF
	6XbzSRFWlNfdljYqNjXZf/c97lZdRooKg8dIE3GeOaoyusG52/0PmY+qfri3XU0=
X-Google-Smtp-Source: AGHT+IE7AYBT8mgjFRnY9vjDSSTW7sO1u4y9uYNLl/TdfNa/F7DWDIMeMiIHAKEKQBJdJ6RzYTxB3Q==
X-Received: by 2002:a50:a682:0:b0:578:4b46:7ac6 with SMTP id 4fb4d7f45d1cf-578519be672mr1755955a12.27.1716560887700;
        Fri, 24 May 2024 07:28:07 -0700 (PDT)
Received: from ?IPv6:2003:de:371a:a400:e6fd:936f:426b:4ff8? (p200300de371aa400e6fd936f426b4ff8.dip0.t-ipconnect.de. [2003:de:371a:a400:e6fd:936f:426b:4ff8])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57852339ea7sm1799126a12.1.2024.05.24.07.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 07:28:07 -0700 (PDT)
Message-ID: <90e3ba2c2f1e8124bcf5d1f24f3d3a54f649f230.camel@suse.com>
Subject: Re: [PATCH 0/7] multipath-tools man pages: add missing information
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Nitin Yewale
	 <nyewale@redhat.com>
Date: Fri, 24 May 2024 16:28:06 +0200
In-Reply-To: <20240513173646.94424-1-bmarzins@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-05-13 at 13:36 -0400, Benjamin Marzinski wrote:
> This patchset is inspired by:
> https://lore.kernel.org/dm-devel/1673555329-9850-1-git-send-email-bmarzin=
s@redhat.com/
>=20
> It removes the useless pathgroup wildcards section from the "show
> wildcards" output and adds wildcards descriptions to the multipathd.8
> man page, along with some issing multipathd commands.=C2=A0 In the proces=
s
> of
> doing this, I noticed some instances where either the man page or
> multipathd wasn't giving the correct information, and fixed those up.
>=20
> Benjamin Marzinski (6):
> =C2=A0 multipath-tools man pages: don't assume multipath.socket is enable=
d
> =C2=A0 libmultipath: print all values in snprint_failback
> =C2=A0 multipathd: Stop double counting map failures for no_path_retry > =
0
> =C2=A0 multipath-tools man pages: add missing multipathd commands
> =C2=A0 libmultipath: change the vend/prod/rev printing
> =C2=A0 multipath-tools man pages: Add format wildcard descriptions
>=20
> Nitin Yewale (1):
> =C2=A0 libmultipath: remove pathgroup wildcard options
>=20
> =C2=A0libmultipath/print.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 22=
 ++--
> =C2=A0libmultipath/structs_vec.c |=C2=A0=C2=A0 5 +-
> =C2=A0multipathd/multipathd.8.in | 260
> +++++++++++++++++++++++++++++++++++--
> =C2=A03 files changed, 263 insertions(+), 24 deletions(-)
>=20

For the series, except 3/7 and 7/7:

Reviewed-by: Martin Wilck <mwilck@suse.com>

