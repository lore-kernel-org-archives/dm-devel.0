From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 00/11] dm-raid: add RAID level takeover
 cababilities
Date: Sat, 21 May 2016 11:48:35 -0700
Message-ID: <971f4b8e-8a5b-305a-fe9a-b9b4d6f491ee@redhat.com>
References: <1463676574-12596-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1463676574-12596-1-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/19/2016 09:49 AM, heinzm@redhat.com wrote:
> This series of patches for the device-mapper dm-raid target
> (which utilizes the md kernel raid runtime) provides superblock
> enhancements and additional infrastructure for full
> takover/reshape and raid set shrink support.
>
> It includes full raid level takeover functionality,
> reshape and shrink will follow later based on the hereby
> provided infrastructure.

<snip>

> It can be used immediately using the 'dmsetup' test tool.

Looks great! You'll also be updating 
Documentation/device-mapper/dm-raid.txt in this or a future patchset?

Thanks -- Andy
