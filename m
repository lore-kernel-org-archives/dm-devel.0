From: Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: lvresize fails with "reload ioctl failed: Invalid
	argument"
Date: Mon, 11 Sep 2006 20:23:25 +0200
Message-ID: <4505A99D.3040604@free.fr>
References: <ee20kk$s7u$1@sea.gmane.org>	<20060910221427.GF13859@agk.surrey.redhat.com>	<20060911141916.GC13522@percy.comedia.it>
	<450592C5.50905@free.fr> <20060911170527.GE13522@percy.comedia.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060911170527.GE13522@percy.comedia.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Luca Berra <bluca@comedia.it>
List-Id: dm-devel.ids

Le 11.09.2006 19:05, Luca Berra a =E9crit :
> On Mon, Sep 11, 2006 at 06:45:57PM +0200, Laurent Riffard wrote:
>> Le 11.09.2006 16:19, Luca Berra a =E9crit :
>>> On Sun, Sep 10, 2006 at 11:14:27PM +0100, Alasdair G Kergon wrote:
>>>> On Sun, Sep 10, 2006 at 11:38:27PM +0200, Laurent Riffard wrote:
>>>>>  device-mapper: reload ioctl failed: Invalid argument
>>>>
>>>>>  LVM version:     2.02.06 (2006-05-12)
>>>>>  Library version: 1.02.09 (2006-08-15)
>>>>>  Driver version:  4.8.0
>>>>> Linux version 2.6.18-rc6-mm1 (laurent@calimero.antadix) (gcc=20
>>>>> version 4.1.1 20060724 (prerelease) (4.1.1-3mdk)) #145 Sun Sep 10=20
>>>>> 20:48:49 CEST 2006
>>>>
>>>>
>>>>> Is it a known problem ?=20
>>>>
>>>> Not sure, but try updating lvm2 version to the same date as the
>>>> library version (at least 2.02.08 15th August).
>>>>
>>> Laurent, can you please try the packages from:
>>> http://kenobi.mandriva.com/~bluca/
>>
>> No luck!
>>
>> [root@calimero ~]# rpm -q lvm2 libdevmapper1.02
>> lvm2-2.02.09-1mdv2007.0
>> libdevmapper1.02-1.02.09-1mdv2007.0
>> [root@calimero ~]# lvm2 version
>>  LVM version:     2.02.09 (2006-08-17)
>>  Library version: 1.02.09 (2006-08-15)
>>  Driver version:  4.8.0
>> [root@calimero ~]# lvresize  --extents +1 /dev/vglinux1/lvswap2
>>  Extending logical volume lvswap2 to 1,00 GB
>>  device-mapper: reload ioctl failed: Argument invalide
>>  Failed to suspend lvswap2
>>
>> Will try vanilla to compile and test vanilla lvm2 2.02.08 as Alasdair=20
>> suggested.
>=20
> works for me with 2.6.17-4mdv kernel
> maybe something related to your kernel version?

Well, I started to fail with Mandriva 2007 beta 2 and 3. Beta 3's=20
kernel was kernel-2.6.17.2mdv-1-1mdv2007.0. So I'm not sure the=20
kernel version has impact.

I planned to update to mandriva-free-2007 this evening. I'll keep=20
you informed.


Another point is that I have some striped LV. Could it be related ?

[root@calimero ~]# lvdisplay -m /dev/vglinux1/lvswap
  --- Logical volume ---
  LV Name                /dev/vglinux1/lvswap
  VG Name                vglinux1
  LV UUID                7rwfvs-tvQ4-gnT2-afC1-7yQA-PGMw-m0Zvac
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                1,00 GB
  Current LE             256
  Segments               1
  Allocation             inherit
  Read ahead sectors     0
  Block device           254:8
  =20
  --- Segments ---
  Logical extent 0 to 255:
    Type                striped
    Stripes             2
    Stripe size         64 KB
    Stripe 0:
      Physical volume   /dev/sdb7
      Physical extents  1553 to 1680
    Stripe 1:
      Physical volume   /dev/sda4
      Physical extents  4424 to 4551


Should I try to compile and try a vanilla Device-mapper from=20
http://sources.redhat.com/dm/ ?

~~
laurent
