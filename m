From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Fri, 10 Jun 2011 09:41:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106100937430.32120@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<20110601095106.GA3718@ubuntu>
	<Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
	<Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
	<20110609094746.GA3152@ubuntu>
	<Pine.LNX.4.64.1106091136510.7642@hs20-bc2-1.build.redhat.com>
	<20110610084424.GA3672@ubuntu>
	<20110610092834.GB22211@barkeeper1-xen.linbit>
	<20110610101446.GB10144@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110610101446.GB10144@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Fri, 10 Jun 2011, Joe Thornber wrote:

> On Fri, Jun 10, 2011 at 11:28:34AM +0200, Lars Ellenberg wrote:
> > On Fri, Jun 10, 2011 at 09:44:25AM +0100, Joe Thornber wrote:
> > > On Thu, Jun 09, 2011 at 12:08:08PM -0400, Mikulas Patocka wrote:
> > > > 
> > > > 
> > > > On Thu, 9 Jun 2011, Joe Thornber wrote:
> > > > > What we're trying to do is avoid kcopyd issuing so much io that it
> > > > > interferes with userland io.
> > > > 
> > > > But you don't know if there is some userland IO or not to the same disk.
> > > 
> > > None the less, this was the motivation Alasdair gave for wanting this
> > > throttling.
> > 
> > Not sure if it helps,
> > but are you familiar with the MD raid rebuild throttling?
> 
> Lars,
> 
> This is very helpful, thankyou.  Any thoughts on this Mikulas?
> 
> - Joe

This works if the data is directly on the partition, but it won't work on 
the device mapper (if MD is on the device mapper, it won't work too).

The device mapper has no function to tell where the bio is finally 
remapped, so you can't read disk statistics for that particular disk.

Mikulas
