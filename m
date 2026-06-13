Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCA4375F82
	for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 10:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781347241; cv=none; b=XJAM9SBvE0IFMHMwIM1xEgEySZR/FEerR+D7UGfdYNgMkZ+EHZIyR5iF3YhKvpx6elLE9bAFsQIGzKeFnkDoFL996SRsd0UHAleP7kuoYdfP/1l9tHYr8nYfqZJ9304yzCYUEj0T51FKdFFr2uJzF+anTsrKVbjI/meSNhkWxok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781347241; c=relaxed/simple;
	bh=gm6Zj4SPmkTbJKlMjIQNXC81jFZZiG7qMZeBtf6moBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RZbBlFk8ppAWlHrxEMxtrlddSYMA7k25gdZ37uAPdwcfSrkuWAXwALg8oSEhjLg/yrQ3fri7PLbK5jtaODEzMFxYP+PtysaHMTvstnmWbBsbbGWhP5ZgCeov55okLlwhb3lI6dUxOkOP5cMUD2NpiS5zh9RRqsLRlnstzIq1j30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cy1NNJgr; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cy1NNJgr"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-45ef5b33e73so208165f8f.1
        for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 03:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781347238; x=1781952038; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5lwXKK8X8IM1ERwaIH8oXThZlb9TO95J6lSbOm0vOtA=;
        b=Cy1NNJgreD4HPUsLqOVwYHecVHhj5qmIz8sS6C/yfewB9ulmwZdI5ORrS2dihntgpg
         q5cEv4lXL+ILFV5ryJYQTQaU5E8EG1cSdc2b4blYWOwVAXPj4CFw4zSE9bbaohUmDbta
         wpiXTzcOmvC1hcXjCxnmLQ/HYyKlvjqpCqKzpeRKYo3vznHbLimrptsi023cm93gFliW
         n/myxlSasiC58zwOHXdZs6UKibPLuZUMh6Ks1d1oblvgTO5yHpOVy1C0/MamZkKNjVlM
         DCQxmXK9YrXWjGe+0yXq+DMCe2FGoAISex21/DdR/sb3AizDW+qsO2neMLp1t3FyewH5
         xfOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781347238; x=1781952038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lwXKK8X8IM1ERwaIH8oXThZlb9TO95J6lSbOm0vOtA=;
        b=aXiHS8eZhYoeMoeSHdyafSq89tScpxaKsh8v3RyU9Wsf9KfXQ/kbNZu5VcmVSKRsNv
         MTsFFggdA6bz4PFnOqQH6QglBDaS4TM9HaPyLo7eigt8j/pqO06xjMYxaN3kXfNjSo9n
         SLkJdQJd9Rlw2baWqJeMUrjSk2dgnSW8gWh0FspNR5zZl9c94cRN173xXBncDabfsp1U
         ExuLaecvR5YBiCit67uitMiRx1eif26Y4R06bsifkVOVRtNKQ7HCnuAIm01abOOQKct1
         0rQC2FdCB3D1QOV17/76acEH031+azdOgGGJJ5TRtXxFI7YL9B+V2IDk45BmZqEHF4uw
         o7VQ==
X-Forwarded-Encrypted: i=1; AFNElJ/6nQG4argWHuIT1rw/B/9n79JX5sfgaM5zZ3ylI1/50tyCIlW8nI2BtSwaMU57vGE6UJOrClKCHw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxAXeDXQjvbmlT3Hk6oTaB4er4hBlMyEqVDDHEYxrR5out9ELMy
	lXHvTx4h56Tspid1hRV8U8Jsu8fC8gJjcjCQMgE3ziwZQ9aPuSCAI50=
