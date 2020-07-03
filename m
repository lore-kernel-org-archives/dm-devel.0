From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 0/4] misc patches
Date: Fri, 3 Jul 2020 09:48:15 +0000
Message-ID: <78bee5d7a30844f473355c36f5187440cf8df0a0.camel@suse.com>
References: <1593736707-14216-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593736707-14216-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <9FE2A1C24D3D134EA76E6040D32B362E@eurprd04.prod.outlook.com>
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

On Thu, 2020-07-02 at 19:38 -0500, Benjamin Marzinski wrote:
> This is a small collection of individual bug fix patches that apply
> on
> top of my previous patch set.
>=20
> Changes from v1:
>=20
> 0001:=09Going with Martin's strtoul() method instead
>=20
> 0002:=09Now getpagesize() is only called once, and size_p is only set
> if
> =09posix_memalign is successful, as suggested by Martin.
> =09
>=20
> Benjamin Marzinski (4):
>   libmultipath: fix sysfs dev_loss_tmo parsing
>   kpartx: read devices with direct IO
>   kpartx: handle alternate bsd disklabel location
>   libmultipath: fix checker detection for nvme devices
>=20
>  kpartx/bsd.c             | 16 ++++++++++--
>  kpartx/dasd.c            |  7 ++---
>  kpartx/gpt.c             | 22 +++++++---------
>  kpartx/kpartx.c          | 56 ++++++++++++++++++++++++++++++++----
> ----
>  kpartx/kpartx.h          |  2 ++
>  libmultipath/discovery.c | 12 ++++++---
>  libmultipath/propsel.c   |  4 ++-
>  7 files changed, 87 insertions(+), 32 deletions(-)
>=20

For the series:

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
