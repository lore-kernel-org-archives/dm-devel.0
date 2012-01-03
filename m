From: Fil <lists@internyc.net>
Subject: Re: mpathpersist
Date: Mon, 02 Jan 2012 22:32:50 -0500
Message-ID: <4F0276E2.4070708@internyc.net>
References: <4EFEA631.3020902@internyc.net><1325340015.6564.18.camel@lapoo.opensvc.com>	<4EFF4BF1.2070608@internyc.net>
	<EE2129A8E578DC4E94D643D6C1C1C67D07A5804B@BTCMVEXC2-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <EE2129A8E578DC4E94D643D6C1C1C67D07A5804B@BTCMVEXC2-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
List-Id: dm-devel.ids

Vijay,

I tried applying patches over that commit and it almost applied. There
is still one reject.

cat ./multipathd/cli.h.rej
--- multipathd/cli.h	2011-12-18 02:25:43.000000000 -0500
+++ multipathd/cli.h	2011-12-18 02:26:09.000000000 -0500
@@ -65,9 +65,9 @@
 #define WILDCARDS	(1 << __WILDCARDS)
 #define QUIT		(1 << __QUIT)
 #define SHUTDOWN	(1 << __SHUTDOWN)
-#define GETPRSTATUS    (1 << __GETPRSTATUS)
-#define SETPRSTATUS    (1 << __SETPRSTATUS)
-#define UNSETPRSTATUS  (1 << __UNSETPRSTATUS)
+#define GETPRSTATUS	(1 << __GETPRSTATUS)
+#define SETPRSTATUS	(1 << __SETPRSTATUS)
+#define UNSETPRSTATUS	(1UL << __UNSETPRSTATUS)

 #define INITIAL_REPLY_LEN 1000

It looks like those definitions already exist. The really bad news is
once you compile it  and run it, it still breaks multipathd cli.

./mpathpersist/mpathpersist --out --register --param-sark=123abc
--prout-type=8 /dev/mapper/blah -v 4
Jan 02 22:31:27 | alias = blah
Jan 02 22:31:27 | params = 0 0 1 1 round-robin 0 2 1 8:0 1 8:16 1
Jan 02 22:31:27 | status = 2 0 0 0 1 1 A 0 2 0 8:0 A 0 8:16 A 0
Jan 02 22:31:27 | blah: disassemble map [0 0 1 1 round-robin 0 2 1 8:0 1
8:16 1 ]
Jan 02 22:31:27 | 8:0: not found in pathvec
Jan 02 22:31:27 | 8:16: not found in pathvec
Jan 02 22:31:27 | No device found for 8:0

Jan 02 22:31:27 | No device found for 8:16

Jan 02 22:31:27 | blah: disassemble status [2 0 0 0 1 1 A 0 2 0 8:0 A 0
8:16 A 0 ]
Jan 02 22:31:27 | blah: reservation_key  = 0x123abc (config file default)
Jan 02 22:31:27 | 36001405c55fc03cd8193d491eda0d4d7: no path available
PR out: command failed



multipathd -k
multipathd> help

Jan 02 22:29:15 | Got request [help]
Jan 02 22:29:15 | Reply [1033 bytes]
*** glibc detected *** ./multipathd/multipathd: free(): invalid next
size (normal): 0x00007fe77c001d40 ***
======= Backtrace: =========
/lib64/libc.so.6[0x366b47c2d6]
/lib64/libc.so.6[0x366b47d5be]
./multipathd/multipathd[0x40abe7]
./multipathd/multipathd[0x4076eb]
/lib64/libpthread.so.0[0x366bc07d90]
/lib64/libc.so.6(clone+0x6d)[0x366b4ef48d]
======= Memory map: ========
00400000-00412000 r-xp 00000000 fd:02 134411
 /root/vlah/multipath-tools/multipathd/multipathd
00612000-00613000 rw-p 00012000 fd:02 134411
 /root/vlah/multipath-tools/multipathd/multipathd
012a0000-012c1000 rw-p 00000000 00:00 0
 [heap]
366b000000-366b022000 r-xp 00000000 fd:02 129841
 /lib64/ld-2.14.90.so
366b221000-366b222000 r--p 00021000 fd:02 129841
 /lib64/ld-2.14.90.so
366b222000-366b223000 rw-p 00022000 fd:02 129841
 /lib64/ld-2.14.90.so
