Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9274DE556
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 16:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721059534; cv=none; b=Z40qEX+kOuBQXeUvfAzW4kDROWW7/83PvBXQxSYRXhOof6XxOX3dVLrLjn0ePycYCxi/O9tiFtH9qVNw496nvzx2L7g7bq61erGVxsH7fcniwEEgqpLfJc6DG+ZfvrPyat2VDgSUpPcEpnmVS61/z1EMXwai2hjSZPsB0Ixb71M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721059534; c=relaxed/simple;
	bh=yuZv/Oaba480abvI7rrqI4q3KQohhTfcKc8w1Qcaw/k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gmKbOnFfH6fd6Sx+8/QpKdwWFNo8x2qS+suh66z35cePR9jcQz4+xKvCMPWSJkZADWO2hpvURPA8pKIZd0Dl/J6UAsnL0QCJSUBaJ30NB37jlDzxDIMD+g+iCP56+c7W1TIfgN9/ZDyOzQLwWEwMU2TpcHv+9rbFoETMNqbCd34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ETRJkPsP; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ETRJkPsP"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-36794da7c96so892338f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 09:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721059531; x=1721664331; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yuZv/Oaba480abvI7rrqI4q3KQohhTfcKc8w1Qcaw/k=;
        b=ETRJkPsPZ4B3K8WhhBMtKHWJqW5uUhW/xmI3/1Y/R+F8zrUrI1Fy68a8eFApVW0S11
         hDDtGEtv+0sCQnK8ezdrrlcpMFlWfo7HVpxYjDBXxzrzWhRfN/AlrS+enjZB5xs0M1id
         skmw3qt4YvnuMizLHycWr69WZgBUcCk0fiLfbDWpr78eYdVIURZqxcEtVReGWDfZj13a
         O+a2OPFqRJJi8vi8U2vzKwgnUec38Q8ph2MnQQTVkgDrqgu/t5qPzs1in0GIYJGqzBGm
         7NoDrWNaBlhdIcDC51WkFV34m9GDUQyuQRF16O8bxjwgNkhQ6Bn9O9iXy9UL5tFv4kPS
         hs0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721059531; x=1721664331;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yuZv/Oaba480abvI7rrqI4q3KQohhTfcKc8w1Qcaw/k=;
        b=UoFfycuu2hk/aBtPqZDZQa+AhqBadxHXJNNoKeWSSbNNA3CiqXtp3xpCUhHOAg8vBV
         Gqs2VOPgo/6z5DhJ3b89y51amJdSPtJNir62sa5+WGM8dMjwmK5lnBPbIEhf4tWAqf5+
         XGMc4+w4kx8HsUbjEhZuA7wJG9Kqpt2RZVBnjnA8p/D6oIdGwYfQiSpUIaW1SuOEUDqa
         AQLLOvXYL7jEKd5Px7RBHHO+zQVhiS/G+eDHfRkc5b4bKYcW4sN49J2q5Ch+SSlfwe+c
         oRc4gwVDyeJLfV0yoIMNgXgS1pt0DvRIkOLFp4EbtbGa8tK5rJIMMMN2pNb3+hPrer+q
         gl9g==
X-Gm-Message-State: AOJu0YyH0n7SYv3WeChKvVSh3Ta9oPaFvTBbi3Sp6SPa/l+wM+aYNwo9
	CZRmnnD6UNSB59CYdTXAxZSui274isPYwjWuZM/deSeHyDdYFVW/v5wzwcLp287mw8MwfR5xa3c
	T
X-Google-Smtp-Source: AGHT+IGPH7GLAvLDmSemYXNZUKNO/cwPCMvd6oPdhbvlufPumSgcAQkC2XIORFrYKeg4ZQFQhWR3Kg==
X-Received: by 2002:adf:e388:0:b0:367:9748:ee7f with SMTP id ffacd0b85a97d-368240cafd8mr115538f8f.65.1721059530772;
        Mon, 15 Jul 2024 09:05:30 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3680dab3bcdsm6821004f8f.3.2024.07.15.09.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 09:05:30 -0700 (PDT)
Message-ID: <688a240ecca834fec6c2847a292a8adbdc9f74c7.camel@suse.com>
Subject: Re: [PATCH 10/22] multipathd: return 0 from path_check() if that
 path wasn't checked
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 18:05:28 +0200
In-Reply-To: <20240713060506.2015463-11-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-11-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> If check_path_state() returns PATH_WILD or PATH_UNCHECKED, then the
> path wasn't correctly checked, and path_check() should return 0.

You mean check_path(). Other than that,

>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed_by: Martin Wilck <mwilck@suse.com>

