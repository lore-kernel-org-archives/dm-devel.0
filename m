From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH v05 04/72] dm-log-userspace.h: use __u32,
 __s32 and __u64 from linux/types.h
Date: Thu, 25 Aug 2016 09:57:00 +0300
Message-ID: <20160825065700.GX5399@lakka.kapsi.fi>
References: <1471890809-4383-1-git-send-email-mikko.rapeli@iki.fi>
	<1471890809-4383-5-git-send-email-mikko.rapeli@iki.fi>
	<BY2PR02MB16868FAEFEA311312FA688B981EB0@BY2PR02MB1686.namprd02.prod.outlook.com>
	<BY2PR02MB1686A7AFCFDB3D8D0C41A42981EB0@BY2PR02MB1686.namprd02.prod.outlook.com>
	<20160823204232.GP5399@lakka.kapsi.fi>
	<BLUPR02MB16838BBEFFAA2240A879370E81ED0@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <BLUPR02MB16838BBEFFAA2240A879370E81ED0@BLUPR02MB1683.namprd02.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Aug 25, 2016 at 04:24:11AM +0000, Bart Van Assche wrote:
> On 08/23/16 13:42, Mikko Rapeli wrote:
> > On Tue, Aug 23, 2016 at 02:28:19PM +0000, Bart Van Assche wrote:
> >> On 08/23/16 06:57, Bart Van Assche wrote:
> >>> On 08/22/16 11:32, Mikko Rapeli wrote:
> >>>> - * uint32_t (*get_region_size)(struct dm_dirty_log *log);
> >>>> + * __u32 (*get_region_size)(struct dm_dirty_log *log);
> >>>
> >>> uint32_t is a type that is defined by ANSI C but __u32 not. So this
> >>> change looks wrong to me. Would it have been sufficient to add "#include
> >>> <linux/types.h>" and keep the uint32_t etc. type names?
> >>
> >> Answering my own question: adding "#include <linux/types.h>" wouldn't be
> >> sufficient. How about adding the following code that also occurs in a
> >> few other uapi header files?
> >>
> >> #ifndef __KERNEL__
> >> #include <stdint.h>
> >> #endif
> >> #include <linux/types.h>
> >
> > I have tried that before but I was instructed to use the linux/types.h
> > versions. For example https://lkml.org/lkml/2015/6/1/160
> >
> > But lately drm and fuse and some others have questioned this approach and
> > would like to use/continue using C99 stdint.h types.
> 
> Hello Mikko,
> 
> Thanks for the feedback. I have a minor comment though about your patch: 
> are you aware that you have changed uint64_t into __u64 in source code 
> comments but that int64_t has not been changed into __s64?

Thanks, that's a bug. I'll update the patch.

I guess I was reading compiler error list and string replacing only those.

-Mikko
