From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Wed, 08 Nov 2006 10:54:45 +0100
Message-ID: <1162979690.3138.273.camel@laptopd505.fenrus.org>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<20061107122837.54828e24.akpm@osdl.org> <45510C73.7060408@redhat.com>
	<20061107150017.fb78a327.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061107150017.fb78a327.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


> 
> You're asking me? ;)
> 
> Guys, I'm going to park this patch pending a full description of what it
> does, a description of what the above hunk is doing and pending an
> examination of whether we'd be better off changing the mutex-debugging code
> rather than switching to semaphores.

It's not used as a mutex. Sad but true. It's not so easy to say "just
shut up the debug code", because it's just not that easy: The interface
allows double "unlock", which is fine for semaphores for example. There
fundamentally is no "owner" for this case, and all the mutex concepts
assume that there is an owner. If the owner goes away, pointers to their
task struct for example are no longer valid (used by lockdep and the
other debugging parts). It's what makes the difference between a mutex
and a semaphore: a mutex has an owner and several semantics follow from
that. These semantics allow a more efficient implementation (no multiple
"owners" possible) but once you go away from that fundamental property,
soon we'll see "oh and it needs <this extra code> to cover the wider
semantics correctly.. and soon you have a semaphore again.

Let true semaphores be semaphores, and make all real mutexes mutexes.
But lets not make actual semaphores use mutex code...


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org
