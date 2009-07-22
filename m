From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: strncpy does not null terminate string
Date: Wed, 22 Jul 2009 13:29:10 +0100
Message-ID: <20090722122910.GA5084@agk-dp.fab.redhat.com>
References: <4A607185.6020302@gmail.com> <4A609A5F.70900@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A609A5F.70900@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Roel Kluin <roel.kluin@gmail.com>
Cc: dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

On Fri, Jul 17, 2009 at 05:35:59PM +0200, Roel Kluin wrote:
> strlcpy() will always null terminate the string.
 
The code is already supposed to ensure correct NULL-termination.

Did you find a bug?  If so, please give details of the code path 
concerned in the patch header and I'll need to deal with it promptly
and submit it to stable too.

Or are you simply proposing this as a precaution against future bugs,
in which case it is not urgent?

Alasdair
