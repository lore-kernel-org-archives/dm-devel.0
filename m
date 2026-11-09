Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794250690;
	b=Rpbg4hR4eqmdSAJpt3eRu3ivvANflYG5VLtRt0sBuqEDCqGSxifo2OLUo53ql6AUGq3N
	 0rJjMWq5tC+pJtMaTjySiYEg9qY6yO+cTdop3LwTIKBCLIAoePONcD4yKu+7wBPUjNOTA
	 58qnecLD59G0FGke5EN2Joiolps2g4dHTzZ1UajwBO5NvMxJS9D200DPhhFNRtusHZSyq
	 Q89dzS89eeNtS42Z+sJtzMu0CA/NivSpQx9WuA6CZ/jAZW7FEJlJChx9Wfy1XpzwL5IBr
	 580T0WrP/8upLGZShURJOgAXKRDpWq1yCUdkpZBgbCVmWGz+hXM0RanoB8Fs8O4raKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794250690;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/zoW0BrWCh0zaz/NJn+wgni62eC5oaMpBXTBJ3ydwE4=;
	b=ArnxvAvue4evMwaBxomVDcP4NWKKWpTg/4qbU9cCL/LIuI9qFYXRenMH+c+/MpZkQGuJ
	 JEJ3yaV/6srqBwf+GpbXYxRp73Loj/LvGKHpyQN4KKYdSS7oeL2M5u7nemsp2A3b+hAzp
	 0DtFFlMFvkHAVJvPsjlr+JQ3lTZfA5TghkHfrK4/PgvnfqdQmwt+A6Qb7RyCVk1GivmJS
	 dMQawvygiwQ/2vvrAxEhOkoxxQbrGq3E0ZqgTNwsclzpbxzzZQhQHc04fscrt/3iioK+k
	 3ojQ9t02NgXjkiw28oF+IdpxZN954TP3arBWY7+88TqrfeKMJt2BpYXGcsYGmP579DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=AmPnQLGf;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1282606A32A
	for <dm-devel@lists.linux.dev>; Mon,  9 Nov 2026 18:58:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1282606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=AmPnQLGf
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-36a315ed211so1408798eec.0
        for <dm-devel@lists.linux.dev>; Mon, 09 Nov 2026 10:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794250689; x=1794855489; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/zoW0BrWCh0zaz/NJn+wgni62eC5oaMpBXTBJ3ydwE4=;
        b=AmPnQLGfvKOCUkc53qQPhW9ggjiO9phC+p7b1QcQq2yT9ouOR2CBgarlpKO1eGxMid
         WE/0ZHV1+0UPwQQQLMoik8KFTjGCq7S+ojZy2WI+/EehzW4hzkUjJxmeSgIHdmOBFz+Y
         u41ZlLTEVhamyiKPNa58xHjV0rMybyD+U1h4CcPzRpjPO3tRmfRxrZHQ2ZwWgUmDYRyB
         DHo+FT4M/3l6a38Gu3O0YUFuvqGqfxcFF3Y/fWfHZUhZdm5O8Xdwm0o+5phJfsB1ujVj
         lRcHGR9keAFr+wxfXa8UGQiqSHF8+mLPJMG3RxA17serp7Wiu5/BNdVGTdRxGbi8zU82
         Dieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794250689; x=1794855489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/zoW0BrWCh0zaz/NJn+wgni62eC5oaMpBXTBJ3ydwE4=;
        b=eD/0tfabyov16EjnXZvkl02vslxTCQ9iiUSVSlekgz7UKZ9W3rjltjgmmZQL4Eew4u
         UtZeybfMR1oC55u1pie5MTIrrUWGR3H4jMXxsH7hUtBTTheJDEWFOXGeN8uuf3XdT+J8
         K0VFTc9LKrdIPyVhAQx6R0Oahj5tUut0OrU3qg0fZlsqoN1yVw1oDzVLXHcV1XoFUEHa
         C3xDm0AEFzCAALQbcM5zmp88OgZWKL/LKdJKM7+5Ni6IilCTG5bd8IjdKu3YG4R1C8vW
         hIelPQoO4Cn4Q7tZ+kt04Rdwu63gPPQrd5qLHNyJVYBe28gKmRlz9int95tAbxTjXvDU
         7+YA==
X-Forwarded-Encrypted: i=1; AL+hErEbJPSgXhHkP6K6uDnZqnCQWODZ5w04dVBEDYKW6Yhf9MXx1Fca5cvWVHOwqGdufeXmuhDFTkY6mQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z8YB0cr+reKFPvdKk/+feM2cradEzP/E55itcTt09+w05TkYc1y
	90B55CksHzl1goFmOduyzZZmJSvmPJ2SR1pRnnrpSvfaEN3K5jB82xELJUShLDkubVE=
