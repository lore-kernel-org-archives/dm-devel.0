From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: Data corruption on software RAID
Date: Fri, 11 Apr 2008 04:55:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0804110448120.22052@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0804080033430.13352@artax.karlin.mff.cuni.cz>
	<47FD0BE8.4070105@tmr.com>
	<Pine.LNX.4.64.0804100503160.26713@artax.karlin.mff.cuni.cz>
	<47FE224D.2020309@tmr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47FE224D.2020309@tmr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, mingo@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

> Currently you can go for hours without ever reaching a clean state on active
> files. By not deliberately allowing the buffer to change during a write the
> chances for getting consistent data on the disk should be significantly
> improved.

It can already happen that one device writes the sector and other not if 
the power is interrupted. And all RAID implementations already deal with 
it by resynchronizing the modified areas in case of crash. So they could 
resynchronize modify-while-write cases as well, with the same code.

... or I don't know if MM maintainers want to add locking to the pages 
that are under a write. Personally, I wouldn't do it.

> > From my point of view that trick with thread doing sync() and turning off
> > region bits looks best. I'd like to know if that solution doesn't have any
> > other flaw.
> >
> >   
> > > For reliable operation I would want all copies (and/or CRCs) to be 
> > > written on an fsync, by the time I bother to fsync I really, really, 
> > > want the data on the disk.
> > >     
> >
> > fsync already works this way.
> >   
> 
> The point I was making is that after you change the code I would still want
> that to happen. And your comment above seems to indicate a goal of getting
> consistent data after a crash, with less concern that it be the most recent
> data written. Sorry in advance if that's a misreading of "you just must not
> forget to resync them after a crash."

There would be no problem with fsync. Fsync writes the synced data to both 
devices. So after a crash you can select any of the devices as a resync 
master copy, and you get the data that you wrote before sync() or fsync().

Mikulas
