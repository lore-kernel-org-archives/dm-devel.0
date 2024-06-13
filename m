Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF1E130E40
	for <dm-devel@lists.linux.dev>; Thu, 13 Jun 2024 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718296224; cv=none; b=Y3QWIvoW5Ergy5n7xf2P9Jhp0pBv6KY4PK+wvs+BWzZq6LKwU+zsDg0PgTDUKDzdVQO2XHvhych61sW3GJp76xY1LJciegwoJ0XBrollRUW7hCfmn85h68AzXMtftWdLVmJx89RTuz0da30eLBydIzarfXNYbr1PQ32tHLeqc0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718296224; c=relaxed/simple;
	bh=ljLIwAKIaCu2K87aK/wh1nbzUGaK0MbJvtQTnuTlktI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pLvWZL4oGYCVsTP+8OJ9ZVU934n4bPyOwGeHS4YQOjMmC3OIYzjKYP6BTdxbA0akOnLAfdNZWwHZeLRjjaHUyrdJdqVxD1sgcIX15Lmx6SHjRrO0z9cAaTullhPzW9NMpUiqKOgqXyYyN4Vw7XEqs2/hlTGPJ6lD5AoiM7f56gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LkQqHrkR; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LkQqHrkR"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2c348a263easo1775248a91.0
        for <dm-devel@lists.linux.dev>; Thu, 13 Jun 2024 09:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718296222; x=1718901022; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ljLIwAKIaCu2K87aK/wh1nbzUGaK0MbJvtQTnuTlktI=;
        b=LkQqHrkRtU8isc4JnToHmZ+4ZNwVA4+VPmLXxr6UNo7MMQ5LCKSJIH6i/ODUuqLS1g
         fDf5DKUke1CXzrz18vXr0pZ8SWaBnQ+AZrZ0n3Uc5lkWKgohpsKbPbIsZ5jhE20no58q
         c+gW0dJ8576cPLh2bACNW+r8mElUAy5tzu9BdnBRWYoH5Iv6z9sTWxwn4sR3GX1qKWjk
         tWcbrkUamfpa7z6az7ttGiopdq080f/L7DQ20Kgm5x41gQLZLgOgx89dIj1lc8LSagKP
         YnKlPgM51ZptXo4FAKvuOBSDLj7y6oBaMBuSH/kV8iae5QsMYR9HXcWPpJQueRuY2WCl
         ymKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718296222; x=1718901022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ljLIwAKIaCu2K87aK/wh1nbzUGaK0MbJvtQTnuTlktI=;
        b=bpcC5qoVqJqMN4wF0xPMO2E03CFLzx9s9SuqgkjLa0+e7ne9+UpG4rRJYqXiR2m+rN
         Zix+4Ef6HJpjuynbXyfYDa5pJ22lShnDgJD3JlMZrAm3Xyl91o5Xkcxe7aoWlhGw3Lsq
         IeKH7tcZd/LAohxV+di/CifvTLUIdKrjT7/vKHmnJzSrl7dUD1obiYpc6Gc0r1O2u6JQ
         oSEDZHJ833uKgkIQjGMrFu5YLeY/jFeRYSgQloh6nlOi5d1cSeHNbIU3EcdPo2jPZ/B+
         2ZWJF783XCYnogxa1g751PDdxF4YN9z+B0bEJ/Ml4CtcCWOFoodvaNpoLbSEahxPePKV
         SxXw==
X-Forwarded-Encrypted: i=1; AJvYcCUNqH+gmrJuGzkJeF/wADAxt6Z4CCgmWE1BzlB/Wc7vzBNE56N1s85KiPdyzORVC2XEiLs/aepTKeQ7+8b9+Q8A8lMSvCwc2GY=
X-Gm-Message-State: AOJu0YxUV8ZTWR8VsA0/+hkvQejVNsNbNFPv35l2DurTtDmdiGyCcvVA
	4Yp+DhZCnBnElakJSYzciUHebLdNxp4g8QfwTqgW7Gw7peuihxa6CekZnqtE
X-Google-Smtp-Source: AGHT+IFec+p7vxH6T9f20tm7W+m1gJvHG0TWdSGyf00ZquKyJJVQRoo/2HjfwLn4STVbqpXz24gxpA==
X-Received: by 2002:a17:90b:108:b0:2c4:c2a9:3171 with SMTP id 98e67ed59e1d1-2c4c2a93b29mr4016667a91.5.1718296222369;
        Thu, 13 Jun 2024 09:30:22 -0700 (PDT)
Received: from dev0.. ([49.43.162.104])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4c45f8690sm1931868a91.33.2024.06.13.09.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 09:30:21 -0700 (PDT)
From: Abhinav Jain <jain.abhinav177@gmail.com>
To: bmarzins@redhat.com
Cc: agk@redhat.com,
	dm-devel@lists.linux.dev,
	jain.abhinav177@gmail.com,
	javier.carrasco.cruz@gmail.com,
	linux-kernel@vger.kernel.org,
	mpatocka@redhat.com,
	skhan@linuxfoundation.org,
	snitzer@kernel.org
Subject: Re: [PATCH] dm: Add support for escaped characters in str_field_delimit()
Date: Thu, 13 Jun 2024 16:30:15 +0000
Message-Id: <20240613163015.38097-1-jain.abhinav177@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <Zmc3vrfFglYISw1P@redhat.com>
References: <Zmc3vrfFglYISw1P@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jun 10, 2024 at 01:11:40PM -0400, Benjamin Marzinski wrote:
> This doesn't do anything to the escape character. Presumably you want to
> pass the field containing a separator down to dm_eary_create(). But you
> don't want to pass the escape character itself.
>
> To work correctly, this code needs to remove all those escape characters
> that come before separators. It probably needs to do something like:
>
> 1. Find a next non-escaped separator and change it to NULL, so you have
> your field string.
>
> 2. Find all the escaped separators in the field string, and shift the
> rest of the string over to overwrite the escape character with the rest
> of the string.
>
> -Ben

Hi Ben,

I realised I should have done better testing after processing your feedback.
I have accordingly modified the code and shared a v2:
https://lore.kernel.org/all/20240613162632.38065-1-jain.abhinav177@gmail.com/

Please help review and provide feedback again. Thanks.
