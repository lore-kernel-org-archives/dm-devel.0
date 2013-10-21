From: Prakash Prasad <prakash_prasad@yahoo.com>
Subject: Re: A review of dm-writeboost
Date: Mon, 21 Oct 2013 10:00:00 +0800 (SGT)
Message-ID: <1382320800.74237.YahooMailNeo@web190704.mail.sg3.yahoo.com>
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
	<52550841.5030001@gmail.com> <525BAB32.5050901@gmail.com>
	<alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
	<20131016060750.GE4446@dastard> <525E6BBE.40004@gmail.com>
	<20131016110146.GH4446@dastard> <525E83E4.9090803@gmail.com>
	<20131016214200.GI4446@dastard> <5262662B.9010807@gmail.com>
	<20131021013143.GC4446@dastard>
Reply-To: Prakash Prasad <prakash_prasad@yahoo.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8999251103929737543=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131021013143.GC4446@dastard>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dave Chinner <david@fromorbit.com>, Akira Hayakawa <ruby.wktk@gmail.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "thornber@redhat.com" <thornber@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "joe@perches.com" <joe@perches.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "tj@kernel.org" <tj@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>, "ejt@redhat.com" <ejt@redhat.com>, "cesarb@cesarb.net" <cesarb@cesarb.net>, "m.chehab@samsung.com" <m.chehab@samsung.com>
List-Id: dm-devel.ids

--===============8999251103929737543==
Content-Type: multipart/alternative;
	boundary="-929976460-1502260485-1382320800=:74237"

---929976460-1502260485-1382320800=:74237
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Can anyone please let me know where can I get the staging area drivers code=
 and their test cases?=0A=0AI understand that I need to download the =0Asta=
ging area device drivers code. In the source code tree there would be a TOD=
O file. Accordingly we have to fix and propagate it identifying =0Athe owne=
r also.=0A=0ABut how are we suppose to test out the same - where are the te=
st cases and process to execute them?=0A=0ARegards,=0APrakash=0A=0A=0A=0A=
=0AOn Monday, 21 October 2013 7:12 AM, Dave Chinner <david@fromorbit.com> w=
rote:=0A =0AOn Sat, Oct 19, 2013 at 07:59:55PM +0900, Akira Hayakawa wrote:=
=0A> Dave,=0A> =0A> # -EIO retuned corrupts XFS=0A> I turned up=0A> lockdep=
, frame pointer, xfs debug=0A> and also changed to 3.12.0-rc5 from rc1.=0A>=
 =0A> What's changed is that=0A> the problem we discussed in previous mails=
=0A> *never* reproduce.=0A> =0A> However, if I turn off the lockdep only=0A=
> it hangs up by setting blockup to 1 and then to 0 after that.=0A=0AWhich =
indicates that the corruption is likely to be caused by a race=0Acondition,=
 and that adding lockdep slows things down enough to=0Achange the timing an=
d hence not hit the race condition...=0A=0Ae.g. the use after free that cau=
ses the memory corruption now occurs=0Aafter the critical point where XFS c=
an get stuck on it.=0A=0A> The underlying device once became dead revives=
=0A> may confuse the filesystem but=0A> this looks not related to locking t=
hings.=0A> This problem may be producible using dm-flakey.=0A=0AI use dm-fl=
akey quite a bit, and I haven't seen this....=0A=0A> This behavior is not r=
eproducible with ext4.=0A> =0A> -------------------------------------------=
-=0A> root@Lyle:/home/akira# virsh console Hercules=0A> Connected to domain=
 Hercules=0A> Escape character is ^]=0A> [=A0 143.042980] device-mapper: wr=
iteboost: info@modulator_proc() reactivated after blockup=0A> [=A0 143.0429=
99] device-mapper: writeboost: info@dm_safe_io_internal() reactivated after=
 blockup=0A> [=A0 143.043006] device-mapper: writeboost: info@migrate_proc(=
) reactivated after blockup=0A> [=A0 143.045328] XFS: metadata I/O error: b=
lock 0x300d0f ("xlog_iodone") error 5 numblks 64=0A> [=A0 143.045333] XFS: =
xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.=
=A0 Return address =3D 0xffffffffa0430f9c=0A> [=A0 143.045335] XFS: Log I/O=
 Error Detected.=A0 Shutting down filesystem=0A> [=A0 143.045335] XFS: Plea=
