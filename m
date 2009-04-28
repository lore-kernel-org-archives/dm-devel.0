From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Handle multipath paths in a path group
 properly during pg_init
Date: Tue, 28 Apr 2009 08:30:16 +0200
Message-ID: <49F6A278.5000300@suse.de>
References: <1238436452.5858.2.camel@chandra-ubuntu>
	<1240872495.22154.7.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1240872495.22154.7.camel@chandra-ubuntu>
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
Cc: Mike Anderson <andmike@us.ibm.com>, dm-devel <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

Chandra Seetharaman wrote:
> Resending the patch after fixing the header, Porting and testing in
> 2.6.30-rc3, and a bug fix.
> ---------------
> There is a problem which was caused due to the architectural change mad=
e
> when we moved from dm hardware handler to SCSI hardware handler.
>=20
>   In dm, handler was called to do a pg_init for a path group, and there
>   was no state maintained in hardware handler code for each path.
>=20
>   In SCSI dh, "state" is maintanined per path, as we wanted to fail I/O
>   early on that path if it is not the active path.
>=20
>   All of the hardware handlers, do have a state now, and they are set t=
o
>   active and (some form of) inactive. All of them have prep_fn(), which=
 use
>   this "state" to fail the I/O without it ever being sent to the device=
.
>=20
> So, in effect when dm-multipath calls scsi_dh_activate(), activate is
> sent to only one path and the "state" of that path is changed appropria=
tely
> to "active" while other paths in the same path group are never changed
> as they never got an "activate".
>=20
> In order make sure all the paths in a path group gets their state set
> properly when a pg_init happens, we need to call scsi_dh_activate() on
> all paths in a path group.
>=20
> Doing this at the hardware handler layer is not a good option as we
> want the multipath layer to define the relationship between path and pa=
th
> groups and not the hardware handler.
>=20
> Attached patch sends an "activate" on each path in a path group when a
> path group is switched. It also sends an activate when a path is reinst=
ated.
>=20
> Patch is applied and tested on 2.6.30-rc3.
>=20
> ----------
>=20
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Acked-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
