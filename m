From: Joe Thornber <thornber@redhat.com>
Subject: Re: Why does dm-thin pool metadata space map use 4K page
 to carry index ?
Date: Thu, 5 Sep 2019 11:38:43 +0100
Message-ID: <20190905103843.xnakopha6s6oeuyd@reti>
References: <CAC-DDmMQu38J6kCirxK=axwEguEpaN+H1JJVPbUsyqtxcx5KEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAC-DDmMQu38J6kCirxK=axwEguEpaN+H1JJVPbUsyqtxcx5KEw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jianchao wang <jianchao.wan9@gmail.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 05, 2019 at 02:43:28PM +0800, jianchao wang wrote:
> But why does it use this 4K page instead of btree as the disk sm ?
> 
> The brb mechanism seem be able to avoid the nested block allocation
> when do COW on the metadata sm btree.
> 
> Would anyone please help to tell why does it use this 4K page instead of a
> btree ?

It's a long time since I wrote this, so I can't remember the order that things
were written.  It may well be that brb mechanism for avoiding recursive allocations
came after the on disk formats were defined.  Irrespective of that the single page
pointing to index pages should perform better.

Is the 16G limit to the metadata device causing you issues?

- Joe
