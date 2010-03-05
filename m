From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm_ioctl: Introduce DM_UEVENT_GENERATED_FLAG
Date: Fri, 5 Mar 2010 19:38:19 +0000
Message-ID: <20100305193819.GS27852@agk-dp.fab.redhat.com>
References: <4B8B7A65.3020301@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B8B7A65.3020301@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Rajnoha <prajnoha@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 01, 2010 at 09:27:17AM +0100, Peter Rajnoha wrote:
> +	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, cookie))
> +		*flags |= DM_UEVENT_GENERATED_FLAG;
  
If userspace set this flag before the call, where is it cleared?
It needs to have a defined state on *every* call.
I'll add this to the top of validate_params.

Alasdair
