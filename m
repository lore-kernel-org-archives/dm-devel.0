From: malahal@us.ibm.com
Subject: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Mon, 19 Jan 2009 17:54:27 -0800
Message-ID: <20090120015427.GA16550@us.ibm.com>
References: <20081230001055.GA13710@us.ibm.com> <49750524.3030007@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49750524.3030007@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Takahiro Yasui <tyasui@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Takahiro Yasui [tyasui@redhat.com] wrote:
> Hi,
> 
> I'm interested in the mirrored log approach which Malahal posted,
> and now I'm looking into it. However, I found one problem with it.
> 
> When one of log disk is broken and is not recognized, there is a case
> disk that replication is executed. Let me explain with the following
> simple case, which is the mirror volume, vg00-lv00 is composed of two
> data disks and one mirrored log which is composed of two log disks.
>
> * Analysis of this problem
> 
> A mirrored log is a type of "core" log and log devices need to be
> synchronized when a mirrored log is activated. But when the first log
> device is not recognized, "READ" I/O returns -EIO in disk_resume()
> because log disk is not in-sync status and a default log can not be
> switched to the other log disk working well.
> 
> 
> Avoiding disk replication even if a log device got trouble is one of
> the requirements. Is there any solution to avoid this problem by the
> mirrored log approach?

Two ways to fix:
1) Never make "error leg" as your master leg as that is pointless.
2) Maybe we can use 'nosync' option when one of the two legs is known to
   be an error device. This is probably easier than method (1)

Any other methods? Any help regarding which method to pursue would be
very much appreciated.

Thanks, Malahal.
PS: This patch was always used along with other patches and that could
explain why we didn't notice this problem.
