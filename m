From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v3 0/6] multipath: path validation library
	prep work
Date: Wed, 20 May 2020 15:52:48 +0000
Message-ID: <50bb1bddca8bf7291bdc571ab1f408bac919ab15.camel@suse.com>
References: <1589908125-7456-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1589908125-7456-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <7384220E39C90D44BDEA9F7B9F301699@namprd18.prod.outlook.com>
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

On Tue, 2020-05-19 at 12:08 -0500, Benjamin Marzinski wrote:
> I've been playing around with the SID code more and I've decided to
> hold
> off on submitting the library until I have it working with the SID
> multipath module better. Instead, I've pulled out the common code
> that
> multipath -u/-c and the library can use, and put it into
> libmultipath.
>=20
> I've also removed some of the ordering differences between the
> existing
> code and my new code.  Right now, the only difference is that if a
> path
> is currently multipathed, it will always be claimed as a valid path.
>=20
> Patches 0001 & 0002 are the same as in my "RFC PATCH v2" set, and
> patch
> 0005 is the same as my "libmultipath: simplify failed wwid code"
> patch.
>=20
> Only patches 0003 and 0004 haven't been posted before.
>=20
> Changes from v1:
> 0003: Minor fixes suggested by Martin Wilck
> 0004: Fixed typo, added tests for filter_property() and switched some
>       tests to pass the check_multipathd code in various ways,
> instead
>       of skipping it, as suggested by Martin Wilck
>=20
> Changes from v2:
> rebased patches on top of Martin's previous patch sets
>=20
> Benjamin Marzinski (5):
>   libmultipath: make libmp_dm_init optional
>   libmultipath: make sysfs_is_multipathed able to return wwid
>   multipath: centralize validation code
>   Unit tests for is_path_valid()
>   libmultipath: simplify failed wwid code
>=20
> Martin Wilck (1):
>   libmultipath: use atomic linkat() in mark_failed_wwid()
>=20
>  libmultipath/Makefile    |   2 +-
>  libmultipath/devmapper.c |  62 ++++-
>  libmultipath/devmapper.h |   4 +-
>  libmultipath/structs.h   |  24 +-
>  libmultipath/sysfs.c     |  24 +-
>  libmultipath/sysfs.h     |   2 +-
>  libmultipath/valid.c     | 118 ++++++++++
>  libmultipath/valid.h     |  42 ++++
>  libmultipath/wwids.c     | 165 +++++++------
>  multipath/main.c         | 295 ++++++++++--------------
>  tests/Makefile           |   4 +-
>  tests/valid.c            | 486
> +++++++++++++++++++++++++++++++++++++++
>  12 files changed, 943 insertions(+), 285 deletions(-)
>  create mode 100644 libmultipath/valid.c
>  create mode 100644 libmultipath/valid.h
>  create mode 100644 tests/valid.c
>=20

You included all the reviewed-by tags from me already, but for the sake
of clarity: ACK for this v3 series.

Thanks,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
