From: Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: lvresize fails with "reload ioctl failed: Invalid
	argument"
Date: Mon, 11 Sep 2006 19:18:58 +0200
Message-ID: <45059A82.6080402@free.fr>
References: <ee20kk$s7u$1@sea.gmane.org>
	<20060910221427.GF13859@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060910221427.GF13859@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Le 11.09.2006 00:14, Alasdair G Kergon a =E9crit :
> On Sun, Sep 10, 2006 at 11:38:27PM +0200, Laurent Riffard wrote:
>>  device-mapper: reload ioctl failed: Invalid argument
>=20
>>  LVM version:     2.02.06 (2006-05-12)
>>  Library version: 1.02.09 (2006-08-15)
>>  Driver version:  4.8.0
>> Linux version 2.6.18-rc6-mm1 (laurent@calimero.antadix) (gcc version 4=
.1.1=20
>> 20060724 (prerelease) (4.1.1-3mdk)) #145 Sun Sep 10 20:48:49 CEST 2006
> =20
>=20
>> Is it a known problem ?=20
>=20
> Not sure, but try updating lvm2 version to the same date as the
> library version (at least 2.02.08 15th August).
>=20
> Alasdair

Still fails...

[root@calimero ~]# PATH=3D/home/laurent/bin:/home/laurent/sbin:$PATH
[root@calimero ~]# lvm version
  LVM version:     2.02.08 (2006-08-15)
  Library version: 1.02.09 (2006-08-15)
  Driver version:  4.8.0
[root@calimero ~]# lvm lvresize  --extents +1 /dev/vglinux1/lvswap2
  Extending logical volume lvswap2 to 1,00 GB
  device-mapper: reload ioctl failed: Argument invalide
  Failed to suspend lvswap2

~~
laurent
