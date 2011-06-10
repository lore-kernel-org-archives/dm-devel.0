From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Fri, 10 Jun 2011 11:28:34 +0200
Message-ID: <20110610092834.GB22211@barkeeper1-xen.linbit>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<20110601095106.GA3718@ubuntu>
	<Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
	<Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
	<20110609094746.GA3152@ubuntu>
	<Pine.LNX.4.64.1106091136510.7642@hs20-bc2-1.build.redhat.com>
	<20110610084424.GA3672@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110610084424.GA3672@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 10, 2011 at 09:44:25AM +0100, Joe Thornber wrote:
> On Thu, Jun 09, 2011 at 12:08:08PM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Thu, 9 Jun 2011, Joe Thornber wrote:
> > > What we're trying to do is avoid kcopyd issuing so much io that it
> > > interferes with userland io.
> > 
> > But you don't know if there is some userland IO or not to the same disk.
> 
> None the less, this was the motivation Alasdair gave for wanting this
> throttling.

Not sure if it helps,
but are you familiar with the MD raid rebuild throttling?

see is_mddev_idle() in drivers/md/md.c

It basically looks at read/write sector part_stats, and tracks its
own resync IO issued to the disk in question (in the special
gendisk member sync_io -- you'd probably need to use your own
counter in some other kcopyd context struct).

Then it figures, if there is "significant" increase in the
partition stats that cannot be accounted for by its own resync IO,
that should be userland IO, which means the device is not idle.

Then it has minimum and maximum bandwidth limits.
It won't use up more than maximum bandwidth,
even if the disk(s) seem to be idle.

If the disk seems to be NOT idle, it still would only throttle,
if its current estimated resync bandwidth is above the minimum
bandwidth limit.

Maybe a similar algorithm could be used for kcopyd?


	Lars
