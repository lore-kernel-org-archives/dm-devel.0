From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 2/2] multipath-tools: change default
 path_grouping_policy from failover to group_by_prio
Date: Mon, 1 Aug 2016 03:34:24 +0200
Message-ID: <dea237d7-f1be-5ed9-19ff-d8d42aae868a@gmail.com>
References: <1468271522-3052-1-git-send-email-xose.vazquez@gmail.com>
	<1468271522-3052-2-git-send-email-xose.vazquez@gmail.com>
	<76957be3-8db8-7863-7152-b67c18194c36@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <76957be3-8db8-7863-7152-b67c18194c36@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/28/2016 04:06 PM, Hannes Reinecke wrote:

> On 07/11/2016 11:12 PM, Xose Vazquez Perez wrote:
>> Default value is: failover
>>       5                 .pgpolicy      = GROUP_BY_SERIAL,
>>      23                 .pgpolicy      = MULTIBUS,
>>      48                 .pgpolicy      = GROUP_BY_PRIO,
>>
>> failover is only used by 1 device:
>> IBM/3303 NVDISK
>>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  libmultipath/defaults.h    |  2 +-
>>  libmultipath/hwtable.c     | 49 +---------------------------------------------
>>  multipath/multipath.conf.5 |  2 +-
>>  3 files changed, 3 insertions(+), 50 deletions(-)
>>

> Please reconsider.

It was done to minimize the number of options in hwtable.c
Also the output of the multipathd configuration is clearer, and it makes
easier to find misconfigured devices and attributes with weird values.

> 'group_by_prio' requires a working prioritizer, which we cannot assume
> for an unknown device.

I don't think that anyone can expect that a minimal config could work
automagically for the first time, with something like this:

devices {
	device {
		vendor  = "AUTOMATIC"
		product = "FORTHEPEOPLE"
	}
}


I do prefer a minimal set of options than a false automagical config.
