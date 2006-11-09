From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH 0/3] HP HSV200 update
Date: Thu, 09 Nov 2006 22:29:56 +0100
Message-ID: <1163107797.10466.9.camel@localhost.localdomain>
References: <455302C6.9090207@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <455302C6.9090207@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Le jeudi 09 novembre 2006 =C3=A0 11:28 +0100, Hannes Reinecke a =C3=A9cri=
t :
> Hi Christophe,
>=20
> this patchset implements a new field 'revision' for the hardware table,=
=20
> which is filled with the 'revision' field from the SCSI Inquiry. The=20
> reason for this is that HP switched the behaviour during a firmware=20
> update (ie from using START_STOP_UNIT to ALUA). And to support this=20
> properly we'll have to match against the 'revision' field, too.
>=20
> In doing so I've found a bug in load_config(). Currently, we're loading
> the default hardware table with comparing via regex. However, as the=20
> default table also contains regexp we'll end up comparing _two_ regexps=
,
> the outcome of which is a quite peculiar to say the least. We should=20
> rather be using a simple string match to avoid this pitfall.
>=20
> So, this patchset does
> - Correct load_config() to compare entries via string match
> - Implements matching against the revision field
> - Updates the hardware table for HP HSV200 support.
>=20
Good stuff.
Patchset applied.

For now I removed the undefined RR_WEIGHT_PRIORITIES you introduced in
the HSV2.* defaults. You can submit the whole thing if you want.

Thanks,
cvaroqui
