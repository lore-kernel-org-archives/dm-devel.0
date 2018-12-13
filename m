From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:block-dm-4.21-inflight 4/9]
 include/linux/percpu-defs.h:219:52: error: invalid operands to binary +
 (have 'struct disk_stats' and 'int')
Date: Wed, 12 Dec 2018 19:47:50 -0500
Message-ID: <20181213004750.GA3663@redhat.com>
References: <201812130808.IbSg5wxo%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201812130808.IbSg5wxo%fengguang.wu@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kbuild test robot <lkp@intel.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, kbuild-all@01.org
List-Id: dm-devel.ids

On Wed, Dec 12 2018 at  7:44pm -0500,
kbuild test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git block-dm-4.21-inflight
> head:   847fb34c0a7f7bbfca9d6053316aafb864a550b2

No idea why the kbuild test robot is just testing random branches but
this code was just a point in time for the percpu inflight counter
patchset.  Since merged into linux-block with full support for
CONFIG_SMP not being set.

I'll delete this old block-dm-4.21-inflight branch now though...
