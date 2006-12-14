From: Adrian Bunk <bunk@stusta.de>
Subject: Re: RFC: dm patches for 2.6.16
Date: Thu, 14 Dec 2006 23:13:27 +0100
Message-ID: <20061214221327.GP3388@stusta.de>
References: <20061124032444.GH28363@stusta.de>
	<20061205202559.GY4409@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061205202559.GY4409@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Jeff Mahoney <jeffm@suse.com>, Alasdair G Kergon <agk@redhat.com>, Michal Miroslaw <mirq-linux@rere.qmqm.pl>, Daniel Kobras <kobras@linux.de>, Neil Brown <neilb@suse.de>, Mark McLoughlin <markmc@redhat.com>
List-Id: dm-devel.ids

On Tue, Dec 05, 2006 at 08:25:59PM +0000, Alasdair G Kergon wrote:
> On Fri, Nov 24, 2006 at 04:24:44AM +0100, Adrian Bunk wrote:
> > The following attached patches seem to make sense for 2.6.16:
> > 
> > Added in 2.6.17.11 and 2.6.18:
> > dm: BUG/OOPS fix
> > 
> > Added in 2.6.17.12 and 2.6.18:
> > dm snapshot: unify chunk_size
> > dm: add module ref counting
> > dm: mirror sector offset fix
> > dm: Fix deadlock under high i/o load in raid1 setup.
> > 
> > Added in 2.6.19:
> > dm snapshot: fix metadata writing when suspending
> > 
> > Do these patches look OK for 2.6.16, 
> 
> Yes.

Thanks, I've applied them.

> > Are there any critical patches I missed?
>  
> The general rule for patches I send to linux-kernel is that any patch with
> 'fix' in the title is a candidate for stable trees (together with any
> earlier patches they depend upon).

I do _sometimes_ find patches for 2.6.16 on linux-kernel.
I'm regularly going through the patches that have been applied to 
-stable.

AFAIK Greg and Chris only apply patches to -stable that were explicitely 
sent to stable@kernel.org.

It would therefore be good, if you could send such patches explicitely 
to stable@kernel.org.

> Alasdair

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
