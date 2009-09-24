From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: A BUG in snapshot merging
Date: Thu, 24 Sep 2009 02:33:07 -0400
Message-ID: <20090924063306.GB4266@redhat.com>
References: <Pine.LNX.4.64.0909211349480.16230@hs20-bc2-1.build.redhat.com>
	<20090921175655.GA28074@redhat.com>
	<Pine.LNX.4.64.0909211815580.31653@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909221130590.24935@hs20-bc2-1.build.redhat.com>
	<20090922170000.GA1806@redhat.com>
	<20090922192039.GA13465@redhat.com>
	<20090924000707.GA29085@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090924000707.GA29085@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 23 2009 at  8:07pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Mikulas,
> 
> I can easily reproduce the BUG you reported (you were running on
> sparc64) if I take the following patch out of the quilt series:
> http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel_unified/2.6.31/dm-exstore-persistent-allow-metadata-reread.patch
> 
> I've made an adjusted quilt series available here:
> http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel_unified_no_reread/2.6.31/
> 
> I'll be working to sort this out but I wanted to give you a heads up
> that I can now easily reproduce the BUG on x86.  Don't even need to stop
> the merge and restart; just a normal merge triggers the BUG after the
> first extent of chunks is merged.

Turns out the BUG doesn't occur immediately after processing the first
extent of chunks (via merge_callback).

It occurs IFF the chunks are _not_ processed in descending order, e.g.:

...
start  merge chunk=29939 linear_chunks=160
finish merge chunk=29939
finish merge chunk=29938
finish merge chunk=29937
finish merge chunk=29936
...
finish merge chunk=29784
finish merge chunk=29783
finish merge chunk=29782
finish merge chunk=29781
finish merge chunk=29780
start  merge chunk=29736 linear_chunks=3
finish merge chunk=29736
finish merge chunk=29735
finish merge chunk=29734
start  merge chunk=29779 linear_chunks=43
finish merge chunk=29779
------------[ cut here ]------------
kernel BUG at drivers/md/dm-snap-persistent.c:456!
...

So in the above you see chunks 29734-29736 gets interleaved between
29779 and 29780.

This provided the hint I needed to fix the fact that when we moved
dm-snapshot-dont-insert-before-existing-chunk.patch to the beginning of
the series  we neglected to adjust
dm-snapshot-move-exception-code-to-new-file.patch accordingly.

As a result dm-snapshot-move-exception-code-to-new-file.patch had
reintroduced inserting the exceptions into the hash_table before other
exceptions..

Mikulas/Jon, I'd really appreciate it if you could test the following
updated quilt tree(s):

http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel_unified/2.6.31/
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel_unified_no_reread/2.6.31/

Mikulas, the 'kernel_unified_no_reread' quilt tree is slightly more
minimalist (avoids adding re-read support to dm-snap-persistent.c) so it
is worth a shot if 'kernel_unified' still fails for you.

Both work for me on x86_64.  But we may not be out of the woods on
sparc64.

Thanks,
Mike
