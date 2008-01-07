From: Hannes Reinecke <hare@suse.de>
Subject: Re: Configuring multipath for root device
Date: Mon, 07 Jan 2008 08:38:01 +0100
Message-ID: <4781D6D9.5030204@suse.de>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1198099093.26366.32.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Chandra Seetharaman wrote:
> I am working on a multipath usage document. Attached is the installatio=
n
> section of that document.
>=20
> Note that it is written for RHEL5 U1 and SLES10 SP1.
>=20
> Good Luck,
>=20
> chandra
>=20
> On Wed, 2007-12-19 at 13:02 -0800, Pradipmaya Maharana wrote:
>> Hi All,
>>
>> Is there a process/document that talks about how to configure
>> root/boot device for multipath?
>>
>> Thanks and Regards,
>> Pradipmaya.
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>> ----------------------------------------------------------------------=
--
>>
>> 4.1. Installation instructions for SLES10
>>
>> Note: This is tested on SLES10 SP1. If you have any other version, you=
r
>> mileage may vary.
>>
>>    1. Install the OS in a device that has multiple paths. Make sure th=
e
>> root device's "Mount by" option is set to "Device by-id" (this option =
is
>> available under "expert partitioner" as "fstab options").
>>    2. Complete the installation. Let the system boot up in multiuser m=
ode.
>> Make sure the root device, swap device are all referenced by their by-=
id
>> device node entries instead of /dev/sd* type names. If they are not, f=
ix
>> them first.
>>    3. Once booted, update /etc/multipath.conf If you have to make chan=
ges
>> to /etc/multipath.conf, make the changes.
>>       Note: the option "user_friendly_names" is not supported by initr=
d.
>> So, if you have user_friendly_names in your /etc/multipath.conf file,
>> comment it for now, you can uncomment it later.
>>    4. Enable multipathing by running the following commands
>>           * chkconfig boot.multipath on
>>
>>           * chkconfig multipathd on=20
>>    5. Add multipath module to initrd
>>
>>       Edit the file /etc/sysconfig/kernel and add "dm-multipath" to
>> INITRD_MODULES". Note: If your storage devices needs a hardware handle=
r,
>> add the corresponding module to INITRD_MODULES, in addition to
>> "dm-multipath". For example add "dm-rdac" and "dm-multipath" to suppor=
t
>> IBM's DS4K storage devices
>>    6.  Run mkinitrd
>>       Note: You can uncomment the user friendly name if you have comme=
nted it above.
>>    7. Reboot=20
>>
>> The system will come up with the root disk on a multipathed device.
>>
>> Note: You can switch off multipathing to the root device by adding
>> multipath=3Doff to the kernel command line.
>>
ACK. This is the correct way.

Thanks for writing this up.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
