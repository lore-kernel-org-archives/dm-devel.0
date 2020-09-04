From: lixiaokeng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 00/14] multipath-tools series: some cleanups
 and fixes checked by codedex tool
Date: Fri, 4 Sep 2020 10:24:58 +0800
Message-ID: <6a6cd305-2c2e-b1af-967b-4b73b254fbda@huawei.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<73d14f51e1ca6aeb8dbd40f5a22c21508b6d4401.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <73d14f51e1ca6aeb8dbd40f5a22c21508b6d4401.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-GB
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

Hello Martin,
   Thanks for your reviews. I will remove the error messages and send
them again.

Regards
Lixiaokeng

On 2020/9/4 4:08, Martin Wilck wrote:
> Hello Lixiaokeng,
> 
> On Wed, 2020-09-02 at 14:40 +0800, lixiaokeng wrote:
>> Hi:
>>     Now, we check multipath-tools codes with codedex tool. Here
>> are some some cleanups and fixes.
> 
> Thank you. However I'm going to nack all patches that add error
> messages after unsuccesful memory allocations. Such messages are
> unhelpful most of the time, and increase the code size without a true
> benefit. I've actually considered to get rid of all these, and replace
> them by a log_oom() macro.
> 
> See an untested prototype attached, to better understand what I mean.
> 
> Regards
> Martin
> 
> 
