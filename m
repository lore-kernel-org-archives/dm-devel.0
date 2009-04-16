From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: DM-RAID1 data corruption
Date: Thu, 16 Apr 2009 18:24:41 -0400
Message-ID: <49E7B029.20906@redhat.com>
References: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>	<20090415031210.GA11881@us.ibm.com>
	<49E645DA.4010204@redhat.com> <20090416024959.GB19876@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090416024959.GB19876@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

malahal@us.ibm.com wrote:
> Takahiro Yasui [tyasui@redhat.com] wrote:
>> malahal@us.ibm.com wrote:
>>> Look at this patch
>>> http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/4973
>>>
>>> It essentially generates an uevet and waits for the user level code to
>>> act on it and send a message to unblock it.
>> This patch was posted more then a year ago, and I could not find
>> any discussion on this issue/patch in the mailing list archive.
>> What was the conclusion of the discussion about this patch?
>> Are there any discussions outside this mailing list?
> 
> The patch alone can't fix the issue. It needed LVM changes. We had some
> discussions on how to implement the LVM related changes. Finally I was
> told look at remote-replication target code to see how that handles
> selecting the right "MASTER" device. That code is not published yet.

Who is working on this?

> That is how the "log device" failure is handled today. Alasdair also
> thought we needed to change LVM to handle events as soon as possible
> using a single thread and not block behind an LVM scan, etc.

I agree. I also described this point in the background section of
"Introduce metadata cache".
https://www.redhat.com/archives/lvm-devel/2009-April/msg00014.html

> Another method is to have dm-mirror target metadata on the disk itself.
> This metadata is internal to the kernel module and would NOT touch it.
> This would avoid any user level interaction and delays.

I'm interested in this approach that dm-mirror manages own data
to keep the status, such as the number of default mirror, valid
legs. When an error is detected, dm-mirror handles the error and
disable the error disk as soon as possible in kernel space, then
lvm metadata is managed in the user-space later.

Some transaction systems are sensitive to delay, and approaches
which don't cause much delay even if an error was detected are
desirable.

> Of course, we can do something in the log itself but it will not fix
> "corelog" mirrors, more over the system can't auto recover after a
> missing log alone.

Yes, storing information on the log device does not save "corelog"
mirrors, so we might need some area to keep information on mirror
legs.

Thanks,
Taka
