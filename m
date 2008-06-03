From: Yan Li <elliot.li.tech@gmail.com>
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Wed, 4 Jun 2008 07:13:39 +0800
Message-ID: <20080603231339.GA5995@yantp.cn.ibm.com>
References: <20080602030738.GA7761@yantp.cn.ibm.com> <48439890.6030904@redhat.com> <20080602123145.GA8258@yantp.cn.ibm.com> <2f83bcba0806031246m30f92892wc868d81a9c29d680@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756228AbYFCXOS@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2f83bcba0806031246m30f92892wc868d81a9c29d680@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ritesh Raj Sarraf <rrs@researchut.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, Milan Broz <mbroz@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>, rjmaomao@gmail.com, Alasdair G Kergon <agk@redhat.com>, dm-crypt@saout.de
List-Id: dm-devel.ids

On Wed, Jun 04, 2008 at 01:16:30AM +0530, Ritesh Raj Sarraf wrote:
> Following is the bugzilla that was opened against this problem.
> http://bugzilla.kernel.org/show_bug.cgi?id=10378
> 
> Since I wasn't able to reproduce it on a server machine again, it was later
> closed.
> 
> If you think it is the same issue, please feel free to re-open it.

I think they are not the same. My problem lied in the slow crypto
computation under heavy I/O. I'm testing Milan Broz's patch, till now
it seems has solved my problem.

-- 
Li, Yan
