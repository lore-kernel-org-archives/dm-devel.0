From: "Singh, Santosh (STSD)" <santosh.singh3@hp.com>
Subject: RE: Next set of device-mapper  patches
Date: Mon, 3 Jul 2006 21:59:51 +0530
Message-ID: <3EC60E80D9AA7C4E910ACC9DA2003AC3061E39EE@BGEEXC02.asiapacific.cpqcorp.net>
References: <4499490C.5070603@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4499490C.5070603@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "P S, Suresh (STSD)" <suresh.pathamadai@hp.com>
List-Id: dm-devel.ids

Hi,

 I am able to bind the dm device with  raw device successfully but when
trying to open in READ/WRITE mode , the application is not able to open
. For binding the raw device I have used the  RAW_SETBIND/RAW_GETBIND
ioctls.

raw -qa  shows the raw device is bounded to device-maper device.
[root@ioctl]# raw -qa=20
/dev/raw/raw1:  bound to major 253, minor 1

[root@ioctl]#ls /dev/mapper/mpath103 -l
brw-rw----  1 root disk 253, 1 Jul  3 16:18 /dev/mapper/mpath103

If any one used the raw device which is bound to device-mapper device
using the RAW_SETBIND/RAW_GETBIND,please help.

TIA
Santosh



-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Milan Broz
Sent: Wednesday, June 21, 2006 6:57 PM
To: device-mapper development
Subject: Re: [dm-devel] Next set of device-mapper patches



AJ Lewis wrote:
> On Wed, Jun 21, 2006 at 01:44:15PM +0200, Milan Broz wrote:
>> ioctl patch simple route ioctls to underlying block device
>> -> it supports all ioctl which are supported by your physical device.
>>
>> e.g.
>> in simple case you have volume /dev/mapper/VolGroup00-LogVol0 mapped=20
>> to physical device /dev/sda, inquiry ioctl (using tools from
>> sg3_util)
>> sg_inq /dev/sda  =20
>> 	is the same as
>> sg_inq /dev/mapper/VolGroup00-LogVol0
>>
>> In the case of multipath target ioctl command is sent through active=20
>> path.
>=20
> So what happens when you have multiple block devices in the volume? =20
> And what if those block devices have different levels of support for
the ioctls?

Currently supported for simple mapping with single target only, if there
are more than one target, it will fail with error -ENOTTY.

Milan

--
Milan Broz
mbroz@redhat.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
