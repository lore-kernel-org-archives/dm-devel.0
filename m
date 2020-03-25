From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 3/3] libmultipath: allow force reload with no
	active paths
Date: Wed, 25 Mar 2020 15:27:47 +0000
Message-ID: <8cf9474c678b92663c1b7a64a9018d4c75abddff.camel@suse.com>
References: <1585083834-14237-1-git-send-email-bmarzins@redhat.com>
	<1585083834-14237-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585083834-14237-3-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <A0A96F79F607864BB015B38E51493E70@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2020-03-24 at 16:03 -0500, Benjamin Marzinski wrote:
> If the partition information has changed on multipath devices (say,
> because it was updated on another node that has access to the same
> storage), users expect that running "multipathd reconfigure" will
> update
> that.  However, if the checkers for the multipath device are pending
> for
> too long when the the device is reconfigured, multipathd will give up
> waiting for them, and refuse to reload the device, since there are no
> active paths. This means that no kpartx update will be triggered.
>=20
> Multipath is fully capable of reloading a multipath device that has
> no
> active paths. This has been possible for years. If multipath is
> supposed
> to reload the device, it should do so, even if there are no active
> paths.
>=20
> Generally, when multipath is force reloaded, kpartx will be updated.
> However when a device is reloaded with no paths, the udev rules won't
> run kpartx.  But they also weren't running kpartx when the first
> valid
> path appeared, even though the dm activation rules get run in this
> case.
> This changes 11-dm-mpath.rules to run kpartx when a device goes from
> no
> usable paths to having usable paths.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/configure.c    | 6 ------
>  multipath/11-dm-mpath.rules | 2 +-
>  2 files changed, 1 insertion(+), 7 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
