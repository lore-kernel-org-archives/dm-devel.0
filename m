Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D9422329;
	Mon, 20 Nov 2023 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MBsV9Juz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94B3C433C7;
	Mon, 20 Nov 2023 17:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1700502049;
	bh=xHJ0vg33qy7F4wRn5bUd3V7ReIDTFYWpIMIL3UbyisA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MBsV9JuzfqOxVH4kWfaFd5mZPjpK4KvDu+2ggKjfyCKjuy4yPW1ieFkKVtHIdbZd3
	 nqpP/flWB2Uxu8jz1VahoI43H0xPyDT1NKT4GbVXwAL8rvQTLjd+KbmcRyYN5muJi5
	 pVLFEUtFOMTrn2eLILPigbf5bP2JOwYxNyf0B0zU=
Date: Mon, 20 Nov 2023 09:40:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Mike Snitzer
 <snitzer@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 dm-devel@lists.linux.dev, linux-block@vger.kernel.org, Alasdair G Kergon
 <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka
 <mpatocka@redhat.com>
Subject: Re: [git pull] device mapper fixes for 6.7-rc2
Message-Id: <20231120094048.1acfb380c90be326b7b3f614@linux-foundation.org>
In-Reply-To: <CAHk-=wgarn2DnvMsZVfm+vDHyUXk7qGMbZHw+mxYvnc8i+SvKw@mail.gmail.com>
References: <ZVjgpLACW4/0NkBB@redhat.com>
	<CAHk-=wjV2S7xBcH2BGuDgfKcg3fjWwk5k74nq89SviMkH-YsJQ@mail.gmail.com>
	<CAHk-=wjCXvFme97sxix_zDfq4-oNRv7fNp+YzWEuUGH-gihA-g@mail.gmail.com>
	<20231119152136.ntnl3sfulo4tgbw3@box.shutemov.name>
	<20231120133145.y7ghl64bqfpeqtwd@box.shutemov.name>
	<CAHk-=wgarn2DnvMsZVfm+vDHyUXk7qGMbZHw+mxYvnc8i+SvKw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 20 Nov 2023 09:36:46 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 20 Nov 2023 at 05:31, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> >
> > NR_ORDERS defines the number of page orders supported by the page
> > allocator, ranging from 0 to MAX_ORDER, MAX_ORDER + 1 in total.
> >
> > NR_ORDERS assists in defining arrays of page orders and allows for more
> > natural iteration over them.
> 
> Well, the thing is, I really think we need to rename or remove
> "MAX_ORDER" entirely.
> 
> Because as-is, that #define now has completely different meaning than
> it used to have for 24 years. Which is not only confusing to people
> who might just remember the old semantics, it's a problem for
> backporting (and for merging stuff, but that is a fairly temporary
> pain and _maybe_ this one-time device mapper thing was the only time
> it will ever happen)
> 

Yes please.  MAX_ORDER was always a poor name - it implies that it's
inclusive.  Renaming it to NR_ORDERS makes it clearer that the usual
and expected "up to but not including" semantics apply.

