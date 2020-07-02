From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 3/4] kpartx: handle alternate bsd disklabel
	location
Date: Thu, 2 Jul 2020 10:52:29 -0500
Message-ID: <20200702155229.GB11089@octiron.msp.redhat.com>
References: <1593643176-6206-1-git-send-email-bmarzins@redhat.com>
	<1593643176-6206-4-git-send-email-bmarzins@redhat.com>
	<42e56b533d5f87dd8ba4f14351d5aeb3a5b4a7f2.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42e56b533d5f87dd8ba4f14351d5aeb3a5b4a7f2.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 02, 2020 at 03:12:58PM +0000, Martin Wilck wrote:
> On Wed, 2020-07-01 at 17:39 -0500, Benjamin Marzinski wrote:
> > bsd disk labels can either be at the start of the second sector, or
> > 64
> > bytes into the first sector, but kpartx only handled the first case.
> > However the second case is what parted creates, and what the linux
> > kernel partition code expects.  kpartx should handle both cases.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> I can see that for parted, but not for the kernel
> (https://elixir.bootlin.com/linux/latest/source/block/partitions/msdos.c#=
L368)

https://elixir.bootlin.com/linux/latest/source/block/partitions/osf.c

-Ben

> Anyway:
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
