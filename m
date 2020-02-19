From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 3/5] libmultipath: change loading and
 resetting in directio
Date: Wed, 19 Feb 2020 09:29:33 -0600
Message-ID: <20200219152933.GL30153@octiron.msp.redhat.com>
References: <1582095273-10279-1-git-send-email-bmarzins@redhat.com>
	<1582095273-10279-4-git-send-email-bmarzins@redhat.com>
	<f7fff14fca415c19b2a9309155df4bc6b95c59a9.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f7fff14fca415c19b2a9309155df4bc6b95c59a9.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 19, 2020 at 10:42:50AM +0100, Martin Wilck wrote:
> On Wed, 2020-02-19 at 00:54 -0600, Benjamin Marzinski wrote:
> > The directio checker previously made sure to always keep an aio_group
> > around after loading or resetting the checker. There is no need to do
> > this, and removing this code simplifies the checker.  With this
> > change,
> > there is no longer a need for a load or unload checker function, only
> > a
> > reset function which is run when the checker is reset or unloaded.
> > Changing this broke a number of tests, so the unit tests have been
> > updated as well.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/checkers.c          |  26 ++---
> >  libmultipath/checkers.h          |   2 +-
> >  libmultipath/checkers/directio.c |  43 +-------
> >  tests/directio.c                 | 177 +++++++++++++--------------
> > ----
> >  4 files changed, 81 insertions(+), 167 deletions(-)
> 
> Many thanks for making this change. I feared that the directio tests
> were tied quite closely to implementation details...

I've always been looking at the unit tests as a way to make sure that we
exercise code paths that are hard to hit with functional tests in a more
real-world environment. As such, the idea is to write them specifically
to match the code.

> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
