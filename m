From: kbuild test robot <lkp@intel.com>
Subject: [dm:dm-5.2 22/22] drivers/md/dm-dust.c:35:17: sparse:
 sparse: symbol 'dust_rb_search' was not declared. Should it be static?
Date: Sat, 27 Apr 2019 07:12:48 +0800
Message-ID: <201904270727.g6e3MBmi%lkp@intel.com>
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
To: Bryan Gurney <bgurney@redhat.com>
Cc: dm-devel@redhat.com, kbuild-all@01.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-5.2
head:   cefb8eb074c8cde87d4a6947e24c00b8cbde830c
commit: cefb8eb074c8cde87d4a6947e24c00b8cbde830c [22/22] dm: add dust target
reproduce:
        # apt-get install sparse
        git checkout cefb8eb074c8cde87d4a6947e24c00b8cbde830c
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/md/dm-dust.c:35:17: sparse: sparse: symbol 'dust_rb_search' was not declared. Should it be static?
>> drivers/md/dm-dust.c:53:6: sparse: sparse: symbol 'dust_rb_insert' was not declared. Should it be static?
>> drivers/md/dm-dust.c:495:12: sparse: sparse: symbol 'dm_dust_init' was not declared. Should it be static?
>> drivers/md/dm-dust.c:505:13: sparse: sparse: symbol 'dm_dust_exit' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
