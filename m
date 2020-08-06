From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 0/6] multipath cleanups
Date: Thu, 6 Aug 2020 10:58:50 +0000
Message-ID: <75f9dc44f24e4ff5923ba3bc5cb44f29635afb62.camel@suse.com>
References: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <45963B8C4183444EA50BFFE78EBAB8F5@eurprd04.prod.outlook.com>
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

On Mon, 2020-07-27 at 14:24 -0500, Benjamin Marzinski wrote:
> Patches 0003 & 0004 fix an issue that I've seen with paths whose
> checker
> takes too long when multipathd is starting up and creating devices.
>=20
> The others are minor build fixes or small cleanups to my previous
> patchset.
>=20
> Benjamin Marzinski (6):
>   Makefile.inc: trim extra information from systemd version
>   kpartx: fix -Wsign-compare error
>   libmultipath: remove code duplication in path counting
>   libmultipath: count pending paths as active on loads
>   libmultipath: deal with flushing no maps
>   multipath: deal with delegation failures correctly
>=20
>  Makefile.inc                    |  2 +-
>  kpartx/kpartx.c                 |  2 +-
>  libmpathpersist/mpath_persist.c |  4 +--
>  libmultipath/devmapper.c        |  5 ++--
>  libmultipath/structs.c          | 52 ++++++++++++++++---------------
> --
>  libmultipath/structs.h          |  2 +-
>  multipath/main.c                |  9 ++++--
>  7 files changed, 39 insertions(+), 37 deletions(-)
>=20

For the series, except 3/6:

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
