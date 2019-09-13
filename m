From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 4/4] libmultipath: fix mpcontext
	initialization
Date: Fri, 13 Sep 2019 12:17:31 -0500
Message-ID: <20190913171730.GV25414@octiron.msp.redhat.com>
References: <1568155161-9343-1-git-send-email-bmarzins@redhat.com>
	<1568155161-9343-5-git-send-email-bmarzins@redhat.com>
	<a7b7b31b82369a51e9490c1a6fd7ce770be3bfbe.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <a7b7b31b82369a51e9490c1a6fd7ce770be3bfbe.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 13, 2019 at 08:28:59AM +0000, Martin Wilck wrote:
> On Tue, 2019-09-10 at 17:39 -0500, Benjamin Marzinski wrote:
> > If a path is discovered before there is a multipath device for it to
> > belong to, the checker will not have its mpcontext initialized, even
> > if
> > that path later belongs to a multipath device. A checker's mpcontext
> > is
> > only set when the checker is selected, and is set to NULL if there is
> > no
> > multipath device associated with the path. This only impacts the emc
> > checker. However, it makes the emc checker unable to determine if a
> > passive path is connected to an inactive snapshot or not.
> > 
> > This can be solved by adding a new checker class function, mp_init().
> > This is called when the checker is first initialized, and whenever
> > the
> > checker is called, if the checker's mpcontext hasn't been
> > initialized.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/checkers.c              | 29
> > ++++++++++++++++++++++++++--
> >  libmultipath/checkers.h              |  1 +
> >  libmultipath/checkers/cciss_tur.c    |  5 +++++
> >  libmultipath/checkers/directio.c     |  5 +++++
> >  libmultipath/checkers/emc_clariion.c |  7 +++++++
> >  libmultipath/checkers/hp_sw.c        |  5 +++++
> >  libmultipath/checkers/rdac.c         |  5 +++++
> >  libmultipath/checkers/readsector0.c  |  5 +++++
> >  libmultipath/checkers/tur.c          |  5 +++++
> >  libmultipath/discovery.c             |  2 ++
> >  10 files changed, 67 insertions(+), 2 deletions(-)
> > 
> 
> I see the problem and agree the solution is correct. But I'd prefer if
> the mp_init() method was optional and, if not defined in the
> libcheckX.so, would simply be set to NULL. So you wouldn't need to
> define empty methods for all checkers except emc. 

Sure.

-Ben

> checker_mp_init() checks for mp_init() being non-NULL anyway.
> 
> Thanks,
> Martin
> 
