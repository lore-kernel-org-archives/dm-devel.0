From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Device Mapper as a cache for SAN?
Date: Mon, 10 Apr 2006 20:50:22 -0400
Message-ID: <1144716622.8591.200.camel@localhost.localdomain>
References: <a4e6962a0604101058w75a7147cy8860bc9ebf8f269e@mail.gmail.com>
	<20060410184531.GA12908@www.ewilts.org>
	<a4e6962a0604101246y5f912a01y72519a6c58291f5@mail.gmail.com>
	<1144704325.8591.170.camel@localhost.localdomain>
	<a4e6962a0604101728o42596adaldb5a2ceb9348f37e@mail.gmail.com>
	<1144715744.8591.197.camel@localhost.localdomain>
	<a4e6962a0604101747g489fb334hb26787ad8ff3b933@mail.gmail.com>
Reply-To: mingz@ele.uri.edu,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a4e6962a0604101747g489fb334hb26787ad8ff3b933@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2006-04-10 at 19:47 -0500, Eric Van Hensbergen wrote:
> On 4/10/06, Ming Zhang <mingz@ele.uri.edu> wrote:
> >
> > yes, "page cache" has its meaning in linux.
> >
> 
> Sorry - my bad, I should have known better.
> 
> >
> > as i know, no stable implementation for this.
> >
> 
> Okay - I'll take a shot at it - should be a good intro to
> device-mapper as a framework.  If anyone else is going down this path,
> please shoot me an email so I don't end up duplicating effort.

good luck. a disk cache for remote storage system is not always useful,
considering u already have GB RAM here at file system level. of course,
depends on your workload pattern and remote access cost, u might get
some marginal benefits.


> 
>        -eric
