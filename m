From: Yathindra <ydev@cs.utah.edu>
Subject: Re: Mapping sectors to have errors
Date: Fri, 28 Oct 2011 13:46:16 -0600
Message-ID: <4EAB0688.1040404@cs.utah.edu>
References: <4EAA13E4.6020709@cs.utah.edu> <4EAB059E.3050900@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EAB059E.3050900@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Milan,

It worked! Thanks so much ! :)

Have a great weekend.

On 10/28/2011 1:42 PM, Milan Broz wrote:
> On 10/28/2011 04:31 AM, Yathindra wrote:
>> I'm trying to create a disk and map some sectors to have errors on them.
>>
>> I tried this,
>> echo "0 100000 linear /dev/sdb 0 100000 480081250 error"| dmsetup create bad_disk
>> device-mapper: reload ioctl failed: Invalid argument
>> Command failed
> Try
> echo -e "0 100000 linear /dev/sdb 0\n100000 480081250 error"| dmsetup create bad_disk
>
> Milan
