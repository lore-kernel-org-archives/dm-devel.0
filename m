Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC396A8D2
	for <dm-devel@lists.linux.dev>; Thu,  3 Oct 2024 21:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727990616; cv=none; b=km2JhYDtW7Jbe3GbRaigt1CYhUchX0CHaWsehaB8JD2TCNHX7froLFfW0bOr3QUV/DRHzf04qZvBfub2ezSMuQv1PgonrieKpymvG27gi7fx3OQKR7fnhhzWaRz3iLix48hknAI97VVsOTCLA1kPp3BDFBJDbiI6xElVO40cVxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727990616; c=relaxed/simple;
	bh=9Da3BSzJ/QLVOFCLUUeodlxOnaNjcTjwo6x4Yzx86Yc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WmcXLsuf1ziF9IAWqy39AOq4Q6EavMY38zRkGbWghMoSfYs5uPy1hd4e8ttt6A7Kg1BT8P8g+Q/4Z0H82OY2VZfkFHYzg3Ofb4leiCG4PVNOxrg4ArZjDUPSV+dpZTmUI0eIDBAkUToP60riyLobOpoVFr+voxEQvRenB5k9r54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CsscV9Eg; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CsscV9Eg"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37cd5016d98so1056202f8f.1
        for <dm-devel@lists.linux.dev>; Thu, 03 Oct 2024 14:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727990613; x=1728595413; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9Da3BSzJ/QLVOFCLUUeodlxOnaNjcTjwo6x4Yzx86Yc=;
        b=CsscV9EgA3BiWVAPdcvFlk3rmT6AwHteNWvxNPKKgV+giE3c9AoWBX7tQaiKBg5dXL
         vzSFddDSKJh2MCXMwCj0/8s4Y0WEHJSWgZ3Q+jMRvrZRO9+xZd+emlxGkP1q5FynuENi
         3PPkO0EcmgMprGLbLkkFjRthOiEisS0n8w0d8xUGBU1iMxCxJVSQtwlxGtROdDUUvb76
         t5o0+k+tEaMptZw48b3QojSU5+a/iK/NA7oHPOdwRfqp7QgUlBbATFmYhERWytrYLV9R
         ybkpGTHsWOLSi56jaxJ6daEcm4VMWuTqnHGAKOfYa8+TlFPC7iIvH6emVYoYDynjsGnT
         BN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727990613; x=1728595413;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Da3BSzJ/QLVOFCLUUeodlxOnaNjcTjwo6x4Yzx86Yc=;
        b=qbJJpGI95E8SFAxwzC2zgaLf8Np5rbdUxn2DDroznogJdEjtkUDIt4HuGFr/ugAugl
         +PS2JVdH9pit1VDvhCXD27XIiQvrhgTDf4Q1PJeXGDZlpdfuoLX86ybgxaEXzFDH+Vpc
         XlPf8YZ3Prz5otKl5yQsTBWeAzaeqKnsPQ1DpYSbBs8iYFsKuFf68NzV9f95t5gi6krb
         WSDnB5ccuGqqeVUKxkBeUTXjcbm08l+LWFA+znfnYOI+fl1pb41YmA4UTWXjqPDPLLk5
         DdC5zuLQsyiAEiGZHzoCujSIstCIPfPa3KMwAeO2gIQv+Bq/xJ/p57y29uKWf6niuGbC
         30wQ==
X-Gm-Message-State: AOJu0Yytn5ZRBeeBV2xXJKnInTyBrZpszZmd4p71QMMyJAtUUBKUO5xN
	0wd0u2AOPw8huHuFbDRBZpPFRCbTHLhyUdJ9Bf8gJIaPRoZzLAZABoM6LQpt0YE=
X-Google-Smtp-Source: AGHT+IEhMnTTHPQiVRUY2N+3UqluBWsbKDR5hPX8dIEsS0yvE1CpHa76lowrcxehW99hEnfhi7owFQ==
X-Received: by 2002:a5d:5f4e:0:b0:374:c1a9:b97b with SMTP id ffacd0b85a97d-37d0e6bbab9mr469893f8f.8.1727990612840;
        Thu, 03 Oct 2024 14:23:32 -0700 (PDT)
