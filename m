From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 0/3] Add deleting state check for target
	messages
Date: Mon, 16 Nov 2009 15:00:40 +0000
Message-ID: <20091116150040.GC11886@agk-dp.fab.redhat.com>
References: <20091113080422.17412.49305.stgit@localhost.localdomain>
	<4B00B597.6050905@ct.jp.nec.com>
	<20091116073848.GA20475@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091116073848.GA20475@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, Nov 15, 2009 at 11:38:48PM -0800, Mike Anderson wrote:
> Yes this patch set should not be needed post the fix to the message ioctl.
> The reduction was aimed at future callers using dm_get_md prior to
> DMF_FREEING being set as the dm_table_destroy holders wait would not
> proceed until current message operations had completed, but the reduction
> of this case is not that important with the other message ioctl changes in
> place.
 
I've left it in my tree for now (with the suggested simplifications - private
to dm.h), to enforce the situation that the dm core will not forward messages
to table targets after they begin to be deleted.

Alasdair
