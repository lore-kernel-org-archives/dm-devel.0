From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm: verity: Add support for emitting
	uevents on dm-verity errors.
Date: Fri, 21 Jun 2013 01:59:05 +0100
Message-ID: <20130621005905.GI23042@agk-dp.fab.redhat.com>
References: <1371763260-9933-1-git-send-email-gcondra@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1371763260-9933-1-git-send-email-gcondra@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geremy Condra <gcondra@google.com>
Cc: dm-devel@redhat.com, wad@chromium.org, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 20, 2013 at 02:21:00PM -0700, Geremy Condra wrote:
> With this change and config option, dm-verity errors
> will cause uevents to be sent to userspace, notifying
> it that an error has occurred and potentially
> triggering recovery actions.
 
> +config DM_VERITY_ERROR_NOTIFY
> +	tristate "Notify userspace of verity errors through uevents"
> +	depends on DM_VERITY && DM_UEVENT
> +	---help---
> +	  This option instructs dm-verity to send uevents on error.
> +

Would it cause any problems if we had this feature enabled all the time,
controlled only by DM_UEVENT?

In other words, if we delete DM_VERITY_ERROR_NOTIFY from the upstream patch?

Alasdair
