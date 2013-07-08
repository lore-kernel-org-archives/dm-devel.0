From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] MAINTAINERS: dm-devel@redhat.com is a list
Date: Mon, 8 Jul 2013 18:10:09 +0100
Message-ID: <20130708171009.GA4870@agk-dp.fab.redhat.com>
References: <1372777307-4259-1-git-send-email-ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1372777307-4259-1-git-send-email-ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jul 02, 2013 at 05:01:47PM +0200, Yann Droneaud wrote:
> This patch changes type of dm-devel@redhat.com
> The output of ./scripts/get_maintainer.pl is
> modified to report dm-devel@redhat.com as a list:
 
>  DEVICE-MAPPER  (LVM)
>  M:	Alasdair Kergon <agk@redhat.com>
> -M:	dm-devel@redhat.com
>  L:	dm-devel@redhat.com
>  W:	http://sources.redhat.com/dm
>  Q:	http://patchwork.kernel.org/project/dm-devel/list/

Is this part of some other changes to the definition of M and L?

Otherwise I don't agree with the change.

MAINTAINERS states:

        M: Mail patches to: FullName <address@domain>
        L: Mailing list that is relevant to this area

In the case of dm-devel, it's not merely a "relevant" list, but it is
essential for us: patches to dm must be sent to the list for patchwork
to collect.  I shall also add Mike Snitzer as a joint maintainer.

And did you notice this bit with uapi?
F:      include/linux/dm-*.h

Alasdair