se umount the filesystem and rectify the problem(s)=0A> [=A0 143.045338] XF=
S: Assertion failed: atomic_read(&iclog->ic_refcnt) =3D=3D 0, file: fs/xfs/=
xfs_log.c, line: 2751=0A.....=0A> [=A0 143.045465] Workqueue: xfslogd xfs_b=
uf_iodone_work [xfs]=0A.....=0A> [=A0 143.045558]=A0 [<ffffffffa0430ed1>] x=
log_state_done_syncing+0x6d/0xe4 [xfs]=0A> [=A0 143.045590]=A0 [<ffffffffa0=
431018>] xlog_iodone+0xd0/0xd9 [xfs]=0A> [=A0 143.045609]=A0 [<ffffffffa03d=
834f>] xfs_buf_iodone_work+0x57/0xa2 [xfs]=0A> [=A0 143.045627]=A0 [<ffffff=
ff8104f21a>] process_one_work+0x18b/0x297=0A> [=A0 143.045631]=A0 [<fffffff=
f8104f6e6>] worker_thread+0x12e/0x1fb=0A> [=A0 143.045634]=A0 [<ffffffff810=
4f5b8>] ? rescuer_thread+0x268/0x268=0A> [=A0 143.045638]=A0 [<ffffffff8105=
4507>] kthread+0x88/0x90=0A> [=A0 143.045641]=A0 [<ffffffff8105447f>] ? __k=
thread_parkme+0x60/0x60=0A=0ASo that has got through xlog_iodone() and has =
found that the=0Areference count of the iclog was not zero when it went to =
run the=0Alog IO completion callbacks.=0A=0AWe asserted that the reference =
count was zero before issuing the IO,=0Aand we only ever increment the refe=
rence count when the iclog is in=0Aan active state. We cannot increment the=
 reference count while the=0Alog is under IO because the state of the iclog=
 is "syncing", not=0A"active".=0A=0AOnce the log is shut down, the iclog st=
ate goes to=0AXLOG_STATE_IOERROR and never goes out of that state. The asse=
rt just=0Aprior to the one that tripped above indicates that we are either =
in=0Aan ACTIVE state or IOERROR:=0A=0A=A0 =A0 =A0 =A0 ASSERT(iclog->ic_stat=
e =3D=3D XLOG_STATE_SYNCING ||=0A=A0 =A0 =A0 =A0 =A0 =A0 =A0  iclog->ic_sta=
te =3D=3D XLOG_STATE_IOERROR);=0A>>>>>>=A0 ASSERT(atomic_read(&iclog->ic_re=
fcnt) =3D=3D 0);=0A=0AIt was the second assert that failed, and hence it's =
clear that=0Ain either state the reference count cannot be incremented unti=
l the=0AIO is fully completed and it transitioned back the active state.=0A=
=0A> [=A0 143.045333] XFS: xfs_do_force_shutdown(0x2) called from line 1161=
 of file fs/xfs/xfs_log.c.=A0 Return address =3D 0xffffffffa0430f9c=0A=0ATh=
is indicates that the shutdown was called from xlog_iodone() as a=0Aresult =
of an IO error on the iclog buffer, and the call to=0Axlog_state_done_synci=
ng() happens 5 lines of code later, which=0Aimmediately assert fails with a=
 corrupt iclog state.=0A=0ABecause we shutdown with SHUTDOWN_LOG_IO_ERROR s=
