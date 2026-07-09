Received: from sg-3-44.ptr.tlmpb.com (sg-3-44.ptr.tlmpb.com [101.45.255.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3062B30DECB
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 09:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783590683; cv=none; b=hjNB1HYbU5dWk9UzDHIJCHrerMkBHFLlCfRZxpO08p0iITW9aTzXrmTW5tcmQE2jzlfoRMHhphcnNdwOGDyY0N/xu8jmqe5LmHDjzkKoJJBl4zP5WiRU1VGC/UqcxA3ocWsPX1wKDT+P0cq8rrjpS3vnIp9n7pOxcnz9DiUaX4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783590683; c=relaxed/simple;
	bh=rxSgwuGzIsEmyghbrvFjO2zv/MUWNeA+OR1hBhENbho=;
	h=From:In-Reply-To:To:Message-Id:Subject:Mime-Version:Cc:Date:
	 Content-Type:References; b=ddn52tF9WEan4eEx4/qR+6HGcL75bh7cKhDIHz6Vix2ak/9UHp43e7RSZElFPWmsdrAl55qqldIdhSEFvQ/fKZc7mdBb4ktyCjXTj4CFn7yffrocWqHGWDWer7YjMjqkpftWJfKRvgE45iw73cWU4UMemsVU4Uc+Y86UnIQWjco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RxNIZIz7; arc=none smtp.client-ip=101.45.255.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RxNIZIz7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783590594;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=rxSgwuGzIsEmyghbrvFjO2zv/MUWNeA+OR1hBhENbho=;
 b=RxNIZIz7eSOtPa6jIHY4CV4fggcmRCLwpFMTN8m1WM0cVnXypHLbgIe5nW0c406nK+b7oQ
 X3mbgsAYSDg4zDrJ6jRGl/0BGq0rF64LeRYAARiBYaw1ekDTCC1U7yNWa2t4XX8n1l0Gsa
 b5M68uxjr++Zh2juQf5i1V7vxyE1BPPxl5uI5ci13k7Ny+MO+kne5RRQdVQ0XhgHcN3fu4
 xjHRa8YDbYnSQj3o9n8Oi8cS3NIjFlmMwNQZ3khIFuSgrqL9sXINKPOjogq8NPlsqB5au4
 atdFpFXNAfxX6Mrz7Qf+LqpbBhX6AqiNIucMwfFnXSnjseluYq7Yr23YoPRbFw==
From: "yu kuai" <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Thu, 09 Jul 2026 09:49:52 +0000
In-Reply-To: <20260709061207.GC16504@lst.de>
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
Message-Id: <1bf1939e-6a7b-4a8d-a316-96812cd6924e@fygo.io>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Subject: Re: [RFC PATCH v1 05/17] block: add bio_alloc_atomic() for atomic bio users
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a4f6ec1+2d8c04+lists.linux.dev+yukuai@fygo.io>
Cc: "Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Keith Busch" <kbusch@kernel.org>, "Sagi Grimberg" <sagi@grimberg.me>, 
	"Alasdair Kergon" <agk@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, 
	"Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Dongsheng Yang" <dongsheng.yang@linux.dev>, 
	"Zheng Gu" <cengku@gmail.com>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, <linux-block@vger.kernel.org>, 
	<cgroups@vger.kernel.org>, <linux-nvme@lists.infradead.org>, 
	<dm-devel@lists.linux.dev>, 
	"linux-bcache@vger.kernel.org Joseph Qi" <joseph.qi@linux.alibaba.com>
Date: Thu, 9 Jul 2026 17:49:47 +0800
Content-Type: text/plain; charset=UTF-8
References: <20260704195124.1375075-1-yukuai@kernel.org> <20260704195124.1375075-6-yukuai@kernel.org> <20260709061207.GC16504@lst.de>

Hi,

=E5=9C=A8 2026/7/9 14:12, Christoph Hellwig =E5=86=99=E9=81=93:
> On Sun, Jul 05, 2026 at 03:51:12AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> Add bio_alloc_atomic() for callers that need a GFP_ATOMIC bio from the
>> default bio set but cannot safely pass a bdev during allocation. The
>> helper returns an unattached bio, leaving callers to set bi_bdev and
>> attach blkcg state explicitly before submission.
>>
>> Use the helper for virtio-pmem flush child bios and OCFS2 heartbeat I/O.
>> Both allocate bios from atomic paths and must avoid creating missing blk=
gs
>> once blkg creation is protected by q->blkcg_mutex. virtio-pmem clones th=
e
>> parent bio's blkg association; OCFS2 binds heartbeat I/O to the root blk=
g.
> Let's kill off the concept of atomic bio allocations instead.
> Joseph already has an outstanding patch for nd_virtio that needs a little
> bit more work, and ocfs2 should be easy enough as well.

Thanks for the notice and good to hear that. This will make this set much
simpler.

>
--=20
Thanks,
Kuai
