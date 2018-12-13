From: kbuild test robot <lkp@intel.com>
Subject: [dm:block-dm-4.21-inflight 4/9]
 include/linux/percpu-defs.h:219:52: error: invalid operands to binary +
 (have 'struct disk_stats' and 'int')
Date: Thu, 13 Dec 2018 08:44:12 +0800
Message-ID: <201812130808.IbSg5wxo%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, kbuild-all@01.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git block-dm-4.21-inflight
head:   847fb34c0a7f7bbfca9d6053316aafb864a550b2
commit: 525770fecc9110905dfc5e6b447155b08d865936 [4/9] block: switch to per-cpu in-flight counters
config: arm-at91_dt_defconfig (attached as .config)
compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 525770fecc9110905dfc5e6b447155b08d865936
        # save the attached .config to linux build tree
        GCC_VERSION=7.2.0 make.cross ARCH=arm 

All errors (new ones prefixed by >>):

   In file included from ./arch/arm/include/generated/asm/local.h:1:0,
                    from include/linux/genhd.h:20,
                    from block/genhd.c:7:
   block/genhd.c: In function 'part_inc_in_flight':
>> include/linux/percpu-defs.h:219:52: error: invalid operands to binary + (have 'struct disk_stats' and 'int')
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                 ~~~~~ ^
   include/asm-generic/local.h:31:40: note: in definition of macro 'local_inc'
    #define local_inc(l) atomic_long_inc(&(l)->a)
                                           ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     __verify_pcpu_ptr(__p);      \
     ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:53:13: note: in expansion of macro 'per_cpu_ptr'
     local_inc(&per_cpu_ptr(part->dkstats, cpu)->in_flight[rw]);
                ^~~~~~~~~~~
>> include/linux/percpu-defs.h:260:10: error: invalid type argument of unary '*' (have 'struct disk_stats')
     (typeof(*(__p)) __kernel __force *)(__p);   \
             ^~~~~~
   include/asm-generic/local.h:31:40: note: in definition of macro 'local_inc'
    #define local_inc(l) atomic_long_inc(&(l)->a)
                                           ^
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:53:13: note: in expansion of macro 'per_cpu_ptr'
     local_inc(&per_cpu_ptr(part->dkstats, cpu)->in_flight[rw]);
                ^~~~~~~~~~~
>> include/linux/percpu-defs.h:219:52: error: invalid operands to binary + (have 'struct disk_stats' and 'int')
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                 ~~~~~ ^
   include/asm-generic/local.h:31:40: note: in definition of macro 'local_inc'
    #define local_inc(l) atomic_long_inc(&(l)->a)
                                           ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     __verify_pcpu_ptr(__p);      \
     ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:55:14: note: in expansion of macro 'per_cpu_ptr'
      local_inc(&per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight[rw]);
                 ^~~~~~~~~~~
>> include/linux/percpu-defs.h:260:10: error: invalid type argument of unary '*' (have 'struct disk_stats')
     (typeof(*(__p)) __kernel __force *)(__p);   \
             ^~~~~~
   include/asm-generic/local.h:31:40: note: in definition of macro 'local_inc'
    #define local_inc(l) atomic_long_inc(&(l)->a)
                                           ^
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:55:14: note: in expansion of macro 'per_cpu_ptr'
      local_inc(&per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight[rw]);
                 ^~~~~~~~~~~
   block/genhd.c: In function 'part_dec_in_flight':
>> include/linux/percpu-defs.h:219:52: error: invalid operands to binary + (have 'struct disk_stats' and 'int')
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                 ~~~~~ ^
   include/asm-generic/local.h:32:40: note: in definition of macro 'local_dec'
    #define local_dec(l) atomic_long_dec(&(l)->a)
                                           ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     __verify_pcpu_ptr(__p);      \
     ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:63:13: note: in expansion of macro 'per_cpu_ptr'
     local_dec(&per_cpu_ptr(part->dkstats, cpu)->in_flight[rw]);
                ^~~~~~~~~~~
