Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2165189916
	for <dm-devel@lists.linux.dev>; Mon,  5 May 2025 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746462628; cv=none; b=k2vje3mJi0VC7jmNGdjFhxBa8xNGGQd+3JDZ4MNxwuZDgofZT8B9zHLHxMbjgCGvaJzrb+CXwECwp2y21TwI1nkBE51Js/RZkWjv1YDt3V0NfOR0W+xyUeeQDKNEMGvRQSfpZzMwWOdt1a/5LEZ58ePOkhEjdehnvc/98cKTwvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746462628; c=relaxed/simple;
	bh=vuNM9LTXUreH/rrIpEhWR4I9JEYP1Er0bcoMq2fbcVY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aIPvD2T+m+GKplGBdVSL0aBaDrSDCNrDMlk+W65XMo+tOQ8Lc2KsB/oEnyXmhC02JaaRm/clDbdvot8PIME4Iym481RqNSCAZHIK+32gxFIx3q+uCHCV+LMzcdUxyG5AwDYLrJB3T0Fu+ZmJwkBy78tEP+zUIHkwCELIZyKpeyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cGclZNyp; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cGclZNyp"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso42598235e9.3
        for <dm-devel@lists.linux.dev>; Mon, 05 May 2025 09:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746462624; x=1747067424; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4HL8qZhjL6jb2JVoPfk1gKfpUKMVCXLbJzecQfVQ2aI=;
        b=cGclZNypeZq9Y1ldcuoRloD3p5ApFsCNRdFzJcf+TVW9DuHvwVVvvsmh4UiT2KENaq
         PlYNWnebX7OE8sFEFx9OQt1guHn5wBaN4a5oLP1P8TUlEdCGk8KcjF7KujEJxLzvGe8/
         pOF2dbkV1tn9o16gz0tf9MsEHLW2Zh/AMRNcxprxrCQxHGxwD0Yh4wCd7PGtUerLNHrD
         5H84p+MzuJb8y8c5YGQRQx+XkAxjgV+/aOUswjnOuODN4C5pcEbWBDuWdhlqqirX3JQ7
         ckVGW5IT0HlU8+Z6fHPZBseT24p0P0P+mjVJth6PcnGM+CtZ/+rQCaq0XO/NjatdKv7m
         8Ejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746462624; x=1747067424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4HL8qZhjL6jb2JVoPfk1gKfpUKMVCXLbJzecQfVQ2aI=;
        b=Q7/f6Wua9wt8y9B0B4Q9jP/4fuqas2OVSI4KLE0qsoietnDQYI7mI+Gny32I/D1dOn
         sTZKpE9aVr1rKMVg+jWL8qKZMjwDcBDJadW4U7kYF47tupqV7D2s1Wst564yiobzTvAw
         wVPZz0mcEXDVWk+5q5p7ZgxDZ7d/uqoSW0DyNDlOrHzspofTuH7JqkpNM4CGQ79m2NK8
         Qa7rzMxUTwL4EL0OmVTu01o8/Y9sMjH/IrqRR13Jw6AayYgMb0J4uxQAe5Ir5j+LZbqv
         hPuvHD4HS07Rb5PdVd3yrqJzyBxv9HFsNbTTXLczj9vt59XI2y4MKLDrKka5h8Wj+Fbo
         xipA==
X-Forwarded-Encrypted: i=1; AJvYcCX75e4pokEdKQYMKC6oQe7RnZduBHXOZwDGOjH2TG7DcZlXfeYj2ulWZaPpgj/o8Hy+DSZT+39DNA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7KGYNAaD6X+cuvBKLSh4keasYaDTEsK34NBqbEyhW2+GjeGSU
	5W5X9aedPs+OUN+UDfsdTZTJUa73S8sOoQ4kz/dbItHLUWxM1BzztmczGWBOqWc=
