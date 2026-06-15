Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894052C08DC
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 21:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781557253; cv=none; b=ZkwkBS7id4raDvf9Xa6g222dKVzzrh+SPL15laQuVWK9Zmt4mWkcjEEQNZEx/8NEP3E+H8O294uKEjH5mZIvfOj+3vHJ8aMJJ4d+NKqhjrxOKeC4Qi9P/ZuViZ2gk93c/AEPO4NkQM3k1d4MT6kclcpUmXS50h4Ua9JhmeLrW68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781557253; c=relaxed/simple;
	bh=I0Io1kcsG3Zip6qiGIg8op8tZmVT96s6m4/ykk41h6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y1FVGQebM+1P8H//386YZkHkcBvlDLK/X0+c4b9UjJ7KPgAJHnHS2Vduqyxy9Lj0CEXo7U1wYguGYTyWmNOm7HIsxTSufcnOzqEY7rrzX1gHhqTSbPyDsgWpkl6NxGdHC7xQIHVtQcenwWEziaYdIhs7+7gxy+5UA4zxIZoMhZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VVL+5ZPj; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VVL+5ZPj"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490a762c8d5so2559925e9.0
        for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 14:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781557250; x=1782162050; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=syspVEp8JIAklYzLeU4FW72cFneOaL9fvD/CnKViutc=;
        b=VVL+5ZPj/+mfO4CVgxhXf6mcA/wy7J4CZLwLNFCblmjoOTRV/aobrVY01BXfb1fpg2
         3x7DFZrXOiyr9ibX6i4crRdtagk1/tV8TPAKnUz+6PxZwbA26z81xnMC0+LS9IFizJ0k
         4/sBDYTyftI5yye1thkhjzYoQAZa+O7Ic2riC7QhM+v8eVlTCj1mRm1AY4ughYcK6lcf
         myBCgP79b7vir+QMnVJuFK2gfVMwHgTKVhvzZxolxaHr2yvJ/AMS8OX07AAvII8c7dmp
         6lDHfM+b+ms4SCS82m6L3SaY/HW5oDwbJK9BRwvFLz7gQj8CMgiCtlvMuUO3iY3p1mx4
         eJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781557250; x=1782162050;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=syspVEp8JIAklYzLeU4FW72cFneOaL9fvD/CnKViutc=;
        b=c3oi1p+FHSlvDi6/ET0YV5tccK1/PTuiYw68RQIOX1dO9ZiHw+je2V2t6AIJLdl5Y1
         Q8oTIYLErKnZVDdxUduvVoJoAJ/sbHQC3wsFLxiIV00x9sKAMohYM4Aciqmjx8NIWW74
         3Td/D2U92Rq4SFSUg+zw9FC1nqatQZwg2W1Jiw4MCWnEVgLj02zkfp7HRvKZo/k+7zqW
         j3F9rKezEbXW9Z1H5iwjdFddayLLipd0Si+TxeP4/2K+AQroPe+rjUAiN7iMn74WwthI
         YJZmhT0GpuFIWB/wNQ1idh2FtPeeCVqjJWRN+2Zic1cgC/Gz2DOCHClFAz4wKYOxkwov
         rbEg==
X-Gm-Message-State: AOJu0YxuMUivbJfWZz1zjKngX11pd1BRwZb05/Swy01N/yedXcbwlBOL
	jApfZso/73Q9prWKpi7q/3fLPO7xA5IC+6XNhyKEfoHYpyRip5YRYSE=
X-Gm-Gg: Acq92OHZartYeeEHBBUXewOwhlstTgLiLYYDdJYKGM1DxKFtMXJH6qHsUl8KbcsPD7T
	DZtKEjvRDP9DTdHiyJ88tx3VrPlBmjmJ3Ew0TZNkN26p24+fez9C5XuYhcZ1N9vPAcjaF1weF7P
	Onfq+q4Fp2BUb98qYV4dT3KrtpTvn+oUFb7Qx7StxXF9RcDKJ4hvmjpwIJeOtW8k9ifQkfmVJO8
	MUeB/REArQBckJWOGJ/U3SFF9jQ4nHITAp1H25w8zRVtMg2pGP5s1nuJvZlx7uNzMZZZOZi4a2W
	CpxtpaiVa3ETJ96nwybBhMGMOO5o3qphEF9YNRrl/6sKUu+yGY0x66bT/JyjflWpewCCbW2j6Xy
	rrN4V8YM0tqLU/IyvLPfzQFOVYXatijLJLYULdf5S4Q+I10J7y1R62ARRJILYQ3Mh6z9rz7RYOb
	JpNhWoP6ENnxebkBy0tRebuGaInSQP/kbkwZcEOHQvCMvSdV8Xq+XKfGtD+sXTp9ZU
X-Received: by 2002:a05:6000:4b16:b0:45e:f45c:537a with SMTP id ffacd0b85a97d-4606dba4531mr10602976f8f.5.1781557249566;
        Mon, 15 Jun 2026 14:00:49 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c473bsm41635279f8f.28.2026.06.15.14.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 14:00:49 -0700 (PDT)
