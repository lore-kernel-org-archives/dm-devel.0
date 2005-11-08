From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [dm-devel] Re: [PATCH resubmit] do_mount: reduce stack consumption
Date: Tue, 08 Nov 2005 11:32:13 +1100
Message-ID: <436FF20D.8030200@yahoo.com.au>
References: <20051104105026.GA12476@osiris.boeblingen.de.ibm.com>	<20051104084829.714c5dbb.akpm@osdl.org>	<20051104212742.GC9222@osiris.ibm.com>	<20051104235500.GE5368@stusta.de>	<20051104160851.3a7463ff.akpm@osdl.org>	<Pine.GSO.4.60.0511051108070.2449@mango.itee.uq.edu.au>	<20051104173721.597bd223.akpm@osdl.org>	<17260.17661.523593.420313@cse.unsw.edu.au>	<17262.40176.342746.634262@cse.unsw.edu.au> <20051107153706.2f3c8b67.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965633AbVKHAa3@vger.kernel.org>
In-Reply-To: <20051107153706.2f3c8b67.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Neil Brown <neilb@suse.de>, dm-devel@redhat.com, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, aherrman@de.ibm.com, bunk@stusta.de, cplk@itee.uq.edu.au
List-Id: dm-devel.ids

Andrew Morton wrote:
> Neil Brown <neilb@suse.de> wrote:
> 
>>...
>>Reduce stack usage with stacked block devices
>>
>>...
>>diff ./include/linux/sched.h~current~ ./include/linux/sched.h
>>--- ./include/linux/sched.h~current~	2005-11-07 10:01:36.000000000 +1100
>>+++ ./include/linux/sched.h	2005-11-07 10:02:23.000000000 +1100
>>@@ -829,6 +829,9 @@ struct task_struct {
>> /* journalling filesystem info */
>> 	void *journal_info;
>> 
>>+/* stacked block device info */
>>+	struct bio *bio_list, **bio_tail;
>>+
>> /* VM state */
>> 	struct reclaim_state *reclaim_state;
>> 
> 
> 
> More state in the task_strut is a bit sad, but not nearly as sad as deep
> recursion in our deepest codepath..
> 
> Possibly one could do:
> 
> struct make_request_state {
> 	struct bio *bio_list;
> 	struct bio **bio_tail;
> };
> 
> and stick a `struct make_request_state *' into the task_struct and actually
> allocate the thing on the stack.  That's not much nicer though.

Possibly it could go into struct io_context?

-- 
SUSE Labs, Novell Inc.

Send instant messages to your online friends http://au.messenger.yahoo.com 
