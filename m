From: Sebastian Reitenbach <sebastia@l00-bugdead-prods.de>
Subject: Re: /dev/sdaa /dev/sdab ... not recognized as valid paths?
Date: Wed, 14 Jan 2009 08:42:30 +0100
Message-ID: <200901140842.31141.sebastia@l00-bugdead-prods.de>
References: <200901140738.03109.sebastia@l00-bugdead-prods.de>
	<496D9552.8080202@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <496D9552.8080202@suse.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wednesday 14 January 2009 08:33:38 am Hannes Reinecke wrote:
> Hi Sebastian,
>
> Sebastian Reitenbach wrote:
> > Hi,
> >
> > I do present 8 luns to the cluster. For each lun there are 4 ways through
> > the SAN that can be used. Therefore I have devices like /dev/sdaa
> > /dev/sdab and so on. The output of multipath -ll shows some disks with 4
> > paths, some with three, some only with two. In the output of multipath
> > -ll only disks with three letters are shown e.g. /dev/sda.
> > when I run e.g. /sbin/scsi_id -g -u -s /block/sdaa, then it outputs one
> > of the configured ID's that I already have in /etc/multipath.conf.
> >
> > How can I add these disks to the multipath failover?
> >
> > I'm on SLES10 sp2.
>
> Have you enabled udev?
> No, it's not on by default. Don't ask.
yes, udevd runs:
service boot.udev status
Checking for udevd:                                                   running

Here the beginning of my /etc/multipath.conf file:
defaults {
        udev_dir        /dev
        path_grouping_policy    multibus
        getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        prio    "alua"
        user_friendly_names yes

        default_features        "0"
}
blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*|sda"
}
multipaths {
        multipath {
...
        }
}

this version of the multipath tools is installed: multipath-tools-0.4.7-34.40

regards
Sebastian
>
> Cheers,
>
> Hannes