Message-ID: <8b715fda-3e14-4a6d-bba0-a3e53481f567@gmail.com>
Date: Mon, 15 Jun 2026 23:00:48 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] minio cleanup patches.
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
 Martin Wilck <Martin.Wilck@suse.com>
References: <20260615190711.797573-1-bmarzins@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20260615190711.797573-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/15/26 9:07 PM, Benjamin Marzinski wrote:

> This patchset is to deprecate the rr_weight, rr_min_io_rq, and rr_min_io
> multipath config options. It's a companion of the patchset to handle
> their deprecation in the man pages.
> https://lore.kernel.org/all/20260607103831.336833-2-xose.vazquez@gmail.com/
> 
> It does not completely remove the minio setting code, since there are
> ideas for reusing this in the future. The final patch is simply a change
> to avoid a kernel warning message that I hit while testing these
> patches.
> 
> Benjamin Marzinski (4):
>    libmultipath: deprecate rr_weight, and make it do nothing
>    libmultipath: deprecate rr_min_io_rq, and make it do nothing
>    libmultipath: deprecate rr_min_io
>    libmultipath: don't set hwhander for bio based devices
> 
>   libmultipath/config.c    |  6 ---
>   libmultipath/config.h    |  6 ---
>   libmultipath/configure.c |  1 -
>   libmultipath/defaults.h  |  2 +-
>   libmultipath/dict.c      | 90 +++++++---------------------------------
>   libmultipath/dmparser.c  | 28 +------------
>   libmultipath/hwtable.c   |  3 --
>   libmultipath/propsel.c   | 54 ++++++------------------
>   libmultipath/propsel.h   |  1 -
>   libmultipath/structs.h   |  1 -
>   tests/hwtable.c          | 13 ++----
>   tests/test-lib.c         |  1 -
>   12 files changed, 33 insertions(+), 173 deletions(-)
> 

Ben, thanks for this cleanup.

I ran grep to see what remains of these options in the codebase.
Could you please check if any of the following occurrences should have been
removed, or if they are intended to stay for now?

8<---
$ git grep -Ei "rr_weight|minio|min_io" | grep -vE "multipath.conf.5.in|deprecated"

libmultipath/config.c:  merge_num(minio);
libmultipath/config.c:  merge_num(minio);
libmultipath/config.c:  hwe->minio = dhwe->minio;
libmultipath/config.h:  int minio;
libmultipath/config.h:  int minio;
libmultipath/config.h:  int minio;
libmultipath/configure.c:       select_minio(conf, mpp);
libmultipath/configure.c:       if (cmpp->minio != mpp->minio) {
libmultipath/configure.c:               select_reload_action(mpp, "minio change");
libmultipath/defaults.h:#define DEFAULT_MINIO           1
libmultipath/defaults.h:#define DEFAULT_MINIO_RQ        1
libmultipath/defaults.h:#define DEFAULT_RR_WEIGHT       RR_WEIGHT_NONE
libmultipath/dict.h:int print_rr_weight(struct strbuf *buff, long v);
libmultipath/dmparser.c:        int minio;
libmultipath/dmparser.c:        minio = mp->minio;
libmultipath/dmparser.c:                        if (print_strbuf(&buff, " %s %d", pp->dev_t, minio) < 0)
libmultipath/dmparser.c:        int def_minio = 0;
libmultipath/dmparser.c:                                        def_minio = atoi(word);
libmultipath/dmparser.c:                                        if (def_minio != mpp->minio)
libmultipath/dmparser.c:                                                mpp->minio = def_minio;
libmultipath/prioritizers/path_latency.c:#define MIN_IO_NUM             20
libmultipath/prioritizers/path_latency.c:       if ((io_num < MIN_IO_NUM) || (io_num > MAX_IO_NUM)) {
libmultipath/propsel.c:select_minio_bio (struct config *conf, struct multipath * mp)
libmultipath/propsel.c: mp_set_mpe(minio);
libmultipath/propsel.c: mp_set_ovr(minio);
libmultipath/propsel.c: mp_set_hwe(minio);
libmultipath/propsel.c: mp_set_conf(minio);
libmultipath/propsel.c: mp_set_default(minio, DEFAULT_MINIO);
libmultipath/propsel.c: condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
libmultipath/propsel.c:int select_minio(struct config *conf, struct multipath *mp)
libmultipath/propsel.c:         return select_minio_bio(conf, mp);
libmultipath/propsel.c: do_default(mp->minio, DEFAULT_MINIO_RQ);
libmultipath/propsel.c: condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
libmultipath/propsel.h:int select_minio(struct config *conf, struct multipath *mp);
libmultipath/structs.h:enum rr_weight_mode {
libmultipath/structs.h: RR_WEIGHT_UNDEF,
libmultipath/structs.h: RR_WEIGHT_NONE,
libmultipath/structs.h: RR_WEIGHT_PRIO
libmultipath/structs.h: int minio;
tests/test-lib.c:       /* pretend new dm, use minio_rq,  */
tests/test-lib.c:       select_minio(conf, mp);
8<---

Regards.
