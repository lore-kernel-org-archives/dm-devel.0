From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 2/2] dm thin: support for non power of 2 pool
	blocksize
Date: Tue, 1 May 2012 10:41:32 +0100
Message-ID: <20120501094131.GA5602@ubuntu>
References: <1335588269-807-1-git-send-email-snitzer@redhat.com>
	<1335588269-807-2-git-send-email-snitzer@redhat.com>
	<20120430095555.GA5955@ubuntu> <20120430173347.GB19033@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120430173347.GB19033@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 30, 2012 at 01:33:47PM -0400, Mike Snitzer wrote:
> Yes.  But imposing this restriction was motivated by and the "attempt to
> access beyond end of device" failures I saw with test_origin_unchanged
> (I shared more details about this in private mail to you and kabi on
> 4/25 -- making the pool size a multiple of the non power of 2 blocksize
> resolved that failure).

This is the wrong fix; you're just hiding the real issue.