et, we call into=0Axfs_log_force_umount() with logerror =3D true. This firs=
t call ends up=0Asetting the log flag XLOG_IO_ERROR, then calling=0Axlog_st=
ate_ioerror() which sets ic_state on all iclogs to=0AXLOG_STATE_IOERROR.=0A=
=0AThe shutdown then runs xlog_state_do_callback() which aborts the=0Acompl=
etions on all the iclogs that have callbacks attached, and=0Awakes anyone w=
aiting on log space or log forces so they can get=0Aerrors returned to them=
.=0A=0AWe now return to xlog_iodone() in a shutdown state, with all the=0Ai=
clog buffers in with ic_state =3D XLOG_STATE_IOERROR. So, there is=0Aabsolu=
tely no opportunity for anyone to take a new reference to the=0Aiclog in th=
e 10 *microseconds* between the IO error being detected,=0Athe shutdown bei=
ng processed and the call to=0Axlog_state_done_syncing() where the assert f=
ails. At this point, I=0Acannot see how this can occur in the XFS code.=0A=
=0AIndeed, I can trigger this error path easily under heavy load just=0Ausi=
ng the godown utility in xfstests:=0A=0A[1044535.986040] XFS (vdc): Mountin=
g Filesystem=0A[1044536.040630] XFS (vdc): Ending clean mount=0A[1044536.05=
9299] XFS: Clearing xfsstats=0A# src/xfstests-dev/src/godown -v /mnt/scratc=
h=0AOpening "/mnt/scratch"=0ACalling XFS_IOC_GOINGDOWN=0A[1044553.342767] X=
FS (vdc): metadata I/O error: block 0x19000c2e98 ("xlog_iodone") error 5 nu=
mblks 512=0A[1044553.345993] XFS (vdc): xfs_do_force_shutdown(0x2) called f=
rom line 1171 of file fs/xfs/xfs_log.c.=A0 Return address =3D 0xffffffff814=
e61ad=0A#[1044554.136965] XFS (vdc): xfs_log_force: error 5 returned.=0A[10=
44554.154892] XFS: Clearing xfsstats=0A[1044566.108484] XFS (vdc): xfs_log_=
force: error 5 returned.=0A[1044596.188515] XFS (vdc): xfs_log_force: error=
 5 returned.=0A[1044626.268166] XFS (vdc): xfs_log_force: error 5 returned.=
=0A[1044656.348146] XFS (vdc): xfs_log_force: error 5 returned.=0A=0AIOWs, =
this looks like something is corrupting the state of the log=0A*before* the=
 xlog_iodone() callback is being run. i.e. it is in a=0Avalid state before =
IO dispatch and it's in a corrupt state on IO=0Acompletion despite XFS havi=
ng *never touched that state* during the=0AIO.=0A=0AIndeed, this is a diffe=
rent issue to the one you posted=0Aearlier, which was the AIL lock (which i=
s in a different XFS=0Astructure) had not been released. Again, I couldn't =
see how that=0Acould occur, and we're now seeing a pattern of random struct=
ures=0Abeing corrupted. Hmmm, looking at pahole:=0A=0Aatomic_t=A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0  ic_refcnt;=A0 =A0 =A0 =A0 =A0 =A0 /*=A0  192=A0 =
=A0  4 */=0A=0Aspinlock_t=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0  xa_lock;=A0 =A0 =
=A0 =A0 =A0 =A0 =A0 /*=A0 =A0 64=A0 =A0  2 */=0A=0ABoth the items that were=
 corrupted are on the first word of a=0Acacheline. That further points to m=
emory corruption of some kind...=0A=0AIOWs, the more I look, the more this =
looks like memory corruption is=0Athe cause of the problems. The only unusu=
al thing that is happening=0Ais an error handling path in a brand new block=
 device driver is=0Abeing run immediately before the memory corruption caus=
es problems,=0Aand that tends to indicate that this corruption is not cause=
d by=0AXFS...=0A=0A> My Idea:=0A> - If something problematic happens in und=
erlying devices=0A>=A0  writeboost device returns -EIO on any requests and=
=0A>=A0  stop all the daemons=0A....=0A> - I will not remove `blockup`.=0A>=
=A0  Yes. If the problem is in hardware it is very difficult=0A>=A0  to rec=
over.=0A>=A0  However, leaving a chance for recovering the device is=0A>=A0=
  at least better than just shutdown the device=0A>=A0  if it doesn't pollu=
