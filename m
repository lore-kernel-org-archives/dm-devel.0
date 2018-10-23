From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] mm: convert totalram_pages,
 totalhigh_pages and managed_pages to atomic.
Date: Mon, 22 Oct 2018 21:15:37 -0700
Message-ID: <c57bcc584b3700c483b0311881ec3ae8786f88b1.camel__41694.7278347381$1540281959$gmane$org@perches.com>
References: <1540229092-25207-1-git-send-email-arunks@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1540229092-25207-1-git-send-email-arunks@codeaurora.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Arun KS <arunks@codeaurora.org>, Guo Ren <ren_guo@c-sky.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter
	Anvin" <hpa@zytor.com>, x86@kernel.org, David Airlie <airlied@linux.ie>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oded Gabbay <oded.gabbay@gmail.com>, Alex Deucher <alexander.deucher@amd.com>, Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.int>
Cc: getarunks@gmail.com
List-Id: dm-devel.ids

On Mon, 2018-10-22 at 22:53 +0530, Arun KS wrote:
> Remove managed_page_count_lock spinlock and instead use atomic
> variables.

Perhaps better to define and use macros for the accesses
instead of specific uses of atomic_long_<inc/dec/read>

Something like:

#define totalram_pages()	(unsigned long)atomic_long_read(&_totalram_pages)
#define totalram_pages_inc()	(unsigned long)atomic_long_inc(&_totalram_pages)
#define totalram_pages_dec()	(unsigned long)atomic_long_dec(&_totalram_pages)
