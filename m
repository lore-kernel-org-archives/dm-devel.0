From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/4] libmultipath: get_udev_uid: make sure
 pp->wwid is 0-terminated
Date: Fri, 14 Jul 2017 14:56:29 +0000
Message-ID: <1500044188.2662.4.camel@wdc.com>
References: <20170714113209.17177-1-mwilck@suse.com>
	<20170714113209.17177-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170714113209.17177-2-mwilck@suse.com>
Content-Language: en-US
Content-ID: <E35AD630428A1643BF952AD6FC1B0867@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "tang.junhui@zte.com.cn" <tang.junhui@zte.com.cn>, "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, "guanjunxiong@huawei.com" <guanjunxiong@huawei.com>
Cc: "mwilck@suse.de" <mwilck@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: dm-devel.ids

On Fri, 2017-07-14 at 13:32 +0200, Martin Wilck wrote:
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

Hi Martin,

Your patch does not cause all overflows to be reported. How about using the
following (untested) alternative?

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index eca4ce97..80d962e6 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1607,13 +1607,8 @@ get_udev_uid(struct path * pp, char *uid_attribute, struct udev_device *udev)
 	if (!value || strlen(value) == 0)
 		value = getenv(uid_attribute);
 	if (value && strlen(value)) {
-		if (strlen(value) + 1 > WWID_SIZE) {
+		if (strlcpy(pp->wwid, value, sizeof(pp->wwid)) >= WWID_SIZE)
 			condlog(0, "%s: wwid overflow", pp->dev);
-			len = WWID_SIZE;
-		} else {
-			len = strlen(value);
-		}
-		strncpy(pp->wwid, value, len);
 	} else {
 		condlog(3, "%s: no %s attribute", pp->dev,
 			uid_attribute);
Bart.
