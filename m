Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398E237C117;
	Fri,  6 Mar 2026 19:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772824125; cv=none; b=QuYg2bcqwhIY74wAyybDCpccrL5QBvW80izf0JGC6K4bpS0mtAf4JUycZ61eJe0LejbFXh3Mlb0MwdaGGvNoYcxs8FSLdoqa8c/KJgSsujwfyuOzlIkkQSoXCFhtR6kUN/RwmQe4vWYsKwr2KJJg0Wt59TXfCPvix6gPem7rfMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772824125; c=relaxed/simple;
	bh=ZLyVBPmGsR9sN2CDAK7LUsnA1QszcART72gzji1i4Zw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ko31MOcgSjdma+JxaTvBiVSF339TGn9tDrAai05Q2WV2Rl/CPJzd1EkzsbZaxayw8BMb8gcI1Qa7lGeBt0NBZRS67p9LHzNpONeiiITu1WMboi3SJvsgblfjjvMUHrnPyejY/k0xRxMNpX4TME1YQCe6qZLiIm570KPkD+S90sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c+iZMI8d; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c+iZMI8d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772824123; x=1804360123;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZLyVBPmGsR9sN2CDAK7LUsnA1QszcART72gzji1i4Zw=;
  b=c+iZMI8dTLOA8ECc6B/D8cETuRFn917aiDSo8Uk3RNnbMVGCLmaa1ros
   QCBkWL/MO2P0AIZIpovVeYSd9nx/YwgPDvlqDNY36iITQtoUD4/JDKONG
   g47h8t3XSNPpHKsB5b3SY/qVH6g3QCE5r2JPwADlwFiPce5QPdrWXbghT
   ugetInD0VCaAlgGPdLDNrgYDrH3SfxCn7K4maLy0ChSqao5/OWnHDG0rS
   /QrRCcFpZGgEreF82BnSwKNN8wmYZTfAkWGsYk5VEvOR/7JNb65N4HGwx
   kB2Yg1OV8zDncBQv4SSSys9YnsJHbRCz0mLA3JncTgMV1kNm24WGQivaI
   g==;
X-CSE-ConnectionGUID: CjuoMIwiTjG2vEM2B7gsPA==
X-CSE-MsgGUID: EpXDhYzCRyiO3JMSnof3SA==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="84265961"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="84265961"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 11:08:41 -0800
X-CSE-ConnectionGUID: SjuGL0ybQ6WgrZFQeRTrog==
X-CSE-MsgGUID: pe/ZkfSjSvWznS0bBCrcvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="215747406"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 06 Mar 2026 11:08:38 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyaXM-000000001Hj-0tpE;
	Fri, 06 Mar 2026 19:08:36 +0000
Date: Sat, 7 Mar 2026 03:07:55 +0800
From: kernel test robot <lkp@intel.com>
To: luoqing <l1138897701@163.com>, agk@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, snitzer@kernel.org,
	dm-devel@lists.linux.dev, mpatocka@redhat.com, bmarzins@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dm-bufio: Use struct_size() helper in kmalloc()
Message-ID: <202603070341.J8qZJaCg-lkp@intel.com>
References: <20260306080257.1268206-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306080257.1268206-1-l1138897701@163.com>

Hi luoqing,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe/for-next]
[also build test ERROR on device-mapper-dm/for-next linus/master v7.0-rc2 next-20260306]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/luoqing/dm-bufio-Use-struct_size-helper-in-kmalloc/20260306-165625
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20260306080257.1268206-1-l1138897701%40163.com
patch subject: [PATCH 2/2] dm-bufio: Use struct_size() helper in kmalloc()
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20260307/202603070341.J8qZJaCg-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260307/202603070341.J8qZJaCg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603070341.J8qZJaCg-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/workqueue.h:9,
                    from include/linux/mm_types.h:19,
                    from include/linux/mmzone.h:22,
                    from include/linux/gfp.h:7,
                    from include/linux/xarray.h:16,
                    from include/linux/list_lru.h:14,
                    from include/linux/fs/super_types.h:7,
                    from include/linux/fs/super.h:5,
                    from include/linux/fs.h:5,
                    from include/linux/highmem.h:5,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/blkdev.h:9,
                    from include/linux/dm-bufio.h:13,
                    from drivers/md/dm-bufio.c:10:
   drivers/md/dm-bufio.c: In function 'dm_bufio_client_create':
