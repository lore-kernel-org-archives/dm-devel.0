From: Alan Hourihane <alanh@fairlite.demon.co.uk>
Subject: Re: RAID5 support ?
Date: Thu, 03 Nov 2005 11:39:43 +0000
Message-ID: <1131017984.6239.36.camel@jetpack.demon.co.uk>
References: <1129981242.7217.6.camel@jetpack.demon.co.uk>
	<17242.17266.315175.852854@cse.unsw.edu.au>
	<1129996688.7217.9.camel@jetpack.demon.co.uk>
	<17244.8868.117125.78408@cse.unsw.edu.au>
	<1130157973.6046.11.camel@jetpack.demon.co.uk>
	<17257.33116.12284.159992@cse.unsw.edu.au>
	<1131008651.6239.10.camel@jetpack.demon.co.uk>
	<17257.57720.25495.299797@cse.unsw.edu.au>
	<1131013854.6239.16.camel@jetpack.demon.co.uk>
	<17257.62063.205766.403519@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <17257.62063.205766.403519@cse.unsw.edu.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2005-11-03 at 22:20 +1100, Neil Brown wrote:
> On Thursday November 3, alanh@fairlite.demon.co.uk wrote:
> > 
> > I mean "Load the kernel image from an md device" which is what it means
> > to me too.
> > 
> > So, you go on to say that booting from raid5 almost certainly requires
> > bios support - so I'm back to needing the onboard Sil 3114 BIOS to
> > handle that and then get md/dmraid to sort the rest out - which gets
> > back to my original question on when device mapper would get RAID5
> > support so that dmraid can handle the SIL RAID5 metadata.
> 
> "device mapper" and "dmraid" are of course different things.  
> One is a kernel subsystem, the other is a configuration tool.
> For dmraid to be able to handle SIL RAID5, it is not necessary for
> "device mapper" to get RAID5 support, only for dmraid to have
> appropriate access to some sort of raid5 support in the Linux kernel.
> 
> I would like md/raid5 (which is quite separate from device mapper) to
> be able to provide the required level of support so that if the dmraid
> developers so chose, they could use it rather than needing a second
> raid5 implementation in the kernel.  Hence my original question, asking
>  "how md/raid5 can be made to be sufficient" for the needs for dmraid?

So what exactly is Heinz working on if it isn't support for RAID5 in
device-mapper ?

> I suspect all it needs is to be able to interface with a user-space
> metadata handler, and possibly some extra configuration options to
> match the expected functionality of the SiL.
> The former I hope be possible by 2.6.16.  The later I'm interested in
> advice on.

I'll defer to Heinz to make that choice - he's a lot closer to the code.

Alan.
