From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Re: Was: [patch 1/1] md/dm: Reduce stack usage with
	stacked block devices
Date: Wed, 11 Jan 2006 16:00:29 -0500
Message-ID: <1137013229.10270.117.camel@localhost.localdomain>
References: <62b0912f0601110445w34d480c4n56d8f02056baef26@mail.gmail.com>
	<20060111135301.GY4346@agk.surrey.redhat.com>
	<62b0912f0601111226q4732fc23qee79b7a2fc215fe9@mail.gmail.com>
	<1137012072.10270.113.camel@localhost.localdomain>
	<20060111205437.GD4346@agk.surrey.redhat.com>
Reply-To: mingz@ele.uri.edu,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060111205437.GD4346@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: akpm@osdl.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2006-01-11 at 20:54 +0000, Alasdair G Kergon wrote:
> On Wed, Jan 11, 2006 at 03:41:11PM -0500, Ming Zhang wrote:
> > does this mean/confirm linux 2.6.x will not have a stable snapshot
> > support any time soon?
>  
> Stable, yes.

yes, we want stable first. 

> Efficient, unlikely with the current implemention - hence the need
> for a rewrite.

> 
> If you have 5 snapshots of the same origin, the current implemention
> takes 5 copies of the data when you change it. That approach is
> never going to scale well!  And it uses lots of memory.

yes, you are right. is there any new rewrite action proposed or planned?

> 
> Next patch is heading for dm-devel in the next hour or so...

thanks!


> 
> Alasdair
