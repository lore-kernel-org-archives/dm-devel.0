From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH v3 0/3] dm: allow mempool and bioset reserves
	to be tuned
Date: Wed, 18 Sep 2013 08:10:24 -0700
Message-ID: <1379517024.32581.10.camel@bobble.lax.corp.google.com>
References: <20130913203005.GA8635@redhat.com>
	<1379106494-16366-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1379106494-16366-1-git-send-email-snitzer@redhat.com>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Fri, 2013-09-13 at 17:08 -0400, Mike Snitzer wrote:
> You can pull these changes from the 'devel' branch of:
> git://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git
> 
> To browse, see:
> https://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel
> 
> v3 changes:
> Added bounds checking (if 0 reset to default, if > 1024 reset to 1024)
> 
> v2 changes:
> Simplified the implementation.  Dropped the peak_reserved_rq_based_ios
> tracking, we'll use the tracepoint patch Jun'ichi Nomura suggested:
> http://www.redhat.com/archives/dm-devel/2013-September/msg00048.html

Very nice, thanks for doing this.  It also makes these parameters a lot
more clear about what they're for, which is a feature.  "MIN_IOS" was
kind of opaque without actually digging into the code.

Feel free to add

Signed-off-by: Frank Mayhar <fmayhar@google.com>

if you care to.
-- 
Frank Mayhar
310-460-4042