>> include/linux/overflow.h:420:38: error: 'struct dm_bufio_client' has no member named 'buffer_tree'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                      ^~
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/overflow.h:436:32: note: in expansion of macro 'flex_array_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |                     ^~~~~~~~~~~
   include/linux/overflow.h:420:69: error: 'struct dm_bufio_client' has no member named 'buffer_tree'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                                     ^~
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/compiler.h:208:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:207:35: note: in expansion of macro '__same_type'
     207 | #define __is_array(a)           (!__same_type((a), &(a)[0]))
         |                                   ^~~~~~~~~~~
   include/linux/compiler.h:208:58: note: in expansion of macro '__is_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                          ^~~~~~~~~~
   include/linux/overflow.h:420:50: note: in expansion of macro '__must_be_array'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                  ^~~~~~~~~~~~~~~
   include/linux/overflow.h:436:32: note: in expansion of macro 'flex_array_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |                     ^~~~~~~~~~~
   include/linux/overflow.h:420:69: error: 'struct dm_bufio_client' has no member named 'buffer_tree'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                                     ^~
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/compiler.h:208:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:207:35: note: in expansion of macro '__same_type'
     207 | #define __is_array(a)           (!__same_type((a), &(a)[0]))
         |                                   ^~~~~~~~~~~
   include/linux/compiler.h:208:58: note: in expansion of macro '__is_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                          ^~~~~~~~~~
   include/linux/overflow.h:420:50: note: in expansion of macro '__must_be_array'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                  ^~~~~~~~~~~~~~~
   include/linux/overflow.h:436:32: note: in expansion of macro 'flex_array_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |                     ^~~~~~~~~~~
   include/linux/compiler.h:203:82: error: expression in static assertion is not an integer
     203 | #define __BUILD_BUG_ON_ZERO_MSG(e, msg, ...) ((int)sizeof(struct {_Static_assert(!(e), msg);}))
         |                                                                                  ^
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/compiler.h:208:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:420:50: note: in expansion of macro '__must_be_array'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                  ^~~~~~~~~~~~~~~
   include/linux/overflow.h:436:32: note: in expansion of macro 'flex_array_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
--
         |                                            ^~
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/overflow.h:436:32: note: in expansion of macro 'flex_array_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |                     ^~~~~~~~~~~
   include/linux/overflow.h:421:75: error: 'struct dm_bufio_client' has no member named 'buffer_tree'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                                                           ^~
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/compiler.h:208:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:207:35: note: in expansion of macro '__same_type'
     207 | #define __is_array(a)           (!__same_type((a), &(a)[0]))
         |                                   ^~~~~~~~~~~
   include/linux/compiler.h:208:58: note: in expansion of macro '__is_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                          ^~~~~~~~~~
   include/linux/overflow.h:421:56: note: in expansion of macro '__must_be_array'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                                        ^~~~~~~~~~~~~~~
   include/linux/overflow.h:436:32: note: in expansion of macro 'flex_array_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |                     ^~~~~~~~~~~
   include/linux/overflow.h:421:75: error: 'struct dm_bufio_client' has no member named 'buffer_tree'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                                                           ^~
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/compiler.h:208:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:207:35: note: in expansion of macro '__same_type'
     207 | #define __is_array(a)           (!__same_type((a), &(a)[0]))
         |                                   ^~~~~~~~~~~
   include/linux/compiler.h:208:58: note: in expansion of macro '__is_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                          ^~~~~~~~~~
   include/linux/overflow.h:421:56: note: in expansion of macro '__must_be_array'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                                        ^~~~~~~~~~~~~~~
   include/linux/overflow.h:436:32: note: in expansion of macro 'flex_array_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |                     ^~~~~~~~~~~
   include/linux/compiler.h:203:82: error: expression in static assertion is not an integer
     203 | #define __BUILD_BUG_ON_ZERO_MSG(e, msg, ...) ((int)sizeof(struct {_Static_assert(!(e), msg);}))
         |                                                                                  ^
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/compiler.h:208:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:421:56: note: in expansion of macro '__must_be_array'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                                        ^~~~~~~~~~~~~~~
   include/linux/overflow.h:436:32: note: in expansion of macro 'flex_array_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |                     ^~~~~~~~~~~
