From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 0/4] dm-writecache patches
Date: Sat, 19 May 2018 07:25:03 +0200
Message-ID: <20180519052503.325953342@debian.vm>
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
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Here I'm sending the dm-writecache patches.

The first patch optimizes x86 memcpy_flushcache for small constant size.
It increases dm-writecache throughput by about 2%. It should be already in
Dan Williams' tree.

The second patch exports __prepare_to_swait and __finish_swait.

The third patch is dm-writecache that is already in Mike's tree.

The fourth patch converts it to use the new API. The pmem_* API is at the
beginning of the file dm-writecache.c - it may be moved to system include
files.

Mikulas
