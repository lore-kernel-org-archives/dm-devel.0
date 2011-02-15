From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Improving dm-mirror as a final year project
Date: Tue, 15 Feb 2011 16:13:15 -0600
Message-ID: <1DF24E8A-B258-4F95-BE8D-15C8EB311748@redhat.com>
References: <20110125155342.GG26864@genesis.frugalware.org>
	<63C70D40-54EE-40A2-98B9-82E06A956941@redhat.com>
	<20110214173352.GJ5980@genesis.frugalware.org>
	<2D45663B-1CE9-4266-97FF-C2C6A959EA64@redhat.com>
	<20110215125214.GR5980@genesis.frugalware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/mixed; boundary=Apple-Mail-15--474267598
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110215125214.GR5980@genesis.frugalware.org>
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


--Apple-Mail-15--474267598
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit


On Feb 15, 2011, at 6:52 AM, Miklos Vajna wrote:

> On Mon, Feb 14, 2011 at 03:31:00PM -0600, Jonathan Brassow <jbrassow@redhat.com 
> > wrote:
>> Thanks for the patches.  I've seen the first one before (slightly
>> different) - I'll discuss it with others whether to include in rhel5.
>> There is no read-balancing in rhel6/upstream.
>
> Oh, do I read the code correctly that rhel6/upstream always reads from
> the first mirror and switches only in case there is a read failure?

yes

>
>> The second patch addresses which device should be primary.  This can
>> be done when creating the mirror.  I'm not sure how much benefit  
>> there
>> is to doing this additional step.  Most people will access dm mirrors
>> through LVM - not through the dm message interface.  If it makes  
>> sense
>> upstream - and you can argue for it - though, I would consider it.
>
> Is there such a messaging interface for lvm as well? I choosed this  
> way
> as in this case I did not have to alter the metadata.

There is no msg interface via LVM (although LVM could use the message  
interface for some things.)

> One useful use case I can imagine is when both data legs of the mirror
> are provided by iscsi and the administrator does not realise what is  
> the
> faster leg and her bad decision is found out only after there is some
> data on the mirror.

Perhaps, but if you don't encode this in the LVM metadata, you will  
have to perform the action every time you reboot.  Instead, you could  
reorder the devices in userspace and reload the table.

> My patch allows one to just set the first mirror in that case, without
> saving data, recreating the mirror and restoring data. (Unless I  
> missed
> some other neat trick on how to do so.)
>
>> Wether changes are going into rhel5 or rhel6, we still like it when
>> they go upstream first.  We generally don't like feature inversion.
>
> Sure - I was not aware at all that the round robin part of the code is
> RHEL5-specific.
>
>> If you have any interest in dm-raid, these are some of the things  
>> that
>> need to be done:
>
> Thanks for the list - I must admit that some of the points are Chinese
> to me; I'm not that familiar with the codebase, just with the basic  
> LVM
> commands anc concepts.
>
>> 1) Definition of new MD superblock:  Some of this is started, and  
>> I've
>> got a working version, but I'm sure there are pieces missing related
>> to offsets that must be tracked for RAID type conversion, etc.
>> 2) Bitmap work:  The bitmap keeps track of which areas of the array
>> are being written.  Right now, I take all the bitmap code "as-is".
>> There are a number of things in this area to be improved.  Firstly,  
>> we
>> don't necessarily need all the fields in the bitmap superblock -
>> perhaps this could be streamlined and added to the new MD superblock.
>> Secondly, things are way too slow.  I get a 10x slowdown when using a
>> bitmap with RAID1 through device-mapper.  This could be due to  the
>> region-size chosen, the bitmap being at a stupid offset, or something
>> else.  This problem could be solved by trial-and-error or through
>> profiling and reason... seems like a great small project.
>> 3) Conversion code:  New device-mapper targets (very simple small
>> ones) must be written to engage the MD RAID conversion code (like  
>> when
>> you change RAID4 to RAID5, for example)
>> 4) Failure testing
>> 5) LVM code: to handle creation of RAID devices
>> 6) dmeventd code: to handle device failures
>
> Before choosing from this list:
>
> I first have to evaluate the current status of dm-raid so that we can
> decide with my mentors if the topic of my thesis should be dm-mirror  
> or
> dm-raid (ie. if dm-raid is mature enough that I can write a thesis  
> about
> it). Where is the newest version of dm-raid.c? I saw the upstream  
> kernel
> has a single commit from this January, but I guess the rawhide / rhel
> kernel contained this earlier - maybe there is a newer version than
> upstream somewhere?

The basic component that covers RAID456 is available upstream, as you  
saw.  I have an additional set of ~12 (reasonably small) patches that  
add RAID1 and superblock/bitmap support.  These patches are not yet  
upstream nor are they in any RHEL product.

> Also, is there any documentation on dm-raid? Google found
> http://www.linux-archive.org/device-mapper-development/454656-dm-raid-wrapper-target-md-raid456.html
> but maybe there is now a better way to create raid4 than using
> gime_raid.pl?

Yes, I have a script called 'gime_raid.pl' that creates the device- 
mapper tables for dm-raid.  Eventually, this will be pushed into LVM,  
but it was much easier (for testing purposes) to start with a perl  
script.

> And a last question: is support for raid1 a planned feature? I think
> that would be interesting as well. (If dm-raid is going to replace
> dm-mirror in the long run.)

Yes, RAID1 is planned; and works to a large extent.

  brassow

For convenience, I've attached the patches I'm working on (quilt  
directory) and the latest gime_raid.pl script.


--Apple-Mail-15--474267598
Content-Disposition: attachment;
	filename=dm-raid-patches.tgz
Content-Type: application/octet-stream; x-unix-mode=0644;
	name="dm-raid-patches.tgz"
Content-Transfer-Encoding: base64

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

--Apple-Mail-15--474267598
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit






--Apple-Mail-15--474267598
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Apple-Mail-15--474267598--
