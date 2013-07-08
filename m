From: Joe Perches <joe@perches.com>
Subject: Re: [dm-devel] [PATCH] MAINTAINERS: dm-devel@redhat.com is a list
Date: Mon, 08 Jul 2013 10:21:43 -0700
Message-ID: <1373304103.9458.2.camel@joe-AO722>
References: <1372777307-4259-1-git-send-email-ydroneaud@opteya.com>
	 <20130708171009.GA4870@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130708171009.GA4870@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 2013-07-08 at 18:10 +0100, Alasdair G Kergon wrote:
> On Tue, Jul 02, 2013 at 05:01:47PM +0200, Yann Droneaud wrote:
> > This patch changes type of dm-devel@redhat.com
> > The output of ./scripts/get_maintainer.pl is
> > modified to report dm-devel@redhat.com as a list:
>  
> >  DEVICE-MAPPER  (LVM)
> >  M:	Alasdair Kergon <agk@redhat.com>
> > -M:	dm-devel@redhat.com
> >  L:	dm-devel@redhat.com
> >  W:	http://sources.redhat.com/dm
> >  Q:	http://patchwork.kernel.org/project/dm-devel/list/

I think this Q entry isn't as useful as it could be
because it doesn't show the status of any patch.

It looks as if every patch ever sent to dm-devel is
still listed as "new".
