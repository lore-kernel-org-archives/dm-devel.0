From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 18/27]
 drivers//md/dm-cache-target.c:1441:19: error: 'ws' undeclared
Date: Fri, 10 Nov 2017 15:31:18 -0500
Message-ID: <20171110203117.GA26187@redhat.com>
References: <201711110435.6GKsKCSt%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201711110435.6GKsKCSt%fengguang.wu@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Joe Thornber <ejt@redhat.com>, kbuild-all@01.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Fixed (my fault!)

On Fri, Nov 10 2017 at  3:03pm -0500,
kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   b93f980e5c9e057254d694c388daef774e717729
> commit: 10d807b74cef508e163e7ae622321f5d6ae866df [18/27] dm cache: fix race condition in the writeback mode overwrite_bio optimisation
> config: i386-randconfig-x019-201745 (attached as .config)
> compiler: gcc-6 (Debian 6.4.0-9) 6.4.0 20171026
> reproduce:
>         git checkout 10d807b74cef508e163e7ae622321f5d6ae866df
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers//md/dm-cache-target.c: In function 'mg_full_copy':
> >> drivers//md/dm-cache-target.c:1441:19: error: 'ws' undeclared (first use in this function)
>       mg_upgrade_lock(ws);
>                       ^~
>    drivers//md/dm-cache-target.c:1441:19: note: each undeclared identifier is reported only once for each function it appears in
>    In file included from include/linux/linkage.h:4:0,
>                     from include/linux/fs.h:4,
>                     from drivers//md/dm.h:13,
>                     from drivers//md/dm-cache-target.c:7:
>    drivers//md/dm-cache-target.c: At top level:
>    include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'strcpy' which is not static
>        ______f = {     \
>        ^
>    include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
>     #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>                           ^~~~~~~~~~
>    include/linux/string.h:421:2: note: in expansion of macro 'if'
>      if (p_size == (size_t)-1 && q_size == (size_t)-1)
>      ^~
>    include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
>        ______f = {     \
>        ^
>    include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
>     #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>                           ^~~~~~~~~~
>    include/linux/string.h:411:2: note: in expansion of macro 'if'
>      if (p_size < size)
>      ^~
>    include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
>        ______f = {     \
>        ^
>    include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
>     #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>                           ^~~~~~~~~~
>    include/linux/string.h:409:2: note: in expansion of macro 'if'
>      if (__builtin_constant_p(size) && p_size < size)
>      ^~
>    include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
>        ______f = {     \
>        ^
>    include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
>     #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>                           ^~~~~~~~~~
>    include/linux/string.h:400:2: note: in expansion of macro 'if'
>      if (p_size < size)
>      ^~
>    include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
>        ______f = {     \
>        ^
>    include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
>     #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>                           ^~~~~~~~~~
>    include/linux/string.h:398:2: note: in expansion of macro 'if'
>      if (__builtin_constant_p(size) && p_size < size)
>      ^~
>    include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
>        ______f = {     \
>        ^
>    include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
>     #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>                           ^~~~~~~~~~
>    include/linux/string.h:389:2: note: in expansion of macro 'if'
>      if (p_size < size)
>      ^~
>    include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
>        ______f = {     \
>        ^
>    include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
>     #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>                           ^~~~~~~~~~
>    include/linux/string.h:387:2: note: in expansion of macro 'if'
>      if (__builtin_constant_p(size) && p_size < size)
>      ^~
>    include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
>        ______f = {     \
>        ^
>    include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
>     #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>                           ^~~~~~~~~~
>    include/linux/string.h:379:2: note: in expansion of macro 'if'
>      if (p_size < size || q_size < size)
>      ^~
>    include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
>        ______f = {     \
>        ^
>    include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
>     #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>                           ^~~~~~~~~~
>    include/linux/string.h:376:3: note: in expansion of macro 'if'
>       if (q_size < size)
>       ^~
>    include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
>        ______f = {     \
>        ^
>    include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
>     #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>                           ^~~~~~~~~~
>    include/linux/string.h:374:3: note: in expansion of macro 'if'
>       if (p_size < size)
>       ^~
>    include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
>        ______f = {     \
> 
> vim +/ws +1441 drivers//md/dm-cache-target.c
> 
> c6b4fcba Joe Thornber      2013-03-01  1432  
> 10d807b7 Joe Thornber      2017-11-10  1433  static void mg_full_copy(struct dm_cache_migration *mg)
> c6b4fcba Joe Thornber      2013-03-01  1434  {
> b29d4986 Joe Thornber      2016-12-15  1435  	struct cache *cache = mg->cache;
> b29d4986 Joe Thornber      2016-12-15  1436  	struct policy_work *op = mg->op;
> b29d4986 Joe Thornber      2016-12-15  1437  	bool is_policy_promote = (op->op == POLICY_PROMOTE);
> c6b4fcba Joe Thornber      2013-03-01  1438  
> b29d4986 Joe Thornber      2016-12-15  1439  	if ((!is_policy_promote && !is_dirty(cache, op->cblock)) ||
> b29d4986 Joe Thornber      2016-12-15  1440  	    is_discarded_oblock(cache, op->oblock)) {
> b29d4986 Joe Thornber      2016-12-15 @1441  		mg_upgrade_lock(ws);
> c6b4fcba Joe Thornber      2013-03-01  1442  		return;
> b29d4986 Joe Thornber      2016-12-15  1443  	}
> c6b4fcba Joe Thornber      2013-03-01  1444  
> b29d4986 Joe Thornber      2016-12-15  1445  	init_continuation(&mg->k, mg_upgrade_lock);
> c6b4fcba Joe Thornber      2013-03-01  1446  
> 10d807b7 Joe Thornber      2017-11-10  1447  	if (copy(mg, is_policy_promote)) {
> b29d4986 Joe Thornber      2016-12-15  1448  		DMERR_LIMIT("%s: migration copy failed", cache_device_name(cache));
> 4e4cbee9 Christoph Hellwig 2017-06-03  1449  		mg->k.input = BLK_STS_IOERR;
> b29d4986 Joe Thornber      2016-12-15  1450  		mg_complete(mg, false);
> b29d4986 Joe Thornber      2016-12-15  1451  	}
> c6b4fcba Joe Thornber      2013-03-01  1452  }
> 10d807b7 Joe Thornber      2017-11-10  1453  
> 
> :::::: The code at line 1441 was first introduced by commit
> :::::: b29d4986d0da1a27cd35917cdb433672f5c95d7f dm cache: significant rework to leverage dm-bio-prison-v2
> 
> :::::: TO: Joe Thornber <ejt@redhat.com>
> :::::: CC: Mike Snitzer <snitzer@redhat.com>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
