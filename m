Received: from va-2-19.ptr.blmpb.com (va-2-19.ptr.blmpb.com [209.127.231.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284F84AE8BE
	for <dm-devel@lists.linux.dev>; Tue, 15 Sep 2026 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487041; cv=none; b=aTTw0dyx8VuJlnVNJE3+9mKlkGSxoHRX952y5GnjoOfyLgWVwatjmS/qJXPAXhB7nEx+DjH0rzEHAhIe3k3p0ra5pfkpfKMfKBVQ7MZdvjgWTf10fztuaewmstzweJk32KgwhNrTf3b6hN99GelFJubG8ik7vKlWekY8O0rAahQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487041; c=relaxed/simple;
	bh=X0OA0zd3t2u7iXfF0yPqLYpX2BIJuMIZZ+1R/TrabeE=;
	h=Cc:Message-Id:Content-Type:In-Reply-To:To:Subject:From:Date:
	 Mime-Version:References; b=QAAxzeJwjX8SNh7Veg1xXRtyQNUbrvP5tlLhgTYKcD8+gI0ukyhRHEM8kcWoflQwEkjJ9QrzN+qInIZhdoOpT90qAWMIXQJNi58/g54qGCeyeYVHSaTNYfy1qDWT+t3V0Fk+/vHTlnbfEs8zbchbjSZB6lwYUXSj8Ouznv9Kogc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Yxfwj8cU; arc=none smtp.client-ip=209.127.231.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Yxfwj8cU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789487022;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=d0n1MM6xxPsL/QERF+JcaetyUJsQd2U/h4AXxBLwz/w=;
 b=Yxfwj8cUnFaenowRxaFu7ujBz88KmMiwrPqOyEtY6KZc4/KQz4cV/ZtjypgMIhf0dG2Uad
 6g6MGTRY3tKrIxSxXvqAu5qt3BMoccdgG3hBtOlsZsePr6nKRM5o7U1EdtYm6DEbWtVQBI
 WM92Ay6NSYf0X2LK2355OATd/dEsYA0u/CMQBtXoHf4B21rN+d/C7OtAPByvu/uEEG++16
 pp4Rn4USo8LFuLM6R4KRW0n1ICP901jwzGYtcrg68abH3D+RbEZOATqpUFQANlaz7XtIEB
 w0JSFBa6avJtYocfqxxBYQXyT6MyxrO7G73aMh85L3A+71SaK3HzCkh+IVHoSA==
Cc: "Jens Axboe" <axboe@kernel.dk>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Tejun Heo" <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Jonathan Corbet" <corbet@lwn.net>, 
	"Shuah Khan" <skhan@linuxfoundation.org>, 
	"Randy Dunlap" <rdunlap@infradead.org>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Kemeng Shi" <shikemeng@huaweicloud.com>, 
	"Nhat Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, 
	"Barry Song" <baohua@kernel.org>, 
	"Youngjun Park" <youngjun.park@lge.com>, 
	"Nathan Chancellor" <nathan@kernel.org>, 
	"Nick Desaulniers" <ndesaulniers@google.com>, 
	"Bill Wendling" <morbo@google.com>, 
	"Justin Stitt" <justinstitt@google.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, "Tao Cui" <cuitao@kylinos.cn>, 
	<linux-block@vger.kernel.org>, <cgroups@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-bcache@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	<linux-raid@vger.kernel.org>, <gfs2@lists.linux.dev>, 
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<llvm@lists.linux.dev>
Message-Id: <06e3c977-461c-4469-80ec-b9f54aa51eea@fygo.io>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260915064950.GA13417@lst.de>
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26aa967ad+5a30eb+lists.linux.dev+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Christoph Hellwig" <hch@lst.de>, "Yu Kuai" <yukuai@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2 2/3] blk-cgroup: store blkcg in bio instead of blkg
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Tue, 15 Sep 2026 15:43:40 +0000
Content-Transfer-Encoding: quoted-printable
From: "yu kuai" <yukuai@fygo.io>
Date: Tue, 15 Sep 2026 23:43:32 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <cover.1789237876.git.yukuai@fygo.io> <ef547fdb7a6c8e39a25a1b9473c444f24a0f03be.1789237876.git.yukuai@fygo.io> <20260915064950.GA13417@lst.de>

Hi,

=E5=9C=A8 2026/9/15 14:49, Christoph Hellwig =E5=86=99=E9=81=93:
> On Sun, Sep 13, 2026 at 02:54:39PM +0800, Yu Kuai wrote:
>> @@ -6243,10 +6245,17 @@ static void bfq_insert_request(struct blk_mq_hw_=
ctx *hctx, struct request *rq,
>>   	bool idle_timer_disabled =3D false;
>>   	blk_opf_t cmd_flags;
>>   	LIST_HEAD(free);
>>  =20
>>   #ifdef CONFIG_BFQ_GROUP_IOSCHED
>> +	/*
>> +	 * Pin the blkg used to look up bfqg.  If this is the first IO for
>> +	 * the blkcg on this queue, create the bfqg before holding bfqd->lock.
>> +	 */
>> +	if (rq->bio && !bio_flagged(rq->bio, BIO_BLKG_REF))
>> +		bio_blkg(rq->bio);
> Can rq->bio be NULL here?  flush or empty passthrough request should
> never enter the scheuler.
Yes, rq->bio should never be NULL.
>
>>   	if (!cgroup_subsys_on_dfl(io_cgrp_subsys) && rq->bio)
>>   		bfqg_stats_update_legacy_io(q, rq);
> But I guess given that the code below checks it, we should at least
> be consistent, so I guess it is better to keep it for now.
>
>>  =20
>>   static inline void dm_bio_record(struct dm_bio_details *bd, struct bio=
 *bio)
>>   {
>>   	bd->bi_bdev =3D bio->bi_bdev;
>> -	bd->bi_flags =3D bio->bi_flags;
>> +	/* Restoring an ownership bit cannot recreate the associated reference=
. */
>> +	bd->bi_flags =3D bio->bi_flags & ~(1U << BIO_BLKG_REF);
> I have a bit of a hard time parsing this, the line also is overly
> long.

This is an issue found by AI, if the new flag is recorded to bi_flags, and =
the flag can be
restored to new bio by dm_bio_restore() without actually acquire a blkg ref=
erence. And I
checked this is the only place to read/write bi_flags directly in driver.

--=20
Thanks,
Kuai
