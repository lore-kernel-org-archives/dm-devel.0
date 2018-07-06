From: Ryan Norwood <ryan.p.norwood@gmail.com>
Subject: raid 5 recovery kernel warnings
Date: Fri, 6 Jul 2018 14:35:40 -0400
Message-ID: <CAFTvtQ=oUD9+mdkqekud5Mn4LuzFSr9joKudtpY+URLfxcNnGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7190749506173626471=="
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

--===============7190749506173626471==
Content-Type: multipart/alternative; boundary="000000000000fd22c3057058ee54"

--000000000000fd22c3057058ee54
Content-Type: text/plain; charset="UTF-8"

We hit a RAID 5 issue during failure testing that caused a flood of kernel
warnings and minor but problematic data corruption.

Setup: RAID 5 with 7 drives + 1 hot spare
OS: RHEL 7.5
Kernel: linux-3.10.0-862.3.3.el7

Scenario: We pulled a single data drive and the array automatically started
its recovery process using the hot spare. We immediately became overwhelmed
with the following kernel messages which choked the system.  Setting
kernel.printk="2 4 1 7" did nothing to stop the messages. Once the repair
was complete the machine became usable again. Once we were online again we
noticed we had some minor data corruption.

We have been unable to reproduce this issue again.

[258091.028244] Workqueue: raid5wq raid5_do_work [raid456]
[258091.028245] Call Trace:
[258091.028248]  [<ffffffff9fb0e78e>] dump_stack+0x19/0x1b
[258091.028250]  [<ffffffff9f491998>] __warn+0xd8/0x100
[258091.028253]  [<ffffffff9f491add>] warn_slowpath_null+0x1d/0x20
[258091.028257]  [<ffffffffc0834677>] handle_stripe+0x2367/0x23f0 [raid456]
[258091.028258] systemd-journald[166084]: /dev/kmsg buffer overrun, some
messages lost.
[258091.028262]  [<ffffffff9f72bad1>] ?
blk_mq_sched_dispatch_requests+0x181/0x1c0
[258091.028266]  [<ffffffffc0834aad>]
handle_active_stripes.isra.55+0x3ad/0x530 [raid456]
[258091.028271]  [<ffffffffc08354bf>] raid5_do_work+0x9f/0x150 [raid456]
[258091.028271] systemd-journald[166084]: /dev/kmsg buffer overrun, some
messages lost.
[258091.028274]  [<ffffffff9f4b312f>] process_one_work+0x17f/0x440
[258091.028276]  [<ffffffff9f4b3df6>] worker_thread+0x126/0x3c0
[258091.028279]  [<ffffffff9f4b3cd0>] ? manage_workers.isra.24+0x2a0/0x2a0
[258091.028280]  [<ffffffff9f4bb161>] kthread+0xd1/0xe0
[258091.028281] systemd-journald[166084]: /dev/kmsg buffer overrun, some
messages lost.
[258091.028284]  [<ffffffff9f4bb090>] ? insert_kthread_work+0x40/0x40
[258091.028287]  [<ffffffff9fb2065d>] ret_from_fork_nospec_begin+0x7/0x21
[258091.028290]  [<ffffffff9f4bb090>] ? insert_kthread_work+0x40/0x40
[258091.028291] systemd-journald[166084]: /dev/kmsg buffer overrun, some
messages lost.
[258091.028292] ---[ end trace 3232975a123b52bf ]---
[258091.028297] ------------[ cut here ]------------
[258091.028301] *WARNING: CPU: 4 PID: 155463 at drivers/md/raid5.c:4672*
handle_stripe+0x2367/0x23f0 [raid456]

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid0]
md126 : active raid0 md127[0]
      4657247232 blocks super 1.2 512k chunks

md127 : active raid5 dm-7[7](R) dm-6[6](F) dm-5[5] dm-4[4] dm-3[3] dm-2[2]
dm-1[1] dm-0[0]
      4657379328 blocks super 1.2 level 5, 16k chunk, algorithm 2 [7/6]
[UUUUUU_]
      [=>...................]  recovery =  9.6% (75100712/776229888)
finish=601.8min speed=19414K/sec
      bitmap: 1/6 pages [4KB], 65536KB chunk

unused devices: <none>

