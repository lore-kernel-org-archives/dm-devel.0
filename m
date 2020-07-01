From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 7/7] multipath: add option to skip
 multipathd delegation
Date: Wed, 1 Jul 2020 21:01:31 +0000
Message-ID: <dc236b19d85fcde7333a21bca0581f1601af7b86.camel@suse.com>
References: <1593117741-28750-1-git-send-email-bmarzins@redhat.com>
	<1593117741-28750-8-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593117741-28750-8-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <3E371701E0764644813486E8D1ABEB5F@eurprd04.prod.outlook.com>
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

On Thu, 2020-06-25 at 15:42 -0500, Benjamin Marzinski wrote:
> Add the -D option to allow users to skip delegating commands to
> multipathd.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
>  libmultipath/config.h | 1 +
>  multipath/main.c      | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
