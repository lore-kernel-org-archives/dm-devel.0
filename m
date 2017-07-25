From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: dm,dax: Make sure dm_dax_flush() is called if device supports it
Date: Tue, 25 Jul 2017 16:54:16 -0400
Message-ID: <20170725205416.GC20979@redhat.com>
References: <20170725194337.GA20979@redhat.com>
 <20170725204608.GA27693@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170725204608.GA27693-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: dm-devel.ids

On Tue, Jul 25, 2017 at 04:46:09PM -0400, Mike Snitzer wrote:
> On Tue, Jul 25 2017 at  3:43pm -0400,
> Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > Right now, dm_dax_flush() is not being called and I think it is not being
> > called becuase DAXDEV_WRITE_CACHE is not set on dm dax device.
> > 
> > If underlying dax device supports write cache, set DAXDEV_WRITE_CACHE on
> > dm dax device. This will get dm_dax_flush() being called.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> In general this looks mostly OK.. but it seems a bit weird to on the one
> hand: test if DAXDEV_WRITE_CACHE is set on underlying device.  And on
> the other: say it is a write cache because it is "flush_capable".  Kind
> of blurring things a bit.
> 
> Why not s/device_dax_flush_capable/device_dax_write_cache_enabled/ ?

Sounds good. I will rename it in next version.

Vivek
