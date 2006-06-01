From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [multipath-tools] [patch] retry tur on reset
Date: Thu, 01 Jun 2006 20:38:07 +0200
Message-ID: <1149187087.8452.79.camel@localhost.localdomain>
References: <1149107158.5790.3.camel@ca-bwong3.trans.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1149107158.5790.3.camel@ca-bwong3.trans.corp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bwong@pillardata.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Le mercredi 31 mai 2006 =C3=A0 13:25 -0700, Brian Wong a =C3=A9crit :
> hi christophe,
>=20
> this patch retries the tur sgio in the tur checker when the status
> returned is a scsi reset. =20
>=20
Interesting.
Can you share a little background about why this is needed, test case ?

Regards,
cvaroqui
