From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm: fix stacking of geometry limits for
	thinp and cache
Date: Thu, 15 Aug 2013 15:37:22 +0100
Message-ID: <20130815143721.GC9538@debian>
References: <20130815142912.GA27908@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130815142912.GA27908@redhat.com>
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
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 15, 2013 at 10:29:12AM -0400, Mike Snitzer wrote:
> Do not blindly override the queue limits (specifically io_min and
> io_opt).  Allow traditional stacking of these limits if io_opt is a
> factor of each target's block size.

Ack
