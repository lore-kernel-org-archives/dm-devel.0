From: Hannes Reinecke <hare@suse.de>
Subject: Re: Bug? Determining the holders of partitions shadowed
	by dm-multipath.
Date: Wed, 11 Feb 2009 09:18:55 +0100
Message-ID: <499289EF.80305@suse.de>
References: <20090210004951.GA4341@mail.oracle.com>	<16F7C86087BE0247B20562A9E6B07DC75BB5DAA6@excnysm95bagp.nysemail.nyenet>	<20090210213239.GA30270@mail.oracle.com>
	<49927F04.3070404@suse.de> <20090211080334.GH9512@mail.oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090211080334.GH9512@mail.oracle.com>
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
> On Wed, Feb 11, 2009 at 08:32:20AM +0100, Hannes Reinecke wrote:
>> Hi Joel,
>>
[ .. ]
>> Well, yes.
>> That's because you have _two_ parent-child relationship in sysfs.
>>
>> The one (as you already noted) is the holders / slaves directories in =
sysfs.
>> However, partitions are handled differently; they are listed under
>>
>> /sys/block/sda/sda2
>>
>> (note the subdir) and do not appear under holders / slaves. So the cor=
rect algorithm
>> is to
>> a) check the holders / slaves
>> and
>> b) check if the parent directory starts with the same name and if so, =
check for
>> the holders / slaves relationship there.
>=20
> 	Why not just setup holders in sda2?  It's held, after all.
> It's just very counterintuitive to look at an empty holders and discove=
r
> that it's empty yet held.

We don't need to, as sda2 is by definition held by sda.
So adding a 'holders' directory here which just points to the parent
directory is quite pointless.
(And it will become even more absurd for the 'slaves' directory in sda ..=
.)

Remember, partitions precede the holders / slaves abstraction by years.
The former abstraction was only introduced to map device-mapper / md
device relationships onto sysfs.

> 	Btw, do we absolutely guarantee that all block devices, forever,
> will have partitions in sysfs named
> "/sys/block/<parent>/<parent><more>"?
>=20
Yes, quite so. This is one relationship I would _not_ touch.

However, I'm all for it to optionally disable the partitions detection
within the kernel and have it all done in userspace by kpartx.
Then we'll be getting the 'holders/slave' relationship automatically
and won't be bothered by a separate partition scheme anymore.

Looks like it's time to dig out the patch again.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
