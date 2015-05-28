From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Wed, 27 May 2015 22:54:55 -0700
Message-ID: <CAF1ivSawO6_xq8dTAVXGX5qX_F+XymR3BNB5O4nAGKXXB61Ebg@mail.gmail.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-2-git-send-email-mlin@kernel.org>
	<20150526143626.GA4315@redhat.com>
	<CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
	<20150526160400.GB4715@redhat.com>
	<CAF1ivSZ351yV4re1Ghf5yqPjgq6aXjrZT4yWd+T9msAFsBnDSw@mail.gmail.com>
	<20150528003627.GD32216@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20150528003627.GD32216-FDJ95KluN3Z0klwcnFlA1dvLeJWuRmrY@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: dm-devel.ids

On Wed, May 27, 2015 at 5:36 PM, Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, May 27, 2015 at 04:42:44PM -0700, Ming Lin wrote:
>> Here are fio results of XFS on a DM stripped target with 2 SSDs + 1 HDD.
>> Does it make sense?
>
> To stripe across devices with different characteristics?

I intended to test it on a 2 sockets server with 10 NVMe drives.
But that server has been busy running other tests.

So I have to run test on a PC which happen to have 2 SSDs + 1 HDD.

>
> Some suggestions.

Thanks for the great detail.
I'm reading to understand.

>
> Prepare 3 kernels.
>   O - Old kernel.
>   M - Old kernel with merge_bvec_fn disabled.
>   N - New kernel.
>
> You're trying to search for counter-examples to the hypothesis that
> "Kernel N always outperforms Kernel O".  Then if you find any, trying
> to show either that the performance impediment is small enough that
> it doesn't matter or that the cases are sufficiently rare or obscure
> that they may be ignored because of the greater benefits of N in much more
> common cases.
>
> (1) You're looking to set up configurations where kernel O performs noticeably
> better than M.  Then you're comparing the performance of O and N in those
> situations.
>
> (2) You're looking at other sensible configurations where O and M have
> similar performance, and comparing that with the performance of N.
>
> In each case you find, you expect to be able to vary some parameter (such as
> stripe size) to show a progression of the effect.
>
> When running tests you've to take care the system is reset into the same
> initial state before each test, so you'll normally also try to include some
> baseline test between tests that should give the same results each time
> and also take the average of a number of runs (while also reporting some
> measure of the variation within each set to make sure that remains low,
> typically a low single digit percentage).
>
> Since we're mostly concerned about splitting, you'll want to monitor
> iostat to see if that gives you enough information to home in on
> suitable configurations for (1).  Failing that, you might need to
> instrument the kernels to tell you the sizes of the bios being
> created and the amount of splitting actually happening.
>
> Striping was mentioned because it forces splitting.  So show the progression
> from tiny stripes to huge stripes.  (Ensure all the devices providing the
> stripes have identical characteristics, but you can test with slow and
> fast underlying devices.)
>
> You may also want to test systems with a restricted amount of available
> memory to show how the splitting via worker thread performs.  (Again,
> instrument to prove the extent to which the new code is being exercised.)
>
> Alasdair
>