te the code so much.=0A>=A0  So, I will leave this option.=0A=0AIt doesn't =
matter whether the underlying hardware might be able to=0Arecover - once yo=
u've send EIOs during IO completion that=0Adata/metadata is considered *unr=
ecoverable* and so the filesystem=0Awill end up inconsistent or the *user w=
ill lose data* as a result.=0A=0AIOWs, your idea is flawed, will not work a=
nd will result in=0Adata/filesystem loss when used. You cannot call this a =
"recovery=0Amechanism" because it simply isn't.=0A=0A> BTW, what do you mea=
n by the word "fatal"?=0A=0A"He suffered a fatal gunshot wound to the head.=
"=0A=0Ai.e. the person is *dead* and life is *unrecoverable*.=0A=0AThat's w=
hat you are doing here - returning EIOs to IOs in progress=0Ais effectively=
 shooting the fileystem (and user data) in the=0Ahead.....=0A=0ACheers,=0A=
=0ADave.=0A=0A-- =0ADave Chinner=0Adavid@fromorbit.com=0A__________________=
_____________________________=0Adevel mailing list=0Adevel@linuxdriverproje=
ct.org=0Ahttp://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev=
-devel
---929976460-1502260485-1382320800=:74237
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:ti=
mes new roman, new york, times, serif;font-size:14pt"><div><span>Can anyone=
 please let me know where can I get the staging area drivers code and their=
 test cases?</span></div><div style=3D"color:rgb(0, 0, 0);font-size:18.6667=
px;font-family:times new roman, new york, times, serif;background-color:tra=
nsparent;font-style:normal;"><br><span></span></div><div style=3D"color:rgb=
(0, 0, 0);font-size:18.6667px;font-family:times new roman, new york, times,=
 serif;background-color:transparent;font-style:normal;"><span>I understand =
that I need to download the =0Astaging area device drivers code. In the sou=
rce code tree there would be=0A a TODO file. Accordingly we have to fix and=
 propagate it identifying =0Athe owner also.</span></div><div style=3D"colo=
r:rgb(0, 0, 0);font-size:18.6667px;font-family:times new roman, new york, t=
imes, serif;background-color:transparent;font-style:normal;"><br><span></sp=
an></div><div style=3D"color:rgb(0, 0, 0);font-size:18.6667px;font-family:t=
imes new roman, new york, times, serif;background-color:transparent;font-st=
yle:normal;"><span>But how are we suppose to test out the same - where are =
the test cases and process to execute them?</span></div><div style=3D"color=
:rgb(0, 0, 0);font-size:18.6667px;font-family:times new roman, new york, ti=
mes, serif;background-color:transparent;font-style:normal;"><br><span></spa=
n></div><div style=3D"color:rgb(0, 0, 0);font-size:18.6667px;font-family:ti=
mes new roman, new york, times, serif;background-color:transparent;font-sty=
le:normal;"><span>Regards,</span></div><div style=3D"color:rgb(0, 0, 0);fon=
t-size:18.6667px;font-family:times new roman, new york, times,
 serif;background-color:transparent;font-style:normal;"><span>Prakash</span=
></div><div><span><br></span></div><div style=3D"display: block;" class=3D"=
yahoo_quoted"> <br> <br> <div style=3D"font-family: times new roman, new yo=
rk, times, serif; font-size: 14pt;"> <div style=3D"font-family: times new r=
oman, new york, times, serif; font-size: 12pt;"> <div dir=3D"ltr"> <font fa=
ce=3D"Arial" size=3D"2"> On Monday, 21 October 2013 7:12 AM, Dave Chinner &=
lt;david@fromorbit.com&gt; wrote:<br> </font> </div>  <div class=3D"y_msg_c=
ontainer">On Sat, Oct 19, 2013 at 07:59:55PM +0900, Akira Hayakawa wrote:<b=
r>&gt; Dave,<br>&gt; <br>&gt; # -EIO retuned corrupts XFS<br>&gt; I turned =
up<br>&gt; lockdep, frame pointer, xfs debug<br>&gt; and also changed to 3.=
12.0-rc5 from rc1.<br>&gt; <br>&gt; What's changed is that<br>&gt; the prob=
lem we discussed in previous mails<br>&gt; *never* reproduce.<br>&gt; <br>&=
gt; However, if I turn off the lockdep only<br>&gt; it hangs up by setting =
blockup
 to 1 and then to 0 after that.<br><br>Which indicates that the corruption =
