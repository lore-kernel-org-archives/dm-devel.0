From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: dm target options
Date: Thu, 3 Mar 2005 14:22:27 -0600
Message-ID: <200503031422.28515.kevcorry@us.ibm.com>
References: <20050303181541.GA6814@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050303181541.GA6814@thumper2>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Andy,

On Thu March 3 2005 12:15 pm, Andy wrote:
> Is there any documentation that gives the format and options for the dm
> targets table?  I'm trying to setup a mirror target, but can't find a lot
> of information about it, and what the options mean.  Is dm-mirror good for
> production use, or should I just use md for mirroring?

There probably isn't any formal documents for the dm-mirror target. Looking at 
drivers/md/dm-raid1.c::mirror_ctr() in the kernel tree, the current table 
format is:

<start_lba> <size_in_sectors> mirror <log_type> <#_log_params> <log_params> \
   <#_mirrors> [<mirror_path> <starting_lba>]{2,}

where <log_type> is "core" or "disk".
<#_log_params> is 0 for the "core" log, and thus there is no <log_params> 
entry.
<#_log_params> is 2 or 3, and the <log_params> is:
  <log_device_path> <region_size> [<sync|nosync>]?

However, dm-mirror is primary used for pe-move in LVM2 and EVMS right now. 
There's still some improvements that will need to be made before it can be a 
full replacement for MD RAID-1. So if you're looking for something to use 
immediately, I'd stick with the MD driver for RAID functionality.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/ltc/
http://evms.sourceforge.net/
