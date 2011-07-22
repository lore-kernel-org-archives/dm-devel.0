From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH -next] dm: fix dm-flakey printk warning
Date: Fri, 22 Jul 2011 17:25:38 +0100
Message-ID: <20110722162538.GK5632@agk-dp.fab.redhat.com>
References: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au> <20110721161047.8a62d89a.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110721161047.8a62d89a.rdunlap@xenotime.net>
Sender: linux-raid-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com, akpm <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Jul 21, 2011 at 04:10:47PM -0700, Randy Dunlap wrote:
> Fix printk format warning for sector_t, which can be (unsigned)
> long or long long.
 
Folded, thanks.

Alasdair