is likely to be caused by a race<br>condition, and that adding lockdep slow=
s things down enough to<br>change the timing and hence not hit the race con=
dition...<br><br>e.g. the use after free that causes the memory corruption =
now occurs<br>after the critical point where XFS can get stuck on it.<br><b=
r>&gt; The underlying device once became dead revives<br>&gt; may confuse t=
he filesystem but<br>&gt; this looks not related to locking things.<br>&gt;=
 This problem may be producible using dm-flakey.<br><br>I use dm-flakey qui=
te a bit, and I haven't seen this....<br><br>&gt; This behavior is not repr=
oducible with ext4.<br>&gt; <br>&gt; --------------------------------------=
------<br>&gt; <a ymailto=3D"mailto:root@Lyle" href=3D"mailto:root@Lyle">ro=
ot@Lyle</a>:/home/akira# virsh console Hercules<br>&gt; Connected to domain=
 Hercules<br>&gt; Escape character is ^]<br>&gt; [&nbsp; 143.042980]
 device-mapper: writeboost: <a ymailto=3D"mailto:info@modulator_proc" href=
=3D"mailto:info@modulator_proc">info@modulator_proc</a>() reactivated after=
 blockup<br>&gt; [&nbsp; 143.042999] device-mapper: writeboost: <a ymailto=
=3D"mailto:info@dm_safe_io_internal" href=3D"mailto:info@dm_safe_io_interna=
l">info@dm_safe_io_internal</a>() reactivated after blockup<br>&gt; [&nbsp;=
 143.043006] device-mapper: writeboost: <a ymailto=3D"mailto:info@migrate_p=
roc" href=3D"mailto:info@migrate_proc">info@migrate_proc</a>() reactivated =
after blockup<br>&gt; [&nbsp; 143.045328] XFS: metadata I/O error: block 0x=
300d0f ("xlog_iodone") error 5 numblks 64<br>&gt; [&nbsp; 143.045333] XFS: =
xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.&=
nbsp; Return address =3D 0xffffffffa0430f9c<br>&gt; [&nbsp; 143.045335] XFS=
: Log I/O Error Detected.&nbsp; Shutting down filesystem<br>&gt; [&nbsp; 14=
3.045335] XFS: Please umount the filesystem and rectify the problem(s)<br>&=
gt;
 [&nbsp; 143.045338] XFS: Assertion failed: atomic_read(&amp;iclog-&gt;ic_r=
efcnt) =3D=3D 0, file: fs/xfs/xfs_log.c, line: 2751<br>.....<br>&gt; [&nbsp=
; 143.045465] Workqueue: xfslogd xfs_buf_iodone_work [xfs]<br>.....<br>&gt;=
 [&nbsp; 143.045558]&nbsp; [&lt;ffffffffa0430ed1&gt;] xlog_state_done_synci=
ng+0x6d/0xe4 [xfs]<br>&gt; [&nbsp; 143.045590]&nbsp; [&lt;ffffffffa0431018&=
gt;] xlog_iodone+0xd0/0xd9 [xfs]<br>&gt; [&nbsp; 143.045609]&nbsp; [&lt;fff=
fffffa03d834f&gt;] xfs_buf_iodone_work+0x57/0xa2 [xfs]<br>&gt; [&nbsp; 143.=
045627]&nbsp; [&lt;ffffffff8104f21a&gt;] process_one_work+0x18b/0x297<br>&g=
t; [&nbsp; 143.045631]&nbsp; [&lt;ffffffff8104f6e6&gt;] worker_thread+0x12e=
/0x1fb<br>&gt; [&nbsp; 143.045634]&nbsp; [&lt;ffffffff8104f5b8&gt;] ? rescu=
er_thread+0x268/0x268<br>&gt; [&nbsp; 143.045638]&nbsp; [&lt;ffffffff810545=
07&gt;] kthread+0x88/0x90<br>&gt; [&nbsp; 143.045641]&nbsp; [&lt;ffffffff81=
05447f&gt;] ? __kthread_parkme+0x60/0x60<br><br>So that has got through
 xlog_iodone() and has found that the<br>reference count of the iclog was n=
