Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BA628E06
	for <dm-devel@lists.linux.dev>; Thu,  4 Jan 2024 18:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V4+q79X5"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40d89105365so6878415e9.0
        for <dm-devel@lists.linux.dev>; Thu, 04 Jan 2024 10:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704393424; x=1704998224; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lZTmKmMwGe4C4FL60fYnRnXFjzczx00AKo/hN5YHIiE=;
        b=V4+q79X5iFbvQPCDXuH+uqmhUPbwzhhVfloWk1RMmNvJQ3GIstK/xy7IQSLZIHrmV5
         a1/R/8lUYZR0BDcC5jEJNZMgzj4Ec6zJelXadolE9KhK82iR5qV7miRR8rqSE/rnMvMD
         NPPIHJTNbI96zw4kWBnAkoeyfdFRgYBMwdA1xpVo7z8CA0inPt09ET0vcV0PzdrCFDgU
         cYeQUMEMZ13xvV/PrHtPOwRMgSjsuNCiknP6xr1S80PjO8aqDw7F+BfVlzHgMqIVwk2F
         zOszIJC10XofbTqGzvA7To1ksHX+2uBq7dmGvRZF1Loysqr50ag3V1h8AdcmyP4h3EQC
         666A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704393424; x=1704998224;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lZTmKmMwGe4C4FL60fYnRnXFjzczx00AKo/hN5YHIiE=;
        b=eaZxKwqy0QtALzTV3mR50ulHsZUNXIs4YOt7crGfZq9mHWkLx0/OElmc+MSP9VLhVs
         bA9+Iuo2XiDN/IIatTxqqN+a4Hbz4z+JblrUX3cn3v5M+KKOE2uUjygrDh8z+QjHhODA
         hGEu79G1T4NaIdz6ali3W+/4Zr7KSTpePRB0CNpnANSDWI3wkfMt54vgIkwEbm0q2ARl
         gbttt4SvPyFvOxrm5qI6tKmERVKFk7DvixRo/Ub4lwKUTgSBuJWNsoG/fc1dzSgseVEL
         CNer0XqT5ucVSSuGPYiifDHhRbxtlgQFjgXFD8hns+pWJJb9VCdrqsaemRoQQbmImIyN
         dFjg==
X-Gm-Message-State: AOJu0YxM6fcOLhCmZuJQxfFos3i76iQZYuWm8riVhmtrq9emeItNi5VH
	gDBFSg1YU6p1IOg8V7KCPIoFHWzRxJHlXw==
X-Google-Smtp-Source: AGHT+IH5glq93pS70FfbHEZN5NZOT//DwnxM3VRdcn6MR0FIC5lsfBEBAZQf3Re2AnsgoDn6prYSAQ==
X-Received: by 2002:a05:600c:3d89:b0:40d:85a2:40e9 with SMTP id bi9-20020a05600c3d8900b0040d85a240e9mr553175wmb.1.1704393424528;
        Thu, 04 Jan 2024 10:37:04 -0800 (PST)
Received: from apollon.fritz.box (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with ESMTPSA id fm17-20020a05600c0c1100b0040e350e4f75sm73308wmb.13.2024.01.04.10.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jan 2024 10:37:04 -0800 (PST)
Message-ID: <fb7896df0bbc14c6dbe1daee614e7221c024fd99.camel@suse.com>
Subject: Re: [PATCH v3 0/5] fix set_no_path_retry and cleanup commands
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 04 Jan 2024 19:37:02 +0100
In-Reply-To: <20231219225151.787521-1-bmarzins@redhat.com>
References: <20231219225151.787521-1-bmarzins@redhat.com>
Autocrypt: addr=martin.wilck@suse.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2023-12-19 at 17:51 -0500, Benjamin Marzinski wrote:
> This patchset combines my patch to disable queueing in
> set_no_path_retry
> when recovery mode has timed out with my pathset to cleanup the
> interactive commands. This has been significantly changed in v3
>=20
> Differences from v2 (based on suggestions by Martin Wilck):
> 0001: This completely new patch that Martin suggested. Martin, I've
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 made you the Author. Feel free to change m=
y commit message if
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 you'd like.
> 0002: This is similar to patch 0001 from v2, except the rational has
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 changed. It is still possible to get in a =
situation where a
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 multipath device is queueing after timeout=
 out in recovery, so
> we
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 still need to handle this. Since we won't =
have to worry about
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 multipathd flip-flopping the queueing stat=
e on reloads, I
> pulled
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 this check outside the PATH_PENDING check,=
 as Martin suggested.
> 0003: This is the same as patches 0002-0004 from v2. It made no sense
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 to merge 0002 and 0004 but not 0003. In wo=
uld just result in
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 making changes only to undo them in the ne=
xt patch.
> 0004: This is instead of my 0005 patch from v2. In order for
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 disabling and restoring queuing to always =
work correctly,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 multipathd needs to track the current queu=
eing state.
> 0005: This is a new patch based on some of Martin's comments on
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 v2 patch 0005.
>=20
> Differences from v1 (based on suggestions by Martin Wilck):
> 0001: added comments explaining why cleaning up the queueing state is
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unnecessary in update_queue_mode_{add|del}=
_path().
> patches 0002-0005 were previously 0001-0004
>=20
> Benjamin Marzinski (4):
> =C2=A0 multipathd: Make sure to disable queueing if recovery has failed.
> =C2=A0 multipathd: don't modify the multipath device on show commands
> =C2=A0 libmultipath: keep track of queueing state in features
> =C2=A0 multipathd: only restore queueing if it has been disabled first
>=20
> Martin Wilck (1):
> =C2=A0 libmultipath: avoid temporarily enabling queueing on reload
>=20
> =C2=A0libmultipath/configure.c=C2=A0=C2=A0 |=C2=A0 4 +--
> =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0 | 23 +++++++++++++++---
> =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0libmultipath/dmparser.c=C2=A0=C2=A0=C2=A0 | 14 +++++++++--
> =C2=A0libmultipath/structs_vec.c | 34 +++++++++++++++++++++-----
> =C2=A0multipathd/cli_handlers.c=C2=A0 | 50 +++++++++++++++++-------------=
------
> --
> =C2=A0multipathd/dmevents.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 33 +++++++++++++------------
> =C2=A0multipathd/main.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 7 +++---
> =C2=A0multipathd/multipathd.8.in | 12 +++++++--
> =C2=A0multipathd/waiter.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 2 +-
> =C2=A011 files changed, 116 insertions(+), 67 deletions(-)
>=20

For the set:

Reviewed-by: Martin Wilck <mwilck@suse.com>


