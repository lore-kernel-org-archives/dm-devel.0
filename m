From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Cannot mount underlying block device after creating
 dm device.
Date: Thu, 03 Nov 2011 15:05:19 -0400
Message-ID: <4EB2E5EF.6010207@cfl.rr.com>
References: <CABMcfaMi_FpOhG2g2vjxCOA8e89Bd+8UGSq0mCb0e+mfeocLeQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABMcfaMi_FpOhG2g2vjxCOA8e89Bd+8UGSq0mCb0e+mfeocLeQ@mail.gmail.com>
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
Cc: Sanjana <sanjana.linux@gmail.com>
List-Id: dm-devel.ids

On 11/2/2011 11:18 PM, Sanjana wrote:
> [root@bladelinux01 ~]# mount /dev/loop0 /mnt/
> mount: /dev/loop0 already mounted or /mnt/ busy
> [root@bladelinux01 ~]# mount /dev/loop1 /mnt/
> mount: /dev/loop1 already mounted or /mnt/ busy
>
> But if I remove the dm device created and try to mount the underlying
> block-device, I can mount both the device which took part in mirroring and
> I can access the data in both the disk.
> [root@bladelinux01 ~]# dmsetup remove raid1
> [root@bladelinux01 ~]# mount /dev/loop0 /mnt/
> [root@bladelinux01 ~]# ls -l /mnt/
> total 51
> drwx------. 2 root root 12288 Nov  2 22:32 lost+found
> -rw-------. 1 root root 37417 Nov  2 22:38 messages
>
> [root@bladelinux01 ~]# umount /mnt/
> [root@bladelinux01 ~]# mount /dev/loop1 /mnt/
> [root@bladelinux01 ~]# ls -l /mnt/
> total 51
> drwx------. 2 root root 12288 Nov  2 22:32 lost+found
> -rw-------. 1 root root 37417 Nov  2 22:38 messages
>
> Why is this behavior. any explanation, please....

Simple; the loop devices are still open by device-mapper, so mount is 
telling you they are busy.  Just because the raid device has zero opens 
does not mean that it closes the underlying devices.
