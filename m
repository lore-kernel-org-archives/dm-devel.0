From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] dm ioctl: Remove double parentheses
Date: Mon, 3 Apr 2017 09:56:53 -0700
Message-ID: <20170403165653.GB13986@google.com>
References: <20170316164830.127026-1-mka@chromium.org>
 <20170401015019.GA13986@google.com>
 <1491012453.27353.25.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491012453.27353.25.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Grant Grundler <grundler@chromium.org>, Michael Davidson <md@google.com>, Greg Hackmann <ghackmann@google.com>
List-Id: dm-devel.ids

Hi Joe,

El Fri, Mar 31, 2017 at 07:07:33PM -0700 Joe Perches ha dit:

> On Fri, 2017-03-31 at 18:50 -0700, Matthias Kaehlcke wrote:
> > El Thu, Mar 16, 2017 at 09:48:30AM -0700 Matthias Kaehlcke ha dit:
> > 
> > > The extra pair of parantheses is not needed and causes clang to generate
> > > the following warning:
> > > 
> > > drivers/md/dm-ioctl.c:1776:11: error: equality comparison with extraneous parentheses [-Werror,-Wparentheses-equality]
> > >         if ((cmd == DM_DEV_CREATE_CMD)) {
> > >              ~~~~^~~~~~~~~~~~~~~~~~~~
> > > drivers/md/dm-ioctl.c:1776:11: note: remove extraneous parentheses around the comparison to silence this warning
> > >         if ((cmd == DM_DEV_CREATE_CMD)) {
> > >             ~    ^                   ~
> > > drivers/md/dm-ioctl.c:1776:11: note: use '=' to turn this equality comparison into an assignment
> > >         if ((cmd == DM_DEV_CREATE_CMD)) {
> 
> There are dozens of these comparisons in the kernel.
> Are you fixing them all or just this one?

For now I focus on occurrences that pop up in my builds. So far there
have been two more:

https://patchwork.kernel.org/patch/9626833/
https://patchwork.kernel.org/patch/9631591/

Thanks

Matthias
