From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RFC: dm-switch target [v3]
Date: Thu, 27 Oct 2011 14:52:23 -0400
Message-ID: <20111027185223.GA6444@redhat.com>
References: <20111021202253.GA27434@freewill.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20111021202253.GA27434@freewill.equallogic.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jim Ramsay <jim_ramsay@dell.com>
Cc: dm-devel@redhat.com, "Shah, Parind" <Parind_Shah@dell.com>, "Shamberger,
	Jason" <Jason_Shamberger@dell.com>, "OKelley,
	Kevin" <Kevin_OKelley@dell.com>
List-Id: dm-devel.ids

On Fri, Oct 21 2011 at  4:22pm -0400,
Jim Ramsay <jim_ramsay@dell.com> wrote:

> Note: This is a repost with a few important implementation improvements.
...
> - Added a sysfs file so userland applications can easily check the version of
>   this module.
...

> static ssize_t sysfs_version_show(struct kobject *kobj,
> 				  struct attribute *attr, char *buff)
> {
> 	return snprintf(buff, PAGE_SIZE, "%d.%d.%d\n",
> 			__g_switch_target.version[0],
> 			__g_switch_target.version[1],
> 			__g_switch_target.version[2]);
> }
> 
> static ssize_t sysfs_version_store(struct kobject *kobj,
> 				   struct attribute *attr, const char *buff,
> 				   size_t size)
> {
> 	return -EINVAL;
> }
> 
> static const struct _sysfs_attr_ops __g_sysfs_version = {
> 	.attr = {"version", 0444},
> 	.ops = {&sysfs_version_show, &sysfs_version_store}
> };

One would hope that this "version" file isn't needed.  DM already
provides the ability to query the version of targets via the
DM_LIST_VERSIONS dm-ioctl.  E.g.:

# dmsetup targets
thin-pool        v1.0.0
thin             v1.0.0
mirror           v1.12.1
multipath        v1.3.0
striped          v1.4.0
linear           v1.1.0
error            v1.0.1

But we don't have the ability to ask for a specific target's version.

(lvm2's tools/dmsetup.c:_targets() illustrates how to collect the
targets and access their versions -- would require linking against
libdm).

But we could add a --target flag to dmsetup targets (like 'dmsetup ls'
allows), e.g.: dmsetup targets --target switch

Mike
