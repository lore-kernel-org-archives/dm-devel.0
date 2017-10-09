From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 1/6] libmultipath: add detect_checker
	option
Date: Mon, 9 Oct 2017 14:09:13 -0500
Message-ID: <20171009190913.GH3145@octiron.msp.redhat.com>
References: <20170925164924.GX3145@octiron.msp.redhat.com>
	<20171005202551.10719-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171005202551.10719-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Thu, Oct 05, 2017 at 10:25:50PM +0200, Martin Wilck wrote:
> On Mon, 2017-09-25 at 11:49 -0500, Benjamin Marzinski wrote:
> > On Mon, Sep 25, 2017 at 06:15:20PM +0200, Xose Vazquez Perez wrote:
> > > On 02/27/2017 07:26 PM, Benjamin Marzinski wrote:
> > > 
> > > > This patch adds a detect_checker option that works just like the
> > > > detect_prio option.  It currently only detects ALUA devices, and
> > > > if it finds ALUA support, it sets the priortizier to TUR. This is
> > > > useful for devices like the VNX2, where it should be using the
> > > > TUR checker when in ALUA mode (or so I have been told). It is set
> > > > on by
> > > > default just like detect_prio and retain_attached_hw_handler.
> > > 
> > > RDAC devices are going also to be affected with this change.
> > > Is it desired?
> > 
> > No. I'll send a patch that adds a check_rdac() call before setting
> > the
> > checker type to TUR.
> > 
> 
> Like this, perhaps?
> 
> Martin Wilck (1):
>   limbultipath: prefer RDAC checker with detect_checker

Oops. I totally dropped this off my plate. But, yes, just like that.

ACK

-Ben

> 
>  libmultipath/propsel.c | 52 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 30 insertions(+), 22 deletions(-)
> 
> -- 
> 2.14.2
