From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/26] dm raid: fix/cleanup for dm-4.8
	inclusion
Date: Wed, 13 Jul 2016 10:19:09 -0400
Message-ID: <20160713141909.GB9378@redhat.com>
References: <1467825897-26058-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1467825897-26058-1-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jul 06 2016 at  1:24pm -0400,
heinzm@redhat.com <heinzm@redhat.com> wrote:

> From: Heinz Mauelshagen <heinzm@redhat.com>
> 
> 
> Patch series vs. kernel.org linux-dm, branch dm-4.8 to address
> issues identified:
> 
> - superfluous memory bariers
> - missing constructor argument checks (sync/nosync)
> - typo in write_mostly constructor argument
> - function argument types
> - recovery ad raid set size issues 
> - out-of-place reshape offset checks
> - reject resize during reshape
> - enhance reshape checks
> - avoid memory leaks in destructor
> - comment typos and enhancements
> 
> Please review and schedule for 4.8 inclusion

Done, just cleaned up the headers a bit and folded 2 comment specific
patches.

Now staged in linux-next (via linux-dm.git's 'for-next') for 4.8
inclusion.
