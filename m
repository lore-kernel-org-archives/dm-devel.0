From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Tue, 26 May 2015 10:17:57 -0700
Message-ID: <CAF1ivSa76LmWTNagR6waPVkcypZY=cd0x9woJCbBfecs40A1Pg@mail.gmail.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-2-git-send-email-mlin@kernel.org>
	<20150526143626.GA4315@redhat.com>
	<CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
	<20150526160400.GB4715@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150526160400.GB4715@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lin <mlin@kernel.org>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

On Tue, May 26, 2015 at 9:04 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Tue, May 26 2015 at 11:02am -0400,
> Ming Lin <mlin@kernel.org> wrote:
>
>> On Tue, May 26, 2015 at 7:36 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>> > On Fri, May 22 2015 at  2:18pm -0400,
>> > Ming Lin <mlin@kernel.org> wrote:
>> >
>> >> From: Kent Overstreet <kent.overstreet@gmail.com>
>> >>
>> >> The way the block layer is currently written, it goes to great lengths
>> >> to avoid having to split bios; upper layer code (such as bio_add_page())
>> >> checks what the underlying device can handle and tries to always create
>> >> bios that don't need to be split.
>> >>
>> >> But this approach becomes unwieldy and eventually breaks down with
>> >> stacked devices and devices with dynamic limits, and it adds a lot of
>> >> complexity. If the block layer could split bios as needed, we could
>> >> eliminate a lot of complexity elsewhere - particularly in stacked
>> >> drivers. Code that creates bios can then create whatever size bios are
>> >> convenient, and more importantly stacked drivers don't have to deal with
>> >> both their own bio size limitations and the limitations of the
>> >> (potentially multiple) devices underneath them.  In the future this will
>> >> let us delete merge_bvec_fn and a bunch of other code.
>> >
>> > This series doesn't take any steps to train upper layers
>> > (e.g. filesystems) to size their bios larger (which is defined as
>> > "whatever size bios are convenient" above).
>> >
>> > bio_add_page(), and merge_bvec_fn, served as the means for upper layers
>> > (and direct IO) to build up optimally sized bios.  Without a replacement
>> > (that I can see anyway) how is this patchset making forward progress
>> > (getting Acks, etc)!?
>> >
>> > I like the idea of reduced complexity associated with these late bio
>> > splitting changes I'm just not seeing how this is ready given there are
>> > no upper layer changes that speak to building larger bios..
>> >
>> > What am I missing?
>>
>> See: [PATCH v4 02/11] block: simplify bio_add_page()
>> https://lkml.org/lkml/2015/5/22/754
>>
>> Now bio_add_page() can build lager bios.
>> And blk_queue_split() can split the bios in ->make_request() if needed.
>
> That'll result in quite large bios and always needing splitting.
>
> As Alasdair asked: please provide some performance data that justifies
> these changes.  E.g use a setup like: XFS on a DM striped target.  We
> can iterate on more complex setups once we have established some basic
> tests.

I'll test XFS on DM and also what Christoph suggested:
https://lkml.org/lkml/2015/5/25/226

>
> If you're just punting to reviewers to do the testing for you that isn't
> going to instill _any_ confidence in me for this patchset as a suitabe
> replacement relative to performance.

Kent's Direct IO rewrite patch depends on this series.
https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/log/?h=block-dio-rewrite

I did test the dio patch on a 2 sockets(48 logical CPUs) server and
saw 40% improvement with 48 null_blks.
Here is the fio data of 4k read.

4.1-rc2
----------
Test 1: bw=50509MB/s, iops=12930K
Test 2: bw=49745MB/s, iops=12735K
Test 3: bw=50297MB/s, iops=12876K,
Average: bw=50183MB/s, iops=12847K

4.1-rc2-dio-rewrite
------------------------
Test 1: bw=70269MB/s, iops=17989K
Test 2: bw=70097MB/s, iops=17945K
Test 3: bw=70907MB/s, iops=18152K
Average: bw=70424MB/s, iops=18028K
