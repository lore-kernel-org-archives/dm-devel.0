Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C618141737A
	for <dm-devel@lists.linux.dev>; Tue,  7 Jul 2026 13:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783431651; cv=none; b=blyPVixkTLy/uV9w09z4SIRphpa/NvAl+8DYO/oMEXazO6wwOn2mR5CJqm9oRJCIgCdwbXqy7QhlwZW2uBm/nbCNFxVldMIJBSeYQeShYpzu2dWFtQ29xAx4bWPxMJXd3lKGrgcyxlnoPp2OcW1Dn2FOdcW/5Ke/zVU4og0Q/ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783431651; c=relaxed/simple;
	bh=bT00hTmvRtRdoYe3nepk3r7coOslORYi091MUvXDLr8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QXJACOB1JHlvp7x6Qf1xvXJ/UaHWFpmCXWQ8aI/iS8AUsPGSwBCodPA4n1vaEotxw3DKiVZVBawhZaKNqiIcg91as/uAnq8rTtiu3Gy9Wvzd03tflJd/QQxDTEakzco7moe7JEvVbfKkZ2U4Oz+6fO9hf2BS+f6mkkbmf7D7s+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=db74xhh8; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="db74xhh8"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493b966dd74so14571715e9.3
        for <dm-devel@lists.linux.dev>; Tue, 07 Jul 2026 06:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783431648; x=1784036448; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bT00hTmvRtRdoYe3nepk3r7coOslORYi091MUvXDLr8=;
        b=db74xhh8NwOmlpcxUxLmuViZOWjOJ32PoOCLCrXII4W0MQK4mJaGmdlIUhGoAr4GSX
         RLteJYT0gBQ7GUdbSTY69M1p0PEaXFzAYGvAHx3VHFGMZlImrvevHmR/gFURe9miBGKX
         I0K10DdBZYEUAV/HIDOofW6pi3Ecib8uteaFENf1w4awQSF4jGEQ9fWCmuME2ktoOr1K
         KTAkApUFDiR6p3IeQ15fY2JD/WqmTSfmeWwUAEaNr9zRBHN9k3AugENykzU3M1ZaISgB
         teUCscmCejXoIQUbZ/PNjLefgXhlD+j5kuUTYrjb5MIauRgB2/FFhQ2efOHWGgyfJWot
         IKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783431648; x=1784036448;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bT00hTmvRtRdoYe3nepk3r7coOslORYi091MUvXDLr8=;
        b=fdrMZUhPVDOfzJf7ql64iTkcUFo9YFVG+vcmnZadQau9AP2zpIu4EyItMmzrps9La3
         Q5fjZhov064915Mez5zFpXyyH1qi9H0/rcj/GKDpoI2aEb4B4H10s7IpFOTphjwDG3zT
         XVU+UMV37TvJkqHCol7VOOsVHLFb+jt9Jir0LWAforB4WCJACfLS24wOy5EwFJWAlkxc
         lNqqx1SZV0EqniA655BapB+QuTzauZWmRPA2u4MdU5CzZ53yQoW9m+VSBzyCfVOXDdNx
         dFCLce4ZC44hRhByuqvgyN65el3VLlpvIkw477vXm1Uygj0LwUhymGTi8Ho2iiW+S1bi
         qNkg==
X-Gm-Message-State: AOJu0YwL0SD7gAsnehKFocEfKpg2YchuuGavwmVSDpPc9CdnUpfvVAaj
	fm3FnNMUKC/2xqsbHytwTyo+nT8LNxCe+tesACrEnhtIHIni1VpK5MoczRAecZys1qo=
X-Gm-Gg: AfdE7ckyevs31LjbA/9bk1whkyNmAjXMBt/YxNJd7qqfZa9CyJdwMpBzrNFgqmXCWLI
	Yw8iCxUA2Yhq+u2VZlOMwN9DcOdkLlHkJMRLG1ceRfPqikJ+uqgCisi8YLEBzqsLFgEmDgBPDcy
	tnK62gn+LlB9TvYgfMvIMKOTTviLlP8/UvMxO6hrPpmXIoGyJjIE/o52kj9SwptqFCe5Hy4ut3j
	Lm2aIoM7S/0uWNZI0JztDrMymiWNsn6fFfWrDUwFizMfenvqrK0J7rk4Xk4TPaRYDvMvSjp0FFO
	D8fnGz+jFhykWk97HpppvmzkSAVtwoVCO8G0M5a3SK2gDfDiVp36XTQLsCD2lQczmxzQS8CuJYx
	2UNfUXGW08Tm8RlkOnmgD0DdK36pBzXJEJ/OvrAUrRk7TvDEa/FkixLdu3MUcJWM+lTo9XeMXU8
	7Fm3oXS1cZObUhUCe/3nMlKnM8PFFrgbbetyp2+Gb6uLFf/jMrnhlOVOJ97Dq7Cvdcwh6az/lSQ
	yPzDJ6ErdpNYAgUdRO0KEpZr2JkMjAfo8moOK8vtPXcxJZF+D8=
X-Received: by 2002:a05:600c:4512:b0:493:aa0a:45ad with SMTP id 5b1f17b1804b1-493e4283464mr14228765e9.2.1783431647815;
        Tue, 07 Jul 2026 06:40:47 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d780csm35069670f8f.11.2026.07.07.06.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 06:40:47 -0700 (PDT)
Message-ID: <177965912b6e43bc06dc50b89c20089608720a2d.camel@suse.com>
Subject: Re: [PATCH 1/2] libmultipath: make sure sscanf sets a max field
 width for strings
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Date: Tue, 07 Jul 2026 15:40:46 +0200
In-Reply-To: <20260707004817.1958264-1-bmarzins@redhat.com>
References: <20260707004817.1958264-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2026-07-06 at 20:48 -0400, Benjamin Marzinski wrote:
> In the iet and datacore prioritizers, multipath was using sscanf to
> get
> a string for a 255 byte buffer, without limiting the size of the
> string.
> This could result in a buffer overflow, if there was a bad value in
> multipath.conf.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
