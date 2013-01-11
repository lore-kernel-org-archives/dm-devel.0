From: Hannes Reinecke <hare@suse.de>
Subject: Re: Priozier for remote port on fibre channel devices
Date: Fri, 11 Jan 2013 09:06:55 +0100
Message-ID: <50EFC81F.1070209@suse.de>
References: <OF21470796.D356BC7E-ONC1257AF0.0022D29F-C1257AF0.00278317@continental-corporation.com>
	<50EFBDB0.5010004@suse.de>
	<OF3C233FBC.B29A53C0-ONC1257AF0.002A1FF8-C1257AF0.002AC473@continental-corporation.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF3C233FBC.B29A53C0-ONC1257AF0.002A1FF8-C1257AF0.002AC473@continental-corporation.com>
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

On 01/11/2013 08:47 AM, =

Andreas.Bleischwitz@continental-corporation.com wrote:
> Hello Hannes,
>
> sorry for top-posting, but crappy Notes is not really a good client
> for mailing-list - at least I don't know how to avoid such mess.
>
> The output is
>
> [root@fru3710e ~]# sg_inq /dev/sdc
> standard INQUIRY:
>    PQual=3D0  Device_type=3D0  RMB=3D0  version=3D0x04  [SPC-2]
>    [AERC=3D0]  [TrmTsk=3D0]  NormACA=3D1  HiSUP=3D1  Resp_data_format=3D2
>    SCCS=3D0  ACC=3D0  TPGS=3D0  3PC=3D0  Protect=3D0  BQue=3D0
>    EncServ=3D0  MultiP=3D1 (VS=3D1)  [MChngr=3D0]  [ACKREQQ=3D0]  Addr16=
=3D0
>    [RelAdr=3D0]  WBus16=3D0  Sync=3D0  Linked=3D0  [TranDis=3D0]  CmdQue=
=3D1
>    [SPI: Clocking=3D0x0  QAS=3D0  IUS=3D0]
>      length=3D193 (0xc1) Peripheral device type: disk
>   Vendor identification: EMC
>   Product identification: Invista
>   Product revision level: 5100
>   Unit serial number: CKM00xxxxxxxxx
>
Hehe. No alua for you (TPGS=3D0).
But that's EMC for you; probably you should count yourself lucky
that it's not claiming compability to SCSI-2 ...

> and well, 'weightedpath' is also available in RHEL, but only queries
> for the device name and the SCSI-address. I wanted to query the
> remote-port of the storage-device - which is the frontend wwn of the
> storage device.
>
Why don't you use the 'by-path' symlinks for the device name in =

weightedpath?
They'll include the target port WWN, so should give you what you want.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
