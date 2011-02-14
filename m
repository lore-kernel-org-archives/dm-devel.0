From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Improving dm-mirror as a final year project
Date: Mon, 14 Feb 2011 15:31:00 -0600
Message-ID: <2D45663B-1CE9-4266-97FF-C2C6A959EA64@redhat.com>
References: <20110125155342.GG26864@genesis.frugalware.org>
	<63C70D40-54EE-40A2-98B9-82E06A956941@redhat.com>
	<20110214173352.GJ5980@genesis.frugalware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110214173352.GJ5980@genesis.frugalware.org>
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
List-Id: dm-devel.ids


On Feb 14, 2011, at 11:33 AM, Miklos Vajna wrote:

> On Tue, Feb 01, 2011 at 10:12:36AM -0600, Jonathan Brassow <jbrassow@redhat.com 
> > wrote:
>>> I do not yet have the right to send those patches (I do this in
>>> university time, so the copyright is not mine), but I hope to be
>>> able to
>>> do so - to get them reviewed.
>
> Hi,
>
> I'm attaching the two patches. I tested these on RHEL5, but I don't
> think there are major changes in newer versions, either.
>
> If that's the only problem, I can test it on latest linux-2.6.git.
>
> Any feedback is welcome. :)

Thanks for the patches.  I've seen the first one before (slightly  
different) - I'll discuss it with others whether to include in rhel5.   
There is no read-balancing in rhel6/upstream.

The second patch addresses which device should be primary.  This can  
be done when creating the mirror.  I'm not sure how much benefit there  
is to doing this additional step.  Most people will access dm mirrors  
through LVM - not through the dm message interface.  If it makes sense  
upstream - and you can argue for it - though, I would consider it.

Wether changes are going into rhel5 or rhel6, we still like it when  
they go upstream first.  We generally don't like feature inversion.

If you have any interest in dm-raid, these are some of the things that  
need to be done:
1) Definition of new MD superblock:  Some of this is started, and I've  
got a working version, but I'm sure there are pieces missing related  
to offsets that must be tracked for RAID type conversion, etc.
2) Bitmap work:  The bitmap keeps track of which areas of the array  
are being written.  Right now, I take all the bitmap code "as-is".   
There are a number of things in this area to be improved.  Firstly, we  
don't necessarily need all the fields in the bitmap superblock -  
perhaps this could be streamlined and added to the new MD superblock.   
Secondly, things are way too slow.  I get a 10x slowdown when using a  
bitmap with RAID1 through device-mapper.  This could be due to  the  
region-size chosen, the bitmap being at a stupid offset, or something  
else.  This problem could be solved by trial-and-error or through  
profiling and reason... seems like a great small project.
3) Conversion code:  New device-mapper targets (very simple small  
ones) must be written to engage the MD RAID conversion code (like when  
you change RAID4 to RAID5, for example)
4) Failure testing
5) LVM code: to handle creation of RAID devices
6) dmeventd code: to handle device failures

This is an incomplete list, but does have a variety of complexity and  
duration.

  brassow
