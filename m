Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4420F35968
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 15:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743002246; cv=none; b=X1AaT8WTa0qoc9d3vCE10mOUdzfL3IAHJk2DxQtuNR4gOANsiHyMaN4PmXbD8Y6kI005t14sAksr3DOX2DOke67wQMqd1Q+S8qrxs3E0ElG8tsDh8bgn2247Nnv7UAT7g/U3aLCh9Sqz0t7lU2C9Gt6tAhDOpkVWrEwl0ldcqfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743002246; c=relaxed/simple;
	bh=EOQjoerpRmOGZcdY2NRl4rLOKGe2XK0c+DsXCo148p0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LvzouoflU8+jpxHBqRdjSRcLCMKw8Scc/yggzX4LiS57cCyOu/3LEFPYm4ybNnXOLrkfWjhu8j7buWLzFtOVd4MCHVLpWplKJZYYqcaV/awpoHLUA7A41Nhuf8MSq4cOdGxZpbu7GJNHAW/Za6qcIPticMCuAVdYFjwlaRoO7DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BwaYL0A4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BwaYL0A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F42C4CEE2;
	Wed, 26 Mar 2025 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743002245;
	bh=EOQjoerpRmOGZcdY2NRl4rLOKGe2XK0c+DsXCo148p0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BwaYL0A42ciLsCo+GQTMz7I9RecBRgLI9pTNIKgxAO4EJCjsqyYGS+judnCS8K5P8
	 Y7p/C8T6ofukn8xEVZ92e8z4HzHa8gan1uQ9dlpyRDhToHNQyoolfIYJ4Y21KN2Yk7
	 6VP7z/twDa0C6CC1NMA4EQoxlg6UbXvOuwvIelHO65SUQi5fwW2NWiXV7ooKqN3dGH
	 j2dqKcpUdoBUd40bgH6e3/SV9YsZcKCyjlNaxI5Hx5XpZuo+POU4Q+QmvFO/Gvk8Bd
	 oBCGdgkOO1WOa7IuSMxIdy/uM1wGkQB8sYxW3mo+63nUDk64r2RbrSIT8ezhgCVaNV
	 Id78YmrjjGtMg==
Message-ID: <df52d589-784c-4035-9e55-8ce94ad182dc@kernel.org>
Date: Wed, 26 Mar 2025 11:17:24 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-delay: support zoned devices
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, snitzer@kernel.org, mpatocka@redhat.com,
 dm-devel@lists.linux.dev
References: <20250321071816.1674943-1-hch@lst.de>
 <Z92naQRO2DrpMnXE@redhat.com>
 <1b09a5a4-437b-466a-a238-8d4cb5526942@kernel.org>
 <Z-QWmaGsJlvntvZn@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <Z-QWmaGsJlvntvZn@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/03/26 11:00, Benjamin Marzinski wrote:
> On Wed, Mar 26, 2025 at 08:55:48AM -0400, Damien Le Moal wrote:
>> On 2025/03/21 13:52, Benjamin Marzinski wrote:
>>> On Fri, Mar 21, 2025 at 08:18:16AM +0100, Christoph Hellwig wrote:
>>>> Add support for zoned device by passing through report_zoned to the
>>>> underlying read device.
>>>>
>>>> This is required to make enable xfstests xfs/311 on zoned devices.
>>>
>>> On suspend, delay_presuspend() stops delaying and it doesn't guarantee
>>> that new bios coming in will always be submitted after the delayed bios
>>> it is flushing. That can mess things up for zoned devices. I didn't
>>> check if that matters for the specific test. Setting
>>>
>>> ti->emulate_zone_append = true;
>>>
>>> would enforce write ordering, at the expense of adding a whole other
>>> layer of delays to zoned dm-delay devices. Since this isn't really
>>> useful outside of testing, I think that could be acceptable if necessary
>>> (it would require us to support table reloads of zoned devices with
>>> emulated zone append, since tests often want to change the delay).
>>> However it would probably be better to see if we can just make dm-delay
>>> preserve write ordering during a suspend.
>>
>> delay_presuspend() calls flush_delayed_bios() with flush_all == true. So all
>> BIOs will be flushed in the order they are queued in the delay list, which as
>> far as I can tell is the order in which the user of dm-delay issued the BIOs. So
>> for writes, the order is preserved as far as I can tell.
> 
> delay_presuspend() is called before we set the DMF_BLOCK_IO_FOR_SUSPEND
> bit, which will stop incoming bio from getting mapped, and also before
> lock_fs() is called. This means it's common for new bios to continue to
> come into delay_map(), while delay_presuspend() is running.  The moment
> delay_presuspend() sets dc->may_delay = false, those new bios will stop
> getting queued by delay_bio(). They will get remapped immeditately to
> the underlying device. flush_delayed_bios() doesn't even get called
> until after dc->may_delay is set to false, and if there are a lot of
> bios on the delayed_bios list, flush_delayed_bios() will schedule. So,
> it's actually very common for new incoming bios to get passed to
> underlying device before all the bios on the dc->delayed_bios list do.
> 
> Solving this without grabbing the dc->process_bios_lock mutex for every
> bio sent to dm-delay probably involves keeping the incoming bios going
> to dc->delayed_bios during suspend, at least until we can guarantee that
> it's empty and no bios are being flushed.

OK. Understood. Thank you for the explanation. And the above sounds like a
rather simple solution, which does not even needs to be zone specific.

I also think that this is orthogonal to Christoph patch and we can fix the
suspend issue on top of Christoph's patch. This is a very niche issue anyway for
the main target use case which is fstests, since fstests does not suspend/resume
the dm-delay device as far as I know.

> 
> -Ben
> 
>>
>> -- 
>> Damien Le Moal
>> Western Digital Research
> 


-- 
Damien Le Moal
Western Digital Research
