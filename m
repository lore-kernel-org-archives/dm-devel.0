From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/4] libmpathpersist: format_transportids():
 avoid PROUT overflow
Date: Sun, 15 Mar 2020 01:14:12 +0100
Message-ID: <dc0b5e29735f0a7f85f1360f9a0feedd35f3e077.camel@suse.com>
References: <20200306230605.3473-1-mwilck@suse.com>
	<20200306230605.3473-3-mwilck@suse.com>
	<20200314231539.GS30153@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200314231539.GS30153@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com, David Bond <dbond@suse.com>
List-Id: dm-devel.ids

On Sat, 2020-03-14 at 18:15 -0500, Benjamin Marzinski wrote:
> On Sat, Mar 07, 2020 at 12:06:03AM +0100, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > This limits the PERSISTENT RESERVE OUT data size to max. 8192
> > bytes.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  libmpathpersist/mpath_pr_ioctl.c | 26 ++++++++++++++++++++++++--
> >  1 file changed, 24 insertions(+), 2 deletions(-)
> > 
> > diff --git a/libmpathpersist/mpath_pr_ioctl.c
> > b/libmpathpersist/mpath_pr_ioctl.c
> > index 1a28cba7..8bf16c0d 100644
> > --- a/libmpathpersist/mpath_pr_ioctl.c
> > +++ b/libmpathpersist/mpath_pr_ioctl.c
> > @@ -1,5 +1,6 @@
> >  #include <stdio.h>
> >  #include <stdlib.h>
> > +#include <stddef.h>
> >  
> >  #include <sys/types.h>
> >  #include <sys/stat.h>
> > @@ -138,38 +139,59 @@ retry :
> >  	return status;
> >  }
> >  
> > +#define check_overflow(ofs, n, start, label)			
> > 	\
> > +	do {								
> > \
> > +		if ((ofs) + 4 + (n) +					
> > \
> 
> I don't get where the 4 comes from here, since buff_offset starts
> at 4. Maybe I'm just missing something.
> 

No. It's wrong, buff_offset includes these 4 bytes inded. Thanks for
spotting it. I'll resubmit the series.

Regards,
Martin
