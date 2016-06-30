From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: NVMeoF multi-path setup
Date: Thu, 30 Jun 2016 18:57:27 -0400
Message-ID: <20160630225727.GC22293@redhat.com>
References: <CAF1ivSbe+NboO+nbiWfEijHFJPd-AgNa=4AvWT24-HjH8A_izw@mail.gmail.com>
	<1467323858.15863.3.camel@ssi> <20160630225207.GB22293@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160630225207.GB22293@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lin <mlin@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

On Thu, Jun 30 2016 at  6:52pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Also, just so you're aware, I've staged bio-based dm-multipath support
> for the 4.8 merge window.  Please see either the 'for-next' or 'dm-4.8'
> branch in linux-dm.git:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.8
> 
> I'd welcome you testing if bio-based dm-multipath performs better for
> you than blk-mq request-based dm-multipath.  Both modes (using the 4.8
> staged code) can be easily selected on a per DM multipath device table
> by adding either: queue_mode=bio or queue_mode=mq
> 
> (made possible with this commit:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.8&id=e83068a5faafb8ca65d3b58bd1e1e3959ce1ddce
> )

Sorry, no = should be used. you need either:
"queue_mode bio" or "queue_mode mq"

Added to the features section of the "multipath" ctr input.
AFAIK, once the above commit lands upstream Ben will be adding some
multipath-tools code to make configuring queue_mode easy (but I think
multipath.conf may allow you to extend the features passed on a
per-device basis already.. but I'd have to look).
