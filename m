Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2852A1CAA9C;
	Wed, 25 Jun 2025 14:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750862996; cv=none; b=i+JOsJ2WHp2n8CWaSNcblhb6WgOSyo92MG+kRcLVtWOzG1xuhixRrrma8JrTSMD/3giaVkd5Tc4bPQ4mN2cP7k3RaXRfkxf0NChsBnlnjpxY1Dfz2tA+0egeu7RA1It2fL9jag5jU5p8Cb4jwvd3ClNx5Mkck5mSII3WlSBAke0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750862996; c=relaxed/simple;
	bh=tVeUa2x1WcFTLAWGUbXok7aqMiWn665OwHBEnUzwDP8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=BTtpwgF8CO3U/jTIDFyMulGC8r2NL+OJ5fm5qcXJ1//xvC14dIQlRcOmkXWjntkmwgfl6LUmdID2MK6r65AmKh3OcdQzMJdBmp/8W1EmmAvqOoTCcZ48mKGPUrudXckoF0BOjL2ejzerVLBwMbb8EhPWDqokYfU846ky8+WjVuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BI4DIs6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BI4DIs6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E838C4CEEA;
	Wed, 25 Jun 2025 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750862995;
	bh=tVeUa2x1WcFTLAWGUbXok7aqMiWn665OwHBEnUzwDP8=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=BI4DIs6jQ+cpG9bet05KTzFI64SHRO4vemD7IwlBF/2J4IFPs64fMANOqztmIXNk1
	 FFIPzzOjPjrz6TCStnmWmky2C+IPbKPulWb5PMeu0CawFRczooOI6c9EH+cL643goA
	 FqCwys5lDSH3Rv+Q9fi0HHjQRJTKHscYDcLgqfOqAaV1To5ewK5uD5ZLdw8jY1JnN0
	 XdlgFpqYyfGvKdODaF+ahQWSnsIQ9OnZ9Ba1iKi5QFD/yZ4/kUIYAa1UO3qKvWbwFM
	 ZEihaOOsdSkemPSoYk9xbUcd7VBJXFlLw8W/2TFjOQw/2mjbDveP8GvN8j9rB4fMN1
	 I4fF5pqYRxRkA==
Message-ID: <d6078d51-169b-4152-8589-40251411a45f@kernel.org>
Date: Wed, 25 Jun 2025 23:49:53 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [WARN 6.16-rc3] warning in bdev_count_inflight()
From: Damien Le Moal <dlemoal@kernel.org>
To: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 dm-devel@lists.linux.dev, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <aFuypjqCXo9-5_En@dread.disaster.area>
 <aFu6laXAY0_0Wga3@dread.disaster.area>
 <36b2bb05-d26f-484b-acae-fdad7645f1cd@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <36b2bb05-d26f-484b-acae-fdad7645f1cd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/25 23:48, Damien Le Moal wrote:
> On 6/25/25 18:00, Dave Chinner wrote:
>> On Wed, Jun 25, 2025 at 06:26:14PM +1000, Dave Chinner wrote:
>>> Hi Jens,
>>>
>>> I had this warning fire on 6.16-rc3 whilst running fstests. I don't
>>> know what test caused it - I run 64 tests in parallel over a couple
>>> of hundred loop devices, so there's lots of stuff going on all the
>>> time.
>>>
>>> This warning fired when xfs_repair was running on some kind of DM
>>> device:
> 
> You are not alone seeing this one. Shin'ichiro saw it with blktests runs and
> other peoples have mentioned seeing it with various hardware as well. We have no
> reliable reproducer yet, and because it randomly shows up. So it is hard to
> debug. This is since 6.16-rc1 I think.

Ignore... I was not aware of the fix candidate :)

-- 
Damien Le Moal
Western Digital Research
