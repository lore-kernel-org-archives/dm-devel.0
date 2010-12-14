From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: update workqueue usages
Date: Tue, 14 Dec 2010 11:03:24 -0500
Message-ID: <20101214160324.GB7944@redhat.com>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
	<4D053D49.1010605@redhat.com> <4D079205.3010204@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4D079205.3010204@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Dec 14 2010 at 10:49am -0500,
Tejun Heo <tj@kernel.org> wrote:

> On 12/12/2010 10:23 PM, Milan Broz wrote:
> > On 12/12/2010 08:10 PM, Tejun Heo wrote:
> > 
> >> * I'm pretty sure workqueues in dm-crypt would benefit from using
> >>   multithreaded workqueue but people already seem to be working on it
> >>   so I left it alone.
> > 
> > Yes, FYI it is already here with new queue api:
> > http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-scale-to-multiple-CPUs.patch
> 
> Yeah, that looks much better.
> 
> > (So that one chunk for dm-crypt in patch 3/6 can be dropped.)
> 
> I'll regenerate the series w/o the chunk.  BTW, against which tree
> should it be generated?

I'll be reviewing your workqueue patches today.  I can take care of
rebasing the patches as needed ontop of Alasdair's quilt tree (up to
dm-raid1-support-discard.patch):
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/series

Once I've folded your patches in I will share the url for resulting
quilt tree.

Thanks,
Mike
