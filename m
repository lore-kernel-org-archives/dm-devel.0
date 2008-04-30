From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] [RFC] switch DM tables to
	readonly	automatically
Date: Wed, 30 Apr 2008 10:57:50 +0200
Message-ID: <4818348E.6050609@suse.de>
References: <1209543591.26745.9.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1209543591.26745.9.camel@plop>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,

Christophe Varoqui wrote:
>> Hi all,
>>
>> this patch switches the device-mapper table to read-only status automa=
tically if one underlying device returns -EROFS.
>>
>> Rationale:
>> Whenever a SCSI device is switched to read-only a table reload from mu=
ltipath-tools fails, without any indication about the reason. And it's ac=
tually quite tricky to detect the read-only status from userland. And qui=
te pointless, too, as the kernel already knows about it.
>>
>> And we now can create tables for CD-ROMs, too, without having to use t=
he '-r' flag to dmsetup ...
>>
>> Christophe, this might also fix your problem.
>>
> It seems it will solve the map creation error on read-only LU, but what=
 about these LU becoming writable ? ...
> as is the case with the Symmetrix R2 upon spliting the synchronisation =
link.
> Will the devmap become writable too automagically or is the multipathd =
daemon expected to take action the promote the map RW ?
>=20
Tricky business. We'll first have to be notified that the LU is becoming =
writeable. The current SCSI stack is not
very good at providing that sort of information.

I would think the best way here would be to modify the 'tur' checker to c=
heck for the READ-ONLY state, too.
That would mean we'll have to implement a new path state 'READONLY', but =
that should be okay methinks.
But this would have to be done at the SCSI level as the current 'sd' driv=
er is not capable of switching
between read-only and read-write on the fly, either.

Maybe I'll give it a go if I find some time.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
