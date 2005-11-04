From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Clariion CX600 automatic failback support
Date: Fri, 4 Nov 2005 10:47:51 +0100
Message-ID: <20051104094751.GB9826@free.fr>
References: <C2EEB4E538D3DC48BF57F391F422779321ADA0@SRMANNING.eng.emc.com>
	<200511040919.07200.bernd@bzed.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200511040919.07200.bernd@bzed.de>
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

On Fri, Nov 04, 2005 at 09:19:06AM +0100, Bernd Zeimetz wrote:
> Hi,
>=20
> > Looks good, except the call to extract_hwe_from_path in setup_multipa=
th
> > must be before the call to select_pgfailback.
> >
>=20
> We have a ton of these log messages now.
> >From the last about 2 hours:
>=20
> 580x multipathd: 3600601f4a20c000099dc229956b0d711: switch to path grou=
p #1
> 714x multipathd: 3600601f4a20c000096dc229956b0d711: switch to path grou=
p #1
> 714x multipathd: 3600601f2a20c0000fb13caa656b0d711: switch to path grou=
p #1
>   45x kernel: device-mapper: dm-emc: emc_pg_init: sending switch-over c=
ommand
>=20
> It happens only for these 3 of 8 luns.
>=20
> Kernel is 2.6.13.4, devmapper 1.01, latest multipath-tools from git, ev=
ms=20
> 2.5.3
>=20
> zeus-1:/# cat /etc/multipath.conf
> defaults {
>         failback                                immediate
> }
>=20
>=20
> Since we had a lot of trouble with our CX400 (Hardware problems, but th=
ey're=20
> supposed to be fixed) I'm wondering what these messages mean, and if we=
 still=20
> have hardware/software bugs somewhere.
>=20
Yes, the test to determine if a switch is needed is sub-optimal :
The no activated PG case (all Enabled for example=C3) keeps triggering a =
switch.
I checked-in a patch to solve that issue.

Regards,
cvaroqui