>> include/linux/overflow.h:420:38: error: 'struct dm_bufio_client' has no member named 'buffer_tree'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                      ^~
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/overflow.h:437:40: note: in expansion of macro 'flex_array_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                        ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |                     ^~~~~~~~~~~
   include/linux/overflow.h:420:69: error: 'struct dm_bufio_client' has no member named 'buffer_tree'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                                     ^~
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/compiler.h:208:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:207:35: note: in expansion of macro '__same_type'
     207 | #define __is_array(a)           (!__same_type((a), &(a)[0]))
         |                                   ^~~~~~~~~~~
   include/linux/compiler.h:208:58: note: in expansion of macro '__is_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                          ^~~~~~~~~~
   include/linux/overflow.h:420:50: note: in expansion of macro '__must_be_array'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                  ^~~~~~~~~~~~~~~
   include/linux/overflow.h:437:40: note: in expansion of macro 'flex_array_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                        ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |                     ^~~~~~~~~~~
   include/linux/overflow.h:420:69: error: 'struct dm_bufio_client' has no member named 'buffer_tree'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                                     ^~
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/compiler.h:208:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:207:35: note: in expansion of macro '__same_type'
     207 | #define __is_array(a)           (!__same_type((a), &(a)[0]))
         |                                   ^~~~~~~~~~~
   include/linux/compiler.h:208:58: note: in expansion of macro '__is_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                          ^~~~~~~~~~
   include/linux/overflow.h:420:50: note: in expansion of macro '__must_be_array'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                  ^~~~~~~~~~~~~~~
   include/linux/overflow.h:437:40: note: in expansion of macro 'flex_array_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                        ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |                     ^~~~~~~~~~~
   include/linux/compiler.h:203:82: error: expression in static assertion is not an integer
     203 | #define __BUILD_BUG_ON_ZERO_MSG(e, msg, ...) ((int)sizeof(struct {_Static_assert(!(e), msg);}))
         |                                                                                  ^
   include/linux/alloc_tag.h:251:16: note: in definition of macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
   include/linux/slab.h:1190:49: note: in expansion of macro 'alloc_hooks'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ^~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:13: note: in expansion of macro 'kzalloc'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ^~~~~~~
   include/linux/compiler.h:208:33: note: in expansion of macro '__BUILD_BUG_ON_ZERO_MSG'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:420:50: note: in expansion of macro '__must_be_array'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                  ^~~~~~~~~~~~~~~
   include/linux/overflow.h:437:40: note: in expansion of macro 'flex_array_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                        ^~~~~~~~~~~~~~~
   drivers/md/dm-bufio.c:2514:21: note: in expansion of macro 'struct_size'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
..


vim +420 include/linux/overflow.h

610b15c50e86eb1 Kees Cook           2018-05-07  405  
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  406  /**
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  407   * flex_array_size() - Calculate size of a flexible array member
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  408   *                     within an enclosing structure.
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  409   * @p: Pointer to the structure.
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  410   * @member: Name of the flexible array member.
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  411   * @count: Number of elements in the array.
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  412   *
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  413   * Calculates size of a flexible array of @count number of @member
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  414   * elements, at the end of structure @p.
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  415   *
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  416   * Return: number of bytes needed or SIZE_MAX on overflow.
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  417   */
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  418  #define flex_array_size(p, member, count)				\
230f6fa2c1db6a3 Kees Cook           2022-02-09  419  	__builtin_choose_expr(__is_constexpr(count),			\
230f6fa2c1db6a3 Kees Cook           2022-02-09 @420  		(count) * sizeof(*(p)->member) + __must_be_array((p)->member),	\
230f6fa2c1db6a3 Kees Cook           2022-02-09  421  		size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
b19d57d0f3cc6f1 Gustavo A. R. Silva 2020-06-08  422  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
