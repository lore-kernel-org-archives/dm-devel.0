From: Neil Brown <neilb@suse.de>
Subject: Does dm avoid container/member loops?
Date: Thu, 5 Oct 2006 15:42:24 +1000
Message-ID: <17700.39744.188262.731633@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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


Hi, 
 I came across an issue with md just recently that could affect dm and
 thought I would ask if dm does anything about it.

 As both dm and md  create a block device using other block
 devices as components, and as components can be added after creation,
 it is theoretically possible to create a loop.
 e.g.
   md0 is a raid0 containing md1 and md2
 md0 could be hot-added as a spare to md1.

 This can create obvious problems such as infinite recursion in called
 to issue_flush_fn (just as one example).

 Presumably exactly the same sort of loop could be attempted with dm.
 Does dm do anything to detect or disable such loops?


 This simplest general approach that I could think of is to add
 loop_detect_fn to 'struct request_queue' which takes a request_queue
 pointer and returns true (of there is a loop) or false.
 Then before (or maybe just after) you attach A as a member of B you
 call
   A->loop_detect_fn(A, B)
 And fail if the result is non-zero.

 The default loop_detect_fn returns 0.
 md and dm provide a loop_detect_fn something like:

    my_loop_detect(struct request_queue *me, struct request_queue *top)
    {
	rv = 0;
	if (me == top)
		return 1;
	lock access to list of components.
        for each component
		rv |= component->loop_detect_fn(component, top);
	unlock
	return rv;
     }

 This would probably give lockdep a major headache, but should detect
 loops reliably, including loops involving both md and dm.

Thoughts?

Thanks,
NeilBrown
