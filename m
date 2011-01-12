From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] linux-next: Tree for January 12 (dm-crypt)
Date: Wed, 12 Jan 2011 23:12:15 +0000
Message-ID: <20110112231215.GC9501@agk-dp.fab.redhat.com>
References: <20110112141822.c29314c4.sfr@canb.auug.org.au> <20110112100121.ba610465.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110112100121.ba610465.randy.dunlap@oracle.com>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Jan 12, 2011 at 10:01:21AM -0800, Randy Dunlap wrote:
> When CONFIG_LBDAF is not enabled (build on i386):
> (sector_t is 32 bits)
> 
> drivers/md/dm-crypt.c:568: warning:right shift count >= width of type
 
Thanks - being fixed.

Alasdair
