From: Hannes Reinecke <hare@suse.de>
Subject: Re: Bug? Determining the holders of partitions shadowed
	by dm-multipath.
Date: Wed, 11 Feb 2009 08:32:20 +0100
Message-ID: <49927F04.3070404@suse.de>
References: <20090210004951.GA4341@mail.oracle.com>	<16F7C86087BE0247B20562A9E6B07DC75BB5DAA6@excnysm95bagp.nysemail.nyenet>
	<20090210213239.GA30270@mail.oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090210213239.GA30270@mail.oracle.com>
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

Hi Joel,

Joel Becker wrote:
> On Tue, Feb 10, 2009 at 09:49:58AM -0500, Romanowski, John (OFT) wrote:
>> my sles10sp2 at 2.6.16.60-0.29-default doesn't have the /sys/block/...=
/holders but
>> I've used major:minor device numbers from commands
>> dmsetup ls
>> and
>> dmsetup deps
>> to resolve such device relationships.
>>
>> A 'dmsetup ls' device number that isn't listed in 'dmsetup deps' devic=
e numbers is a top-level device. Example below: mproot-part1 (dev 253:3, =
a partition of mp device 253:2) isn't listed as a dependency of any devic=
e. Likewise each listed LVM volume isn't listed as a dependency of any de=
vice; example- rootvg-tmp 253:10
>=20
> 	Sure, but a /dev/sda2 won't show up in dmsetup output anywhere.
> That's kind of my point.
>=20
Well, yes.
That's because you have _two_ parent-child relationship in sysfs.

The one (as you already noted) is the holders / slaves directories in sys=
fs.
However, partitions are handled differently; they are listed under

/sys/block/sda/sda2

(note the subdir) and do not appear under holders / slaves. So the correc=
t algorithm
is to
a) check the holders / slaves=20
and
b) check if the parent directory starts with the same name and if so, che=
ck for
the holders / slaves relationship there.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
