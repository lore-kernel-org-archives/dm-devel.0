From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: an optimization for dm-bufio and dm-integrity
Date: Wed, 19 Jul 2017 11:39:55 -0400
Message-ID: <20170719153954.GA61594@redhat.com>
References: <alpine.LRH.2.02.1707191128350.2305@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1707191128350.2305@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Wed, Jul 19 2017 at 11:30P -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi Mike
> 
> Some times ago, I sent this patch as dm-bufio optimization (it doesn't 
> have to write full buffers, it only writes a part of the buffer that 
> changed). You delayed the patch until the next kernel.
> 
> Will you submit the patch to the current kernel?

Sorry about that.  It obviously fell off my radar.

I'll review it and see if I can make the justification for it going into
4.13-rc2.  But unfortunately the 4.13 merge window closed this past
Sunday when Linus released v4.13-rc1

I'll let you know though, thanks.
Mike
