From: Miklos Vajna <vmiklos@ulx.hu>
Subject: Re: Improving dm-mirror as a final year project
Date: Tue, 15 Feb 2011 13:52:14 +0100
Message-ID: <20110215125214.GR5980@genesis.frugalware.org>
References: <20110125155342.GG26864@genesis.frugalware.org>
	<63C70D40-54EE-40A2-98B9-82E06A956941@redhat.com>
	<20110214173352.GJ5980@genesis.frugalware.org>
	<2D45663B-1CE9-4266-97FF-C2C6A959EA64@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2D45663B-1CE9-4266-97FF-C2C6A959EA64@redhat.com>
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

On Mon, Feb 14, 2011 at 03:31:00PM -0600, Jonathan Brassow <jbrassow@redhat.com> wrote:
> Thanks for the patches.  I've seen the first one before (slightly  
> different) - I'll discuss it with others whether to include in rhel5.   
> There is no read-balancing in rhel6/upstream.

Oh, do I read the code correctly that rhel6/upstream always reads from
the first mirror and switches only in case there is a read failure?

> The second patch addresses which device should be primary.  This can  
> be done when creating the mirror.  I'm not sure how much benefit there  
> is to doing this additional step.  Most people will access dm mirrors  
> through LVM - not through the dm message interface.  If it makes sense  
> upstream - and you can argue for it - though, I would consider it.

Is there such a messaging interface for lvm as well? I choosed this way
as in this case I did not have to alter the metadata.

One useful use case I can imagine is when both data legs of the mirror
are provided by iscsi and the administrator does not realise what is the
faster leg and her bad decision is found out only after there is some
data on the mirror.

My patch allows one to just set the first mirror in that case, without
saving data, recreating the mirror and restoring data. (Unless I missed
some other neat trick on how to do so.)

> Wether changes are going into rhel5 or rhel6, we still like it when  
> they go upstream first.  We generally don't like feature inversion.

Sure - I was not aware at all that the round robin part of the code is
RHEL5-specific.

> If you have any interest in dm-raid, these are some of the things that  
> need to be done:

Thanks for the list - I must admit that some of the points are Chinese
to me; I'm not that familiar with the codebase, just with the basic LVM
commands anc concepts.

> 1) Definition of new MD superblock:  Some of this is started, and I've  
> got a working version, but I'm sure there are pieces missing related  
> to offsets that must be tracked for RAID type conversion, etc.
> 2) Bitmap work:  The bitmap keeps track of which areas of the array  
> are being written.  Right now, I take all the bitmap code "as-is".   
> There are a number of things in this area to be improved.  Firstly, we  
> don't necessarily need all the fields in the bitmap superblock -  
> perhaps this could be streamlined and added to the new MD superblock.   
> Secondly, things are way too slow.  I get a 10x slowdown when using a  
> bitmap with RAID1 through device-mapper.  This could be due to  the  
> region-size chosen, the bitmap being at a stupid offset, or something  
> else.  This problem could be solved by trial-and-error or through  
> profiling and reason... seems like a great small project.
> 3) Conversion code:  New device-mapper targets (very simple small  
> ones) must be written to engage the MD RAID conversion code (like when  
> you change RAID4 to RAID5, for example)
> 4) Failure testing
> 5) LVM code: to handle creation of RAID devices
> 6) dmeventd code: to handle device failures

Before choosing from this list:

I first have to evaluate the current status of dm-raid so that we can
decide with my mentors if the topic of my thesis should be dm-mirror or
dm-raid (ie. if dm-raid is mature enough that I can write a thesis about
it). Where is the newest version of dm-raid.c? I saw the upstream kernel
has a single commit from this January, but I guess the rawhide / rhel
kernel contained this earlier - maybe there is a newer version than
upstream somewhere?

Also, is there any documentation on dm-raid? Google found
http://www.linux-archive.org/device-mapper-development/454656-dm-raid-wrapper-target-md-raid456.html
but maybe there is now a better way to create raid4 than using
gime_raid.pl?

And a last question: is support for raid1 a planned feature? I think
that would be interesting as well. (If dm-raid is going to replace
dm-mirror in the long run.)

Thanks!
