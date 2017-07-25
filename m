From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm,
	dax: Make sure dm_dax_flush() is called if device supports it
Date: Tue, 25 Jul 2017 16:46:09 -0400
Message-ID: <20170725204608.GA27693@redhat.com>
References: <20170725194337.GA20979@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170725194337.GA20979@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dm-devel@redhat.com, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-Id: dm-devel.ids

On Tue, Jul 25 2017 at  3:43pm -0400,
Vivek Goyal <vgoyal@redhat.com> wrote:

> Right now, dm_dax_flush() is not being called and I think it is not being
> called becuase DAXDEV_WRITE_CACHE is not set on dm dax device.
> 
> If underlying dax device supports write cache, set DAXDEV_WRITE_CACHE on
> dm dax device. This will get dm_dax_flush() being called.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

In general this looks mostly OK.. but it seems a bit weird to on the one
hand: test if DAXDEV_WRITE_CACHE is set on underlying device.  And on
the other: say it is a write cache because it is "flush_capable".  Kind
of blurring things a bit.

Why not s/device_dax_flush_capable/device_dax_write_cache_enabled/ ?

Mike
