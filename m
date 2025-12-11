Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CE918787A
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 00:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765411900; cv=none; b=PgZiGOj+0DzT3fYKrJJBM6xb4WWDUyM1YUD7vPShD0vIZgXAV0eDMw+E2+CEnTXc88tWbs2YtRSCtd5AO2zrLHazsATrsyh09xQSs9xvTM6tqpmmya8k1xR4pM1dbGkEHWeNvUowhbW6Ka6I5Aib7LGlgwO5Bw/1hfk6lVJfRSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765411900; c=relaxed/simple;
	bh=BITr5jvo2ffIXHW6PWmX7Ox1GaaaeN/AJwQRDX/pIr8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a6PW/Gc60hmVYHbusOtW9KIb4SJupqrGidwwyHrxxXzc9zSpCwb5rw5U4bQ8uFUwkXO0ynMoAOeQ0d7sCjKcLgwyPMZkb3JMM1ygeggFCCy30U2JfGC7CbZ2+QJv1DBxB6siCxxuhfyG3F2gF/zw8OSD81ypV7cWkPpdcFn/PsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aAGahqk+; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aAGahqk+"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b79f98adea4so56273366b.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 16:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1765411895; x=1766016695; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PHwkGxN2T3gi0ALOr7YMoYD7OhHM/r5GNezYoQZQYCk=;
        b=aAGahqk+3EK4MPd8JRIeG6Ra1VFtIEebAY18E6ERJ7VO8DXmL0IVdWMgCD46AzRpEu
         0qCrjKXkUxQZufFkgOYMY9DoWeoZKKbw6wbbT3lTnptqUdMZr0tNMXryeJfJvyzv8oBu
         VAqh7VLPNoSfMttzoNmu0YeEi4o7ptoicLoO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765411895; x=1766016695;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHwkGxN2T3gi0ALOr7YMoYD7OhHM/r5GNezYoQZQYCk=;
        b=u2uBkGRBS7Y8GLsLSdXhplGDdNviihaixPNRscdCN43PoTUUjfSBt1tGxMaQ/alAV5
         U9UqqRfpotrdbbFpQ4SYTIq07HOgIw6l/QVvkhuq5EQ9mWNmHub5gkQwiQYOFhGfWVS5
         QmZ6GCYrddwMcDKwQ2YSGEhwPTjLP40eCMyfVM4bKoOdemwCXuHByLHC+p9vxQXCeO0D
         4HYdHFvkn2zoYvRmd1wFEg7Pguq1sFAV7CBz4z6d8Nvhr8zlOUqicVKhST/XNEnbkak6
         fgcJzH5MFud8BlmlQ7jUcZYc73C+k6ZF+Lsw41nUgPbx4nje/FwYtwf+BSjII69If8sf
         1F4w==
X-Forwarded-Encrypted: i=1; AJvYcCXIQaOf60QGlqv4oXvTQQvONNt1H1tl5oaweO+4kPWzMAPE0PuDlUYLQ+LkuREYU8oY+7GZsobfUg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzTnvz/2gFiYHANTP//bBOpgiPNl73qjRzMJZCHOpGtNu+Fe8CN
	7hQJ0ncwizL8G/MNWjvNO92IA628EfleeEaAzvaPKoxKAiWbBhpkgqoiiSfsawcZpz1FxJo2Ie2
	p5YQgVRqLcw==
X-Gm-Gg: ASbGnctv5zJKdv3z3gbhCUL7bt3XuFa2kzohSwY3I+qScBEVvA8OIuacZZk+1+EQvWZ
	FfypWjgoaM9TyjVNvBeUa+COTi+J7N7+yOGtfJREWe/EWvxpHiBt6KcFx95aF8TKkrjBNkPyB1B
	bfKXrQI1oaL+NDeMlhUD0FoFfot65Dz4IZnq9xkoS6KRndQp6fJWgwYZVF8eg+iEVs38e1UGxzy
	1MrpTnS96PIRZOn7/RNAyFZZWvn5288INz7AmE0xDOgbf+POu8/szH5D/ofIziQJwLTEW8RpcBo
	BH8yq+A5MWfw/9rL2yNmPK1lVnnfILOyh+++TTeBXZAyvNLs426f5NNCyf7W/DokGHabtueF7mb
	yOEBeUkKDJymg80R1/uKb9RCTKID1DOdG+48fTGisn41BzFIle2jB13UGcmYnMOhNOhQUxhSBdP
	LyusGKBvjD5dqRPXbj6AiMwP254pxpyRpfx6Ooum8G7RyEkiPcyrkY0Vqw3spJ
X-Google-Smtp-Source: AGHT+IFJ15vihTcPr4+oVHlO7mWfNRHFO3bKYVy3ZYsiFw9ChBM7oYDLf2fMXIQVNjNZI8i0zwSdWA==
X-Received: by 2002:a17:906:f587:b0:b73:7a44:b4d5 with SMTP id a640c23a62f3a-b7ce8477cddmr466956466b.41.1765411895278;
        Wed, 10 Dec 2025 16:11:35 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa2e6dc1sm93359166b.17.2025.12.10.16.11.32
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 16:11:33 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so796079a12.2
        for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 16:11:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXG7xHCJPyTELPcZ3jhbuAuw8OzZvhwlGPY2CJEk8JVlTeUpZTsOoXd9XJVuOo0HBB4HiUyf251PQ==@lists.linux.dev
X-Received: by 2002:a17:907:7ba7:b0:b76:d89d:3710 with SMTP id
 a640c23a62f3a-b7ce82b604dmr458877066b.8.1765411892592; Wed, 10 Dec 2025
 16:11:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2b7fa07e-cf1c-73a7-d1eb-5d6082e08b29@redhat.com>
In-Reply-To: <2b7fa07e-cf1c-73a7-d1eb-5d6082e08b29@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Dec 2025 09:11:16 +0900
X-Gmail-Original-Message-ID: <CAHk-=wi4ckGEFjHhMHcSoWidgd+URdorcdt5KCP6rQvP_DDS5g@mail.gmail.com>
X-Gm-Features: AQt7F2rMxK4hBca3wg2VG4zF_ilR688xlt12h-ZwBcXrIo0X3Q5W8C0UDqm2KyI
Message-ID: <CAHk-=wi4ckGEFjHhMHcSoWidgd+URdorcdt5KCP6rQvP_DDS5g@mail.gmail.com>
Subject: Re: [git pull] device mapper changes for 6.19
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
	Alexey Simakov <bigalex934@gmail.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Dongsheng Yang <dongsheng.yang@linux.dev>, Eric Biggers <ebiggers@kernel.org>, 
	Haotian Zhang <vulab@iscas.ac.cn>, Heinz Mauelshagen <heinzm@redhat.com>, 
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, John Garry <john.g.garry@oracle.com>, 
	Jon Hunter <jonathanh@nvidia.com>, Li Chen <chenl311@chinatelecom.cn>, 
	Matthew Sakai <msakai@redhat.com>, Pedro Demarchi Gomes <pedrodemargomes@gmail.com>, 
	Shubhankar Mishra <shubhankarm@google.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Vivek BalachandharTN <vivek.balachandhar@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Dec 2025 at 04:18, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> small dm code refactoring [...]

This is not an explanation of the pull request.

This is just a badly formatted shortlog.

This pull request came in late, and doesn't have a proper explanation,
so I'm less than thrilled.

Get me a proper explanation of what has been going on.

              Linus
