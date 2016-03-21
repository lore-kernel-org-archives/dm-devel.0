From: Werner Koch <wk@gnupg.org>
Subject: Re: [PATCH] dmsetup: improve message command
Date: Mon, 21 Mar 2016 11:55:58 +0100
Message-ID: <87egb45cch.fsf@wheatstone.g10code.de>
References: <87y4a7wvdi.fsf@wheatstone.g10code.de>
	<8737rogi4v.fsf@wheatstone.g10code.de> <56EBEBFB.6070107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56EBEBFB.6070107@redhat.com> (Zdenek Kabelac's message of "Fri,
	18 Mar 2016 12:52:27 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 18 Mar 2016 12:52, zkabelac@redhat.com said:

> It looked usable - thought could you trim down the zeroing of
> dm-malloced area (wipememory)  macro.

Actually the patch zeroes the given string (from command line or stdin).
That is in general pretty short and given that this is a command line
tool there won't be any noticable speed penality.

> It's useless for heap allocation.

Sorry, I have to dissent: If dmsetup is swapped out the key would end up
in the swap (which is still not encrypted by default on Linux).  free()
does not zero out the memory and thus another malloc may reveal the key.
Thus it is important to zeroise all sensitive data before a free.

> Unless you show example and compiler which would optimize 'library' call away.
> a) such compiler would be horrible broken (since I could always LD_PRELOAD
> my free() implementation),

It is not about removing a library call but about optimizing compilers
which may remove a plain memset if they can deduce that the memory is
not used after that memset call.  Can you exclude that it will never
happen that a somehow attributed free() will be detected by a future
gcc/clang version to elimination - what they call - dead code?

The current discussion is to provide a memset_s function which other
platforms already have, for example see:

  http://www.openwall.com/lists/musl/2015/09/09/5

The wipememory macro we use in GnuPG is currently the most portable
solution.  There are way faster implementations, for example what we use
in Libgcrypt, but that is overkill and frankly for Linux we should wait
for a memset_s.

> b) we would need to do same for dm_task_struct - since your 'dmsetup mem
> is duplicated for dm_task.

Right.  However a full audit of sensitive code paths in dmsetup was out
of my scope.  I merely did what can be expected for new code.


Shalom-Salam,

   Werner

-- 
Die Gedanken sind frei.  Ausnahmen regelt ein Bundesgesetz.
