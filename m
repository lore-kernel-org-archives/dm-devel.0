Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9A613AA48;
	Thu,  6 Jun 2024 08:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717660953; cv=none; b=OLHe+NjOJuGvC9yEWCgyck8hhqVlbn94Rv61BKgjWieT3w8NRIX8hBhOk6Q/PtpwP58ZlEO+WtJYq20+8YMsEauhBRQQhsLNZyZRE7mhWkkDHcln/D3bXwVdJ1J8liYiOueKsSZ7Kaz+Zzzo5VVbYihT7aV81G68ObblgERHCgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717660953; c=relaxed/simple;
	bh=eNup1FTDVZ1cu+bKlFNVCUWQfTOOz4ECmCfmOvatGV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IjmgVoJw+HE7iyM4CHDVuonVwn12jSXZupbeYMmJhYRRx/OCJsx4VLyN+4ztVGD1vS6+7lOu/IIZ4WE2BELyAc/fuvf7Q+pTkiBzmQ+++28qG7OLJOnYpCjXv9IQTXSOLSfmd425+XKeCFsYai4KHR15UjI1st6AV0XkiZVrIoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ToOFy2YM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ToOFy2YM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B281CC32782;
	Thu,  6 Jun 2024 08:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717660952;
	bh=eNup1FTDVZ1cu+bKlFNVCUWQfTOOz4ECmCfmOvatGV0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ToOFy2YMrgel4Vr6SW8iUtzaDWpFP7Y/+H0lb5RHU5T3XvlFu808/UpoBzgoxIKoB
	 W1ZYhSAwptCGz5le5+TGBPKrraRw8+IuqrgybCbhNcxF667mVpHwGNsomuk6siDnWu
	 rWraB8nd/e1OT+mqpbHId9H3GfD6krwg6X9UBL+rNgmExcWzg0iBxDFCsko1nlzSky
	 UWvskkBeO+t+yD/JFJLYEbU8q0ouq5sLoFf4NQ54Dyu2a3UplXHnosv3zehq5XlW6B
	 bK0p0DyL/rkGJNbZGCbna6z8tyWAcNRx7D0hODCTpYCKP9ghI7FWlWCD8NJlcON+1v
	 4Q00AUfbOiMig==
Message-ID: <2ef06cf2-6f7a-4fd2-ab27-7c5520864d12@kernel.org>
Date: Thu, 6 Jun 2024 17:02:30 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] Fix DM zone resource limits stacking
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20240606073721.88621-1-dlemoal@kernel.org>
 <20240606075934.GC14059@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240606075934.GC14059@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 4:59 PM, Christoph Hellwig wrote:
> Vaguely related:  should we add you to MAINTAINERS for
> drivers/md/dm-zone* so that you always are in the loop for changes
> to this code?

Sure, fine with me.

Note that I am working with Shin'ichiro to add test cases to better cover this.
So either way, our weekly runs on rc and -next will catch any issue/regression
sneaking in.

-- 
Damien Le Moal
Western Digital Research