366b223000-366b224000 rw-p 00000000 00:00 0
366b400000-366b5ab000 r-xp 00000000 fd:02 131672
 /lib64/libc-2.14.90.so
366b5ab000-366b7ab000 ---p 001ab000 fd:02 131672
 /lib64/libc-2.14.90.so
366b7ab000-366b7af000 r--p 001ab000 fd:02 131672
 /lib64/libc-2.14.90.so
366b7af000-366b7b1000 rw-p 001af000 fd:02 131672
 /lib64/libc-2.14.90.so
366b7b1000-366b7b6000 rw-p 00000000 00:00 0
366b800000-366b802000 r-xp 00000000 fd:02 131675
 /lib64/libdl-2.14.90.so
366b802000-366ba02000 ---p 00002000 fd:02 131675
 /lib64/libdl-2.14.90.so
366ba02000-366ba03000 r--p 00002000 fd:02 131675
 /lib64/libdl-2.14.90.so
366ba03000-366ba04000 rw-p 00003000 fd:02 131675
 /lib64/libdl-2.14.90.so
366bc00000-366bc17000 r-xp 00000000 fd:02 131678
 /lib64/libpthread-2.14.90.so
366bc17000-366be16000 ---p 00017000 fd:02 131678
 /lib64/libpthread-2.14.90.so
366be16000-366be17000 r--p 00016000 fd:02 131678
 /lib64/libpthread-2.14.90.so
366be17000-366be18000 rw-p 00017000 fd:02 131678
 /lib64/libpthread-2.14.90.so
366be18000-366be1c000 rw-p 00000000 00:00 0
366c000000-366c007000 r-xp 00000000 fd:02 131679
 /lib64/librt-2.14.90.so
366c007000-366c206000 ---p 00007000 fd:02 131679
 /lib64/librt-2.14.90.so
366c206000-366c207000 r--p 00006000 fd:02 131679
 /lib64/librt-2.14.90.so
366c207000-366c208000 rw-p 00007000 fd:02 131679
 /lib64/librt-2.14.90.so
366c400000-366c41d000 r-xp 00000000 fd:02 131683
 /lib64/libselinux.so.1
366c41d000-366c61d000 ---p 0001d000 fd:02 131683
 /lib64/libselinux.so.1
366c61d000-366c61e000 r--p 0001d000 fd:02 131683
 /lib64/libselinux.so.1
366c61e000-366c61f000 rw-p 0001e000 fd:02 131683
 /lib64/libselinux.so.1
366c61f000-366c620000 rw-p 00000000 00:00 0
366c800000-366c83e000 r-xp 00000000 fd:02 131691
 /lib64/libsepol.so.1
366c83e000-366ca3e000 ---p 0003e000 fd:02 131691
 /lib64/libsepol.so.1
366ca3e000-366ca3f000 rw-p 0003e000 fd:02 131691
 /lib64/libsepol.so.1
366cc00000-366cc26000 r-xp 00000000 fd:02 131693
 /lib64/libdevmapper.so.1.02
366cc26000-366ce25000 ---p 00026000 fd:02 131693
 /lib64/libdevmapper.so.1.02
366ce25000-366ce27000 rw-p 00025000 fd:02 131693
 /lib64/libdevmapper.so.1.02
366d000000-366d015000 r-xp 00000000 fd:02 131690
 /lib64/libgcc_s-4.6.2-20111027.so.1
366d015000-366d214000 ---p 00015000 fd:02 131690
 /lib64/libgcc_s-4.6.2-20111027.so.1
366d214000-366d215000 rw-p 00014000 fd:02 131690
 /lib64/libgcc_s-4.6.2-20111027.so.1
366d400000-366d43c000 r-xp 00000000 fd:02 131715
 /lib64/libreadline.so.6.2
366d43c000-366d63b000 ---p 0003c000 fd:02 131715
 /lib64/libreadline.so.6.2
366d63b000-366d643000 rw-p 0003b000 fd:02 131715
 /lib64/libreadline.so.6.2
366d643000-366d644000 rw-p 00000000 00:00 0
366d800000-366d823000 r-xp 00000000 fd:02 131710
 /lib64/libncurses.so.5.9
366d823000-366da22000 ---p 00023000 fd:02 131710
 /lib64/libncurses.so.5.9
366da22000-366da23000 r--p 00022000 fd:02 131710
 /lib64/libncurses.so.5.9
