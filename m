From: Alan Hourihane <alanh@fairlite.demon.co.uk>
Subject: Re: RAID5 support ?
Date: Mon, 24 Oct 2005 13:46:13 +0100
Message-ID: <1130157973.6046.11.camel@jetpack.demon.co.uk>
References: <1129981242.7217.6.camel@jetpack.demon.co.uk>
	<17242.17266.315175.852854@cse.unsw.edu.au>
	<1129996688.7217.9.camel@jetpack.demon.co.uk>
	<17244.8868.117125.78408@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <17244.8868.117125.78408@cse.unsw.edu.au>
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

On Mon, 2005-10-24 at 09:54 +1000, Neil Brown wrote:
> On Saturday October 22, alanh@fairlite.demon.co.uk wrote:
> > > More usefully though, I'd be very happy to talk about how md/raid5 can
> > > be made to be sufficient.  I'd be happy for it to integrate more
> > > closely with dm, if that was seen to be of value.
> > 
> > That'd be useful Neil.
> > 
> > I'll explain the problem.
> > 
> > I've got a SIL3114 controller with 4 x 200GB drives attached. Now that
> > SIL controller supports RAID5. Given that I set the RAID support up in
> > the BIOS I can now boot from the array.
> > 
> > If one of those disks die, I understand that the BIOS will still allow
> > me to boot from the array, even though the primary disk may have died.
> > 
> > In the md/raid5 setup, I'm not sure that's the case and if you lose the
> > primary you have to muck about with your bootloader to fix things up.
> 
> It seems the core problem here is that you need soft-raid5 in Linux
> which can work with the metadata that is stored by the BIOS on the SIL
> controller. 
> This shouldn't be too hard to do, providing it is reasonably
> documented.
> 'md' has all the meta-data operations reasonably well factored out, so
> working with new formats shouldn't be difficult.

That to me still doesn't resolve the bootloader problems.

Regardless of the md understanding the meta-data operations, it deals
with partitions and therefore the boot sector of each drive in an md
setup is outside the scope of it's operation.

Unless I'm missing something, this is where device-mapper really is
useful, and presents a single drive to linux.

Alan.
