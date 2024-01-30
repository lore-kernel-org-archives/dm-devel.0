Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544DB364DC
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 02:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706580854; cv=none; b=rBJaBkdZVDwOvZQZ3WkFlGzrbiq5um1td7QWaPkoapMZcCmbOqtRc8x5QlzPMFPSGYUXQcF4yHEUAIC7iMIUoikIqYe1qeLb7A2RBReIlsS9jUQi7nv6TQsBCsJZw7LfrXlHxeMmUlqRLEmjw9rX4FUWcBiCYE5LwfuqiXhnqEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706580854; c=relaxed/simple;
	bh=IwEanimwTJYmtMfF9RyN9E4q0NxtOqmII2D84OiSFsk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=SD4QqpeR6HSvNzHUYIiTeMF22sNgip3DCJxDEE3Iq5GmIfxzmoNt+F5RfkRc6zzMvYxLWnfFbRcL4Vtfd0C31Hnx0d3mO6IqOlbXe4Ww8VXkbD8fe3Y+pLdoNZg/4PnAGhBc5GM1WpoHhwMByj8d+kJOdGOhhJ8KplGwNH4RLxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m1wVSrOF; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1wVSrOF"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-602c91a76b1so44230687b3.2
        for <dm-devel@lists.linux.dev>; Mon, 29 Jan 2024 18:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706580851; x=1707185651; darn=lists.linux.dev;
        h=content-transfer-encoding:subject:from:cc:content-language:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2SupoQE1x02Ku5Ly/mo1tWoqHbGHXYcCbk4MN0N1NQ=;
        b=m1wVSrOFBi9M1AgEVXEwOVbaQspnIbhSYNS7HJBsLmmyNhqxkP/9u2Pk9oivJ7uZQg
         HH5v2TxbqIw+rDuI6Cop3oJPoIXy8ZNMFDbMEVIUu4kNqMEX7R2l7BN3GntUq4ViIMLw
         LcKaOiFmlDDz4rK9kiXFfuik/E/J/vJ2wnLlMpT8nQzJC1rYsYg4kDiPj+kP2blbP7uu
         pZoLwdYvWZ0sMd6DWP8sYvY1ycYUNCmB2MP3RYajXUaWFSq8B/jkMhHPwrIlTo0jVXv5
         1pFUaGskqubLLOYQflmoqeh4V695Ct9s5atjCBcLLopjDSmyIG+9h44dHVPPYVRXtruB
         jN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706580851; x=1707185651;
        h=content-transfer-encoding:subject:from:cc:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e2SupoQE1x02Ku5Ly/mo1tWoqHbGHXYcCbk4MN0N1NQ=;
        b=s/lxUS5G7mc+sz0UbGQViVCtH2YHQkWQFBm787pJKciXNB/H2yxzNMk/k2ZkswQcRS
         dFR6T5blP98l9aqFLUsg2YAZ4/O+JoxDxoPLKpxUXgArZ8ovbEhcRRgCyedUk3jNmegP
         kBY3h2BMCUAdRA64K1aIr+w3yPN5HE1to7+soM4UxGh59/gmwDon9zNlQ3pQR79qBloB
         NPbtEv0J5mm7TE021Y2i8oM7GhjVHuyFE8hs2m88HkqTVhr4M/o9yPKUNCBZ4RrgHmGz
         Nj1+yFyS4xcn9SPs2IZeisc2dGS5VY28uUwbDU1Z8DOFI13rotCc1oZe+KE7ixpsbFi2
         Yu1Q==
X-Gm-Message-State: AOJu0YwSPxXNBDcfEBdpm1JJGT82mHuOUP26ZWsqq4LWK95VRuD/hywx
	DwOJ530l+YK+YaEHV9TtmOyTxtFDVEvEQv8Zwt/t862MekrMY/6vS66J8k5tw2uRjg==
X-Google-Smtp-Source: AGHT+IEH6HrbRm2hcFFWV0x1WrnhrHn5xO1Kv+DxqZMwqoGP9M1NDyuQALiJx8gGAQ0HMmJooopoLQ==
X-Received: by 2002:a81:af4e:0:b0:603:aa89:65b3 with SMTP id x14-20020a81af4e000000b00603aa8965b3mr6191088ywj.74.1706580851008;
        Mon, 29 Jan 2024 18:14:11 -0800 (PST)
Received: from [10.56.180.189] (184-057-057-014.res.spectrum.com. [184.57.57.14])
        by smtp.gmail.com with ESMTPSA id br7-20020a05620a460700b00783f0df60c0sm2350146qkb.120.2024.01.29.18.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 18:14:10 -0800 (PST)
Message-ID: <8213bdcd-2b2f-48c9-86da-ce3feeb37774@gmail.com>
Date: Mon, 29 Jan 2024 21:14:09 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: dm-devel@lists.linux.dev
Content-Language: en-US
Cc: ignat@cloudflare.com
From: Adrian Vovk <adrianvovk@gmail.com>
Subject: dm-crypt: Automatically enable no_{read,write}_workqueue on SSDs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello all,

I am working as a contractor for the GNOME Foundation to integrate 
systemd-homed into the GNOME desktop and related components, as part of 
a grant by the Sovereign Tech Fund[1]. systemd-homed is a component of 
systemd that, among other things, puts each user's home directory into a 
separate LUKS volume so that each user can have their data encrypted 
independently.

I have recently come across a blog post from Cloudflare[2] that details 
a significant (~2x) improvement to throughput and latency that they were 
able to achieve on dm-crypt devices by implementing[3] and using the 
no_read_workqueue and no_write_workqueue performance flags. These flags 
bypass queuing that was in place to optimize for access patterns of 
spinning media and work around limitations of kernel subsystems at the time.

Thus, to me it looks like these flags should default to on for SSDs 
(i.e. /sys/block/<name>/queue/rotational is 0). Such a distinction based 
on the type of storage media has precedent (i.e. selecting the `none` IO 
scheduler for SSDs to improve throughput). So, I was going to change 
systemd to turn these flags on when it detected an SSD, but I spoke to 
the maintainers first and they suggested that I try to implement this in 
cryptsetup instead. So I reached out there[4], and they suggested that I 
should write to you, and that the kernel should set optimal defaults in 
cases like this. They also mentioned recalling some hardware 
configurations where these flags shouldn't be on.

Is there some reason these two flags aren't on by default for SSDs?

Thanks,
Adrian

[1]: 
https://foundation.gnome.org/2023/11/09/gnome-recognized-as-public-interest-infrastructure/ 

[2]: https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
[3]: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/md/dm-crypt.c?id=39d42fa96ba1b7d2544db3f8ed5da8fb0d5cb877 

[4]: https://gitlab.com/cryptsetup/cryptsetup/-/issues/862
