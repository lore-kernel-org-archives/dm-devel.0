From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH] dm flakey: add DAX support
Date: Wed, 21 Sep 2016 07:42:43 +1000
Message-ID: <20160920214243.GA10454@dastard>
References: <147440445480.62486.9559239844115396323.stgit@djiang5-desk3.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <147440445480.62486.9559239844115396323.stgit-Cxk7aZI4ujnJARH06PadV2t3HXsI98Cx0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Tue, Sep 20, 2016 at 01:47:34PM -0700, Dave Jiang wrote:
> Change dm-flakey to implement direct_access function,
> flakey_direct_access(), which maps sector and calls direct_access
> function of its physical target device. This pretty much is a copy
> from DM Linear.
> 
> This allows fs with DAX to pass in xfstests.

They don't fail. They simply don't run like this:

generic/321 1s ... [not run] Cannot run tests with DAX on dmflakey devices
generic/322 0s ... [not run] Cannot run tests with DAX on dmflakey devices

> It does not actually introduce
> data corruption and dropping writes unlike the non-DAX path. The main
> reason is due to the I/O path being out of dmflakey's control once
> direct_access() has been called. The the existing implementation cannot
> be adapted to DAX I/O path. The error injection will be introduced at a
> later date with more thought.

Then introduce dmflakey DAX support at that time. Running tests that
are supposed to exercise failure paths when those failure paths
cannot be triggered is fundamentally useless. It leads a false
indication that we are actually testing failures, when in fact we
are doing nothing of the sort.

Right now the test harness execution clearly documents that there is
no failure testing being run on DAX devices, and that's the way it
should remain until dmflakey, dmerror, etc can inject the required
errors into the DAX paths....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
