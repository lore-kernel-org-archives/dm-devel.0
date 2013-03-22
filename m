From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: dm-cache fails to write the cache device in writethrough mode
Date: Fri, 22 Mar 2013 18:34:28 -0400
Message-ID: <20130322223425.GA5638@redhat.com>
References: <20130322201151.GB5357@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130322201151.GB5357@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Paul Taysom <taysom@chromium.org>, Randy Dunlap <rdunlap@infradead.org>
List-Id: dm-devel.ids

On Fri, Mar 22 2013 at  4:11pm -0400,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> The new writethrough strategy for dm-cache issues a bio to the origin device,
> remaps the bio to the cache device, and issues the bio to the cache device.
> However, the block layer modifies bi_sector and bi_size, so we need to preserve
> these or else nothing gets written to the cache (bi_size == 0).  This fixes the
> problem where someone writes a block through the cache, but a subsequent reread
> (from the cache) returns old contents.

Your writethrough blkid test results are certainly strange.  But I'm not
aware of where the block layer would modify bi_size and bi_sector;
please elaborate.

I cannot reproduce your original report.  I developed
'test_writethrough_ext4_uuids_match', apologies for the ruby code:

  def test_writethrough_ext4_uuids_match
    size = meg(10)
  
    # wipe the origin to ensure we don't accidentally have the same
    # data on it.
    with_standard_linear(:data_size => size) do |origin|
      wipe_device(origin)
    end

    uuid = "deadbeef-cafe-dead-beef-cafedeadbeef"

    # format the cache device with a specific uuid
    with_standard_cache(:format => true,
                        :io_mode => :writethrough,
                        :data_size => size) do |cache|
      fs = FS::file_system(:ext4, cache)
      fs.format(:uuid => uuid)
      FS::assert_fs_uuid(uuid, cache)
    end

    # origin should have the same uuid as the cache
    with_standard_linear(:data_size => size) do |origin|
      FS::assert_fs_uuid(uuid, origin)
    end
  end

This test was committed to the 'devel' branch of my thinp-test-suite
tree: git://github.com/snitm/thinp-test-suite.git

Also the existing 'test_writethrough' test works fine.

So for now:

Nacked-by: Mike Snitzer <snitzer@redhat.com>
