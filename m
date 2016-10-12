From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: remove hwhandler when it's
	alua
Date: Wed, 12 Oct 2016 13:06:10 +0200
Message-ID: <305ee5f4-8a06-4f33-6f72-892c0a9919a2@gmail.com>
References: <20161006185021.3625-1-xose.vazquez@gmail.com>
	<CABr-GnfHUoWn_q4LfvhDeF6w_vPcMg8VRjEN98quZ6+oes1Ryw@mail.gmail.com>
	<1d46912b-0cad-89e4-2bd6-2b4c9e3fe67f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1d46912b-0cad-89e4-2bd6-2b4c9e3fe67f@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/11/2016 08:22 AM, Hannes Reinecke wrote:

> Autodetection will only work if the hardware handler is loaded.
> If the handler is _not_ loaded autodetection won't work, either.
> And if we add this patch multipath will never load the modules, neither.
> So we need this functionality as a fallback if autodetect does not work.

I'm pretty sure all works flawlessly with this patch. Because I use similar
options for EMC VNX7500(CLARiiON) configured as ALUA "Failover Mode 4 (Asymmetric Active/Active)",
with SLES-11/12 and RHEL-6 booting from SAN.

For SLES it was added to DGC config:
retain_attached_hw_handler yes
detect_prio yes

In RHEL it's included by default:
http://pkgs.fedoraproject.org/cgit/rpms/device-mapper-multipath.git/plain/0117-RHBZ-1198424-autodetect-clariion-alua.patch

And the modules are preloaded by multipathd/multipathd.service:
ExecStartPre=/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac dm-multipath


RDAC devices also depend *exclusively* on "retain_attached_hw_handler" and "detect_prio"
to run in ALUA mode.
