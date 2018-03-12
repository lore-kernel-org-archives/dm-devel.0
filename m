From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: device mapper mapping across reboot
Date: Mon, 12 Mar 2018 15:41:48 +0100
Message-ID: <1999d398-9689-8aa0-f4c6-c5c9833ee5d4@redhat.com>
References: <CAN-6CVmztjkV6JL0k3N8Vh47Tr4oY_8Jj6-JL16b2YY5yNEHOA@mail.gmail.com>
	<f0e41723-159a-fe39-42f2-4a2ef1466bfa@redhat.com>
	<20180310104747.GA1027@gmail.com>
	<c257ef68-a6f2-a458-fbbf-752b729fa169@redhat.com>
	<20180312110912.GA1015@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180312110912.GA1015@gmail.com>
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
To: Jitendra <jkhasdev@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 12.3.2018 v 12:09 Jitendra napsal(a):
> On Mon, Mar 12, 2018 at 10:49:02AM +0100, Zdenek Kabelac wrote:
>> Dne 10.3.2018 v 11:47 Jitendra napsal(a):
>>>
> =

>> Once kernel is booted and 'ramdisk' is processed - you have plenty of
>> time and lots of binaries there (typically with lvm2 built-in)=A0 - so
>> here you can safely activate your root volume being on dm device (even
>> without lvm2 just by issuing couple 'dmsetup' commands)
> =

> This is something which I have tried in following steps.
> =

> 1. First load my target driver(eg. my_custom_target) in initramfs (RHEL 7=
) =

> using dracuf.
> 2. Now=A0 my_custom_target will be available when initramfs get loaded.
> 3. Before the switch_root, I tried to run following command as,
> =

>  =A0=A0=A0=A0[root@localhost ~]# ls -l /usr/lib/systemd/system/initrd-swi=
tch-root.service
>  =A0=A0=A0=A0-rw-r--r--. 1 root root 737 Mar 12 07:00 =

> /usr/lib/systemd/system/initrd-switch-root.service
> =


I'm not quite sure why do you ever need to play with any systemd service s

Is there lost support for some kind of /etc/rc.local ?

Of course you have to use UUID on your devices - and shift filesystems on y=
our =

real /dev/sdaX  so  systemd  WAIT for devices that will appear in your syst=
em =

only via  'DM' mapping (so your rootfs on sdX needs to be prefixed with som=
e =

header).

You cannot have in your system 2 'same' devices' - that will confuse your =

systemd.

Solving complexity of systemd world is where lvm2 is there for. So if you p=
lan =

to 'recreate' simpler lvm2 just because you don't want to use lvm2 - it's =

going to be hard task...

> In my target driver, I am tracking each and every I/O and looking for off=
set and
> length in each bio and doing some logging stuff.

Btw - isn't  dmstats  good enough for that already? You can split every dev=
ice =

in your system in regions and get very detailed start about that.

For using dmstats - you can directly use LVs and attach dmstats to them - s=
o =

you don't have to recreate this machinery yourself...

Regards

Zdenek