X-Gm-Gg: ASbGncvupybPLo88Rd5oxAWiHK08c32zTbQH+lAQK04Qm3vEW+bgvMzXsXAi1CpwMdy
	DCx12lxwKV4VANJAAwhaX42FjvWB3SvLh19wKzUo80KKKiIS97Sh3m2G3C6M8B6kXSiuw+cXMpZ
	P7tyHhSdaPC3jNy9KeNkXlLtBtEZkzDCFHzT7dA58eMp9vxqvMQKPPS2P33Pqjvtdx3shFz6y2M
	orokz2tEnfsWX/7SZpst9st3Dk7JO4fyAOzECMzqeqgJj4QhBp6CMyCdoow7X9GLytHHdXSwaZ0
	UdlBdt1P8npq9jzSgXDl3GzX0mB7yYunX9dSnSV/L89q+bZi797olIzu014RkM2b+zDKwpHKAF3
	aInif8Wt75G6c1qB0uospkwrv4gEX
X-Google-Smtp-Source: AGHT+IEe5qvGCGx128Reawc1fSjx2g0lxgEJ2QsNOggnnuXipFO6McB40Ch2sdMBhqX4jgjswBABUg==
X-Received: by 2002:a05:600c:3e09:b0:43d:82c:2b23 with SMTP id 5b1f17b1804b1-441c49236ecmr54202715e9.23.1746462623634;
        Mon, 05 May 2025 09:30:23 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a099b16ea2sm10669571f8f.85.2025.05.05.09.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 09:30:23 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 0/6] multipath-tools: static analyzer fixes
Date: Mon,  5 May 2025 18:29:52 +0200
Message-ID: <20250505163007.59352-1-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Xose has kindly informed me about the warnings from Fedora's static
code analysis tool.

I'm sending a couple of related fixes here. Most of the warnings
appear to be false positives though, see below (a second look by
another eye pair would be appreciated).

Regards
Martin

On Sat, 2025-05-03 at 23:29 +0200, Xose Vazquez Perez wrote:
> Findings by static analyzers in Fedora 43 Critical Path Packages:
> https://marc.info/?l=fedora-devel-list&m=174582743823723
> 
> device-mapper-multipath-0.11.1-1.fc43:
> https://openscanhub.fedoraproject.org/task/51915/
> 
> device-mapper-multipath-0.11.1-1.fc43 List of Findings:
> https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html

I'll leave the shellcheck errors in mpathconf to Ben.

