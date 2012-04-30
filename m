From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] dm: update max_io_len to support
	a	split_io that is not a power of 2
Date: Mon, 30 Apr 2012 17:10:43 +0100
Message-ID: <20120430161043.GB8713@agk-dp.fab.redhat.com>
References: <1335588269-807-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1335588269-807-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Sat, Apr 28, 2012 at 12:44:28AM -0400, Mike Snitzer wrote:
> Required to support a target's use of a non power of 2 blocksize.
 
For which targets?
(merge_bvec supported?)

> +		boundary = ti->split_io - do_div(tmp, ti->split_io);

sector_div()?

What about 32-bit arch + LBD + large split_io (from raid?)
  - Is a 32-bit restriction on split_io unreasonable nowadays?
    - OR reasonable on 32bit/LBD?
    - OR fallback to old code there?

Alasdair
