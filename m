From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 3/7] libmultipath: make dm_flush_maps only
 return 0 on success
Date: Thu, 18 Jun 2020 20:29:54 +0000
Message-ID: <8d3690e3ce8e01a15663502ddcd2c99095b9ee72.camel@suse.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<1592439867-18427-4-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1592439867-18427-4-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <6FC6C2779DC5AA4CA76BAEFDDBE49A76@eurprd04.prod.outlook.com>
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

On Wed, 2020-06-17 at 19:24 -0500, Benjamin Marzinski wrote:
> dm_flush_maps() returned both 0 and 1 on error, depending on which
> part
> of the function it was in, but the caller was always treating 0 as a
> success. Make dm_flush_maps() always return 1 on error and 0 on
> success.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/devmapper.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
