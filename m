Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D59A41B34F;
	Fri,  6 Mar 2026 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817304; cv=none; b=pa4vDi9FFpy4shRBrqWRzxRZBpBkp5MGu/Gg6bjGhOEDsofXwpgH0rBNt8Am46goucI6miy5iy8zYh3doTuiYuq44ppC4iTatKnJOQh0siM7HVhw43i6v2O7bvTVKPUwcGq6j2lScXOLZl9+X4ndg2sw9ZkB3aTk/dQt1A/mCig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817304; c=relaxed/simple;
	bh=BQG2iBejr7GJS93lSzOQzYGb4u+EhLXK6hWxnP7UGHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhZVE/ZBG2cM4SeJ+awR/yLqAUCHs/l7K8hLuSNZbYjnd3wxweZkK5QNok+GiQOdvMgGFP4m2kvRkeMtLqPUDg8UWtKgEEHe1AT6qxF6iB955ilflYg4BWRwL9owW+9Szvg5WIPlOmBklFu7g4HuVUWbE6UEZmwutXdJJ+iyUaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L9bQ2I5o; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L9bQ2I5o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772817303; x=1804353303;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BQG2iBejr7GJS93lSzOQzYGb4u+EhLXK6hWxnP7UGHo=;
  b=L9bQ2I5oeUzs6YdEC53iVFCZpEgv/7jO/P9XZjsdlYTLGNOuSILgmcOr
   UkpNV7MDilFEc1DAIBCdSAHVjgaOFHm8K81EelR1YucmOJskm7AhL0UAy
   S8pAwtWNWLf7ZmafX4HqyBm8jDftMgt1h4V5HNq0Mqu1UKZ6dt6w5OJve
   ElKKihemnCj+S1fBKDgwgQA5MYP7PKvU+7EKL28UKwsp/iD1+2HHqECKs
   iBP2A+rJRWfzLl6u4qTjrepzOgFkDrqSTQ9DMjswZYMigTUFwHieMRjBP
   lBLc8zRMarzduMVgKt32rbn0ocjsfvEBXC4+tQmKnT8XhKIuPXq8BDGCu
   A==;
X-CSE-ConnectionGUID: dQ7G2YdURUqLXrLk6AjXVg==
X-CSE-MsgGUID: JbR4E6olRDO9TP4EB1lYUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="73805077"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="73805077"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 09:15:02 -0800
X-CSE-ConnectionGUID: LAkPTm3EQQGZ0w/WrREynA==
X-CSE-MsgGUID: Nmkri4kzTGiz1scqZDclxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="223757673"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa005.fm.intel.com with ESMTP; 06 Mar 2026 09:14:59 -0800
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyYlM-000000002I5-2mCq;
	Fri, 06 Mar 2026 17:14:56 +0000
Date: Fri, 6 Mar 2026 18:14:17 +0100
From: kernel test robot <lkp@intel.com>
To: luoqing <l1138897701@163.com>, agk@redhat.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, snitzer@kernel.org,
	dm-devel@lists.linux.dev, mpatocka@redhat.com, bmarzins@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dm-bufio: Use struct_size() helper in kmalloc()
