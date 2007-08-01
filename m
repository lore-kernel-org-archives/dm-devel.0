From: chris <chris@parallelsw.com>
Subject: Re: encrypted filesystem not encrypted?
Date: Wed, 01 Aug 2007 17:05:11 -0600
Message-ID: <46B111A7.5000607@parallelsw.com>
References: <E5C8AFD1ADF9DF48AD935F49588E895506B36FFD@gamx.iccur.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E5C8AFD1ADF9DF48AD935F49588E895506B36FFD@gamx.iccur.com>
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

Thank you both for your replies!

Thank you for the replies! I have learned a lot from this posting... I=20
knew to seed a looped file with random data, but had not thought about=20
seeding the device itself.

The basic commands that were (should have been) run were:

cryptsetup =96-verbose =96-verify-passphrase create sda3 /dev/sda3
pvcreate /dev/mapper/sda3
vgcreate loggroup /dev/mapper/sda3
lvcreate -L##G -n logvolume loggroup
mkfs.ext3 -j /dev/loggroup/logvolume
mount /dev/loggroup/logvolume /mount_point

I'm basically the Architect who came up with the process to run for the=20
company, the S/A who setup the box actually ran the commands, the ones I=20
delivered to him were to build out an encrypted filesystem ontop of an=20
existing (loop). He made a change to them to use the actual device and=20
they could have easily enough converted the commands to
pvcreate /dev/sda3, vgcreate loggroup /dev/sda3 and the rest doesn't=20
matter, nothing would be encrypted.

I think the way I can prove this (please let me know if this has faults)=20
is in tearing down (unmounting, and vgchange/lvchange) the filesystem=20
and removing the cryptsetup... At that point the LVM should not=20
recognize the loggroup as a valid LVM and therefore (vg/pv/lv)display=20
wont display anything for the subject groups.... So, I think I am=20
comfortable enough proving that we are (or are not) using the encryption=20
that way.

What I think has happened was that these devices were in fact used=20
previously, and we did not seed the devices with random data... I=20
verified that with the S/A who ran the commands to setup the box.

The only reason we were looking at sda3 was to give the testers a way to=20
make them feel better that the disk was in fact encrypting the data, are=20
there better ways to ensure the data stored on the disk is in fact=20
encrypted?

TIA again!

-chris

Ellison, Bob wrote:
> Also, did you initialize the partition with random data before the
> cryptsetup step? If not, you could be looking at stale, unencrypted
> data.
> e.g
>        dd if=3D/dev/urandom of=3D/dev/sda3=20
>     or
>        /sbin/badblocks -c 10240 -s -w -t random -v /dev/sda3
>
> Either will do; the choice is how secure you want your actual data
> and/or how long you're willing to wait for the seeding to complete.
> --
> bob
>
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Jonathan Brassow
> Sent: Wednesday, August 01, 2007 10:43 AM
> To: device-mapper development
> Subject: Re: [dm-devel] encrypted filesystem not encrypted?
>
> I'm guessing that you are bypassing your crypt device.  Depends on =20
> what your arguments are to the LVM commands.
>
> cryptsetup will create a new device that sits on top of sda3 - you =20
> should use that one.  Do not use sda3 directly.
>
>   brassow
>
> On Jul 31, 2007, at 8:08 PM, chris wrote:
>
>  =20
>> Hi all,
>>
>> I was not sure which list to send this to, so I choose a couple =20
>> that looked like decent fits, please advise if there is one more =20
>> specific to the encryption.
>>
>> I am currently working on a project where we are converting some of =20
>> our filesystems to an encrypted fs using LVM2.  We are running =20
>> RHEL:  "2.6.9-55.0.2.ELsmp #1 SMP Tue Jun 12 17:59:08 EDT 2007 i686 =20
>> i686 i386 GNU/Linux"
>>
>> We setup an encrypted filesystem using one of the open partitions =20
>> on the physical hard drive using "cryptsetup create /dev/sda3"  We =20
>> have verified this using the cryptsetup status, This shows the =20
>> filesystem as being encrypted as aes_plain 256 bit key.  We then =20
>> created an LVM and mounted the filesystem using the LVM.
>>
>> All seems to be well, except when our testers ran the following =20
>> command:
>> head -c 5000 /dev/sda3
>>
>> They got some output that includes clear text and obviously not =20
>> encrypted data (along with encrypted data).  Some things are date =20
>> formatted strings like 20050912 which appears quite a few times in =20
>> the mounted filesystem, and in the raw device (/dev/sda3).
>>
>> I can post the exact commands that were used to create the =20
>> filesystem, but they are basically
>> create partition ...sda3
>> cryptsetup create /dev/sda3 (prompts for passphrase)
>> pvcreate
>> vgcreate
>> lvcreate
>> mount
>>
>> (TIA) any help (or light shed on this) is greatly appreciated!
>>
>> -chris
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>    =20
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>  =20
