From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 2/3] set pthread stack size to at least
	PTHREAD_STACK_MIN
Date: Mon, 30 Mar 2009 18:30:05 -0500
Message-ID: <20090330233005.GL15911@ether.msp.redhat.com>
References: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
	<1236883093-2989-3-git-send-email-bmarzins@redhat.com>
	<49BA3ACF.1010101@suse.de>
	<20090313205514.GL32340@ether.msp.redhat.com>
	<49BE7A89.1040808@suse.de>
	<20090316230847.GM32340@ether.msp.redhat.com>
	<95d3ae170903170056l467c50c1v40a3657f001030e3@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <95d3ae170903170056l467c50c1v40a3657f001030e3@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 17, 2009 at 07:56:39AM +0000, Joe Thornber wrote:
> 2009/3/16 Benjamin Marzinski <bmarzins@redhat.com>:
> > I definitely see a problem if we use the default stacksize on ia64
> > machines. =A0In RHEL5 at least, it's 10Mb per thread. =A0With one wai=
ter
> > thread per multipath device, you get a gigabyte of memory wasted on
> > machines with over a hundred multipath devices.
>=20
> You need to check whether this is 1G of physical memory, or just a 1G
> chunk out of the address space.
>=20
> Some threads need to have their stack reserved and locked into memory
> before calls into the kernel.  This avoids deadlocks where the stack
> gets paged out, but he vm can't page it back in until the thread
> completes ...
>=20
> It sounds like you have many more threads running these days than when
> I last looked at LVM, it's not clear to me how many of these are ones
> that need their stacks mem-locking.  Do you have an idea ?
>=20
> If they don't need mem-locking then as long as you're not forcing the
> stack to be physically allocated I wouldn't worry too much about
> consuming address space.
>=20
> Hope that ramble made sense,

Yeah, sorry for missing your reply.

The issue is that the event threads occasionally need to hold mutexs
that the checker thread (the one that restores downed paths) needs. If
the system was low on memory because a number of devices had no paths to
them, and IO was queueing up, you could run into a problem where a event
thread was paged out while holding a mutex. With the mutex locked, the
checker thread could never restore the downed paths, letting the IO
complete, and freeing up the memory.=20

Christophe, if people are O.k. with these patches now, could they get
in.

Thanks

-Ben
>=20
> - Joe
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
