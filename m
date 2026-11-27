Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795740641;
	b=DunwzdCbQRrEyZ03O6w5pI3/LKFhDUB8sGJgYvJTe8QbmADBIIxONKW5So3UmTaUxrkE
	 Sh1bn5hr7h7rFbAUgntTbWx4SM1mfEn873bHSMJeOKAhnudtqZe3juJAKXuN1uyCevDw1
	 Hd6pcX9onqKhoK603jkgOOdOBw/ggY9SuQlQwZVJsjDftdRPUHJCxWlXNdp+2+yQSR5C7
	 eEyLcg2iqwPVEfLY9KOlzalaZp0t6e0u2OGWo0YqHvKK5TpCaRTkhI6bDmehLih9GmESc
	 TRRbq/X2ejJMpyZpdTXPFPom/FBdvGqA63y9JCuM+GWuPhuMYI8ST0f1XgCvMYmidEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795740641;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References;
	bh=x0Mp5Txn9dhWnd7kNaeyrGhDTXOo7utFqS5hhFOq2io=;
	b=oyG24lxw1p8hecZjCwJhB4D5Po8Cry2kbZicfGzxKN+J0IK6Re6wC66xF8Jn0Q1HTQqa
	 GAzdc0Kix1MCWs58dDdo+1vc1Rli6FXjFysSV8/e5E/oBLLw8WvsjURjbYD1KWeypRNoi
	 EOthUAcAfhZutVoM9AvYKMdphfuP/WAjAAG1o9XNaJIp+3dXbUz+LMIlu4CsEE+ceSJNb
	 7OmhweVgKGAG/+u6rT/3jFjZ+VQ1U7yw7SBs7eOAehWixwwxRd8tcQVLsIO5t4MS/cMlS
	 dX3Nv/UNLLUErAVIANy7UrF2EGoVKaxY4oQymmqoH8Dl61EcLpoefyXZsGKEw1iPdyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uL7NFQgn;
	arc=none smtp.remote-ip=209.85.219.48
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45404606A31E
	for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 00:50:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45404606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uL7NFQgn
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91c1f548f87so99908396d6.2
        for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 16:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795740640; x=1796345440; darn=lists.linux.dev;
        h=references:in-reply-to:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=x0Mp5Txn9dhWnd7kNaeyrGhDTXOo7utFqS5hhFOq2io=;
        b=uL7NFQgnblRxnycfhSKsiJjvQvb8c2pIyxvYetiPnT9FtRkSR9sQF88Yy2Prbg3ekB
         Dl0O4tFJOwac9btBlKN2gt6/rn2DCuYr/6B7b7ncZgb3ZStfXbQ7gIs1HvhK3SME+aiN
         9xkVzeLwPqX/CI6UEcDA1eAmY3W1BusTbEkmyNBKnrx3AVn+QAKjl1M2aJeMgxwM9FDt
         WrPDStbebPMwmPMy6kRw7/dcz9BiVOqhUx4WrudUIYVr6AxLUdSj1S3HYswq9VET1frv
         upnlGU5V/Mo+FPTrJYVfET9RYuG5WeBq/GN3h89zc7pthOtOuS3/QBb63fWiA1xLyYfq
         eEVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795740640; x=1796345440;
        h=references:in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x0Mp5Txn9dhWnd7kNaeyrGhDTXOo7utFqS5hhFOq2io=;
        b=TZKzidj7qcxuCTIhp/DYyVrU7ol7ovScuqBYAqQH/ePUwbQNOjN5g9RK7tLBhIJSV+
         UQbb4ZOREmB/DvWSzdKl6h0ey/834oZmv1IA2i6zhZU/4OEX2UfY6J1vpK+SuLeyQ73W
         0kJU5ZGRmGwk7MU66RLprqSjDyF1qbyiD4HAJiuNex9Y+etJzEyQJs3gQWXeh1GvMZzW
         rYH0NF8BnEzYPuL0jExlGRn8Q4P+DHFlFKEpSZLCzNPKh+YyL8MTLphnEGqqkEcPR00F
         JFfoTw8F5iC7mc1zl/R9z1QEm7SO6+6FBlzQZHKuN18gdkGsigE2Wi5gI5asaH8tBcpM
         3afw==
X-Forwarded-Encrypted: i=1; AL+hErF3Nx1AAyNei9qGar3w+OmeneSdHLKyDSgLDhTtI1ykpKHyb+37s1oMiWkCetT+PGcP1jlts5adQQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+QACX3vXXU0MERkqcfkO5bdDNULBZYai7P4Dpa9kqOQ08I9IHk
	MPoqgFj2nzplOiJ+ef4wMFRaVHOCACARTZBo59zOQehH+aAo3P8ex1jr
X-Gm-Gg: AZFdTZfT65IvEfx8V39c/U18whyyps+LqcGm70ltwn1VpSS02uuTJETJOQjFTMgL8CP
	Mv0Q9sgT9QLXxnpaQq8P/DHjb3MXO8R/R2Zba44ZMX/PZAIuhqy3sjPV/SiyBYpKjS4j7Uaj9dM
	e9zoUwD4Zpg8pKbKMBTLI12rop07mtdAHDKr/92K/QVzkPBfbzxloirped9Ggogix1F0ttIvKEs
	V0sdMH1zOhdzCpn4NPfOaKqYjjY3a6yMho9SrpBlNJ2w6AM+2q6a1pN1auwtE1UY+yDeN/3YLlX
	a7x8U0N63NCdmY5rkw6ObUqkuEx44kWnXa65182KA8VsvZ2PGmQM1s0pvZhG6Jkg/SRbqiodvzQ
	C8xJTpjdGuW7z1ktyU6zdnVQFuaH8V6T0VVBUwPujJ13tg6cn1ifk3bsn8yXuEvukHScjzrTV/Z
	gopg0SSGQMH4Tj19iOxMex4YCQsS47ZW/vVg5SiOsZVWBV/J+dqwOQ3qbl2/BDqp2nkngGaxPWN
	mfEKnkiV8SCo7hYVk0BQIHbT+2SsjM0hIlZxHfREehU6AZkih1j06eO4xolcDTpWEXRj97a0rjd
	oWSmPb1gK1n1k0YXGIQoulAvqSHEcChzWxCSf5pNRVWDLtUrTnOaCiX3CYz5xhTE2ubGJlAKp8I
	1HFpx7xsAkslFGsRRDkT4LDJA4A==
X-Received: by 2002:a05:620a:2907:b0:949:72c3:dee6 with SMTP id af79cd13be357-949ba99cbf7mr4043850085a.19.1795740640134;
        Thu, 26 Nov 2026 16:50:40 -0800 (PST)
Received: from localhost ([138.197.109.108])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb34ac11sm1703987985a.14.2026.11.26.16.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 16:50:39 -0800 (PST)
Date: Fri, 27 Nov 2026 03:50:37 +0300
Message-ID: <a424da14ad9f0fcda6988f558432d10e.ndokutovich@gmail.com>
From: Nikolai Dokutovich <ndokutovich@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH] fs: tolerate an unfrozen superblock in the
 block-layer thaw
In-Reply-To: <20261127003902.48-1-ndokutovich@gmail.com>
References: <20261127003902.48-1-ndokutovich@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Please disregard this patch.  The same issue is already fixed by the
"super: fixes for freezing, reconfiguration and error reporting" series
([PATCH 09/15] fs: don't keep a device frozen when its freeze is already
gone), which I missed when preparing this.  Sorry for the noise.

Thanks,
Nikolai Dokutovich
