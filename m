From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: delete dm_bufio_discard_buffers
Date: Wed, 27 May 2020 09:11:07 -0400
Message-ID: <20200527131107.GA19310@redhat.com>
References: <alpine.LRH.2.02.2005270702460.6054@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2005270702460.6054@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, May 27 2020 at  7:04am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> I suggest to delete dm_bufio_discard_buffers because no one is using it.
> 
> If you need it in the future, tell me - and I will optimize it, so that it 
> walks the rb-tree of buffers instead of doing block-by-block lookups.
> 

OK, my only concern is: Heinz, should you have used
dm_bufio_discard_buffers() in dm-ebs commit a5089a95d84c ("dm ebs: pass
discards down to underlying device")?  Or are you certain all ebs'
bufio buffers have made it to disk?

Also now seeing that the FIXME commit a5089a95d84c removed referred to
making use of dm_bufio_discard_buffers()...

Mike
