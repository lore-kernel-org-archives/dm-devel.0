From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH] multipath: add udev sync support.
Date: Tue, 18 May 2010 15:38:19 +0200
Message-ID: <4BF2984B.7040606@redhat.com>
References: <20100517190338.GO3295@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100517190338.GO3295@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/17/2010 09:03 PM, Benjamin Marzinski wrote:
> device-mapper in now able to synchronize operations through udev.  This patch
> allows multipath and kpartx to make use of this feature. If kpartx is run with
> "-s", it waits for the partitions to be created before returning. Multipath
> will now always wait for the devices to be created before returning.
> 

Looks fine. I haven't found any misuse of the interface or errors...
Ack.

Peter
