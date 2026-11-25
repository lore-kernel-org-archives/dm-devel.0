Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795604652;
	b=v/SWNLm2ySfCiPzHj0uMHS+xxaBYPcgpl6IVlYW57xRPxv06cLLOWmAQ7pZW0LZFsFoB
	 xGlSOG6F0FRbKnnbJgjckEOWisMSn+80v1uVrq22KfWVEG66RNw9trY998Znh4Gz63cJU
	 jMNSNWLmZqJ7csVJJ9sP0/ESrpW26+M8CBIwFOWETKY5rDFVq4Lz7VLyA/A+WbnvkfW+F
	 jvn44QB+oFNGS6hOm0HxbCQhiBrBzZ45UV3DNsK0Uzm/0T3C4+nYk4gAtRlrwB4UxohIo
	 hPfsZmagL7fC5CIlgTTksP883OzkVAx5WzfvckvxiAbYXsHAtdaa5jlJElwVKnmJzcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795604652;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Ed/dwsYEtwCWH9KjuZt1ohLbpuZvRwKKfK5cvZH8Hs=;
	b=4vM4Fblb/uIMnMf+Zs9+9YONkEUm4CxTt55owOaqa++RURR1sfFZ80sRKojHcT33ugR+
	 Ar5blIaiHyv3brSiME55zcrnMh5ERZT8rXpWxbM3gm44i1B2jScDgzoBzMLtiEh1TfPi5
	 bdb0TcDP3hfnBiKWubROdlgfO7KQTJk9dsxO7pXm0j/218G92q9lb3JKF598mgrgaZstd
	 qAt4fgaDskQmUUGJ1hvMZA0jG8QUTbQfpsc9EbdrNq6Z1Tq1GY6PplL0uI9Gc3fLUFeQY
	 P0+8I0Fjt3K5nuBYrLMhTelxddF9x/yXl6M2qZY7KU8tAPOWmOmOMbG9l3HpoetwIUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=w7TuWmIZ;
	arc=none smtp.remote-ip=111.22.67.151
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC2E606A31E
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 11:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AC2E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=w7TuWmIZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=w7TuWmIZi9CEgr3hX7ejxjWTpnz5EjVSaZSyLxdk1dkcvgyPOAUImfSiCOvRWKzOsBoSjREZEp1az
	 bAIszhVj4oJ6GXTy31b46dX4PUoYwTjATYZC1opVgdXCTohawZ8FYJpzYDYoJkB+CqWcTz3rbsIRM1
	 oPeWtxk/0pqT41u8=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee26b06c0a4f15-8e7c9;
	Wed, 25 Nov 2026 19:04:06 +0800 (CST)
X-RM-TRANSID:2ee26b06c0a4f15-8e7c9
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee96b06c0a3c87-442e4;
	Wed, 25 Nov 2026 19:04:06 +0800 (CST)
X-RM-TRANSID:2ee96b06c0a3c87-442e4
From: tongzhiwei <tongzhiwei@cmss.chinamobile.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: tongzhiwei@cmss.chinamobile.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] block: fix divide by zero in queue_limit_discard_alignment()
Date: Wed, 25 Nov 2026 19:03:51 +0800
Message-ID: <20261125110353.366-1-tongzhiwei@cmss.chinamobile.com>
X-Mailer: git-send-email 2.45.0.windows.1
In-Reply-To: <20261120103040.610-1-tongzhiwei@cmss.chinamobile.com>
References: <20261120103040.610-1-tongzhiwei@cmss.chinamobile.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Christoph,

thanks for the review.  Please withdraw this patch.

I do agree with the design to fix it on setup.

Sorry for the noise, and thanks for the quick review.