Message-ID: <202603061810.Sm9P1QKo-lkp@intel.com>
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260306/202603061810.Sm9P1QKo-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260306/202603061810.Sm9P1QKo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603061810.Sm9P1QKo-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:436:37: note: expanded from macro 'struct_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                                   ^
   include/linux/overflow.h:420:26: note: expanded from macro 'flex_array_size'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                        ^
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:251:9: note: expanded from macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:436:37: note: expanded from macro 'struct_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                                   ^
   include/linux/overflow.h:420:57: note: expanded from macro 'flex_array_size'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                                       ^
   include/linux/compiler.h:208:64: note: expanded from macro '__must_be_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                                     ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:251:9: note: expanded from macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:436:37: note: expanded from macro 'struct_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                                   ^
   include/linux/overflow.h:421:32: note: expanded from macro 'flex_array_size'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                              ^
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:251:9: note: expanded from macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:436:37: note: expanded from macro 'struct_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                                   ^
   include/linux/overflow.h:421:63: note: expanded from macro 'flex_array_size'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                                                             ^
   include/linux/compiler.h:208:64: note: expanded from macro '__must_be_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                                     ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:251:9: note: expanded from macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:437:45: note: expanded from macro 'struct_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                                           ^
   include/linux/overflow.h:420:26: note: expanded from macro 'flex_array_size'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                        ^
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:251:9: note: expanded from macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:437:45: note: expanded from macro 'struct_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                                           ^
   include/linux/overflow.h:420:57: note: expanded from macro 'flex_array_size'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                                       ^
   include/linux/compiler.h:208:64: note: expanded from macro '__must_be_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                                     ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:251:9: note: expanded from macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:437:45: note: expanded from macro 'struct_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                                           ^
   include/linux/overflow.h:421:32: note: expanded from macro 'flex_array_size'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                              ^
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:251:9: note: expanded from macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:437:45: note: expanded from macro 'struct_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                                           ^
   include/linux/overflow.h:421:63: note: expanded from macro 'flex_array_size'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                                                             ^
   include/linux/compiler.h:208:64: note: expanded from macro '__must_be_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                                     ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:251:9: note: expanded from macro 'alloc_hooks_tag'
     251 |         typeof(_do_alloc) _res;                                         \
         |                ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:436:37: note: expanded from macro 'struct_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                                   ^
   include/linux/overflow.h:420:26: note: expanded from macro 'flex_array_size'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                        ^
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:255:10: note: expanded from macro 'alloc_hooks_tag'
     255 |                 _res = _do_alloc;                                       \
         |                        ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:436:37: note: expanded from macro 'struct_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                                   ^
   include/linux/overflow.h:420:57: note: expanded from macro 'flex_array_size'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                                       ^
   include/linux/compiler.h:208:64: note: expanded from macro '__must_be_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                                     ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:255:10: note: expanded from macro 'alloc_hooks_tag'
     255 |                 _res = _do_alloc;                                       \
         |                        ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:436:37: note: expanded from macro 'struct_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                                   ^
   include/linux/overflow.h:421:32: note: expanded from macro 'flex_array_size'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                              ^
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:255:10: note: expanded from macro 'alloc_hooks_tag'
     255 |                 _res = _do_alloc;                                       \
         |                        ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:436:37: note: expanded from macro 'struct_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                                   ^
   include/linux/overflow.h:421:63: note: expanded from macro 'flex_array_size'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                                                             ^
   include/linux/compiler.h:208:64: note: expanded from macro '__must_be_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                                     ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:255:10: note: expanded from macro 'alloc_hooks_tag'
     255 |                 _res = _do_alloc;                                       \
         |                        ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:437:45: note: expanded from macro 'struct_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                                           ^
   include/linux/overflow.h:420:26: note: expanded from macro 'flex_array_size'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                        ^
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:255:10: note: expanded from macro 'alloc_hooks_tag'
     255 |                 _res = _do_alloc;                                       \
         |                        ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:437:45: note: expanded from macro 'struct_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                                           ^
   include/linux/overflow.h:420:57: note: expanded from macro 'flex_array_size'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                                       ^
   include/linux/compiler.h:208:64: note: expanded from macro '__must_be_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                                     ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:255:10: note: expanded from macro 'alloc_hooks_tag'
     255 |                 _res = _do_alloc;                                       \
         |                        ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:437:45: note: expanded from macro 'struct_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                                           ^
   include/linux/overflow.h:421:32: note: expanded from macro 'flex_array_size'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                              ^
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:255:10: note: expanded from macro 'alloc_hooks_tag'
     255 |                 _res = _do_alloc;                                       \
         |                        ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:437:45: note: expanded from macro 'struct_size'
     437 |                 size_add(sizeof(*(p)), flex_array_size(p, member, count)))
         |                                                           ^
   include/linux/overflow.h:421:63: note: expanded from macro 'flex_array_size'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                                                             ^
   include/linux/compiler.h:208:64: note: expanded from macro '__must_be_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                                     ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:255:10: note: expanded from macro 'alloc_hooks_tag'
     255 |                 _res = _do_alloc;                                       \
         |                        ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:436:37: note: expanded from macro 'struct_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                                   ^
   include/linux/overflow.h:420:26: note: expanded from macro 'flex_array_size'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                        ^
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:258:10: note: expanded from macro 'alloc_hooks_tag'
     258 |                 _res = _do_alloc;                                       \
         |                        ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:436:37: note: expanded from macro 'struct_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                                   ^
   include/linux/overflow.h:420:57: note: expanded from macro 'flex_array_size'
     420 |                 (count) * sizeof(*(p)->member) + __must_be_array((p)->member),  \
         |                                                                       ^
   include/linux/compiler.h:208:64: note: expanded from macro '__must_be_array'
     208 | #define __must_be_array(a)      __BUILD_BUG_ON_ZERO_MSG(!__is_array(a), \
         |                                                                     ^
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:258:10: note: expanded from macro 'alloc_hooks_tag'
     258 |                 _res = _do_alloc;                                       \
         |                        ^~~~~~~~~
