From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: New dm-bufio with shrinker API
Date: Wed, 7 Sep 2011 14:39:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109071431300.27938@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1109021732490.13426@hs20-bc2-1.build.redhat.com>
	<20110905090428.GA3826@ubuntu> <20110905144913.GB22386@ubuntu>
	<Pine.LNX.4.64.1109051148450.22564@hs20-bc2-1.build.redhat.com>
	<20110906093332.GB3619@ubuntu>
	<Pine.LNX.4.64.1109061202280.21793@hs20-bc2-1.build.redhat.com>
	<20110907094642.GA3729@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110907094642.GA3729@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

> One other optimisation to think about: As you know, if a non-blocking
> lookup of the thinp mapping fails, the bio gets handed across to a
> worker thread to do the blocking lookup.  Is there any way to you
> could make dm_bm_read_try_lock() pass a preload hint to bufio, since
> we know that block is going to be required in the near future?
> 
> - Joe

No, you can't submit any IOs in the request handler (i.e. in dm's "map" 
function). Such IOs are queued and delayed until the request handler 
exits. If it I did it, there would be IO hanging which is not going to be 
finished and a deadlock possibility.

For example:
* process 1 submits a bio in the request handler, bio submittion waits 
until the request handler exits
* process 2 takes the dm-bufio mutex and waits for this bio to be finished 
(thus, it waits for the request handler of process 1 to finish)
* process 1 tries to take the dm-bufio mutex again in the same request 
handler, waiting for process 2, which waits for process 1 --- deadlock.

Mikulas
