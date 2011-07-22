From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] linux-next: Tree for July 21 (drivers/md/dm-raid)
Date: Fri, 22 Jul 2011 02:14:01 +0100
Message-ID: <20110722011401.GH5632@agk-dp.fab.redhat.com>
References: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au> <20110721145648.2477f8bb.rdunlap@xenotime.net> <20110722081040.48abfff1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110722081040.48abfff1@notabene.brown>
Sender: linux-next-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jonathan Brassow <jbrassow@redhat.com>, linux-raid@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Fri, Jul 22, 2011 at 08:10:40AM +1000, Neil Brown wrote:
> I suspect the right thing to do is add
>    select MD_RAID1
> to the 
>    config DM_RAID
 
Indeed - done.

Alasdair
