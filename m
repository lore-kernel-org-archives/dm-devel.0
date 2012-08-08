From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: dm-loop and kernel 3.x
Date: Wed, 08 Aug 2012 15:42:27 +0100
Message-ID: <50227AD3.6040600@redhat.com>
References: <FB767254-0A6B-42BF-92C7-0527F5329F84@dattobackup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <FB767254-0A6B-42BF-92C7-0527F5329F84@dattobackup.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Matt Coleman <mcoleman@dattobackup.com>
Cc: dm-devel@redhat.com, breeves@redhat.com
List-Id: dm-devel.ids

On 08/08/2012 03:33 PM, Matt Coleman wrote:
> I just tried (unsuccessfully) to apply the dm-loop patches to kernel
> 3.2.0. dm-bio-list-helpers.patch failed to apply because
> dm-bio-list.h no longer exists in the kernel tree. Is this an
> abandoned project, or were the changes incorporated into the kernel's
> existing loopback support? (...as hinted at here:
> http://www.redhat.com/archives/dm-devel/2012-February/msg00041.html)

Most of the support patches went in to mainline several years ago so
this is probably due to later changes in md/ - I'd have to take a look
at the errors to see what's failing for you.

That said, the original patch is somewhat abandoned at this stage. I've
not done any work on it beyond helping folks get it applied and built
for quite a few years and the block mapping approach it uses was
rejected on LKML without VFS changes to make it safe (it operates behind
the file system's back).

I did start work last year on a revised dm-loop that was a refactoring
of and thin wrapper around the existing drivers/block loop driver but
this isn't published anywhere at the moment.

It could probably be cleaned up and put somewhere without too much work
but it's not something I'm working on regularly at the moment.

I know Mikulas was also interested in reviving dm-loop and we had some
discussions at Devconf in Brno earlier in the year but nothing has
happened since.

Regards,
Bryn.
