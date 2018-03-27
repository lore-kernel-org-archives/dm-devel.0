From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: Can we drop 'hardware_handler "1 alua"'?
Date: Tue, 27 Mar 2018 17:46:28 +0200
Message-ID: <9660e35b-7c25-f74d-3b26-561e387e501b@gmail.com>
References: <1522140989.13140.12.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1522140989.13140.12.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>, Leonardo Arena <rnalrd@alpinelinux.org>, Thomas Deutschmann <whissi@gentoo.org>, Lars Wendler <polynomial-c@gentoo.org>, Ritesh Raj Sarraf <rrs@debian.org>, Vincent McIntyre <vincent.mcintyre@csiro.au>, Julian Andres Klode <juliank@ubuntu.com>, Michael Lass <bevan@bi-co.net>
List-Id: dm-devel.ids

On 03/27/2018 10:56 AM, Martin Wilck wrote:

> hwtable.c has multiple entries that set 'hardware_handler "1 alua"'
> explicitly. But the kernel has been auto-attaching the ALUA hwhandler
> to devices that support it since 4.3, the only prerequisite being that
> scsi_dh_alua is present at device probing time (kernel commits
> d95dbff2, d6a32b98). "retain_attached_hwhandler" is also hard-wired
> since 4.3. Thus if the above prerequisite is met, there's no point in
> setting 'hardware_handler "1 alua"'.
> 
> We've recently seen problems with the explicit setting of the alua
> hwhandler in the hwtable; if we do this and the device fails ALUA for
> whatever reason, setting up the multipath map fails entirely.
> 
> Therefore we have reasons to try and remove 'hardware_handler "1 alua"'
> from the hwtable. But it could cause regressions in some cases, e.g.
> for distributions that don't force-load scsi_dh_alua before device
> probing, or for kernels older than 4.3.
Remove it, and add info to README.alua or README.kernel-lower-4.4 ...


systemd distributions are safe with this line from multipathd/multipathd.service:
ExecStartPre=-/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac dm-multipath


Gentoo, Alpine and Debian/Ubuntu should adapt their OpenRC/sysvinit scripts and
also initrd, just in case.


The last longterm-kernel<4.4, 3.16 will die in "Apr, 2020":
https://www.kernel.org/category/releases.html
