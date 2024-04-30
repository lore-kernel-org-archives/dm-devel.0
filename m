Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F30B171E67
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 16:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714493572; cv=none; b=eXUVLNclR686q87UeGhA7k6RMuHpLHciL+7LEnIyxDin4Yd2YE9Bb5ZQ0ZV4BHTyCFSsJxDjADwVLskDpxEPUkS+WcKGi40AO8yvWysE6G0qj4Ub1OrpWeIT68wFiRf7G0hVIZpYXDzt7xb7F381wS8wH0KOohkZ7gmmTvJdYDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714493572; c=relaxed/simple;
	bh=BoGZkMO6fkNInTqbk+uc/HetlMwIedWQg89taSWr3fQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rf4YPLZy7zFLKFhvD6jfHcYqIJhDJsyBy41i9xlxV1KRJpPL/WDMFc2CRHktz3rHkv1KBFr6MuwRGLMnBvpg0n+uvBJwJBrwLClmztHopS0MvsLnRACtw4040wrY8/8NZPS5vxgtL+kk7DWOvFQrprNBa0PxNhhgr1wQX5caaTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com; spf=pass smtp.mailfrom=linbit.com; dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b=TfUej9Ka; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b="TfUej9Ka"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-51d62b0ecb7so4896096e87.3
        for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 09:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20230601.gappssmtp.com; s=20230601; t=1714493568; x=1715098368; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BoGZkMO6fkNInTqbk+uc/HetlMwIedWQg89taSWr3fQ=;
        b=TfUej9KaGlU58Wqb9MuEYfva2Kygn5bFF8ZCEli1ZI9ZUSrF4j/4exz+fLtE1HkWPm
         ZdDEfhxNprvfTfeCRYwH2afro10VfOqpIKe7K3cgRDotqfz2nAZw8Lm5i+JYUhrGxZ8j
         YSfBCE22uhP/vCmLJHpkZOUH1qsMa1Gm3wrtwI4Tv/TDCEasjZk+Jl+5uiCCYOn/+8NN
         ngslPdelNZpu+pgJgV1ArhqpjNEqXpQPfuuU8iDv5tzqKjl7zEZN+TpUDFSUApVz9f1I
         P9FDRnGL+NaXEcwTObiKDdh3c8n/Lmk9CTOAlXH9sVFJPSLjJ4DQbFc/2q5vGgGUKFIf
         7n+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714493568; x=1715098368;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BoGZkMO6fkNInTqbk+uc/HetlMwIedWQg89taSWr3fQ=;
        b=sBDwPh5iTYxQF6Hp/EkFG9lYNvz+w47VuX5c61PZM/M3VPo0h/Cf/mM8vae0hc0bt0
         X4botlY9zXqpjF46ULlTD5pFfLXJ+Re40Y0Hp6oJ11i9iyrm/dlGjVUHwFbYxL4jsSk7
         DdVzOjNZEpP9oeQoql6ipm5cilSOsX/G5c47zbnkNOxoASZOfjEMBgvcUeAL83La7H0E
         LNB8Mqj+vQJkcctZGmsl0v+jCN8QTZL2IRFmYXpi79E+nbKHeZxDfpkrjUj9PKiRcsDW
         fhkAKCYxKBitkFcpSWDnjfA6kHGlGS+FcE9X8UotEFgaQljjYo43+mYEJGhNKGmHVtPz
         qB/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXhc7CZcPoXAFHd84QJUr8HsEkLmAlHMwuTgmeit7CV4upQmBXNEep7AmZfemLb3H6w0TfEEiQ1uKTeGZJNicMyr3uYBjyiFhM=
X-Gm-Message-State: AOJu0Yw8ycLQ+hC6TiiNsCpeBq8bALdGsmg5r3RtEeTqXTM6fKdYBNOD
	fKxgNNb8DyqBUN8J02FANHD4gyg7EIyTiiw+Rilq8OheVJLVstJkaF7tqJyv2m9QI/wyezD3UV6
	h2L/fWdtSPOdXgUbM4QLDvh0hwQAgoMvqKQut7g==
X-Google-Smtp-Source: AGHT+IGiw736SWHN5lPtqiIAKDxxRH4iuI88nVBI0BdBh3W3mvh2Yz7DXlY1t0BvpVo0g6DcryRYHBZE/xkK65u9MNQ=
X-Received: by 2002:a05:6512:2033:b0:51d:9e17:29f0 with SMTP id
 s19-20020a056512203300b0051d9e1729f0mr5377196lfs.24.1714493568350; Tue, 30
 Apr 2024 09:12:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240426072135.291206-1-joel.colledge@linbit.com>
 <20240426072135.291206-2-joel.colledge@linbit.com> <71a31fdb-fad6-4ce9-bda0-2f86633d23a3@arm.com>
 <CAGNP_+Uocb_8YtY9P3EuMQ8sQwWaQtqEMszqbGZrVyrKw-udRg@mail.gmail.com> <bc673c7e-f705-46ce-a3c0-0d34f612fe30@arm.com>
In-Reply-To: <bc673c7e-f705-46ce-a3c0-0d34f612fe30@arm.com>
From: Joel Colledge <joel.colledge@linbit.com>
Date: Tue, 30 Apr 2024 18:12:37 +0200
Message-ID: <CAGNP_+WStY+C9=eT=gzC-dYhMtPTj4kzKDSuYiVHi0w41Qa_8w@mail.gmail.com>
Subject: Re: [PATCH 1/1] dm-delay: fix hung task introduced by kthread mode
To: Christian Loehle <christian.loehle@arm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 30 Apr 2024 at 17:27, Christian Loehle <christian.loehle@arm.com> wrote:
> On 30/04/2024 15:44, Joel Colledge wrote:
> > On Tue, 30 Apr 2024 at 16:28, Christian Loehle <christian.loehle@arm.com> wrote:
> >> Is this an issue for delay > 0 too somehow?
> >
> > I believe it is. If there is simply no IO to the delay device, then
> > nothing will wake the new thread and the same issue will occur.
>
> Yes, but might be better to just set_current_state(TASK_INTERRUPTIBLE);
> instead of the wakeup.

I'm afraid I don't follow what you mean.
set_current_state(TASK_INTERRUPTIBLE) would need to be called from the
worker, but the worker isn't running yet, so it can't do that.

When preparing this patch, I checked how common kthread_create()
followed by wake_up_process() is. It is fairly common according to
this very approximate metric:
$ grep -r -I -A10 kthread_create | grep -c wake_up_process
49

I just looked through those matches in more detail and noticed that
there is a kthread_run() macro which does exactly what we need. I will
change my suggestion to use that instead.

I will wait for more comments before sending a new version of the patch.

Best regards,
Joel
