From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] SCHED: remove proliferation of wait_on_bit action
 functions.
Date: Tue, 13 May 2014 18:45:52 +0200
Message-ID: <20140513164552.GA5226@laptop.programming.kicks-ass.net>
References: <20140501123738.3e64b2d2@notabene.brown>
 <30769.1399997170@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <30769.1399997170@warthog.procyon.org.uk>
Sender: owner-linux-mm@kvack.org
To: David Howells <dhowells@redhat.com>
Cc: NeilBrown <neilb@suse.de>, Oleg Nesterov <oleg@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, dm-devel@redhat.com, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, Steve French <sfrench@samba.org>, Theodore Ts'o <tytso@mit.edu>, Trond Myklebust <trond.myklebust@primarydata.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

On Tue, May 13, 2014 at 05:06:10PM +0100, David Howells wrote:
> NeilBrown <neilb@suse.de> wrote:
>=20
> > The wait_on_bit() call in __fscache_wait_on_invalidate() was ambiguous
> > as it specified TASK_UNINTERRUPTIBLE but used
> > fscache_wait_bit_interruptible as an action function.
> > As any error return is never checked I assumed that 'uninterruptible'
> > was correct.
>=20
> Bug.  It should be uninterruptible in both places.

Thanks David, queued the patch!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
