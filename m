From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 0/3] sysfs representation of stacked devices
	(dm/md)
Date: Fri, 17 Feb 2006 20:21:32 -0500
Message-ID: <43F6769C.5010505@ce.jp.nec.com>
References: <43F60F31.1030507@ce.jp.nec.com>
	<20060217194249.GO12169@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060217194249.GO12169@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

Alasdair G Kergon wrote:
> I can't speak for the 'mount' code base, but I don't think it'll
> make any significant difference to LVM2 - we'd still have to do 
> all the same device scanning as we do now because we have to be
> aware of md devices defined in on-disk metadata regardless of 
> whether or not the kernel knows about them at the time the 
> command is run.

Actually, as you say, LVM2 already does the relationship analysis
correctly by itself. So it's not 'good' example...
The point was that dm and md have similar dependency
structure but currently we have to scan all devices to
find out the upward relationship using different method
for dm and md.

>>thus we only need to check "holders" directory of the device
>>to decide whether the device is used by dm/md.
>>Also we can walk down the "slaves" directories to collect
>>the devices conposing the given dm/md device.
> 
> For device-mapper devices, 'dmsetup deps' and ls --tree already
> gives you this information reasonably efficiently.

Speaking about the efficiency, 'dmsetup ls --tree' works well.
However, I haven't yet found a efficient way to implement
'dmsetup info --tree -o inverted dm-0', for example.

Deps ioctl provides downward information for a given dm device
but there is no method for upward information.

Providing reverse-deps ioctl in dm may be alternative solution.
But it still doesn't provide the holders of non-dm devices.
So I feel sysfs solution is appealing.

> Would others find the proposal useful for non-dm devices?

I would appreciate comments from others as well.

> And rather than adding code just to dm and md, would it be better 
> to implement it by enhancing bd_claim()?

It may be possible if I can extend the bd_claim to accept
additional parameter because all dm devices use same 'holder'
signature for bd_claim but actual owner of the claim should
be determined to create symlinks.

-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.
