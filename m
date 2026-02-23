Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F7F32693D
	for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771866071; cv=none; b=WJ1J9nhK6fEoJPYfWIMCGK2JkNkg+rQtrEchilveiMbK7li33arYc0tYJdWKjRIgbfgIArrg9AMvoNSndtGh2pNmMtbizu3lu3pPP+TPVFSl5Ev37Hs5RMpYmZcuo7ZBVOC2PD+fkIMaxbvwCax7DSV/xJjKI2x5M3PyYsmD2us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771866071; c=relaxed/simple;
	bh=YoSdX5A1qCF2rf/iZWIwKvcKlBSd19BvmD7dbe6mWN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lSPKBRA3wAYeTJY591fwgAHTgM2BzYyAQETYBJxTYVcnRMijW2hGIuFGLsiYXVdrFdKnzoOZ3XFD5T9M6Tj82WPMyZVFiPTbDcfHmromJbCmxmrQGyppEsQYsO7OLcNQmKnrQpT2Y366GE398sQ5W0ZwrOQebw+P2boQeE2Snwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CnJ6duUn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CnJ6duUn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771866067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GXae8ZDi2xAVqOQ536LC8GPIXHI77pgb4VLzCQO0tUE=;
	b=CnJ6duUnN6s1esVPDGe1mtJg/67W4Jx0no+lnyiaZdiPpA8Z/7Rp13AoDICV1qZdRF08i5
	OswvyaviYB5En/474BIFjqnvb4ldqvoq/suucFXmfWbFxwOqPgztNRD/EDyiAu6QPDuDJM
	BPP9hnsdPkorR60ITpIH2ViFdtXC2Ms=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-NIiJ91ZYPYu5tykUD3gGoQ-1; Mon, 23 Feb 2026 12:01:05 -0500
X-MC-Unique: NIiJ91ZYPYu5tykUD3gGoQ-1
X-Mimecast-MFC-AGG-ID: NIiJ91ZYPYu5tykUD3gGoQ_1771866064
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a0f92b33a0so148699e87.2
        for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 09:01:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771866064; x=1772470864;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GXae8ZDi2xAVqOQ536LC8GPIXHI77pgb4VLzCQO0tUE=;
        b=oyQUkHtuFjYB7fVQysCTLjQupNvUWFQwJ34F00XYh5M6Ri1QGUTd1JZuL20SIH6Dot
         R2QzITKDd/UXoJDC0h2RtWogaAp7K/9/C2EH5y7kSffVonzEYwitqob6qag1yB2ZZOys
         ZnRWV6MREaWJesPWnoI0ip5PC2j82OsWD5rywQZ0AkNs9gGhIyHpzACidkqbEHcOiv6J
         oadK+7GMyIZqQEq2VAeGSTbBOW3CwzjH7u8U30uECYrPbk+vZU24nAMSxnc1O14af2Hm
         TSQhrKQ2ArdzFH9885IwXKNgTUpGRtqJCtj6nyYTl/Ept0LpE3jsyfQZkztIgDS1KQ61
         uqoA==
X-Gm-Message-State: AOJu0Yx/FtBkuI7vgjON056bTDdRM8E8ZU175EFTY+ZTRp7LPbhJj5om
	twm31krQUwKsPEvMf6pmIDpkt8Vg6J8KkeFviaHFP5rVyZSLakfkZmGA9sj6vvCSPXKtdNwSFkC
	gjuEhp2o/D9352dIBmHAStF+FOPIJiQpKj6Nv9PLrG+8mWdy2DMjirh3f5Mc6
