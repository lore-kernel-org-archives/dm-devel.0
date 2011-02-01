From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Improving dm-mirror as a final year project
Date: Tue, 1 Feb 2011 10:12:36 -0600
Message-ID: <63C70D40-54EE-40A2-98B9-82E06A956941@redhat.com>
References: <20110125155342.GG26864@genesis.frugalware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110125155342.GG26864@genesis.frugalware.org>
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

On Jan 25, 2011, at 9:53 AM, Miklos Vajna wrote:

> Hi,
>
> I got the possibility to work on dm-mirror as a final year project at
> ULX, the Hungarian distributor of Red Hat.
>
> Get my feet wet, I created two small patches:
>
> 1) dm-mirror: allow setting ios count to 0
>
> Always read from the default_mirror in that case.
>
> 2) dm-mirror: allow setting the default mirror
>
> These can help in case one data leg of a mirror is a remote (iSCSI)  
> one,
> so the default RR aproach is not optimal for reading. (One may set the
> ios count to 0, set the default mirror to the local one, and that will
> cause a read speedup.)
>
> I do not yet have the right to send those patches (I do this in
> university time, so the copyright is not mine), but I hope to be  
> able to
> do so - to get them reviewed.
>
> So the final year project's aim is to improve "the fault tolerance and
> performance of dm-mirror". We (I and my mentors) have two ideas in  
> that
> area, not counting the above patches:
>
> 1) Make the currently hardwired RR read approach modular, that would
> allow implementing for example a weighted RR algorithm. (In case one
> disk is two times faster than the other one, etc.)
>
> 2) From our experiments, it seems that in case the dm-mirror looses  
> one
> of its legs and there is a write to the mirror, it gets converted to a
> linear volume. It would be nice (not sure how easy) to use the mirror
> log to mark the dirty blocks, so that the volume would not be  
> converted
> to a linear one: once the other leg is back, it could be updated based
> on the mirror log.
>
> The question: what do you (who have much more experience with dm- 
> mirror
> than me) think - are these reasonable goals? If not, what would you
> improve/change/add/remove to the above list?

Would you consider working on the recently added dm-raid.c?  It is an  
attempt to access the MD personalities through device-mapper.  As  
such, RAID456 (the initial drop) will be available - in addition to  
RAID1.  There is much to be done in this area - large projects as well  
as small - encompassing performance issues, metadata layout, testing,  
etc...  There is also a lot of attention being paid to this area.

I think device-mapper mirroring will be used for a while, but it will  
likely become deprecated.

  brassow
