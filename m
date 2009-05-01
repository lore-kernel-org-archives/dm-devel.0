From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] raid1: use __GFP_NOFAIL
Date: Fri, 1 May 2009 08:04:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0905010801490.16859@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904270658390.12384@hs20-bc2-1.build.redhat.com>
	<20090430231443.GD23302@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090430231443.GD23302@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 1 May 2009, Alasdair G Kergon wrote:

> On Mon, Apr 27, 2009 at 07:01:22AM -0400, Mikulas Patocka wrote:
> > This is a bug I found when implementing the barriers. There should be 
> > __GFP_NOFAIL if the code can't handle an allocation failure.
>  
> See also this one:
>   dm-raid1-mempool-bug-workaround-reversion.patch
> 
> Has the original reason for that workaround gone away now or is that
> mempool still being used incorrectly?
> 
> Alasdair

As I said on chat, don't remove that GFP_IO allocation. The code is 
deadlocky anyway and allocation from a mempool with GFP_ATOMIC and, in 
case of failure, allocation from memory with GFP_IO is the best that can 
be done to reduce the probability of the deadlock.

Mikulas
