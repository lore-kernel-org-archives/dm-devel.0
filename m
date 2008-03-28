From: Tore Anderson <tore@linpro.no>
Subject: Re: Using different configuration for arrays with
	identicalvendor/product
Date: Sat, 29 Mar 2008 00:07:07 +0100
Message-ID: <47ED7A1B.2020508@linpro.no>
References: <47ECD532.5060402@linpro.no>
	<218DC19ED27F8842B837598EC6D59D0ED702BC@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <218DC19ED27F8842B837598EC6D59D0ED702BC@CORPUSMX40A.corp.emc.com>
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

* berthiaume_wayne@emc.com

> 	You should be able to use the emc_handler for both arrays.
> Depending on the distro you are using only implicit ALUA is supported,
> explicit ALUA is in being worked on for upcoming distros. Whether the
> storage group within the array attached to the server is ALUA or not is
> determined by the failover mode you set for the host on that array. At
> the server side you will not know the difference between the two
> failover modes, PNR or ALUA.

Hi Wayne, thanks for your reply.

So I can use the emc_clariion hardware handler towards an array
configured for ALUA mode.  Wasn't aware of that.  I feel it's better to
let the array handle the trespassing on its own based on the ratio of
=C2=ABnon-optimal=C2=BB I/O operations (using hardware_handler 0), but I =
can live
with host-initiated trespasses on PG swithces/inits.

Anyway - there's still the problem of the path_checker.  If I'm using
=C2=ABemc_clariion=C2=BB for the array configured for ALUA mode (CLARiiON=
 Open,
mode 4), all paths is perceived to be failed.  If I'm using =C2=ABtur=C2=BB=
 for
the array configured for PNR mode (CLARiiON Open, mode 1), the passive
path is perceived to be failed.

Hence, if I use =C2=ABemc_clariion=C2=BB I won't be able to access the vo=
lumes on
the CX3-40 at all, while if I use =C2=ABtur=C2=BB dm-multipath won't swit=
ch PGs
when there's a (real) failure on the active path to the CX200.  None of
these are acceptable alternatives for production use, so the only
workaround I've found so far is to configure the CX3-40 to use PNR mode
(which sucks since ALUA is way better).  Do you have another trick up
your sleeve for me?

Regards
--=20
Tore Anderson
