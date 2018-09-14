From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-next: Tree for Sep 13 (dm-thin-pool)
Date: Thu, 13 Sep 2018 21:14:48 -0400
Message-ID: <20180914011448.GA7110@redhat.com>
References: <20180913152753.60866288@canb.auug.org.au>
	<258e14a1-0dbc-74ff-23a5-cd676fdf4579@infradead.org>
	<20180913185147.GA5647@redhat.com>
	<6572c1a5-3db0-af6d-30cc-f9f7c0dc604c@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <6572c1a5-3db0-af6d-30cc-f9f7c0dc604c@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Joe Thornber <dm-devel@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Sep 13 2018 at  8:45pm -0400,
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 9/13/18 11:51 AM, Mike Snitzer wrote:
> > On Thu, Sep 13 2018 at  1:28pm -0400,
> > Randy Dunlap <rdunlap@infradead.org> wrote:
> > 
> >> On 9/12/18 10:27 PM, Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> News: there will be no linux-next releases on Friday or Monday.
> >>>
> >>> Changes since 20180912:
> >>>
> >>
> >> on i386:
> >>
> >> ERROR: "__udivdi3" [drivers/md/dm-thin-pool.ko] undefined!
> > 
> > Well, as I pointed out in reply that nobody will see to the buildbots:
> > 
> > There is something off in this report... I cannot reproduce.  It is
> > almost like the warning was generated when building an older version of
> > this change, but then reported against the latest commit.
> > 
> > I switched to sector_div() specifically because of the undefined
> > __udivdi3 error.
> > 
> > So I'm ignoring this given I cannot reproduce when using 'make ARCH=i386'
> 
> > gcc --version
> gcc (SUSE Linux) 4.8.5
> 
> # CONFIG_LBDAF is not set
> 
> Perhaps you could try to reproduce it with the attached randconfig file.

Ah, yeap.. sector_div() is only viable for use with sector_t.
dm_block_t is typedef'd to uint64_t -- so that explains it.

Need to use div_u64() instead.

Thanks,
Mike
