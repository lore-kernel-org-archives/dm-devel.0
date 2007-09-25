From: Hannes Reinecke <hare@suse.de>
Subject: Re: Device-mapper-multipath RDAC
Date: Tue, 25 Sep 2007 07:54:39 +0200
Message-ID: <46F8A29F.6060803@suse.de>
References: <200709241706.26322.npf-mlists@eurotux.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200709241706.26322.npf-mlists@eurotux.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Nuno Fernandes wrote:
> hello,
>=20
> Just a question:
>=20
> With recent support for rdac hardware handler in kernel 2.6.23-rc7, wha=
t=20
> configuration should be in storage DS4700? AVT (Automatic Volume transf=
er)=20
> turned on or off?
>=20
Off. AVT is the acronym for 'Automated Volume Transfer', ie the array tri=
es
to transfer the volumes from one controller to the other automatically.

> When it's turned on, luns keep on jumping from controller to controller=
..
>=20
Indeed. That's to be expected.

As a rule:

- With rdac hardware handler: AVT off
- Without hardware handler: AVT on

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
