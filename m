Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755804;
	b=EftPWljhx6+ESXX3iYhkfsrEtZ5PQUkZjm/Zuuvhr64JuBGF8MczxvN9hLgRCxx6LpXf
	 mbPGuLHlnbeX+btl/4YkAVxPdK0/X3R6gU2Dvtq+azcnf5Adexf6T8YKe99nppqvtfCnz
	 rzsW4HfSf8Bm75TnM04h7QnPEwl05VZhkPjletn61R+0vQKFDSPPy5qWbo2P5/zx+eOwv
	 Um4FJg6afHZSDlKsdaMiZ/F+0i7Y/CNvxTtrdsV+z4uH3et8LFTrHGYt/8+45yTYXaRVV
	 MFK/8JCCLAMrZeQgGruZ/pZQnKTDChXc95KW07sYo/YDAP5h1cJSBHWS+WNpP6MAh2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755804;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition;
	bh=yEu6yyL0+xI2Dfe025H+amgRJZrDJT8P4ol1ESga1/w=;
	b=0+ryXPhg8dV5yz4o/IpJIWbaU2bMxNfsZJ/JUY0/NsIH3OSJYiuSLJIK7A4y7Ac6wwTe
	 2Ch7+xN2whvqP69ucr7U7TpsCsHspk21YLlpGrxMtI+fdY0p4B1Ecqa4w/KjyWC5KVpWp
	 W02/7a1tqLybLDKJhQeJJ/PcgMGQygMOP9ZHE9YgL1nY5/clCbhaB1kKZZwOJAY9yUzzo
	 romOFEs0YIPTuu7/84KNPH1FUykz1BmebDVofj8cbYoF4FZEGagGCGiPtcyfGPOlPa5BO
	 M2NlydLgkAdJdid0E1J8Yb1uNoEAlSR0prTXJCZH5ouZDCbmMavPk1hDy8CXA2oD4WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hSzOd2n3;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6994606A326;
	Wed,  4 Nov 2026 01:30:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6994606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hSzOd2n3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793755802; x=1825291802;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=syy6QjJl2jFKpWBfFodPKYB/m/8Hval3+l8xNhB4PjM=;
  b=hSzOd2n3FsB8lMCs6o6wA6txzr4s4hvcRoqi8ytwwDK9zdFOct0Htf0f
   gpNDtG+2Z4edJ79MY0iXIm6ENT2LOMWSzK5xglqcs7I0y7xh5GAgNgxta
   9VWefhdIsU/naUMXj4KsacO2N+ucyA45cjtp4PBJILDG5wBg8zXviZwAT
   Sv4JAJNQHHXO96D1onnGwyZ/Q3CwSe2GJ4mBlPJqotcKe76wk08opiFyq
   X/cd4Yz8yYdlzHLoMMPaWYP6kAmEcNG5CU2woEyE1hJm6KHdsTTd1Jixb
   h9yautDTYFDc66T84FZNWBKpOVebisN/8Vw8YLydeEioZ8CBb7Ky58yjj
   A==;
X-CSE-ConnectionGUID: 6cVPODEoRS6S9e5NnQkJCA==
X-CSE-MsgGUID: 0H2h19u3SF6g/wU1IZRNZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2592904"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2592904"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 17:30:02 -0800
X-CSE-ConnectionGUID: i+t+TH98QdO/q+1wNBAJuQ==
X-CSE-MsgGUID: ook4j2l8TWmULubw0mdFAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="6596283"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 17:29:58 -0800
Date: Wed, 4 Nov 2026 09:29:54 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-um@lists.infradead.org, linux-perf-users@vger.kernel.org,
	kvm@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	dm-devel@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	linux-pm@vger.kernel.org, yi1.lai@intel.com
Subject: [linus:master] [x86/cpu]  3eaa50e1e2:
 WARNING:at_arch/x86/mm/tlb.c:#switch_mm_irqs_off
Message-ID: <202611040239.b33be21c-lkp@intel.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Hello,