>> include/linux/percpu-defs.h:260:10: error: invalid type argument of unary '*' (have 'struct disk_stats')
     (typeof(*(__p)) __kernel __force *)(__p);   \
             ^~~~~~
   include/asm-generic/local.h:32:40: note: in definition of macro 'local_dec'
    #define local_dec(l) atomic_long_dec(&(l)->a)
                                           ^
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:63:13: note: in expansion of macro 'per_cpu_ptr'
     local_dec(&per_cpu_ptr(part->dkstats, cpu)->in_flight[rw]);
                ^~~~~~~~~~~
>> include/linux/percpu-defs.h:219:52: error: invalid operands to binary + (have 'struct disk_stats' and 'int')
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                 ~~~~~ ^
   include/asm-generic/local.h:32:40: note: in definition of macro 'local_dec'
    #define local_dec(l) atomic_long_dec(&(l)->a)
                                           ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     __verify_pcpu_ptr(__p);      \
     ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:65:14: note: in expansion of macro 'per_cpu_ptr'
      local_dec(&per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight[rw]);
                 ^~~~~~~~~~~
>> include/linux/percpu-defs.h:260:10: error: invalid type argument of unary '*' (have 'struct disk_stats')
     (typeof(*(__p)) __kernel __force *)(__p);   \
             ^~~~~~
   include/asm-generic/local.h:32:40: note: in definition of macro 'local_dec'
    #define local_dec(l) atomic_long_dec(&(l)->a)
                                           ^
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:65:14: note: in expansion of macro 'per_cpu_ptr'
      local_dec(&per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight[rw]);
                 ^~~~~~~~~~~
   block/genhd.c: In function 'part_in_flight':
>> include/linux/percpu-defs.h:219:52: error: invalid operands to binary + (have 'struct disk_stats' and 'int')
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                 ~~~~~ ^
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     __verify_pcpu_ptr(__p);      \
     ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:80:30: note: in expansion of macro 'per_cpu_ptr'
      inflight[0] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) +
                                 ^~~~~~~~~~~
>> include/linux/percpu-defs.h:260:10: error: invalid type argument of unary '*' (have 'struct disk_stats')
     (typeof(*(__p)) __kernel __force *)(__p);   \
             ^~~~~~
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:80:30: note: in expansion of macro 'per_cpu_ptr'
      inflight[0] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) +
                                 ^~~~~~~~~~~
>> include/linux/percpu-defs.h:219:52: error: invalid operands to binary + (have 'struct disk_stats' and 'int')
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                 ~~~~~ ^
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     __verify_pcpu_ptr(__p);      \
     ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:81:17: note: in expansion of macro 'per_cpu_ptr'
        local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
                    ^~~~~~~~~~~
>> include/linux/percpu-defs.h:260:10: error: invalid type argument of unary '*' (have 'struct disk_stats')
     (typeof(*(__p)) __kernel __force *)(__p);   \
             ^~~~~~
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:81:17: note: in expansion of macro 'per_cpu_ptr'
        local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
                    ^~~~~~~~~~~
>> include/linux/percpu-defs.h:219:52: error: invalid operands to binary + (have 'struct disk_stats' and 'int')
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                 ~~~~~ ^
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     __verify_pcpu_ptr(__p);      \
     ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:90:31: note: in expansion of macro 'per_cpu_ptr'
       inflight[1] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) +
                                  ^~~~~~~~~~~
>> include/linux/percpu-defs.h:260:10: error: invalid type argument of unary '*' (have 'struct disk_stats')
     (typeof(*(__p)) __kernel __force *)(__p);   \
             ^~~~~~
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:90:31: note: in expansion of macro 'per_cpu_ptr'
       inflight[1] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) +
                                  ^~~~~~~~~~~
>> include/linux/percpu-defs.h:219:52: error: invalid operands to binary + (have 'struct disk_stats' and 'int')
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                 ~~~~~ ^
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     __verify_pcpu_ptr(__p);      \
     ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:91:18: note: in expansion of macro 'per_cpu_ptr'
         local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
                     ^~~~~~~~~~~
