Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526B3420877
	for <dm-devel@lists.linux.dev>; Tue,  7 Jul 2026 05:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403527; cv=none; b=Vt3ccZ8H4Iat6kqcs4dqDr6lUTSnUVN28AsGo+M53g1ysFNE8ZczKYDIK0YxA1m65AtI/p2s3uOoMvk82twI6/iiRTh6VQ6gUUL9t2g0qfXVWKJ9uOJ1XRJ9VsTmGafcSkptm+T1C1IH6lQsAPenYdH05tdwF0a2K37qPFQziVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403527; c=relaxed/simple;
	bh=bC2gl9TzYt9A8ocKmxrmRoaTvzTV1fmAovqWndvmOkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PExI5GVApYE8AOcUUQk+UJsrGeqS/9Zt8KDzbwnOF7hpWkzTun5ZDJK4UMjFHIbu8t1LBsivJoNzQ7XVPJAQZUtqpc8uWlvqDWJx87dc2frGjSa6xP0cUapIo376yvU19VLlvvNyf4230Xkz16KF1DuVD2fsrhApsgntI6Qjdho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sky/MxQ9; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sky/MxQ9"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490791a3e92so1449385e9.0
        for <dm-devel@lists.linux.dev>; Mon, 06 Jul 2026 22:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783403525; x=1784008325; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bC2gl9TzYt9A8ocKmxrmRoaTvzTV1fmAovqWndvmOkM=;
        b=sky/MxQ9nU+7rSVhb+SENhY8rD8s76WgHVqw2yIaBxliil/x7Bhz6ezPEdMS/6CV2B
         jFvFcgLHokwQduDtauQ0Fac1xdZ608GjP3yrz1ohKkAjDlM3ZZC0+5AKSf7V0C1GYb1n
         /r99dAEBCwhFDxuLdRB+KcK4rdPlPgRmacW4wh8XbZYY7rlU91z0DwMhxzxpq55D9JUU
         MNZNcgnxV1ZnMkD9uTwgGOUPxhcE/YGwIyzzs7o6B7dScKL+g3iCJXOcpdvUc8bGhy0+
         e409OhFu6FTjFNUWvrW73Q8Y20OQDEwynS6C5jIk5vNE9zRRAPUxYPatt3FNhAbIFBcJ
         e5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783403525; x=1784008325;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bC2gl9TzYt9A8ocKmxrmRoaTvzTV1fmAovqWndvmOkM=;
        b=Vnx3pZyuNcc3UUGwnQpPpYkwGIqUEF6u0S1v7iVbpIiWuFDJtJtn/HwHq08hRnKYPa
         Cdkn5wFOCIvWh22w98zURNQoz/jVVAGIBbU5yuCoI27sxXKni+44Xvq0ngwzMUqelbTt
         kId70nU8UKUvJV0WTCHUxrPAt9RaPBvpZnmiFRqjhuxBrwUWr2rzzNgKsCMyDy3ZZVm1
         1FnBHwtlWb059FTKzi9gLSQq5+5wD/mFOJtUGSqhg5rUt840SX4XZoVHSSzQjewkCxLm
         LIzdyyqm5sc4Wb/3g75GUvSWey2w5az6F+a6rv6vU5sQQjKVdGF76OU0emJvX09RhwKZ
         rdxw==
X-Gm-Message-State: AOJu0YzQMUfXNHLqB0OUwInBqB8NDMoEX+/A/oRmd+Qytpv3vNgouqn5
	tDMXyuJEh8MJik5BHJUc6iGk7X5YGLUWelC+j43/7RJ+HfJnm8TUE+o=
X-Gm-Gg: AfdE7clqgeEOOwyqTwbOzDqSj+8ia6y4Yr+T0uDkDxedJxeZaDNKIdJFCHQbD1PzMbK
	cbBW4LlpL0yPk9KQmk4fLcfYDSKV7rxnTjurjLvxX4UlZaOd5AC1fg6H/b8bmTbV+O8SoPGisKN
	KUKtm7vpNJGgZgdmQDVZY7YoEuyiAkr/msWmA27+PdmtaFuJYV2CXXyDGx5FyIzPaa8jTjMSfij
	7TXt1MCfL1H3vXtIyJgDpt8bJFzcQDo5whhdC+ND8DZnScVFsJylrsSx8wfL/4JcOdU5oQyUus2
	U39SWH9aj4TW0iCf567ggvm6AQwzjZ0YfpmcT4eZ3UY/3qtwObs2gDnBN4jYxTPk3WAnZBpBr90
	MLFaSW93s1TZrwthhEIL7y4/Cq0SvU+NzhLeEYfxj/q7nlDIYY/klTOjR6nWPBg2NnTc/BxvYnm
	x/aUGHmLxRWKIZP5SiRpZ6xwNNgPj3lqBZIqAPgjzro+KOi0ViJMo=
X-Received: by 2002:a05:600d:112:b0:493:a6d2:3a37 with SMTP id 5b1f17b1804b1-493d0f09874mr49514485e9.1.1783403524398;
        Mon, 06 Jul 2026 22:52:04 -0700 (PDT)
Received: from localhost (32.red-88-28-15.dynamicip.rima-tde.net. [88.28.15.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0fccf2dsm27932295e9.15.2026.07.06.22.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 22:52:03 -0700 (PDT)
Message-ID: <edd01616-ab8f-4cec-bae9-5f4e84e1cf59@gmail.com>
Date: Tue, 7 Jul 2026 07:52:03 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] libmultipath: make sure sscanf sets a max field width
 for strings
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
 Martin Wilck <Martin.Wilck@suse.com>
References: <20260707004817.1958264-1-bmarzins@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20260707004817.1958264-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/7/26 2:48 AM, Benjamin Marzinski wrote:

> Note:
> This patch applies on top of Martin's ("libmultipath: iet prioritizer:
> obtain PATH_ID from udev") commit, from the "tip" branch.
Martin, this should be removed from iet.c:
"// Uses /dev/disk/by-path to find the IP of the device."
