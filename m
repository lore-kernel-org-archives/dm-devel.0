From: Dave Wysochanski <dave.wysochanski@redhat.com>
Subject: Re: Failover between two paths to one LU doesn't work
	onlinux-iscsi
Date: Wed, 11 Oct 2006 10:16:45 -0400
Message-ID: <1160576205.4819.13.camel@linux-cxyg.rtp.netapp.com>
References: <452BD5C6.2080808@voltaire.com> <452BD768.30206@ilm.com>
	<452BFAA0.1000100@voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <452BFAA0.1000100@voltaire.com>
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

> I ran iozone benchmark and manually failed one of two paths. There was 
> no failover to second path.
> The iSCSI initiator retried to reconnect to the first path - 
> unsuccessfully. When I restored the first
> path - the initiator reconnected to the target via the first path.
> 
> Thanks!
> 
> ------------- INFO -------------
> Versions:
> device-mapper-1.01.01-1.6
> multipath-tools-0.4.5-0.11
> 
> Machine:
> 2.6.5-7.244-smp; x86_64; SLES9 sp3
> 

Did you set ConnFailTimeout to a non-zero value?  This sounds like it's
still at default (reconnect indefinately).  You also need to set the
Multipath variable, but it sounds like you may have done that already.
