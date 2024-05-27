Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB53317E8E3
	for <dm-devel@lists.linux.dev>; Mon, 27 May 2024 15:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716823030; cv=none; b=NDPga+col34/saUkjszbJrTAfYuWCbw7Q3D49x6RzLPw1X2qAMDwL6jnjDoBVpdA8pCzQUJ6XJUtcB0rA/O5WPeo/29kU2Ezz4+2Ds+fz+6OOFy2N0rrEKPXCW7/bwnjriTsP1BHm7Xvgz5LA7AC53lGnMnXyyIzo8cdzMY+i0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716823030; c=relaxed/simple;
	bh=5jiH4x1XWMSnP7qoMjrpmykCRTHBhIhKSZ3Gp9R829s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=I1oyCdUP7d9V88NtPoIr3Qf500/eA+pT9EI9Qi0ftcmWQkFdPXJMfZuqXY/fWaS6WXPz+iz91IkcEAFz0SHpStt5hmmD36pkgV4Z1lfcJoZK7TZEf1SZTDgp0/90O6ApFx/XjMxl4JgSFlkuj8s/JfPlo0eSgUhkNcwnYCWUHRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JvzSGuBW; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JvzSGuBW"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1f4948a6a8cso20785ad.1
        for <dm-devel@lists.linux.dev>; Mon, 27 May 2024 08:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716823028; x=1717427828; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NmPSot7ggLnz+XQPHJ/svK2HUqmn9I3vNorDkw0wgw4=;
        b=JvzSGuBWHkTpskV9Qh+n6e3y5AKAavJS4SvOuiWrEht8SqdoAViwrqDA/KRIjtfDXM
         vHGsAx83m/x5CVjAhph5wgKrlrrN2+sbhGS0ycGj6aMtCAqJD9mIu39wbHxF2o7O92Fl
         rHeAxe782IhX+bMQeCVoIZJqJ9D8gJrJiFEFdPWuIIVJE5OyM5+I3R7V9M7xjqk+A297
         ZlatHSrAkPtI4di8knasnweA4prhIXxkByzRYjeKPUoKXO8tpkQ8kN3WaT3eBY+cGy7x
         hKwyiwJSeJxHtw/RdjNm0TBr2pcpxsaW6x5GHXp7iAuB4NDjsCi72DOwR8QzzQ7PPkke
         QpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716823028; x=1717427828;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NmPSot7ggLnz+XQPHJ/svK2HUqmn9I3vNorDkw0wgw4=;
        b=JNnTmEvauDb60ovWIaxZNEgVupKoUiYCNyerKkDHs26N/8whO5nFKqNhlZ2MuPdsRD
         hRQ1acDQfrQHjyugd1e490Sgc6mkXkqVKS4jCOyShN88EY4pQvxPRnOvIQx06vNUCTKJ
         Z2a4H/MPx8rQAyj1AR5fy37ZcX6x1h+z2Kml23oW7v1SeVxmUKRONOdFzHMkPZehTVBw
         GwMU9s/v8KfHbAMCvVrREm7wJ8uh+/xUbDT/zRRutW2o7Ju+K3kbdPt3ZManzE3oivd5
         ad0fkK0QRUEgyVx7Wn1euBl6C8J6RfVb58h7IuyQ6TY9QeRRFzMImqaNomOH4f60YBfz
         WzwA==
X-Forwarded-Encrypted: i=1; AJvYcCXvP+vOylPw9KC/yMwBEgJqnL3KV4KKBUnfmskCdt4x3nbNefG/gOovEfyuI/s19PRNMXUd6FZ+tXMEhzsQmdOwZv4EuvKrlwI=
X-Gm-Message-State: AOJu0Yym51JeJyzEGwCVKSO1MGlqVDscDGslP6mfL1JE39URdkjtxRIa
	BQeMSpd1kVweyQCgJhjEVh0kNkahpAh8y24wClpu52xcZtciRLCJqEqgk5edZlA=
X-Google-Smtp-Source: AGHT+IHE849WWUx6bhlmTYdHVKsY/r/dVwclg2T4wtnnhKmGhqVNqk5z4HVEcOzw4kd0DhXQltjrtQ==
X-Received: by 2002:a17:902:f686:b0:1f3:3d5a:e864 with SMTP id d9443c01a7336-1f4494f3db4mr114828955ad.3.1716823027556;
        Mon, 27 May 2024 08:17:07 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c9a4fadsm62169365ad.224.2024.05.27.08.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 08:17:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, dm-devel@lists.linux.dev, 
 linux-block@vger.kernel.org
In-Reply-To: <20240527123634.1116952-1-hch@lst.de>
References: <20240527123634.1116952-1-hch@lst.de>
Subject: Re: convert newly added dm-zone code to the atomic queue commit
 API v3
Message-Id: <171682302619.252705.15503452020920646398.b4-ty@kernel.dk>
Date: Mon, 27 May 2024 09:17:06 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Mon, 27 May 2024 14:36:17 +0200, Christoph Hellwig wrote:
> the new dm-zone code added by Damien in 6.10-rc directly modifies the
> queue limits instead of using the commit-style API that dm has used
> forever and that the block layer adopted now, and thus can only run
> after all the other changes have been commited.  This is quite a land
> mine and can be easily fixed.
> 
> Mike said he's fine with merging this through the block tree as the
> dm-zone changes came in through that.
> 
> [...]

Applied, thanks!

[1/3] dm: move setting zoned_enabled to dm_table_set_restrictions
      commit: d9780064b163b91c28e4d44ec3115599db65b7fa
[2/3] dm: remove dm_check_zoned
      commit: 5e7a4bbcc33d7df6bcc8565a8938c196285e5423
[3/3] dm: make dm_set_zones_restrictions work on the queue limits
      commit: c8c1f7012b807ca4da0136eacab96961b56f25d5

Best regards,
-- 
Jens Axboe



