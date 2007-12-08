From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] dm: add stripe end_io function and event
	trigger
Date: Sat, 8 Dec 2007 03:32:16 +0000
Message-ID: <20071208033215.GF22311@agk.fab.redhat.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC01A86F93@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC01A86F93@orsmsx418.amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Wood, Brian J" <brian.j.wood@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 07, 2007 at 12:10:51PM -0800, Wood, Brian J wrote:
> +static void trigger_event(struct work_struct *work)

> +	/* Test to see which stripe drive triggered the event. */
> +	for (i = 0; i < sc->stripes; i++) {
> +		memset(dev_path, 0, DEV_STR_LEN);
> +		memcpy(dev_path, "/dev/", len = strlen("/dev/"));
> +		/* Copy name of the drive stored in the gendisk
> structure
> +		 * (this is the same name as what is stored in the
> +		 * /proc and /sysfs filesystems */
> +		memcpy(dev_path+len,
> +			sc->stripe[i].dev->bdev->bd_disk->disk_name,

I'm afraid I don't understand what's going on here.

Inode/name lookups have caused dm plenty of trouble in the past from
memory and locking problems so we go out of our way to avoid them.
Only pre-existing fields (like 'name') should be used as device
references.  (And how does that loop work with the error counting?)

> +	/* Trigger event to let dmeventd daemon know to
> +	 * check device status when stripe's DSO is registered*/

(The kernel is independent of any userspace implementation, so we
avoid references to specific choices of userspace daemons.  You
can however include reference examples like that in the patch header.)

> +	 * disconnected this sets "error == -5" */

The symbolic representation of -5 is?

Alasdair
-- 
agk@redhat.com
