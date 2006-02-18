From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 0/3] sysfs representation of stacked devices (dm/md)
Date: Sat, 18 Feb 2006 01:06:01 -0500
Message-ID: <DEEF4650-99AF-4905-A291-453C2664A1B5@mac.com>
References: <43F60F31.1030507@ce.jp.nec.com> <20060217194249.GO12169@agk.surrey.redhat.com>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750856AbWBRGGT@vger.kernel.org>
In-Reply-To: <20060217194249.GO12169@agk.surrey.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Neil Brown <neilb@suse.de>, Lars Marowsky-Bree <lmb@suse.de>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Feb 17, 2006, at 14:42, Alasdair G Kergon wrote:
> On Fri, Feb 17, 2006 at 01:00:17PM -0500, Jun'ichi Nomura wrote:
>> Though md0, dm-0, dm-1 and sd[a-d] contain same LVM2 meta data,  
>> LVM2 should pick up md0 as PV, not dm-0, dm-1 and sdXs. mdadm  
>> should build md0 from dm-0 and dm-1, not from sdXs. Similar things  
>> will happen on 'mount' and 'fsck' if we use file system labels  
>> instead of LVM2.
>
> I can't speak for the 'mount' code base, but I don't think it'll  
> make any significant difference to LVM2 - we'd still have to do all  
> the same device scanning as we do now because we have to be aware  
> of md devices defined in on-disk metadata regardless of whether or  
> not the kernel knows about them at the time the command is run.

Aha!  This is a very valid reason why we should export partition  
types from the kernel to userspace:  Partitions/devices that appear  
to have 2 different filesystems/formats.  The _kernel_ cannot  
reliably tell which to use.  On the other hand, a properly configured  
_userspace_ initramfs could use configured partition-type  
information, a small config file, and a user-configurable detection  
algorithm to figure out that the device is _actually_ the first  
segment of an ext3-on-LVM-on-RAID1, instead of a raw ext3, and mount  
it appropriately.  Now, this requires that the admin correctly  
specify the partition types, but that seems a bit more reliable than  
depending on the probe-order to get things right.

Cheers,
Kyle Moffett

--
Unix was not designed to stop people from doing stupid things,  
because that would also stop them from doing clever things.
   -- Doug Gwyn
