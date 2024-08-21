Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288FC2B9B7
	for <dm-devel@lists.linux.dev>; Wed, 21 Aug 2024 04:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724215537; cv=none; b=hBF+wQUV8QEUHBeCiX+aW6gWj82ZFjMY+R5EvfHC5UGxm6aBM5hc3akCV5y5N0SEiVcQx8jK6uTOQ6lukpwH7e9quksNpPOsFy+S1Is4CCpYDxLaxjUAXb1TPBj00n38Owev58AvhCUalt7Mljitm0VvXrgx93U59c/PyFEFOek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724215537; c=relaxed/simple;
	bh=iVwLN3pHjTCYWRvbn68J39cMQjsLMkf8YabA2yvf/1w=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=sTUc7oDu+is13cIikDtbz3JHGwbEtiRTQPzNjLibxvacVukP6SnrA5E8OmYvyNMUP6KZnp0vz34wg8hb1Fk+BF5Lx9rVGQo0O2LCsfYQBl74Po9ETMtCLpbv5SYR4a/1LKUwCqAlvpsZ1xrS3ZVN9kAiKnFWD9U+KalUwyoOrO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=pB4KWNv4; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="pB4KWNv4"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2d439572aeaso275425a91.1
        for <dm-devel@lists.linux.dev>; Tue, 20 Aug 2024 21:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1724215533; x=1724820333; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iVwLN3pHjTCYWRvbn68J39cMQjsLMkf8YabA2yvf/1w=;
        b=pB4KWNv4IyE9O93PafQm2cpmM6JuvxndXDW2Wy/gEFyuKKYBshNkYomk00ATf/YvQ2
         us6TvHykz6dO7YclL6BQWNh/m6OiiegxPI5120RB/AlwZn+r57ibxCzm2pc4hwoUJxK/
         qm4orvNMFqL1T8ED9U1phdmxP3gY+r2Soa32lhGhLIsXewmiCBnGXacyz2gBjZ4yLnCP
         zPntMUFey84k8Aj4TVrp2WGQq/yc3hLFAAE2mVcA3+ugH9WEyILqw1hGgk+pUwPUeQBk
         0oy/byi6isPi8STDeDsdLssLBn3Ra5iU7N3KXe5IyVSgEiUb03vLy0+pAZPBfOZ3fFrD
         xYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724215533; x=1724820333;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iVwLN3pHjTCYWRvbn68J39cMQjsLMkf8YabA2yvf/1w=;
        b=cEXbLhG007tOD1yZ3A4FOS+woEnRXV+7OaB51pbDIJblu1/AQRfflLCj0nl1jzJSia
         sb47rreWGyOuBsq52ieh9O7xGofQTStKecFH5tudmRWshanZm+axaTD79GbhLaFgT1Oo
         uV7+ZRxWHFv91pQz3W4D2zntmxQ53+kdv9t9+WJsbmtRmWllbRq7WIoSfMBSezsiHMSL
         jCzlZCam8ctJSjG0MNBS6lxi/g1p0yeQUtuCciUXKtTWpDn9gqoYIoxN/lf/JEO9A9yk
         cQYq0H9Vy8OyHi7gxB/e1UqHo01ZIJZGSraBtBEvIOdqTpZQ9GTSDo5keMcS/BsNvhiZ
         vemA==
X-Gm-Message-State: AOJu0YyH1rsRiKub0hcIUNbCgAFDC+j22SbXZgPnThBz5Iilym6Xf7Al
	8ym7jHdNI+Zi0rnnGvoA2xYhIu2uvOGiBVvLUuWzti1cvQPyAd2s1/+95KwSOZiMJu4MdRqsxue
	0u4tJkf5iR+XFSunuwMfM3c4scGh4BEdkGTVcKdlIhyEEi1JLYw==
X-Google-Smtp-Source: AGHT+IH2/+EsJCUKBzhL/fwfswqyPuEOgl055BNS/cvOFHQwdWLPi5AD20bIrZS7W6fwib627kDGR5DMGcX6Q53YYVY=
X-Received: by 2002:a17:90b:4b81:b0:2d4:902e:ca3f with SMTP id
 98e67ed59e1d1-2d5e9a6673emr1957568a91.19.1724215532746; Tue, 20 Aug 2024
 21:45:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: David Chu <thedavidchu@berkeley.edu>
Date: Tue, 20 Aug 2024 21:45:20 -0700
Message-ID: <CAHge_00RZ7r8Np0F4PdH50hTsX-OrkXznKU2u+R9qD16=vx0_Q@mail.gmail.com>
Subject: dm-integrity and write reordering
To: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi,

I was wondering how (excluding possible crashes) dm-integrity
guarantees that the hashes that it stores for each sector is
consistent with the data for each sector.

I've been told that outside of FUAs or flushes, block IOs can be
arbitrarily reordered (see this article
https://lwn.net/Articles/400541/). So, let's say there are 2 write
operations, A and B, writing to the same sector, not separated by any
FUA or flushes. We know that even if they are concurrent, dm-integrity
will ensure that they are not submitted concurrently: write A must
complete first (its end_io is called) before write B is submitted.
This is the add_new_range() logic, if I am interpreting it correctly.
In this case, the hash of write B is written to disk.

Can the disk order write B before write A, thereby making the hash
check fail? Or is there an ordering guarantee, that if write B is
submitted after write A's end_io, it must be ordered after? The
add_new_range() logic seems to suggest that that is the case. Are
there any special flags that dm-integrity appends in order to get this
ordering guarantee?

Thanks,
David
