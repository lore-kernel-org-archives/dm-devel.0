From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm cache: fix race affecting dirty block count
Date: Fri, 1 Aug 2014 16:17:30 +0100
Message-ID: <20140801151729.GA27644@debian>
References: <53D32999.6080206@iki.fi>
 <1406831487-18750-1-git-send-email-anssi.hannula@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406831487-18750-1-git-send-email-anssi.hannula@iki.fi>
Sender: stable-owner@vger.kernel.org
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jul 31, 2014 at 09:31:27PM +0300, Anssi Hannula wrote:
> I did notice that after a reboot (after having incorrect nr_dirty) the
> entire cache was considered to be dirty and a full writeback occurred,
> but I don't know if that was related at all.

Did you take the cache down cleanly?  Normally this happens when you
shutdown without destroying the cache device first.

Patch looks good.

- Joe
