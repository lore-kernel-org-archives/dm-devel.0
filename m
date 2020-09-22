From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 19/19] mpathpersist: remove logsink and udev
Date: Tue, 22 Sep 2020 13:32:51 +0200
Message-ID: <bf7d1347bd6f3f2f5549a965725001c1785227cb.camel@suse.com>
References: <20200916153718.582-1-mwilck@suse.com>
	<20200916153718.582-20-mwilck@suse.com>
	<20200921201544.GZ11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200921201544.GZ11108@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 2020-09-21 at 15:15 -0500, Benjamin Marzinski wrote:
> On Wed, Sep 16, 2020 at 05:37:18PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > We can use libmultipath's internal symbols now.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  mpathpersist/main.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> > index 0f0db4b..729857f 100644
> > --- a/mpathpersist/main.c
> > +++ b/mpathpersist/main.c
> 
> I'm pretty sure that without this patch, mpathpersist is not directly
> calling functions from libmultipath

Yes, this is so.

> , and if so, it should stay that way.
> 
> I don't see any problem with adding the libmultipath_init() and
> libmultipath_exit() calls to libmpathpersist_init() and
> libmpathpersist_exit().

Will do.

Martin