>> include/linux/percpu-defs.h:260:10: error: invalid type argument of unary '*' (have 'struct disk_stats')
     (typeof(*(__p)) __kernel __force *)(__p);   \
             ^~~~~~
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:91:18: note: in expansion of macro 'per_cpu_ptr'
         local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
                     ^~~~~~~~~~~
   block/genhd.c: In function 'part_in_flight_rw':
>> include/linux/percpu-defs.h:219:52: error: invalid operands to binary + (have 'struct disk_stats' and 'int')
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                 ~~~~~ ^
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     __verify_pcpu_ptr(__p);      \
     ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:111:30: note: in expansion of macro 'per_cpu_ptr'
      inflight[0] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]);
                                 ^~~~~~~~~~~
>> include/linux/percpu-defs.h:260:10: error: invalid type argument of unary '*' (have 'struct disk_stats')
     (typeof(*(__p)) __kernel __force *)(__p);   \
             ^~~~~~
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:111:30: note: in expansion of macro 'per_cpu_ptr'
      inflight[0] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]);
                                 ^~~~~~~~~~~
>> include/linux/percpu-defs.h:219:52: error: invalid operands to binary + (have 'struct disk_stats' and 'int')
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                 ~~~~~ ^
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:259:2: note: in expansion of macro '__verify_pcpu_ptr'
     __verify_pcpu_ptr(__p);      \
     ^~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:112:30: note: in expansion of macro 'per_cpu_ptr'
      inflight[1] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
                                 ^~~~~~~~~~~
>> include/linux/percpu-defs.h:260:10: error: invalid type argument of unary '*' (have 'struct disk_stats')
     (typeof(*(__p)) __kernel __force *)(__p);   \
             ^~~~~~
   include/asm-generic/local.h:29:42: note: in definition of macro 'local_read'
    #define local_read(l) atomic_long_read(&(l)->a)
                                             ^
   include/linux/percpu-defs.h:263:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
   block/genhd.c:112:30: note: in expansion of macro 'per_cpu_ptr'
      inflight[1] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
                                 ^~~~~~~~~~~

vim +219 include/linux/percpu-defs.h

