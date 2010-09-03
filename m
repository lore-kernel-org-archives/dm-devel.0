From: Hannes Reinecke <hare@suse.de>
Subject: Re: Discard support for dm-snap
Date: Fri, 3 Sep 2010 07:45:58 +0200
Message-ID: <20100903054557.GA30704@ochil.arch.suse.de>
References: <4C7F5AE2.9020908@suse.de>
	<4C7FEB11.8090903@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4298412847465815568=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C7FEB11.8090903@filteredperception.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============4298412847465815568==
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx01.colomx.prod.int.phx2.redhat.com id o835kEhx003721

On Thu, Sep 02, 2010 at 01:21:05PM -0500, Douglas McClendon wrote:
> On 09/02/2010 03:05 AM, Hannes Reinecke wrote:
>> Hi all,
>>
>> now that we've got discard support in the block layer, are there plans
>> to update dm-snap to actually implement discard?
>> Looks like a valid addendum here; we could be freeing up unused blocks
>> thus freeing up space.
>> Especially helpful when using dm-snap to create a sparse device;
>> cf
>> http://www.mjmwired.net/kernel/Documentation/device-mapper/zero.txt
>>
>> Thoughts?
>
> Here was my similar suggestion and the discussion with Mike that follow=
ed-
>
> http://www.spinics.net/lists/dm-devel/msg11632.html
>
> I still feel like there is a disconnect between my thinking and Mike's,=
 as=20
> I think I have the same fundamental interest as you do Hannes.
>
Yes and no. Snapshotting is similar but not identical to a sparse device.

> I.e. a perfect example is a simple dm-snapshot used for a livecd root=20
> filesystem.  In that case, after boot, the user creates a new file in t=
he=20
> rootfs, and that causes exception chunks (terminology?) to be created i=
n=20
> the cow device of the dm-snapshot.  Then, at a later point, the user=20
> deletes that file.  It then seems 100% reasonable for the discard reque=
st=20
> to result in freeing the used resources in the cow device.  I see no=20
> semantic reason why that data need be kept around any more than it need=
 be=20
> kept around on an SSD after a file is deleted.
>
It has to be for snapshotting. The main idea of snapshotting is the
possibility to do a rollback, ie that you can mount an earlier snapshot
instead of the current one and re-start from there.
This ability is lost if a later snapshot deletes blocks permanently;
these blocks would have to be removed from _all_ snapshots to really
free up space. But this would make rollback impossible.

Tempting as it may sound, I fear it's not going to work in general.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)


--===============4298412847465815568==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============4298412847465815568==--
