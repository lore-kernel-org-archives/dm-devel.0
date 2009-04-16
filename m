From: malahal@us.ibm.com
Subject: Re: DM-RAID1 data corruption
Date: Wed, 15 Apr 2009 19:49:59 -0700
Message-ID: <20090416024959.GB19876@us.ibm.com>
References: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>
	<20090415031210.GA11881@us.ibm.com> <49E645DA.4010204@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49E645DA.4010204@redhat.com>
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

Takahiro Yasui [tyasui@redhat.com] wrote:
> malahal@us.ibm.com wrote:
> > Look at this patch
> > http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/4973
> >
> > It essentially generates an uevet and waits for the user level code to
> > act on it and send a message to unblock it.
> 
> This patch was posted more then a year ago, and I could not find
> any discussion on this issue/patch in the mailing list archive.
> What was the conclusion of the discussion about this patch?
> Are there any discussions outside this mailing list?

The patch alone can't fix the issue. It needed LVM changes. We had some
discussions on how to implement the LVM related changes. Finally I was
told look at remote-replication target code to see how that handles
selecting the right "MASTER" device. That code is not published yet.

> I think data corruption is really a serious problem even if it
> has very small chance to happen. If it is a known problem, we
> need to fix it. Don't you agree?

Of course, yes!

> I roughly looked your patch, and I understand it is one of the
> approach to fix this issue. I have just one concern about delay.
> When 'unblock' message is delayed for some reason (by dmeventd?),
> all write I/Os from applications need to be waited, and many I/Os
> might come in a write queue and be blocked during 'block' status.

That is how the "log device" failure is handled today. Alasdair also
thought we needed to change LVM to handle events as soon as possible
using a single thread and not block behind an LVM scan, etc.

Another method is to have dm-mirror target metadata on the disk itself.
This metadata is internal to the kernel module and would NOT touch it.
This would avoid any user level interaction and delays.

Of course, we can do something in the log itself but it will not fix
"corelog" mirrors, more over the system can't auto recover after a
missing log alone.

Thanks, Malahal.