366da23000-366da24000 rw-p 00023000 fd:02 131710
 /lib64/libncurses.so.5.9
366e000000-366e023000 r-xp 00000000 fd:02 131709
 /lib64/libtinfo.so.5.9
366e023000-366e222000 ---p 00023000 fd:02 131709
 /lib64/libtinfo.so.5.9
366e222000-366e226000 r--p 00022000 fd:02 131709
 /lib64/libtinfo.so.5.9
366e226000-366e227000 rw-p 00026000 fd:02 131709
 /lib64/libtinfo.so.5.9
366f800000-366f80e000 r-xp 00000000 fd:02 131692
 /lib64/libudev.so.0.12.0
366f80e000-366fa0e000 ---p 0000e000 fd:02 131692
 /lib64/libudev.so.0.12.0
366fa0e000-366fa0f000 r--p 0000e000 fd:02 131692
 /lib64/libudev.so.0.12.0
366fa0f000-366fa10000 rw-p 0000f000 fd:02 131692
 /lib64/libudev.so.0.12.0
7fe774000000-7fe774021000 rw-p 00000000 00:00 0
7fe774021000-7fe778000000 ---p 00000000 00:00 0
7fe778000000-7fe778021000 rw-p 00000000 00:00 0
7fe778021000-7fe77c000000 ---p 00000000 00:00 0
7fe77c000000-7fe77c021000 rw-p 00000000 00:00 0
7fe77c021000-7fe780000000 ---p 00000000 00:00 0
7fe780000000-7fe780021000 rw-p 00000000 00:00 0
7fe780021000-7fe784000000 ---p 00000000 00:00 0
7fe784000000-7fe784021000 rw-p 00000000 00:00 0
7fe784021000-7fe788000000 ---p 00000000 00:00 0
7fe78b617000-7fe78b618000 ---p 00000000 00:00 0
7fe78b618000-7fe78b628000 rw-p 00000000 00:00 0
7fe78b628000-7fe78b629000 ---p 00000000 00:00 0
7fe78b629000-7fe78b639000 rw-p 00000000 00:00 0
7fe78b639000-7fe78b63a000 ---p 00000000 00:00 0
7fe78b63a000-7fe78b64a000 rw-p 00000000 00:00 0
7fe78b64a000-7fe78b64b000 ---p 00000000 00:00 0
7fe78b64b000-7fe78b65b000 rw-p 00000000 00:00 0
7fe78b65b000-7fe78b65c000 r-xp 00000000 fd:02 131265
 /lib64/multipath/libprioconst.so
7fe78b65c000-7fe78b85b000 ---p 00001000 fd:02 131265
 /lib64/multipath/libprioconst.soAborted

thanks
fil


