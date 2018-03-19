From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH RESEND] multipathd: check and cleanup zombie
 paths
Date: Mon, 19 Mar 2018 14:48:36 -0700
Message-ID: <5ec40e21-f756-c599-597f-75214a219402@wdc.com>
References: <CEB9978CF3252343BE3C67AC9F0086A34295C7AB@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A34295C7AB@H3CMLB14-EX.srv.huawei-3com.com>
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
To: Chongyun Wu <wu.chongyun@h3c.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 'Christophe Varoqui' <christophe.varoqui@opensvc.com>, 'Hannes Reinecke' <hare@suse.de>, 'Xose Vazquez Perez' <xose.vazquez@gmail.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Changlimin <changlimin@h3c.com>, Changwei Ge <ge.changwei@h3c.com>
List-Id: dm-devel.ids

On 03/05/18 17:26, Chongyun Wu wrote:
> +				sysfs_attr_set_value(pp->udev, "device/delete",
> +						delete, strlen(delete));

Before using the "delete" sysfs attribute, please fix the kernel 
deadlock reported in "Avoid that SCSI device removal through sysfs 
triggers a deadlock" 
(https://www.spinics.net/lists/linux-scsi/msg101193.html).

Thanks,

Bart.
