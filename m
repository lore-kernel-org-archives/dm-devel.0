From: "Eli Malul" <eli.malul@kaminario.com>
Subject: Re: Huge memory allocation
Date: Thu, 3 Mar 2011 10:58:51 +0200
Message-ID: <E04C10E329E0CD40816C9C17AE53BBD301863ED7@kit001.kaminario.local>
References: <E04C10E329E0CD40816C9C17AE53BBD301863B7E@kit001.kaminario.local>	<20110301134606.GN3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863EB0@kit001.kaminario.local>
	<4D6F544B.409@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4D6F544B.409@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, undisclosed-recipients <undisclosed-recipients>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I would like to accelerate read IO performance for user data which
resides on one machine (with low IO performance due to slow media) and
might be scattered on many different extents by mirroring these extents
to another machine with much better IO performance and direct read
requests to that machine (I already added a patch to the dm-raid1.c to
set preferred read capability).

Any suggestions would be appreciated...

-----Original Message-----
From: Zdenek Kabelac [mailto:zkabelac@redhat.com] 
Sent: Thursday, March 03, 2011 10:42 AM
To: undisclosed-recipients
Cc: Eli Malul; device-mapper development
Subject: Re: [dm-devel] Huge memory allocation

Dne 3.3.2011 09:05, Eli Malul napsal(a):
> I am expecting to have lots of (up to million) scattered extents
across
> some volumes which I am required to mirror.
> Since mirror mapped device with a table that large consume unbearable
> amount of memory (e.g. for 10,000 extents I saw about 6 Giga of memory
> allocated by the device-mapper) I am going to create two linear
devices
> which maps these extents and mirror them.
> 
> In addition, I am required to preserve the original extent's offsets
> since they are an existing user data used by DB applications.
> To achieve that I will create another linear device to simulate the
> original extent's offsets which shall be mapped to the created
mirrored
> device so, the client will continue to read and write the same
offsets.
> 



Aren't you trying to reinvent  dm-replicator target ?
(available as an extra kernel patch)

Maybe you should first describe exactly what are you trying to achieve.
I'd guess there would be better ways to achieve that goal.

Updating kernel tables is expensive operation - especially if you plan
to have
its size in the range of multiple megabytes - so it looks like wrong
plan...

Zdenek
