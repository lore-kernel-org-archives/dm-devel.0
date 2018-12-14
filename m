From: Huaisheng HS1 Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
Subject: RE: [External]  Re: Snapshot target and DAX-capable devices
Date: Fri, 14 Dec 2018 08:24:49 +0000
Message-ID: <HK2PR03MB441871946735DE9EE714D10B92A10@HK2PR03MB4418.apcprd03.prod.outlook.com>
References: <20180830093028.GC1767@quack2.suse.cz>
 <20180830184907.GA14867@redhat.com>
 <x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
 <alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
 <20180830233809.GH1572@dastard> <20180831094255.GB11622@quack2.suse.cz>
 <167a3303a01.11a848ab768799.5161498967766415143@zoho.com>
 <20181212161254.GA20790@infradead.org> <20181212175047.GA24962@redhat.com>
 <20181212211547.GA24926@thunk.org> <20181212224321.GA2902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181212224321.GA2902-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: zh-CN
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, NingTing Cheng <chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, colyli <colyli-l3A5Bk7waGM@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: dm-devel.ids

From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sent: Thursday, December 13, 2018 6:43 AM
> On Wed, Dec 12 2018 at  4:15pm -0500,
> Theodore Y. Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> 
> > On Wed, Dec 12, 2018 at 12:50:47PM -0500, Mike Snitzer wrote:
> > > On Wed, Dec 12 2018 at 11:12am -0500,
> > > Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > >
> > > > Does it really make sense to enhance dm-snapshot?  I thought all serious
> > > > users of snapshots had moved on to dm-thinp?
> > >
> > > There are cases where dm-snapshot is still useful for people.  But those
> > > are very niche users.  I'm not opposed to others proposing enhancements
> > > for dm-snapshot in general but it is definitely not a priority (Google's
> > > dm-bow is an example of a case where dm-snapshot may get extended to
> > > fulfill google's needs).
> >
> > I would expect that dm-snapshot will be used quite a lot for
> > short-lived snapshots (that only live during a database backup or an
> > fsck run).  I would hardly call that a "niche use case".
> 
> dm-snapshot is only ~60% performant for 1 snapshot.  Try to do
> additional snapshots and performance crawls to a stop (though I haven't
> reassessed performance in a while).
> 
> dm-snapshot has been in Linux since before 2005, I don't know of all the
> users of it -- maybe there are a ton of users who only take a single
> temporary snapshot and we're all oblivious.
> 
> Definitely not seeing many bugs against it (but it has been around
> forever).  I do know that there are relatively few people showing
> interest in it.  But for 4.21 I did stage a couple useful performance
> fixes:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.
> 21&id=61d594bb7e1cf86dca49cbc9524eb80169d9fca6
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.
> 21&id=d1f7898c7a1b24aa9ae670f9cc21b65e730827eb

Hi Mike,

Could these two patches be applied to current code of LVM?
Although there is a difficult problem as mmap for dm-snapshot with
DAX-capable, the two patches can be used for other complex DM targets
when trying to implement DAX.

[RFC PATCH v2 2/3] dm: expand hc_map in mapped_device for lack of map
https://lkml.org/lkml/2018/11/21/273

[RFC PATCH v2 3/3] dm: expand valid types for dm-ioctl
https://lkml.org/lkml/2018/11/21/276

Cheers,
Huaisheng Ye
