Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794775348;
	b=e0vAlC0Afg3Y3S20mrfui7awWjBCNAwsRHinuOkVbCP74jIKhU+ovhL1WPXtM68m3k+U
	 hIQm0D8kVPdSJouHISGmTddLCO+9D9jVx2+iOepvPwGGLWucLEx0NH5x4QH+hN77vdcuQ
	 Wbddtwf06xqOipN3yZ/zZp6OCaAwq7RZogah5J4AlZbJLfATKF2qeTcqH7hUcQkZAD31f
	 I3QaMXXO/Svk76Gnrz/dgpwHBNwqJBGst1qLZkzO9bsHPHy1iasIY6pL15B9No2r/KSv1
	 KsVnuObxH+z05wrvLHHUMaKM55oWQWlGG5bPRPXKwO12G5qq4Ua3+cmzxfdZsLxDkBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794775348;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=57qg6lfcglp0N4Mj4NgnwPYExZR+gKFM0e2d2Eu9fTw=;
	b=R7r6LfbmzwofE5M9ojaoXjKXf3cbQe36r1fgkN/VzF2Slpv7GRG3Wgxu2AUd38CPd7dI
	 +Esby36UF4Erbsqtp63RKz4YIEC59iXBHXlx1Nz0KGGYeFv8dVHOxd8gQLdFF3/09igkR
	 KYjkah79s0TX+oBZNDFXOxXamf8fWuazeCKXIoyJoyZCDGY25gnCtnvseRNAQMEIP++k1
	 +KKddCJh/9kjEt4l8AtCPgaVJxtS7YieB/XLoAzVPkodT1VVwzl/pkXnI+yBbMvg4DqNU
	 7yjXHSUcxt/M0irUwoeA1ZhkrHxn+nidEkg9NtTanIWa6CcvOgCObAyivftiKE1/3CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=MtrtZZDp;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459E2606A330
	for <dm-devel@lists.linux.dev>; Sun, 15 Nov 2026 20:42:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 459E2606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=MtrtZZDp
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jSNGP1ZRhz1XMYJW;
	Sun, 15 Nov 2026 20:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794775338; x=1797367339; bh=57qg6lfcglp0N4Mj4NgnwPYE
	xZR+gKFM0e2d2Eu9fTw=; b=MtrtZZDp7qD5J70HXAoNolpn2WpTDUFn9OAxViit
	MNMoaLQwo7v93ZvYmGTUTW9Uh5m7jF2b44pKa8Yh6aEkXrqri1jswKQloo9cLMuY
	7vm8JaIcOqIvARuhsXQ3xaDAHkatT9DZb0aCD/hijDM8A424SAguqOLyLWR9dXdF
	Wo0HvXpTB1bi+mRGNAwkAm0lByzqJBA05dmWhWcVXvF+wTXAbd/vUltAJlItI4IG
	ZH7aeDiWYCb3+ccfzyy/QEKtjJnCYgLoKdGU2KW2gt5IN5/i2QiTkS07sz4vcgqj
	z2P2XAQnmxp9SzpfZfibWtcKogMmcey8hgPuwkGDgIwoaA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8BFVPczuCpW4; Sun, 15 Nov 2026 20:42:18 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jSNGL25W2z1XM311;
	Sun, 15 Nov 2026 20:42:18 +0000 (UTC)
Message-ID: <a3a40995-613f-4bbb-8de4-7d087649bad0@acm.org>
Date: Sun, 15 Nov 2026 12:42:17 -0800
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/29] scsi: core: Clear cmd->flags for terminal
 queuing error
To: John Garry <john.garry@linux.dev>, james.bottomley@hansenpartnership.com,
 mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de,
 michael.christie@oracle.com
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-2-john.garry@linux.dev>
 <060d5e0d-764e-40bd-8bb7-ead8d4ada5b0@acm.org>
 <84b50119-cb4a-4bda-9ab8-7b590216858e@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <84b50119-cb4a-4bda-9ab8-7b590216858e@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/26 10:37 AM, John Garry wrote:
> Hi Martin, I would really rather not post yet another version of this 
> series. How about send the extra change which Bart requested separately?
How will this approach affect bisectability of the SCSI core?

Thanks,

Bart.
