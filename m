From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v3 00/18] Multipath patch dump
Date: Wed, 19 Feb 2020 08:55:08 +0000
Message-ID: <b11e466e845185fdf90614d2d3a1c76394973447.camel@suse.com>
References: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <2DB6CB099A745543A5690FCFA7FB79B4@namprd18.prod.outlook.com>
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

On Wed, 2020-02-19 at 00:48 -0600, Benjamin Marzinski wrote:
> This patch set is has multiple parts.
>=20
> patch 01 is just a resubmit of my previous patch, with Martin's
> corrections added.
>=20
> Patches 02 - 06 are miscellaneous fixes and cleanups
>=20
> Patches 07 - 09 are related to adding a new format wildcard, at the
> =09request of HPE, that allows multipath to get and display
> =09information from the vendor specific VPD pages
>=20
> Patches 10 - 18 are the part that needs the most review, patch 14
> =09especially. It turns out that on machines with a large number
> =09of cores, io_destroy(), which is used by the directio checker,
> =09can take a long time to complete. Talking to some kernel people
> =09at Red Hat, I was told that this isn't a bug. It's working as
> =09expected, and multipath shouldn't be issuing so many
> =09io_destroy() calls (1 per path, when multipath or multipathd
> =09stops). Cutting out the io_destroy calls involved a major
> change
> =09to the directio checker. It's pretty hard to test a lot of the
> =09corner cases on actual hardware, so I've written a bunch of
> =09unit tests for this (patches 16 & 17).
>=20
> Changes in v3:
> This removes the conflicts with Martin's earlier patches,
> specifically
>=20
> 0003-libmultipath-fix-leak-in-foreign-code.patch
> =09removed in favor of Martin's
> =09"libmultipath: _init_foreign(): fix possible memory leak"
> =09patch
>=20
> 0016-fixup-libmultipath-add-code-to-get-vendor-specific-v.patch
> 0017-fixup-libmultipath-make-directio-checker-share-io-co.patch
> =09New patches to fix compile-time errors resulting from the
> =09rebase
>=20
> 0018-tests-make-directio-tests-able-to-work-on-a-real-dev.patch
> =09Fix conflicts between with Martin's earlier patches
>=20
> Changes in v2:
> 0001-multipathd-warn-when-configuration-has-been-changed.patch
> =09Changed to reflect Martin Wilck's comments
>=20
> 0002-multipathd-staticify-uxlsnr-variables-functions.patch
> =09New patch
>=20
> 0008-libmultipath-fix-sgio_get_vpd-looping.patch
> =09Test has been changed to keep create_vpd83 the same, and
> =09overwrite the length in the actual test, as suggested by
> =09Martin Wilck
>=20
> 0010-libmultipath-add-code-to-get-vendor-specific-vpd-dat.patch
> =09The information to find the vpd page and how to decode it is
> =09now simply the index in a table of name -> page_nr mappings
>=20
> 0012-libmultipath-change-failed-path-prio-timeout.patch
> =09The timeout argument has been renamed to avoid confusion,
> =09as suggested by Martin Wilck
>=20
> 0015-libmultipath-make-directio-checker-share-io-contexts.patch
> =09Minor changes to print more useful messages, and avoid
> =09printing anything when we get a non-zero io_cancel()
> =09result, as suggested by Martin Wilck
>=20
> 0016-tests-add-directio-unit-tests.patch
> =09Minor change to improve readability, as suggested by
> =09Martin Wilck
>=20
> 0017-tests-make-directio-tests-able-to-work-on-a-real-dev.patch
> =09New patch. This adds the ability to set a testing device, so
> =09you can run the directio tests on an actual device
>=20
>=20
>=20
> Benjamin Marzinski (16):
>   multipathd: warn when configuration has been changed.
>   multipathd: staticify uxlsnr variables/functions
>   Fix leak in mpathpersist
>   libmultipath: remove unused path->prio_args
>   libmultipath: constify get_unaligned_be*
>   libmultipath: add missing hwe mpe variable merges
>   libmultipath: fix sgio_get_vpd looping
>   libmultipath: add vend_id to get_vpd_sgio
>   libmultipath: add code to get vendor specific vpd data
>   libmultipath: change how the checker async is set
>   libmultipath: change failed path prio timeout
>   multipathd: add new paths under vecs lock
>   libmultipath: add new checker class functions
>   libmultipath: make directio checker share io contexts
>   tests: add directio unit tests
>   tests: make directio tests able to work on a real device
>=20
> Martin Wilck (2):
>   fixup! libmultipath: add code to get vendor specific vpd data
>   fixup! libmultipath: make directio checker share io contexts
>=20
>  libmpathpersist/mpath_persist.c  |   2 +-
>  libmultipath/checkers.c          |  29 +-
>  libmultipath/checkers.h          |   1 +
>  libmultipath/checkers/directio.c | 336 ++++++++++---
>  libmultipath/config.c            |  10 +
>  libmultipath/config.h            |   2 +
>  libmultipath/dict.c              |  38 ++
>  libmultipath/discovery.c         |  80 ++-
>  libmultipath/discovery.h         |   2 +-
>  libmultipath/hwtable.c           |   1 +
>  libmultipath/print.c             |  25 +
>  libmultipath/prio.c              |   6 +-
>  libmultipath/propsel.c           |  20 +-
>  libmultipath/propsel.h           |   1 +
>  libmultipath/structs.h           |  16 +-
>  libmultipath/unaligned.h         |   4 +-
>  mpathpersist/main.c              |   1 +
>  multipath/main.c                 |   1 +
>  multipath/multipath.conf.5       |  15 +-
>  multipathd/main.c                |  18 +-
>  multipathd/uxlsnr.c              | 150 +++++-
>  tests/Makefile                   |  19 +-
>  tests/directio.c                 | 812
> +++++++++++++++++++++++++++++++
>  tests/directio_test_dev          |   4 +
>  tests/vpd.c                      |  87 ++--
>  25 files changed, 1527 insertions(+), 153 deletions(-)
>  create mode 100644 tests/directio.c
>  create mode 100644 tests/directio_test_dev
>=20

ACK for the series.

... one small nit: I'd rather not add the new file
"tests/directio_test_dev" from patch 18/18 to version control (git),
because the file is likely to be different in every environment, and
changes to the file will need to be stashed away before every branch
export, which is inconvenient. "make test" will work just fine without
the file. I'd prefer a tests/README file explaining how to
activate directio-on-real-device testing.

But this is not a reject, Christophe could fix this when merging, or
I'll post a fix.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
