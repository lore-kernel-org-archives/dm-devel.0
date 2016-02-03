From: jiangyiwen <jiangyiwen@huawei.com>
Subject: Re: Why don't return -EOPNOTSUPP?
Date: Wed, 3 Feb 2016 12:03:04 +0800
Message-ID: <56B17BF8.2030404@huawei.com>
References: <56B099B1.2060304@huawei.com>
	<alpine.LFD.2.00.1602021443260.17054@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1602021443260.17054@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>, martin.petersen@oracle.com
Cc: dm-devel@redhat.com, "Qijiang (Joseph, Euler)" <joseph.qi@huawei.com>, xuejiufei@huawei.com
List-Id: dm-devel.ids

On 2016/2/2 21:58, Luk=E1=9A Czerner wrote:
> On Tue, 2 Feb 2016, jiangyiwen wrote:
> =

>> Date: Tue, 2 Feb 2016 19:57:37 +0800
>> From: jiangyiwen <jiangyiwen@huawei.com>
>> To: lczerner@redhat.com
>> Cc: dm-devel@redhat.com, "Qijiang (Joseph, Euler)" <joseph.qi@huawei.com=
>,
>>     xuejiufei@huawei.com
>> Subject: [dm-devel] Why don't return -EOPNOTSUPP?
>>
>> Hi Lukas,
>> I have a question about commit 8af1954d172a("blkdev: Do not return
>> -EOPNOTSUPP if discard is supported"). That is we issue a
>> WRITE SAME request to device and return failed with EOPNOTSUPP,
>> but blkdev_issue_write_same ignore this error and return
>> success to caller. In this way, this will cause an inconsistent state
>> between upper layer and bottom layer.
>>
>> I don't know why don't return EOPNOTSUPP if part of devices support
>> discard, because I think that blkdev_issue_discard should return
>> EOPNOTSUPP to caller even if some of devices support discard.
>>
>> Thanks,
>> Yiwen Jiang.
> =

> Hi,
> =

> I think that the reasoning is very well explained in the commit
> description. Simply put, if the device does not support the discard
> at all then there is:
> =

> if (!blk_queue_discard(q))
> 	return -EOPNOTSUPP;
> =

> however if the device itself (possibly because it's dm device)
> advertise that it indeed does support discard and only parts of it
> does not (again possibly because it's a dm device) then there is no
> reason to return EOPNOTSUPP because that would only confuse the
> upper layers.
> =

> Now the question is, why is this a problem ? It's very much a
> advisory interface so if we send a discard request and it's not
> supported on the part of the device, what harm will be done by
> returning success ?
> =

> On the other hand if we did return EOPNOTSUPP, upper layer may stop
> issuing discard whatsoever which will be harmful for the parts of
> the device where discard is actually supported. Moreover it might
> also be a problem of alignment or granularity, not just that it's
> not supported.
> =

> However it's possible that situation changed since this commit and
> the lower layers, mainly probably dm, is doing the right thing, or
> is configurable in some way...I do not know.
> =

> -Lukas
> =

> .
> =

Hi Lukas,
Sorry, it is my fault, I previously misunderstand the actual meaning
of discard, because once applications issue a discard request to device,
they can't expect deterministic behavior. However, WRITE SAME should
not use this function bio_batch_end_io() which will ignore error with
EOPNOTSUPP, because if applications issue WRITE SAME requests to device,
it will return deterministic results to applications, or else it will
cause an inconsistent state between upper layer and bottom layer.

The detailed explanation is as follows:

Document 14-163r1 includes text intended to make it
clear that applications can't expect deterministic behavior from UNMAP.  Use
WRITE SAME if the LBAs need to return all zeros after the command completes.
WRITE SAME will probably be slower than UNMAP but will return deterministic
results.

So I will send a patch which solve this problem about WRITE SAME later.

Thanks,
Yiwen Jiang.
