From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm transaction manager: handle space map checker
	failure
Date: Mon, 25 Jun 2012 13:16:21 +0100
Message-ID: <20120625121619.GA2417@ubuntu>
References: <1340220299-17771-1-git-send-email-snitzer@redhat.com>
	<20120620212010.GK22599@redhat.com>
	<20120620213756.GL22599@redhat.com>
	<20120620221542.GA18880@redhat.com>
	<20120621051032.GA20978@redhat.com>
	<20120621061009.GA21318@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120621061009.GA21318@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, dm-devel@redhat.com, agk@redhat.com, Vivek Goyal <vgoyal@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 21, 2012 at 02:10:09AM -0400, Mike Snitzer wrote:
> (Joe and Alasdair, I'll post 2 new cleaned up patches for 3.5; the
> dm-space-map-disk.c change in this patch needs to be folded into v2 of
> the "dm transaction manager: handle space map checker failure" patch I
> posted yesterday)

I think it's time to pull that checker completely.  Confidence in the
space maps is higher these days, and this checker is very expensive in
memory for realistic sized pools.

- Joe
