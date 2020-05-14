From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] device-mapper: use dynamic debug instead
 of compile-time config option
Date: Thu, 14 May 2020 12:26:49 -0400
Message-ID: <20200514162649.GB31400@redhat.com>
References: <20200514060929.85469-1-hare@suse.de>
	<20200514060929.85469-2-hare@suse.de>
	<BY5PR04MB6900948BCF84B9B97C5E5921E7BC0@BY5PR04MB6900.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BY5PR04MB6900948BCF84B9B97C5E5921E7BC0@BY5PR04MB6900.namprd04.prod.outlook.com>
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
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, May 14 2020 at  3:53am -0400,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:

> On 2020/05/14 15:09, Hannes Reinecke wrote:
> > Switch to use dynamic debug to avoid having recompile the kernel
> > just to enable debugging messages.
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > ---
> >  include/linux/device-mapper.h | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> > index af48d9da3916..4694e1bb4196 100644
> > --- a/include/linux/device-mapper.h
> > +++ b/include/linux/device-mapper.h
> > @@ -557,12 +557,11 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
> >  #define DMINFO(fmt, ...) pr_info(DM_FMT(fmt), ##__VA_ARGS__)
> >  #define DMINFO_LIMIT(fmt, ...) pr_info_ratelimited(DM_FMT(fmt), ##__VA_ARGS__)
> >  
> > +#define DMDEBUG_LIMIT(fmt, ...) pr_debug_ratelimited(DM_FMT(fmt), ##__VA_ARGS__)
> 
> Why do you move this one out of the #ifdef CONFIG_DM_DEBUG scope ?

I'd imagine because it already uses dynamic debugging and is useful even
if CONFIG_DM_DEBUG isn't set.  Makes sense to me.  I'll add a note about
it in the commit header though.

Mike
