From: Martin Wilck <martin.wilck@suse.com>
Subject: Re: [PATCH v2 0/6] multipath: path validation library
	prep work
Date: Tue, 19 May 2020 14:55:05 +0200
Message-ID: <d7168e4c5ab1a2deabb10ade2d35ea64e2c22ff7.camel@suse.com>
References: <1589864228-1363-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1589864228-1363-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2020-05-18 at 23:57 -0500, Benjamin Marzinski wrote:
> I've been playing around with the SID code more and I've decided to
> hold
> off on submitting the library until I have it working with the SID
> multipath module better. Instead, I've pulled out the common code
> thatremember_cmdline_wwid
> multipath -u/-c and the library can use, and put it into
> libmultipath.
>=20
> I've also removed some of the ordering differences between the
> existing
> code and my new code.  Right now, the only difference is that if a
> path
> is currently multipathed, it will always be claimed as a valid path.
>=20
> Patches 0001 & 0002 are the same as in my "RFC PATCH v2" set, and
> patch
> 0005 is the same as my "libmultipath: simplify failed wwid code"
> patch.
>=20
> Only patches 0003 and 0004 haven't been posted before.
>=20
> Changes from v1:
> 0003: Minor fixes suggested by Martin Wilck
> 0004: Fixed typo, added tests for filter_property() and switched some
>       tests to pass the check_multipathd code in various ways,
> instead
>       of skipping it, as suggested by Martin Wilck
>=20

This set (v2) doesn't apply cleanly to upstream, neither with or
without my late patches. It's been generated against a tree that
included "Make multipath add wwids from kernel cmdline mpath.wwids with
-A" (https://patchwork.kernel.org/patch/4445691/). From my series, it's
missing "libmultipath: move libsg into libmultipath".

Apart from that, for the series:

Reviewed-by: Martin Wilck <mwilck@suse.com>

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
