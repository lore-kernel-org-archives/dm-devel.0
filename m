From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] SCHED: remove proliferation of wait_on_bit action functions.
Date: Tue, 13 May 2014 17:06:10 +0100
Message-ID: <30769.1399997170@warthog.procyon.org.uk>
References: <20140501123738.3e64b2d2@notabene.brown>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140501123738.3e64b2d2@notabene.brown>
Sender: owner-linux-mm@kvack.org
To: NeilBrown <neilb@suse.de>
Cc: dhowells@redhat.com, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, dm-devel@redhat.com, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, Steve French <sfrench@samba.org>, Theodore Ts'o <tytso@mit.edu>, Trond Myklebust <trond.myklebust@primarydata.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

NeilBrown <neilb@suse.de> wrote:

> The wait_on_bit() call in __fscache_wait_on_invalidate() was ambiguous
> as it specified TASK_UNINTERRUPTIBLE but used
> fscache_wait_bit_interruptible as an action function.
> As any error return is never checked I assumed that 'uninterruptible'
> was correct.

Bug.  It should be uninterruptible in both places.

David

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
