From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Choosing the device name in kpartx.
Date: Mon, 3 Oct 2016 07:59:41 +0100
Message-ID: <20161003065940.GA3480@localhost.localdomain>
References: <CADVh14WfxhnCj8Mok1iq-KXJ7hYOBF0rUBQboVdxfGT=Zdq6Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CADVh14WfxhnCj8Mok1iq-KXJ7hYOBF0rUBQboVdxfGT=Zdq6Tw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andre Caldas <andre.em.caldas@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Oct 02, 2016 at 02:10:50AM -0300, Andre Caldas wrote:
> As I understood it, when I call
> $ kpartx -a disk.img
> kpartx chooses a "device name" X, detects the partitions and their
> numbers N, and creates device nodes with naming
> XpN.

This command performs several steps for you. You can have greater
control by issuing those steps yourself:

1. Create a loop device mapping the image (/dev/loopN)
2. Create a device-mapper device with a linear map of the loop:

   # dmsetup create $DEV_NAME --table="0 $DEV_SIZE linear /dev/loopN"

   This allows you to give any DEV_NAME you like to the device (with
   the default kpartx behaviour, the partitions just map the loop
   device, so have names like 'loop0p1' etc.).

3. Map partitions on the new dm device with kpartx:

   # kpartx -a /dev/mapper/$DEV_NAME

See the kpartx man page for options to fine-tune the partition device
names.

The dmsetup command has lots of options to control the output format
that can be used to get readily parseable data.

Regards,
Bryn.
