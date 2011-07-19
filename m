From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: device mapper not finding all devices
Date: Tue, 19 Jul 2011 14:51:10 -0400
Message-ID: <4E25D21E.8050901@cfl.rr.com>
References: <CA+cRLpLs7CL4VeSw9YNGdTDOUG8mz=TpUuzyP=sWXpLiKywA+A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+cRLpLs7CL4VeSw9YNGdTDOUG8mz=TpUuzyP=sWXpLiKywA+A@mail.gmail.com>
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
Cc: David Cramblett <david@functionalchaos.net>
List-Id: dm-devel.ids

On 7/17/2011 3:03 PM, David Cramblett wrote:
> Current Software:
> Linux 2.6.18-238.12.1.el5 #1 SMP Tue May 31 13:23:01 EDT 2011 i686
> i686 i386 GNU/Linux
> device-mapper-1.02.55-2.el5

2.6.18 is now 5 years old; it might be time to upgrade.

> I did some research and the only info I could find was regarding dmsetup:
>
> #dmsetup status
> pdc_eehgddjjp1: 0 976768002 linear
> pdc_eehgddjj: 0 976772992 linear
> via_cdeadaheebp1: 0 976768002 linear
> via_cdeadaheeb: 0 1953546240 striped 2 8:0 8:16 1 AA
>
>
> Looks like something is wrong with the vg0-lvol0 entry above, but I
> can't figure out how to fix it.  There is also another HDD on each of

You only seem to have 4 entries for two dmraid disks ( which is not well 
supported so you should not be using it unless you need to dual boot 
with windows ) and a partition on each.  It is also quite strange that 
the pdc array is using a linear mapping.  Could it be a degraded mirror?

> the via and pdc controllers that are seen by the system, but not
> showing up in the "status" list above.  There is also a disk connected
> to PATA port "/dev/hda" that is part of the lvol.

What disks are supposed to be LVM physical volumes?  The output of 
pvdisplay may prove useful.  An lvchange -ay might also be worthwhile.

> The device-mapper device is being created for the lvol:
>
>   /dev/mapper/vg0-lvol0

If it had actually been created, then it should show up in dmsetup 
status.  The system appears to be failing to create it.
