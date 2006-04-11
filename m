From: Jure =?UTF-8?Q?Pe=C4=8Dar?= <pegasus@nerv.eu.org>
Subject: Re: Device Mapper as a cache for SAN?
Date: Tue, 11 Apr 2006 10:55:52 +0200
Message-ID: <20060411105552.3f32c4ef.pegasus@nerv.eu.org>
References: <a4e6962a0604101058w75a7147cy8860bc9ebf8f269e@mail.gmail.com>
	<20060410184531.GA12908@www.ewilts.org>
	<a4e6962a0604101246y5f912a01y72519a6c58291f5@mail.gmail.com>
	<1144704325.8591.170.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1144704325.8591.170.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 10 Apr 2006 17:25:25 -0400
Ming Zhang <mingz@ele.uri.edu> wrote:

> still, what is the main benefit of this cache? what u mean "local disk
> page cache"? use "local disk" as page cache or page cache for "local
> disk" or something else?

I recently did some tests with ext3 data journaling and discovered that
large journals eat almost as much system memory as its size, which is a
bit crazy. Some might argue that configuring 4gb journal is crazy too,
but there are scenarios where this might be beneficial (think large
mail servers with gazillion small writes, which journal turns into one
big sequential write). So if something like external journal can be
implemented in dm, fs-agnostic and not as memory hungry, I'd be very
interested.

--=20

Jure Pe=C4=8Dar
http://jure.pecar.org
