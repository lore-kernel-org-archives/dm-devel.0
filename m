From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: multipathd.init
Date: Sun, 10 Apr 2005 21:22:56 +0200
Message-ID: <20050410192256.GN12752@marowsky-bree.de>
References: <20050401204048.GI14307@agk.surrey.redhat.com>
	<1112389744.8118.26.camel@zezette>
	<20050401211902.GL14307@agk.surrey.redhat.com>
	<1112390705.8118.34.camel@zezette>
	<1112521418.8118.49.camel@zezette>
	<20050404211520.GB14307@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050404211520.GB14307@agk.surrey.redhat.com>
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

On 2005-04-04T22:15:20, Alasdair G Kergon <agk@redhat.com> wrote:

> For Red Hat distributions, I intend to use glibc static builds for=20
> the multipath-tools, same as for lvm2 & dmsetup.
>=20
> I don't want the worry of having to support more than one libc.
> (All tests have to be done twice then, for starters, and you lose
> use of glibc features the other libraries don't support.)
>=20
> So much is getting pushed into the initrd these days, that there's=20
> even the prospect of shared object support being added one day.

Again, same here. Though I'm not even sure our initrd doesn't have the
glibc.so already ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
