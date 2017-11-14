From: Joe Thornber <thornber@redhat.com>
Subject: Re: Significantly dropped dm-cache performance in 4.13
 compared to 4.11
Date: Tue, 14 Nov 2017 11:00:47 +0000
Message-ID: <20171114110046.6lmv34rqngs6pjwf@reti>
References: <CAAxjCExHqssZ8vuCC19_NP1io=StFAYk48nqDfudhjD-PyLZCg@mail.gmail.com>
	<20171107144157.6yng4owvmmcm33qj@reti>
	<CAAxjCEy5yc7G1iBznLFCwEVWgkijSUD29oZwHsD5b2+zyA94ig@mail.gmail.com>
	<CAAxjCEwaGHCG1qEKfUJrHkhvL9HU9qs362tmy2O-ib3wSY-0bg@mail.gmail.com>
	<20171113190111.GE32510@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171113190111.GE32510@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: stefanrin@gmail.com
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 13, 2017 at 02:01:11PM -0500, Mike Snitzer wrote:
> On Mon, Nov 13 2017 at 12:31pm -0500,
> Stefan Ring <stefanrin@gmail.com> wrote:
> 
> > On Thu, Nov 9, 2017 at 4:15 PM, Stefan Ring <stefanrin@gmail.com> wrote:
> > > On Tue, Nov 7, 2017 at 3:41 PM, Joe Thornber <thornber@redhat.com> wrote:
> > >> On Fri, Nov 03, 2017 at 07:50:23PM +0100, Stefan Ring wrote:
> > >>> It strikes me as odd that the amount read from the spinning disk is
> > >>> actually more than what comes out of the combined device in the end.
> > >>
> > >> This suggests dm-cache is trying to promote too way too much.
> > >> I'll try and reproduce the issue, your setup sounds pretty straight forward.
> > >
> > > I think it's actually the most straight-forward you can get ;).
> > >
> > > I've also tested kernel 4.12 in the meantime, which behaves just like
> > > 4.13. So the difference in behavior seems to have been introduced
> > > somewhere between 4.11 and 4.12.
> > >
> > > I've also done plain dd from the dm-cache disk to /dev/null a few
> > > times, which wrote enormous amounts of data to the SDD. My poor SSD
> > > has received the same amount of writes during the last week that it
> > > has had to endure during the entire previous year.
> > 
> > Do you think it would make a difference if I removed and recreated the cache?
> > 
> > I don't want to fry my SSD any longer. I've just copied several large
> > files into the dm-cached zfs dataset, and while reading them back
> > immediately afterwards, the SSD started writing crazy amounts again.
> > In my understanding, linear reads should rarely end up on the cache
> > device, but that is absolutely not what I'm experiencing.
> 
> Joe tried to reproduce your reported issue today and couldn't.

I'm not sure what's going on here.  Would you mind sending me the
metadata please?  Either a cache_dump of it, or a copy of the metadata
dev?

- Joe
