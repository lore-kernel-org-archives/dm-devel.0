From: Christian May <christian_may@de.ibm.com>
Subject: Re: 2.6.32.28 - md resync + pvmove - crash
Date: Thu, 19 May 2011 15:56:35 +0200
Message-ID: <OFB3220E2E.60BE18D4-ONC1257895.004BE5D4-C1257895.004C97B5@de.ibm.com>
References: <20110507103907.GA2712@nik-comp.lan>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6083439272338443202=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110507103907.GA2712@nik-comp.lan>
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
List-Id: dm-devel.ids

This is a multipart message in MIME format.
--===============6083439272338443202==
Content-Type: multipart/alternative;
	boundary="=_alternative 004C31DAC1257895_="

This is a multipart message in MIME format.
--=_alternative 004C31DAC1257895_=
Content-Type: text/plain; charset="US-ASCII"

Hi,

currently I have a ppc64 IBM blade running with RHEL6.1 RC2 
(2.6.32-131.0.13.el6.ppc64). Twelve multipath devices are attached and I/O 
is running.
I've checked dmesg and found:

[root@elm8a211 ~]# dmesg
INFO: task kjournald:7938 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kjournald     D 0000000000000000     0  7938      2 0x00008080
Call Trace:
[c0000003c82f3420] [c0000003c82f34d0] 0xc0000003c82f34d0 (unreliable)
[c0000003c82f35f0] [c000000000014288] .__switch_to+0xf8/0x1d0
[c0000003c82f3680] [c00000000059cc18] .schedule+0x408/0xd30
[c0000003c82f3960] [c00000000059d5d0] .io_schedule+0x90/0x110
[c0000003c82f39f0] [c0000000001fc2f8] .sync_buffer+0x68/0x80
[c0000003c82f3a60] [c00000000059e104] .__wait_on_bit+0xb4/0x130
[c0000003c82f3b10] [c00000000059e1f0] .out_of_line_wait_on_bit+0x70/0x90
[c0000003c82f3bf0] [c0000000001fc1b0] .__wait_on_buffer+0x30/0x50
[c0000003c82f3c70] [d000000004043bc4] 
.journal_commit_transaction+0x624/0x1630 [jbd]
[c0000003c82f3de0] [d0000000040488fc] .kjournald+0x11c/0x330 [jbd]
[c0000003c82f3ed0] [c0000000000bb02c] .kthread+0xbc/0xd0
[c0000003c82f3f90] [c0000000000323f4] .kernel_thread+0x54/0x70
[root@elm8a211 ~]# 

I have no idea where it's coming from..system i still up'n running.


Best regards,

Christian May
IBM
 
--=_alternative 004C31DAC1257895_=
Content-Type: text/html; charset="US-ASCII"

<font size=2 face="sans-serif">Hi,</font>
<br>
<br><font size=2 face="sans-serif">currently I have a ppc64 IBM blade running
with RHEL6.1 RC2 (2.6.32-131.0.13.el6.ppc64). Twelve multipath devices
are attached and I/O is running.</font>
<br><font size=2 face="sans-serif">I've checked dmesg and found:<br>
<br>
[root@elm8a211 ~]# dmesg</font>
<br><font size=2 face="sans-serif">INFO: task kjournald:7938 blocked for
more than 120 seconds.</font>
<br><font size=2 face="sans-serif">&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot;
disables this message.</font>
<br><font size=2 face="sans-serif">kjournald &nbsp; &nbsp; D 0000000000000000
&nbsp; &nbsp; 0 &nbsp;7938 &nbsp; &nbsp; &nbsp;2 0x00008080</font>
<br><font size=2 face="sans-serif">Call Trace:</font>
<br><font size=2 face="sans-serif">[c0000003c82f3420] [c0000003c82f34d0]
0xc0000003c82f34d0 (unreliable)</font>
<br><font size=2 face="sans-serif">[c0000003c82f35f0] [c000000000014288]
.__switch_to+0xf8/0x1d0</font>
<br><font size=2 face="sans-serif">[c0000003c82f3680] [c00000000059cc18]
.schedule+0x408/0xd30</font>
<br><font size=2 face="sans-serif">[c0000003c82f3960] [c00000000059d5d0]
.io_schedule+0x90/0x110</font>
<br><font size=2 face="sans-serif">[c0000003c82f39f0] [c0000000001fc2f8]
.sync_buffer+0x68/0x80</font>
<br><font size=2 face="sans-serif">[c0000003c82f3a60] [c00000000059e104]
.__wait_on_bit+0xb4/0x130</font>
<br><font size=2 face="sans-serif">[c0000003c82f3b10] [c00000000059e1f0]
.out_of_line_wait_on_bit+0x70/0x90</font>
<br><font size=2 face="sans-serif">[c0000003c82f3bf0] [c0000000001fc1b0]
.__wait_on_buffer+0x30/0x50</font>
<br><font size=2 face="sans-serif">[c0000003c82f3c70] [d000000004043bc4]
.journal_commit_transaction+0x624/0x1630 [jbd]</font>
<br><font size=2 face="sans-serif">[c0000003c82f3de0] [d0000000040488fc]
.kjournald+0x11c/0x330 [jbd]</font>
<br><font size=2 face="sans-serif">[c0000003c82f3ed0] [c0000000000bb02c]
.kthread+0xbc/0xd0</font>
<br><font size=2 face="sans-serif">[c0000003c82f3f90] [c0000000000323f4]
.kernel_thread+0x54/0x70</font>
<br><font size=2 face="sans-serif">[root@elm8a211 ~]# </font>
<br>
<br><font size=2 face="sans-serif">I have no idea where it's coming from..system
i still up'n running.</font>
<br>
<br><font size=2 face="sans-serif"><br>
Best regards,</font>
<br>
<br><font size=2 face="sans-serif">Christian May</font>
<br><font size=2 face="sans-serif">IBM</font>
<p><font size=3>&nbsp;</font>
--=_alternative 004C31DAC1257895_=--


--===============6083439272338443202==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6083439272338443202==--
