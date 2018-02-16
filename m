From: Max Ivanov <ivanov.maxim@gmail.com>
Subject: kworker spin on iSCSI session logout with multipath
	running
Date: Fri, 16 Feb 2018 07:56:30 +0000
Message-ID: <CALQ-8CJgbRqZxRK2ZAxVfZgq+8Tohbj7XL+Cpk9Mr=nP-vk_6Q@mail.gmail.com>
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

Hello All,

I am investigating strange behaviour described here
https://github.com/coreos/bugs/issues/2357 and would like to ask for
help/advice to diagnose it further.

It all boils down to kworker spinning 100% of CPU per iSCSI portal,
when logging out from iSCSI sessions. It happens only if multipathd is
running or had run and created multipath devices. No problem occur if
I mask multipathd, reboot, wait for all scsi devices to be discovered
and attempt to logout.

  1. start server, login to all iscsi portals, no need to mount anything
  2. logout from all or one session. logging out from one sometimes
work, but more often does not. Logging out from all simultaneously
triggers problem 100% of the time.
  3. every iSCSI session we had befor makes kworker to spin. In my
case there are 4 portals to NetApp.  `l > /proc/sysrq-trigger` shows
following stack traces per kworker spinning:

[19806.968333] Call Trace:
[19806.968347]  scsi_remove_device+0x19/0x60 [scsi_mod]
[19806.968354]  scsi_remove_target+0x167/0x1b0 [scsi_mod]
[19806.968355]  iscsi_free_session+0x383/0x430 [scsi_transport_iscsi]
[19806.968366]  process_one_work+0x144/0x350
[19806.968367]  worker_thread+0x4d/0x3e0
[19806.968369]  kthread+0xfc/0x130
[19806.968370]  ? rescuer_thread+0x310/0x310
[19806.968371]  ? kthread_park+0x60/0x60
[19806.968372]  ? do_syscall_64+0xe9/0x1c0
[19806.968374]  ret_from_fork+0x35/0x40



  4. if I do `multipath -F; for d in $(iscsiadm -m session -P3 |awk
'/scsi disk/ {print $4}'); do echo 1 > /sys/block/$d/device/delete;
done` before logging out, it works just fine
  5. it is reproducible 100% of the time, so I you want me to collect
some data, I can run commands for you :)

Any help is greatly appreciated.


Software versions:
Kernel version is 4.14.16-coreos (CoreOS 1632.2.1)
iscsid version 2.0-873
multipath-tools 0.6.4
no iSCSI offloading
