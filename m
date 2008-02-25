From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack
 overflow: ide-cd related? dm-related?
Date: Mon, 25 Feb 2008 12:25:22 -0800
Message-ID: <20080225122522.f2a9f073.akpm@linux-foundation.org>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix>
	<m363wepa3a.fsf@telia.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m363wepa3a.fsf@telia.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Osterlund <petero2@telia.com>
Cc: Nix <nix@esperi.org.uk>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, 24 Feb 2008 17:56:09 +0100 Peter Osterlund <petero2@telia.com> wrote:

> 
>  drivers/block/pktcdvd.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index 674cd66..f2510e7 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -849,7 +849,7 @@ static int pkt_flush_cache(struct pktcdvd_device *pd)
>  /*
>   * speed is given as the normal factor, e.g. 4 for 4x
>   */
> -static int pkt_set_speed(struct pktcdvd_device *pd, unsigned write_speed, unsigned read_speed)
> +static noinline int pkt_set_speed(struct pktcdvd_device *pd, unsigned write_speed, unsigned read_speed)
>
> ...

yup, I'll grab that.  I'll even write your changelog for you (grr).

But first, let's do this:


From: Andrew Morton <akpm@linux-foundation.org>

People are adding `noinline' in various places to prevent excess stack
consumption due to gcc inlining.  But once this is done, it is quite unobvious
why the `noinline' is present in the code.  We can comment each and every
site, or we can use noinline_for_stack.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/compiler.h~add-noinline_for_stack include/linux/compiler.h
--- a/include/linux/compiler.h~add-noinline_for_stack
+++ a/include/linux/compiler.h
@@ -138,6 +138,12 @@ extern void __chk_io_ptr(const volatile 
 #define noinline
 #endif
 
+/*
+ * Rather then using noinline to prevent stack consumption, use
+ * noinline_for_stack instead.  For documentaiton reasons.
+ */
+#define noinline_for_stack noinline
+
 #ifndef __always_inline
 #define __always_inline inline
 #endif
_

(Note that these changes don't let DM off the hook!)
