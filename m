Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAA818411C
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 10:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721040830; cv=none; b=dG/iZY8A5zb5lcOSigI/V6X3E6KMOsH6ijg/51OqO7SjYmZFGk9hQZlsGnEXNk/Gg+AvOXBEMoYhPqYOMJCN26hnJalQILw/dLAAoBrRXGd9UcCookEIpOq0Vgtyrkg/7YH+Q6O7oYIrmS4aTyhfyNDsNdEAx9O65BYu4GuqSTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721040830; c=relaxed/simple;
	bh=Q+TsE2OkWz+QgrFtzwHwFgeOQAVqesI3ucW2fhshxKA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s3+gZSAE906jbiXSIM6J8xA7ONBAjdHg1QWZVlF7ehelE0u6hE3b630+EnMAa4meXMXaHU56cNJVlI4HunSbx+XEZsjCQrGoyBF4udvG52DURku5mdlH4MrA3TshmbjaWpdzvofxeMHPRqj/pc/CxBJMA4wN6x1xWnrDG16j2Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FwyJfj+B; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FwyJfj+B"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-36805befd01so1463974f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 03:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721040826; x=1721645626; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q+TsE2OkWz+QgrFtzwHwFgeOQAVqesI3ucW2fhshxKA=;
        b=FwyJfj+BXRvI6dG93zP564IeB05vc8ZcTBQjuPblTunDAa9iO8c09tREsDU75To/hw
         zuapoyUeTlmh5bbEZOHMSWyb3yDxF28CcIIu4hZ1wogK7GL2BrQTBhH/7Bp7Gft7FU9i
         WAGozwLYFplbU4kJTmxzxTsBH9RDUGzUTkBg691GEaHp/dY3qLQZlgNJfvkKMUHT5eQ3
         L9cAhRdYAvrpMxhWombx2LFgsGO1sWHuEM5yinb1ciTyvjRdNBWw8R7MHErMY/A8Gqfy
         6UOT4o7c6RtPin/3HqOt9WZDdSZfOEW/QxXwXAEVSxNs5ETSmqzRy59KqFMWQY3I+Azm
         053A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721040826; x=1721645626;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q+TsE2OkWz+QgrFtzwHwFgeOQAVqesI3ucW2fhshxKA=;
        b=hkWIIhKboay5C0k/3t0fUgTWWeZTeUJJT5CWyiOxUKMuxC3e32nFSJpN9nv4Yt/H+u
         7QgenxTVRPrsFdsIycRaByesU3B9ZEF0QEYRjrOUpXsqZkQlElH0HCNiKXjqnOfyEruD
         CFnrWTmijogNL3OfGuz/1/5W5IAQc481OsDLv3hhKrjB7kvlfin8sTh/rsE350mOW7ro
         SRYskUQFNLLmGuKwEy7iZnEVmJaV6hfFODrZx+oqnzYZQfkMkMCxi3o3OovJwtb5+oaJ
         R0f64ye72bnZ4Fw1CpaNBv+KA959oSynBs/vb2hBMlthmx7rsUWjfbTUQW3KKUmfa5jZ
         H1Ww==
X-Gm-Message-State: AOJu0YzRYbYDQjcx3Sfasj+//tAC7DOqpiy6UCU6XnygtE/eJ1JSJUGz
	yHLSUx2dQFFt73MlmdQi+3Ou+AjQDR2+P6jkKZ9h55jiSi+Lv3/sqe0QEwQbqFw=
X-Google-Smtp-Source: AGHT+IE80GG3rAVq7An5dQ8V/U6pQFieOJ4/gvUa+VI7h0s1YQMmI3KTB4okuqpAjn/Tb900xX1y/w==
X-Received: by 2002:a5d:5602:0:b0:367:9625:bd06 with SMTP id ffacd0b85a97d-367cea9640cmr12812091f8f.42.1721040825994;
        Mon, 15 Jul 2024 03:53:45 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3680dafb991sm6127839f8f.79.2024.07.15.03.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 03:53:45 -0700 (PDT)
Message-ID: <f615dfb9053183adfe81279a77283203ca2663e9.camel@suse.com>
Subject: Re: [PATCH 01/22] libmultipath: rename dm_map_present_by_wwid() and
 add outputs
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 12:53:44 +0200
In-Reply-To: <20240713060506.2015463-2-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hi Ben,

On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> add arguments to dm_map_present_by_wwid() to allow optionally
> fetching
> the device name and minor number for the devices found by WWID.=C2=A0
> These
> will be used by a later patch. Since it can now also be used to get
> the
> name and minor number of a device from its WWID, rename it to
> dm_find_map_by_wwid()
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Is this supposed to apply over my v1 patchseries? That patch series
needed major amends, and I'm getting merge conflicts trying to apply it
on v2. I can untangle that, but it'd be easier to figure out if we'd
setted on a final reviewed version of my patch set.

Regards
Martin

