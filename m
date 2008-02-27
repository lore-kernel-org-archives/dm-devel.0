From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: RE: RE: RAID5 compatibility.
Date: Wed, 27 Feb 2008 09:32:46 -0800
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC01EBDADA@orsmsx418.amr.corp.intel.com>
References: <31325860.300541204131583899.JavaMail.www@wwinf4618>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <31325860.300541204131583899.JavaMail.www@wwinf4618>
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
List-Id: dm-devel.ids

You need to use the raid 4/5 patch from the maintainers website to have d=
mraid 4/5 support added. Here's the link:

http://people.redhat.com/heinzm/sw/dm/dm-raid45/dm-raid45-2.6.25-rc2_2008=
0221.patch.bz2=20

Unzip this patch using bunzip2 and apply it to your 2.6.25-rc2 kernel. Th=
en using "make gconfig" or "make menuconfig" go into "Device Drivers->Mul=
tiple devices driver support (RAID and LVM)->Device mapper support" and s=
elect "RAID 4/5 target".=20

Brian Wood
Software Engineer
Intel Corp., Manageability & Platform Software Division
brian.j.wood@intel.com

>-----Original Message-----
>From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] O=
n Behalf Of silentphoebus
>Sent: Wednesday, February 27, 2008 9:00 AM
>To: dm-devel@redhat.com
>Subject: RE: RE: [dm-devel] RAID5 compatibility.
>
>Thank you for your answer.
>I can't manage the raid5 to work,
>here are what what i do :
>
>dmraid -s give me :
>*** Group superset isw_hdaagdcbc
>--> Subset
>name   : isw_hdaagdcbc_RAID5
>size   : 1465177344
>stride : 128
>type   : raid5_la
>status : ok
>subsets: 0
>devs   : 4
>spares : 0
>
>dmraid -tay give me :
>isw_hdaagdcbc_RAID5: 0 1465177344 raid45 core 2 131072 nosync raid5_la 1=
 128 4 -1 /dev/sda 0
>/dev/sdb 0 /dev/sdc 0 /dev/sde 0
>
>and dmraid -ay give me :
>ERROR: device-mapper target type "raid45" not in kernel
>and the /dev/mapper/ show only the control file.
>
>i have try with the from the cvs tree and the current tools.
>i use the latest kernel with raid456 compiled as modules and loaded.
>
>What should i do to make the raid5 work.
>Thank you very much.
>>
>>
>> > Message du 26/02/08 =E0 10h00
>> > De : "Cetnerowski, Adam" <adam.cetnerowski@intel.com>
>> > A : silentphoebus@voila.fr, "device-mapper development" <dm-devel@re=
dhat.com>
>> > Copie =E0 :
>> > Objet : RE: [dm-devel] RAID5 compatibility.
>> >
>> >
>> >
>> > > -----Original Message-----
>> > > From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.=
com]
>> > On > Behalf Of silentphoebus
>> > > Sent: Monday, February 25, 2008 8:07 PM
>> > > To: dm-devel@redhat.com
>> > > Subject: [dm-devel] RAID5 compatibility.
>> > >
>> > > Hi all,
>> > > i found a lot of informations on the internet for intel software r=
aid5
>> > > with ICH controler.
>> > > So, the best is maybe to ask here.
>> > > Is it compatible with the dmraid mapper or not ?
>> > > Thank you for taking time to read.
>> >
>> > Hi,
>> >
>> > The software RAID 5 does indeed use device mapper. I would like to n=
ote
>> > that at the moment it is in the experimental stage, while we work on
>> > some of the features.
>> >
>> > Adam Cetnerowski
>> > Intel Technology Poland
>> >
>> >
>
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
