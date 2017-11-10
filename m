From: kbuild test robot <fengguang.wu@intel.com>
Subject: [dm:for-next 18/27]
 drivers//md/dm-cache-target.c:1441:19: error: 'ws' undeclared
Date: Sat, 11 Nov 2017 04:03:47 +0800
Message-ID: <201711110435.6GKsKCSt%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="r5Pyd7+fXNt84Ff3"
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
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com, kbuild-all@01.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   b93f980e5c9e057254d694c388daef774e717729
commit: 10d807b74cef508e163e7ae622321f5d6ae866df [18/27] dm cache: fix race condition in the writeback mode overwrite_bio optimisation
config: i386-randconfig-x019-201745 (attached as .config)
compiler: gcc-6 (Debian 6.4.0-9) 6.4.0 20171026
reproduce:
        git checkout 10d807b74cef508e163e7ae622321f5d6ae866df
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   drivers//md/dm-cache-target.c: In function 'mg_full_copy':
>> drivers//md/dm-cache-target.c:1441:19: error: 'ws' undeclared (first use in this function)
      mg_upgrade_lock(ws);
                      ^~
   drivers//md/dm-cache-target.c:1441:19: note: each undeclared identifier is reported only once for each function it appears in
   In file included from include/linux/linkage.h:4:0,
                    from include/linux/fs.h:4,
                    from drivers//md/dm.h:13,
                    from drivers//md/dm-cache-target.c:7:
   drivers//md/dm-cache-target.c: At top level:
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'strcpy' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:421:2: note: in expansion of macro 'if'
     if (p_size == (size_t)-1 && q_size == (size_t)-1)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:411:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:409:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:400:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:398:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:389:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:387:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:379:2: note: in expansion of macro 'if'
     if (p_size < size || q_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:376:3: note: in expansion of macro 'if'
      if (q_size < size)
      ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:374:3: note: in expansion of macro 'if'
      if (p_size < size)
      ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \

vim +/ws +1441 drivers//md/dm-cache-target.c

c6b4fcba Joe Thornber      2013-03-01  1432  
10d807b7 Joe Thornber      2017-11-10  1433  static void mg_full_copy(struct dm_cache_migration *mg)
c6b4fcba Joe Thornber      2013-03-01  1434  {
b29d4986 Joe Thornber      2016-12-15  1435  	struct cache *cache = mg->cache;
b29d4986 Joe Thornber      2016-12-15  1436  	struct policy_work *op = mg->op;
b29d4986 Joe Thornber      2016-12-15  1437  	bool is_policy_promote = (op->op == POLICY_PROMOTE);
c6b4fcba Joe Thornber      2013-03-01  1438  
b29d4986 Joe Thornber      2016-12-15  1439  	if ((!is_policy_promote && !is_dirty(cache, op->cblock)) ||
b29d4986 Joe Thornber      2016-12-15  1440  	    is_discarded_oblock(cache, op->oblock)) {
b29d4986 Joe Thornber      2016-12-15 @1441  		mg_upgrade_lock(ws);
c6b4fcba Joe Thornber      2013-03-01  1442  		return;
b29d4986 Joe Thornber      2016-12-15  1443  	}
c6b4fcba Joe Thornber      2013-03-01  1444  
b29d4986 Joe Thornber      2016-12-15  1445  	init_continuation(&mg->k, mg_upgrade_lock);
c6b4fcba Joe Thornber      2013-03-01  1446  
10d807b7 Joe Thornber      2017-11-10  1447  	if (copy(mg, is_policy_promote)) {
b29d4986 Joe Thornber      2016-12-15  1448  		DMERR_LIMIT("%s: migration copy failed", cache_device_name(cache));
4e4cbee9 Christoph Hellwig 2017-06-03  1449  		mg->k.input = BLK_STS_IOERR;
b29d4986 Joe Thornber      2016-12-15  1450  		mg_complete(mg, false);
b29d4986 Joe Thornber      2016-12-15  1451  	}
c6b4fcba Joe Thornber      2013-03-01  1452  }
10d807b7 Joe Thornber      2017-11-10  1453  

:::::: The code at line 1441 was first introduced by commit
:::::: b29d4986d0da1a27cd35917cdb433672f5c95d7f dm cache: significant rework to leverage dm-bio-prison-v2

:::::: TO: Joe Thornber <ejt@redhat.com>
:::::: CC: Mike Snitzer <snitzer@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--r5Pyd7+fXNt84Ff3
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
IPSyAQA=

--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--r5Pyd7+fXNt84Ff3--
