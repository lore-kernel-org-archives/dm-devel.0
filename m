From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: Reject sector_size feature if device
 length is not aligned to it
Date: Wed, 4 Oct 2017 11:05:21 -0400
Message-ID: <20171004150520.GA31155@redhat.com>
References: <20170913134556.23145-1-gmazyland@gmail.com>
	<b6c539ce-c841-a21c-1a2c-4ee93d826680@gmail.com>
	<alpine.LRH.2.02.1710021034380.2597@file01.intranet.prod.int.rdu2.redhat.com>
	<20171003120508.GA9979@agk-dp.fab.redhat.com>
	<20171003180804.GA25465@redhat.com>
	<20171003190934.GB9979@agk-dp.fab.redhat.com>
	<alpine.LRH.2.02.1710031606140.8739@file01.intranet.prod.int.rdu2.redhat.com>
	<ddef2346-99af-c20d-903f-f77af35925b6@gmail.com>
	<20171003211815.GA26406@redhat.com>
	<704e2665-2dc2-54a4-a35e-0c04350f4d8c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <704e2665-2dc2-54a4-a35e-0c04350f4d8c@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 04 2017 at  2:45am -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 10/03/2017 11:18 PM, Mike Snitzer wrote:
> > On Tue, Oct 03 2017 at  4:33pm -0400,
> > Milan Broz <gmazyland@gmail.com> wrote:
> > 
> >> On 10/03/2017 10:08 PM, Mikulas Patocka wrote:
> >>>
> >>> It would be interesting to know, why Milan wants the table load to fail.
> >>
> >> I mentioned this on IRC:
> >> the only situation I care about in load is that size (dm-table length) is unaligned to optional sector_size.
> >> create fails in this case, load should imho fail as well. 
> >> ...
> >> if we say that dmsetup table output is always directly usable (as a mapping table),
> >> then why should there be an exception for dmsetup table --inactive? (now it can print apparently invalid mapping)
> > 
> > The .ctr should validate the inactive table and that'll cause load to
> > fail.
> 
> And that's exactly what is the former patch doing - we introduced a new parameter that
> has new limitations, we should fix constructor. That's all I want :-)

Yeap, I've staged your fix.. enough with all this debate.
See: https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-4.14/dm&id=783874b050768d361239e444ba0fa396bb6d463f

(but yes I read your "rant".. I agreed with all you said.. but it lacked
the qualities of a flaming rant.. you must be happier ;)
