From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 1/2] multipath.conf: add "enable_foreign"
	parameter
Date: Mon, 19 Aug 2019 20:32:37 +0000
Message-ID: <da712bc269003e39dd35e8d7799992ff1d650c6a.camel@suse.com>
References: <20190815144638.5664-1-martin.wilck@suse.com>
	<20190815144638.5664-2-martin.wilck@suse.com>
	<20190816201218.GF25414@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190816201218.GF25414@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <CD4C0E7ED279B04CA14B6419438E6737@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2019-08-16 at 15:12 -0500, Benjamin Marzinski wrote:
> On Thu, Aug 15, 2019 at 02:46:54PM +0000, Martin Wilck wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > This new configuration parameter can be used to selectively
> > enable foreign libraries. The value is a regular expression,
> > against which foreign library names such as "nvme" are matched.
> > By setting this to a value that matches no foreign library
> > (e.g. "^$" or "NONE"), foreign code is completely disabled.
> > By default, all available foreign libraries are loaded.
> > 
> 
> This will stop the foreign libraries from even claiming devices.
> Won't
> this mean that pathinfo() will now treat these devices as
> multipathable
> paths, since is_claimed_by_foreign() will return false? 

IMO this won't happen, because we ignore the native multipath path
devices anyway as they're "hidden", and we ignore native NVMe multipath
maps because they have "nvme-subsystem" subsystem rather than "nvme"
(commit b18ed66). But I'll double-check again.

Martin
