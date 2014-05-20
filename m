From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm: check era->md is non-NULL before closing it
Date: Tue, 20 May 2014 08:41:20 +0100
Message-ID: <20140520074120.GA30857@debian>
References: <87d2f9ds17.fsf@elisp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d2f9ds17.fsf@elisp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: naota@elisp.net
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, May 20, 2014 at 12:53:56PM +0900, naota@elisp.net wrote:
> In era_ctr(), era->md remain NULL until it's set after metadata_open().
> On the other hand, era_destroy() assume era->md is non-NULL and it is
> called by era_ctr() before initializing the value.

Thanks.  This change went into my tree on the 11th March, I'll chase
and see why it's not upstream yet.

- Joe
