Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DAE4D131
	for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 22:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707775722; cv=none; b=lcWToLFIgw6rMrJYnRGx5kCd8E49klR7awau0mm86IkbZpWn0YjzdxW6bgPvQ3llORGtgaKiKQ4xO6zg9ZysO+cpflwZt1bAMyElEotTyECHmbB01e46xjmGF0odKad0qZ9BUpyulj8+KPIot/ZrXgeaecROnwrH1d7nFNa9P9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707775722; c=relaxed/simple;
	bh=gAbe+DaZz7ho9Xs/O1+sZUd+Q7Ss16k+L7gT59qsNpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=upOp+tUY4eV4eKn5hRVmTo38Zh1wb/rGRwrSWtg82mRSsmjv4MDtUc8FbUWRcRpZ6FccPkM9lfZBzeA9AOswD5EiDzuh62/jOIsfke4HVs8btus6C1Ntx8saWzGX5XAXsipfYH2nzexTO52+FoEZAYn/GPXmpZbp8CZybG0edHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PlF0RXF3; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PlF0RXF3"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a3ce44c5ac0so77986466b.1
        for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 14:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1707775719; x=1708380519; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uavn2lIFtdjKttrhD59+foSMVfR1WVZExe9j9lqEZVs=;
        b=PlF0RXF3TqDw+qfB97zaNoQoHVdoEm52PnYDwAdPUbvHS2NuPKGQ3ehBsMQb6HM//E
         yTsNsCH+NyeFpkrLqEcDDmb1BiUmPNlkeA+LHROJ05wkGyMEYBUfbBGzZZNmTcxRkQne
         EyUfF+7oD7a6wrW26ofzUpPNA+ZpflyWnuZDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707775719; x=1708380519;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uavn2lIFtdjKttrhD59+foSMVfR1WVZExe9j9lqEZVs=;
        b=SweI5rFmSJftTDVILJXIWimflG3yEmFUunZO67LRvtLFKKjLK3ZQGtS4aJ2njlrZwG
         8Z6xRW7edlRxXnRuwWktdtNfxdBPPjVfjtc3OvmmOafxW7ddy98W0FZtBDAtiJZ3mqnZ
         BEdVBgpzGkjuorIp00T/pcNzUd9jy+Ej1U5SK8yB/WkfOO4hgUyT2mzXq73JrY+1OY9c
         w5xvpy+ytO/WB/NgoUHDNooCbBMgKpRzokRIUGYtbjVQCAs+HnVxboe3B9KrKblaLpBo
         IqVcE3vuZlLO+km3RoFgSaETVWcQQtxyk2C+81z2+8Sr8pEfG+PmlcOrTpUxhhO8P2sR
         aJiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkkOt/UqEjzib9LK7V72S8MLAym0CmVmQm03pdDFEGoAzbisge4XOKqUX8B+QL4DqD+zCy1JZaByocH+VcJlU5DSAEDe6yquA=
X-Gm-Message-State: AOJu0YxF9SCswYlAcF/oIyMe83s2+w3CcCIE+NBQaQI9u6YE/Q1J1uLy
	wL9pyKReSm/179yQdfDasasy5JwdPRg63vUq/PUU8JgX4NQPBUPcO/C0DQ2BAdegvgiu0KyclMb
	n6GA=
X-Google-Smtp-Source: AGHT+IG3Lfw+QtWzXVSxYRTdDEshLI6XH+F88bx7gIQ3N5PiD37Av+a9cCj87bijUoUL/HmBCu0vMg==
X-Received: by 2002:a17:906:2794:b0:a3c:c228:7560 with SMTP id j20-20020a170906279400b00a3cc2287560mr1938872ejc.29.1707775718728;
        Mon, 12 Feb 2024 14:08:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXoCWqsAtuWGvReYzS781R6OYjWATspNrc2JPI4CwVvwa2EqaQ7ErOZD7kngJRnBfzjFeFZaRZmguGx/Hc+HaqDN1RQxLXggc4=
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id cu3-20020a170906ba8300b00a3cb30d6271sm620458ejd.143.2024.02.12.14.08.37
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 14:08:38 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5600d950442so4125549a12.1
        for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 14:08:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVzPXoVbk6VteudjTERxfIdmxqJpwshWbEBB8zTU5e98MINIqwbtv5V7mGxN+8WCISeHkaBK+lTYZjbV3iCrqOA893L4z4B2Pk=
X-Received: by 2002:aa7:cd66:0:b0:561:f173:6611 with SMTP id
 ca6-20020aa7cd66000000b00561f1736611mr60172edb.35.1707775717604; Mon, 12 Feb
 2024 14:08:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240212163101.19614-1-mathieu.desnoyers@efficios.com>
 <20240212163101.19614-6-mathieu.desnoyers@efficios.com> <65ca95d086dfd_d2d429470@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <65ca95d086dfd_d2d429470@dwillia2-xfh.jf.intel.com.notmuch>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Feb 2024 14:08:20 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiqaENZFBiAihFxdLr2E+kSM4P64M3uPzwT4-K9NiVSmw@mail.gmail.com>
Message-ID: <CAHk-=wiqaENZFBiAihFxdLr2E+kSM4P64M3uPzwT4-K9NiVSmw@mail.gmail.com>
Subject: Re: [PATCH v5 5/8] virtio: Treat alloc_dax() -EOPNOTSUPP failure as non-fatal
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Arnd Bergmann <arnd@arndb.de>, 
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Russell King <linux@armlinux.org.uk>, linux-arch@vger.kernel.org, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-s390@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 12 Feb 2024 at 14:04, Dan Williams <dan.j.williams@intel.com> wrote:
>
> This works because the internals of virtio_fs_cleanup_dax(), "kill_dax()
> and put_dax()", know how to handle a NULL @dax_dev. It is still early
> days with the "cleanup" helpers, but I wonder if anyone else cares that
> the DEFINE_FREE() above does not check for NULL?

Well, the main reason for DEFINE_FREE() to check for NULL is not
correctness, but code generation. See the comment about kfree() in
<linux/cleanup.h>:

 * NOTE: the DEFINE_FREE()'s @free expression includes a NULL test even though
 * kfree() is fine to be called with a NULL value. This is on purpose. This way
 * the compiler sees the end of our alloc_obj() function as [...]

with the full explanation there.

Now, whether the code wants to actually use the cleanup() helpers for
a single use-case is debatable.

But yes, if it does, I suspect it should use !IS_ERR_OR_NULL(ptr).

            Linus
