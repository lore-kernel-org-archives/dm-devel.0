Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF9413D2AC
	for <dm-devel@lists.linux.dev>; Fri, 26 Apr 2024 16:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714150068; cv=none; b=dyNmbyNIGTTU2dfC8PlYj4xiNK14rgBkxE6F4Kxs80zJ7kC+7ot4/z9HUnls863gAtYcvqRv1m6c+oSF31KM3E0uAas5QPd/i8HXtqQoi6VBjdwl/kBr4zdqb65NqLzKFJLAoarlQ1C/zaEoj0RjyYDfRokKy8uDAlK4Gp4J2jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714150068; c=relaxed/simple;
	bh=YJ6Jom6G97YN8w3EDwLjv3Cpk22lq6ED3j3LVJuaoDg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=j28Ne9M8zP2yh2rfgbAiA9SqEjjCTW6aZ+D2NrjLgh6BlEYh4zihKBlt6ZdGYxpjSi9sFoYFq3mTioOcJ+9L9waCp20F1bXup4v6kS9kjPgyd8BPDBr6On4pAMapYhlXl48YpF9wSHfkmVDb9qc1sYf7qFB2qIzg+a1vz4JBLzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3c70d8bb618so1119977b6e.2
        for <dm-devel@lists.linux.dev>; Fri, 26 Apr 2024 09:47:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714150066; x=1714754866;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fQ7psnjiyD4hYo+pT2BvMWh7VOo4jdebGJzBPZLs+1E=;
        b=Vo5P/2eLtYjdN71xDOyCBZZsLyAtnEpMCvk4uc62garYD1rwBZu/SbuSci+H0fnWXu
         pfXSflH08m/9AUVxKS5BXjq2xplr2sQ/AoE2BVS9P6JWvHC5A1wRz42xFuFpDUUvYcid
         QCnyuAY18+nTiouENu7poGWWGCdCAD8GLJ91GyiU7SBfwb9SlRwlufbGlJvFUTvI5Igl
         sLXZslQ4j9CKjXanWexd2/dRc0dOL3PM+GZD3p5nUOLKDWdeMAlPXbPA+M3T0HG+jond
         9F/uoLVXcTiuZXJSCXnKElvGX1EiptbE9hN1DsO/mOKqbLsW6ef8d+nzu/+Xl5JRaACt
         BJow==
X-Gm-Message-State: AOJu0YwOHSqW4XtkiBbx501ZBNCOFeBG3BAoaj9ZOLSl6PSLwS2RMPMA
	cwq0WK/BKm05iJeVlJHh6ASjKvOt12qe/UPyW4dd1LieV3iLZRjpZ0+WckD/ojV1XlumHIQIFaa
	cgDitUCuhwhSfxo9iTiIT/u2Z13aUqeaGOHaD1wpJgVpglSoaS9YaTFA4ZpXkXrWL4HoTZFVNDn
	KiVVDPHTEXk80khbD8LS95+GaWmETJfGdoId/5/g==
X-Google-Smtp-Source: AGHT+IFibUOOBHj8lc5K8tcyd9ZkLRAAIPwBS8+jyXPmqanl08PNgrfJy0N2Q7nOV0BAibme0p4DDw==
X-Received: by 2002:a05:6808:200e:b0:3c7:4976:7923 with SMTP id q14-20020a056808200e00b003c749767923mr4768274oiw.39.1714150065853;
        Fri, 26 Apr 2024 09:47:45 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id k11-20020a0cf28b000000b006a053b4c3adsm8006054qvl.118.2024.04.26.09.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 09:47:45 -0700 (PDT)
Date: Fri, 26 Apr 2024 12:47:44 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-nfs@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>
Subject: [ANNOUNCE] still co-maintainer of DM, but leaving Red Hat and
 joining Hammerspace
Message-ID: <ZivasKvjSpltZOh9@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

After more than 15 years, today is my last day as a Red Hat employee.
I appreciate everything Red Hat has enabled me to do and we're parting
on great terms.

I will continue to co-maintain DM with Mikulas Patocka.  Mikulas will
be stepping up such that he does more of the DM maintainer work
(reviewing, testing and staging changes, etc).  We'll be working
closely to develop "the new normal" but we'll likely be switching off
who is taking lead on driving changes upstream every other Linux merge
window.

I start at Hammerspace on Monday. I'm really excited to take on new
challenges via Hammerspace employment. I will continue to have
meaningful Linux contributions to DM _and_ new areas of development
(NFS, etc).

Thanks,
Mike
