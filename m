From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Tue, 20 Jan 2009 17:12:34 -0500
Message-ID: <49764C52.9010205@redhat.com>
References: <20081230001055.GA13710@us.ibm.com> <49750524.3030007@redhat.com>
	<20090120015427.GA16550@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090120015427.GA16550@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

malahal@us.ibm.com wrote:
> Takahiro Yasui [tyasui@redhat.com] wrote:
> ...
>> When one of log disk is broken and is not recognized, there is a case
>> disk that replication is executed. Let me explain with the following
>> simple case, which is the mirror volume, vg00-lv00 is composed of two
>> data disks and one mirrored log which is composed of two log disks.
>>
>> * Analysis of this problem
>>
>> A mirrored log is a type of "core" log and log devices need to be
>> synchronized when a mirrored log is activated. But when the first log
>> device is not recognized, "READ" I/O returns -EIO in disk_resume()
>> because log disk is not in-sync status and a default log can not be
>> switched to the other log disk working well.
>>
>>
>> Avoiding disk replication even if a log device got trouble is one of
>> the requirements. Is there any solution to avoid this problem by the
>> mirrored log approach?
> 
> Two ways to fix:
> 1) Never make "error leg" as your master leg as that is pointless.

This approach will solve the case that a log leg is not recognized, but
I'm afraid that it won't solve other type of I/O errors, such as medium
error.

LVM commands such as vgchange accesses only sectors containing label and
metadata, and LVM commands will successfully activate mirrored log as a
userland process. However, in kernel, I/Os errors might be detected in
a log area, and "READ" I/O returns -EIO. In this case, log will be detected
as a failed device.

> 2) Maybe we can use 'nosync' option when one of the two legs is known to
>    be an error device. This is probably easier than method (1)

This approach looks good.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.
