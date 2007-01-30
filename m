From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [RFC] Multiple Snapshots - Manageability problem
Date: Mon, 29 Jan 2007 23:39:43 -0500
Message-ID: <170fa0d20701292039u144d29dcq86133ebe2514ff57@mail.gmail.com>
References: <45A6CC0F.A9E3.000B.0@novell.com>
	<20070112215917.GB7441@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070112215917.GB7441@ether.msp.redhat.com>
Content-Disposition: inline
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

On 1/12/07, Benjamin Marzinski <bmarzins@redhat.com> wrote:
> On Thu, Jan 11, 2007 at 11:18:13AM -0700, Vijai Babu Madhavan wrote:

> > I would like to receive some comments about what users, developers
> > and others think about this.
> >
>
> Have you taken a look at Daniel Phillips cluster snapshot work?
>
> http://sources.redhat.com/cluster/csnap/index.html
>
> The code is not complete, and am not sure if Daniel is doing any work on it at
> all, but it has a nice design to store the cow data, and that URL contains the
> design documents. In brief:
>
> There is one device that stores all cow data (the snapstore). It has three
> main parts, an allocation bitmap, a superblock that stores metadata, and
> an exception btree. The exception btree is indexed by the location of the data
> on the origin. For each chuck on the origin device that has cow data for one or
> more snapshots, there is an exception in the btree that lists the location of
> the cow data on the snapstore device, and the snapshots which are using that
> exception.  This list of snapshots is stored as a bitmask.
>
> This means that no matter now many snapshots you have, all you need to do to
> write to the origin is check the btree.

Daniel's work has become an integral part of the hotcakes project:
http://code.google.com/p/hotcakes/

There was/is talk of making the dm targets used for ddsnap work
locally as a replacement for dm-snapshot.  It might be wise to catch
up with the hotcakes people to see if you could leverage it as the
basis for a dm-snapshot++

Mike