*drivers/md/raid5.c:4672*

    /* maybe we need to check and possibly fix the parity for this stripe
     * Any reads will already have been scheduled, so we just see if enough
     * data is available.  The parity check is held off while parity
     * dependent operations are in flight.
     */
    if (sh->check_state ||
        (s.syncing && s.locked == 0 &&
         !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
         !test_bit(STRIPE_INSYNC, &sh->state))) {
        if (conf->level == 6)
            handle_parity_checks6(conf, sh, &s, disks);
        else
            handle_parity_checks5(conf, sh, &s, disks);
    }

    if ((s.replacing || s.syncing) && s.locked == 0
        && !test_bit(STRIPE_COMPUTE_RUN, &sh->state)
        && !test_bit(STRIPE_REPLACED, &sh->state)) {
        /* Write out to replacement devices where possible */
        for (i = 0; i < conf->raid_disks; i++)
            if (test_bit(R5_NeedReplace, &sh->dev[i].flags)) {
                *WARN_ON(!test_bit(R5_UPTODATE, &sh->dev[i].flags));*
                set_bit(R5_WantReplace, &sh->dev[i].flags);
                set_bit(R5_LOCKED, &sh->dev[i].flags);
                s.locked++;
            }
        if (s.replacing)
            set_bit(STRIPE_INSYNC, &sh->state);
        set_bit(STRIPE_REPLACED, &sh->state);
    }

--000000000000fd22c3057058ee54
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>We hit a RAID 5 issue during failure testing that cau=
sed a flood of kernel warnings and minor but problematic data corruption.=
=C2=A0</div><div><br></div><div>Setup: RAID 5 with 7 drives=C2=A0+ 1 hot sp=
are=C2=A0</div><div>OS: RHEL 7.5</div><div>Kernel:=C2=A0linux-3.10.0-862.3.=
3.el7</div><div><br></div><div>Scenario: We pulled a single data drive and =
the array automatically started its recovery process using the hot spare. W=
e immediately became overwhelmed with the following kernel messages which c=
hoked the system.=C2=A0 Setting kernel.printk=3D&quot;2 4 1 7&quot;=C2=A0di=
d nothing to stop the messages. Once the repair was complete the machine be=
came usable again. Once we were online again we noticed we had some minor d=
ata corruption.</div><div><br></div><div>We have been unable to reproduce t=
his issue again.</div><div><br></div><div><div>[258091.028244] Workqueue: r=
aid5wq raid5_do_work [raid456]</div><div>[258091.028245] Call Trace:</div><=
div>[258091.028248] =C2=A0[&lt;ffffffff9fb0e78e&gt;] dump_stack+0x19/0x1b</=
div><div>[258091.028250] =C2=A0[&lt;ffffffff9f491998&gt;] __warn+0xd8/0x100=
</div><div>[258091.028253] =C2=A0[&lt;ffffffff9f491add&gt;] warn_slowpath_n=
ull+0x1d/0x20</div><div>[258091.028257] =C2=A0[&lt;ffffffffc0834677&gt;] ha=
ndle_stripe+0x2367/0x23f0 [raid456]</div><div>[258091.028258] systemd-journ=
ald[166084]: /dev/kmsg buffer overrun, some messages lost.</div><div>[25809=
1.028262] =C2=A0[&lt;ffffffff9f72bad1&gt;] ? blk_mq_sched_dispatch_requests=
+0x181/0x1c0</div><div>[258091.028266] =C2=A0[&lt;ffffffffc0834aad&gt;] han=
dle_active_stripes.isra.55+0x3ad/0x530 [raid456]</div><div>[258091.028271] =
=C2=A0[&lt;ffffffffc08354bf&gt;] raid5_do_work+0x9f/0x150 [raid456]</div><d=
iv>[258091.028271] systemd-journald[166084]: /dev/kmsg buffer overrun, some=
 messages lost.</div><div>[258091.028274] =C2=A0[&lt;ffffffff9f4b312f&gt;] =
