From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin: Several Questions on dm-thin performance.
Date: Tue, 3 Dec 2019 12:51:15 +0000
Message-ID: <20191203125115.rdc74jgjdz2673ig@reti>
References: <35cf1ecf-5cd8-604b-ec4e-18c9fd4a4195@linux.alibaba.com>
	<20191122185530.pcrgmb655dkdbdcq@reti>
	<6b12137e-411e-0368-518e-41ae54e138e0@linux.alibaba.com>
	<alpine.LRH.2.11.1912022002210.11561@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1912022002210.11561@mx.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: JeffleXu <jefflexu@linux.alibaba.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Dec 02, 2019 at 10:26:00PM +0000, Eric Wheeler wrote:

> Hi Joe,
> 
> I'm not sure if I will have the time but thought I would start the 
> research and ask a few questions. I looked at the v1/v2 .h files and some 
> of the functions just change suffix to _v2 and maybe calling 
> convention/structure field changes.
> 
> However, there appear to be some design changes, too:

Yes, the interface is different, and it's really not trivial to switch dm-thin
over to use it (otherwise I'd have done it already).  dm-cache already uses
the new interface which could be used as a guide, especially if you look at the patches
that made the switch.

I'm going to write up some notes over the next couple of days.  Which I'll post on this thread.

- Joe
