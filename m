From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: Multipath ID not equal to LUN scsi ID
Date: Mon, 10 Jul 2017 15:02:33 +0200
Message-ID: <0fff72eb-312f-5a77-e276-7bf607053396@linux.vnet.ibm.com>
References: <2017071017581348809421@huayun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2017071017581348809421@huayun.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 07/10/2017 11:58 AM, liuqing@huayun.com wrote:
> Dear list,
> We have a FC storage and using multipathd to manager the FC paths.
> I've met an issue in this environment. The following is how to recreate t=
he issue.
> =

> =3D=3D=3D=3D=3D=3D=3D
> 1. Map a LUN to host with LUN ID 0,
> 2. rescan fc_host, a new path will be found by multipath.
> 3. Unmap LUN 0.  path will failed as following.
> [root@localhost sys]# multipath -ll
> Jul 10 18:41:50 | sdp: couldn't get asymmetric access state
> Jul 10 18:41:50 | sdq: couldn't get asymmetric access state
> 36005076300810eadf800000000000156 dm-3 IBM,2145
> size=3D8.0G features=3D'2 queue_if_no_path retain_attached_hw_handler' hw=
handler=3D'1 alua' wp=3Drw
> |-+- policy=3D'service-time 0' prio=3D0 status=3Denabled
> | `- 2:0:0:0 sdp 8:240 failed faulty running
> `-+- policy=3D'service-time 0' prio=3D0 status=3Denabled
>    `- 2:0:1:0 sdq 65:0  failed faulty running
> 4. Map another LUN which have different ID_SERIAL but with the same LUN I=
D(0).

Did you "rescan" the SCSI device via sysfs to let Linux know that this =

is now in fact a different device?

AFAIK, Linux decodes SCSI sense data for LUNs remapped on the storage =

target and emits a udev event, but I'm not aware of any default udev =

rule that would actually react. The kernel itself does not react other =

than creating the uevent.

> Multipath(check_path function) will set the paths up, tur checker will su=
ccessfully test the LUN.
> [root@localhost sys]# /lib/udev/scsi_id --whitelisted --replace-whitespac=
e --device=3D/dev/mapper/36005076300810eadf800000000000156
> 36005076300810eadf800000000000155
>   I think this is not right, although I do not remove the device by 'echo=
 1> /sys/block/sdp/device/delete'. A multipath is identified by LUN scsi ID=
, in this situation the multipath
> ID is not equal to LUN scsi ID. And if I add the previous LUN back, the p=
aths will also be added to that multipath id(36005076300810eadf800000000000=
156).
> =

> Any suggestion on how to make it create a new node in /dev with correct s=
csi ID? Thanks.

If you assume the old mapped volume would be gone, you could also flush =

the mpath map with the old WWID.

After the SCSI device rescan it should create a new map with the new WWID.

> =

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [root@localhost sys]# cat /etc/multipath.conf
> defaults {
>      features "0"
>      no_path_retry           queue
>      getuid_callout "/lib/udev/scsi_id --whitelisted --replace-whitespace=
 --device=3D/dev/%n"

IIRC, using an explicit getuid_callout has been deprecated in later =

releases of multipath tools and it would use builtin code to determine =

the necessary information, potentially even using inquiry data cached in =

the kernel (exported via sysfs).

If your toolchain is recent enough, would it work without this conf setting?

> }
> blacklist {
>      devnode "sd[a-m]"
> }

-- =

Mit freundlichen Gr=FC=DFen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