Received: from ?IPv6:2003:de:3719:4a00:e912:812a:2309:b70? (p200300de37194a00e912812a23090b70.dip0.t-ipconnect.de. [2003:de:3719:4a00:e912:812a:2309:b70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d081f7141sm2037503f8f.6.2024.10.03.14.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 14:23:32 -0700 (PDT)
Message-ID: <2c1c389a658784d073e31c9a7d83acdff2e4615f.camel@suse.com>
Subject: Re: [PATCH v2 00/22] Yet Another path checker refactor
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 03 Oct 2024 23:23:31 +0200
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> This patchset cleans up some of the ugly code from my last refactor,
> and
> speeds up multipathd path checking, by refactoring how paths are
> checked.
>=20
> multipathd previously ran the checker on a path, waited briefly for
> it
> to complete, and if it did, updated the path and the priorities for
> the
> multipath device and possibly reloaded it.
>=20
> This had multiple issues.
> 1. All the paths waited for their checkers to complete serially. This
> wasted time with no benefit. It also meant that it wasn't that
> uncommon
> for a checker to not finish in time, and get marked pending.
>=20
> 2. The prioritiers could get run on paths multiple times during a
> checker loop if multiple paths were restored at the same time, which
> is
> a common occurance.
>=20
> 3. In an effort to keep a multipath device's state consistent despite
> the delays introduced by waiting for the path checkers, paths were
> checked by multipath device. However checking the paths could involve
> reloading a multipath device table, or even removing a multipath
> device.
> This added some ugly backout and retry logic to the path check code.
>=20
> With this patchset, the code now first starts the path checkers on
> all
> devices due for a path check. If there are path checkers that need
> waiting it then unocks the vecs lock and waits 5ms. Next, it goes
> back
> and updates the state of all the path devices. Once all of the paths
> have been updated, it goes through each multipath device, updating
> path
> priorities and reloading the device as necessary.
>=20
> This allows multipathd to spend less time and do less redundant work
> while checking paths, while making paths more likely to not spend a
> checker cycle marked as pending. Since multipathd drops the vecs lock
> while waiting, uevents and user commands can be processed while its
> waiting.
>=20
> Since there isn't a delay waiting for the previous checker before
> starting the next one, the path checker code has reverted to checking
> all paths in pathvec order, instead of by multipath device. Updating
> the
> paths in pathvec order simplifies the code, since the multipath
> devices
> can change during path updates. Starting the checkers in pathvec
> order
> keeps a path from having its checker started towards the end of the
> list
> of paths but checking for the result towards the start of the list of
> paths.
>=20
> Changes since v1:
>=20
> The original patches have been updated based on suggestions from
> Martin
> Wilck (patches listed using their original numbering):
>=20
> - Moved checker path_state initialization code from 06 to 01
> - Check for NULL before dereference in checker_get_state() in 04
> - Moved adding start_checker to version file from 07 to 06
> - Renamed check_path_state() to get_new_state() in 08. updated 09,
> 11,
> =C2=A0 and 12 to deal with the name change.
> - Added new patch before 13 ('fix "fail path" and "reinstate path"
> =C2=A0 commands') to fix issues with manually failing and reinstating
> paths
> =C2=A0 between when the checkers are run and the paths are updated
> - Fixed check in update_paths in 13
> - Split patch 13 into three patches, one to move priority updating
> out
> =C2=A0 of the individual path updating code, and two others to clean up
> some
> =C2=A0 of the logic about updating priorities and path groups.
>=20
> After the now 18 patches from the original patchset, four new patches
> have been added to move the waiting for pending paths out from
> checker_get_state() and into the existing waiting code in
> checkerloop().
> Doing the waiting outside of the checkers (in fact, outside of the
> vecs lock completely) means that we can't wait till a checker has
> completed. We must just pick a time and wait for all of it. On
> Martin's
> suggestion I picked 5ms. Since multipathd isn't sleeping with the
> vecs
> lock held, it's much less critical to do this quickly.
>=20
> For checker run in pathinfo, I kept the previous timeout of 1ms, but
> I
> waffled on whether to wait at all here, and I'd be perfectly fine
> with
> removing the wait altogether, and just let the paths be pending when
> called from multipathd with async checkers.
>=20
> Also, I've just added these patches to the end of the patchset to
> make
> it easier to see the changes from v1, but if people want less churn
> in
> the checker code commits, I'd be find with resending this patchset
> with
> these patches refactored into the earlier patches.

Except for the few minor nits in my previous replies:

Reviewed-by: Martin Wilck <mwilck@suse.com>

