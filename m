From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Support HDIO_GETGEO on device-mapper volumes
Date: Fri, 10 Feb 2006 16:21:53 -0500
Message-ID: <43ED03F1.4010308@cfl.rr.com>
References: <43EBEDD0.60608@us.ibm.com>
	<20060210145348.GA12173@agk.surrey.redhat.com>
	<43ECAD5B.9070308@cfl.rr.com>
	<62b0912f0602101227q719e712bq40da5b2f0c5422c5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <62b0912f0602101227q719e712bq40da5b2f0c5422c5@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Molle Bestefich wrote:
> It would be better to make the decision once and for all, in one place.
>
> It would be even better for the HDIO_GETGEO call to return the same
> geometry that the BIOS uses, so that Grub is handed numbers that
> actually mean *something*.
>   

The problem is that the numbers don't actually mean anything, even to 
the bios.  They are only there for backward compatibility with real mode 
software that makes int 13 calls.  The bios just fakes the geometry 
anyway so it can emulate something, but there really is no meaning to 
the geometry; it's just smoke and mirrors. 

In the case of dm, which geometry should it report?  In some cases it 
might make sense to pass up the values from the bios, but in most, there 
is no sensible way to choose what to report, and any value you do report 
is meaningless gibberish anyhow, so why bother at all?  Just bring the 
apps still using it ( grub, lilo ) into the 21st century and have them 
stop using these meaningless values in the first place.  LBA has been 
around for a good 10 years now, so I think it is safe to no longer 
require these made up values to support CHS addressing. 
> When 'dmraid' has assembled an array, it should find the matching BIOS
> drive in /proc/bios/int13_dev* and then it should tell device-mapper
> to present that geometry to whomever asks via HDIO_GETGEO.
>   
dmraid is only one client of the kernel device mapper.  It has numerous 
uses that have nothing to do with hardware fakeraid, including LVM.  In 
the special case of dmraid there is a bios int13 dev for the raid that 
provides some geometry, but why hack dm for this special case when it is 
totally unnecessary in the first place?
> And while we're at it, <some component> should do the same for eg.
> /dev/hd?.  It's very annoying trying to fix up a harddrive's partition
> table when the numbers you see in Linux is different to the numbers
> you'll see when rebooting into DOS, or Windows XP, or whatever it is
> that's on the disk you're trying to fix.
> -
>   
