From: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [dm-devel] Snapshot target and DAX-capable devices
Date: Thu, 13 Dec 2018 23:11:18 -0500
Message-ID: <20181214041118.GE20880@thunk.org>
References: <20180830184907.GA14867@redhat.com>
 <x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
 <alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
 <20180830233809.GH1572@dastard>
 <20180831094255.GB11622@quack2.suse.cz>
 <167a3303a01.11a848ab768799.5161498967766415143@zoho.com>
 <20181212161254.GA20790@infradead.org>
 <20181212175047.GA24962@redhat.com>
 <20181212211547.GA24926@thunk.org>
 <20181212224321.GA2902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20181212224321.GA2902-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, chengnt <chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, colyli <colyli-l3A5Bk7waGM@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

On Wed, Dec 12, 2018 at 05:43:22PM -0500, Mike Snitzer wrote:
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

Well, here's one user:

https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/tree/scrub/e2scrub.in

This is a spiffed up version of my original script:

https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/tree/contrib/e2croncheck

I suppose we should look into enhancing e2scrub so it can deal with
volumes stored on dm-thin pools.....

> dm-thinp has the concept of an "external origin".  Changes to origin LVM
> volume get copied out to the thin-pool (same copy cost as old
> dm-snapshot).  But IIRC from that point on your LVM volume is a dm-thin
> device.

I would think the *snapshot* would have to be the dm-thin device, not
the origin volume, correct?

The original LVM module would still be mounted through the original
LVM device-mapper device, so it couldn't get transmogrified to be a
dm-thin device, right?

					- Ted
