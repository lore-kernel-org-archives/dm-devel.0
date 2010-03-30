From: Hannes Reinecke <hare@suse.de>
Subject: Re: RHEL 5.4 multipath doesn't handle virtio block
	devices
Date: Tue, 30 Mar 2010 09:16:10 +0200
Message-ID: <4BB1A53A.4030806@suse.de>
References: <20100330121606.54b4a50c@martins.ozlabs.org>	<4BB186F6.1050402@ct.jp.nec.com>
	<20100330172358.69e794b9@martins.ozlabs.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100330172358.69e794b9@martins.ozlabs.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: k-ueda@ct.jp.nec.com
List-Id: dm-devel.ids

Martin Schwenke wrote:
> On Tue, 30 Mar 2010 14:07:02 +0900, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> wrote:
> =

>> Why do you want to use dm-multipath on virtio block devices?
> =

> For consistency rather than failover...  :-)
> =

> I'm using virtual machines to test a clustered NAS environment.  The
> production setup expects to see dm devices from dm-multipath.  So I'm
> using dm-multipath on virtio block devices to simulate use of
> dm-multipath in a SAN environment.  =

> =

megasas megasas megasas ...
I posted a megasas HBA emulation for KVM a while back.
Would solve your problem rather elegantly.
But then you'd have to recompile KVM, at which point you could include
the SCSI emulation as well ...

> The RHEL 5.4 version of KVM doesn't contain a SCSI emulation, so the
> only 2 choices for large numbers of block devices are virtio and
> iSCSI.  I'm trying to keep my options open for both of these.
> =

> The fix for virtio block devices seems quite straightforward, so I
> thought I would propose it.  :-)
> =

Problem is, though, that you don't have a unique ID for virtio devices.
EG scsi_id and friends don't work here.
And AFAIR there is no feature flag which would allow you do set one.

How do you distinguish between, say, 2 virtio devices across 2 paths?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