kernel test robot noticed "WARNING:at_arch/x86/mm/tlb.c:#switch_mm_irqs_off" on:

commit: 3eaa50e1e255ec261c757b9eea811ef3bac10d1e ("x86/cpu: Hide and rename static_cpu_has()") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linux-next/master 7649ba73f9e7e1e04d0b46213e39c79ae09dd55c]

in testcase: trinity
version: 
with following parameters:

	runtime: 300s
	group: group-03
	nr_groups: 5


config: i386-randconfig-2302-20261020
compiler: clang-22
test machine: qemu-system-i386 -enable-kvm -cpu Icelake-Server-noTSX,enforce,lm=off -smp 4 -m 4G

(please refer to attached dmesg/kmsg for entire log/backtrace)

If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202611040239.b33be21c-lkp@intel.com


[    6.581068][    T0] ======================================================
[    6.581069][    T0] WARNING: possible circular locking dependency detected
[    6.581070][    T0] 7.2.0-rc2-00001-g3eaa50e1e255 #1 Not tainted
[    6.581072][    T0] ------------------------------------------------------
[    6.581073][    T0] swapper/1/0 is trying to acquire lock:
[    6.581074][    T0] c31a3080 (console_owner){..-.}-{0:0}, at: console_lock_spinning_enable+0x2b/0x80
[    6.581086][    T0]
[    6.581086][    T0] but task is already holding lock:
[    6.581086][    T0]
[    6.581086][    T0] but task is already holding lock:
[    6.581086][    T0]
[    6.581086][    T0] but task is already holding lock:
[    6.581087][    T0] e85ad118 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0x1b4/0x940
[    6.581676][    T0]
[    6.581676][    T0] which lock already depends on the new lock.
[    6.581676][    T0]
[    6.581676][    T0] which lock already depends on the new lock.
[    6.581676][    T0]
[    6.581676][    T0] which lock already depends on the new lock.
[    6.581676][    T0]
[    6.581677][    T0]
[    6.581677][    T0] the existing dependency chain (in reverse order) is:
[    6.581677][    T0]
[    6.581677][    T0] the existing dependency chain (in reverse order) is:
[    6.581677][    T0]
[    6.581677][    T0] the existing dependency chain (in reverse order) is:
[    6.581678][    T0]
[    6.581678][    T0] -> #4 (&rq->__lock){-.-.}-{2:2}:
[    6.581678][    T0]
[    6.581678][    T0] -> #4 (&rq->__lock){-.-.}-{2:2}:
[    6.581678][    T0]
[    6.581678][    T0] -> #4 (&rq->__lock){-.-.}-{2:2}:
[    6.581683][    T0]        _raw_spin_lock_nested+0x20/0x40
[    6.581686][    T0]        ___task_rq_lock+0x55/0x100
[    6.581691][    T0]        wake_up_new_task+0xd5/0x2c0
[    6.581693][    T0]        kernel_clone+0x1f4/0x3c0
[    6.581696][    T0]        user_mode_thread+0x61/0x80
[    6.581698][    T0]        rest_init+0x1a/0x1c0
[    6.581700][    T0]        start_kernel+0x337/0x3c0
[    6.581706][    T0]        i386_start_kernel+0xc6/0x100
[    6.581708][    T0]        startup_32_smp+0x151/0x154
[    6.581710][    T0]
[    6.581710][    T0] -> #3 (&p->pi_lock){-.-.}-{2:2}:
[    6.581710][    T0]
[    6.581710][    T0] -> #3 (&p->pi_lock){-.-.}-{2:2}:
[    6.581710][    T0]
[    6.581710][    T0] -> #3 (&p->pi_lock){-.-.}-{2:2}:
[    6.581713][    T0]        _raw_spin_lock_irqsave+0x33/0x80
[    6.581715][    T0]        try_to_wake_up+0x3b/0x440
[    6.581717][    T0]        default_wake_function+0x13/0x40
[    6.581719][    T0]        autoremove_wake_function+0x10/0x40
[    6.581723][    T0]        __wake_up_common_lock+0x6e/0xc0
[    6.581726][    T0]        __wake_up+0x13/0x40
[    6.581729][    T0]        tty_wakeup+0x50/0x80
[    6.581732][    T0]        tty_port_default_wakeup+0x52/0x80
[    6.581734][    T0]        tty_port_tty_wakeup+0x11/0x40
[    6.581737][    T0]        uart_write_wakeup+0x12/0x40
[    6.581739][    T0]        serial8250_tx_chars+0x184/0x1c0
[    6.581741][    T0]        serial8250_handle_irq_locked+0x1bd/0x200
[    6.581744][    T0]        serial8250_handle_irq+0x57/0x100
[    6.581746][    T0]        serial8250_default_handle_irq+0x1c/0x40
[    6.581748][    T0]        serial8250_interrupt+0x41/0xc0
[    6.581750][    T0]        __handle_irq_event_percpu+0xac/0x3c0
[    6.581752][    T0]        handle_irq_event+0x26/0x80
[    6.581754][    T0]        handle_edge_irq+0x77/0x140
[    6.581757][    T0]        __handle_irq+0x67/0x80
[    6.581761][    T0]        __common_interrupt+0x74/0xc0
[    6.581763][    T0]        common_interrupt+0x24/0x40
[    6.581765][    T0]        asm_common_interrupt+0x137/0x140
[    6.581768][    T0]        pv_native_safe_halt+0xe/0x40
[    6.581769][    T0]        default_idle+0x8/0x40
[    6.581771][    T0]        arch_cpu_idle+0x8/0x40
[    6.581773][    T0]        default_idle_call+0x6c/0xc0
[    6.581775][    T0]        do_idle+0xbc/0x240
[    6.581779][    T0]        cpu_startup_entry+0x25/0x40
[    6.581781][    T0]        start_secondary+0x9f/0xc0
[    6.581785][    T0]        startup_32_smp+0x151/0x154
[    6.581787][    T0]
[    6.581787][    T0] -> #2 (&tty->write_wait){-...}-{3:3}:
[    6.581787][    T0]
[    6.581787][    T0] -> #2 (&tty->write_wait){-...}-{3:3}:
[    6.581787][    T0]
[    6.581787][    T0] -> #2 (&tty->write_wait){-...}-{3:3}:
[    6.581790][    T0]        _raw_spin_lock_irqsave+0x33/0x80
[    6.581791][    T0]        __wake_up_common_lock+0x15/0xc0
[    6.581794][    T0]        __wake_up+0x13/0x40
[    6.581796][    T0]        tty_wakeup+0x50/0x80
[    6.581798][    T0]        tty_port_default_wakeup+0x52/0x80
[    6.581801][    T0]        tty_port_tty_wakeup+0x11/0x40
[    6.581802][    T0]        uart_write_wakeup+0x12/0x40
[    6.581805][    T0]        serial8250_tx_chars+0x184/0x1c0
[    6.581807][    T0]        serial8250_handle_irq_locked+0x1bd/0x200
[    6.581809][    T0]        serial8250_handle_irq+0x57/0x100
[    6.581811][    T0]        serial8250_default_handle_irq+0x1c/0x40
[    6.581813][    T0]        serial8250_interrupt+0x41/0xc0
[    6.581815][    T0]        __handle_irq_event_percpu+0xac/0x3c0
[    6.581817][    T0]        handle_irq_event+0x26/0x80
[    6.581818][    T0]        handle_edge_irq+0x77/0x140
[    6.581820][    T0]        __handle_irq+0x67/0x80
[    6.581822][    T0]        __common_interrupt+0x74/0xc0
[    6.581825][    T0]        common_interrupt+0x24/0x40
[    6.581827][    T0]        asm_common_interrupt+0x137/0x140
[    6.581829][    T0]        pv_native_safe_halt+0xe/0x40
[    6.581830][    T0]        default_idle+0x8/0x40
[    6.581832][    T0]        arch_cpu_idle+0x8/0x40
[    6.581834][    T0]        default_idle_call+0x6c/0xc0
[    6.581835][    T0]        do_idle+0xbc/0x240
[    6.581838][    T0]        cpu_startup_entry+0x25/0x40
[    6.581840][    T0]        start_secondary+0x9f/0xc0
[    6.581842][    T0]        startup_32_smp+0x151/0x154
[    6.581844][    T0]
[    6.581844][    T0] -> #1 (&port_lock_key){-.-.}-{3:3}:
[    6.581844][    T0]
[    6.581844][    T0] -> #1 (&port_lock_key){-.-.}-{3:3}:
[    6.581844][    T0]
[    6.581844][    T0] -> #1 (&port_lock_key){-.-.}-{3:3}:
[    6.581847][    T0]        _raw_spin_lock_irqsave+0x33/0x80
[    6.581848][    T0]        serial8250_console_write+0x57/0x640
[    6.581851][    T0]        univ8250_console_write+0x20/0x40
[    6.581853][    T0]        console_flush_all+0x26f/0x480
[    6.581856][    T0]        console_unlock+0x65/0x100
[    6.581858][    T0]        vprintk_emit+0x183/0x2c0
[    6.581860][    T0]        vprintk_default+0x10/0x40
[    6.581862][    T0]        vprintk+0xe/0x40
[    6.581864][    T0]        _printk+0x20/0x40
[    6.581866][    T0]        register_console+0x340/0x3c0
[    6.581868][    T0]        univ8250_console_init+0x1b/0x40
[    6.581871][    T0]        console_init+0x7b/0x280
[    6.581874][    T0]        start_kernel+0x229/0x3c0
[    6.581877][    T0]        i386_start_kernel+0xc6/0x100
[    6.581879][    T0]        startup_32_smp+0x151/0x154
[    6.581880][    T0]
[    6.581880][    T0] -> #0 (console_owner){..-.}-{0:0}:
[    6.581880][    T0]
[    6.581880][    T0] -> #0 (console_owner){..-.}-{0:0}:
[    6.581880][    T0]
[    6.581880][    T0] -> #0 (console_owner){..-.}-{0:0}:
[    6.581883][    T0]        __lock_acquire+0x16ac/0x2a80
[    6.581886][    T0]        lock_acquire+0xa0/0x240
[    6.581888][    T0]        console_lock_spinning_enable+0x44/0x80
[    6.581890][    T0]        console_flush_all+0x253/0x480
[    6.581893][    T0]        console_unlock+0x65/0x100
[    6.581894][    T0]        vprintk_emit+0x183/0x2c0
[    6.581896][    T0]        vprintk_default+0x10/0x40
[    6.581898][    T0]        vprintk+0xe/0x40
[    6.581900][    T0]        _printk+0x20/0x40
[    6.581902][    T0]        __report_bug+0xa8/0x140
[    6.581904][    T0]        report_bug+0x61/0x80
[    6.581906][    T0]        handle_bug+0x92/0x240
[    6.581908][    T0]        exc_invalid_op+0x24/0x80
[    6.581911][    T0]        handle_exception_return+0x0/0xcb
[    6.581913][    T0]        switch_mm_irqs_off+0x3bd/0x440
[    6.581916][    T0]        __schedule+0x539/0x940
[    6.581918][    T0]        schedule_idle+0x2a/0x40
[    6.581920][    T0]        do_idle+0x1cf/0x240
[    6.581923][    T0]        cpu_startup_entry+0x25/0x40
[    6.581925][    T0]        start_secondary+0x9f/0xc0
[    6.581927][    T0]        startup_32_smp+0x151/0x154
[    6.581929][    T0]
[    6.581929][    T0] other info that might help us debug this:
[    6.581929][    T0]
[    6.581929][    T0] other info that might help us debug this:
[    6.581929][    T0]
[    6.581929][    T0] other info that might help us debug this:
[    6.581929][    T0]
[    6.581930][    T0] Chain exists of:
[    6.581930][    T0]   console_owner --> &p->pi_lock --> &rq->__lock
[    6.581930][    T0]
[    6.581930][    T0] Chain exists of:
[    6.581930][    T0]   console_owner --> &p->pi_lock --> &rq->__lock
[    6.581930][    T0]
[    6.581930][    T0] Chain exists of:
[    6.581930][    T0]   console_owner --> &p->pi_lock --> &rq->__lock
[    6.581930][    T0]
[    6.581933][    T0]  Possible unsafe locking scenario:
[    6.581933][    T0]
[    6.581933][    T0]  Possible unsafe locking scenario:
[    6.581933][    T0]
[    6.581933][    T0]  Possible unsafe locking scenario:
[    6.581933][    T0]
[    6.581934][    T0]        CPU0                    CPU1
[    6.581935][    T0]        ----                    ----
[    6.581935][    T0]   lock(&rq->__lock);
[    6.581937][    T0]                                lock(&p->pi_lock);
[    6.581939][    T0]                                lock(&rq->__lock);
[    6.581940][    T0]   lock(console_owner);
[    6.581941][    T0]
[    6.581941][    T0]  *** DEADLOCK ***
[    6.581941][    T0]
[    6.581941][    T0]  *** DEADLOCK ***
[    6.581941][    T0]
[    6.581941][    T0]  *** DEADLOCK ***
[    6.581941][    T0]
[    6.581942][    T0] 3 locks held by swapper/1/0:
[    6.581944][    T0]  #0: e85ad118 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0x1b4/0x940
[    6.581949][    T0]  #1: c31a3094 (console_lock){+.+.}-{0:0}, at: vprintk_emit+0x17a/0x2c0
[    6.581954][    T0]  #2: c2e82dc4 (console_srcu){....}-{0:0}, at: rcu_try_lock_acquire+0x0/0x40
[    6.581959][    T0]
[    6.581959][    T0] stack backtrace:
[    6.581959][    T0]
[    6.581959][    T0] stack backtrace:
[    6.581959][    T0]
[    6.581959][    T0] stack backtrace:
[    6.581962][    T0] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted 7.2.0-rc2-00001-g3eaa50e1e255 #1 PREEMPT(lazy)
[    6.581965][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    6.581967][    T0] Call Trace:
[    6.581969][    T0]  __dump_stack+0x18/0x40
[    6.581973][    T0]  dump_stack_lvl+0x65/0xc0
[    6.581976][    T0]  dump_stack+0xd/0x12
[    6.581979][    T0]  print_circular_bug+0x2bf/0x300
[    6.581982][    T0]  check_noncircular+0x106/0x140
[    6.581986][    T0]  __lock_acquire+0x16ac/0x2a80
[    6.581994][    T0]  lock_acquire+0xa0/0x240
[    6.581997][    T0]  ? console_lock_spinning_enable+0x2b/0x80
[    6.582000][    T0]  ? console_lock_spinning_enable+0x2b/0x80
[    6.582003][    T0]  console_lock_spinning_enable+0x44/0x80
[    6.582006][    T0]  ? console_lock_spinning_enable+0x2b/0x80
[    6.582008][    T0]  console_flush_all+0x253/0x480
[    6.582012][    T0]  console_unlock+0x65/0x100
[    6.582016][    T0]  vprintk_emit+0x183/0x2c0
[    6.582019][    T0]  vprintk_default+0x10/0x40
[    6.582022][    T0]  vprintk+0xe/0x40
[    6.582025][    T0]  _printk+0x20/0x40
[    6.582027][    T0]  __report_bug+0xa8/0x140
[    6.582030][    T0]  ? switch_mm_irqs_off+0x3bd/0x440
[    6.582033][    T0]  ? switch_mm_irqs_off+0x3bf/0x440
[    6.582036][    T0]  report_bug+0x61/0x80
[    6.582038][    T0]  handle_bug+0x92/0x240
[    6.582041][    T0]  ? switch_mm_irqs_off+0x3bd/0x440
[    6.582043][    T0]  ? handle_bug+0x240/0x240
[    6.582046][    T0]  exc_invalid_op+0x24/0x80
[    6.582049][    T0]  handle_exception+0x168/0x168
[    6.582052][    T0] EIP: switch_mm_irqs_off+0x3bd/0x440
[    6.582054][    T0] Code: 89 55 e4 e8 25 3f 40 01 8b 55 e4 8b 45 f0 f7 45 e8 00 02 00 00 0f 85 31 fe ff ff e9 2d fe ff ff 0f 0b e9 b3 fd ff ff 8b 75 ec <0f> 0b 83 7d f0 08 73 13 8b 45 f0 f0 0f ab 86 00 05 00 00 8b 5d e0
[    6.582057][    T0] EAX: 00000001 EBX: e85a0000 ECX: c0ecf380 EDX: c0ecf380
[    6.582059][    T0] ESI: c0ecf380 EDI: 00000000 EBP: c031ff0c ESP: c031fee4
[    6.582061][    T0] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210096
[    6.582064][    T0]  ? handle_bug+0x240/0x240
[    6.582067][    T0]  ? handle_bug+0x240/0x240
[    6.582070][    T0]  ? switch_mm_irqs_off+0x3bd/0x440
[    6.582074][    T0]  __schedule+0x539/0x940
[    6.582079][    T0]  schedule_idle+0x2a/0x40
[    6.582081][    T0]  do_idle+0x1cf/0x240
[    6.582085][    T0]  cpu_startup_entry+0x25/0x40
[    6.582087][    T0]  start_secondary+0x9f/0xc0
[    6.582090][    T0]  startup_32_smp+0x151/0x154
[    6.752586][    T0] WARNING: arch/x86/mm/tlb.c:859 at switch_mm_irqs_off+0x3bd/0x440, CPU#1: swapper/1/0
[    6.754233][    T0] Modules linked in:
[    6.754879][    T0] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted 7.2.0-rc2-00001-g3eaa50e1e255 #1 PREEMPT(lazy)
[    6.756668][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    6.758441][    T0] EIP: switch_mm_irqs_off+0x3bd/0x440
[    6.759346][    T0] Code: 89 55 e4 e8 25 3f 40 01 8b 55 e4 8b 45 f0 f7 45 e8 00 02 00 00 0f 85 31 fe ff ff e9 2d fe ff ff 0f 0b e9 b3 fd ff ff 8b 75 ec <0f> 0b 83 7d f0 08 73 13 8b 45 f0 f0 0f ab 86 00 05 00 00 8b 5d e0
[    6.762672][    T0] EAX: 00000001 EBX: e85a0000 ECX: c0ecf380 EDX: c0ecf380
[    6.763861][    T0] ESI: c0ecf380 EDI: 00000000 EBP: c031ff0c ESP: c031fee4
[    6.765043][    T0] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210096
[    6.766344][    T0] CR0: 80050033 CR2: b7d0600c CR3: 0435b000 CR4: 00350ed0
[    6.767537][    T0] Call Trace:
[    6.768079][    T0]  __schedule+0x539/0x940
[    6.768799][    T0]  schedule_idle+0x2a/0x40
[    6.769557][    T0]  do_idle+0x1cf/0x240
[    6.770231][    T0]  cpu_startup_entry+0x25/0x40
[    6.771029][    T0]  start_secondary+0x9f/0xc0
[    6.771794][    T0]  startup_32_smp+0x151/0x154
[    6.772571][    T0] irq event stamp: 11750
[    6.773297][    T0] hardirqs last  enabled at (11749): [<c248ea58>] default_idle_call+0x98/0xc0
[    6.774773][    T0] hardirqs last disabled at (11750): [<c2492d95>] __schedule+0x155/0x940
[    6.776182][    T0] softirqs last  enabled at (11726): [<c249c90a>] __do_softirq+0xa/0xc
[    6.777581][    T0] softirqs last disabled at (11721): [<c249c90a>] __do_softirq+0xa/0xc
[    6.778962][    T0] ---[ end trace 0000000000000000 ]---


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261104/202611040239.b33be21c-lkp@intel.com



--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

