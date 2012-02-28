From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Add barrier support to dm-raid
Date: Tue, 28 Feb 2012 09:00:18 -0500
Message-ID: <20120228140018.GB18849@redhat.com>
References: <1330437449.9910.2.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1330437449.9910.2.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 28 2012 at  8:57am -0500,
Jonathan Brassow <jbrassow@redhat.com> wrote:

> Add barrier support to dm-raid.
> 
> MD has support for barriers.  DM core has support for barriers.  Set the
> variable necessary to indicate to DM core that it is ok to pass down
> barrier requests - which dm-raid will simply pass along to MD.
> 
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
