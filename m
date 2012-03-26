From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Query about dm device max_discard_sectors
Date: Sun, 25 Mar 2012 21:49:11 -0400
Message-ID: <20120326014910.GA31951@redhat.com>
References: <CAL08bwfwD0wtOvum-oeA=skLfQQ_BKSmwJ-ZQbZ+RBwduEJm_A@mail.gmail.com>
	<20120325235421.GA31320@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120325235421.GA31320@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Amar Mudrankit <amar.mudrankit@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Mar 25 2012 at  7:54pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Sun, Mar 25 2012 at  6:46pm -0400,
> Amar Mudrankit <amar.mudrankit@gmail.com> wrote:
> 
> > Hi all,
> > 
> > I am building an experimental device mapper target which is supposed to
> > receive
> > all TRIM requests (REQ_DISCARD).  Irrespective of whether underlying actual
> > physical block device supports discards or not, my device mapper target
> > should
> > receive REQ_DISCARD bios.
> 
> I'm just curious but: what will your target do in general?
>  
> > In my target, I set:
> > 
> > ti->num_discard_requests = 1;
> > ti->discards_supported = 1;
> 
> You'll also want to set ti->discards_supported
> 
> see: http://git.kernel.org/linus/4c259327

ah, I now see you already did set discards_supported.
 
> > So, if my device mapper target does not implement iterate_devices function
> > (used to set max_discard_sectors based on underlying physical device's
> > discard
> > support) or underlying physical device does not support discards, then there
> > is no way for device mapper target to set max_discard_sectors more than 0
> > to receive REQ_DISCARD commands.
> > 
> > Is this analysis correct? Or I am missing something?
> 
> All DM targets should implement .iterate_devices -- intent is to iterate
> over all data devices.
> 
> You'll also want to implement .io_hints to set limits->max_discard_sectors 
> (like drivers/md/dm-thin.c does).

BTW, the dm-thin.c discard changes will be merged in 3.4, you can see
the relevant patches here:

http://people.redhat.com/agk/patches/linux/editing/dm-thin-support-discards.patch
http://people.redhat.com/agk/patches/linux/editing/dm_thin-add-pool-target-flags-to-control-discard.patch
