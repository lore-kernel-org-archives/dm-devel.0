From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Regression: Disk corruption with dm-crypt and
	kernels >= 4.0
Date: Fri, 1 May 2015 22:47:29 +0100
Message-ID: <20150501214728.GL19922@agk-dp.fab.redhat.com>
References: <1430455027.7012.32.camel@memnix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430455027.7012.32.camel@memnix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Abelardo Ricart III <aricart@memnix.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Fri, May 01, 2015 at 12:37:07AM -0400, Abelardo Ricart III wrote:
> # first bad commit: [cf2f1abfbd0dba701f7f16ef619e4d2485de3366] dm crypt: don't
> allocate pages for a partial request
 
That's not a particularly good commit to identify.

If you didn't already, can you confirm whether or not the code works at the
patch immediately following?

  7145c241a1bf2841952c3e297c4080b357b3e52d

Alasdair
