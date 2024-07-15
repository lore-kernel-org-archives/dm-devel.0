Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE103FBE8
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 19:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721070998; cv=none; b=o/6MYAlWYXUkUBJLhq7JGfXxMSk3G32z/3rChocO+3S6MSKxRkyBYvJBWNaOEkZlDy3sv7zg/0lPYOmVCzqQBNRCC5Puy8bOHVCJmmCyDRLL8CYXvs8xdxBcAPjbO+1QzDshc0nJq3LqJUKlzm03NooNHPJs136sYlhsQH/T5n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721070998; c=relaxed/simple;
	bh=+KfVSLDpekj3u7b6h2d6zXxTUtfZEtX4y8Qq17ZG2qc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gZGPRlC8b9rc15Kkp4JeWlJhXqwNdhBKmYo2Cod4yUH3JiFo4syLp6Otejx/KtSddyHkm7viSFx7fnYtD8zGymTdw55xoeayn55Vg9QPPzKW9uQhrgsHBFdVfuU5fFmsnyZtTmWgIO4HaXHWlujS+IiuGUPj+HB65HfnGXu47/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ObdDsgjU; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ObdDsgjU"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52ea79e689eso6620468e87.1
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 12:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721070994; x=1721675794; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+KfVSLDpekj3u7b6h2d6zXxTUtfZEtX4y8Qq17ZG2qc=;
        b=ObdDsgjUA6nmUHLZHLqICD4RKJjIAzcDvNmKJNqPwDGFQ2c9T7UQCVMgfbb/CABIzW
         87dR8tDxaLms8pIhshVxw9a+KARG6QGt82EZFosgjUVT6jtwGLYf80tHtmBeNutEqhVM
         UvGy0C1BfXFTvlL4PDqcgf5l6o6tdWDmPPmWY99eyZvki1SvqeZ3W6bHycII2qRe8KfH
         aci7MIhaFGyZSs715gSy9PIbwdXlAH1IRDA4BA2PLXrMhyb1teWMa6bGOuwpfe0//yy1
         MypoSIUdkZrSAHgyTojEz2xl505MZJoGz+bIY7Qi9uuMHjc8uU7gB05mFmTFfhJA/mQB
         r6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721070994; x=1721675794;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+KfVSLDpekj3u7b6h2d6zXxTUtfZEtX4y8Qq17ZG2qc=;
        b=kJ8UrzAR2HEtQquRGhDagOi7G+GUspnPGK2WrcFx358gsmGpDQMr+1VABqhdiDQlR/
         Mu7F0EnMX0GE/x7y5IejDIAO80E/yEXqVA97wuxpvrZNKeOYdyEyJGyF1LEfX9Z6L4F6
         EmmYIkhbInqzkvcvCIZoP71LDGdPrC0ieUjMPZyUOgDm4hnPg8qIDdwDCJphZQF46quj
         UIc1Zd3/OMJxSHZLFY1DIM0m1/7XACpxOcXHdMufuHDvRGde572DrEjciWAlzLm7Xe+l
         WEcuWp/AK3LsMnK3yeg4vZ6dmZew29Y++IV2Sec2RsbAvNw1nmUUZpaApwJCRFJ5MgPR
         wwmA==
X-Gm-Message-State: AOJu0YwtFyz6Wr2aCCKTex/LGa0QH4j1OwgVfzy9TbcGqyBCd51BV4iO
	MacetH7b+OLB4LB5cJRH21kVGSA+d77someAI16Reb+HCUJnpfPiB1NXNGttaaM=
X-Google-Smtp-Source: AGHT+IH4KOO65vOnpQSy3yIvJsS9E9sYxgeLlQF0Ko8Hs1RuNCp1gqa/KugBm3L+dHftZccl5+xCdw==
X-Received: by 2002:a05:6512:690:b0:52c:d5ac:d42 with SMTP id 2adb3069b0e04-52ede19ce92mr313230e87.9.1721070993528;
        Mon, 15 Jul 2024 12:16:33 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc7ff7a7sm231021366b.155.2024.07.15.12.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 12:16:33 -0700 (PDT)
Message-ID: <694ee49e785ac6f1e67c201590694a8afffd28fc.camel@suse.com>
Subject: Re: [PATCH 16/22] multipathd: correctly handle paths removed for a
 wwid change
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 21:16:32 +0200
In-Reply-To: <20240713060506.2015463-17-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-17-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:05 -0400, Benjamin Marzinski wrote:
> If check_path() exitted because the path's wwid changed and it was
> removed, checkerloop() wasn't decrementing the pathvec loop count.
> This caused the next path to be skipped by the checker loop.
>=20
> To solve this, make check_path() return -1 when a path is removed,
> make handle_uninitialized_path() also remove the path if it was
> blacklisted, and make checkerloop() just decrement the loop count
> when a path returns -1.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Would you mind making these return values symbolic? Other than that,
LGTM.

Martin

