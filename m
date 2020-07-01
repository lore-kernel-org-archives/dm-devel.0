From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 6/7] multipath: delegate flushing maps to
	multipathd
Date: Wed, 1 Jul 2020 21:00:31 +0000
Message-ID: <95db8fb3c557369a0532fff12bd93447f067fedb.camel@suse.com>
References: <1593117741-28750-1-git-send-email-bmarzins@redhat.com>
	<1593117741-28750-7-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593117741-28750-7-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <04CE8E80CF148F448D7A791A48E4F5D0@eurprd04.prod.outlook.com>
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
> Since there can be problems with removing maps outside of multipathd,
> multipath should attempt to delegate this command to multipathd.
> However, multipathd doesn't attempt to suspend the device, in order
> to avoid potential hangs. If delegating to multipathd fails,
> multipath
> should try the remove itself.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