62fde54123 Tejun Heo 2014-06-17  205  
9c28278a24 Tejun Heo 2014-06-17  206  /*
6fbc07bbe2 Tejun Heo 2014-06-17  207   * __verify_pcpu_ptr() verifies @ptr is a percpu pointer without evaluating
6fbc07bbe2 Tejun Heo 2014-06-17  208   * @ptr and is invoked once before a percpu area is accessed by all
6fbc07bbe2 Tejun Heo 2014-06-17  209   * accessors and operations.  This is performed in the generic part of
6fbc07bbe2 Tejun Heo 2014-06-17  210   * percpu and arch overrides don't need to worry about it; however, if an
6fbc07bbe2 Tejun Heo 2014-06-17  211   * arch wants to implement an arch-specific percpu accessor or operation,
6fbc07bbe2 Tejun Heo 2014-06-17  212   * it may use __verify_pcpu_ptr() to verify the parameters.
9c28278a24 Tejun Heo 2014-06-17  213   *
9c28278a24 Tejun Heo 2014-06-17  214   * + 0 is required in order to convert the pointer type from a
9c28278a24 Tejun Heo 2014-06-17  215   * potential array type to a pointer to a single item of the array.
9c28278a24 Tejun Heo 2014-06-17  216   */
eba117889a Tejun Heo 2014-06-17  217  #define __verify_pcpu_ptr(ptr)						\
eba117889a Tejun Heo 2014-06-17  218  do {									\
9c28278a24 Tejun Heo 2014-06-17 @219  	const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;	\
9c28278a24 Tejun Heo 2014-06-17  220  	(void)__vpp_verify;						\
9c28278a24 Tejun Heo 2014-06-17  221  } while (0)
9c28278a24 Tejun Heo 2014-06-17  222  
62fde54123 Tejun Heo 2014-06-17  223  #ifdef CONFIG_SMP
62fde54123 Tejun Heo 2014-06-17  224  
62fde54123 Tejun Heo 2014-06-17  225  /*
62fde54123 Tejun Heo 2014-06-17  226   * Add an offset to a pointer but keep the pointer as-is.  Use RELOC_HIDE()
62fde54123 Tejun Heo 2014-06-17  227   * to prevent the compiler from making incorrect assumptions about the
62fde54123 Tejun Heo 2014-06-17  228   * pointer value.  The weird cast keeps both GCC and sparse happy.
62fde54123 Tejun Heo 2014-06-17  229   */
eba117889a Tejun Heo 2014-06-17  230  #define SHIFT_PERCPU_PTR(__p, __offset)					\
6fbc07bbe2 Tejun Heo 2014-06-17  231  	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
6fbc07bbe2 Tejun Heo 2014-06-17  232  
6fbc07bbe2 Tejun Heo 2014-06-17  233  #define per_cpu_ptr(ptr, cpu)						\
eba117889a Tejun Heo 2014-06-17  234  ({									\
6fbc07bbe2 Tejun Heo 2014-06-17  235  	__verify_pcpu_ptr(ptr);						\
6fbc07bbe2 Tejun Heo 2014-06-17  236  	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)));			\
62fde54123 Tejun Heo 2014-06-17  237  })
62fde54123 Tejun Heo 2014-06-17  238  
6fbc07bbe2 Tejun Heo 2014-06-17  239  #define raw_cpu_ptr(ptr)						\
6fbc07bbe2 Tejun Heo 2014-06-17  240  ({									\
6fbc07bbe2 Tejun Heo 2014-06-17  241  	__verify_pcpu_ptr(ptr);						\
6fbc07bbe2 Tejun Heo 2014-06-17  242  	arch_raw_cpu_ptr(ptr);						\
6fbc07bbe2 Tejun Heo 2014-06-17  243  })
62fde54123 Tejun Heo 2014-06-17  244  
62fde54123 Tejun Heo 2014-06-17  245  #ifdef CONFIG_DEBUG_PREEMPT
6fbc07bbe2 Tejun Heo 2014-06-17  246  #define this_cpu_ptr(ptr)						\
6fbc07bbe2 Tejun Heo 2014-06-17  247  ({									\
6fbc07bbe2 Tejun Heo 2014-06-17  248  	__verify_pcpu_ptr(ptr);						\
6fbc07bbe2 Tejun Heo 2014-06-17  249  	SHIFT_PERCPU_PTR(ptr, my_cpu_offset);				\
6fbc07bbe2 Tejun Heo 2014-06-17  250  })
62fde54123 Tejun Heo 2014-06-17  251  #else
62fde54123 Tejun Heo 2014-06-17  252  #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
62fde54123 Tejun Heo 2014-06-17  253  #endif
62fde54123 Tejun Heo 2014-06-17  254  
62fde54123 Tejun Heo 2014-06-17  255  #else	/* CONFIG_SMP */
62fde54123 Tejun Heo 2014-06-17  256  
eba117889a Tejun Heo 2014-06-17  257  #define VERIFY_PERCPU_PTR(__p)						\
eba117889a Tejun Heo 2014-06-17  258  ({									\
eba117889a Tejun Heo 2014-06-17 @259  	__verify_pcpu_ptr(__p);						\
62fde54123 Tejun Heo 2014-06-17 @260  	(typeof(*(__p)) __kernel __force *)(__p);			\
62fde54123 Tejun Heo 2014-06-17  261  })
62fde54123 Tejun Heo 2014-06-17  262  

:::::: The code at line 219 was first introduced by commit
:::::: 9c28278a24c01c0073fb89e53c1d2a605ab9587d percpu: reorder macros in percpu header files

:::::: TO: Tejun Heo <tj@kernel.org>
:::::: CC: Tejun Heo <tj@kernel.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--EeQfGwPcQSOJBaQU
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--EeQfGwPcQSOJBaQU--
