From: Martin Wilck <martin.wilck@suse.com>
Subject: Re: multipath-tools: -1patch in upstream-queue
Date: Wed, 20 May 2020 22:36:59 +0200
Message-ID: <97355996ab3dfeda13cee42a93f92f3ab54d289a.camel@suse.com>
References: <fbbd16f6-3564-288e-4180-6322a2b478da@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <fbbd16f6-3564-288e-4180-6322a2b478da@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Christian Hesse <mail@eworm.de>, dm-devel mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Xose,

On Wed, 2020-05-20 at 18:56 +0200, Xose Vazquez Perez wrote:
> Hi Martin,
>=20
> The JSON patch send by Christian Hesse(twice) is missed, in your
> upstream-queue:
> https://marc.info/?l=3Ddm-devel&m=3D158792878717348 or
> https://marc.info/?l=3Ddm-devel&m=3D158797224229431
>=20
> Thank you.

Right, I missed that one. Thanks for pointing it out.

However, it has no "Reviewed-by:" tag from anyone, including yourself,
so it couldn't be pushed to upstream-queue yet.

Actually, I don't like fixing this this way. I have no idea why the
json-c people did this, but I'd rather fall back to stdbool.h than to 0
and 1.

I'm going to send a modified verson.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
