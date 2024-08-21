Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AA21509A2
	for <dm-devel@lists.linux.dev>; Wed, 21 Aug 2024 17:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724259907; cv=none; b=KAEnI8SMJ4GxoGzocMfgpyBq56cuQL8y6DEvV28peYqdOCgL5yrYq6eXHDeMSKCE8jNA11MLUkcFRiQ77/2f6PivEGkbc7se7p1dYkQ/JJ9NgLePltNHUl5bik6qujGrIlJtubj312nSd26vXZm4WoJk6mhuY6wKKAANezinl2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724259907; c=relaxed/simple;
	bh=h+PF6jpu1XG6hiUbEzNYEfutpiaFho4HuTYcLFDAG6U=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nXkCQMF2oPnYHp2BH94yU1lB1TgBIZi39bsEWW2fY4bZps+AaMV8i78Fo0twFI7+oMSFq/Iu4aZu1wWu9ge3lWrRi2sv9CMAc52+HdolPHrLM+u/k4I2pZboayW8eMoJ9xS/WQhdEVi2cGIVrfwxqxIc5Z6jCFl03dlCkc8UIAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1knhH9/r; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1knhH9/r"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5bebb241fddso457a12.1
        for <dm-devel@lists.linux.dev>; Wed, 21 Aug 2024 10:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724259903; x=1724864703; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h+PF6jpu1XG6hiUbEzNYEfutpiaFho4HuTYcLFDAG6U=;
        b=1knhH9/r7MeKyISZVTv/VskIyaqkIb1uaFc75hDWQelWQRr3LPZtpzaKe3NF9qxwcn
         4YT5IqUmCUqCC7SYJC18lhW3dr86n/KTgOYXf1pE6qjIKAZesgsNcb694I/uCFNb2a+Z
         UHDL6drqr49TY95G5tax2ZOREzfymf6J7zs94btb2ySvX5/ET79QvLiPXilWgGja1Tww
         xjaqd+hXX+zTcyv1FlCixKHGfT7NqhtCJA5x1d9QkI4etqVZaJOpzXCXgk3q25beUxzl
         1kcqMutlGGfCaVLjkrDeTHV5jWQToTX6HSkag33qLsIJjJn9JPHMlJjN+k1tR4spCyRb
         75fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724259903; x=1724864703;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h+PF6jpu1XG6hiUbEzNYEfutpiaFho4HuTYcLFDAG6U=;
        b=vb2KIDZGTvYuo+YHiNE2BLuN29fqX9A3fBOjWccy9CprYdZTE2pDgj/Sm52dbvCdyX
         r06VMxa85FU/LNkEn1YSc1xIhTWsej6du/RRvT/zQqf1B79ijzh5XOVIn2zYmQU9yKBo
         QT98TzeYCUZUUyPxmAAbQfeUkRvureWcKVDLlLo500F+v8ky3vNbhdRIKsKBJvStvmCv
         XLtEhTQtLxC3LtlpZMnjSJ3VqKwcg0NAwnWmSOZSr0/d1Qk/9x1YMdS09FEli2h60eFA
         wPEYkre9+kWU5Q2pkOGnJ/R8dTglrTNhOhAFvk5n8v+bj19PIx/FzBMk6pNmcklAax00
         pN9g==
X-Gm-Message-State: AOJu0YxDzzMxHdyI9/n39INA2pWnbi64r8I647/Z1R0TpMy7J8fVuRCA
	whLxHcuYgJOZDLXWhdKWUwviawS5osnGtnPvDUDRYnaUYljAqQb1Bjwtfyge4S87lFD1XEd9PhE
	hd3xlDJc/1ArhSI3TKtGnKSqEg+NZbuqyu3kAnbHlGjN78hA043gI
X-Google-Smtp-Source: AGHT+IHjaqqFjKxrL6Ts4pjB70bLAnySTRqfGOFdeQiwUN2AdHtsekSyltMW9KETv/SOaMDeIgPJtF8zxw5rCmwNq3I=
X-Received: by 2002:a05:6402:26c4:b0:58b:15e4:d786 with SMTP id
 4fb4d7f45d1cf-5bf0e5a2814mr324331a12.5.1724259902971; Wed, 21 Aug 2024
 10:05:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Robert Pang <robertpang@google.com>
Date: Wed, 21 Aug 2024 10:04:50 -0700
Message-ID: <CAJhEC05N5HM76OV7BJpNkxXLaSuhgBwPdGyBwHeVTaMiLGMXZg@mail.gmail.com>
Subject: dmstats seperate read / write latencies
To: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi developers

To measure I/O latencies of mapped devices, I see that we can use
dmstats. From the manpage [1] and from my tests, it seems like
latencies are not reported for read and write ops separately. I
checked dm_stat_for_entry() and it looks like we disregard the I/O
direction when tallying in the histogram.

So is it correct that dmstats only tracks and reports combined
latencies? Is there a way to measure read and write latency
percentiles individually?

Thank you
Robert Pang

[1] https://man7.org/linux/man-pages/man8/dmstats.8.html
