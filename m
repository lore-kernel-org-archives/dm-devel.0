From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] SCHED: remove proliferation of wait_on_bit action
 functions.
Date: Thu, 5 Jun 2014 14:45:09 +0200
Message-ID: <20140605124509.GA1975@gmail.com>
References: <20140501123738.3e64b2d2@notabene.brown>
 <20140522090502.GB30094@gmail.com>
 <20140522195056.445f2dcb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140522195056.445f2dcb@notabene.brown>
Sender: owner-linux-mm@kvack.org
To: NeilBrown <neilb@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, dm-devel@redhat.com, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, Steve French <sfrench@samba.org>, Theodore Ts'o <tytso@mit.edu>, Trond Myklebust <trond.myklebust@primarydata.com>, Ingo Molnar <mingo@redhat.com>, Roland McGrath <roland@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids


* NeilBrown <neilb@suse.de> wrote:

> On Thu, 22 May 2014 11:05:02 +0200 Ingo Molnar <mingo@kernel.org> wrote=
:
>=20
> >=20
> > * NeilBrown <neilb@suse.de> wrote:
> >=20
> > > [[ get_maintainer.pl suggested 61 email address for this patch.
> > >    I've trimmed that list somewhat.  Hope I didn't miss anyone
> > >    important...
> > >    I'm hoping it will go in through the scheduler tree, but would
> > >    particularly like an Acked-by for the fscache parts.  Other acks
> > >    welcome.
> > > ]]
> > >=20
> > > The current "wait_on_bit" interface requires an 'action' function
> > > to be provided which does the actual waiting.
> > > There are over 20 such functions, many of them identical.
> > > Most cases can be satisfied by one of just two functions, one
> > > which uses io_schedule() and one which just uses schedule().
> > >=20
> > > So:
> > >  Rename wait_on_bit and        wait_on_bit_lock to
> > >         wait_on_bit_action and wait_on_bit_lock_action
> > >  to make it explicit that they need an action function.
> > >=20
> > >  Introduce new wait_on_bit{,_lock} and wait_on_bit{,_lock}_io
> > >  which are *not* given an action function but implicitly use
> > >  a standard one.
> > >  The decision to error-out if a signal is pending is now made
> > >  based on the 'mode' argument rather than being encoded in the acti=
on
> > >  function.
> >=20
> > this patch fails to build on x86-32 allyesconfigs.
>=20
> Could you share the build errors?

Sure, find it attached below.

> >=20
> > Could we keep the old names for a while, and remove them in the next=20
> > cycle or so?
>=20
> I don't see how changing the names later rather than now will reduce th=
e
> chance of errors... maybe I'm missing something.

Well, it would reduce build errors?

Thanks,

	Ingo

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>
fs/cifs/file.c: In function =E2=80=98cifs_oplock_break=E2=80=99:
fs/cifs/file.c:3652:4: warning: passing argument 3 of =E2=80=98wait_on_bi=
t=E2=80=99 makes integer from pointer without a cast [enabled by default]
    cifs_pending_writers_wait, TASK_UNINTERRUPTIBLE);
    ^
In file included from include/linux/fs.h:6:0,
                 from fs/cifs/file.c:24:
include/linux/wait.h:878:1: note: expected =E2=80=98unsigned int=E2=80=99=
 but argument is of type =E2=80=98int (*)(void *)=E2=80=99
 wait_on_bit(void *word, int bit, unsigned mode)
 ^
fs/cifs/file.c:3652:4: error: too many arguments to function =E2=80=98wai=
t_on_bit=E2=80=99
    cifs_pending_writers_wait, TASK_UNINTERRUPTIBLE);
    ^
In file included from include/linux/fs.h:6:0,
                 from fs/cifs/file.c:24:
include/linux/wait.h:878:1: note: declared here
 wait_on_bit(void *word, int bit, unsigned mode)
 ^
  CC      kernel/smp.o
  CC      kernel/trace/trace_event_perf.o
make[2]: *** [fs/cifs/file.o] Error 1
make[2]: *** Waiting for unfinished jobs....
  CC      drivers/bcma/sprom.o
  CC      fs/btrfs/locking.o
  LD      sound/isa/ad1848/snd-ad1848.o
  LD      sound/isa/ad1848/built-in.o
  CC      sound/isa/cs423x/cs4231.o
  CC      lib/fonts/fonts.o
  CC      lib/fonts/font_sun8x16.o
  CC      drivers/bcma/driver_chipcommon.o
  CC      lib/fonts/font_sun12x22.o

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
