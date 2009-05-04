From: Hannes Reinecke <hare@suse.de>
Subject: Re: rdac priority checker changing priorities
Date: Mon, 04 May 2009 12:43:50 +0200
Message-ID: <49FEC6E6.6070105@suse.de>
References: <9ad205140904291534j4cc1a71aq3b4a0e308f1687bd@mail.gmail.com>	
	<49F9443E.7040109@suse.de>
	<1241114743.11905.13.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1241114743.11905.13.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Chandra,

Chandra Seetharaman wrote:
> Hannes,
>=20
> I think we need to revisit the priority value we provide for preferred
> path(4) relative to active path (2) and non-preferred(1).
>=20
> Consider the following scenario:
>=20
> Access to a lun thru 2 preferred and 2 non-preferred path. Lets call
> path group with preferred paths as pg1 and with non-preferred paths as
> pg2.=20
>=20
> Initially pg1 has priority of 8 and pg2 has priority of 2. pg1 is chose=
n
> and I/O goes thru pg1, all good.
>=20
> Both the paths in pg1 fails, pg2 has been made the active path group an=
d
> I/O is sent thru that path and since it became "active", its priority
> raises to 6 ( 2 path times (active + non-preferred)).=20
>=20
> When one of the paths in pg1 comes back, one would expect the failback
> to happen. It doesn't happen as pg1's priority (4) is smaller than that
> of pg2 (6). Which is not correct.
>=20
Is this really a valid case?
This means we'll have a setup like this:

rdac
 pg1
  sda failed
  sdb failed
 pg2
  sdc active
  sdd active

Correct?
So, given your assumptions, the proposed scenario would be represented
like this:

rdac
 pg1
  sda active
  sdb failed
 pg2
  sdc active
  sdd active

So it is really a good idea to switch paths in this case? The 'sdb'
path would not be reachable here, so any path switch command wouldn't
have been received, either. I'm not sure _what_ is going to happen
when we switch paths now and sdb comes back later; but most likely
the entire setup will be messed up then:
  sda (pref & owned) 6
  sdb                0
  sdc (sec)          1
  sdd (sec & owned)  3
and we'll be getting the path layout thoroughly jumbled then.
So I don't really like this idea. We should only be switching
paths when _all_ paths of a path group become available again.
Providing not all paths have failed in the active group, of course.
Then we should be switching paths regardless.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
