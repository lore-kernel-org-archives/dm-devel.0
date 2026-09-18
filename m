Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5A03AEF2D
	for <dm-devel@lists.linux.dev>; Fri, 18 Sep 2026 09:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723215; cv=none; b=eIgHWrB3YzXrg7Nl7uhpQRgPf8Ly7/x0JvYbl99OxNRnv5+q9ZkELbqqigAZfitRQM3DtgUnNv/a6e9IKPISlGFXnrZiguzmtVpjsKmLGqZ3iZ/oLotQ9rWJ8tqx4fMx9Rg2QqOGvdynUr7Rl57B/h/DgxQZ6Lpv1ikOkJPGXfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723215; c=relaxed/simple;
	bh=lVI4wS9/F6uS9qnJB4qvn+MECJkuubYFiWZq6Sw6lrU=;
	h=Message-Id:In-Reply-To:Cc:Date:Mime-Version:Subject:Content-Type:
	 To:From:References; b=f9in5WEOBWShp2LmiXLb3s8qwg0r+XO8b0o7/bp2+MYLCbOI6+8fUVKab0cvXjzF9v5O5z6Rm/2PZKaAorwX5s307KUat3PFHhm+aRTuRsur/4A1OuKWFfe/A/bnPyPB9Kc1qnNUBQMXjo4+PT5DV2GtJESIVHU4GP+WDjKuZyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=bwBSdZ1I; arc=none smtp.client-ip=209.127.231.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="bwBSdZ1I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789723203;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=c/HoGHos08YYVCDf+erQy3ROLdbEA8DrOr1npGBRCuw=;
 b=bwBSdZ1IC2vZJtJQ/GMrgZtFKRuuaPwCdBnsVuBZK6OAE/8KLo1qyhHqMMucszqIQ+NkQ2
 HU22scbIi4juP7uDQoN2yJO1G9pAH/o3M11JKl8GQa+S1r5Y8BMJwBwEJhOfbqphjVZxdn
 4yJH4AnELbXL5Ej/uTa6zIxHk/LQAYt4GP5OAuLG1IzbfNdiAQ/oxgQ4h14NALYiEW2F81
 ZWkWZwb9JqbvgqODZjDQttxI64Lhn4YXAABcOdUvpIV5upKvcA6VJysv/TxG7WPbSXtXFa
 VdB7sBO5K3nkoNbXDSVcHsd3NaAQP4MUtRi2ofcw3DZ/hzlSesbtohAXVw9SsA==
Message-Id: <daf4ba77-4c25-4993-900d-ee1fe713d9b6@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <20260918071634.GA10884@lst.de>
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
Date: Fri, 18 Sep 2026 17:19:53 +0800
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Fri, 18 Sep 2026 09:20:01 +0000
Reply-To: yukuai@fygo.io
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Subject: Re: dm review needed, was: Re: [PATCH v3 2/3] blk-cgroup: store blkcg in bio instead of blkg
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26aad0242+26ae42+lists.linux.dev+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
References: <20260918041744.1526924-1-yukuai@kernel.org> <20260918041744.1526924-3-yukuai@kernel.org> <20260918071634.GA10884@lst.de>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/9/18 15:16, Christoph Hellwig =E5=86=99=E9=81=93:
> On Fri, Sep 18, 2026 at 12:17:43PM +0800, Yu Kuai wrote:
>>   static inline void dm_bio_record(struct dm_bio_details *bd, struct bio=
 *bio)
>>   {
>>   	bd->bi_bdev =3D bio->bi_bdev;
>> -	bd->bi_flags =3D bio->bi_flags;
>> +	/*
>> +	 * Restoring BIO_BLKG_REF would not recreate its associated reference.
>> +	 */
>> +	bd->bi_flags =3D bio->bi_flags & ~(1U << BIO_BLKG_REF);
> But do we need to restore the reference?  I have to admit that
> this surrounding code is very confusing and I would really like
> to have the dm maintainers look over it.

dm_bio_record() will store the bi_flags for current bio, later the flag is =
restored
by dm_bio_restore(). For example like dm-raid1 read error path:

issue path, if blk-throttle is enabled, flag can be set before bio issuing =
to dm-raid1

mirror_map
  dm_bio_record
   bd->bi_flags =3D bio->bi_flags
   // contain the new flag

bio_endio
  bio_clear_blkcg
  // new flag is cleared
  clone_endio
   mirror_end_io
   // if this IO failed and there is another mirror to read
    dm_bio_restore
     bio->bi_flags =3D bd->bi_flags
     // new flag is set without get a blkg reference

So I think we don't need to restore the reference, BTW, there is another ap=
proach to
avoid such problem in blk-throttle I don't take for now:

For bio entering blk-throttle, we can clear the new flag and blkg reference=
 directly
after the bio is throttled and before this bio is issuing to disk, because =
bio will
not enter blk-throttle in the completion path. And since blk-throttle is th=
e only rq_qos
policy that can be enabled for bio-based disk, then dm_bio_record() will ne=
ver see a
bio with the new flag set.

--=20
Thanks,
Kuai
