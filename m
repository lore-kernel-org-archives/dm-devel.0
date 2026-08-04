Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFAA4570FC
	for <dm-devel@lists.linux.dev>; Tue,  4 Aug 2026 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785856049; cv=none; b=UW21E6Hp91Cjc/lSBKfOEckEtoPRAegGcxs8N+pchhayZDODRqityiLSFvpBG7zd5RgR5JvUZ85GTBQsxRNLwrd+hGo1I5nEYdr3oan6wPB1EsGVH9eNViCeqc3awj2b/Z9taLvfjwfZs+PcnmONrWVhm9JssG5xJKChnIrvCZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785856049; c=relaxed/simple;
	bh=3vCX73HTin8OMhCLrL4mg1udeBnAS0Z1tTY+9wzBoW4=;
	h=To:Subject:Mime-Version:Cc:Date:Content-Type:References:From:
	 Message-Id:In-Reply-To; b=X6nA1zjs2tE/GBiXXVOoL4Exrl0Oxkj5m2Va5MLEfPnJ1KcOu/lepCxj9B0TpFjQpCOuJ7G9X2n7KPoZvJ4lDyiVSAg8ILBrcsPFNZDwNLbr7ccYRqSMjYmZimiZYb64I+koW5LzSKCY2ZVDwh+5wZxpgtwjIh0TRL3nH/T+vbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=hWciGx/n; arc=none smtp.client-ip=209.127.231.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="hWciGx/n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785856033;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=aTkMnMJBZbmBk8aXgbvQ0jabgPpSOlUfMkXtPY+IHFY=;
 b=hWciGx/nfSr6Hw5Z64Z2T3Z5ANa+tTAGOmZIvBkd9YhOh9q5nVKiFYBbmu2+8mwtGf7Rpr
 v6ZKlDEVMbUd6752vqSdIZxr8aGtnx1gp0KOOfPc8CfEMIv3l6xB9LaL1gDEGxnvxtzFd3
 2DiI/V4z0yWJYiCRcKLnrhkdkO0/7v42/ljEU3GGL6rMpqB4ztTeOOz9wQXY0lHQuXTiPD
 2ZKXLeD7kBDLDrn3KoKExk/wd5Y6haSQlj89wFXxRZTGCJEWmyaL/sZcTiMGqgw+jjbNgo
 Su7dhb354fuaJvhWkgCzW4p0RJXstOl7HrscXFC91/s8ZMUNAlouz74tYp59Gw==
Reply-To: yukuai@fygo.io
To: "Christoph Hellwig" <hch@lst.de>, "Jan Kara" <jack@suse.cz>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [RFC PATCH v1 1/3] blk-cgroup: add helpers for bio cgroup state
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Tue, 04 Aug 2026 15:07:11 +0000
Cc: "Yu Kuai" <yukuai@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, 
	"Tejun Heo" <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Jonathan Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Dan Williams" <djbw@kernel.org>, 
	"Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dave Jiang" <dave.jiang@intel.com>, 
	"Alison Schofield" <alison.schofield@intel.com>, 
	"Pankaj Gupta" <pankaj.gupta.linux@gmail.com>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, "Tao Cui" <cui.tao@linux.dev>, 
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	<linux-bcache@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	<linux-raid@vger.kernel.org>, <nvdimm@lists.linux.dev>, 
	<virtualization@lists.linux.dev>, <gfs2@lists.linux.dev>, 
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Date: Tue, 4 Aug 2026 23:07:03 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a720020+e59529+lists.linux.dev+yukuai@fygo.io>
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-2-yukuai@kernel.org> <prx5s4rwbgoeh7wtgyo7vwydh5iwqn6qc2utamowirsplspfmp@e3eteq5xwuyf> <20260804132527.GA8078@lst.de>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <a780016f-8f94-4337-b700-786f5487ca3f@fygo.io>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260804132527.GA8078@lst.de>
X-Original-From: yu kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/8/4 21:25, Christoph Hellwig =E5=86=99=E9=81=93:
> On Tue, Aug 04, 2026 at 12:52:16PM +0200, Jan Kara wrote:
>> Mostly looks good. Just I think bio_blkcg() should gracefully handle the
>> case where bio->bi_blkg is NULL (and return NULL in that case). That way
>> you can also get rid of somewhat odd pattern:
>>
>> 	if (!bio_blkg(bio))
>> 		return ...;
>> 	do something with bio_blkcg(bio)
>>
>> You can then just check bio_blkcg(bio) directly which is much more obvio=
us.
> Yes.  Looking at the whole series I'm also not sure that this makes too
> much sense as a split out patch as the next one touches more than half
> of the callsite anyway.

Yes, this make sense, I'm trying not to cook a huge patch, but patch 2 is g=
row
much bigger than I was expected. Unless I figure out a nicer way to split p=
atch 2,
I'll merge them in the next version.

>
--=20
Thanks,
Kuai
