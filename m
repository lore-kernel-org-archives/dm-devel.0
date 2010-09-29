From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm-thinp: new device mapper target to thin
 provision storage
Date: Wed, 29 Sep 2010 13:25:36 +0200
Message-ID: <1285759536.23010.2.camel@o>
References: <1285706977.22966.20.camel@o> <4CA261C5.7070005@cfl.rr.com>
	<4CA2DCCE.3070905@suse.de>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CA2DCCE.3070905@suse.de>
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

On Wed, 2010-09-29 at 08:29 +0200, Hannes Reinecke wrote:
> Phillip Susi wrote:
> > On 9/28/2010 4:49 PM, Heinz Mauelshagen wrote:
> >> These are 2 new device mapper targets "thinp" and "thinp-dev"
> >> implemented in one module, which allow for thin provisioning of storage
> >> on a single host from a storage pool to an arbitrary amount of devices.
> > 
> > How is this different than snapshotting a zero target?
> > 
> Main difference is that you actually can free up space.
> You can't with snapshotting as then a rollback
> becomes impossible.
> 

Yes, that's right.

Heinz

> Cheers,
> 
> Hannes
