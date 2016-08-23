From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [dm-devel] [PATCH v05 04/72] dm-log-userspace.h: use __u32,
 __s32 and __u64 from linux/types.h
Date: Tue, 23 Aug 2016 23:42:32 +0300
Message-ID: <20160823204232.GP5399@lakka.kapsi.fi>
References: <1471890809-4383-1-git-send-email-mikko.rapeli@iki.fi>
 <1471890809-4383-5-git-send-email-mikko.rapeli@iki.fi>
 <BY2PR02MB16868FAEFEA311312FA688B981EB0@BY2PR02MB1686.namprd02.prod.outlook.com>
 <BY2PR02MB1686A7AFCFDB3D8D0C41A42981EB0@BY2PR02MB1686.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BY2PR02MB1686A7AFCFDB3D8D0C41A42981EB0@BY2PR02MB1686.namprd02.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 23, 2016 at 02:28:19PM +0000, Bart Van Assche wrote:
> On 08/23/16 06:57, Bart Van Assche wrote:
> > On 08/22/16 11:32, Mikko Rapeli wrote:
> >> - * uint32_t (*get_region_size)(struct dm_dirty_log *log);
> >> + * __u32 (*get_region_size)(struct dm_dirty_log *log);
> >
> > uint32_t is a type that is defined by ANSI C but __u32 not. So this
> > change looks wrong to me. Would it have been sufficient to add "#include
> > <linux/types.h>" and keep the uint32_t etc. type names?
> 
> Answering my own question: adding "#include <linux/types.h>" wouldn't be 
> sufficient. How about adding the following code that also occurs in a 
> few other uapi header files?
> 
> #ifndef __KERNEL__
> #include <stdint.h>
> #endif
> #include <linux/types.h>

I have tried that before but I was instructed to use the linux/types.h
versions. For example https://lkml.org/lkml/2015/6/1/160

But lately drm and fuse and some others have questioned this approach and
would like to use/continue using C99 stdint.h types.

-Mikko
