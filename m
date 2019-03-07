From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-crypt] Dm-integrity freeze
Date: Thu, 7 Mar 2019 17:37:10 +0100
Message-ID: <9d19e5b1-b76f-27da-fa4a-f3a83e6e2791@gmail.com>
References: <5D8A23C5-B6AD-48EA-B0AD-AD1BD1A2B97B@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5D8A23C5-B6AD-48EA-B0AD-AD1BD1A2B97B@gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Victor Helmholtz <victor.helmholtz@gmail.com>, dm-crypt@saout.de
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Hi,

from the full log it seems that it is stuck in tgtd (iSCSI).

Anyway, this is device-mapper, dm-devel is better list here.
(added to cc + Mikulas)

m.

On 3/7/19 4:26 PM, Victor Helmholtz wrote:
> Hi
> =

> I have recently had a problem with my server: all writes to RAID drives w=
ere frozen and I had to force-reboot it. I looked at kernel logs and I thin=
k dm-integrity might be source of the problem. Could anyone help me underst=
and meaning of following messages (this message was repeated 8 times, full =
kernel log is here: https://pastebin.com/DMgMtNJq ):
> =

> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.498048] INFO: task =
kworker/0:112:26760 blocked for more than 120 seconds.
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.499784] =A0 =A0 =A0=
 Not tainted 4.19.0-2-amd64 #1 Debian 4.19.16-1
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.501222] "echo 0 > /=
proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.503095] kworker/0:1=
12 =A0 D =A0 =A00 26760 =A0 =A0 =A02 0x80000080
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.504424] Workqueue: =
dm-integrity-metadata integrity_bio_wait [dm_integrity]
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.506149] Call Trace:
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.506782] =A0? __sche=
dule+0x2a2/0x870
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.507706] =A0schedule=
+0x28/0x80
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.508484] =A0io_sched=
ule+0x12/0x40
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.509321] =A0wait_and=
_add_new_range+0x89/0xa0 [dm_integrity]
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.510709] =A0dm_integ=
rity_map_continue+0xe71/0x1020 [dm_integrity]
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.512193] =A0? __swit=
ch_to_asm+0x40/0x70
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.513149] =A0? __swit=
ch_to_asm+0x34/0x70
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.514105] =A0? __swit=
ch_to_asm+0x40/0x70
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.515088] =A0? __swit=
ch_to_asm+0x40/0x70
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.516048] =A0? __swit=
ch_to_asm+0x34/0x70
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.517000] =A0? __swit=
ch_to_asm+0x40/0x70
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.517978] =A0? __swit=
ch_to_asm+0x34/0x70
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.518968] =A0? __swit=
ch_to_asm+0x34/0x70
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.519926] =A0? __swit=
ch_to+0x8c/0x440
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.520822] =A0process_=
one_work+0x1a7/0x3a0
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.521798] =A0worker_t=
hread+0x30/0x390
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.522725] =A0? pwq_un=
bound_release_workfn+0xd0/0xd0
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.523901] =A0kthread+=
0x112/0x130
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.524691] =A0? kthrea=
d_bind+0x30/0x30
> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.525584] =A0ret_from=
_fork+0x35/0x40
> =

> Is this a bug in kernel or do I have some problems with hardware?
> =

> Regards
> Victor
> =

> _______________________________________________
> dm-crypt mailing list
> dm-crypt@saout.de
> https://www.saout.de/mailman/listinfo/dm-crypt
> =