>> drivers/md/dm-bufio.c:2514:29: error: no member named 'buffer_tree' in 'struct dm_bufio_client'
    2514 |         c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
         |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:436:37: note: expanded from macro 'struct_size'
     436 |                 sizeof(*(p)) + flex_array_size(p, member, count),       \
         |                                                   ^
   include/linux/overflow.h:421:32: note: expanded from macro 'flex_array_size'
     421 |                 size_mul(count, sizeof(*(p)->member) + __must_be_array((p)->member)))
         |                                              ^
   include/linux/slab.h:1190:52: note: expanded from macro 'kzalloc'
    1190 | #define kzalloc(...)                            alloc_hooks(kzalloc_noprof(__VA_ARGS__))
         |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/alloc_tag.h:265:31: note: expanded from macro 'alloc_hooks'
     265 |         alloc_hooks_tag(&_alloc_tag, _do_alloc);                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
   include/linux/alloc_tag.h:258:10: note: expanded from macro 'alloc_hooks_tag'
     258 |                 _res = _do_alloc;                                       \
         |                        ^~~~~~~~~
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.


vim +2514 drivers/md/dm-bufio.c

  2491	
  2492	/*
  2493	 * Create the buffering interface
  2494	 */
  2495	struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsigned int block_size,
  2496						       unsigned int reserved_buffers, unsigned int aux_size,
  2497						       void (*alloc_callback)(struct dm_buffer *),
  2498						       void (*write_callback)(struct dm_buffer *),
  2499						       unsigned int flags)
  2500	{
  2501		int r;
  2502		unsigned int num_locks;
  2503		struct dm_bufio_client *c;
  2504		char slab_name[64];
  2505		static atomic_t seqno = ATOMIC_INIT(0);
  2506	
  2507		if (!block_size || block_size & ((1 << SECTOR_SHIFT) - 1)) {
  2508			DMERR("%s: block size not specified or is not multiple of 512b", __func__);
  2509			r = -EINVAL;
  2510			goto bad_client;
  2511		}
  2512	
  2513		num_locks = dm_num_hash_locks();
> 2514		c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
  2515		if (!c) {
  2516			r = -ENOMEM;
  2517			goto bad_client;
  2518		}
  2519		cache_init(&c->cache, num_locks, (flags & DM_BUFIO_CLIENT_NO_SLEEP) != 0);
  2520	
  2521		c->bdev = bdev;
  2522		c->block_size = block_size;
  2523		if (is_power_of_2(block_size))
  2524			c->sectors_per_block_bits = __ffs(block_size) - SECTOR_SHIFT;
  2525		else
  2526			c->sectors_per_block_bits = -1;
  2527	
  2528		c->alloc_callback = alloc_callback;
  2529		c->write_callback = write_callback;
  2530	
  2531		if (flags & DM_BUFIO_CLIENT_NO_SLEEP) {
  2532			c->no_sleep = true;
  2533			static_branch_inc(&no_sleep_enabled);
  2534		}
  2535	
  2536		mutex_init(&c->lock);
  2537		spin_lock_init(&c->spinlock);
  2538		INIT_LIST_HEAD(&c->reserved_buffers);
  2539		c->need_reserved_buffers = reserved_buffers;
  2540	
  2541		dm_bufio_set_minimum_buffers(c, DM_BUFIO_MIN_BUFFERS);
  2542	
  2543		init_waitqueue_head(&c->free_buffer_wait);
  2544		c->async_write_error = 0;
  2545	
  2546		c->dm_io = dm_io_client_create();
  2547		if (IS_ERR(c->dm_io)) {
  2548			r = PTR_ERR(c->dm_io);
  2549			goto bad_dm_io;
  2550		}
  2551	
  2552		if (block_size <= KMALLOC_MAX_SIZE && !is_power_of_2(block_size)) {
  2553			unsigned int align = min(1U << __ffs(block_size), (unsigned int)PAGE_SIZE);
  2554	
  2555			snprintf(slab_name, sizeof(slab_name), "dm_bufio_cache-%u-%u",
  2556						block_size, atomic_inc_return(&seqno));
  2557			c->slab_cache = kmem_cache_create(slab_name, block_size, align,
  2558							  SLAB_RECLAIM_ACCOUNT, NULL);
  2559			if (!c->slab_cache) {
  2560				r = -ENOMEM;
  2561				goto bad;
  2562			}
  2563		}
  2564		if (aux_size)
  2565			snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer-%u-%u",
  2566						aux_size, atomic_inc_return(&seqno));
  2567		else
  2568			snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer-%u",
  2569						atomic_inc_return(&seqno));
  2570		c->slab_buffer = kmem_cache_create(slab_name, sizeof(struct dm_buffer) + aux_size,
  2571						   0, SLAB_RECLAIM_ACCOUNT, NULL);
  2572		if (!c->slab_buffer) {
  2573			r = -ENOMEM;
  2574			goto bad;
  2575		}
  2576	
  2577		while (c->need_reserved_buffers) {
  2578			struct dm_buffer *b = alloc_buffer(c, GFP_KERNEL);
  2579	
  2580			if (!b) {
  2581				r = -ENOMEM;
  2582				goto bad;
  2583			}
  2584			__free_buffer_wake(b);
  2585		}
  2586	
  2587		INIT_WORK(&c->shrink_work, shrink_work);
  2588		atomic_long_set(&c->need_shrink, 0);
  2589	
  2590		c->shrinker = shrinker_alloc(0, "dm-bufio:(%u:%u)",
  2591					     MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
  2592		if (!c->shrinker) {
  2593			r = -ENOMEM;
  2594			goto bad;
  2595		}
  2596	
  2597		c->shrinker->count_objects = dm_bufio_shrink_count;
  2598		c->shrinker->scan_objects = dm_bufio_shrink_scan;
  2599		c->shrinker->seeks = 1;
  2600		c->shrinker->batch = 0;
  2601		c->shrinker->private_data = c;
  2602	
  2603		shrinker_register(c->shrinker);
  2604	
  2605		mutex_lock(&dm_bufio_clients_lock);
  2606		dm_bufio_client_count++;
  2607		list_add(&c->client_list, &dm_bufio_all_clients);
  2608		__cache_size_refresh();
  2609		mutex_unlock(&dm_bufio_clients_lock);
  2610	
  2611		return c;
  2612	
  2613	bad:
  2614		while (!list_empty(&c->reserved_buffers)) {
  2615			struct dm_buffer *b = list_to_buffer(c->reserved_buffers.next);
  2616	
  2617			list_del(&b->lru.list);
  2618			free_buffer(b);
  2619		}
  2620		kmem_cache_destroy(c->slab_cache);
  2621		kmem_cache_destroy(c->slab_buffer);
  2622		dm_io_client_destroy(c->dm_io);
  2623	bad_dm_io:
  2624		mutex_destroy(&c->lock);
  2625		if (c->no_sleep)
  2626			static_branch_dec(&no_sleep_enabled);
  2627		kfree(c);
  2628	bad_client:
  2629		return ERR_PTR(r);
  2630	}
  2631	EXPORT_SYMBOL_GPL(dm_bufio_client_create);
  2632	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
