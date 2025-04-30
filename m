Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934E8264FA0
	for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 17:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746034816; cv=none; b=KDiS1huunX7+w01fqF1H8B6gLXdtGoadOYPa+AdIuIofR+6PhPO0ZWU5/wIbf8WGcGmStzi6Qmo4YXlSrwMBKdD2SQWi/I+x8ty4kH4gf0H4szVvnJw2PH6IuRJaTK5LNN55qTvw2yEJzIjxnxq36Njoc7kGWP8nAvRFz2KkQtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746034816; c=relaxed/simple;
	bh=NDzeKYPe2I8Yfoh+f4eSw99RP2htupFat6fSOf0y+Cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bBRewIopfC86vrNKtST6wz2q11IDF2pN8ageebJGnZ/jpfVhO4hKSC7V6jqlAiz1G+h88SUPq8FqQb61IpixwUTOqo2Oe/yzSdnhAWwa5McojVl5PgFuNGfA0tvIZJm9u+YJVWCW2VqlYzjmDqpX16AaMam00JpnBJwbBHImO6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FQb7p1HL; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FQb7p1HL"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-39c1ef4ae3aso99477f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 10:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746034813; x=1746639613; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fTI+NTQY1S5fmWs9NCsPjnEhqIDgFiuLJ0sQ9mVO6og=;
        b=FQb7p1HLtIw2GQMuyGOddZYLpL+F2X+wIymzxjerCNMP9jJk58Jw4KmK0O1Ioxu83G
         x0p/2F+dZ8nNb0mfDT5dDcIUYTct1L+tG3vLg1TFipLkYFEAJPNM+Rj0Ri0+BDqWKcXZ
         yqBiaV2vlOre6eE7QjlZbWZCQ5NUUL3Lhy23XfKAx6EGWl0JNbenJSqJA59Wzy4XJ7Uk
         VqL8NLebmhSjWpDtqM1JsFqwSAN3eft37tPGY9FYhreISZhC6t0WGJTEdU48KA0XKB7s
         +nRU1vWhXdcmwuGjN2NilBqG8cXA/KoMRfzDiKndGHmdY4ZzS9QCTIxaBlE/hyLoGP4N
         tSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746034813; x=1746639613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTI+NTQY1S5fmWs9NCsPjnEhqIDgFiuLJ0sQ9mVO6og=;
        b=jQU483qMRPhW31H0apGvtoWNKgmhch9EjeeBt8U0PkX2WcHk6PitaekV1u8mtYafnx
         6S+VpHaZHdhOiD0UEeI44mBkO3Tm3zXC+JHVeT7rfszBx0mI9FnINcA8ZDtXMaQU82v7
         T6ywVwFY4AAYI2b5TR90dEw7szCFeV2Qia9ofQbC6RQ6rIHyjU3U6Df4XdcHNZBYse1J
         sQEwQfmEJwmS7MsoYKQyOjVkeBPrQ4IFoBllrOpFbZgIEVg2lu/b3XpTQ3MH8AnaV9oj
         Ws2f4RjWcGvWZ9Yv0MlorxtPX3Ouu+p7kkPfEJYVp5O8DdUYZCVgzeQ5vcIfhiCfOU86
         LB2w==
X-Forwarded-Encrypted: i=1; AJvYcCUROZnU5y3XJkDChz/F4ux0ZBnCVL3SuWZ132DL37rcrfzp0zL1T174zwi7mEe2UNySx3qbATfF9w==@lists.linux.dev
X-Gm-Message-State: AOJu0YyEcaAUQI25liNulFrIq/xj2wb21D8z2Crtmi9O20DD/xY1QJKp
	I2IYbEMm5VFoq1gZkiCO4mmNlOM24sAA62SeG0hs69eU8342c3NXf4ht+la5gco=
X-Gm-Gg: ASbGncvtTokDeoWeCh90Dpb9SixTEODSQmnOnqbqsidVREto6QicAqnNz8yfp94VFol
	qrxnzzbdPzKECEaEsILOE1q0S5FOcGRoMbf406WXmn6SgousfK3wQYpYT+qj/PG968FWlFceJ4U
	l2Fijp7qmEtWoYINXm9tsuJB+mv3lp9Pv2cR3HSlcEQa0L4fW1qieZYAGthpfzhcBQzNMAhZJWk
	SeZE4fKJdfRdy4vP8wJa9XtTaCjh0mNTfRAJ0J1FiYDamaNV4K0h9BcRDnOynlJALA2SY4Go4O3
	6NqKE8WZYOGaerr6xDfYYYjmx6vzA2jnt8HmCU3VBe6ZbA==
X-Google-Smtp-Source: AGHT+IF1nO2qpvxe8YcGotQpsDAI9G2//rj00Y8Vv2gR//T8UoGu6ib91X10edaNaTJyuRE9TTivJg==
X-Received: by 2002:adf:ee0a:0:b0:3a0:831a:8fef with SMTP id ffacd0b85a97d-3a092d00c42mr301702f8f.22.1746034812866;
        Wed, 30 Apr 2025 10:40:12 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a073cbf04dsm17858905f8f.52.2025.04.30.10.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 10:40:12 -0700 (PDT)
Date: Wed, 30 Apr 2025 20:40:09 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Satya Tangirala <satyat@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] dm: add missing unlock on in dm_keyslot_evict()
Message-ID: <aBJgeV7pZ7Q47OCb@stanley.mountain>
References: <aBHZ4puON8GNK0vw@stanley.mountain>
 <20250430165037.GA1958@sol.localdomain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430165037.GA1958@sol.localdomain>

On Wed, Apr 30, 2025 at 09:50:37AM -0700, Eric Biggers wrote:
> On Wed, Apr 30, 2025 at 11:05:54AM +0300, Dan Carpenter wrote:
> > We need to call dm_put_live_table() even if dm_get_live_table() returns
> > NULL.
> > 
> > Fixes: 9355a9eb21a5 ("dm: support key eviction from keyslot managers of underlying devices")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > ---
> >  drivers/md/dm-table.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> 
> But that's an awfully error-prone API.

Yep.

> 
> dm_blk_report_zones() gets this wrong too.

Ugh...  dm_blk_report_zones() is too weird for my static checker tool.
The checker is looking very specifically for error paths with missing
unlocks.

regards,
dan carpenter

