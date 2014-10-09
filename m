From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-bufio cache patches
Date: Thu, 9 Oct 2014 14:07:36 +0100
Message-ID: <20141009130736.GA21297@debian>
References: <alpine.LRH.2.02.1410081607440.5670@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1410081617120.9823@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1410081617120.9823@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 08, 2014 at 04:17:59PM -0400, Mikulas Patocka wrote:
> > I created dm-bufio patchset that keep some amount of cache indefinitely, 
> > regardless of the timeout (the default is to keep 1/500 of total memory 
> > indefinitely).

I'm running something similar here.  I just put in a hard coded
default rather than basing it on the amount of memory present.  I'm
not sure which I prefer.

I've also switched over to using a rbtree instead of that huge hash
table which consumes 8m.

I'll post clean patches in a bit.

- Joe
