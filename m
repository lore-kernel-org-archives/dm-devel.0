From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: trouble with generic/081
Date: Thu, 5 Jan 2017 13:52:10 -0500
Message-ID: <20170105185210.GB7737@redhat.com>
References: <20161214164314.GA25105@infradead.org>
	<20161215063650.GJ4326@dastard>
	<20161215084224.GA14395@infradead.org>
	<c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
	<20161216081523.GA13847@infradead.org>
	<5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
	<a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
	<86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Dave Chinner <david@fromorbit.com>, eguan@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 05 2017 at  1:24pm -0500,
Eric Sandeen <sandeen@sandeen.net> wrote:

> Upstream now has better xfs error handling configurability.  Have you
> tested with that?  (for that matter, what thinp test framework exists
> on the lvm2/dm side?  We currently have only minimal testing fstests,
> to be honest.  Until we have a framework to test against this seems likely
> to continue going in theoretical circles.)

device-mapper-test-suite (dmts) has various thinp out of space tests,
e.g.:

# dmtest run --suite thin-provisioning -n /out_of_*space/
Loaded suite thin-provisioning
DeletionTests
  delete_after_out_of_space...PASS
DiscardSlowTests
  discard_after_out_of_space...PASS

# dmtest run --suite thin-provisioning -t PoolResizeWhenOutOfSpaceTests
Loaded suite thin-provisioning
PoolResizeWhenOutOfSpaceTests
  io_to_provisioned_region_with_OODS_held_io...PASS
  out_of_data_space_errors_immediately_if_requested...PASS
  out_of_data_space_times_out...PASS
  resize_after_OODS_error_immediately...PASS
  resize_after_OODS_held_io...PASS
  resize_after_OODS_held_io_ext4...#<Test::Unit::Error:0x00000003746d48
 @exception=
  #<ProcessControl::ExitError: command failed: fsck.ext4 -fn /dev/mapper/test-dev-60498>,
 @test_name=
  "test_resize_after_OODS_held_io_ext4(PoolResizeWhenOutOfSpaceTests)">
FAIL
  resize_after_OODS_held_io_preload...PASS
  resize_after_OODS_held_io_timed_out_preload...PASS
  resize_io...PASS

I need to look closer at the 'resize_after_OODS_held_io_ext4' FAIL,
after initial look the dmts test code seems to be buggy.

But we can easily extend to have specific coverage with XFS ontop.