On 01/02/2012 06:53 AM, Chauhan, Vijay wrote:
> Thanks for trying out this patch and for your comments.
> 
> Patch is made on top of commit fa7074f35c67ff1ef29f1aea5a484c5dea25863a
> . 
> Please let me know if you still face any issue in applying patch on this
> commit. 
> Meanwhile I will rebase the changes to HEAD   before resending it.
> 
> Any feedback for your verification would be appreciated.   
> 
> On 12/31/2010 11:23 PM, Fil wrote:
>> oops sorry, I was reading something else you responded to so
> automatically I
>> wrote to you....
>> On 12/31/2011 09:00 AM, Christophe Varoqui wrote:
>>>
>>>> I have seen your set of patches for persistent reservation of
>>>> multipath devices and wanted to try them out. While trying this
> patch
>>>> set I have run into several issues. Which code base can I apply
> this
>>>> against? Any help would be greatly appreciated. Issues are listed
> below.
>>>
>>> This patchset has been developped by Netapp's Vijay Chauhan.
>>>
>>>> 2. I pulled multipath-tools from opensvc git and that patching
> failed
>>>> too, so I had to apply all the patches manually.
>>>>
>>> This is the correct project repository. The patchset may need
> rebasing
>>> over the HEAD. If it does not apply cleanly there, you might try to
>>> revert to a previous commit.
>>>
>>> I'll try this patchset soon and compare my experience with your
>>> observations.
>>>
>>> Thanks for the report.
>>>
>>>> 3. while testing mppersist I get following error:
>>>>
>>>> mpathpersist --out --register --param-sark=123abc --prout-type=8
>>>> /dev/mapper/blah -v 4 Dec 31 00:54:29 | alias = blah Dec 31
> 00:54:29
>>>> | params = 0 0 1 1 round-robin 0 2 1 8:0 1 8:16 1 Dec 31 00:54:29 |
>>>> status = 2 0 0 0 1 1 A 0 2 0 8:0 A 0 8:16 A 0 Dec 31 00:54:29 |
> blah:
>>>> disassemble map [0 0 1 1 round-robin 0 2 1 8:0 1
>>>> 8:16 1 ]
>>>> Dec 31 00:54:29 | 8:0: not found in pathvec Dec 31 00:54:29 | 8:16:
>>>> not found in pathvec Dec 31 00:54:29 | No device found for 8:0
>>>>
> 
> Please try patch on the commit version mentioned above and let me know
> if 
> you still face issue 3 and issue 4? 
> 
>>>> Dec 31 00:54:29 | No device found for 8:16
>>>>
>>>> Dec 31 00:54:29 | blah: disassemble status [2 0 0 0 1 1 A 0 2 0 8:0
> A
>>>> 0
>>>> 8:16 A 0 ]
>>>> Dec 31 00:54:29 | 36001405c55fc03cd8193d491eda0d4d7: no path
>>>> available PR out: command failed
>>>>
>>>> 4. with all patches applied, all multipathd cli commands crash the
> daemon.
>>>>
> 
> You may need specify reservation_key keyword in following format in
> either 
> multipath section or default section for the applicable devices. In case
> if reservation_key
>  is not mentioned in multipath.conf then multipathd would not check for
> persistent reservation 
> for newly discovered path and reinstated path.
> 
> reservation_key  <reservation key>
> 
> Example:
>  multipaths {
>         multipath {
>                           wwid   XXXXXXXXXXXXXXXX
>                          alias      yellow
>                          reservation_key  0x123abc
>       }
> }
> 
>>>> here are my configs:
>>>>
>>>> cat /etc/multipath.conf
>>>> defaults {
>>>> 	user_friendly_names	yes
>>>> 	polling_interval	10
>>>> }
>>>>
>>>> multipaths {
>>>> 	multipath {
>>>> 		wwid
>> 	36001405c55fc03cd8193d491eda0d4d7
>>>> 		alias			blah
>>>> 	}
>>>> }
>>>>
>>>>
>>>> devices {
>>>> 	device {
>>>> 		vendor			"QNAP"
>>>> 		product			"iSCSI Storage"
>>>> 		path_selector		"round-robin 0"
>>>> 		path_grouping_policy	multibus
>>>> 		getuid_callout          "/lib/udev/scsi_id -g -u -d
> /dev/%n"
>>>> 		path_checker		directio
>>>> 		failback		immediate
>>>> 	}
>>>>
>>>> }
>>>>
>>>> blacklist {
>>>>         devnode "^(vd)[a-z]"
>>>> }
>>>>
>>>> multipath -ll -v3
>>>> Dec 31 00:59:01 | loading /lib64/multipath/libcheckdirectio.so
>>>> checker Dec 31 00:59:01 | loading /lib64/multipath/libprioconst.so
>>>> prioritizer Dec 31 00:59:01 | loop0: device node name blacklisted
> Dec
>>>> 31 00:59:01 | loop1: device node name blacklisted Dec 31 00:59:01 |
>>>> loop2: device node name blacklisted Dec 31 00:59:01 | loop3: device
>>>> node name blacklisted Dec 31 00:59:01 | loop4: device node name
>>>> blacklisted Dec 31 00:59:01 | loop5: device node name blacklisted
> Dec
>>>> 31 00:59:01 | loop6: device node name blacklisted Dec 31 00:59:01 |
>>>> loop7: device node name blacklisted Dec 31 00:59:01 | vda: device
>>>> node name blacklisted Dec 31 00:59:01 | dm-0: device node name
>>>> blacklisted Dec 31 00:59:01 | dm-1: device node name blacklisted
> Dec
>>>> 31 00:59:01 | dm-2: device node name blacklisted Dec 31 00:59:01 |
>>>> dm-3: device node name blacklisted Dec 31 00:59:01 | sda: not found
>>>> in pathvec Dec 31 00:59:01 | sda: mask = 0x5 Dec 31 00:59:01 | sda:
>>>> dev_t = 8:0 Dec 31 00:59:01 | sda: size = 20971520 Dec 31 00:59:01
> |
>>>> sda: vendor = QNAP Dec 31 00:59:01 | sda: product = iSCSI Storage
> Dec
>>>> 31 00:59:01 | sda: rev = 3.1 Dec 31 00:59:01 | sda: h:b:t:l =
> 2:0:0:0
>>>> Dec 31 00:59:01 | sda: path state = running Dec 31 00:59:01 | sda:
>>>> get_state Dec 31 00:59:01 | sda: path checker = directio
> (controller
>>>> setting) Dec 31 00:59:01 | sda: checker timeout = 30000 ms (sysfs
>>>> setting) Dec 31 00:59:01 | directio: starting new request Dec 31
>>>> 00:59:01 | directio: io finished 4096/0 Dec 31 00:59:01 | sda:
> state
>>>> = up Dec 31 00:59:01 | sdb: not found in pathvec Dec 31 00:59:01 |
>>>> sdb: mask = 0x5 Dec 31 00:59:01 | sdb: dev_t = 8:16 Dec 31 00:59:01
> |
>>>> sdb: size = 20971520 Dec 31 00:59:01 | sdb: vendor = QNAP Dec 31
>>>> 00:59:01 | sdb: product = iSCSI Storage Dec 31 00:59:01 | sdb: rev
> =
>>>> 3.1 Dec 31 00:59:01 | sdb: h:b:t:l = 3:0:0:0 Dec 31 00:59:01 | sdb:
>>>> path state = running Dec 31 00:59:01 | sdb: get_state Dec 31
> 00:59:01
>>>> | sdb: path checker = directio (controller setting) Dec 31 00:59:01
> |
>>>> sdb: checker timeout = 30000 ms (sysfs setting) Dec 31 00:59:01 |
>>>> directio: starting new request Dec 31 00:59:01 | directio: io
>>>> finished 4096/0 Dec 31 00:59:01 | sdb: state = up Dec 31 00:59:01 |
>>>> dm-4: device node name blacklisted ===== paths list =====
>>>> uuid hcil    dev dev_t pri dm_st chk_st vend/prod/rev      dev_st
>>>>      2:0:0:0 sda 8:0   -1  undef ready  QNAP,iSCSI Storage running
>>>>      3:0:0:0 sdb 8:16  -1  undef ready  QNAP,iSCSI Storage running
>>>> Dec 31 00:59:01 | params = 0 0 1 1 round-robin 0 2 1 8:0 1 8:16 1
> Dec
>>>> 31 00:59:01 | status = 2 0 0 0 1 1 A 0 2 0 8:0 A 0 8:16 A 0 Dec 31
>>>> 00:59:01 | blah: disassemble map [0 0 1 1 round-robin 0 2 1 8:0 1
>>>> 8:16 1 ]
>>>> Dec 31 00:59:01 | sda: mask = 0x8
>>>> Dec 31 00:59:01 | sda: path state = running Dec 31 00:59:01 | sda:
>>>> prio = const (internal default) Dec 31 00:59:01 | sda: prio =
>>>> (internal default) Dec 31 00:59:01 | sda: const prio = 1 Dec 31
>>>> 00:59:01 | sdb: mask = 0x8 Dec 31 00:59:01 | sdb: path state =
>>>> running Dec 31 00:59:01 | sdb: prio = const (internal default) Dec
> 31
>>>> 00:59:01 | sdb: prio =  (internal default) Dec 31 00:59:01 | sdb:
>>>> const prio = 1 Dec 31 00:59:01 | blah: disassemble status [2 0 0 0
> 1
>>>> 1 A 0 2 0 8:0 A 0
>>>> 8:16 A 0 ]
>>>> blah (36001405c55fc03cd8193d491eda0d4d7) dm-4 QNAP,iSCSI Storage
>>>> size=10G features='0' hwhandler='0' wp=rw
>>>> `-+- policy='round-robin 0' prio=0 status=active
>>>>   |- 2:0:0:0 sda 8:0  active ready running
>>>>   `- 3:0:0:0 sdb 8:16 active ready running Dec 31 00:59:01 |
> directio
>>>> checker refcount 2 Dec 31 00:59:01 | directio checker refcount 1
> Dec
>>>> 31 00:59:01 | unloading const prioritizer Dec 31 00:59:01 |
> unloading
>>>> directio checker
> 
> Thanks,
> Vijay
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
