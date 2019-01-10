From: james harvey <jamespharvey20@gmail.com>
Subject: Re: dm thin pool discarding
Date: Wed, 9 Jan 2019 20:09:59 -0500
Message-ID: <CA+X5Wn5NCv-zhjigb8AU_Ab5oGJFZEHKs5FxaUB8U4ezpOgzWA@mail.gmail.com>
References: <CA+X5Wn4fqXZa_Ecc75CfmA2LBq7y8qFzzdDcdFugZwaPgq-Aeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+X5Wn4fqXZa_Ecc75CfmA2LBq7y8qFzzdDcdFugZwaPgq-Aeg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Wed, Jan 9, 2019 at 7:39 PM james harvey <jamespharvey20@gmail.com> wrote:
> Q2 - Is it correct that the blocks of size discard_granularity sent to
> dm/LVM need to be aligned from the start of the volume, rather than
> the start of the partition?  ...

This is probably what discard_alignment is for.

# lvcreate --size 1G --chunksize 128MB --thin lvm/thinpoolntfs /dev/nvme0n1p4
# lvcreate --virtualsize 256M --thin lvm/thinpoolntfs --name ntfs
# fdisk /dev/lvm/ntfs
GPT
New, Partition number 1, First sector 2048 (default was 32 sectors of
512 bytes?), +128M
# kpartx -a /dev/lvm/ntfs
# dmsetup ls | grep ntfs
lvm-ntfs (254:16)
lvm-ntfs1 (254:17)
$ cat /sys/dev/block/254:16/discard_alignment
0 # makes sense, this is the volume itself
$ cat /sys/dev/block/254:17/discard_alignment
133169152

That's equal to size of the volume (128 * 1024 * 1024) minus the start
of the partition (2048 * 512 byte sector size).

discard_alignment is described at
https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-block

as: "Devices that support discard functionality may internally
allocate space in units that are bigger than the exported logical
block size. The discard_alignment parameter indicates how many bytes
the beginning of the device is offset from the internal allocation
unit's natural alignment."

So, is that value supposed to be how many bytes are LEFT in the first
discard granularity block?  Meaning, the fs should treat this many
bytes as non-discardable?  Instead of this value giving how many bytes
INTO the first discard granularity block the partition starts?
