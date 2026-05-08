Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCAB153BE9
	for <dm-devel@lists.linux.dev>; Fri,  8 May 2026 00:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778201285; cv=none; b=TWSlsFGUKH1XSo6VH/9o404w0lom6b1PIEzr7PBCzEqPeasXsQY+/NQSkN6lYQP7LfTjiKE/CSu+Vwp1sgiDK2KIabScaBKHsvxFHDwXHAf2kQScFZrryLb1RVIYL+DDHOnikTKYACtVqDoQGsuCmrqIZ8fehvneIR9w0ROorVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778201285; c=relaxed/simple;
	bh=X+bUJGv3Xea7s2yqhHvZe4+TFNYvgDYlECEfQKnII6M=;
	h=Date:From:To:Cc:Subject:Message-ID; b=QZicJCHp+68ORj3XbYSdQvItkdvxR047pgK2RYymvVYc1cgktf61n7GHkItuE1cNtPKhmGVlyplMaR1opJkd2RHs6G87VkHhd2PlcIBhSyjwIHk4S+pcW54kCnfg0d8Mx5tvWOB6yGZwqwrPYrFdpWJ1JWp+6v6XxAVAAdebAW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CVXq9D6W; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CVXq9D6W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778201284; x=1809737284;
  h=date:from:to:cc:subject:message-id;
  bh=X+bUJGv3Xea7s2yqhHvZe4+TFNYvgDYlECEfQKnII6M=;
  b=CVXq9D6W0pqYDudI/1zQEobXlZ9DTiQDdholdP8FlhjnftQcSUDvx/7O
   iWJqLSxCNR3TeI9cj8dcQzRG+Xg+Wh8bK4oJ2yF4LLlFXnH6wvo7s42D7
   CXs0UeG7ZlTzzx2nbqddDgRLxHobslZGLguL60nycR+SkYJkQlHvgl/BY
   DuZX2CiOhmDHxzxBGL1NZZlP06IkfxZqh4HT6t7x6Z2MY+e1jur0XhRY1
   7OHLqjplpwrp/I1KoX0WXDGIHuOxe/uTk5Q0OqWefoj0jJ2/08z27l1s0
   1kvf5/bbKLt6V6G9AL6DViOU5m5BOzKtW+w9nmi+4hKdPz5aDu2JZAnCi
   Q==;
X-CSE-ConnectionGUID: MF9PbZp1Sta98sp9UeMy/g==
X-CSE-MsgGUID: k9swMvcNTumOaOe3lmmzlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="83013311"
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="83013311"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 17:48:04 -0700
X-CSE-ConnectionGUID: N+tz7d/WR/qQ6+3O8eNu+g==
X-CSE-MsgGUID: Leoo5Y56QnWF8IaqpxjBIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="236553957"
Received: from lkp-server01.sh.intel.com (HELO d6e19f2f5857) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 07 May 2026 17:48:00 -0700
Received: from kbuild by d6e19f2f5857 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wL9Nk-000000000f7-0yz9;
	Fri, 08 May 2026 00:47:56 +0000
Date: Fri, 08 May 2026 08:46:57 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 dm-devel@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 Thierry Reding <treding@nvidia.com>
Subject: [linux-next:master] BUILD REGRESSION
 17c7841d09ee7d33557fd075562d9289b6018c90
Message-ID: <202605080845.lfBckbvQ-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 17c7841d09ee7d33557fd075562d9289b6018c90  Add linux-next specific files for 20260507

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202605072335.vIeZwrl0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202605080638.NXLkvBwM-lkp@intel.com

    ERROR: modpost: "__aeabi_ldivmod" [sound/soc/tegra/snd-soc-tegra210-mixer.ko] undefined!
    ERROR: modpost: "__aeabi_uldivmod" [sound/soc/tegra/snd-soc-tegra210-mixer.ko] undefined!
    drivers/md/dm-inlinecrypt.c:329 inlinecrypt_ctr() warn: error code type promoted to positive: 'ctx->key_size'
    ld.lld: error: call to __compiletime_assert_343 marked "dontcall-error": BUILD_BUG failed
    ld.lld: error: undefined symbol: crypto_register_rng

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202605080719.1aBMAYBS-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202605080740.0iDqLAUR-lkp@intel.com

    Warning: arch/mips/cavium-octeon/executive/cvmx-boot-vector.c:155 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    drivers/platform/x86/hp/hp-wmi.c:391 rpm_to_pwm() warn: signedness bug returning '(-65025)'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arm-randconfig-001
