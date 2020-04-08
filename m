From: Milan Broz <gmazyland@gmail.com>
Subject: Re: alignment enforcement in dm-crypt causes severe
	problems
Date: Wed, 8 Apr 2020 17:05:31 +0200
Message-ID: <66dbdf7d-8c47-d723-0c15-cb7176934d42@gmail.com>
References: <754a4098-9da2-3395-8a9e-f5b7737ed242@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <754a4098-9da2-3395-8a9e-f5b7737ed242@posteo.de>
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
To: Andreas Kinzler <hfp@posteo.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/04/2020 12:21, Andreas Kinzler wrote:
> Hello devs,
> 
> please see issue: 
> https://github.com/virtio-win/kvm-guest-drivers-windows/issues/446
> 
> Short summary: When using encrypted disks with qemu (using dm-crypt) and 
> pass that through LIO/vhost to qemu (via virtio-scsi) the following code 
> is hit:
> 
> https://elixir.bootlin.com/linux/v5.3.18/source/drivers/md/dm-crypt.c#L1251
> 
> I am not familiar with the specification/contract of "bio". So I am not 
> sure if the enforced alignment is legitimate.

Encryption in dm-crypt works with sectors as atomic units of encryption,
so data legth in bio must be aligned to whole sectors.

For example, if you use CBC (Cipher Block Chaining mode), and only
partial encrypted sector is written, the rest is corrupted.

So this restriction is perfectly valid there.

The question is what operation sends such bio structures.
If it is some control operation, it should probably bypass it.

Anyway this seems like but in the driver that sends such bio.

Milan
