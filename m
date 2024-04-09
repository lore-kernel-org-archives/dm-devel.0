Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81A1381C8
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 14:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673543; cv=none; b=dGd0ISLLnCv9D5bf5LGkXPyrhVgP8Vy7FlzEScsST8vbpKQVrrkqDW5cCj2qfxYC+OPokhPWEM0K5w3oDDjwkGVjP4nYSXsDhaPZ7YMo+QbuuOYQDdQG1J99TmIr4s41Vk+kFQ5ZoZk1sKVkLuoqZFXe9xzeGO0zm9o5QRoTvds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673543; c=relaxed/simple;
	bh=GmfUDxVPuiwIkTUsd+ogO5/l7IrAr/+E8tvLrf91a6s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qXgnkL5VyZ8WaoyHwDgWmPo8d1g8hsAKDhYku1CXQek2mhJG1AK3AQDVgeaV8mAikFZimmIJgkJaDEx+Ulhf6vC89qU+s8v8bRy6qQANFyA9mflJodqfACjLWwHaRgX+Hb4KUq+jCglkG6dgO5sQyc73oyX+W67b0jwWaLVF1nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=hAbX1GXy; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="hAbX1GXy"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-516d6c1e238so4525596e87.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Apr 2024 07:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712673539; x=1713278339; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GmfUDxVPuiwIkTUsd+ogO5/l7IrAr/+E8tvLrf91a6s=;
        b=hAbX1GXyu6GtbvvTYNB6VilYzkCcZ7BI50Y67cAWOF6695PTlZkc5GFJHTWTsWSGd3
         P7RyXG6O1agbNi+eM7D99LEjrH5e4lxu+RELx2DQctb66j25cpgOON8ClrgRBCl6N0cR
         C4uPR7pV7Of6czsiyt1fsS8opRFjA2djvBXkk2NKF2gC+tAbP5JJf85+cjFzTLAMQOKu
         /ZTgIK071Tt1OwftobTuWUrgIKqo8d+5ZC/wV5wbyukzvwk4QRIh1+1BA6pt0aEhz22A
         Kn6orlzMkK+M+tkpBXy6hJBmxB/s4aQjgkRQKtO7ISgd6z4a4fKPkPAozP/Pbt75VQLj
         0Kog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712673539; x=1713278339;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GmfUDxVPuiwIkTUsd+ogO5/l7IrAr/+E8tvLrf91a6s=;
        b=sb/EmPaIQjFHZymMWlKtnX9Yq44m+IMoPT6k7BkfLhiOxvJXVXucvBivyerFWiOuU9
         0HJ5KCHZ6kB/9Qv+toxwzRzNACj23AOEx4uXJJcc+S7MijK9ucRvsjGZy5vh0OJ/H4al
         2kTTrWCSPxg319poqEVvXHXi3evklDRgwIl2jnQVIl2R+pmjGwt4a1AVecJxEixW1C16
         kSfwwRhy315SObP7tdNL7EiOjIuJTco9554OnNdcqpwoNRBU+TKEgtRX9wyOYPgjTVtS
         vkqr0K69csKxxIIhBqkeAmC5zbFukMX+pC2orkpS9ziidAomj5t/lB9CvhCAmq/FsaKx
         FJGw==
X-Gm-Message-State: AOJu0YyyO6AlBvnF2cUgy75i4dCTo1xQyhWTuMbz8QqVG3ztVHgu8JmQ
	QxNYQO0sWsCaAHE2cmbP0wA3j9HVa8ewh0KL5BR+ydflnVBgwAgUsgSUtX581xJDHCCNdkVPlej
	t
X-Google-Smtp-Source: AGHT+IHGzOAPowNEzetjXeKP3Wf4qertSGU0NfYLU3cv+WaSAxYKWgkDkcv/BtK3L1FKqYt1s8D3CQ==
X-Received: by 2002:ac2:4286:0:b0:515:d036:f5c6 with SMTP id m6-20020ac24286000000b00515d036f5c6mr7525308lfh.52.1712673538903;
        Tue, 09 Apr 2024 07:38:58 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id i33-20020a0564020f2100b0056e6e9a367fsm1113255eda.19.2024.04.09.07.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 07:38:58 -0700 (PDT)
Message-ID: <f6654d3ac12ff4621942e409340b29bb23d959b3.camel@suse.com>
Subject: Re: [PATCH] multipathd: make multipathd set priority to
 RLIMIT_RTPRIO
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 09 Apr 2024 16:38:57 +0200
In-Reply-To: <20240329182813.1455019-1-bmarzins@redhat.com>
References: <20240329182813.1455019-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-03-29 at 14:28 -0400, Benjamin Marzinski wrote:
> With this change, if the SCHED_RT_PRIO compiler flag is not set,
> multipathd will call getrlimit(RLIMIT_RTPRIO, ...) and look at the
> hard
> limit. It it's 0, multipath will do nothing. Otherwise it will change
> its scheduling policy to SCHED_RR and its priority to the hard limit.
>=20
> This allows users to change the priority of that multipathd runs with
> by
> adding
>=20
> LimitRTPRIO=3D<prio>
>=20
> to the [Service] section of the multipathd.service unit file. Setting
> LimitRTPRIO=3D0 will make multipathd run as a normal process, while
> setting LimitRTPRIO=3Dinfinity will make it use the maximum SCHED_RR
> prio,
> which is 99.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

This looks good to me, but do we really need both the RLIMIT_RTPRIO and
the SCHED_RT_PRIO mechanism?

Thanks,
Martin

