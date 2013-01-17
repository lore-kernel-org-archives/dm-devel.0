From: lei yang <yanglei.fage@gmail.com>
Subject: what's wrong with my build
Date: Fri, 18 Jan 2013 00:09:08 +0800
Message-ID: <CAHsH0E8sQYYs6jt6NaP8kQ=+jj5uxK8FJpUky=kUAuSmXss=6w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi experts

I try to build multipath-tools, when I do below thing

i586-wrs-linux-gcc  -m32   -march=i586
--sysroot=/home/lyang001/kvm_32/bitbake_build/tmp/sysroots/x86-kvm-guest
-pipe -g -Wall -Wunused -Wstrict-prototypes -fPIC
-DLIB_STRING=\"lib64\" -I../libmultipath -Wl,-O1 -Wl,--hash-style=gnu
-Wl,--as-needed -lpthread -ldevmapper -lreadline -lncurses -ldl
-lmultipath -L../libmultipath -o multipathd main.o pidfile.o uxlsnr.o
uxclnt.o cli.o cli_handlers.o


I see it has use  -L../libmultipath to link related lib, but still
meet below error

/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:251:
undefined reference to `find_mp_by_alias'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:259:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:261:
undefined reference to `xfree'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:268:
undefined reference to `add_map_without_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:270:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:273:
undefined reference to `get_refwwid'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:276:
undefined reference to `coalesce_paths'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:277:
undefined reference to `dm_lib_release'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:281:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:283:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:285:
undefined reference to `xfree'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:286:
undefined reference to `xfree'
main.o: In function `uev_remove_map':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:293:
undefined reference to `dlog'
main.o: In function `ev_remove_map':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:302:
undefined reference to `find_mp_by_str'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:305:
undefined reference to `dlog'
main.o: In function `uev_umount_map':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:319:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:321:
undefined reference to `find_mp_by_str'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:326:
undefined reference to `update_mpp_paths'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:327:
undefined reference to `verify_paths'
main.o: In function `uev_add_path':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:338:
undefined reference to `dlog'
main.o: In function `ev_add_path':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:360:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:364:
undefined reference to `find_path_by_dev'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:367:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:376:
undefined reference to `store_pathinfo'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:378:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:388:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:391:
undefined reference to `filter_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:392:
undefined reference to `find_slot'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:394:
undefined reference to `vector_del_slot'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:395:
undefined reference to `free_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:398:
undefined reference to `find_mp_by_wwid'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:403:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:407:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:410:
undefined reference to `find_slot'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:412:
undefined reference to `vector_del_slot'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:413:
undefined reference to `free_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:417:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:419:
undefined reference to `adopt_paths'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:422:
undefined reference to `verify_paths'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:428:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:430:
undefined reference to `find_slot'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:432:
undefined reference to `vector_del_slot'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:433:
undefined reference to `free_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:437:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:438:
undefined reference to `add_map_with_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:447:
undefined reference to `setup_map'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:448:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:455:
undefined reference to `domap'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:456:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:462:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:464:
undefined reference to `update_mpp_paths'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:470:
undefined reference to `dm_lib_release'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:475:
undefined reference to `setup_multipath'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:481:
undefined reference to `start_waiter_thread'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:484:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:488:
undefined reference to `remove_map'
main.o: In function `uev_remove_path':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:497:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:500:
undefined reference to `sysfs_device_put'
main.o: In function `ev_remove_path':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:512:
undefined reference to `find_path_by_dev'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:516:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:528:
undefined reference to `update_mpp_paths'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:529:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:533:
undefined reference to `find_slot'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:534:
undefined reference to `vector_del_slot'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:547:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:551:
undefined reference to `dm_queue_if_no_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:554:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:565:
undefined reference to `setup_map'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:566:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:575:
undefined reference to `domap'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:576:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:584:
undefined reference to `setup_multipath'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:589:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:595:
undefined reference to `find_slot'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:596:
undefined reference to `vector_del_slot'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:598:
undefined reference to `free_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:603:
undefined reference to `remove_map_and_stop_waiter'
main.o: In function `map_discovery':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:613:
undefined reference to `dm_get_maps'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:617:
undefined reference to `setup_multipath'
main.o: In function `uxsock_trigger':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:633:
undefined reference to `cleanup_lock'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:633:
undefined reference to `__pthread_register_cancel'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:650:
undefined reference to `__pthread_unregister_cancel'
main.o: In function `uev_discard':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:665:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:670:
undefined reference to `dlog'
main.o: In function `uev_trigger':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:688:
undefined reference to `sysfs_device_get'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:718:
undefined reference to `filter_devnode'
main.o: In function `ueventloop':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:739:
undefined reference to `block_signal'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:740:
undefined reference to `block_signal'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:742:
undefined reference to `uevent_listen'
main.o: In function `uxlsnrloop':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:751:
undefined reference to `block_signal'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:752:
undefined reference to `block_signal'
main.o: In function `exit_daemon':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:800:
undefined reference to `dlog'
main.o: In function `fail_path':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:816:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:819:
undefined reference to `dm_fail_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:821:
undefined reference to `update_queue_mode_del_path'
main.o: In function `reinstate_path':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:833:
undefined reference to `dm_reinstate_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:834:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:836:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:838:
undefined reference to `update_queue_mode_add_path'
main.o: In function `enable_group':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:860:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:861:
undefined reference to `dm_enablegroup'
main.o: In function `mpvec_garbage_collector':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:875:
undefined reference to `dm_map_present'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:876:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:877:
undefined reference to `remove_map_and_stop_waiter'
main.o: In function `retry_count_tick':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:911:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:913:
undefined reference to `dm_queue_if_no_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:914:
undefined reference to `dlog'
main.o: In function `check_path':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:937:
undefined reference to `get_state'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:940:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:941:
undefined reference to `pathinfo'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:955:
undefined reference to `checker_message'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:955:
undefined reference to `checker_message'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:955:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:964:
undefined reference to `update_multipath_strings'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1010:
undefined reference to `checker_message'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1010:
undefined reference to `checker_message'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1010:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1021:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1025:
undefined reference to `checker_message'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1025:
undefined reference to `checker_message'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1025:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1032:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1033:
undefined reference to `pathinfo'
main.o: In function `checkerloop':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1060:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1070:
undefined reference to `block_signal'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1071:
undefined reference to `cleanup_lock'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1071:
undefined reference to `__pthread_register_cancel'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1073:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1087:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1092:
undefined reference to `__pthread_unregister_cancel'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1093:
undefined reference to `pthread_sigmask'
main.o: In function `configure':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1107:
undefined reference to `vector_alloc'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1110:
undefined reference to `vector_alloc'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1113:
undefined reference to `vector_alloc'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1119:
undefined reference to `path_discovery'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1122:
undefined reference to `filter_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1123:
undefined reference to `vector_del_slot'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1124:
undefined reference to `free_path'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1136:
undefined reference to `coalesce_paths'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1146:
undefined reference to `dm_lib_release'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1153:
undefined reference to `remove_maps'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1158:
undefined reference to `vector_free'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1165:
undefined reference to `setup_multipath'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1168:
undefined reference to `start_waiter_thread'
main.o: In function `reconfigure':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1183:
undefined reference to `remove_maps_and_stop_waiters'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1186:
undefined reference to `free_pathvec'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1191:
undefined reference to `load_config'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1202:
undefined reference to `free_config'
main.o: In function `init_vecs':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1211:
undefined reference to `zalloc'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1217:
undefined reference to `zalloc'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1228:
undefined reference to `xfree'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1229:
undefined reference to `dlog'
main.o: In function `sighup':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1255:
undefined reference to `dlog'
main.o: In function `sigusr1':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1275:
undefined reference to `dlog'
main.o: In function `setscheduler':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1299:
undefined reference to `dlog'
main.o: In function `setup_thread_attr':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1328:
undefined reference to `pthread_attr_setstacksize'
main.o: In function `child':
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1353:
undefined reference to `waiter_attr'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1357:
undefined reference to `log_thread_start'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1361:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1362:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1364:
undefined reference to `load_config'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1367:
undefined reference to `init_checkers'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1368:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1371:
undefined reference to `init_prio'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1372:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1392:
undefined reference to `dlog'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1398:
undefined reference to `log_thread_stop'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1410:
undefined reference to `sysfs_init'
/home/lyang001/kvm_32/bitbake_build/tmp/work/i586-wrs-linux/multipath-tools-0.4.9-r0/multipathd/main.c:1411:
undefin
