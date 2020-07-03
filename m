From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v3 0/7] Fix muitpath/multipathd flush issue
Date: Fri, 3 Jul 2020 09:48:14 +0000
Message-ID: <95065bc425e4571e8cb49c5019196ffdba0357f0.camel@suse.com>
References: <1593734826-14059-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593734826-14059-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <29C9AFF244450F4F8E2BA45C7DB17027@eurprd04.prod.outlook.com>
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

On Thu, 2020-07-02 at 19:06 -0500, Benjamin Marzinski wrote:
> If a multipath device is removed, and check_path() checks one of its
> paths before multipathd processes either the uevent or the dm event
> from
> removing it, multipathd will recreate the removed device. This
> happens
> because check_path() will continute to check the removed device's
> former
> paths until an event arrives removing the device.  A missing multpath
> device will cause the update_multipath_strings() call to fail,
> setting
> pp->dmstate to PSTATE_UNDEF.  If the path is up, this dmstate will
> cause
> reinstate_path() to be called, which will also fail, because the
> multipath device doesn't exist.  This will trigger a reload,
> restoring
> the recently removed device.
>=20
> This patchset handles this is two ways. The first two patches
> directly
> fix these issues in check_path(), so that a missing multipath device
> will no longer get recreated when checking one of its former paths.
>=20
> The other 5 patches add a "multipathd del maps" command, and make the
> mutipath command delegate flush operations to multipathd so
> multipathd's
> state remains in sync with the kernel's, while doing removes.
>=20
> Changes from v1:
> 0001:=09This is completely different. I've change how patch 0002
> detects
> =09when a multipath device has disappeared. Instead of
> do_get_info,
> =09I need more return values on dm_get_map/status, and the
> =09update_multipath_* functions. I have used symbolic return
> =09values, which was the objection to the previous patch. I tried
> =09to picked generic enough names that they could be used for
> other
> =09devmapper.c functions as well.
>=20
> 0002:=09At Martin's suggestion, multipath now differentiates between dm
> =09failures and a missing multipath device in
> =09update_multipath_strings(). So there is no need to recheck if
> =09the device is missing.
>=20
> 0006:=09Added some man page info that was previously in patch 0007
>=20
> 0007:=09Removed mentions of the -D option in the man page and usage
> =09output.
>=20
> Changes from v2 (all are Martin's suggestions):
> 0001:=09Using dm_task_get_errno() and changed the names and values of
> =09the symbolic returns.
>=20
> 0002:=09Changed symbolic return names, and improved some logging.
>=20
> Benjamin Marzinski (7):
>   libmultipath: make dm_get_map/status return codes symbolic
>   multipathd: fix check_path errors with removed map
>   libmultipath: make dm_flush_maps only return 0 on success
>   multipathd: add "del maps" multipathd command
>   multipath: make flushing maps work like other commands
>   multipath: delegate flushing maps to multipathd
>   multipath: add option to skip multipathd delegation
>=20
>  libmultipath/config.h      |  4 ++-
>  libmultipath/configure.h   |  3 --
>  libmultipath/devmapper.c   | 63 +++++++++++++++++++++++++-----------
> --
>  libmultipath/devmapper.h   |  8 ++++-
>  libmultipath/structs_vec.c | 45 +++++++++++++++------------
>  multipath/main.c           | 44 ++++++++++++++++++--------
>  multipath/multipath.8      |  4 +--
>  multipathd/cli.c           |  1 +
>  multipathd/cli_handlers.c  | 19 ++++++++++++
>  multipathd/cli_handlers.h  |  1 +
>  multipathd/main.c          | 57 ++++++++++++++++------------------
>  multipathd/main.h          |  1 +
>  12 files changed, 160 insertions(+), 90 deletions(-)
>=20

For the set:

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
