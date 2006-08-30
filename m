From: "Brian Geisel" <brian.geisel@incipient.com>
Subject: RE: Multipathd not starting up properly
Date: Wed, 30 Aug 2006 11:11:40 -0400
Message-ID: <2F9C0315D2701343B960848AD8A611140B16F9@exch-2003.incipient.waltham>
References: <1156940689.3962.21.camel@cutter>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1156940689.3962.21.camel@cutter>
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

Hey Seth,

Forewarning: While I've done multipathing for quite some time I am new
to dm, so I'm going on multipathing / SCSI knowledge more than dm
knowledge.  It is possible I may be leading you down the wrong path (no
pun intended).

That being said, I have to assume that /sbin/mpath_prio_alua is issuing
a report target ports groups (SCSI cmd) to determine ALUA priority.  You
may want to issue the "sg_rtpg" command to each of your paths and see if
that is failing anywhere.  That seems to be the rough equivalent of
sending sg_inq when a path seems to be down.

Usually path tests are done with inquiry and/or TUR.  ALUA preference
must be determined from report target port groups.  That will at least
tell you if it's something obvious like old firmware that doesn't
support ALUA (how HP does their new A/A) or a check condition.  -- not
suggesting that's the problem, just giving an example --

FWIW,
Brian

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of seth vidal
Sent: Wednesday, August 30, 2006 8:25 AM
To: device-mapper development
Subject: Re: [dm-devel] Multipathd not starting up properly

On Wed, 2006-08-30 at 09:42 +0200, Hannes Reinecke wrote:
> Adam Huffman wrote:
> > I'm seeing the following messages when I start multipathd:
> >=20
> > Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s

> > /block/sda
> > Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s

> > /block/sdb
> >=20
> > Here is the output of multipath -v 3:
> >=20
> >=20
> [ .. ]
> > path checker =3D readsector0 (internal default)
> > state =3D 2
> > getprio =3D (null) (internal default)
> > prio =3D 1
> > getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)
> > error calling out /sbin/scsi_id -g -u -s /block/sda
>=20
> This is your problem. Somehow 'scsi_id' cannot talk to the drive.
> Try 'sg_inq /dev/sda' to find out where the problem is.
>=20

And this:
 error calling out /sbin/mpath_prio_alua 65:16

Any suggestions on what to look for for that?

-sv


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
