Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0D927A131
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752163192; cv=none; b=hqmD1DbxtauOk1P2OGXkqUWjg6KD2tDmlBnaTEhUmHcviTRrrtXSL4fxbmoJb7EIApRuOcID8dXZrd8JZBpuyfUT3vvSuIAprpxgCYjVx90BbB/c0OdO4RIZRorrkXBCu6VwQ7upsue7Tb6eexpnmy7LLA7bCwN3Mg3bMWaCN1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752163192; c=relaxed/simple;
	bh=YRvREnEGJodTCrOLHXy8PdaJa6Il/fCMlrEAABhM9QQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=riDDBqQnk85mW2o6Zmhg/tNLhDq6aaQfuoMelWEd3izGHvcVnQjmuqzlPVwF0fgjh9/uMbLzBYFe1JdRztcJ5QgndxTdhY3xGBMaYCM8fDFCUAn7fU9jk2yyR030kmFB18W1ZyoJc1sOZiyMPG4dIiXsgYKFLuD0FMdtM2mhyGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ISG2N8Xl; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ISG2N8Xl"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bdKFD3H8Wzm0yT2;
	Thu, 10 Jul 2025 15:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752162942; x=1754754943; bh=YRvREnEGJodTCrOLHXy8PdaJ
	a6Il/fCMlrEAABhM9QQ=; b=ISG2N8Xl1Aq5GQgBzOXIOVmfVj8gwoe4U9AQetJu
	nMUI1yIf1FQznOhyl17IBktzSlUioLdx1d9kdmKtjgW/eqYHvQ2lpfDHlPoN0Ee0
	39vrVAw8oTTp8caHIflbt5usfpVKTRIGya2heCbvoQzF0Dz+BKaBPTShvfTF24Gz
	HPzU+0GyZM0Jb17hww0/SHxd2dpqynnAgZtVZTvcYPR/lNd1NFVt76KbJMCjzPKh
	n+7M4zN9rEJidcDmqh3aaKbPEZ4oxjx/ynWDKR/fDdjQ4640+L4IP2HAcLJul26Y
	FzCUNZDlyuOHJ9LhLxXP9p3XFILnGcOA3de3wXOKKR9xgg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ln-ogYi7nizy; Thu, 10 Jul 2025 15:55:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bdKF15mWNzm174y;
	Thu, 10 Jul 2025 15:55:32 +0000 (UTC)
Message-ID: <48bd1925-94b6-4913-9cbc-f348e4dc4ae6@acm.org>
Date: Thu, 10 Jul 2025 08:55:31 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm-verity: remove support for asynchronous hashes
To: Milan Broz <gmazyland@gmail.com>, Eric Biggers <ebiggers@kernel.org>,
 dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Sami Tolvanen <samitolvanen@google.com>
References: <20250709190902.49554-1-ebiggers@kernel.org>
 <1ee8338a-b19a-409a-bbe6-2068893b8abc@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1ee8338a-b19a-409a-bbe6-2068893b8abc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/10/25 1:28 AM, Milan Broz wrote:
> Just one nitpick - could you please increase minor version of dm-
> verity target, so we have information in debug log that it is a
> patched version?
Others are convinced that version numbers have no place in the upstream
kernel and that all version information should be removed from upstream
kernel drivers.

Thanks,

Bart.
