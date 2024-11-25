Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10AB2500AC
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 06:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732514594; cv=none; b=lpzjEIcuI4Hs/J+PLOLz0396kO3CW4ydpZuTMAXb6x8emsQprW1A39e5XrObt5TMSh345bkUCCgx6Ewbbpxp5Ny0zKRSV8fYGAmpie/SxDv6uXPRuIo42q4gHFbwl24XX8fbBzS/BDWbvPa98K81594WbKFY+NdXFn8UaNAqXsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732514594; c=relaxed/simple;
	bh=Q5sic6rfDQNlyAkKA5O1aGIahh0QLNKPVwEZ6uPwRkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oc1ySFYgs+DEBqCyIOUmWn3pAsapJphAnl6NiZXh3l73j8paWpmRUF/HbAuL+Vcy3lERKcsWzonsPoKls08JRtYVeYX9YcoarJcLtMaH3FLd1hnVBp2Vzwj2PdtwWITzZ1zrxpS3RW2tDJG+8aHLQPfAy14ntaIk8RQlJWdbV08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sA3dVfmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sA3dVfmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B048C4CECE;
	Mon, 25 Nov 2024 06:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732514593;
	bh=Q5sic6rfDQNlyAkKA5O1aGIahh0QLNKPVwEZ6uPwRkw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sA3dVfmRpqXzdMIzM6eCMopvVp56+BlAPlRF5542hIvCqdCC45uFdAyPge2UF0ayH
	 T8GPALGhrm3cnt+2Uhvi0+ssWqocE3RZP5VHM6cd5pRGs3uYaLtaSi49CTedF4d7z7
	 jLtfzEkbIoUjSdFFoxcxucFGfhqhu3hzDKMpcC8GVOHXtOkazGvUzrZICdKdo2BUG+
	 PGzvlWzrxrgRYpjIh4Ysc998nI+idAp2SHSzmsmFXnc8NYWTJOH7nkTClHmbLoMoGT
	 7g6BO5kcnNzD+1QyJ8ehJD/0jVbzR+n6xQTQjYulUjUvgdGOsHXUrrYGNz9CVLhMA1
	 x8yjHhNn35qxg==
Message-ID: <46dbb946-dc74-40ab-b0af-133c0e1cc582@kernel.org>
Date: Mon, 25 Nov 2024 15:02:58 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-crypt: set max_io_len as chunk_sectors of zoned device
To: Christoph Hellwig <hch@infradead.org>, LongPing Wei <weilongping@oppo.com>
Cc: dm-devel@lists.linux.dev, snitzer@redhat.com, bvanassche@acm.org,
 ebiggers@google.com
References: <20241125032250.1329977-1-weilongping@oppo.com>
 <Z0QEhGYYmH6R5QRE@infradead.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <Z0QEhGYYmH6R5QRE@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/24 2:00 PM, Christoph Hellwig wrote:
> On Mon, Nov 25, 2024 at 11:22:51AM +0800, LongPing Wei wrote:
>> When dm level submit a bio with bi_size > max_sectors_kb of lower device,
>> blk_mq_submit_bio will split it into several ones with limited bi_size.
>> It may be a potential unordered issue as it breaks the ZWL design in dm
>> on 6.6.
> 
> What is ZWL?  And why mention 6.6?  And why do you care about ordering?
> There is no real ordering requirement in the block layer.
> 

ZWL == zone write locking. That is, the mq-deadline request-based write request
ordering control we had before zone write plugging.
This is about ordering of write requests resulting from a split BIO.

-- 
Damien Le Moal
Western Digital Research
