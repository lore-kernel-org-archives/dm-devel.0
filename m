From: Hannes Reinecke <hare@suse.de>
Subject: Re: rdac priority checker changing priorities
Date: Tue, 23 Jun 2009 08:20:49 +0200
Message-ID: <4A407441.2060701@suse.de>
References: <9ad205140904291534j4cc1a71aq3b4a0e308f1687bd@mail.gmail.com>	
	<49F9443E.7040109@suse.de>
	<1241114743.11905.13.camel@chandra-ubuntu>	
	<49FEC6E6.6070105@suse.de>
	<1245718044.10657.12.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1245718044.10657.12.camel@chandra-ubuntu>
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

Chandra Seetharaman wrote:
> Hi Hannes,
>=20
> Please see the attached file for the real example.
>=20
> Can I go ahead and generate a patch to increase the priority of the
> preferred path to say, 50 ?
>=20
No. That's just wrong and we'll run into the same problem once
someone increases the number of paths to 50.

What we should do here is to modify the priority value, or
rather the way priority is used.

We should be splitting the current priority value into two
fields, pg priority and number of paths in a pg.
pg priority is the priority of a _single_ path here, and,
by definition as we're using group_by_prio, the priority
of each path in the pg.

Then we should be modifying the algorithm to choose the
next pg to do something like this:

-> Choose the pg with the highest priority
-> If two pgs have the same priority choose the pg
   with the highest path count. Maybe we could
   even use the highest _valid_ path count here,
   depending if we have the information at that point.

This algorithm would solve the problem we're having
now once and for all.

Just adding the priorities of the individual paths will
always lead to these type of problems.

I see if I can find some time to draw up a patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
