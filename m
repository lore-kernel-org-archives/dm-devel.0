Received: from mail.tnxip.de (mail.tnxip.de [49.12.77.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D071242909
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 17:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.77.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747070105; cv=none; b=gF5fupvp145/RTORs1XgjqZrWdI0hWzWPZFYZ/t1m70T5mXf5DeJ4b4y0+D++aaTTFwMKbaZtDJWFTFg5kBeTfnCWeXL+mv8B7bUIhOKoA1fv7r0CUoLOjEiyavGq2MSQmoCSeM4gxmN2xa58WaiTRou+v4HWN8p41vQ24y6vA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747070105; c=relaxed/simple;
	bh=4mtvH5m20/j78XW5cNzCCed/ENqttyxm4q2D89rSpSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E3v2LvU0+8SKL4Wly/2W2yAzsu0fXcvGg2agEIc/e9Buca4/0xm2j02h4IwktS4hnXmitlKTGmz/Uq8uew0AXdnjDaGgovq/95a3F4Z7yLyrmwdspmNyHE3vymd2Br+HfDPItNVmquTLxrbAM6JaevKHUzvquk642m0/BjWT27E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de; spf=pass smtp.mailfrom=tnxip.de; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=casOrVmw; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=SklYOZPa; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=1ihNy465; dkim=neutral (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=FmOn4QYg; arc=none smtp.client-ip=49.12.77.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tnxip.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="casOrVmw";
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="SklYOZPa";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="1ihNy465";
	dkim=neutral (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="FmOn4QYg"
Received: from gw.tnxip.de (unknown [IPv6:fdc7:1cc3:ec03:1:ccf8:d536:7d2f:27d5])
	by mail.tnxip.de (Postfix) with ESMTPS id 7DB24208AB;
	Mon, 12 May 2025 19:14:50 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-vps-ed; t=1747070090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pxGewjB4Zx9VFjxm9xIRj3jzl4iXxxOTX+hI1iZGSiY=;
	b=casOrVmws8rYZopuEgHpvlsle4CvYqBhqSC73DdDcyrh6K38gnVdxROo75PytlDjhnLisi
	D9XrAvr5fau4AkDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-vps;
	t=1747070090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pxGewjB4Zx9VFjxm9xIRj3jzl4iXxxOTX+hI1iZGSiY=;
	b=SklYOZPaMGhCJCNeqxl+3vsuKVHBDLKnk+FhHsP8yL9QWGxQFFZcl2UAdG1jPkNcgRgQDr
	0rnMnAHrLF69XDnlGiVIe11F5tyySo+VJiKHX8y/8Jpj4914PRUoWLLpI3TB43mrxZXfYM
	HGdq8bS1YkCLWv8kITNT5eOm6Z8zmx4=
Received: from [IPV6:2a04:4540:8c04:fe00:e093:2c25:7ecc:6d74] (unknown [IPv6:2a04:4540:8c04:fe00:e093:2c25:7ecc:6d74])
	by gw.tnxip.de (Postfix) with ESMTPSA id 43E776000000000001BC6;
	Mon, 12 May 2025 19:14:38 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-gw-ed; t=1747070090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pxGewjB4Zx9VFjxm9xIRj3jzl4iXxxOTX+hI1iZGSiY=;
	b=1ihNy4658lOezLKh0QiSx9N4lGJd2D9SQdaxo1XdAGqo3lubGBRGHyKnjvpwEaL/At4MkP
	ZBBmcn/hH8Y9HAAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-gw;
	t=1747070090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pxGewjB4Zx9VFjxm9xIRj3jzl4iXxxOTX+hI1iZGSiY=;
	b=FmOn4QYgoCuhmewy2d+PNyVzQ7ixsGpZ3jagW4r+GUamrzmzeglwGM12w08Eit7IvBRKYB
	fXmuuer3sa9tPdD+gTWulrv+bslc98dP4DtOf7YuNc5V4JAaA2tqWK7Hz2ecH0az30uLWk
	kWEsia2Gz0LSNpYEPZc/oKdTxZAajiM=
Message-ID: <fc682b1d-d665-4a9b-840e-a2728fbd6791@tnxip.de>
Date: Mon, 12 May 2025 19:14:37 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: LVM RAID1 regression in 6.15-rc5, bisected
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, bmarzins@redhat.com,
 dm-devel@lists.linux.dev
References: <fc8148d9-4b9f-4c13-9924-2f9b0eced194@tnxip.de>
 <c09e5298-4824-4b0c-8fc8-0be33975da17@acm.org>
 <4a159e7a-4d0d-181a-9853-8ec952b68172@redhat.com>
Content-Language: en-US, de-DE
From: =?UTF-8?Q?Malte_Schr=C3=B6der?= <malte.schroeder@tnxip.de>
In-Reply-To: <4a159e7a-4d0d-181a-9853-8ec952b68172@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 12/05/2025 15:21, Mikulas Patocka wrote:
>
> On Wed, 7 May 2025, Bart Van Assche wrote:
>
>> On 5/7/25 3:40 AM, Malte Schröder wrote:
>>> kernel 6.15-rc5 fails to access lvs which use mirroring (lvcreate -m1).
>>> Last working release is -rc4. Reverting
>>> 5a2a6c428190f945c5cbf5791f72dbea83e97f66 fixes the issue.
>> From commit f1aff4bc199cb92c055668caed65505e3b4d2656 in Linus' master
>> branch:
>>
>> Fixes: 5a2a6c428190 ("dm: always update the array size in realloc_argv on
>> success")
>>
>> Bart.
> Hi
>
> Malte. do you see some kernel crashes in the log? The commit 
> 5a2a6c428190f945c5cbf5791f72dbea83e97f66 could cause crashes, however I 
> don't see how could it cause misbehavior (it is reading beyond the end of 
> the allocated memory).
>
> How many device mapper devices are there in total?
>
> Does the commit f1aff4bc199cb92c055668caed65505e3b4d2656 fix it for you?
>
> Mikulas

There are 26 dm-devices. The system is running fine using -rc6, which
should include f1aff4bc199cb92c055668caed65505e3b4d2656. If you are
asking for crashes in -rc5, I do not remember and I do not have those
logs anymore.

/Malte

