From: =?ISO-8859-1?Q?Xu=E2n_Baldauf?= <xuan--2006--dm-devel--redhat.com@baldauf.org>
Subject: [Bug] Double acquisition of the same semaphore
Date: Sun, 24 Dec 2006 04:13:42 +0100
Message-ID: <458DF066.10708@baldauf.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0228208874=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is a multi-part message in MIME format.
--===============0228208874==
Content-Type: multipart/alternative;
	boundary="------------000603050808060407020105"

This is a multi-part message in MIME format.
--------------000603050808060407020105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

I have a Linux box where block devices are layered in this hierarchy:
dm-crypt over LVM2 over software-RAID5 over LVM over harddisks. Since
that hierarchy was used, there were occassionally crashes, whose
probability at a certain time seems to be proportional to the amount of
I/O done. Now one disk of the RAID5 showed block errors and I tried to
copy large amounts of data using pvmove to other block devices, but
without success, the machine crashes before the copying finishes. Now I
upgraded to linux-2.6.20-rc1 and this yields error messages when
accessing the block device hierarchy:

<4>[   37.732000] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
<4>[   37.732000] [ INFO: possible recursive locking detected ]
<4>[   37.732000] 2.6.20-rc1-nopreempt #21
<4>[   37.732000] ---------------------------------------------
<4>[   37.732000] kcryptd/0/755 is trying to acquire lock:
<4>[   37.732000]  (&md->io_lock){----}, at: [<c02e3bc8>]
dm_request+0x18/0xf0
<4>[   37.732000]
<4>[   37.732000] but task is already holding lock:
<4>[   37.732000]  (&md->io_lock){----}, at: [<c02e3bc8>]
dm_request+0x18/0xf0
<4>[   37.732000]
<4>[   37.732000] other info that might help us debug this:
<4>[   37.732000] 1 lock held by kcryptd/0/755:
<4>[   37.732000]  #0:  (&md->io_lock){----}, at: [<c02e3bc8>]
dm_request+0x18/0xf0
<4>[   37.732000]
<4>[   37.732000] stack backtrace:
<4>[   37.732000]  [<c01042ee>] dump_trace+0x1ce/0x200
<4>[   37.732000]  [<c010433a>] show_trace_log_lvl+0x1a/0x30
<4>[   37.732000]  [<c0104972>] show_trace+0x12/0x20
<4>[   37.732000]  [<c0104a26>] dump_stack+0x16/0x20
<4>[   37.732000]  [<c013a3e5>] __lock_acquire+0xb35/0xe00
<4>[   37.732000]  [<c013a72e>] lock_acquire+0x7e/0xb0
<4>[   37.732000]  [<c01352aa>] down_read+0x3a/0x50
<4>[   37.732000]  [<c02e3bc8>] dm_request+0x18/0xf0
<4>[   37.732000]  [<c0208aed>] generic_make_request+0x1cd/0x380
<4>[   37.732000]  [<c02d1563>] make_request+0x553/0x5f0
<4>[   37.732000]  [<c0208aed>] generic_make_request+0x1cd/0x380
<4>[   37.732000]  [<c02e2bbf>] __map_bio+0xcf/0x130
<4>[   37.732000]  [<c02e36b1>] __split_bio+0x171/0x430
<4>[   37.732000]  [<c02e3c5a>] dm_request+0xaa/0xf0
<4>[   37.732000]  [<c0208aed>] generic_make_request+0x1cd/0x380
<4>[   37.732000]  [<c02e9cbf>] kcryptd_do_work+0x27f/0x3e0
<4>[   37.732000]  [<c012e9c5>] run_workqueue+0xf5/0x1d0
<4>[   37.732000]  [<c012f09a>] worker_thread+0x13a/0x160
<4>[   37.732000]  [<c0131cf3>] kthread+0xa3/0xd0
<4>[   37.732000]  [<c0103d0f>] kernel_thread_helper+0x7/0x18
<4>[   37.732000]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
<3>[   37.733000] BUG: workqueue leaked lock or atomic:
kcryptd/0/0x00000000/755, in_atomic()=3D0, lockdep_depth(current)=3D1,
previous_lockdep_depth=3D0.
<3>[   37.734000]     last function: kcryptd_do_work+0x0/0x3e0
<4>[   37.734000] 1 lock held by kcryptd/0/755:
<4>[   37.734000]  #0:  (&md->io_lock){----}, at: [<c02e3bc8>]
dm_request+0x18/0xf0
<4>[   37.734000]  [<c01042ee>] dump_trace+0x1ce/0x200
<4>[   37.734000]  [<c010433a>] show_trace_log_lvl+0x1a/0x30
<4>[   37.734000]  [<c0104972>] show_trace+0x12/0x20
<4>[   37.734000]  [<c0104a26>] dump_stack+0x16/0x20
<4>[   37.734000]  [<c012ea65>] run_workqueue+0x195/0x1d0
<4>[   37.734000]  [<c012f09a>] worker_thread+0x13a/0x160
<4>[   37.734000]  [<c0131cf3>] kthread+0xa3/0xd0
<4>[   37.735000]  [<c0103d0f>] kernel_thread_helper+0x7/0x18
<4>[   37.735000]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