> Error: GCC_ANALYZER_WARNING (CWE-775): [#def42]
> multipath-tools-0.11.1/kpartx/dasd.c:89:24: warning[-Wanalyzer-fd-leak]: leak of file descriptor ‘fd_dasd’
> multipath-tools-0.11.1/kpartx/dasd.c:69:1: enter_function: entry to ‘read_dasd_pt’
> ...
> multipath-tools-0.11.1/kpartx/dasd.c:134:20: branch_true: following ‘true’ branch (when ‘fd_dasd < 0’)...
> branch_true: ...to here

This one looks like a false positive to me. If fd_dasd < 0, it can't be leaked.

> Error: GCC_ANALYZER_WARNING (CWE-476): [#def45]
> multipath-tools-0.11.1/libmpathutil/parser.c:139:29: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘keyword’

False positive, too. VECTOR_SLOT won't return NULL here. 
We could add a test to make the compiler happy, but I don't quite see the point.

> Error: GCC_ANALYZER_WARNING (CWE-457): [#def49]
> multipath-tools-0.11.1/libmultipath/alias.c:201:31: warning[-Wanalyzer-use-of-uninitialized-value]: use of uninitialized value ‘bdg’

False positive. bdg won't be NULL here.

> Error: GCC_ANALYZER_WARNING (CWE-465): [#def50]
> multipath-tools-0.11.1/libmultipath/dmparser.c:31:12: warning[-Wanalyzer-deref-before-check]: check of ‘p’ for NULL after already dereferencing it

False positive. *dst is non-NULL when we call merge_words(). We must double-check
after calling realloc().
(That said, we should reimplement this using strbuf functions).

> Error: GCC_ANALYZER_WARNING (CWE-476): [#def51]
> multipath-tools-0.11.1/libmultipath/dmparser.c:436:25: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘pgp’

False positive. VECTOR_SLOT won't return NULL here. Same for the next 3 errors.

> Error: GCC_ANALYZER_WARNING (CWE-476): [#def55]
> multipath-tools-0.11.1/libmultipath/dmparser.c:501:33: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘pp’

Likewise. Same for the next 2 errors.

> Error: GCC_ANALYZER_WARNING (CWE-476): [#def58]
> multipath-tools-0.11.1/libmultipath/foreign/nvme.c:494:28: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘path’

The nvme_pathgroup is a member of struct nvme_path. nvme_pg_to_path() doesn't return NULL. Same for the next 2 errors in nvme.c

> Error: GCC_ANALYZER_WARNING (CWE-476): [#def62]
> multipath-tools-0.11.1/libmultipath/pgpolicies.c:191:17: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘pp1’

Again, false positives; VECTOR_SLOT() doesn't return NULL here.
Same for the next 3 errors.

> Error: GCC_ANALYZER_WARNING (CWE-401): [#def66]
> multipath-tools-0.11.1/libmultipath/print.c:920:16: warning[-Wanalyzer-malloc-leak]: leak of ‘alloc_path_layout()’

False positive. Strange one - gcc doesn't understand its own __attribute__((cleanup))?
Or am I blind? Same for the next one.

> Error: GCC_ANALYZER_WARNING (CWE-126): [#def70]
multipath-tools-0.11.1/libmultipath/uevent.c:122:9: warning[-Wanalyzer-out-of-bounds]: stack-based buffer over-read

This one is somewhat harder because it involves list handling macros, but I believe that our code is correct and that this is a false positive, too.

> Error: GCC_ANALYZER_WARNING (CWE-775): [#def69]
> multipath-tools-0.11.1/libmultipath/sysfs.c:309:22: warning[-Wanalyzer-fd-leak]: leak of file descriptor ‘open(&pathbuf, 0)’

Again, false positive; there's a cleanup function for fd.

> Error: GCC_ANALYZER_WARNING (CWE-775): [#def71]
> multipath-tools-0.11.1/libmultipath/valid.c:208:34: warning[-Wanalyzer-file-leak]: leak of FILE ‘fopen(&mountinfo, "r")’

False positive, gcc doesn't understand the cleanup_fclose().
Same for the next error.

> Error: GCC_ANALYZER_WARNING (CWE-415): [#def73]
> multipath-tools-0.11.1/multipathd/fpin_handlers.c:508:17: warning[-Wanalyzer-double-free]: double-‘free’ of ‘els_marginal_list_head.next + -2056’

I don't see an error in this code. Looks like another false positive to me.

> Error: GCC_ANALYZER_WARNING: [#def74]
> multipath-tools-0.11.1/multipathd/fpin_handlers.c:624:23: warning[-Wanalyzer-fd-use-without-check]: ‘read’ on possibly invalid file descriptor ‘fd’

False positive, too. fd == -1 is checked beforehand.

> Error: GCC_ANALYZER_WARNING (CWE-688): [#def75]
> multipath-tools-0.11.1/multipathd/main.c:3286:21: warning[-Wanalyzer-null-argument]: use of NULL ‘new’ where non-null expected

Similar to other false positives above, VECTOR_SLOT() won't return NULL in a  loop like this.

> Error: GCC_ANALYZER_WARNING (CWE-775): [#def77]
> multipath-tools-0.11.1/multipathd/main.c:3973:12: warning[-Wanalyzer-fd-leak]: leak of file descriptor ‘dup2(open("/dev/null", 2), 0)’

Yet another false positive, the fd is closed in the cleanup handler. Same for the next 3 errors.

> Error: GCC_ANALYZER_WARNING (CWE-476): [#def81]
multipath-tools-0.11.1/multipathd/multipathc.c:97:30: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘kw’

Another case of VECTOR_SLOT() false positive. Same for the next error.

Regards
Martin

Martin Wilck (6):
  kpartx_id: fix shellcheck reported errors
  kpartx: fix file descriptor leak
  libmpathpersist: fix memory leak in mpath_prout_rel()
  libmpathutil: silence compiler warning in vector_del_slot()
  libmultipath: fix undefined behavior in 31-bit shift
  libmultipath: prioritizers/iet: fix possible NULL dereference

 kpartx/kpartx.c                     | 14 +++++++-------
 kpartx/kpartx_id                    |  8 ++++----
 libmpathpersist/mpath_persist_int.c | 12 ++++++------
 libmpathutil/vector.c               | 16 ++++++++--------
 libmultipath/nvme/nvme-ioctl.c      |  2 +-
 libmultipath/prioritizers/iet.c     |  3 +++
 6 files changed, 29 insertions(+), 26 deletions(-)

-- 
2.49.0

