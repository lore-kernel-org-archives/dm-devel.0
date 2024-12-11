Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755DD2451E2
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 07:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733903350; cv=none; b=VtbG2Wd9cUwFrl6ftabQMboqHf/XL7ZiadpESiGCkMORnpfseUvb9Gxak12hDXS+H1BlKJcyZQfcoS0zp5BhvaDmoLJixE2JcD7+SnjAEZC/O3OtA1bNXOlN8Bq4vpg/e9OInE2GiRUnTZWiklEbul0f192KtdA72OZKgqJhRkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733903350; c=relaxed/simple;
	bh=0+DYPJJkGojmkc6w04x8em/eDnzDvBfSANdbcRTEra4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kCsoKNL4zgrw37lEmrhyolgCaeVIpM7rw6UqIkkkwHttuch3W6u9inBGgWM3AmqBGmjrJEkmeFGoTkK+T8lV+rhpUdqVJ/lkUmkmgAdyBeqXfi83TnQACdP7dvwCNXV/K5dJM2ZzNTpAFCAxE2P0qiqFNbbPbLc1RiUJWyJijBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DnYBW8Od; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DnYBW8Od"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733903347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+DYPJJkGojmkc6w04x8em/eDnzDvBfSANdbcRTEra4=;
	b=DnYBW8Od/kX5u0zFJdlG8WJhjo4raaODnKQAkBh3SaIlg+9MqgFXUCxSfNpdWnngylWm58
	Rgpp/Jgs4CgqN5qu7xhtIeCgWkbpPigJfUkkwVIGLpHZkxAJ8IyKYxm71BOaV5L4Dym/fZ
	hyFKTV6dzDTJGzxH537R303aEBp6QZk=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-YruW5OojOIyeykXU4yGncw-1; Wed, 11 Dec 2024 02:49:05 -0500
X-MC-Unique: YruW5OojOIyeykXU4yGncw-1
X-Mimecast-MFC-AGG-ID: YruW5OojOIyeykXU4yGncw
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-71e1c2b6f72so373151a34.1
        for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 23:49:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733903344; x=1734508144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0+DYPJJkGojmkc6w04x8em/eDnzDvBfSANdbcRTEra4=;
        b=dgphYlgNFd/PNTLnk5VneIZtgFOD69bGMoLpTs/AwWQaq9D/BgYsPerStYI+odRKHN
         uy29rMYsfFx4SjIXBwkbrmsEUiq+xVFGaWOV3chDK5HRGnAalhBz3c06IwtYVMbTOef/
         Q9M74rIeRJ5k6TQIv400LeMx6AwV9bUpPRiyaSUrJKRG5oFBzulCsMEWwsuL2cxglKlh
         JFJxGwUot3bHavIWxnXrNKPY6xjyuA34Y15EgvJHweKq7M0XnKJVN5qVEyDMl3+Lgc6W
         8TOrCIkAf9ylmD9sWV4cEcGS2M1o2E5nYLFXHjHYCPkSOr+5lmG3M3MAX0IoLCqPXBrX
         iOEQ==
X-Gm-Message-State: AOJu0Yyl3trUOeMnTLsiZEk4JiGVJt7/ykyBVECjrve+3o4FHAXpmnL1
	ZkEDnsKbNK4Ngc7WRs0OqOkU+ZvNA1A8IJDaPkk6e3qcXfFcZUVwKIqKRqmpBvFw05el1wlRhby
	sQmDUikIJa3Ih3JoNJO1Bwx7/z8qJpUYwcQHua3yq9p6UhLYPrrlO33BZuyG5NpBis8NysmVoB6
	kK+P4UMmxxR+Dwjd9NYf40Zmo15Q9XRELCEzz/vC7jyDc=
X-Gm-Gg: ASbGncuzSdOmPu1WurVgmTBM13ySU6KwXmPbbT0IZscQMfdvHhknFbMNja9dpUoNgiw
	qrme/1Z+M0j4Oyr6ajt9KCFoTunz0uLiQE9ip
X-Received: by 2002:a05:6830:44a9:b0:713:ce15:d4d3 with SMTP id 46e09a7af769-71e197ac9afmr715954a34.1.1733903344376;
        Tue, 10 Dec 2024 23:49:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHtQA8q+Ts2h+wZ0CpbJLmlO61ay6yAT9NfFZIFxAg7wz3BRbNNaVbXse5htHIZagVkjFy8t1pha90J8ZF8oyk=
X-Received: by 2002:a05:6830:44a9:b0:713:ce15:d4d3 with SMTP id
 46e09a7af769-71e197ac9afmr715947a34.1.1733903344079; Tue, 10 Dec 2024
 23:49:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241205114153.1496986-1-mtsai@redhat.com> <20241205114153.1496986-3-mtsai@redhat.com>
In-Reply-To: <20241205114153.1496986-3-mtsai@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 11 Dec 2024 15:48:53 +0800
Message-ID: <CALjSBEvxc5D=5f-KgkWFOjrz5n=ZpEsVeLDoi_8RLqBYi+si6g@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] dm array: fix unreleased btree blocks on closing a
 faulty array cursor
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <thornber@redhat.com>, 
	Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oz6ie0l8ecQr8kdlP6QZXdBUm0oxc6YICuokkEcIZsg_1733903344
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 7:42=E2=80=AFPM Ming-Hung Tsai <mtsai@redhat.com> wr=
ote:
>
> The cached block pointer in dm_array_cursor might be NULL if it reaches
> an unreadable array block, or the array is empty. Therefore,
> dm_array_cursor_end() should call dm_btree_cursor_end() unconditionally,
> to prevent leaving unreleased btree blocks.
>

The patch can be verified using the "array_cursor/iterate/empty" test
in dm-unit:

dm-unit run /pdata/array_cursor/iterate/empty --kernel-dir <KERNEL_DIR>

