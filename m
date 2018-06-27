From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: writecache: Use 2-factor allocator arguments
Date: Wed, 27 Jun 2018 17:52:27 -0400
Message-ID: <20180627215227.GA13549@redhat.com>
References: <20180618175033.GA2627@beast>
	<CAGXu5j+Su3fObnuzntQ7Tp8W6jfMt1hc=h-3Xhidgx--Nau1Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+Su3fObnuzntQ7Tp8W6jfMt1hc=h-3Xhidgx--Nau1Ew@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kees Cook <keescook@chromium.org>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: dm-devel.ids

On Wed, Jun 27 2018 at  5:48pm -0400,
Kees Cook <keescook@chromium.org> wrote:

> On Mon, Jun 18, 2018 at 10:50 AM, Kees Cook <keescook@chromium.org> wrote:
> > This adjusts the allocator calls to use the 2-factor argument style, as
> > already done treewide for better defense against allocator overflows.
> > Additionally adjusts style nit to avoid assignments in test expressions.
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Friendly ping -- I'd like to make sure this makes it into 4.18. All
> other 2-factor allocations have been fixed in the kernel.

Yeap, I'll be sending it to Linus this week.  Already staged and ready
to go, please see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.18&id=50a7d3ba7c9ac5e0b7e03fc7f420180989361dbf

Thanks,
Mike
