From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Dealing with constantly failing paths
Date: Thu, 13 Sep 2018 12:45:25 -0500
Message-ID: <20180913174525.GG3172@octiron.msp.redhat.com>
References: <CAPUHmCoLAEAvJ-4Ftnf+jjDANS=EgXVcA=7dQ0NdFuJbsBzwDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAPUHmCoLAEAvJ-4Ftnf+jjDANS=EgXVcA=7dQ0NdFuJbsBzwDA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?iso-8859-1?Q?=D6zkan_G=F6ksu?= <ozkangksu@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 13, 2018 at 12:42:54PM +0300, =D6zkan G=F6ksu wrote:
>    Hello.=A0
>    I'm sorry to have e-mailed you here but I did not really find the answ=
er.
>    When a disk starts to die slowly multipath starts to Failing & Reinsta=
ting
>    paths and this keeps forever.. (I'm using LSI-3008HBA card with SAS-JB=
OD
>    not FC-Network)
>    Because kernel do not echo to offline faulted disk. This is causing
>    terrible problems to me.
>    I'm using: multipath-tools 0.7.4-1
>    Linux DEV2 4.14.67-1-lts #1=A0
>    Dmesg;
>    =A0 =A0 Sep 13 11:20:17 DEV2 kernel: sd 0:0:190:0: attempting task abo=
rt!
>    scmd(ffff88110e632948)
>    =A0 =A0 Sep 13 11:20:17 DEV2 kernel: sd 0:0:190:0: [sdft] tag#3 CDB:
>    opcode=3D0x0 00 00 00 00 00 00
>    =A0 =A0 Sep 13 11:20:17 DEV2 kernel: scsi target0:0:190: handle(0x0037=
),
>    sas_address(0x5000c50093d4e7c6), phy(38)
>    =A0 =A0 Sep 13 11:20:17 DEV2 kernel: scsi target0:0:190:
>    enclosure_logical_id(0x500304800929ec7f), slot(37)
>    =A0 =A0 Sep 13 11:20:17 DEV2 kernel: scsi target0:0:190: enclosure
>    level(0x0001),connector name(1=A0 =A0)
>    =A0 =A0 Sep 13 11:20:17 DEV2 kernel: sd 0:0:190:0: task abort: SUCCESS
>    scmd(ffff88110e632948)
>    =A0 =A0 Sep 13 11:20:18 DEV2 kernel: device-mapper: multipath: Failing=
 path
>    130:240.
>    =A0 =A0 Sep 13 11:25:34 DEV2 kernel: device-mapper: multipath: Reinsta=
ting
>    path 130:240.
>    Full dmesg example:=A0[1]https://paste.ubuntu.com/p/H9NMWxNfgD/
>    =A0
>    As you can see kernel aborted the mission and after that multipath fai=
led.
>    So I want to get rid of this problem via telling Multipath "do not
>    Reinstate the path".=A0=A0
>    This method will keep dead the zombie disk.
>    If I dont kick the disk out its causing HBA reset and I'm losing all d=
isk
>    in my pool and ZFS pool suspending.
>    I'm not saying this problem related to multipathd, I'm just thinking t=
his
>    will save me.
>    So how can I tell the multipath do not Reinstate X times failed path?
>    Thank you.

In recent releases there are two seperate methods to do this. Both of
them involve setting multiple multipath.conf parameters. The older
method is to set "delay_wait_checks" and "delay_watch_checks". The newer
one is to set "marginal_path_double_failed_time",
"marginal_path_err_sample_time", "marginal_path_err_rate_threshold", and
"marginal_path_err_recheck_gap_time". You can look in the multipath.conf
man page to see if both sets of options are available to you, and how
they work. If the version of the multipath tools you are using has both
sets of options, the "marginal_path_*" options should do a better job at
finding these marginal paths.

-Ben

> =

> References
> =

>    Visible links
>    1. https://paste.ubuntu.com/p/H9NMWxNfgD/

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
