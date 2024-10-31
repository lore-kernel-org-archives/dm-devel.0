Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C646E146A66
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 20:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730406810; cv=none; b=uyq9P1sgx3msrzOPN/76mSooek82psIWTzA5UgnoXj4EbzR60gp8Uc5OX8v/3e/H0/yF67dOJRw7yfrRq/EHS7k0D3jC7vDLUjRbOpeNTR+TD89vuMlSPEe0IaZFPe+o7ETBFiKdUS6pwyGPcMtFKijsX1fH+0aQamT40zR6ZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730406810; c=relaxed/simple;
	bh=uokyZXMjb5ZSoVyTUJcE52QzSCoKy7qvTufIFT5eaOk=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=kG7zS/ntuJjGn32Lh2vcoPMGFfqLR1tCrqMzn2ZO2RbGwNMg0bSHQGEASqfNn3GLUe0iSZmplPzFd9iTG3ukMyyRNt1KterOvTmrfiOWcZS8U9oGKTaanHmJTiHw0pefXrc+CmB4Rxvm0uHIz4zn39HF5Pm1G0BjUMNX14z3RDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id BD0721E11C;
	Thu, 31 Oct 2024 16:33:22 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 7BF00A0AD4; Thu, 31 Oct 2024 16:33:17 -0400 (EDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26403.59789.480428.418012@quad.stoffel.home>
Date: Thu, 31 Oct 2024 16:33:17 -0400
From: "John Stoffel" <john@stoffel.org>
To: Christian Theune <ct@flyingcircus.io>
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
    John Stoffel <john@stoffel.org>,
    "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
    dm-devel@lists.linux.dev,
    Dragan =?iso-8859-2?Q?Milivojevi=E6?= <galileo@pkm-inc.com>,
    "yukuai (C)" <yukuai3@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
In-Reply-To: <78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
	<26298.22106.810744.702395@quad.stoffel.home>
	<EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io>
	<CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
	<2F5F9789-1827-4105-934F-516582018540@flyingcircus.io>
	<adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
	<143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io>
	<1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
	<69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io>
	<CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
	<E893A1D9-4042-4515-88AE-C69B078A3E43@flyingcircus.io>
	<A74EC4F5-2FF8-4274-A1EB-28D527F143F1@flyingcircus.io>
	<2d85e9ab-1d0f-70a1-fab2-1e469764ef28@huaweicloud.com>
	<3CF4B28B-52D7-414E-96A1-FDFA5A5EF172@flyingcircus.io>
	<3DB33849-56C5-4C5C-BF56-F54205BEFCF2@flyingcircus.io>
	<1f2c74f4-8ba9-1a9f-0c11-018a25e785e5@huaweicloud.com>
	<22A202B1-A802-406F-8F38-F4F486A92F81@flyingcircus.io>
	<45d44ed5-da7c-6480-9143-f611385b2e92@huaweicloud.com>
	<9C03DED0-3A6A-42F8-B935-6EB500F8BCE2@flyingcircus.io>
	<DD99A1F0-56E7-473D-B917-66885810233E@flyingcircus.io>
	<78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Christian" == Christian Theune <ct@flyingcircus.io> writes:

> Hi,
> the system has been running under stress for a while on 6.11.5 with the debugging. I have two observations so far:

> 1. The bitmap_counts are sometimes low and sometimes very high and intermingled like this:

> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721bf1db20000(29009381448+8) 7
> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721bf9d6fbf80(29009382168+8) 5
> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721beec896f20(29009381928+8) 4294967242
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c108f26f20(29009374480+8) 3
> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721bfb083df40(29009381456+8) 7
> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721bfc92a2fa0(29009381936+8) 5
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c108f26f20(29009374480+8) 2
> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721c074f8df40(29009381464+8) 7
> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721bfa3b2df40(29009381944+8) 5
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c108f26f20(29009374480+8) 1
> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721beec219fc0(29009381472+8) 4294967268
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c108f26f20(29009374480+8) 0
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967247
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967246
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967245
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967244
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967243
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967242
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967241
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 6
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 5
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 4
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 3
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 2
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 1
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 0
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c1aa216f20(29009374504+8) 6
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c1aa216f20(29009374504+8) 5
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c1aa216f20(29009374504+8) 4
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c1aa216f20(29009374504+8) 3
> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c1aa216f20(29009374504+8) 2

> Is the high number an indicator of something weird?

Is this number wrapping around and not being detected?  Maybe a
signed/unsigned issue?  Total wild ass guess on my part...
