Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C149255F22
	for <dm-devel@lists.linux.dev>; Fri, 24 Oct 2025 16:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761323514; cv=none; b=bqFQn0jH4EXM1RCiZTNQKqSsqNsxVYMhMVSuCsNcpp4+CxxM1G/cRSWap4hKkDLuCd3Dfi+5eBigVl/uq0mQIpSKzohzICbrvvApNtnRnmpY/we7m7JFLG8RikkNiih4jxibu9Ef+XhUdijx1NWUZ8cjZPpjnda0m1xQcOjmzVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761323514; c=relaxed/simple;
	bh=2sni659oKETAt3mg4JWKS26aiVXJeHNTGhbFaOETvpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsL/67CnWLZ04ik8JbSXV5UeRTmWgVPNHZTa6npkJODUMzNUFZxrmdrhCnKFxprvKPYCFMUnNUAsH10u1/QrafyPYWjooEslwxEPZW659K7+FzTlKixRj5Osl+ASuMlQr7tHSMIFRBWIRxCtPe6Lub9SbpaoqvsTN9v6rnDBN30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HdFczxX5; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HdFczxX5"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so3898966a12.1
        for <dm-devel@lists.linux.dev>; Fri, 24 Oct 2025 09:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761323510; x=1761928310; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OU6+xLScjAoCvkgYL37muGkf8RRryUsuClOGQPNvZ0U=;
        b=HdFczxX5tZoWsHoPJ/RDA6Uv4d94HZmuli9YrhHhymLZlm2MIlruQ8dghPot4o7ajm
         /WsEbjTL8J8HmcRSw5BCzd0f/LQfB4SdhI53t2FMlL9lPa9trP3sZLtPCINY/svF5Oav
         Ex9MXs+ry7yP1NWiq8/estOvbldgYj8Qhb7om67L+toCCkUByqU8nTwGUNbXIrEaoHKy
         JXnhY9yrRf6KKydxe/DiQWsskDjOIj5blRS/7MkF1MqJ/p7ulYRSnAwf6FaODHMRTeC4
         nIaeDQiFGjDps1ZSRabYM7j1+bLsNOzJ/1lVB0MInE5JZQrs3gYGLBr/KuagscQYatCQ
         upng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761323510; x=1761928310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OU6+xLScjAoCvkgYL37muGkf8RRryUsuClOGQPNvZ0U=;
        b=huc8u+ct4pN221lOW6gMe8HK6I/DxAAycYy7JvTwu3JpnBrSyKoN/48e9/nDCenfRQ
         t/FGXCXwA5JvATNIbWMdNhwgk6qZ7iwdN+fLqvUqAis7pPe4S0X8vlI9tvMIPvSMdE9M
         SHoJa48TcCq7i6VpkHSFUdEnRpXc05kMp41h39bJj6gDJboV5ciGDtdEW6itcwonzxRK
         f/P54bfz7Ix4ofzQu78xSNFm8ldqIAeyCVzJrVh/DFX0sOcuOo/1jailREuty8WN9+Nr
         usyX/gkaFa9ni4OhO3TJXwLdjyro/Y9VIGDUJNvu2650QdwAoXlqjQXnroEeptrqVtg9
         rSOg==
X-Forwarded-Encrypted: i=1; AJvYcCXxsQrOcZzP+CuwJJPFBKiPiUw5i+fkFQ1O7CPs7kjdyzdKmdjAAfIVxg7MeeDwHtoiJqUCtjXfsA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyQOkAHJ3llGBeaKox+OIOgxKvkAiaG97bTKYSwAKC5pkw0ZTQg
	1lEf9sjWlsJYR80anXrnDDoTwn59jjoOBCmAUM8F1SXH4pAKWiivnhpx
X-Gm-Gg: ASbGncv6lirNgOHCfQA6qHra7FF/6/22e7Glu1urPuGHnWjPJ6CWdGoq1jncnQ4Z4mw
	t7hl4eWc+axr9xhCc5EREe7YcGXay9gW10auKW2nn891NtrshgD1iMO6GWOV7hWgmoULwBmkqWo
	wdglkbjYEuw+DQihkiWUnU2p+AMTaGVWAMqT2dzUqUN0Z/ic0XbX2rQGAqwxRjDRWSwxq8/vcJT
	FS5uPZ3kKxpNfvCG8gepjqgfX7q02tDCd4prOJIuPQyslmjWFPF4rwAaIEZ8E9yXV5cwq+jqRjJ
	r8umIiNR2Ud7nmb3o5M3nOO7G3SMHqZ+JMAp+FgG6QpKIGCgPy+AVE4gGggZ6qzlWZWTcWczdao
	qhwIzSqcz45Ck0MXvkTAMSLBtJ16tWvK6rIxVlZNdfQZUzLICl//jU3ej712NTfEibtJw9k+T85
	iD
X-Google-Smtp-Source: AGHT+IGJrzUB5n97Ss2T/JTlLzP7kGDtRqESJivToHOWW6+qmykXupmsLuZ+wNfM3MQ1VRw6GaGwKg==
X-Received: by 2002:a05:6402:42ca:b0:63b:fbd9:3d9c with SMTP id 4fb4d7f45d1cf-63e6002459emr2596805a12.15.1761323509904;
        Fri, 24 Oct 2025 09:31:49 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-63e3f316b64sm4717822a12.22.2025.10.24.09.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 09:31:49 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: dm bug: hibernate to swap located on dm-integrity doesn't work (how to get data redundancy for swap?)
Date: Fri, 24 Oct 2025 19:31:42 +0300
Message-ID: <20251024163142.376903-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com>
References: <a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Milan Broz <gmazyland@gmail.com>:
> Hi,

I just wrote script for reproduction of this bug in Qemu:
https://zerobin.net/?4e742925aedbecc6#BX3Tulvp7E3gKhopFKrx/2ZdOelMyYk1qOyitcOr1h8=

Just run it, and you will reproduce this bug, too.

Also, I just reproduced it on current master (43e9ad0c55a3).

Here is output of this script on master:
https://zerobin.net/?68ef6601ab203a11#7zBZ44AaVKmvRq161MJaOXIXY/5Hiv+hRUxWoqyZ7uE=

As you can see, hibernate succeeds, but resume fails so:

+ blkid --match-tag TYPE --output value /dev/mapper/early-swap
+ TYPE=swap
+ echo 'Type: swap'
Type: swap
+ echo /dev/mapper/early-swap
[    0.446545] PM: Image not found (code -22)

Also, I just noticed that the bug sometimes reproduces, and sometimes not.
Still it reproduces more than 50% of time.

Also, you will find backtrace in logs above. Disregard it. I think this
is just some master bug, which is unrelated to our dm-integrity bug.

I will answer to rest of your letter later.

Also, I saw patch, I will test it later.

-- 
Askar Safin
