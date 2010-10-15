From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Make it possible to set a uuid if one
	was	not set during DM_DEV_CREATE.
Date: Fri, 15 Oct 2010 16:11:01 +0100
Message-ID: <20101015151101.GI32395@agk-dp.fab.redhat.com>
References: <1286560423-12748-1-git-send-email-pjones@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1286560423-12748-1-git-send-email-pjones@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Jones <pjones@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Peter Rajnoha tested this this morning and 'dmsetup remove' hung.

On Fri, Oct 08, 2010 at 01:53:43PM -0400, Peter Jones wrote:
> +	if (param->flags & DM_NEW_UUID_FLAG) {
> +		/*
> +		 * Does this device already have a uuid?
> +		 */
> +		if (hc->uuid) {
> +			DMWARN("asked to change uuid of device with uuid "
> +			       "already set %s %s -> %s",
> +			       param->name, hc->uuid, param->uuid);

It's missing dm_put(hd->md) here.

> +			up_write(&_hash_lock);
> +			kfree(new_data);
> +			return ERR_PTR(-EINVAL);

Alasdair
