Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A413905EC
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784314692; cv=none; b=YWE4j8NXeOub7neWB2V9ZBSSzeHMrT8Vy4P2G04WWQSIyrlkIg1uYP7WBTZhPZO9OFzos/u0UXE1uk4kuHOURMM0BSaW5hzt+FjZOk8wGLCxlQMtO0MG6I2/vs3Pfp7gw0KsHYchokBOaUzb7KWtGTAav6v3rpZE0n9nWpG8KTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784314692; c=relaxed/simple;
	bh=H1niux4ln6EXp5snoP3rxVDA6lNWxV3mEEb/01ea2x0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OxMOvvzjhf1EwwHjCtz8TllN6R1T/oINSA7nDjIUkvKbUdXXy9OyCZcIkstoRmF+DFn+ffdR/haCPi8wvMskBA7S6zhk6UB93ZwoQfCwP55Gr3gA+TkHfcgnDZQN7wKAcyJsdaWEF5HypQUJyVPGg+AALz3qkVbjV2Ohgmd9nYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VWsyWzxN; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VWsyWzxN"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47df6a5202bso5615124f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 11:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784314689; x=1784919489; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=H1niux4ln6EXp5snoP3rxVDA6lNWxV3mEEb/01ea2x0=;
        b=VWsyWzxNcU7qHanoe8mIfp+pwxjI92wQVYb4iNB5Wj2j5cZmbcm5ux0hYHsWd63GQk
         9bX+rIOI36qVxW3owK6t9TrOgLpwHALlRY4QWeREpT4DNnZ3r5NBCtRhJyCkL3qhVIGs
         sFX5LU6cCNixXpVzOKM3Nk9/+kQsJRre/eLwH/pkPInd+CKT2jXsaW/WLBbiNTr1dAAp
         4jkWgLhKnp8tyhGi/1A8t+p4IdOlMH3zg4U6G71R15rB2Tl8bD0HImiiy71z/m3n3/n1
         DRLTUPhEotReIYv4olQNAIF0mY3DGFLa7YIj9RWTOxDT2VDHZ1vzC4I06KMS8nKY+oxu
         9+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784314689; x=1784919489;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H1niux4ln6EXp5snoP3rxVDA6lNWxV3mEEb/01ea2x0=;
        b=FtZJlrQTHewD/6qKXBqO6Cb3ZTK1RmDnQugWpwacF0SYGt53GPNRy7qhFZhE1eP6nx
         YhxAl3SemutobXQPPNTUzuuQcjg7Y+GVY84NBId4TBOjZr9fTRdLi6eAnIfbHm3Ge60R
         sUkeY8whfpKK1o/WfBmE4jzXUqpPnSRA7Tp7k5/aSd5vzw4s1eETN0g2H61slby0u/P6
         PXW2G29Ap/7vGWDpvdkTwlxFuhgn7EhvnSJROFb/IBaBe6AwAaZUXstncp/mda20S82R
         TkaXWXFCDMgY1RFVL879VgB1KOAnngS1fBOYhJhr6Qhlw/PpaUd+Nt/9w/crPEdk2/2D
         2JJQ==
X-Gm-Message-State: AOJu0Yx5rVHnU6m3uJ/FUSnpUfvpGmtiIAC8rhgri/KSkWzWCo1xbSv4
	gv9pGkkd9Dnd3N4583OPxpZuv93N5+NAYukGPFg4x7Wy7HhrGPLCfVzq3GIhNLC+rd8=
X-Gm-Gg: AfdE7cmEhWCM1ovp+JfOUPcPOe9ulYbVGQ3dVUD4GlNoVJNjaTYPD/e4c4pkbA7JbvA
	Ezeela2Mfh/TZ8TvkF1gezZVsN+imZKML7JyTxqVugNd5aWv4ks3DOu4KZRpRkM0zIok/fxB6Jq
	G3i/ZJdTJ+5dl8lwqCdSGPGXNbRDwRor+caj/CEmEK1cncTEONHKhru2NgPdaerj6/dyNqwXxLg
	bS9SYcXPKZ1GG0fRzluhlJoxcxegZijwyJR3+0hskRh90OMxpxMWZpwaqvjceM35s5YbHNynIVb
	hwcXT2wN51vvQFVCzq1iVtIx1uR6ipXsoaymzA/q2qdd9iJPMBCUZyVDLZjjpYJG+XVHRW5y10l
	5i3R5lggvpcepN2cYgKy5Su5iNyWO0iqY4bM6xmeHuRIogHrS2xbMxjVxYcL42sRG2LofjACGyj
	+KnUazaVHenSAngBrJY8eQFkXYZKIyWP/MUftg3RIr/pJQC+rRYD01QK2n0ozKlIg8H25joGpyk
	b2ZrWtsW0cmjsDPqaPGGHwk0nVLTwE7+mNecCbf
X-Received: by 2002:a05:600c:4743:b0:493:bc4a:fb55 with SMTP id 5b1f17b1804b1-4954a508d60mr46297985e9.38.1784314689229;
        Fri, 17 Jul 2026 11:58:09 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549a3e56fsm67788435e9.5.2026.07.17.11.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 11:58:08 -0700 (PDT)
Message-ID: <20c43ff93c9145be8f618d9b3c07f916a274fd28.camel@suse.com>
Subject: Re: [PATCH 1/2] multipath: clean up find_multipaths documentation
From: Martin Wilck <martin.wilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Date: Fri, 17 Jul 2026 20:58:07 +0200
In-Reply-To: <0467af29-1ada-4d20-a5b8-acba5c166e33@gmail.com>
References: <20250307001034.3141833-1-bmarzins@redhat.com>
	 <0467af29-1ada-4d20-a5b8-acba5c166e33@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2026-07-17 at 15:27 +0200, Xose Vazquez Perez wrote:
>=20
> Could we please backport this patch to the stable-0.10.y and stable-
> 0.11.y branches?

Done, thanks for the reminder.

Martin
--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
