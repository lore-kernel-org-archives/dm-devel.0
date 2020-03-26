From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 2/3] libmutipath: don't close fd on
	dm_lib_release
Date: Thu, 26 Mar 2020 08:41:05 +0000
Message-ID: <6b99731ed6f7cc983e1f12a6b679bb4be1f1ea05.camel@suse.com>
References: <1585196568-23714-1-git-send-email-bmarzins@redhat.com>
	<1585196568-23714-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585196568-23714-2-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <3954F07A9C65BC46A08A0A4034F74910@namprd18.prod.outlook.com>
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

On Wed, 2020-03-25 at 23:22 -0500, Benjamin Marzinski wrote:
> If dm_hold_control_open() isn't set, when dm_lib_release() is called,
> it
> will close the control fd. The control fd will get re-opened on the
> next
> dm_task_run() call, but if there is a dm_task_run() call already
> in progress in another thread, it can fail. Since many of the
> device-mapper callouts happen with the vecs lock held, this wasn't
> too
> noticeable, but there is code that calls dm_task_run() without the
> vecs lock held, notably the dmevent waiter code.
>=20
> Since, as Martin pointed out, dm_hold_control_open() hasn't always
> existed in libdevmapper, check if it's supported on compilation,
> and update the version requirements if so.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
