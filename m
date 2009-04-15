From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: DM-RAID1 data corruption
Date: Wed, 15 Apr 2009 16:38:50 -0400
Message-ID: <49E645DA.4010204@redhat.com>
References: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>
	<20090415031210.GA11881@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090415031210.GA11881@us.ibm.com>
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
> Look at this patch
> http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/4973
>
> It essentially generates an uevet and waits for the user level code to
> act on it and send a message to unblock it.

This patch was posted more then a year ago, and I could not find
any discussion on this issue/patch in the mailing list archive.
What was the conclusion of the discussion about this patch?
Are there any discussions outside this mailing list?

I think data corruption is really a serious problem even if it
has very small chance to happen. If it is a known problem, we
need to fix it. Don't you agree?

I roughly looked your patch, and I understand it is one of the
approach to fix this issue. I have just one concern about delay.
When 'unblock' message is delayed for some reason (by dmeventd?),
all write I/Os from applications need to be waited, and many I/Os
might come in a write queue and be blocked during 'block' status.

Thanks,
Taka