X-Gm-Gg: Acq92OG8qVX1qzWvG0shZ8KF/owzadSwD9eDuREwSfSeL/SM+g5bIFZlsxlWiGJTUlY
	8/RpGQuCb5orgeX+h/mE64/o+qdrCKgT3Svid89IxC4hgyLMcNNo+e3sx69VrkFXej/BR5Ylzqu
	cmgjJHTB8B2tmDMdbDrJow++11w+2+Kpt6irXmh3Tj93mhZN4jtItgb81bxGNRgS9WjGeyR0g4X
	RHqzXsSk2yf5DnshwpUMtKVjN+bN3uz3inzKxQVg2saLHMACoNSZV7bI6f48d1L4HVve5igPLKJ
	LKTT7eS6Y/8m+I58fOyISx/k9N+QeIGy59O5/0r+7PJzA3S1Fkb3db00rEZz+nZ0xBG80HoGdND
	rWB+v0NqyV8PHB+7ANb2N/EvInCLYOj6TYkfiiAPcIrkREV/5InxzpbxSlVk1xqDnKeFJdX/4of
	MXQoR1c598fKpbdUIDh0xExKJKT4eXIj6iPU0iTSQpbCYVgYuLBqzaOi+RRHLopEUB
X-Received: by 2002:a05:6000:260e:b0:45e:ced1:19c1 with SMTP id ffacd0b85a97d-4606db99b90mr3785948f8f.3.1781347238576;
        Sat, 13 Jun 2026 03:40:38 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0c10sm14553376f8f.21.2026.06.13.03.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2026 03:40:38 -0700 (PDT)
Message-ID: <f06ee4da-9643-408c-bceb-50a3ea954235@gmail.com>
Date: Sat, 13 Jun 2026 12:40:37 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] multipath-tools: update third-party valgrind headers
 to v3.28
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Martin Wilck <mwilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <20260608085547.41471-1-xose.vazquez@gmail.com>
 <aingoZvGkFxy8Wvs@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <aingoZvGkFxy8Wvs@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/26 12:09 AM, Benjamin Marzinski wrote:

> On Mon, Jun 08, 2026 at 10:55:47AM +0200, Xose Vazquez Perez wrote:

>>   third-party/valgrind/drd.h      |    6 +-
>>   third-party/valgrind/valgrind.h | 1182 +++++++++++++++++++++++++++++--
>>   2 files changed, 1138 insertions(+), 50 deletions(-)

> Is valgrind 3.28 released yet? I only see 3.27.1.
The files in this patch were updated using the official valgrind upstream
git repo, rather than a specific tarball release.

The only difference is:

--- ./valgrind-3.27.1/include/valgrind.h.in	2026-02-18 13:16:39.000000000 +0100
+++ ./valgrind.git/include/valgrind.h.in	2026-06-11 17:10:32.219080399 +0200
@@ -7173,6 +7173,7 @@ typedef
            VG_USERREQ__DISCARD_TRANSLATIONS     = 0x1002,
            VG_USERREQ__VALGRIND_REPLACES_MALLOC = 0x1003,
            VG_USERREQ__VALGRIND_GET_TOOLNAME    = 0x1004,
+          VG_USERREQ__VALGRIND_RUNNING_VERSION = 0x1005,

            /* These allow any function to be called from the simulated
               CPU but run on the real CPU.  Nb: the first arg passed to
@@ -7299,6 +7300,15 @@ typedef
                                      (zzbuflen),                        \
                                      0, 0, 0)

+/* Returns the Valgrind version that this code is running under.
+   Returns 0 if not running on Valgrind. The version number is expressed
+   as a decimal number: Mmm where M is the major and mm the minor
+   version of Valgrind e.g. 328 for version 3.28. */
+#define VALGRIND_RUNNING_VERSION                                           \
+    (unsigned)VALGRIND_DO_CLIENT_REQUEST_EXPR(0 /* if not */,              \
+                                    VG_USERREQ__VALGRIND_RUNNING_VERSION,  \
+                                    0, 0, 0, 0, 0)                         \
+
  #define VALGRIND_INNER_THREADS(_qzz_addr)                               \
     VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__INNER_THREADS,           \
                                     _qzz_addr, 0, 0, 0, 0)
8<---

and it is harmless.
