From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath-tools: multipath should allow
	only path with valid size to get added in the map
Date: Mon, 23 Nov 2009 14:39:36 +0100
Message-ID: <20091123133936.GA26597@ochil.suse.de>
References: <0D1E8821739E724A86F4D16902CE275C1C93C74DFE@inbmail01.lsi.com>
	<1258754235.20768.1.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1258754235.20768.1.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

On Fri, Nov 20, 2009 at 01:57:15PM -0800, Chandra Seetharaman wrote:
> Looks good to me except one comment below.
>=20
> On Fri, 2009-11-20 at 20:38 +0530, Chauhan, Vijay wrote:
> > Hi,
> >=20
> > If READ_CAPACITY fails during device discovery, sd device gets attach=
ed
> > with device size 0. Currently multipath discover these paths and adds
> > into the map. RDAC patch checker sends inquiry on each path to check
> > path status, which eventually marks this path as up. If this path is
> > from owning controller then mode select will be issued to switch the
> > pathgroup. But any I/O sent to this path(path with size 0) will event=
ually
> > fail in sd_prep_fn due to incorrect device size and resulting to ping=
 pong
> > between pathgroups.  We should only allow valid paths to get added in=
 the
> > map. Below patch checks two cases before adding paths; i.e.:
> > 	1) device size of path is not 0
> > 	2) there is no mismatch between mpp size and new path size.
> >=20
> >=20
Careful here. Some storage arrays (like the old HP MSA firmware) will rep=
ort
a size of zero for the inactive path. So we must make sure to not kill su=
pport
for those.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
