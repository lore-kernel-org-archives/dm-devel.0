From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm-thinp: new device mapper target to thin
 provision storage
Date: Wed, 29 Sep 2010 17:20:58 +0200
Message-ID: <1285773658.23010.20.camel@o>
References: <1285706977.22966.20.camel@o> <4CA261C5.7070005@cfl.rr.com>
	<1285759512.23010.1.camel@o>  <4CA341F1.70305@cfl.rr.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CA341F1.70305@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Wed, 2010-09-29 at 09:41 -0400, Phillip Susi wrote:
> On 9/29/2010 7:25 AM, Heinz Mauelshagen wrote:
> > On Tue, 2010-09-28 at 17:44 -0400, Phillip Susi wrote:
> >> How is this different than snapshotting a zero target?
> > 
> > Like Hanness mentioned: you can free space.
> 
> Could you clarify that a bit?  Is space only freed if you reduce the
> length of a device?  You can't do the same with a snapshot?

Not just when you shrink a device, you can release all allocations to an
inactive thin provisioned device as well.

With snapshots the exception store is dropped when you delete the
snapshot as well.

But you can't drop allocated space of a partial exception store because
the exception size is much smaller than the allocation units lvm2 goes
by (ie. extents sized 128MB). Thus dropping exceptions related to a now
past EOD segment within the origin just gives you stale exceptions in
the table w/o the option to reduce allocated space.

> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
