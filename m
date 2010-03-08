From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH] dm: max_segments=1 if merge_bvec_fn is not supported
Date: Mon, 8 Mar 2010 14:14:49 +0100
Message-ID: <20100308131449.GA15156@racke>
References: <20100306211012.GA9689@racke>
 <20100308163345.42841480@notabene.brown>
 <Pine.LNX.4.64.1003080321190.25635@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003080321190.25635@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Mar 08, 2010 at 03:35:37AM -0500, Mikulas Patocka wrote:
> Hi
> 
> That patch with limits->max_segments = 1; is wrong. It fixes this bug 
> sometimes and sometimes not.
> 
> The problem is, if someone attempts to create a bio with two vector 
> entries, the first maps the last sector contained in some page and the 
> second maps the first sector of the next physical page: it has one 
> segment, it has size <= PAGE_SIZE, but it still may cross raid stripe and 
> the raid driver will reject it.

Now that you put it that way ;)
You are right.

My asumption that "single segment" was  
equalvalent in practice with "single bvec"
does not hold true in that case.

Then, what about adding seg_boundary_mask restrictions as well?
	max_sectors = PAGE_SIZE >> 9;
	max_segments = 1;
	seg_boundary_mask = PAGE_SIZE -1;
or some such.

> > > This is not the first time this has been patched, btw.
> > > See https://bugzilla.redhat.com/show_bug.cgi?id=440093
> > > and the patch by Mikulas:
> > > https://bugzilla.redhat.com/attachment.cgi?id=342638&action=diff
> 
> Look at this patch, it is the proper way how to fix it: create a 
> merge_bvec_fn that reject more than one biovec entry.

If adding seg_boundary_mask is still not sufficient,
lets merge that patch instead?
Why has it been dropped, respectively never been merged?
It became obsolete for dm-linear by 7bc3447b,
but in general the bug is still there, or am I missing something?



	Lars
