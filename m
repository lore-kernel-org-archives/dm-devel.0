From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v2 1/2] dm-unstripe: unstripe of IO across RAID 0
Date: Mon, 11 Dec 2017 16:25:50 -0700
Message-ID: <20171211232550.GD11218@localhost.localdomain>
References: <20171211160019.20518-1-scott.bauer@intel.com>
 <20171211160019.20518-2-scott.bauer@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171211160019.20518-2-scott.bauer@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Scott Bauer <scott.bauer@intel.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On Mon, Dec 11, 2017 at 09:00:18AM -0700, Scott Bauer wrote:
> +
> +	dm_set_target_max_io_len(ti, target->max_hw_sectors);

The return for this function has "__must_check", so it's currently
throwing an a compiler warning.

Otherwise, this looks like it's doing what you want, and tests
successfully on my synthetic workloads.

Acked-by: Keith Busch <keith.busch@intel.com>
