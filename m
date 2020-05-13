From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: device-mapper: use dynamic debug instead of
 compile-time config option
Date: Wed, 13 May 2020 13:10:43 -0400
Message-ID: <20200513171042.GA20324@redhat.com>
References: <20200513070843.71528-1-hare@suse.de>
	<BY5PR04MB6900AD28F5B6B6C3A8AEAA5EE7BF0@BY5PR04MB6900.namprd04.prod.outlook.com>
	<5357d0d6-12cb-9585-36ae-9aec206eebb4@suse.de>
	<20200513162502.GA20131@redhat.com>
	<ce79fe87-3d2c-794b-75d6-7e59fd0b447c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ce79fe87-3d2c-794b-75d6-7e59fd0b447c@suse.de>
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
To: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, May 13 2020 at  1:01pm -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 5/13/20 6:25 PM, Mike Snitzer wrote:
> >On Wed, May 13 2020 at  7:10am -0400,
> >Hannes Reinecke <hare@suse.de> wrote:
> >
> >>On 5/13/20 11:41 AM, Damien Le Moal wrote:
> >>>On 2020/05/13 16:10, Hannes Reinecke wrote:
> >>>>Switch to use dynamic debug to avoid having recompile the kernel
> >>>>just to enable debugging messages.
> >>>>
> >>>>Signed-off-by: Hannes Reinecke <hare@suse.de>
> >>>>---
> >>>>  include/linux/device-mapper.h | 7 +------
> >>>>  1 file changed, 1 insertion(+), 6 deletions(-)
> >>>>
> >>>>diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> >>>>index e2d506dd805e..3d4365fd3001 100644
> >>>>--- a/include/linux/device-mapper.h
> >>>>+++ b/include/linux/device-mapper.h
> >>>>@@ -556,13 +556,8 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
> >>>>  #define DMINFO(fmt, ...) pr_info(DM_FMT(fmt), ##__VA_ARGS__)
> >>>>  #define DMINFO_LIMIT(fmt, ...) pr_info_ratelimited(DM_FMT(fmt), ##__VA_ARGS__)
> >>>>-#ifdef CONFIG_DM_DEBUG
> >>>
> >>>Can we remove this from Kconfig as a config option ?
> >>>
> >>No, we can't, it's being used by dm-snap and dm-integrity.
> >
> >Yeah, they provide additional debugging if its set.
> >
> >But shouldn't we preserve old-style DMDEBUG if CONFIG_DM_DEBUG is set
> >(compile time printing of debugging) but if not set, use dynamic
> >debugging?
> >
> >Think I'd prefer that as the incremental improvement... thoughts?
> >
> Works for me; I just don't want to recompile the kernel anytime I
> need to debug device-mapper stuff.
> 
> Will be resending.

Does the use of pr_debug() cause missing newlines (with your patch)?

Only thought to ask this because I'm chasing another DM issue at the
moment and happened to see __dm_suspend()'s use of pr_debug() includes
an explicit extra \n.

Mike
