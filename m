From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] add stripe end_io function and event
	trigger
Date: Wed, 5 Dec 2007 09:57:08 -0800
Message-ID: <20071205175708.GA12022@linux.vnet.ibm.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC01A1DFE8@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC01A1DFE8@orsmsx418.amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Wood, Brian J <brian.j.wood@intel.com> wrote:
> +static void trigger_event(struct work_struct *work)
> +{
> +	int i, len;
> +	char dev_path[DEV_STR_LEN];
> +	struct stripe_c *sc = container_of(work, struct stripe_c,
> kstriped_ws);

It appears your mailer is breaking lines which leads to hand edits prior
to trying to apply the patch.

Your patch also appears to be adding extra whitespace. You want to run
checkpatch.pl prior to sending the patch out and correct all issues
listed.

> +		/* Finally as a last check, see if the inode mode is set
> 
> +		 * to be a block device, record error if not */

> +		if (!S_ISBLK(inode->i_mode)) {
> +			atomic_inc(&(sc->stripe[i].error_count));
> +		}

Code comment style and extra bracing.

http://sources.redhat.com/lvm2/wiki/KernelPatchGuidelines


-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
