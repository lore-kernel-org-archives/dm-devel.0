From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH]  rm alloc_page from dm-emc take 2
Date: Mon, 11 Apr 2005 13:40:27 +0200
Message-ID: <20050411114027.GI12752@marowsky-bree.de>
References: <425A6145.7010302@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <425A6145.7010302@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>, Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2005-04-11T04:36:37, Mike Christie <michaelc@cs.wisc.edu> wrote:

> I am not sure if the first mail got sent out. Here is
> the correct mail with the patch.
>=20
> Hey Lars,
>=20
> Here is what I meant. A Page for just something around 8-16 bytes
> seems wasteful. Plus there is no reserve.
>=20
> If you have to end up setting more bits maybe it is better to
> preallocate a command per device at create time, or maybe since
> there are four different combos I should have done it with this
> patch?
>=20
> This was made against 2.6.12-rc2. Only compile tested.

Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>

Looks sane to me. Thanks!


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
