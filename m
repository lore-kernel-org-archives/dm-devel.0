From: Yathindra <ydev@cs.utah.edu>
Subject: Re: Mapping sectors to have errors
Date: Fri, 28 Oct 2011 11:54:50 -0600
Message-ID: <4EAAEC6A.4070209@cs.utah.edu>
References: <4EAA13E4.6020709@cs.utah.edu> <20111028091140.GD4105@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111028091140.GD4105@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Joe,

I tried it the other way but when I specify error it doesn't seem to take
the start sector > 0.

# echo "0 `blockdev --getsz /dev/sdb` linear /dev/sdb 0" | dmsetup 
create bad_disk

# dmsetup table
bad_disk: 0 488281250 linear 8:16 0

# echo "100000 488181250 error" | dmsetup load bad_disk << This failed
device-mapper: reload ioctl failed: Invalid argument
Command failed

# echo "0 100000 error" |  dmsetup load bad_disk << This worked

Any ideas?

Thanks,
Yathi


On 10/28/2011 3:11 AM, Joe Thornber wrote:
> On Thu, Oct 27, 2011 at 08:31:00PM -0600, Yathindra wrote:
>> Hi,
>>
>> I'm trying to create a disk and map some sectors to have errors on them.
>>
>> I tried this,
>> echo "0 100000 linear /dev/sdb 0 100000 480081250 error"| dmsetup
>> create bad_disk
>> device-mapper: reload ioctl failed: Invalid argument
>> Command failed
>>
>> I have put in the right arguments but not sure why it fails.
> You have 2 target lines concatenated onto the same line there.
