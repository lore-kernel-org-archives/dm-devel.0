From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH for-dm-3.14-fixes 6/8] dm thin: fix
 pool_preresume resize with heavy IO races
Date: Fri, 21 Feb 2014 14:47:05 +0000
Message-ID: <20140221144704.GI13298@debian>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
	<1392951365-9829-7-git-send-email-snitzer@redhat.com>
	<20140221142706.GE13298@debian> <20140221143746.GF4578@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140221143746.GF4578@redhat.com>
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
List-Id: dm-devel.ids

On Fri, Feb 21, 2014 at 09:37:47AM -0500, Mike Snitzer wrote:
> You may think it complicated, and yeah it isn't dead simple, but it
> unlocks the nuanced state that is needed to allow for fixing data space
> exhaustion that still allows for prepared_mappings to complete -- even
> though the pool is in read-only mode.

ok, but we still need a patch to stop the worker being woken while the
pool is suspended.
