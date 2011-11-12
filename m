From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: Multipath.conf
Date: Sat, 12 Nov 2011 13:18:04 +0100
Message-ID: <1321100284.14506.18.camel@lapoo.opensvc.com>
References: <OF65500C59.20F9F543-ON80257944.003C1AE0-80257944.003F18B9@bportugal.pt>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF65500C59.20F9F543-ON80257944.003C1AE0-80257944.003F18B9@bportugal.pt>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tiago.Francisco.Abreu@bportugal.pt
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> 1) Can someone point me to the latest version of the documentation?
> The following examples seem to show that the multipath(d) are not in sync
> with the man.

The uptodate information is the one shipped with the sources. It may
have rotten parts ... but feel free to point them out for us to fix.

> a) polling_interval
> The man page and the comments in the multipath.conf say that the default
> value is 5, but when I execute "multipath -t" when I didn't specified the
> value in multipath.conf it says the polling_interval is 0.
> I don't even know what 0 means.
> Is "multipath -t" giving incorrect values? Is my reasonning wrong? Other?
> 
Fixed as of today by commit 56753df50b08d67fb711e215a556d005f82ddf7b

> b) path_grouping_policy
> man says that the default is multibus.
> Red Hat Documentation (
> http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/DM_Multipath/config_file_defaults.html
> ) says the default is Failover.
> 
I have no such default in either multipath.8 multipathd.8 and
multipath.conf.defaults

multipath.conf.annotated correctly points failover as the default policy

> c) prio
> man says default is none.
> Red Hat Documentation (
> http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/DM_Multipath/config_file_defaults.html
> ) says the default is const.
> 
I have no such default in either multipath.8 multipathd.8 and
multipath.conf.defaults has the correct const default.

Fixed in multipath.conf.annotated though

> d) Why "prio emc" gives "sda: emc prio: query command indicates error",
> when I execute multipath -v2 -d with multipathd not running. And sda is
> even in the blacklist.
> 
> e) If I have EMC Clariion Disk Array, should I use: "path_checker
> emc_clariion"?
> 
Depends on the Clariion settings. Either that or alua

> f) What is the correct getuid_callout:
> -  /sbin/scsi_id -g -u -s /block/%n (As old EMC document says)
> - /sbin/scsi_id -g -u -s (As the man says)
> - "/lib/dev/scsi_id --whitelisted --device=/dev/%n" (As
> http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/DM_Multipath/config_file_defaults.html
>  says.)
> 
The correct one is the one that works on your system. Different scsi_id
version running on different kernel version have different behaviour.
The internal default makes it work with latest kernel/scsi_id

> g) There maybe more differences. I didn't check all.
> 
Please do, if you have the means. Input is valuable.
