From: Miklos Vajna <vmiklos@ulx.hu>
Subject: Re: Improving dm-mirror as a final year project
Date: Wed, 9 Feb 2011 18:13:39 +0100
Message-ID: <20110209171339.GV5980@genesis.frugalware.org>
References: <20110125155342.GG26864@genesis.frugalware.org>
	<63C70D40-54EE-40A2-98B9-82E06A956941@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <63C70D40-54EE-40A2-98B9-82E06A956941@redhat.com>
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

Hi Jonathan,

On Tue, Feb 01, 2011 at 10:12:36AM -0600, Jonathan Brassow <jbrassow@redhat.com> wrote:
> Would you consider working on the recently added dm-raid.c?  It is an  
> attempt to access the MD personalities through device-mapper.  As  
> such, RAID456 (the initial drop) will be available - in addition to  
> RAID1.  There is much to be done in this area - large projects as well  
> as small - encompassing performance issues, metadata layout, testing,  
> etc...  There is also a lot of attention being paid to this area.
> 
> I think device-mapper mirroring will be used for a while, but it will  
> likely become deprecated.

Sure, that sounds interesting. The first part of my MSc thesis should be
done till 2011.05.13 (14 weeks), I have about 2 workdays / week for the
project. Of course the actual development time is a bit less, since I
have to produce paper from this (about 30 pages for the first part).

(The second part should be done in Q3-Q4, when I'll have a bit more
dedicated time.)

Do you have a project idea for such a timeframe?

My mentors are asked: is dm-raid supported in a RHEL version?

As far as I see it was added in commit
9d09e663d5502c46f2d9481c04c1087e1c2da698 after 2.6.37, so it's not part
of RHEL (I created my dm-mirror patches on RHEL5) - and it's a pro for
them if I can do my development based on a RHEL kernel, what they use.

So - given such a timeframe, is it better to develop dm-mirror, which is
fairly stable or is it possible to develop dm-raid, even if it's quite
new?

Thanks,

Miklos
