From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [bug report] dm: add statistics support
Date: Fri, 16 Mar 2018 13:54:37 +0300
Message-ID: <20180316105437.qyu2ykg5uyclhnrm@mwanda>
References: <20180315142532.GA29284@mwanda>
	<alpine.LRH.2.02.1803151514260.21432@file01.intranet.prod.int.rdu2.redhat.com>
	<20180316105220.x7eyeswzlpoyqmcb@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180316105220.x7eyeswzlpoyqmcb@mwanda>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 16, 2018 at 01:52:20PM +0300, Dan Carpenter wrote:
> Gar.  I'm sorry, this is really new code and you're right that it's
> buggy.
> 
> On Thu, Mar 15, 2018 at 03:25:52PM -0400, Mikulas Patocka wrote:
> > > The patch fd2ed4d25270: "dm: add statistics support" from Aug 16,
> > > 2013, leads to the following static checker warning:
> > > 
> > > 	drivers/md/dm-stats.c:371 dm_stats_create()
> > > 	warn: dead code because of 's->id == ((~0 >> 1))' and 'tmp_s->id < s->id'
> > 
> > ((~0 >> 1)) is -1 and we are comparing it against INT_MAX. Perhaps the 
> > static checker is buggy because it believes that INT_MAX is -1.
> > 
> > INT_MAX definition in the linux kernel is ((int)(~0U>>1)).
> > 
> 
> Yeah, the format of the smatch outputs is bad.  It gets INT_MAX correct
> internally it just prints it out badly.  The problem here is that Smatch
> is crap at parsing loops.  Parsing seems like an essential thing, but

Parsing *loops*, I meant.

regards,
dan carpenter

> you'd be surprised how many times you can get away with parsing them
> badly.  The main issue is that parsing them correctly is probably a big
> slow down because you'd have to go through a lot of code twice...
> 
> Anyway, thanks for looking at this and sorry for the noise.
> 
> regards,
> dan carpenter
