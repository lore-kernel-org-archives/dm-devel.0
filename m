From: Joe Perches <joe@perches.com>
Subject: [RFC] using #pragma push_macro and pop_macro
Date: Mon, 17 Apr 2017 19:51:43 -0700
Message-ID: <1492483903.8661.28.camel@perches.com>
References: <201704180416.flAy5fPu%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201704180416.flAy5fPu%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: kbuild-all@01.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

There is an argument for using these #pragmas for pr_fmt.

gcc/clang/icc all support push_macro and pop_macro pragmas.

As far as I can tell, these compilers are the only ones
used to compile
the kernel.

Anyone have any objection to using these pragmas?

On Tue, 2017-04-18 at 05:02 +0800, kbuild test robot wrote:
> Hi Joe,
> 
> [auto build test ERROR on v4.9-rc8]
> [also build test ERROR on next-20170413]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Joe-Perches/device-mapper-Convert-printks-to-pr_-level-macros/20170418-030508
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from fs/nfs/blocklayout/blocklayout.h:35:0,
>                     from fs/nfs/blocklayout/dev.c:11:
>    fs/nfs/blocklayout/dev.c: In function 'bl_free_device':
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
> > > include/linux/printk.h:277:18: note: in expansion of macro 'pr_fmt'
> 
>      printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>                      ^~~~~~
> > > fs/nfs/blocklayout/dev.c:33:5: note: in expansion of macro 'pr_err'
> 
>         pr_err("failed to unregister PR key.\n");
>         ^~~~~~
>    fs/nfs/blocklayout/dev.c: In function 'nfs4_block_decode_volume':
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
>    include/linux/printk.h:284:19: note: in expansion of macro 'pr_fmt'
>      printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>                       ^~~~~~
> > > fs/nfs/blocklayout/dev.c:81:5: note: in expansion of macro 'pr_info'
> 
>         pr_info("signature too long: %d\n",
>         ^~~~~~~
>    fs/nfs/blocklayout/dev.c: In function 'bl_validate_designator':
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
> > > include/linux/printk.h:277:18: note: in expansion of macro 'pr_fmt'
> 
>      printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>                      ^~~~~~
>    fs/nfs/blocklayout/dev.c:287:3: note: in expansion of macro 'pr_err'
>       pr_err("pNFS: unsupported designator "
>       ^~~~~~
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
> > > include/linux/printk.h:277:18: note: in expansion of macro 'pr_fmt'
> 
>      printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>                      ^~~~~~
>    fs/nfs/blocklayout/dev.c:294:3: note: in expansion of macro 'pr_err'
>       pr_err("pNFS: invalid designator "
>       ^~~~~~
>    fs/nfs/blocklayout/dev.c: In function 'bl_open_udev_path':
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
>    include/linux/printk.h:279:22: note: in expansion of macro 'pr_fmt'
>      printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
>                          ^~~~~~
>    include/linux/printk.h:280:17: note: in expansion of macro 'pr_warning'
>     #define pr_warn pr_warning
>                     ^~~~~~~~~~
> > > fs/nfs/blocklayout/dev.c:320:3: note: in expansion of macro 'pr_warn'
> 
>       pr_warn("pNFS: failed to open device %s (%ld)\n",
>       ^~~~~~~
>    fs/nfs/blocklayout/dev.c: In function 'bl_parse_scsi':
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
>    include/linux/printk.h:284:19: note: in expansion of macro 'pr_fmt'
>      printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>                       ^~~~~~
>    fs/nfs/blocklayout/dev.c:373:2: note: in expansion of macro 'pr_info'
>      pr_info("pNFS: using block device %s (reservation key 0x%llx)\n",
>      ^~~~~~~
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
> > > include/linux/printk.h:277:18: note: in expansion of macro 'pr_fmt'
> 
>      printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>                      ^~~~~~
>    fs/nfs/blocklayout/dev.c:378:3: note: in expansion of macro 'pr_err'
>       pr_err("pNFS: block device %s does not support reservations.",
>       ^~~~~~
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
> > > include/linux/printk.h:277:18: note: in expansion of macro 'pr_fmt'
> 
>      printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>                      ^~~~~~
>    fs/nfs/blocklayout/dev.c:386:3: note: in expansion of macro 'pr_err'
>       pr_err("pNFS: failed to register key for block device %s.",
>       ^~~~~~
> --
>    In file included from fs/nfs/blocklayout/blocklayout.h:35:0,
>                     from fs/nfs/blocklayout/extent_tree.c:7:
>    include/linux/netdevice.h: In function 'netdev_cap_txqueue':
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
>    include/linux/printk.h:279:22: note: in expansion of macro 'pr_fmt'
>      printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
>                          ^~~~~~
> > > include/linux/net.h:238:3: note: in expansion of macro 'pr_warning'
> 
>       function(__VA_ARGS__);    \
>       ^~~~~~~~
> > > include/linux/net.h:252:2: note: in expansion of macro 'net_ratelimited_function'
> 
>      net_ratelimited_function(pr_warn, fmt, ##__VA_ARGS__)
>      ^~~~~~~~~~~~~~~~~~~~~~~~
> > > include/linux/net.h:252:27: note: in expansion of macro 'pr_warn'
> 
>      net_ratelimited_function(pr_warn, fmt, ##__VA_ARGS__)
>                               ^~~~~~~
> > > include/linux/netdevice.h:3119:3: note: in expansion of macro 'net_warn_ratelimited'
> 
>       net_warn_ratelimited("%s selects TX queue %d, but real number of TX queues is %d\n",
>       ^~~~~~~~~~~~~~~~~~~~
>    include/net/inet_connection_sock.h: In function 'inet_csk_clear_xmit_timer':
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
>    include/linux/dynamic_debug.h:126:35: note: in expansion of macro 'pr_fmt'
>       __dynamic_pr_debug(&descriptor, pr_fmt(fmt), \
>                                       ^~~~~~
>    include/linux/printk.h:309:2: note: in expansion of macro 'dynamic_pr_debug'
>      dynamic_pr_debug(fmt, ##__VA_ARGS__)
>      ^~~~~~~~~~~~~~~~
> > > include/net/inet_connection_sock.h:213:3: note: in expansion of macro 'pr_debug'
> 
>       pr_debug("%s", inet_csk_timer_bug_msg);
>       ^~~~~~~~
>    include/net/inet_connection_sock.h: In function 'inet_csk_reset_xmit_timer':
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
>    include/linux/dynamic_debug.h:126:35: note: in expansion of macro 'pr_fmt'
>       __dynamic_pr_debug(&descriptor, pr_fmt(fmt), \
>                                       ^~~~~~
>    include/linux/printk.h:309:2: note: in expansion of macro 'dynamic_pr_debug'
>      dynamic_pr_debug(fmt, ##__VA_ARGS__)
>      ^~~~~~~~~~~~~~~~
>    include/net/inet_connection_sock.h:229:3: note: in expansion of macro 'pr_debug'
>       pr_debug("reset_xmit_timer: sk=%p %d when=0x%lx, caller=%p\n",
>       ^~~~~~~~
> > > include/linux/device-mapper.h:536:34: error: expected ')' before 'DM_MSG_PREFIX'
> 
>     #define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>                                      ^
>    include/linux/dynamic_debug.h:126:35: note: in expansion of macro 'pr_fmt'
>       __dynamic_pr_debug(&descriptor, pr_fmt(fmt), \
>                                       ^~~~~~
>    include/linux/printk.h:309:2: note: in expansion of macro 'dynamic_pr_debug'
>      dynamic_pr_debug(fmt, ##__VA_ARGS__)
>      ^~~~~~~~~~~~~~~~
>    include/net/inet_connection_sock.h:247:3: note: in expansion of macro 'pr_debug'
>       pr_debug("%s", inet_csk_timer_bug_msg);
>       ^~~~~~~~
> 
> vim +536 include/linux/device-mapper.h
> 
>    530	#endif
>    531	
>    532	#ifdef pr_fmt
>    533	#undef pr_fmt
>    534	#endif
>    535	
>  > 536	#define pr_fmt(fmt) DM_NAME ": " DM_MSG_PREFIX ": " fmt
>    537	
>    538	#define DMCRIT(fmt, ...)						\
>    539		pr_crit(fmt "\n", ##__VA_ARGS__)
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
