From: Ritika Srivastava <ritika.srivastava@oracle.com>
Subject: Re: [PATCH 7/7] multipathd: ignore uevents for non-mpath
 devices
Date: Mon, 29 Jan 2018 14:25:08 -0800
Message-ID: <0f6c9e29-b4a7-74b9-4ce0-b776214d9466@oracle.com>
References: <20180117074939.7795-1-mwilck@suse.com>
	<20180117074939.7795-8-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180117074939.7795-8-mwilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On 01/16/2018 11:49 PM, Martin Wilck wrote:
> multipathd can't deal with other devices anyway. Proceeding further
> with events for other devices just generates log noise.
>
> Based on an idea from Ritika Srivastava <ritika.srivastava@oracle.com>.
> ("multipath-tools: Skip CHANGE uevent for non-mpath devices").
>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   multipathd/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index ff3ecb640487..26632291657f 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1121,7 +1121,7 @@ uev_trigger (struct uevent * uev, void * trigger_data)
>   	 * Add events are ignored here as the tables
>   	 * are not fully initialised then.
>   	 */
> -	if (!strncmp(uev->kernel, "dm-", 3)) {
> +	if (!strncmp(uev->kernel, "dm-", 3) && uevent_is_mpath(uev)) {
>   		if (!strncmp(uev->action, "change", 6)) {
>   			r = uev_add_map(uev, vecs);
>   

Hi Martin,
Thank you for the updated patch.
With this patch, the error "uevent trigger error" would not be 
encountered when removing lvm snapshots.

However, when the uevent is for a 'dm' device but not for a multipath 
device, then should we just return from this check in uev_trigger()?
With this patch, uev_update_path()/uev_remove_path() would still be 
called which would generate further log.
Should we avoid these function calls too?
-- 
Thanks,
Ritika
