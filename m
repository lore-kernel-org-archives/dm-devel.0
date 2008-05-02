From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] [RFC] switch DM tables to readonly
	automatically
Date: Fri, 02 May 2008 08:24:40 +0200
Message-ID: <481AB3A8.30803@suse.de>
References: <4811EB85.8090505@suse.de>
	<20080501112451.GT18935@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080501112451.GT18935@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> On Fri, Apr 25, 2008 at 04:32:37PM +0200, Hannes Reinecke wrote:
>> this patch switches the device-mapper table to read-only
>> status automatically if one underlying device returns -EROFS.
> =20
> I'm going to need some persuading here...
>=20
> An analogy.  If I call open() with O_RDWR and but that can't be done
> because the device is read-only - what happens?  Does the open()
> silently give me a read-only file descriptor instead?  Or does it
> give me -EROFS?
>=20
> If I request DM_TABLE_LOAD without the DM_READONLY_FLAG, I am asking
> for a device I can write to and if that's not possible I expect an
> error.  If I'd wanted a read-only device I'd have set the
> DM_READONLY_FLAG on my request.
>=20
> Is the real problem that -EROFS/-ENXIO errors are not propagating back
> up through target _ctr functions as perhaps they should?
>=20
No, the real error is that you currently cannot create multipath
targets on devices exported as read-only from the storage.
Having device-mapper setting the 'read-only' flag automatically
on those devices instead of just bailing out will fix this.

The main problem we're facing here (from the point of multipathd)
is the lack of error reporting from device-mapper.
We're just getting the very helpful error 'ioctl failed',
with no indication about _why_.
So we have no clue at all that we might have to check for the
read-only setting on this device.
And checking this setting on _any_ ioctl error is just plain
silly.

The rest of the patch (calling _set_disk_ro and refusing to
open the device with O_RDWR) is just whitewhash to get a
better user experience.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
