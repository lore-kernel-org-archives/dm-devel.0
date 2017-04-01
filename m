From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] dm ioctl: Remove double parentheses
Date: Fri, 31 Mar 2017 19:07:33 -0700
Message-ID: <1491012453.27353.25.camel@perches.com>
References: <20170316164830.127026-1-mka@chromium.org>
	<20170401015019.GA13986@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170401015019.GA13986@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Matthias Kaehlcke <mka@chromium.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Michael Davidson <md@google.com>, Grant Grundler <grundler@chromium.org>, linux-kernel@vger.kernel.org, Greg Hackmann <ghackmann@google.com>, linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

On Fri, 2017-03-31 at 18:50 -0700, Matthias Kaehlcke wrote:
> El Thu, Mar 16, 2017 at 09:48:30AM -0700 Matthias Kaehlcke ha dit:
> 
> > The extra pair of parantheses is not needed and causes clang to generate
> > the following warning:
> > 
> > drivers/md/dm-ioctl.c:1776:11: error: equality comparison with extraneous parentheses [-Werror,-Wparentheses-equality]
> >         if ((cmd == DM_DEV_CREATE_CMD)) {
> >              ~~~~^~~~~~~~~~~~~~~~~~~~
> > drivers/md/dm-ioctl.c:1776:11: note: remove extraneous parentheses around the comparison to silence this warning
> >         if ((cmd == DM_DEV_CREATE_CMD)) {
> >             ~    ^                   ~
> > drivers/md/dm-ioctl.c:1776:11: note: use '=' to turn this equality comparison into an assignment
> >         if ((cmd == DM_DEV_CREATE_CMD)) {

There are dozens of these comparisons in the kernel.
Are you fixing them all or just this one?
