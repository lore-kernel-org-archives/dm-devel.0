Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC9D135A59
	for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 18:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293645; cv=none; b=qnaGvLeAGBoaQVOMWGWMqDQ3I9CwGYJYoNHRBqSmby24zUiveGbL0woutROBUdEGoLYywMibZmG4//LMX0bvK1auxzcnDywK1YQ9+3NLBU9ZDlXEBC4ze4MjBZD/YSx838Pu5YEYayc7URu/pcF4qT6gkQy/VrBRGB4PwMNLAfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293645; c=relaxed/simple;
	bh=W7BoatVACwIPXu+FXpbkJHEM8N3lO3XG8oHE5V3nYLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jNZ/FlLmSA7Fe5mnRz+Nr0p+5bSIFZvgc60BqmsTI2jupEp9ez9fRFbCVKs+PHj2iBM4/SlpAO1scOolf5YA3yun64uN7ynVV1keiCcoxDN/GW2xsVnTyhijKinPoJNjro6sd7dY4pRNKwfK0fOqMRSBjwaPNjjRn9CiQYtDZHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C2/iSgkx; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C2/iSgkx"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-518a3e0d2ecso5854305e87.3
        for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 11:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713293642; x=1713898442; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FSPsMrJEvBxc1T0PtDxpSVsVzNl/W7uQZoqywMwNj/s=;
        b=C2/iSgkxZl59A8CbvkijEAnEA0zG6KuL+SpnXCTH6lvhsMKvMTMCEBi5OatpYBC8yK
         yXCTjpvLYAQMZY3NRDond4r3ju7HgwANSwIprDTUZXPH2zv+DWfDeXKceBQysI5oQD7e
         YSV1JEsfXK9vt08swPrXBIATqdts+HmP696B31TTrsyl3kEAgRv2J8kaWtPSSRzpDEM9
         bC2xmwzR2BOtKDc3+ALHdvG/Zs6Qs69acQbUgm6YXtvqmLsIUtRZg+bqyLxST6pQxrtB
         oT1FKq7HYT/zM/iHPMEbIvur+PP9euwWY7xDfbh7cnyYtB2qdbKjHxgQA/qo0fnRj5Rk
         0KzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293642; x=1713898442;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FSPsMrJEvBxc1T0PtDxpSVsVzNl/W7uQZoqywMwNj/s=;
        b=fiRGcjfkaTyF2hvfSibJseTAUd89u0BI3RPnzfhrfh4mIPNd9V76kcA4R40xE7Rpz5
         1rfsGnPxoVB0kjXaliO3HTkTSCxHaamT+y5Z7Pe7VaUeMre5mkyuMtfyckFMst2uFnYk
         MczKDE9BEr2yaVGZ11Pajlkgoy6ZMnwsPcGN4SJNHLJ8MCzARmTDGlvCyNyTTlfGe+Cy
         9AvObu34cVX/YH0ZU5vOcegvR1MFyczBpKqXZtNbtb8UrFV8Cz2xZuRKVuoot0Z8CGgU
         Zk7BxbAm5FH0gcPMBkoTKXgKeAWp/un3YiEFYgYWR51TqbbU4HNyLDlChMLsDKAgUpil
         kGgw==
X-Gm-Message-State: AOJu0YxgZ7fR7Kbhg37J4+VKXKfHdKJaKVjP2+gpOh6fHfdk2kqmVUNr
	5ugWR1u13b+kje2YSKovfVYEMGjkFZnRtD1vZH/JFyU0ur8Yr1Ya3K2bGpDm3R4=
X-Google-Smtp-Source: AGHT+IH5cKcbEOb4uUJaQvMwrmVn0XCptQaNvK+dII3v0Jmz5a3mhHe59hDvCPY7zXgyOnjxryDOVg==
X-Received: by 2002:a19:9151:0:b0:513:cfaa:e618 with SMTP id y17-20020a199151000000b00513cfaae618mr10945866lfj.0.1713293641630;
        Tue, 16 Apr 2024 11:54:01 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id h24-20020a170906261800b00a528064f438sm2497942ejc.34.2024.04.16.11.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 11:54:01 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH v2 0/2] multipath-tools: CI fixes for glibc symbol substitutions
Date: Tue, 16 Apr 2024 20:53:49 +0200
Message-ID: <20240416185351.30670-1-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Or cmocka-based CI relies on the ability to wrap functions calls, both
our own code and from and system libraries, with the --Wl,--wrap linker
flags. This works only if the function name in the function call generated
by the compliler is known. glibc has introduced function substitutions
for multiple system calls that break this assumption and thus break our CI.
For example, a C call to open() may be translated into a "call __open64_2"
assembly instruction.

We have first seen this with 7b217f8 ("multipath-tools: Makefile.inc:
set _FILE_OFFSET_BITS=64"), but also happens independently of the
type size macros. The 2nd patch in this series works around a
compiler-dependent substitution.

This has an unfortunate effect on our CI code, which is becoming
increasingly hard to understand, with lots of #if's with workarounds
combinations of library versions, compilers, and compile time settings.

CI failures have lately been caused much more frequently by this sort
of failure than by actual bugs in our own code, which is causing significant
maintenance effort.

I am not sure how to deal with this in the long term. I don't see a general
solution, although it's unlikely that only multipath-tools is affected by
this problem. For now, here are patches that fix the recent CI regressions.

Changes wrt v1:

- 1/2: fix compilation with DIO_TEST_DEV set (Ben Marzinski)
  Note: this fixes the compilation, but the directio test itself fails under
  qemu-linux-static. See commit message for 1/2.

Martin Wilck (2):
  multipath-tools tests: fix CI failures on arm/v7 with glibc 2.37
  multipath-tools tests: fix CI failures with clang on Fedora Rawhide

 tests/directio.c | 28 +++++++++++------------
 tests/dmevents.c |  6 ++---
 tests/sysfs.c    | 58 ++++++++++++++++++++++++------------------------
 tests/test-lib.c |  6 ++---
 tests/vpd.c      | 35 +++++++++++++++--------------
 tests/wrap64.h   | 39 +++++++++++++++++++++++++++++++-
 6 files changed, 105 insertions(+), 67 deletions(-)

-- 
2.44.0

