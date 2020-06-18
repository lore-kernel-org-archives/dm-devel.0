From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 5/7] multipath: make flushing maps work like
 other commands
Date: Thu, 18 Jun 2020 20:38:46 +0000
Message-ID: <bffcf533c947830e4bc83cec575bb74fa3615d5e.camel@suse.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<1592439867-18427-6-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1592439867-18427-6-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <CE3AEBBA311FCE44875DDB740548CAB2@eurprd04.prod.outlook.com>
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
> The config structure doesn't need a special variable just for
> removes.
> Multipath can just use the cmd variable, like it does for the other
> commands.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
