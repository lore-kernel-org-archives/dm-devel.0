Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB38C14A639
	for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 16:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732034372; cv=none; b=XSkr91ybvRCpXfxWodWxqQ3uQ0tyRy9LYlG7VVvIj88yGbQnKpN4P5IuDeGC0iVdibl4mFtrq/9FqZd/tJbalCQmidS00fSZ8e49dezi7brKP6Ug2YZtVPxE3QQWci9+5E5RGr/dMhJROjY8psuKYbqM2RiRIqZFadxr9/xzGnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732034372; c=relaxed/simple;
	bh=PToJUso/w7unGRw0wuFuvU5BwAxsx4y0wg+fjosZBZY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W3gMcutu44MmeqBTwYGXAnS8vytxDffMFN3E6BSZ+pOjTKtz2To1AG2s83UuPlUZ/TCvvQrqEqWP7Dw6/yLjdhDzSB5bW4RCjPmz1P6+NN8FQB/LJKhjNu+hPMgMloOrXuXxWPAN+wRXFiZ++1LFPYTBvkrw5YGqzIFufwvP9gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fa4wBR2y; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fa4wBR2y"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4316cce103dso47111905e9.3
        for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 08:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732034368; x=1732639168; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PToJUso/w7unGRw0wuFuvU5BwAxsx4y0wg+fjosZBZY=;
        b=fa4wBR2yrxHWRVq1QTa9WeJp1l0m38hw0YEmu+vZKmyCfI2gxtDRPZ7w9l3Lfl3LZ2
         S/zdskcfxUO/o4NFprtu1qj2KbDE7p2/6zYnIBq98mlKcANvFDa/xQLwA6SYhkU3m65L
         EXQVxK7B7SQgoMS1D2heZTWLk1d70YUKyKHTV7fvuI5Frnsu9iCrhq9JPO5oKusoHlXV
         /VJgHtcr2qd35A2+FtlEGJN0gSk3PtFuVlMS/oWdfZ6Z0toozpH2lb4Oe4U3p6yLNoOJ
         fQSJNx/4o6Wk1Gvd8SOf7Iv+2tIDBU0le/RO1YNZmexiC+nVprq93WXqlKcUydNJyS5O
         4wSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732034368; x=1732639168;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PToJUso/w7unGRw0wuFuvU5BwAxsx4y0wg+fjosZBZY=;
        b=i2nMorYDC3Ps+1HQG/WK78mRLXg76fAEQTEHWzN5QCCkl4Jg7C7p9xROBRnK7LhX+U
         vFalzoks2PxaDeqZ7VBJ0kOz7FWW9lJ9zVujvfdA/D/OiBGnf4UoUYhRlwG6MMsse3Vf
         rIudslkD9XEGywA1wSH+snQg9BdV3mOVRuXZ1BcKuTrMpMjC7aTLh1LCNJuM+0yOjvvx
         yHzDhjw7sd3/SqVrR87fBWdx1+AgTIUp26ZDXaaht2slanTywNm6P7wcyPs9fEAPsBeb
         uu7fgh8KhioCNsEmCpaM0AoZcaiK5MkobCd257vP6fM4aUkqDXykf3DjE2KTbm54Aelq
         qhpA==
X-Gm-Message-State: AOJu0YySFnqswPIMbuoATWX1Bzz8F910/X8dwDlYyIMMtZ9th3XiAT9U
	KmSG5Umj9bnh+4COUZoQnnECbYL4DnUPVt7iWGLk9KWAP3EBEYJmXWg7gitTbv8=
X-Google-Smtp-Source: AGHT+IE07147oxeAaTUAjf8X7AbUudKjFShZrm3HoOewrh+y5wHrBPwQL46sE1Q2KHe0pp9T+jgreg==
X-Received: by 2002:a05:600c:19c6:b0:431:5533:8f0d with SMTP id 5b1f17b1804b1-432df793dd5mr199168925e9.30.1732034367989;
        Tue, 19 Nov 2024 08:39:27 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3824259dda3sm8284915f8f.77.2024.11.19.08.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 08:39:27 -0800 (PST)
Message-ID: <8f74ed950515b775def323b2d04fb5092ad615de.camel@suse.com>
Subject: Re: [PATCH 1/6] libmultipath: signal device with no table in
 libmp_mapinfo
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 19 Nov 2024 17:39:26 +0100
In-Reply-To: <20241115232256.627933-2-bmarzins@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
	 <20241115232256.627933-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> if libmp_mapinfo() is run on a device that has no active table,
> it will now return with a new exit code, DMP_EMPTY, to signal this.
> Currently all code paths treat this identically to DMP_NOT_FOUND.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I just looked through the code again. I think with this change, we need
to modify dm_flush_map__() and do_foreach_partmaps(). They should
remove / act on empty maps. What do you think?

Also, we can skip the call to is_mpath_part_uuid() in
do_foreach_partmaps() after my "make MAPINFO_CHECK_UUID work with
partitions" patch. I can submit a patch myself, but as you're at
already, maybe you want to do that?

Martin