As you can see, dm_request() finally calls itself, leading to a double
acquisition of the same semaphore &md->io_lock, while double acquisition
of the same semaphore is not supported by standard Linux kernel
semaphores. The semaphore should also be double freed and thus freed to
early. This might explain my I/O-sensitive crashes I suffer.

How can this bug be solved?

   1. Use recursive semaphores? I could not find recursive semaphores
      (semaphores which may be acquired multiple times by the same
      thread) in the Linux kernel.
   2. Pass an "already locked" flag between all the functions, including
      generic_make_request()?
   3. Use a kind of thread-local storage for knowing a list of all locks
      held?
   4. Implement recursive semaphores by myself? (I should leave this to
      the more experienced Linux hackers.)
   5. Rework device-mapper so that there will no a recursive call of
      dm_request() on the same mapped_device? (Is this possible?)

Please help.

Merry Christmas!

Xu=E2n.


--------------000603050808060407020105
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Hello,<br>
<br>
I have a Linux box where block devices are layered in this hierarchy:
dm-crypt over LVM2 over software-RAID5 over LVM over harddisks. Since
that hierarchy was used, there were occassionally crashes, whose
probability at a certain time seems to be proportional to the amount of
I/O done. Now one disk of the RAID5 showed block errors and I tried to
copy large amounts of data using pvmove to other block devices, but
without success, the machine crashes before the copying finishes. Now I
upgraded to linux-2.6.20-rc1 and this yields error messages when
accessing the block device hierarchy:<br>
<br>
<tt>&lt;4&gt;[&nbsp;&nbsp; 37.732000]
=============================================<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000] [ INFO: possible recursive locking detected ]<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000] 2.6.20-rc1-nopreempt #21<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000] ---------------------------------------------<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000] kcryptd/0/755 is trying to acquire lock:<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; (&amp;md-&gt;io_lock){----}, at:
[&lt;c02e3bc8&gt;] dm_request+0x18/0xf0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000] but task is already holding lock:<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; (&amp;md-&gt;io_lock){----}, at:
[&lt;c02e3bc8&gt;] dm_request+0x18/0xf0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000] other info that might help us debug this:<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000] 1 lock held by kcryptd/0/755:<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; #0:&nbsp; (&amp;md-&gt;io_lock){----}, at:
[&lt;c02e3bc8&gt;] dm_request+0x18/0xf0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000] stack backtrace:<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c01042ee&gt;] dump_trace+0x1ce/0x200<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c010433a&gt;] show_trace_log_lvl+0x1a/0x30<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c0104972&gt;] show_trace+0x12/0x20<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c0104a26&gt;] dump_stack+0x16/0x20<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c013a3e5&gt;] __lock_acquire+0xb35/0xe00<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c013a72e&gt;] lock_acquire+0x7e/0xb0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c01352aa&gt;] down_read+0x3a/0x50<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c02e3bc8&gt;] dm_request+0x18/0xf0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c0208aed&gt;]
generic_make_request+0x1cd/0x380<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c02d1563&gt;] make_request+0x553/0x5f0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c0208aed&gt;]
generic_make_request+0x1cd/0x380<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c02e2bbf&gt;] __map_bio+0xcf/0x130<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c02e36b1&gt;] __split_bio+0x171/0x430<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c02e3c5a&gt;] dm_request+0xaa/0xf0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c0208aed&gt;]
generic_make_request+0x1cd/0x380<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c02e9cbf&gt;] kcryptd_do_work+0x27f/0x3e0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c012e9c5&gt;] run_workqueue+0xf5/0x1d0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c012f09a&gt;] worker_thread+0x13a/0x160<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c0131cf3&gt;] kthread+0xa3/0xd0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; [&lt;c0103d0f&gt;]
kernel_thread_helper+0x7/0x18<br>
&lt;4&gt;[&nbsp;&nbsp; 37.732000]&nbsp; =======================<br>
&lt;3&gt;[&nbsp;&nbsp; 37.733000] BUG: workqueue leaked lock or atomic:
kcryptd/0/0x00000000/755, in_atomic()=0, lockdep_depth(current)=1,
previous_lockdep_depth=0.<br>
&lt;3&gt;[&nbsp;&nbsp; 37.734000]&nbsp;&nbsp;&nbsp;&nbsp; last function: kcryptd_do_work+0x0/0x3e0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.734000] 1 lock held by kcryptd/0/755:<br>
&lt;4&gt;[&nbsp;&nbsp; 37.734000]&nbsp; #0:&nbsp; (&amp;md-&gt;io_lock){----}, at:
[&lt;c02e3bc8&gt;] dm_request+0x18/0xf0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.734000]&nbsp; [&lt;c01042ee&gt;] dump_trace+0x1ce/0x200<br>
&lt;4&gt;[&nbsp;&nbsp; 37.734000]&nbsp; [&lt;c010433a&gt;] show_trace_log_lvl+0x1a/0x30<br>
&lt;4&gt;[&nbsp;&nbsp; 37.734000]&nbsp; [&lt;c0104972&gt;] show_trace+0x12/0x20<br>
&lt;4&gt;[&nbsp;&nbsp; 37.734000]&nbsp; [&lt;c0104a26&gt;] dump_stack+0x16/0x20<br>
&lt;4&gt;[&nbsp;&nbsp; 37.734000]&nbsp; [&lt;c012ea65&gt;] run_workqueue+0x195/0x1d0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.734000]&nbsp; [&lt;c012f09a&gt;] worker_thread+0x13a/0x160<br>
&lt;4&gt;[&nbsp;&nbsp; 37.734000]&nbsp; [&lt;c0131cf3&gt;] kthread+0xa3/0xd0<br>
&lt;4&gt;[&nbsp;&nbsp; 37.735000]&nbsp; [&lt;c0103d0f&gt;]
kernel_thread_helper+0x7/0x18<br>
&lt;4&gt;[&nbsp;&nbsp; 37.735000]&nbsp; =======================<br>
</tt><br>
As you can see, dm_request() finally calls itself, leading to a double
acquisition of the same semaphore <tt>&amp;md-&gt;io_lock</tt>, while
double acquisition of the same semaphore is not supported by standard
Linux kernel semaphores. The semaphore should also be double freed and
thus freed to early. This might explain my I/O-sensitive crashes I
suffer.<br>
<br>
How can this bug be solved?<br>
<ol>
  <li>Use recursive semaphores? I could not find recursive semaphores
(semaphores which may be acquired multiple times by the same thread) in
the Linux kernel.</li>
  <li>Pass an "already locked" flag between all the functions,
including generic_make_request()?</li>
  <li>Use a kind of thread-local storage for knowing a list of all
locks held?</li>
  <li>Implement recursive semaphores by myself? (I should leave this to
the more experienced Linux hackers.)</li>
  <li>Rework device-mapper so that there will no a recursive call of
dm_request() on the same mapped_device? (Is this possible?)<br>
  </li>
</ol>
Please help.<br>
<br>
Merry Christmas!<br>
<br>
Xu&acirc;n.<br>
<br>
</body>
</html>

--------------000603050808060407020105--


--===============0228208874==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0228208874==--