ot zero when it went to run the<br>log IO completion callbacks.<br><br>We a=
sserted that the reference count was zero before issuing the IO,<br>and we =
only ever increment the reference count when the iclog is in<br>an active s=
tate. We cannot increment the reference count while the<br>log is under IO =
because the state of the iclog is "syncing", not<br>"active".<br><br>Once t=
he log is shut down, the iclog state goes to<br>XLOG_STATE_IOERROR and neve=
r goes out of that state. The assert just<br>prior to the one that tripped =
above indicates that we are either in<br>an ACTIVE state or IOERROR:<br><br=
>&nbsp; &nbsp; &nbsp; &nbsp; ASSERT(iclog-&gt;ic_state =3D=3D XLOG_STATE_SY=
NCING ||<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  iclog-&gt;ic_=
state =3D=3D XLOG_STATE_IOERROR);<br>&gt;&gt;&gt;&gt;&gt;&gt;&nbsp; ASSERT(=
atomic_read(&amp;iclog-&gt;ic_refcnt) =3D=3D 0);<br><br>It was the second a=
ssert
 that failed, and hence it's clear that<br>in either state the reference co=
unt cannot be incremented until the<br>IO is fully completed and it transit=
ioned back the active state.<br><br>&gt; [&nbsp; 143.045333] XFS: xfs_do_fo=
rce_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.&nbsp; Ret=
urn address =3D 0xffffffffa0430f9c<br><br>This indicates that the shutdown =
was called from xlog_iodone() as a<br>result of an IO error on the iclog bu=
ffer, and the call to<br>xlog_state_done_syncing() happens 5 lines of code =
later, which<br>immediately assert fails with a corrupt iclog state.<br><br=
>Because we shutdown with SHUTDOWN_LOG_IO_ERROR set, we call into<br>xfs_lo=
g_force_umount() with logerror =3D true. This first call ends up<br>setting=
 the log flag XLOG_IO_ERROR, then calling<br>xlog_state_ioerror() which set=
s ic_state on all iclogs to<br>XLOG_STATE_IOERROR.<br><br>The shutdown then=
 runs xlog_state_do_callback() which aborts the<br>completions on all
 the iclogs that have callbacks attached, and<br>wakes anyone waiting on lo=
g space or log forces so they can get<br>errors returned to them.<br><br>We=
 now return to xlog_iodone() in a shutdown state, with all the<br>iclog buf=
fers in with ic_state =3D XLOG_STATE_IOERROR. So, there is<br>absolutely no=
 opportunity for anyone to take a new reference to the<br>iclog in the 10 *=
