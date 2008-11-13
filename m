From: Milan Broz <mbroz@redhat.com>
Subject: Re: Error target causes entire device to error
Date: Thu, 13 Nov 2008 19:38:50 +0100
Message-ID: <491C743A.9060609@redhat.com>
References: <4918B2BC.8020606@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4918B2BC.8020606@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


Phillip Susi wrote:
> $ sudo dmsetup create foo
> 0 1 zero
> 1 1 error
> $ sudo dd if=/dev/mapper/foo bs=512 count=1
> dd: reading `/dev/mapper/foo': Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.000715356 seconds, 0.0 kB/s
> 
> Why can't you read the first sector mapped to the zero target without 
> getting an error?  It doesn't seem to matter where the error target is 
> in the table, or how big the virtual device is; any attempt to read 
> anywhere returns an error if there are any sectors mapped to the error 
> target.

try

dd iflag=direct if=/dev/mapper/foo bs=512 count=1
and
dd iflag=direct if=/dev/mapper/foo bs=512 count=1 skip=1

it seems that someone optimize the request, direct io does what you want.
in fact, dm receives bio requesting 1024 bytes, not 512.
(optimizing it to page size, but here it is limited by device size).

assuming that your arch has 4kb pages, try to setup device with
0 8 zero
8 8 error

and try again...

Milan
--
mbroz@redhat.com
