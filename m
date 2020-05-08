From: Paul Richards <paul.richards@gmail.com>
Subject: lvmcache comes back dirty after unclean shutdown
Date: Fri, 8 May 2020 09:26:23 +0100
Message-ID: <CAMoswehmi-hhp2M0w_8nEwX5CwPKKR7YW9jw1QrNzE=PFqKcRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

Hello,
I would like to add a warning to the lvmcache man page about its
suitability in environments that expect unclean shutdowns.

I've been using lvmcache on my laptop which has a small nvme drive and
a much larger hdd.  I am using approx 60GiB of the nvme drive as a
cache for the 1TiB HDD.

With both "writethrough" and "writeback" modes an unclean shutdown
results in the entire cache being marked as dirty.  On next boot the
system then spends a long time (4+ hours) writing the cache out to
disk.  From what I can see this is known behavior of lvmcache ([1] and
[2]).  It's even documented in the kernel device mapper docs [3].

It seems to me that dm-cache and lvmcache are not appropriate for
environments that expect unclean shutdowns.  In those environments I
have found bcache to be a bit more robust.

This is not a criticism of lvmcache and dm-cache.  I am sure they
perform well in more robust environments.  But I wonder if it would be
appropriate to add a warning note to the lvmcache man page about this
issue?


I am using Ubuntu 20.04 currently, if that's relevant, and I saw the
same issue with 18.04.


1: https://www.redhat.com/archives/dm-devel/2019-July/msg00114.html
2: https://www.redhat.com/archives/dm-devel/2014-December/msg00143.html
3: https://github.com/torvalds/linux/blame/79dede78c0573618e3137d3d8cbf78c84e25fabd/Documentation/admin-guide/device-mapper/cache.rst#L140-L143
