From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-bufio
Date: Mon, 17 Oct 2011 17:41:13 +0100
Message-ID: <20111017164110.GB14913@ubuntu>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
	<20111017111128.GF13963@ubuntu>
	<Pine.LNX.4.64.1110171004290.14928@hs20-bc2-1.build.redhat.com>
	<20111017140947.GA10136@ubuntu>
	<Pine.LNX.4.64.1110171218130.21071@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110171218130.21071@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 17, 2011 at 12:22:13PM -0400, Mikulas Patocka wrote:
> > thinp uses dm_bufio_release_move() and write_callback.  So yes, this
> > is a bug fix.  I thought so and merged.
> 
> BTW. it still uses the old block number in "prepare_for_write" callback. 
> Do you use this block number somewhere? Should we link the buffer to the 
> new block before the call and the link it back?

Good catch, let me look into it.

- Joe
