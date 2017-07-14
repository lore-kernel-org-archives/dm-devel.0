From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/4] libmultipath: get_udev_uid: make sure
 pp->wwid is 0-terminated
Date: Fri, 14 Jul 2017 17:17:53 -0500
Message-ID: <20170714221753.GA2940@octiron.msp.redhat.com>
References: <20170714113209.17177-1-mwilck@suse.com>
	<20170714113209.17177-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170714113209.17177-2-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Martin Wilck <mwilck@suse.de>, Xose Vazquez Perez <xose.vazquez@gmail.com>, tang.junhui@zte.com.cn, Guan Junxiong <guanjunxiong@huawei.com>, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

ACK, but I'm fine with Bart's patch as well.

-Ben

On Fri, Jul 14, 2017 at 01:32:06PM +0200, Martin Wilck wrote:
> If the first WWID_LEN bytes of the uuid_attribute do not contain
> a 0 byte, pp->wwid may end up not properly terminated. Fix it.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/discovery.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 663c8eaa..9951af84 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1615,6 +1615,7 @@ get_udev_uid(struct path * pp, char *uid_attribute, struct udev_device *udev)
>  			len = strlen(value);
>  		}
>  		strncpy(pp->wwid, value, len);
> +		pp->wwid[WWID_SIZE - 1] = '\0';
>  	} else {
>  		condlog(3, "%s: no %s attribute", pp->dev,
>  			uid_attribute);
> -- 
> 2.13.2
