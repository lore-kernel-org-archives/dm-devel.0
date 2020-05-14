From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] device-mapper: use dynamic debug instead
 of compile-time config option
Date: Thu, 14 May 2020 13:15:33 -0400
Message-ID: <20200514171533.GD31400@redhat.com>
References: <20200514060929.85469-1-hare@suse.de>
	<20200514060929.85469-2-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200514060929.85469-2-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Hannes Reinecke <hare@suse.de>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, May 14 2020 at  2:09am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> Switch to use dynamic debug to avoid having recompile the kernel
> just to enable debugging messages.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

FYI, I decided to always use pr_debug* rather than preserve using printk
if CONFIG_DM_DEBUG is enabled.  More consistent and less surprising for
a developer (to have to reason through how to enable debugging).

May cause initial surprise if debugging messages disappear despite
CONFIG_DM_DEBUG being enabled... but pretty sure DM developers can cope
(and/or help non-developers) as needed.

Patches were staged for 5.8, I also added an additional related cleanup:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.8

Thanks,
Mike
