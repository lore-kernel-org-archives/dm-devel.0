From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 1/2] multipath.conf: add "enable_foreign"
 parameter
Date: Tue, 20 Aug 2019 14:24:46 -0500
Message-ID: <20190820192446.GM25414@octiron.msp.redhat.com>
References: <20190815144638.5664-1-martin.wilck@suse.com>
	<20190815144638.5664-2-martin.wilck@suse.com>
	<20190816201218.GF25414@octiron.msp.redhat.com>
	<da712bc269003e39dd35e8d7799992ff1d650c6a.camel@suse.com>
	<3913aa7aa45297995fc8776bc7d4496ef9fbe3f8.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3913aa7aa45297995fc8776bc7d4496ef9fbe3f8.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 20, 2019 at 04:24:58PM +0000, Martin Wilck wrote:
> On Mon, 2019-08-19 at 20:32 +0000, Martin Wilck wrote:
> > On Fri, 2019-08-16 at 15:12 -0500, Benjamin Marzinski wrote:
> > > On Thu, Aug 15, 2019 at 02:46:54PM +0000, Martin Wilck wrote:
> > > > From: Martin Wilck <mwilck@suse.com>
> > > > 
> > > > This new configuration parameter can be used to selectively
> > > > enable foreign libraries. The value is a regular expression,
> > > > against which foreign library names such as "nvme" are matched.
> > > > By setting this to a value that matches no foreign library
> > > > (e.g. "^$" or "NONE"), foreign code is completely disabled.
> > > > By default, all available foreign libraries are loaded.
> > > > 
> > > 
> > > This will stop the foreign libraries from even claiming devices.
> > > Won't
> > > this mean that pathinfo() will now treat these devices as
> > > multipathable
> > > paths, since is_claimed_by_foreign() will return false? 
> > 
> > IMO this won't happen, because we ignore the native multipath path
> > devices anyway as they're "hidden", and we ignore native NVMe
> > multipath
> > maps because they have "nvme-subsystem" subsystem rather than "nvme"
> > (commit b18ed66). But I'll double-check again.
> 
> Confirmed. With nvme_core.multipath=Y and the nvme library disabled,no
> NVMe-related output is printed.
> 
> Ben, with that in mind, would you ACK this patch?

Sure. Sorry about the confusion

Reviewed-by: Benjamin Marzinksi <bmarzins@redhat.com>
 
> Martin
> 
