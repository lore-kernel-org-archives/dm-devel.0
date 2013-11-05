From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-mpath: requeue I/O during pg_init
Date: Tue, 5 Nov 2013 13:31:58 +0000
Message-ID: <20131105133158.GD27505@agk-dp.fab.redhat.com>
References: <1380620996-110162-1-git-send-email-hare@suse.de>
	<20131105130221.GC27505@agk-dp.fab.redhat.com>
	<5278EE5F.9070208@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5278EE5F.9070208@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 05, 2013 at 02:10:55PM +0100, Hannes Reinecke wrote:
> If this is just a left-over from the original port to request-based
> (for bio-based we _have_ to queue internally as there's no request
> queue to be had), fine, we should be removing it.

I think that is the case.

> But there _might_ be some corner cases which require us to do internal
> queueing.
 
We *only* add I/O to the internal queue in map_io() - which can always
be replaced with REQUEUE,  As long as we still 'wake up' the queue
immediately when we are ready to receive the I/O, I can't think of any
other reason.  And it would let us remove quite a bit of tricky code!

> Junichi, could you share some light here?
 
Alasdair
