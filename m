From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: The DM_BUFIO_HASH_BITS is defined as 20, any plan to make it
 flexible?
Date: Wed, 3 Dec 2014 11:17:49 -0500
Message-ID: <20141203161749.GA13117@redhat.com>
References: <547D7BC6.6070708@windriver.com>
 <20141202140015.GB5985@redhat.com>
 <20141203141921.GB6993@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141203141921.GB6993@debian>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, zhangxiao <xiao.zhang@windriver.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 03 2014 at  9:19am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> On Tue, Dec 02, 2014 at 09:00:17AM -0500, Mike Snitzer wrote:
> > On Tue, Dec 02 2014 at  3:43am -0500,
> > zhangxiao <xiao.zhang@windriver.com> wrote:
> > 
> > > Hi Experts,
> > > 
> > > See drivers/md/dm-bufio.c as below:
> > >   50 /*
> > >   51  * Buffer hash
> > >   52  */
> > >   53 #define DM_BUFIO_HASH_BITS      20
> > >   54 #define DM_BUFIO_HASH(block) \
> > >   55         ((((block) >> DM_BUFIO_HASH_BITS) ^ (block)) & \
> > >   56          ((1 << DM_BUFIO_HASH_BITS) - 1))
> > > "drivers/md/dm-bufio.c" 1854L, 45375C
> > > 
> > > DM_BUFIO_HASH_BITS was defined as 20 and it maybe not fit for some
> > > use case with limited resources. Do we have any plan to make it more
> > > flexible? Like module parameter or something else?
> > 
> > No immediate plans.
> 
> That hash table has been replaced with a red/black tree.
> 
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.19&id=4e420c452b11edf9d510c8180ac66f529e5b6206

Ah yes, you'd think I'd have remembered that change.  Thanks for keeping
me honest Joe!
