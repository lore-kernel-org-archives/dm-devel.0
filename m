From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: dm-cache bug when using the cleaner?
Date: Mon, 4 Mar 2013 17:40:48 -0800
Message-ID: <20130305014048.GD5347@blackbox.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Joe Thornber <thornber@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi there,

I've been playing around with writeback mode in dmcache with my shiny new
3.9-rc1 kernel.

# dmsetup table moocache
0 67108864 cache 253:0 253:1 8:0 512 1 writeback default 4 random_threshold 8 sequential_threshold 512
# dmsetup status moocache
0 67108864 cache 14/2048 3967 54586 263549 190982 0 0 2000 51 0 2 migration_threshold 204800 4 random_threshold 8 sequential_threshold 512

I think this means there are 51 dirty cache blocks?  I'd like to flush them out
to the spinny disk:

# dmsetup suspend moocache
# echo '0 67108864 cache 253:0 253:1 8:0 512 0 cleaner 0' | dmsetup reload moocache
# dmsetup resume moocache

Ok, now let's wait for it to finish...

# dmsetup wait moocache
# dmsetup status moocache
0 67108864 cache 14/2048 3967 54586 263583 190982 0 0 2000 0 0 2 migration_threshold 204800 0

Now that dirty field goes from 51 back to 0, like I'd expected.  However, if I
then put the old policy back:

# dmsetup suspend moocache
# echo '0 67108864 cache 253:0 253:1 8:0 512 1 writeback default 4 random_threshold 8 sequential_threshold 512' | dmsetup reload moocache
# dmsetup resume moocache

# dmsetup status moocache
0 67108864 cache 14/2048 3967 54586 263553 190982 0 0 2000 51 0 2 migration_threshold 204800 4 random_threshold 8 sequential_threshold 512

That's odd, there are still 51 dirty cache blocks?  Am I missing something?  Is
there something about suspend/resume that causes something to get reset?  Do I
even need the suspend/resume pair?  (I'm pretty sure I do; the table doesn't
change if I don't.)  I get the same dirtyblocks==51 results even if I remove
and (re)create moocache.

--D
