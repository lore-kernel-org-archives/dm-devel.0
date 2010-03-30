From: Martin Schwenke <martin@meltin.net>
Subject: Re: RHEL 5.4 multipath doesn't handle virtio block
 devices
Date: Tue, 30 Mar 2010 18:43:34 +1100
Message-ID: <20100330184334.43cf7934@martins.ozlabs.org>
References: <20100330121606.54b4a50c@martins.ozlabs.org>
	<4BB186F6.1050402@ct.jp.nec.com>
	<20100330172358.69e794b9@martins.ozlabs.org>
	<4BB1A53A.4030806@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BB1A53A.4030806@suse.de>
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

On Tue, 30 Mar 2010 09:16:10 +0200, Hannes Reinecke <hare@suse.de>
wrote:

> megasas megasas megasas ...
> I posted a megasas HBA emulation for KVM a while back.
> Would solve your problem rather elegantly.
> But then you'd have to recompile KVM, at which point you could include
> the SCSI emulation as well ...

Right, that sounds good.  However, for reasons I won't go into, I need
to use the version of KVM that ships with RHEL 5.  So recompiling or
even using RPMs provided by a 3rd party isn't an easy option.  :-(

> Problem is, though, that you don't have a unique ID for virtio
> devices. EG scsi_id and friends don't work here.
> And AFAIR there is no feature flag which would allow you do set one.
> 
> How do you distinguish between, say, 2 virtio devices across 2 paths?

I write a unique identifier onto each image using dd and then as you
would expect, in the libvirt XML configuration, I make 2 devices point
to each image.

Then I use a custom getuid_callout setting, as follows:

  [root@strg001st068 ~]# cat /sbin/scsi_id_autocluster.sh
  #!/bin/sh
  # get scsi ID assuming disks setup by autocluster
  /bin/dd if=/dev/$1 bs=1 count=13 2> /dev/null | cat -v
  echo

The filesystem being used on those disks doesn't use the first
block...  ;-)

It works nicely...

peace & happiness,
martin