microseconds* between the IO error being detected,<br>the shutdown being pr=
ocessed and the call to<br>xlog_state_done_syncing() where the assert fails=
. At this point, I<br>cannot see how this can occur in the XFS code.<br><br=
>Indeed, I can trigger this error path easily under heavy load just<br>usin=
g the godown utility in xfstests:<br><br>[1044535.986040] XFS (vdc): Mounti=
ng Filesystem<br>[1044536.040630] XFS (vdc): Ending clean mount<br>[1044536=
.059299] XFS: Clearing xfsstats<br># src/xfstests-dev/src/godown -v /mnt/sc=
ratch<br>Opening "/mnt/scratch"<br>Calling
 XFS_IOC_GOINGDOWN<br>[1044553.342767] XFS (vdc): metadata I/O error: block=
 0x19000c2e98 ("xlog_iodone") error 5 numblks 512<br>[1044553.345993] XFS (=
vdc): xfs_do_force_shutdown(0x2) called from line 1171 of file fs/xfs/xfs_l=
og.c.&nbsp; Return address =3D 0xffffffff814e61ad<br>#[1044554.136965] XFS =
(vdc): xfs_log_force: error 5 returned.<br>[1044554.154892] XFS: Clearing x=
fsstats<br>[1044566.108484] XFS (vdc): xfs_log_force: error 5 returned.<br>=
[1044596.188515] XFS (vdc): xfs_log_force: error 5 returned.<br>[1044626.26=
8166] XFS (vdc): xfs_log_force: error 5 returned.<br>[1044656.348146] XFS (=
vdc): xfs_log_force: error 5 returned.<br><br>IOWs, this looks like somethi=
ng is corrupting the state of the log<br>*before* the xlog_iodone() callbac=
k is being run. i.e. it is in a<br>valid state before IO dispatch and it's =
in a corrupt state on IO<br>completion despite XFS having *never touched th=
at state* during the<br>IO.<br><br>Indeed, this is a different issue
 to the one you posted<br>earlier, which was the AIL lock (which is in a di=
fferent XFS<br>structure) had not been released. Again, I couldn't see how =
that<br>could occur, and we're now seeing a pattern of random structures<br=
>being corrupted. Hmmm, looking at pahole:<br><br>atomic_t&nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  ic_refcnt;&nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; /*&nbsp;  192&nbsp; &nbsp;  4 */<br><br>spinlock_t&=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  xa_lock;&nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /*&nbsp; &nbsp; 64&nbsp; &nbsp;  2 */=
<br><br>Both the items that were corrupted are on the first word of a<br>ca=
cheline. That further points to memory corruption of some kind...<br><br>IO=
Ws, the more I look, the more this looks like memory corruption is<br>the c=
ause of the problems. The only unusual thing that is happening<br>is an err=
or handling path in a brand new block device driver is<br>being run
 immediately before the memory corruption causes problems,<br>and that tend=
s to indicate that this corruption is not caused by<br>XFS...<br><br>&gt; M=
y Idea:<br>&gt; - If something problematic happens in underlying devices<br=
>&gt;&nbsp;  writeboost device returns -EIO on any requests and<br>&gt;&nbs=
p;  stop all the daemons<br>....<br>&gt; - I will not remove `blockup`.<br>=
&gt;&nbsp;  Yes. If the problem is in hardware it is very difficult<br>&gt;=
&nbsp;  to recover.<br>&gt;&nbsp;  However, leaving a chance for recovering=
 the device is<br>&gt;&nbsp;  at least better than just shutdown the device=
<br>&gt;&nbsp;  if it doesn't pollute the code so much.<br>&gt;&nbsp;  So, =
I will leave this option.<br><br>It doesn't matter whether the underlying h=
ardware might be able to<br>recover - once you've send EIOs during IO compl=
etion that<br>data/metadata is considered *unrecoverable* and so the filesy=
stem<br>will end up inconsistent or the *user will lose data* as a
 result.<br><br>IOWs, your idea is flawed, will not work and will result in=
<br>data/filesystem loss when used. You cannot call this a "recovery<br>mec=
hanism" because it simply isn't.<br><br>&gt; BTW, what do you mean by the w=
ord "fatal"?<br><br>"He suffered a fatal gunshot wound to the head."<br><br=
>i.e. the person is *dead* and life is *unrecoverable*.<br><br>That's what =
you are doing here - returning EIOs to IOs in progress<br>is effectively sh=
ooting the fileystem (and user data) in the<br>head.....<br><br>Cheers,<br>=
<br>Dave.<br><br>-- <br>Dave Chinner<br><a ymailto=3D"mailto:david@fromorbi=
t.com" href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>_____=
__________________________________________<br>devel mailing list<br><a ymai=
lto=3D"mailto:devel@linuxdriverproject.org" href=3D"mailto:devel@linuxdrive=
rproject.org">devel@linuxdriverproject.org</a><br><a href=3D"http://driverd=
ev.linuxdriverproject.org/mailman/listinfo/driverdev-devel"
 target=3D"_blank">http://driverdev.linuxdriverproject.org/mailman/listinfo=
/driverdev-devel</a><br><br><br></div>  </div> </div>  </div> </div></body>=
</html>
---929976460-1502260485-1382320800=:74237--


--===============8999251103929737543==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8999251103929737543==--