X-Gm-Gg: ATEYQzwvRZMjn+gjXagSPhJCiHv5yWY+gNu4yrWBxFsCuKDTuNtGNgyj9Bw7zMxlkip
	uKCJDsQJxmxBX9k3ZXpEMxKUVhNaaaowcoLgcjJXVLf0fYkgRNzRcFGJDWpveVs63W4asR+phA1
	f1tBvA4xRLwvoRfFW7ju8VPYAdrASidkZWrR5GW3NO5ZgK1NKTAOqFu6C21UW2nW52Dd2YZBNpB
	O00D9dgsPospsu/LJfcBCpKDuc57bqLmS1ZMrbDNhRqxR2sXHcTuu1Fh6GPUs0v/7+oWw49FPTN
	UIvhOo83703Y7HHD0wxyacIoKtjdAhjTstACWdsbu7p01ZjB9WR+U1sFqkMD6x5ZNY3IozY1n2k
	NYqulAzYfNBEzpkMnnF+XvRGLK6cabyP1cx1FbmS/zxh98dosaSw6IPj9UECJr4imAI9YsujeUn
	SvzURc/xROMxwE8X6zMF5zA0vkl+u3aPI2JnypeqVr5uwjj+GjxEA=
X-Received: by 2002:a05:6512:2316:b0:59b:b096:c659 with SMTP id 2adb3069b0e04-5a0ed99d66bmr2769433e87.34.1771866062384;
        Mon, 23 Feb 2026 09:01:02 -0800 (PST)
X-Received: by 2002:a05:6512:2316:b0:59b:b096:c659 with SMTP id 2adb3069b0e04-5a0ed99d66bmr2769385e87.34.1771866060338;
        Mon, 23 Feb 2026 09:01:00 -0800 (PST)
Received: from ?IPV6:2003:cf:d737:d011:ab6c:9161:6264:9da5? (p200300cfd737d011ab6c916162649da5.dip0.t-ipconnect.de. [2003:cf:d737:d011:ab6c:9161:6264:9da5])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a0eeb4c66asm1689900e87.85.2026.02.23.09.00.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 09:00:59 -0800 (PST)
Message-ID: <c2600a65-b94d-4889-9f92-0ba9cd964ea4@redhat.com>
Date: Mon, 23 Feb 2026 18:00:54 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-mpath: don't stop probing paths at presuspend
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Kevin Wolf <kwolf@redhat.com>,
 Martin Wilck <martin.wilck@suse.com>
References: <20260212180541.1154475-1-bmarzins@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20260212180541.1154475-1-bmarzins@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vFFAJvXUH9j20v7EQ5NqSLfTNlkVMgWwuAedH08-jUQ_1771866064
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.02.26 19:05, Benjamin Marzinski wrote:
> Commit 5c977f102315 ("dm-mpath: Don't grab work_mutex while probing
> paths"), added code to make multipath quit probing paths early, if it
> was trying to suspend. This isn't necessary. It was just an optimization
> to try to keep path probing from delaying a suspend. However it causes
> problems with the intended user of this code, qemu. The path probing
> code was added because failed ioctls to multipath devices don't cause
> paths to fail in cases where a regular IO failure would.
>
> If an ioctl to a path failed because the path was down, and the
> multipath device had passed presuspend, the M_MPATH_PROBE_PATHS ioctl
> would exit early, without probing the path. The caller would then retry
> the original ioctl, hoping to use a different path. But if there was
> only one path in the pathgroup, it would pick the same non-working path
> again, even if there were working paths in other pathgroups.
>
> ioctls to a suspended dm device will return -EAGAIN, notifying the
> caller that the device is suspended, but ioctls to a device that is just
> preparing to suspend won't (and in general, shouldn't). This means that
> the caller (qemu in this case) would get into a tight loop where it
> would issue an ioctl that failed, skip probing the paths because the
> device had already passed presuspend, and start over issuing the ioctl
> again. This would continue until the multipath device finally fully
> suspended, or the caller gave up and failed the ioctl.
>
> multipath's path probing code could return -EAGAIN in this case, and the
> caller could delay a bit before retrying, but the whole purpose of
> skipping the probe after presuspend was to speed things up, and that
> would just slow them down. Instead, remove the is_suspending flag, and
> check dm_suspended() instead to decide whether to exit the probing code
> early. This means that when the probing code exits early, future ioctls
> will also be delayed, because the device is fully suspended.
>
> Fixes: 5c977f102315 ("dm-mpath: Don't grab work_mutex while probing paths")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>   drivers/md/dm-mpath.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)

Reviewed-by: Hanna Czenczek <hreitz@redhat.com>

