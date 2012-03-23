From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 10/14] dm_thin: add support for REQ_DISCARD
Date: Fri, 23 Mar 2012 12:45:21 +0000
Message-ID: <20120323124520.GC16214@agk-dp.fab.redhat.com>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
	<1331911358-8848-10-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1331911358-8848-10-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 16, 2012 at 03:22:33PM +0000, Joe Thornber wrote:
> +	default:
> +		DMERR("discard: find block unexpectedly returned %d\n", r);

What can trigger that?
- Is it really BUG() or /* NOTREACHED */ perhaps?

Similar question applies to (existing) process_bio().

Alasdair
