From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [patch 1/1] md/dm: Reduce stack usage with stacked
	block devices
Date: Tue, 10 Jan 2006 14:04:02 +0000
Message-ID: <20060110140402.GQ4346@agk.surrey.redhat.com>
References: <200601100231.k0A2VMYu005612@shell0.pdx.osdl.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200601100231.k0A2VMYu005612@shell0.pdx.osdl.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: akpm@osdl.org, neilb@suse.de, axboe@suse.de, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 09, 2006 at 06:31:10PM -0800, Andrew Morton wrote:
> When stacked block devices are in-use (e.g.  md or dm), the recursive calls
> to generic_make_request can use up a lot of space, and we would rather they
> didn't.
 
I can see nothing wrong with this in principle.

For device-mapper at the moment though it's essential that, while the bio 
mappings may now get delayed, they still get processed in exactly
the same order as they were passed to generic_make_request().

My main concern is whether the timing changes implicit in this patch
will make the rare data-corrupting races in the existing snapshot code
more likely. (I'm working on a fix for these races, but the unfinished
patch is already several hundred lines long.)

It would be helpful if some people on this mailing list would test 
this patch in various scenarios and report back.

Alasdair
-- 
agk@redhat.com