X-Gm-Gg: AYBFou04AZp20twUNht6/imfCtMPDfTqQFnKdeA7woMMhwqX3uB5Q/rGBF3oIs5QlHL
	RizNqdh+9ycqC1gzuwC+kSzmQfJmRNmSFAbsg9skYjt7ZnaZkokTbfa8H8SeU2A+S0eNQstfthi
	7ZVTlSF70KGRtTbNAFLGPp0Dwvs0tJW8QNzRFGNcpRQWYa9DE5PLRb+XtVZ3nhXvnLrqUC4dYRJ
	+ltujHdVI4/EX96+yrfHcH3knT1hHVRd1tCEt1aRcBlJ4kvmpviyYy0TRXYwURvqqnf5q0m9PFy
	VkoJaFxT0sDGF26+T50EwXDxqqODuQJblmukFXrnqviOtD4HJaEpH2LVnsxpc1QwbYdZtcSvvcJ
	3Pc+NQKBn8HcpeJpoy/z00H1Q/eeNDsx6VIAn867YwUxkrxpqjQjmorLWBwLGXn9H/ZvVRZAtE0
	Tu3jGLw7W9wwMGRSClGDOhVMTqY5FIInIgJz8PDDyUmRFKF2R/Mbl3vlsiMCbghSrcClOfPxULd
	3YlzrKLbR4OYp7I0GR3VOCBgK7LKEaBOmkqpqhpJLmbXViB0ms8I/GwDaBAPFhRCYG+3K+eYuDS
	JYxHiIYSW3Qw5xOvqFGdyPnBTDo6+3TW/KWMID7WbOgkcTe5YYGERjuQSmjGZ93BIlz7DkJzZO4
	kXQ1qo/AjxeNXyzGwe5fyMhM1pN5hrTKvlXoix7kkiiZtfQ7GSyvBJZF2iEsbCnnH2tBGOe9rfd
	Vqh02tzvY5l5NyxDyZZAIFPZstNCN36QOsvwshOmw40AY06Q==
X-Received: by 2002:a05:693c:65c3:b0:36c:a2cb:6ad0 with SMTP id 5a478bee46e88-3750903a112mr434254eec.8.1794250688528;
        Mon, 09 Nov 2026 10:58:08 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520bfb58dsm394541eec.18.2026.11.09.10.58.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 10:58:07 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 1/1] multipathd: verify udev WWIDs with the device before moving paths
Date: Mon,  9 Nov 2026 10:57:56 -0800
Message-ID: <20261109185757.27498-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <f9a399429d9c7ac2e4079e7cd89ae7c304ee3b24.camel@suse.com>
References: <20261029235241.97614-1-brian@purestorage.com> <20261029235241.97614-2-brian@purestorage.com> <auTdZn84HV8DjGZ0@redhat.com> <f9a399429d9c7ac2e4079e7cd89ae7c304ee3b24.camel@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 2026-11-06, Martin Wilck wrote:
> You will need convince me that this doesn't do more harm than good.
> We can't just use udev in one place and other methods elsewhere.
>
> I am open for a general redesign that uses sysfs for retrieving
> WWIDs, rather than udev. But using SG_IO seems wrong to me in general,
> because it can hang.

Agreed on SG_IO. v3 drops it: the re-add check compares the udev WWID
with one built from the VPD page 0x83 data cached in sysfs, using the
same get_vpd_uid()/parse_vpd_pg83() code as the existing sysfs
fallback in get_uid(). It does no I/O on the device.

On mixing methods, one thing I should have said earlier: on RHEL 9 the
udev WWID isn't taken from sysfs. The RHEL sg3_utils package installs
55-scsi-sg3_id.rules as 61-scsi-sg3_id.rules ("need to run after
60-persistent-storage.rules"), so ID_SERIAL comes from
"scsi_id --whitelisted", which sends INQUIRY over SG_IO; strace on our
host shows it on every run. The bad WWID came from that INQUIRY.

Where the sg3 rules run first, ID_SERIAL is derived from the same
sysfs page the check reads, with the same designator selection when
everything is at defaults, and can_recheck_wwid() limits the check to
that case. So I'd argue it isn't another way of computing the WWID,
but a comparison of udev's value with the data it is meant to come
from.

I also dropped the uev_update_path() check from v2. With cached data
it could keep a path to a really remapped LUN in its old map, which is
worse than the problem it was meant to fix.

> I wouldn't call this a valid test. It's a deliberate abuse of udev
> functionality.

Fair. The tool doing this is ours, and we've changed it to open the
devices read-only, which stops the flood of change events in our
testing. The reason
I'd still like multipathd to check the re-add is that when it goes
wrong, the result is silent data corruption on another LUN, and
nothing else in the stack notices.

> Thinking about it, I wonder if we should simply set "nowatch" for
> multipath members by default.

I think that's worth doing regardless of this patch, and I'm happy to
look at it separately.

Brian
