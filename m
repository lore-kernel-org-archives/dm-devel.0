From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: questions about dm-thin and discard
Date: Mon, 16 Jul 2012 14:01:42 -0400
Message-ID: <20120716180141.GA7988@redhat.com>
References: <Pine.LNX.4.64.1207161302450.22760@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1207161302450.22760@file.rdu.redhat.com>
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
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

On Mon, Jul 16 2012 at  1:14pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi Joe
> 
> I would like to ask you about this code path: In process_discard, there is 
> a branch with a comment "This path is hit if people are ignoring 
> limits->discard_granularity." It trims the discard request so that it 
> doesn't span a block boundary and submits it.
> 
> The question is: what if the block is shared? In this case, we can't 
> submit discard to the block, because it would damage the other snapshot 
> that is sharing this block. Shouldn't there be shomething like this?
> if ((!lookup_result.shared) & pool->pf.discard_passdown) {
> 	remap_and_issue(tc, bio, lookup_result.block);
> } else {
> 	bio_endio(bio, 0) 
> } 
> ... or is it tested elsewhere and am I missing something?

in process_discard:

 m->pass_discard = (!lookup_result.shared) && pool->pf.disard_passdown;

then in process_prepared_discard:

 if (m->pass_discard)
        remap_and_issue(tc, m->bio, m->data_block);
 else
        bio_endio(m->bio, 0);

> Another question is about setting "ti->discards_supported = 1" in 
> pool_ctr. ti->discards_supported means that the target supports discards 
> even if the underlying disk doesn't. Since the pool device is passing 
> anyth I/O unchanged to the underlying disk, ti->discards_supported 
> shouldn't be set. Or is there any other reason why is it set?

The thin device's bios will be remapped to the pool device.

process_prepared_discard's remap_and_issue() will send the bio to the
pool device via generic_make_request().
