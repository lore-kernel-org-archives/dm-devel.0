Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F30539849
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YgeXtbHk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700518661; x=1732054661;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IgtBxKHW4oLrKQdICG6wrPvdLby5TOM5jLHTx1Jq5Dk=;
  b=YgeXtbHkelPKSlBvH5vBgCbKDxkiK6jg6SEpNaC4amef6t7Q60wILJGT
   Lf+vF8i+n0Iumvv1kF3LiTQztwfsrgw1fDBG636Lxu4j1CmcuyzuH4LRu
   +832jdNLUDF/Waayz5cqwNTJuTA3y14bH66pKRPhmIUwAG1r8XL4rOfIv
   aLaKITSYPhjhBmQesHWP5ZH2aub1xYZw7d2wnh8SxChWA5ACCtpKG/dlO
   Oy2/7PbseWaQrq2JKrQVUqYJx33HjjeX2WSLz5SPz5Zd/0TaUfCd4daVn
   6AzPd9r9JSYLHgH9A/M6DRGsPCPncogmbIwZD3a4Yj2a0Ac5H7bL8O5d4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="10389088"
X-IronPort-AV: E=Sophos;i="6.04,214,1695711600"; 
   d="scan'208";a="10389088"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 14:17:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="759906249"
X-IronPort-AV: E=Sophos;i="6.04,214,1695711600"; 
   d="scan'208";a="759906249"
Received: from nmalinin-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.57.201])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 14:17:38 -0800
Received: by box.shutemov.name (Postfix, from userid 1000)
	id 5976710A36E; Tue, 21 Nov 2023 01:17:35 +0300 (+03)
Date: Tue, 21 Nov 2023 01:17:35 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [git pull] device mapper fixes for 6.7-rc2
Message-ID: <20231120221735.k6iyr5t5wdlgpxui@box.shutemov.name>
References: <ZVjgpLACW4/0NkBB@redhat.com>
 <CAHk-=wjV2S7xBcH2BGuDgfKcg3fjWwk5k74nq89SviMkH-YsJQ@mail.gmail.com>
 <CAHk-=wjCXvFme97sxix_zDfq4-oNRv7fNp+YzWEuUGH-gihA-g@mail.gmail.com>
 <20231119152136.ntnl3sfulo4tgbw3@box.shutemov.name>
 <20231120133145.y7ghl64bqfpeqtwd@box.shutemov.name>
 <CAHk-=wgarn2DnvMsZVfm+vDHyUXk7qGMbZHw+mxYvnc8i+SvKw@mail.gmail.com>
 <20231120094048.1acfb380c90be326b7b3f614@linux-foundation.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120094048.1acfb380c90be326b7b3f614@linux-foundation.org>

On Mon, Nov 20, 2023 at 09:40:48AM -0800, Andrew Morton wrote:
> On Mon, 20 Nov 2023 09:36:46 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, 20 Nov 2023 at 05:31, Kirill A. Shutemov
> > <kirill.shutemov@linux.intel.com> wrote:
> > >
> > > NR_ORDERS defines the number of page orders supported by the page
> > > allocator, ranging from 0 to MAX_ORDER, MAX_ORDER + 1 in total.
> > >
> > > NR_ORDERS assists in defining arrays of page orders and allows for more
> > > natural iteration over them.
> > 
> > Well, the thing is, I really think we need to rename or remove
> > "MAX_ORDER" entirely.
> > 
> > Because as-is, that #define now has completely different meaning than
> > it used to have for 24 years. Which is not only confusing to people
> > who might just remember the old semantics, it's a problem for
> > backporting (and for merging stuff, but that is a fairly temporary
> > pain and _maybe_ this one-time device mapper thing was the only time
> > it will ever happen)
> > 
> 
> Yes please.  MAX_ORDER was always a poor name - it implies that it's
> inclusive.  Renaming it to NR_ORDERS makes it clearer that the usual
> and expected "up to but not including" semantics apply.

I personally would prefer to have both value for different use cases.
What about MAX_PAGE_ORDER and NR_PAGE_ORDERS?

If it is okay, I will prepare patches.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
