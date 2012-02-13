From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 0/2] block: online resize of disk partitions
Date: Mon, 13 Feb 2012 17:18:33 -0500
Message-ID: <4F398C39.6010901@ubuntu.com>
References: <1329161438-12602-1-git-send-email-vgoyal@redhat.com> <4F3981FE.7090601@ubuntu.com> <20120213215039.GD3130@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120213215039.GD3130@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, Karel Zak <kzak@redhat.com>, maxim.patlasov@gmail.com
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/13/2012 4:50 PM, Vivek Goyal wrote:
> So if a user anyway does not specify the start of sector, then 
> tools shall have to first read it and then call the ioctl. If 
> anyway tools are specifying, there is no much scope of screwing up 
> the things?

Tools certainly should know where the partition starts.  I already
have patched parted and partx to pass the current size, which they
had trivially available.  Making sure of that is a good sanity check
to guard against, for instance, resizing the wrong partition.

> Even if we allow changing start at some point of time, then IOCTL 
> can remain the same and just the implementation will change in a 
> backward compatible manner. Old tools still will continue to work 
> as they have always been, and new ones can start passing "start" 
> too.
> 
> So I really did not find passing and checking "start" of partition
>  very appealing.

That is exactly why passing and checking start is required.  If it is
entirely ignored, then the interface can not start using it in the
future in a backward compatible way, because user mode tools will have
grown used to passing in any kind of garbage, so if the kernel starts
using it to alter the start position of the partition, older tools
would randomly and accidentally be shifting the the start of
partitions they just mean to change the length of.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPOYw5AAoJEJrBOlT6nu75CV4H/2vyZwujRqb+mqTAfQ+/XJE7
E850b+MOFZEQEoKQy+XAeu15pmm/TIa8NTk83kBeoQb30P2sU814+rJjbMKpZ9x/
xc8DZVC+DdnLLJ8a9aQw5feV0nmy102QrL0CWS+Wi6vS3DLlLCQQ+nv7AZ1jPV0Z
NPzqtmI/zBopf/F2IrL+5DLD9TAi7mf+Yv5IBb7w2JQSiU9LoBo9TTMJhPAhaqtC
ihqSJ0Q/t0DG3WacK+8fwh6Jyta1Bx+YsoUzYijtsaH6GQ1zbe+3c44T1JMI+Zvq
30M8V7y1BsLhp+lfZSUlC5YvPpu7gCJ1lg2fpMz56q2DENURj3L1HkdFwPwfLcw=
=TTAk
-----END PGP SIGNATURE-----
