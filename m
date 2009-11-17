From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 12/12] dm snapshot: merge a linear region
 of chunks using one large IO
Date: Tue, 17 Nov 2009 11:20:44 -0500
Message-ID: <20091117162043.GA5223@redhat.com>
References: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
	<1258474344-10886-13-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1258474344-10886-13-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 17 2009 at 11:12am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> s->store->type->prepare_merge returns the number of chunks that can be
> linearly copied starting from the returned chunk number backward. (but
> the caller is allowed to copy less, and the caller puts the number of
> copied chunks to s->store->type->commit_merge)
> 
> I.e. if returned chunk numbers are old_chunk == 10 and new_chunk == 20
> and returned value is 3, then chunk 20 can be copied to 10, chunk 19 to
> 9 and 18 to 8.
> 
> s->merge_write_interlock_n has now been allowed to be increased up to
> the full range of chunks returned from s->store->type->prepare_merge.
> Until now kcopyd was only ever allowed to copy one chunk at a time;
> as a result snapshot-merge performance was extremely slow.
> 
> Also, snapshot_merge_process() needs to delay the merging of _all_
> chunks that have in-progress writes; not just the first chunk in the
> region that is to be merged.
> 
> snapshot-merge performance is now very respectible.

s/respectible/respectable/

Also, I removed the following from the patch header but it helps show
how "respectable" snapshot-merge performance is with this patch:

Here are performance results from some mkfs-based testing:

# lvcreate -n testlv -L 32G test
# lvcreate -n testlv_snap -s -L 7G test/testlv

# time mkfs.ext3 /dev/test/testlv
...
real    1m7.827s
user    0m0.116s
sys     0m11.017s

# lvs
 LV          VG   Attr   LSize  Origin Snap%  Move Log Copy%  Convert
 testlv      test owi-a- 32.00G
 testlv_snap test swi-a-  7.00G testlv   9.05

before:
-------
# time lvconvert --merge test/testlv_snap
 Merging of volume testlv_snap started.
 ...
 Merge into logical volume testlv finished.
 Logical volume "snapshot1" successfully removed

real    22m33.100s
user    0m0.045s
sys     0m0.711s


after:
------
# time lvconvert --merge test/testlv_snap
 Merging of volume testlv_snap started.
 testlv: Merged: 6.4%
 testlv: Merged: 3.5%
 testlv: Merged: 0.9%
 testlv: Merged: 0.0%
 Merge into logical volume testlv finished.
 Logical volume "snapshot1" successfully removed

real    1m0.881s
user    0m0.015s
sys     0m0.560s
