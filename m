From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Device Mapper as a cache for SAN?
Date: Tue, 11 Apr 2006 08:57:39 -0400
Message-ID: <1144760259.26235.9.camel@localhost.localdomain>
References: <a4e6962a0604101058w75a7147cy8860bc9ebf8f269e@mail.gmail.com>
	<20060410184531.GA12908@www.ewilts.org>
	<a4e6962a0604101246y5f912a01y72519a6c58291f5@mail.gmail.com>
	<1144704325.8591.170.camel@localhost.localdomain>
	<20060411105552.3f32c4ef.pegasus@nerv.eu.org>
Reply-To: mingz@ele.uri.edu,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060411105552.3f32c4ef.pegasus@nerv.eu.org>
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

On Tue, 2006-04-11 at 10:55 +0200, Jure Pe=C4=8Dar wrote:
> On Mon, 10 Apr 2006 17:25:25 -0400
> Ming Zhang <mingz@ele.uri.edu> wrote:
>=20
> > still, what is the main benefit of this cache? what u mean "local dis=
k
> > page cache"? use "local disk" as page cache or page cache for "local
> > disk" or something else?
>=20
> I recently did some tests with ext3 data journaling and discovered that
> large journals eat almost as much system memory as its size, which is a
> bit crazy. Some might argue that configuring 4gb journal is crazy too,
> but there are scenarios where this might be beneficial (think large
> mail servers with gazillion small writes, which journal turns into one
> big sequential write). So if something like external journal can be
> implemented in dm, fs-agnostic and not as memory hungry, I'd be very
> interested.

even u journal is a big sequential write, u data write are not. so the
combined performance will not have big difference.=20

u mean u journal contain everything? including log and data? you might
want to ask ext3 list and ask them why take so many memory with a 4GB
journal. Also i think journal will write to disk very fast, so after
written to disk, the ram can be reclaimed.

also i do not see how a DM disk cache can help you on this.

ming
