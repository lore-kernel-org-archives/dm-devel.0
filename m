From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 0/2] dm verity: add support for error
	correction
Date: Mon, 7 Dec 2015 09:58:14 -0500
Message-ID: <20151207145814.GB29457@redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
	<1449152791-33586-1-git-send-email-samitolvanen@google.com>
	<20151203195401.GA5444@redhat.com>
	<20151203230538.GB5444@redhat.com>
	<20151204100305.GA37949@google.com>
	<20151204210935.GA63877@redhat.com>
	<20151207132149.GA7583@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20151207132149.GA7583@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Mandeep Baines <msb@chromium.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Mark Salyzyn <salyzyn@google.com>, Alasdair Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 07 2015 at  8:21am -0500,
Sami Tolvanen <samitolvanen@google.com> wrote:

> On Fri, Dec 04, 2015 at 04:09:35PM -0500, Mike Snitzer wrote:
> > I'd really appreciate it if you could do some regression testing,
> > etc on your end to verify I didn't break anything while tweaking
> > things.
> 
> Sure. The changes look fine. I applied them to my tree and everything
> still works as expected in my tests.

Great.  Moving forward it'd be awesome if you could work to get your
verity FEC support regression tests into cryptsetup's tests.  We need a
way to verify future DM and/or other kernel changes don't somehow cause
this FEC support to regress.

Also, I know you said you'd be getting Milan a veritysetup patch soon.
How are things going on that?  Ideally that'll land in conjunction with
the kernel's dm-verity FEC support.

> Thanks for taking the time to review the patches!

No problem, like I said I'll be reviewing the code further but at this
point your changes seem to be on-track for upstream Linux 4.5
inclusion.

Mike
