From: Chris Mason <chris.mason@oracle.com>
Subject: Re: direct-io regression [Was: How to track down abysmal
 performance ata - raid1 - crypto - vg/lv - xfs]
Date: Thu, 5 Aug 2010 07:32:40 -0400
Message-ID: <20100805113240.GA29846__9684.60926455936$1281008124$gmane$org@think>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
	<15446.1280953986@localhost>
	<20100805093100.GA3001@comet.dominikbrodowski.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100805093100.GA3001@comet.dominikbrodowski.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dominik Brodowski <linux@dominikbrodowski.net>, Valdis.Kletnieks@vt.edu, josef@redhat.com, Michael Monnerie <michael.monnerie@is.it-management.at>, Christoph
List-Id: dm-devel.ids

On Thu, Aug 05, 2010 at 11:31:00AM +0200, Dominik Brodowski wrote:
> Hey,
> 
> when attempting to track down insufficient I/O performance, I found the
> following reression relating to direct-io on my notebook, where an
> ata device, which consists of several partitions, is combined to a lvm
> volume, and one logical volume is then encrypted using dm-crypt. Test case
> was the following command:
> 
> $ dd if=/dev/mapper/vg0-root_crypt of=/dev/zero iflag=direct bs=8k count=131072
> 
> 2.6.34 results in ~16 MB/s,
> 2.6.35 results in ~ 3.1 MB/s
> 
> The regression was bisected down to the follwoing commit:
> 
> commit c2c6ca417e2db7a519e6e92c82f4a933d940d076
> Author: Josef Bacik <josef@redhat.com>
> Date:   Sun May 23 11:00:55 2010 -0400
> 
>     direct-io: do not merge logically non-contiguous requests
>     
> ...
> 
> How to fix this? I do not use btrfs, but ext3 (and the access was down on
> the block level, not on the fs level, so this btrs-related commit should not
> cause such a regression).

Well, you've already bisected down to an offending if statement, that's
a huge help.  I'll try to reproduce this and fix it up today.

But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
seems a little high.  

-chris