process_one_work+0x17f/0x440</div><div>[258091.028276] =C2=A0[&lt;ffffffff9=
f4b3df6&gt;] worker_thread+0x126/0x3c0</div><div>[258091.028279] =C2=A0[&lt=
;ffffffff9f4b3cd0&gt;] ? manage_workers.isra.24+0x2a0/0x2a0</div><div>[2580=
91.028280] =C2=A0[&lt;ffffffff9f4bb161&gt;] kthread+0xd1/0xe0</div><div>[25=
8091.028281] systemd-journald[166084]: /dev/kmsg buffer overrun, some messa=
ges lost.</div><div>[258091.028284] =C2=A0[&lt;ffffffff9f4bb090&gt;] ? inse=
rt_kthread_work+0x40/0x40</div><div>[258091.028287] =C2=A0[&lt;ffffffff9fb2=
065d&gt;] ret_from_fork_nospec_begin+0x7/0x21</div><div>[258091.028290] =C2=
=A0[&lt;ffffffff9f4bb090&gt;] ? insert_kthread_work+0x40/0x40</div><div>[25=
8091.028291] systemd-journald[166084]: /dev/kmsg buffer overrun, some messa=
ges lost.</div><div>[258091.028292] ---[ end trace 3232975a123b52bf ]---</d=
iv><div>[258091.028297] ------------[ cut here ]------------</div><div>[258=
091.028301] <b>WARNING: CPU: 4 PID: 155463 at drivers/md/raid5.c:4672</b> h=
andle_stripe+0x2367/0x23f0 [raid456]</div></div><div><br></div><div><div># =
cat /proc/mdstat=C2=A0</div><div>Personalities : [raid6] [raid5] [raid4] [r=
aid0]=C2=A0</div><div>md126 : active raid0 md127[0]</div><div>=C2=A0 =C2=A0=
 =C2=A0 4657247232 blocks super 1.2 512k chunks</div><div>=C2=A0 =C2=A0 =C2=
=A0=C2=A0</div><div>md127 : active raid5 dm-7[7](R) dm-6[6](F) dm-5[5] dm-4=
[4] dm-3[3] dm-2[2] dm-1[1] dm-0[0]</div><div>=C2=A0 =C2=A0 =C2=A0 46573793=
28 blocks super 1.2 level 5, 16k chunk, algorithm 2 [7/6] [UUUUUU_]</div><d=
iv>=C2=A0 =C2=A0 =C2=A0 [=3D&gt;...................] =C2=A0recovery =3D =C2=
=A09.6% (75100712/776229888) finish=3D601.8min speed=3D19414K/sec</div><div=
>=C2=A0 =C2=A0 =C2=A0 bitmap: 1/6 pages [4KB], 65536KB chunk</div><div><br>=
</div><div>unused devices: &lt;none&gt;</div></div><div><br></div><div><b>d=
rivers/md/raid5.c:4672</b><br></div><div><b><br></b></div><div>=C2=A0 =C2=
=A0 /* maybe we need to check and possibly fix the parity for this stripe</=
div><div>=C2=A0 =C2=A0 =C2=A0* Any reads will already have been scheduled, =
so we just see if enough</div><div>=C2=A0 =C2=A0 =C2=A0* data is available.=
=C2=A0 The parity check is held off while parity</div><div>=C2=A0 =C2=A0 =
=C2=A0* dependent operations are in flight.</div><div>=C2=A0 =C2=A0 =C2=A0*=
/</div><div>=C2=A0 =C2=A0 if (sh-&gt;check_state ||</div><div>=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 (s.syncing &amp;&amp; s.locked =3D=3D 0 &amp;&amp;</div><div=
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!test_bit(STRIPE_COMPUTE_RUN, &amp;sh-&g=
t;state) &amp;&amp;</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!test_bit(S=
TRIPE_INSYNC, &amp;sh-&gt;state))) {</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
if (conf-&gt;level =3D=3D 6)</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 handle_parity_checks6(conf, sh, &amp;s, disks);</div><div>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 else</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
handle_parity_checks5(conf, sh, &amp;s, disks);</div><div>=C2=A0 =C2=A0 }</=
div><div><br></div><div>=C2=A0 =C2=A0 if ((s.replacing || s.syncing) &amp;&=
amp; s.locked =3D=3D 0</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;&amp; !te=
st_bit(STRIPE_COMPUTE_RUN, &amp;sh-&gt;state)</div><div>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 &amp;&amp; !test_bit(STRIPE_REPLACED, &amp;sh-&gt;state)) {</div=
><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Write out to replacement devices where=
 possible */</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt; con=
f-&gt;raid_disks; i++)</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
if (test_bit(R5_NeedReplace, &amp;sh-&gt;dev[i].flags)) {</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 <b>WARN_ON(!test_bit(R5_UP=
TODATE, &amp;sh-&gt;dev[i].flags));</b></div><div>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 set_bit(R5_WantReplace, &amp;sh-&gt;dev[i].=
flags);</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 s=
et_bit(R5_LOCKED, &amp;sh-&gt;dev[i].flags);</div><div>=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 s.locked++;</div><div>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 }</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (s.repl=
acing)</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 set_bit(STRIPE_I=
NSYNC, &amp;sh-&gt;state);</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 set_bit(ST=
RIPE_REPLACED, &amp;sh-&gt;state);</div><div>=C2=A0 =C2=A0 }</div><div><br>=
</div></div>

--000000000000fd22c3057058ee54--


--===============7190749506173626471==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7190749506173626471==--
