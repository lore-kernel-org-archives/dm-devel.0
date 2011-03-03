From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Huge memory allocation
Date: Thu, 03 Mar 2011 11:00:19 +0100
Message-ID: <4D6F66B3.2050401@redhat.com>
References: <E04C10E329E0CD40816C9C17AE53BBD301863B7E@kit001.kaminario.local>	<20110301134606.GN3626@agk-dp.fab.redhat.com>	<E04C10E329E0CD40816C9C17AE53BBD301863EB0@kit001.kaminario.local>	<4D6F544B.409@redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863ED7@kit001.kaminario.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E04C10E329E0CD40816C9C17AE53BBD301863ED7@kit001.kaminario.local>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Dne 3.3.2011 09:58, Eli Malul napsal(a):
> I would like to accelerate read IO performance for user data which
> resides on one machine (with low IO performance due to slow media) and
> might be scattered on many different extents by mirroring these extents
> to another machine with much better IO performance and direct read
> requests to that machine (I already added a patch to the dm-raid1.c to
> set preferred read capability).
> 
> Any suggestions would be appreciated...

There were some projects like  dm cache and probably few others.
(http://visa.cis.fiu.edu/ming/dmcache/)
You will need to create a new dm target for the thing you try to achieve.
Handling this in userspace could only serve for prototype thing.

Structures in  libdm are not designed to work efficiently with millions of
extents passed to kernel through ioctl operation - this path isn't probably
the best one...

You may still want to check dm-replicator or drdb technology.

But it all depends on how do you plan to synchronize above the block level,
and how the write operation is supposed to handled.

Zdenek