|   |-- ERROR:__aeabi_ldivmod-sound-soc-tegra-snd-soc-tegra210-mixer.ko-undefined
|   `-- ERROR:__aeabi_uldivmod-sound-soc-tegra-snd-soc-tegra210-mixer.ko-undefined
|-- hexagon-randconfig-r073-20260508
|   |-- drivers-md-dm-inlinecrypt.c-inlinecrypt_ctr()-warn:error-code-type-promoted-to-positive:ctx-key_size
|   `-- drivers-md-dm-inlinecrypt.c-inlinecrypt_ctr()-warn:unsigned-ctx-key_size-is-never-less-than-zero.
|-- i386-randconfig-r061-20260508
|   `-- ld.lld:error:call-to-__compiletime_assert_NNN-marked-dontcall-error:BUILD_BUG-failed
|-- loongarch-randconfig-002-20260507
|   `-- ld.lld:error:undefined-symbol:crypto_register_rng
|-- mips-randconfig-r131-20260507
|   `-- Warning:arch-mips-cavium-octeon-executive-cvmx-boot-vector.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
`-- x86_64-randconfig-161-20260507
    `-- drivers-platform-x86-hp-hp-wmi.c-rpm_to_pwm()-warn:signedness-bug-returning

elapsed time: 754m

configs tested: 192
configs skipped: 8

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260508    gcc-13.4.0
arc                   randconfig-002-20260508    gcc-12.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260508    gcc-8.5.0
arm                   randconfig-002-20260508    gcc-10.5.0
arm                   randconfig-003-20260508    gcc-14.3.0
arm                   randconfig-004-20260508    gcc-13.4.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260507    clang-23
arm64                 randconfig-002-20260507    gcc-13.4.0
arm64                 randconfig-003-20260507    clang-23
arm64                 randconfig-004-20260507    gcc-8.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260507    gcc-15.2.0
csky                  randconfig-002-20260507    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260507    clang-23
hexagon               randconfig-002-20260507    clang-23
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260507    gcc-14
i386        buildonly-randconfig-001-20260508    gcc-14
i386                 buildonly-randconfig-002    clang-20
i386        buildonly-randconfig-002-20260507    gcc-14
i386        buildonly-randconfig-002-20260508    gcc-14
i386                 buildonly-randconfig-003    clang-20
i386        buildonly-randconfig-003-20260507    gcc-14
i386        buildonly-randconfig-003-20260508    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260507    gcc-14
i386        buildonly-randconfig-004-20260508    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260507    clang-20
i386        buildonly-randconfig-005-20260508    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260507    gcc-14
i386        buildonly-randconfig-006-20260508    gcc-14
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260508    clang-20
i386                  randconfig-002-20260508    gcc-14
i386                  randconfig-003-20260508    clang-20
i386                  randconfig-004-20260508    gcc-14
i386                  randconfig-005-20260508    gcc-12
i386                  randconfig-006-20260508    gcc-14
i386                  randconfig-007-20260508    clang-20
i386                  randconfig-011-20260508    clang-20
i386                  randconfig-012-20260508    gcc-13
i386                  randconfig-013-20260508    clang-20
i386                  randconfig-014-20260508    gcc-14
i386                  randconfig-015-20260508    clang-20
i386                  randconfig-016-20260508    clang-20
i386                  randconfig-017-20260508    gcc-13
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260507    clang-23
loongarch             randconfig-002-20260507    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260507    gcc-9.5.0
nios2                 randconfig-002-20260507    gcc-10.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260507    gcc-8.5.0
parisc                randconfig-002-20260507    gcc-11.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260507    clang-16
powerpc               randconfig-002-20260507    clang-23
powerpc64             randconfig-001-20260507    clang-23
powerpc64             randconfig-002-20260507    gcc-15.2.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260507    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260507    gcc-13.4.0
s390                  randconfig-002-20260507    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                 kfr2r09-romimage_defconfig    gcc-15.2.0
sh                    randconfig-001-20260507    gcc-10.5.0
sh                    randconfig-002-20260507    gcc-15.2.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260507    gcc-8.5.0
sparc                 randconfig-002-20260507    gcc-12.5.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260507    clang-23
sparc64               randconfig-002-20260507    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260507    gcc-13
um                    randconfig-002-20260507    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260507    clang-20
x86_64      buildonly-randconfig-001-20260508    gcc-14
x86_64      buildonly-randconfig-002-20260507    clang-20
x86_64      buildonly-randconfig-002-20260507    gcc-13
x86_64      buildonly-randconfig-002-20260508    clang-20
x86_64      buildonly-randconfig-003-20260507    clang-20
x86_64      buildonly-randconfig-003-20260507    gcc-14
x86_64      buildonly-randconfig-003-20260508    gcc-14
x86_64      buildonly-randconfig-004-20260507    clang-20
x86_64      buildonly-randconfig-004-20260508    clang-20
x86_64      buildonly-randconfig-005-20260507    clang-20
x86_64      buildonly-randconfig-005-20260508    gcc-14
x86_64      buildonly-randconfig-006-20260507    clang-20
x86_64      buildonly-randconfig-006-20260507    gcc-14
x86_64      buildonly-randconfig-006-20260508    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260507    gcc-14
x86_64                randconfig-002-20260507    clang-20
x86_64                randconfig-003-20260507    gcc-14
x86_64                randconfig-004-20260507    gcc-14
x86_64                randconfig-005-20260507    clang-20
x86_64                randconfig-006-20260507    clang-20
x86_64                randconfig-072-20260508    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260507    gcc-15.2.0
xtensa                randconfig-002-20260507    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
