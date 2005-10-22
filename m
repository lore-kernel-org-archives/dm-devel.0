From: Alan Hourihane <alanh@fairlite.demon.co.uk>
Subject: Re: RAID5 support ?
Date: Sat, 22 Oct 2005 16:58:08 +0100
Message-ID: <1129996688.7217.9.camel@jetpack.demon.co.uk>
References: <1129981242.7217.6.camel@jetpack.demon.co.uk>
	<17242.17266.315175.852854@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <17242.17266.315175.852854@cse.unsw.edu.au>
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

On Sat, 2005-10-22 at 23:49 +1000, Neil Brown wrote:
> On Saturday October 22, alanh@fairlite.demon.co.uk wrote:
> > I read on September 23rd that NVIDIA spoke about the need to support
> > RAID5 in device-mapper and that RedHat was going to speak to them about
> > supporting it.
> 
> I'm curious to know why md/raid5 is not sufficient...
> 
> More usefully though, I'd be very happy to talk about how md/raid5 can
> be made to be sufficient.  I'd be happy for it to integrate more
> closely with dm, if that was seen to be of value.

That'd be useful Neil.

I'll explain the problem.

I've got a SIL3114 controller with 4 x 200GB drives attached. Now that
SIL controller supports RAID5. Given that I set the RAID support up in
the BIOS I can now boot from the array.

If one of those disks die, I understand that the BIOS will still allow
me to boot from the array, even though the primary disk may have died.

In the md/raid5 setup, I'm not sure that's the case and if you lose the
primary you have to muck about with your bootloader to fix things up.

Your insights into this would be good.

Thanks,

Alan.
