From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: How to filter local disks that should not be managed
 by multipathd?
Date: Wed, 20 Jul 2016 16:06:46 +0200
Message-ID: <bfceebd0-65f2-dd8c-2804-8a2f0fd6c8c3@gmail.com>
References: <AF7C226D2A4F8B4D913D33FF7150AE0531BECD94@szxeml556-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AF7C226D2A4F8B4D913D33FF7150AE0531BECD94@szxeml556-mbs.china.huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xieyingtai <xieyingtai@huawei.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/18/2016 01:59 PM, Xieyingtai wrote:
> Hi,
> 
>    Recently I encountered a problem, In certain scenarios that a new local disk was hot plugged, I have no way
> 
> to obtain the wwn of the disk in advance, so I can not filter that disk by adding it to blacklists. Actually there
> 
> is no need for multipathd to  take over local disks in the hot-plugged sceno. And find_multipaths param seems not to be
> 
> a perfect way to solve this problem. Is there any way to  provide a param in /etc/multipath.conf for mulitpathd to manage
> 
> only ISCSI or FC bus disks? In that configuration, path_discovery() will only scan devices which were underline ISCSI bus
> 
> or FC bus in sysfs.

Add a rule in the "blacklist section" to exclude ALL,
and then fill the "blacklist_exceptions section" with
the desired devices.
