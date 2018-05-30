From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
Date: Wed, 30 May 2018 09:26:47 -0400
Message-ID: <20180530132647.GB5157@redhat.com>
References: <alpine.LRH.2.02.1805250213270.13894@file01.intranet.prod.int.rdu2.redhat.com>
 <20180525125126.GA9275@redhat.com>
 <CAPcyv4j-v5HGBg9JMBXt7UUyw=K_bGC7t5tQGfXM9G4qjOpFjQ@mail.gmail.com>
 <alpine.LRH.2.02.1805260246250.15978@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jwLsCNvNhgvv2DDSZuQsQXYEpKUU_5w1pTnyKj-uDBbQ@mail.gmail.com>
 <alpine.LRH.2.02.1805280922190.13486@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jXV4aZ6wqqjVPL8J4LxwTtXnzQCLZ0Wk5oB4_0uxpg7g@mail.gmail.com>
 <alpine.LRH.2.02.1805300903220.1090@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530131623.GB2106@redhat.com>
 <alpine.LRH.2.02.1805300919070.11327@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1805300919070.11327-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

On Wed, May 30 2018 at  9:21am -0400,
Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> 
> 
> On Wed, 30 May 2018, Mike Snitzer wrote:
> 
> > That is really great news, can you submit an incremental patch that
> > layers ontop of the linux-dm.git 'dm-4.18' branch?
> > 
> > Thanks,
> > Mike
> 
> I've sent the current version that I have. I fixed the bugs that were 
> reported here (missing DAX, dm_bufio_client_create, __branch_check__ 
> long->int truncation).

OK, but a monolithic dm-writecache.c is no longer useful to me.  I can
drop Arnd's gcc warning fix (with the idea that Ingo or Steve will take
your __branch_check__ patch).  Not sure what the dm_bufio_client_create
fix is... must've missed a report about that.

ANyway, point is we're on too a different phase of dm-writecache.c's
development.  I've picked it up and am trying to get it ready for the
4.18 merge window (likely opening Sunday).  Therefore it needs to be in
a git tree, and incremental changes overlayed.  I cannot be rebasing at
this late stage in the 4.18 development window.

Thanks,
Mike
