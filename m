Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94CB449EC8
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 09:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768987719; cv=none; b=HLAx17oQNDdByU6vd4MSibZDja0oMVVHXmOJMfD9e50YrhuabqC4/vs0xptTqNzlj2nkrXxHWih8EbBvIBl5qpBr+3caNnmR0lHEnKoa2JYibOpAf8UeihlZ1sv6xBDNAm2zNCtqaCBgUVjziOSmiSEUyDDsimIGlV1m4l7b6RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768987719; c=relaxed/simple;
	bh=O2nEUxDAy5bsAYIV+yhBRSENnrgBTjfF/Rc2yvAwLKo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b0IsZ4Ir4vl+Rpgg6EEjkFl4leAQp2lAchn83ulzZsR2QFsJxsrOBCflZy+PvmmPOtuU1E3WPcd+9zzehdln6akUK43GPTDtxWq6fsENdWZ37Cj5BzCpqZi92CXoNn5BDQPj8Ei2/I4btwuisqKQkSJ1SWmFF/J2wK7d7YLqR9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aUMjfOco; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aUMjfOco"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4359108fd24so895834f8f.2
        for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 01:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768987715; x=1769592515; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O2nEUxDAy5bsAYIV+yhBRSENnrgBTjfF/Rc2yvAwLKo=;
        b=aUMjfOcoCCEZgnwDf4MNwFU+uPvNPS1Q+WT9BeIUKUR4UpcZv7apkwtuqw4I01yGwu
         yj0p9SFktVvYcWQs9jie3VvLuWmyDwJKLy0JEcpJBWMis4PyrDf2DJ7zFnpURKUtMo8E
         puxo4sFoDjVLD24NZPx0FcEILNdTWjJicNHnOoLEuv+F4/RB7K2bT972TkByoa+zfnSo
         DWbRAVOR9UnFmyldHiO/isSEB9VCq4u4Q+ulBRh98DTNwlF/6pFk/YiEpuFF3nq2FbTU
         fxuojolcggMNSpscewAGea4E6gy5QaYbswZl3kxc0WCkzivVjJ3/qM7RLfSJ6tlxaWYi
         vTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768987715; x=1769592515;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O2nEUxDAy5bsAYIV+yhBRSENnrgBTjfF/Rc2yvAwLKo=;
        b=gAEwB5Ar7sMQo86KFCJGOOdRhNFWvpfBOI9IbuOM8keE6Hzz5Xq3cnNDy3es6VBQ8g
         kNLfbQ2b24Z4RkoeSKkDYH8rth+YBSF6VCVCgli3AK7h11mHFhwqj9PUSpI974gZeNIs
         kloWL/NjB0ligBXH1mMT1feL045OhO07CfMKACIcO4rANasDH+T5736ZpEWC9HuXSe9f
         cg9IwO0ZQ3TgVyFIM9Exy+mzkzh3i49jK9VScUeyldv5xtkLoN7QS9g/+2Am3kvkrrgJ
         lbgV4hQL+Myk3zFpcQzISJX7kMB0f8unIU4NpeYfisdpUdVUHKGXGrDM9yIfuGcEIBNO
         7fMg==
X-Gm-Message-State: AOJu0Ywge/bhCPW56bbym606yljbgHmUBhI1L17hOx3JrAd3799P+lbG
	sJOflb+tKqGl55ZMgALh1eXP7eTtEaAxuk0orka4Mhlz/XGRs/4AwiMWv7UHeB4mDys=
X-Gm-Gg: AZuq6aIvpx7Tnr9cxhrNOCD9j+ctyEArnM/wv+2we39gHdT6JgstGPkQNlr1bjwvQbW
	7Dz4PN2zbox7lpkZR5VAQewXGvx2Fi+ysV6Qw6rlpXtiY2op9x17bSzKwoZWH3wEYa2QCoiNU2h
	kdtLUp9Xl4vspCR3jauKRX8QdDRnaJZe19J35anWRFQmuKQKSIbDkNqdDKCo/AksJDczC5HIHrL
	jCdBlNlQ+dH7wOf23ERMM3xsmDMf/C6C5YPHIPI90NTUL01BttOaggMk47YxutUUfklFbnuvxfY
	AZm9S2ZaiUhje7Puc/2pzpRToNHYl7qHohuVc2F0US7a8tkLv4r5DRTOLuySvkTYvHDodgx2Wjm
	ffufx4sdDHruAwOg0npGsilW8flvHhAJRnoBySSBh3HU7gO25Ik39EBSbe/FJNGetEBrvFpHsBW
	pmJk5mtX5vzcA9MyaOHmkXc7FeMJZTqVWp5E3xsNjFS5+ZoQiPkwt2+v4+dP1ZlpFWgSp6L9fSr
	yMjPyXlEIfcFwvTclFlTG2yjgzM9IEbTbvA0NBLscJNOwI=
X-Received: by 2002:a05:6000:2dc4:b0:432:5b81:48b with SMTP id ffacd0b85a97d-43569bd4951mr25204857f8f.61.1768987714953;
        Wed, 21 Jan 2026 01:28:34 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43596b62700sm6458555f8f.42.2026.01.21.01.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 01:28:34 -0800 (PST)
Message-ID: <26d4936e41c4127c7f7e073f8b16e478b3bd1666.camel@suse.com>
Subject: Re: [PATCH 1/4] multipathd: don't add removed/partial paths to new
 maps
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 21 Jan 2026 10:28:34 +0100
In-Reply-To: <20260121042315.3914707-2-bmarzins@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
	 <20260121042315.3914707-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2026-01-20 at 23:23 -0500, Benjamin Marzinski wrote:
> During configure(), when the old multipath devices are added in
> map_discovery(), it's possible that they have paths in the
> INIT_PARTIAL
> or INIT_REMOVED state. These paths were not found during
> path_discovery(). Don't add them to the new multipath maps.
> coalesce_maps() will make sure that they point to the old maps, so
> they
> will get cleaned up when those maps are removed.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
