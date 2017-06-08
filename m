From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/4] dm: zoned block device fixes
Date: Thu, 8 Jun 2017 16:21:47 -0400
Message-ID: <20170608202146.GB6747@redhat.com>
References: <20170529102307.19814-1-damien.lemoal@wdc.com>
	<20170530202031.GA52190@redhat.com>
	<46ec84af-0700-70f9-f990-d87a63cc18b0@wdc.com>
	<20170531143910.GA16671@redhat.com>
	<20170602003617.GB25647@redhat.com>
	<9749b12d-e232-5386-0894-511bb45758e7@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <9749b12d-e232-5386-0894-511bb45758e7@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 05 2017 at  6:48am -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:
 
> I did address some of the "FIXME" notes you added. The main one is the
> BIO cloning in the I/O path. I removed most of that and added a .end_io
> method for completion processing. The only place were I do not see how
> to remove the call to bio_clone() is during read BIO processing: since a
> read BIO may end up being split between buffer zone, sequential zone and
> simple buffer zero-out, fragmentation of the read BIO is sometimes
> necessary and so need a clone.

So shouldn't it be possible to not allow a given bio to cross zone
boundaries by using dm_accept_partial_bio()?

Like you're already doing in dmz_map() actually... so why do you need to
account for crossing zone boundaries on read later on in
dmz_submit_read_bio()?

Is it that these zones aren't easily known up front (in dmz_map)?

Mike
