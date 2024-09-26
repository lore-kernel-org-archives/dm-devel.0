Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A463146A7A
	for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727361918; cv=none; b=QPQ5rnj+3kQ+hpsxLd9Wrq9y2jRmd3RgmDn0uMMmiDRs7LKiIO+8nMerZK515A5ZpjUpfzHqJt8K9LIIIxD28j0EJ50tXvEtTajTGyodTYAKvJoxOS50Is7ganolNfR6OUsO/nf4JCsZOTqy/Lhkr6Npg5vVwR8dlJMYYLgmyKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727361918; c=relaxed/simple;
	bh=dsumOzFDfuh/PYFlQ5fBlwa0itLqF681cpqOcUvtv+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jjDIpPuYuRyiIAnuEXokOJMC+lw+jwwSF4ArxWKmBYSOUHaKGfZlQ0jv/3WklCuSVpZmZ2sniEEM2j/VBaxAw8ipvssQ2HMV6HPLwqomCPLzSaV9GUsW7eZbOGsEb3mQJoqTTdcFJRqj1iAISnyz0wBO/zTs78DaB8JwbyAP8Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=v7boWCtU; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="v7boWCtU"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f8ca33ef19so14920871fa.2
        for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 07:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1727361914; x=1727966714; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUk5GqFsvnt8aibuoucXH3mgAlXQnT7Fu6sM4Odfi8U=;
        b=v7boWCtUZSTOWBX7yKXi5cyZCy+BW7VzqaFoNeMax6Rw642r2o6Shuw6o+aYrP+0iD
         aloS5slx42o2N3STyuHXmMk0guDPnESCj6RBSCrWonqFddiT4qctIlqK0m98cZrsG2Ju
         N75VNZ+9KgPidM1td/2qlyxGcXUzOR/QuCaQskz39KfL1wx3RyE3fg3h4H230/dbBOWe
         go/CJs0XTq7uihVoGUE46tQFx85w4A3GrMa/FZG009YsRmiYUjFj4vw+cC1dZkoslHOb
         8QPuV073bMubM+8yFvWePJSn9fWDwXl2WtzXCZTnUi0r5uVbDtjqxwKr0o5hBQChW6GK
         uB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727361914; x=1727966714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUk5GqFsvnt8aibuoucXH3mgAlXQnT7Fu6sM4Odfi8U=;
        b=W5wIXGBE/pwhG8HbbMgkz8JUVNX1rcRgchxHzrSn4H9xjG2VcSclvy+SupMLYwcndj
         vJGJ6DHdV6PnH3YD6G+A1yaZ5ZkGePzd0hWp6LVFGZSegLywNCHxmCWLeWeHAteM+js3
         MR7rPIbfessq6fQA9jf/tNwQkOt1ZdugxZw6Ijb7QGrGj6fKTe+2yJ7Q8vQWLzRxTGDB
         W8Lxt7+nnqWcDXUoMgE2W5Tv0kG2LXAkdhX07nuiAla8JWpMWxDgNqY/+lu+TRz7Ys9g
         Jj3Z9aEj17GpFnCpBi8LvQl39kj7M082OO0wWvpUZ6KZD/dwcKuSqhyDBu0A1KCNlKbQ
         6WoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJEGUx98HUoEnEXPI9ja00cg7L9GBdK7Jtilq6JKithoRRDRvCCxL0ZQm51uj3EIiHk8E5XYMSUg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyE196M4jgFSsLJykyiK57BvKco2Pji5sG1tNN+5Ieb+csLTnnp
	bj6eg5dGW0AX1Lz/5uyt+rCGe5PtzWNZK67Swi+oQPW/I3hFtqIJRD8qMIXms/vdZA4atAttVRK
	xLG62ltPneIoucDVOxJjJlTd58aT58XIs12SiTA==
X-Google-Smtp-Source: AGHT+IFBiLue3QFOk1WR26MRKOBV5299+r2MgZ52axZ/Ki/sFLcqtDTCw32+oxmnpnFn89KL/PCW6zIy0IG54nMMM54=
X-Received: by 2002:a2e:4a0a:0:b0:2f7:6869:3b55 with SMTP id
 38308e7fff4ca-2f9cd40052emr9790031fa.21.1727361913927; Thu, 26 Sep 2024
 07:45:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
 <20240906-wrapped-keys-v6-6-d59e61bc0cb4@linaro.org> <fc780dc2-5a69-48d8-8caa-ca2ee97d10ef@kernel.org>
In-Reply-To: <fc780dc2-5a69-48d8-8caa-ca2ee97d10ef@kernel.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 26 Sep 2024 16:45:01 +0200
Message-ID: <CAMRc=Md3itY5N1gErL-VDAz0qW6DrHPKpXzT6kNwc2HVfvchpA@mail.gmail.com>
Subject: Re: [PATCH v6 06/17] firmware: qcom: scm: add a call for deriving the
 software secret
To: Konrad Dybcio <konradybcio@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Asutosh Das <quic_asutoshd@quicinc.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Bjorn Andersson <andersson@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, linux-block@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-mmc@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 9, 2024 at 1:23=E2=80=AFPM Konrad Dybcio <konradybcio@kernel.or=
g> wrote:
> > +
> > +     memzero_explicit(secret_buf, sw_secret_size);
> > +
> > +out_free_wrapped:
>
> Is there a reason to zero out the buffer that's being zero-allocated?
>

It's my understanding that it is a good practice in crypto routines to
immediately and explicitly zero out the memory used for storing
secrets.

Bart
