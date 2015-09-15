From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: ioctl: prevent double freeing
Date: Tue, 15 Sep 2015 14:13:33 -0400
Message-ID: <20150915181333.GB18972@redhat.com>
References: <1441365759-7247-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20150915161855.GE10399@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150915161855.GE10399@birch.djwong.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 15 2015 at 12:18pm -0400,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Fri, Sep 04, 2015 at 04:52:39PM +0530, Sudip Mukherjee wrote:
> > DM_PARAMS_KMALLOC and DM_PARAMS_VMALLOC should never be set together in
> > param_flags. We are setting these flags while allocating so we know that
> > there is almost no chance of having these two set together but still we
> > can have some additional safety.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >  drivers/md/dm-ioctl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> > index 80a4395..aaad74e 100644
> > --- a/drivers/md/dm-ioctl.c
> > +++ b/drivers/md/dm-ioctl.c
> > @@ -1680,7 +1680,7 @@ static void free_params(struct dm_ioctl *param, size_t param_size, int param_fla
> >  
> >  	if (param_flags & DM_PARAMS_KMALLOC)
> >  		kfree(param);
> > -	if (param_flags & DM_PARAMS_VMALLOC)
> > +	else if (param_flags & DM_PARAMS_VMALLOC)
> 
> Wouldn't you also want a WARN_ON to complain about both flags being set?

No, this is getting rediculous now.  Please stop the insanity.

DM_PARAMS_KMALLOC and DM_PARAMS_VMALLOC are mutually exclussive --
always will be.  Sprinkling defensive code around isn't high on my list
of changes I'm interested in.

At some point I'll stage the original change from Sudip for 4.4 but I'm
re-writing the subject and header to not be so alarmist (this is more to
do with eliminating a conditional than anything else).  There is _zero_
potential for a double-free with the current code.

Mike
