From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 0/8] multipath cleanups
Date: Wed, 12 Aug 2020 09:31:33 +0000
Message-ID: <2f55ef8f7d5178f14cf40af4171d4ced6df21884.camel@suse.com>
References: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <5C95B521B326B045AB914BA12F591251@eurprd04.prod.outlook.com>
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

On Tue, 2020-08-11 at 16:58 -0500, Benjamin Marzinski wrote:
> Patches 0003 & 0004 fix an issue that I've seen with paths whose
> checker
> takes too long when multipathd is starting up and creating devices.
>=20
> The others are minor build fixes or small cleanups to my previous
> patchset.
>=20
> Changes in v2:
> - patch 0003 no longer refactors count_active_paths(), as suggested
>   by Martin Wilck
> - Added patches 0007 & 0008, which are both unrelated minor changes.
>=20
> Benjamin Marzinski (8):
>   Makefile.inc: trim extra information from systemd version
>   kpartx: fix -Wsign-compare error
>   libmultipath: refactor path counting
>   libmultipath: count pending paths as active on loads
>   libmultipath: deal with flushing no maps
>   multipath: deal with delegation failures correctly
>   multipathd: unset mpp->hwe when removing map
>   multipathd: log reason for calling domap()
>=20
>  Makefile.inc                    |  2 +-
>  kpartx/kpartx.c                 |  2 +-
>  libmpathpersist/mpath_persist.c |  4 ++--
>  libmultipath/devmapper.c        |  5 +++--
>  libmultipath/structs.c          | 38 +++++++++++++++++++++--------
> ----
>  libmultipath/structs.h          |  2 +-
>  libmultipath/structs_vec.c      |  1 +
>  multipath/main.c                |  9 +++++---
>  multipathd/main.c               | 14 ++++++++----
>  9 files changed, 49 insertions(+), 28 deletions(-)
>=20

For the series, except 7/8 "multipathd: unset mpp->hwe when removing
map":

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
