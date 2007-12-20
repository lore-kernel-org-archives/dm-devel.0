From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Snapshots
Date: Thu, 20 Dec 2007 14:45:54 -0500
Message-ID: <476AC672.4030405@cfl.rr.com>
References: <47682630.5060803@cfl.rr.com>
	<47684BE3.5060408@ce.jp.nec.com>	<47694A05.9090202@cfl.rr.com>
	<4769862D.6090403@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4769862D.6090403@ce.jp.nec.com>
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

Jun'ichi Nomura wrote:
> So, you have to put the linear mapping *before* that.
> Then, the top-level block device will be locked but you can
> still change the underlying mappings.

So using a disk device as a dm target locks it.  DM won't use a disk
device as a target if it is locked.  Are you saying that dm can use
another dm device as a target, even if it is already locked by being
used as another dm target?
