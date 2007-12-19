From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Snapshots
Date: Wed, 19 Dec 2007 11:42:45 -0500
Message-ID: <47694A05.9090202@cfl.rr.com>
References: <47682630.5060803@cfl.rr.com> <47684BE3.5060408@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47684BE3.5060408@ce.jp.nec.com>
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
> LVM2 does it by putting a linear mapping on top of the origin device.

How does this work?  I'm trying to figure out the whole locking business
and it seems that mounting the device, or using it as a target in a dm
table place an exclusive lock on the device, so how can you add a linear
mapping to the origin device, if it is already used as a target in the
snapshot device, and thus locked?
