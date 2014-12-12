From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH v2] staging: writeboost: Add dm-writeboost
Date: Fri, 12 Dec 2014 14:24:48 +0000
Message-ID: <20141212142447.GA30315@debian>
References: <54883195.1060304@gmail.com> <20141211152626.GA8196@redhat.com>
 <548A39E7.80508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <548A39E7.80508@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: gregkh@linuxfoundation.org, dm-devel@redhat.com, driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Fri, Dec 12, 2014 at 09:42:15AM +0900, Akira Hayakawa wrote:
> The SSD-caching should be log-structured.

No argument there, and this is why I've supported you with
dm-writeboost over the last couple of years.

However, after looking at the current code, and using it I think it's
a long, long way from being ready for production.  As we've already
discussed there are some very naive design decisions in there, such as
copying every bio payload to another memory buffer, splitting all io
down to 4k.  Think about the cpu overhead and memory consumption!
Think about how it will perform when memory is constrained and it
can't allocate many of those rambufs!  I'm sure more issues will be
found if I read further.

I'm sorry to have disappointed you so, but if I let this go upstream
it would mean a massive amount of support work for me, not to mention
a damaged reputation for dm.

Mike raised the question of why you want this in the kernel so much?
You'd find none of the distros would support it; so it doesn't widen
your audience much.  It's far better for you to maintain it outside of
the kernel at this point.  Any users will be bold, adventurous people,
who will be quite capable of building a kernel module.

- Joe
