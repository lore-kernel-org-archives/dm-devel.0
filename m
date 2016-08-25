From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: v4.8 dm-mpath
Date: Thu, 25 Aug 2016 14:06:10 -0700
Message-ID: <b8dd5787-e21c-8e64-a7fc-b609c11c13cf@sandisk.com>
References: <afa6895b-7301-2856-a68e-eaf81bde311b@sandisk.com>
	<20160816191241.GA16948@redhat.com> <20160817024302.GA29089@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160817024302.GA29089@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/16/2016 07:43 PM, Mike Snitzer wrote:
> On Tue, Aug 16 2016 at  3:12pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> On Tue, Aug 16 2016 at  1:32pm -0400,
>> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>>
>>> Can you have a look at this?
>>
>> I'll get linux-dm.git's 'dm-4.8' branch (v4.8-rc2) loaded on one of my
>> testbed systems to run the mptest testsuite.  It should provide coverage
>> for simple failover and failback.
>
> I successfully ran mptest against that v4.8-rc2 based kernel.  Any
> chance you could try mptest to see if it also passes for you?  Or if it
> is able to trigger the issue for you.
>
> mptest's runtest script defaults to setting up scsi-mq and dm-mq.

Hello Mike,

mptest on top of scsi_debug passes on v4.8-rc3 on the same system I used 
to run my SRP tests:

# ./runtest
[ ... ]
PASSED:  test_00_no_failure test_01_sdev_offline test_02_sdev_delete 
test_03_dm_failpath test_04_dm_switchpg
FAILED:

My SRP tests pass on the same setup if I disable scsi-mq. However, I 
still sporadically see I/O errors if I run srp-test 02 on kernel 
v4.8-rc3 with scsi-mq and dm-mq:
# srp-test/run_tests -t 02
[ ... ]
verify: bad magic header 0, wanted acca at file 
/root/mnt1/data-integrity-test.1.0 offset 581632, length 4096
fio: io_u error on file /root/mnt1/data-integrity-test.8.0: Input/output 
error: write offset=8888320, buflen=4096

Bart.
