From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Multipath conf
Date: Tue, 14 Jun 2011 15:12:37 +0100
Message-ID: <4DF76C55.4070802@redhat.com>
References: <80B8E0EA896B3E489A5802234274BA9C77C968B828@sandy.IS972DH.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <80B8E0EA896B3E489A5802234274BA9C77C968B828@sandy.IS972DH.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe BOULLANGER <cbo@info-services.biz>
List-Id: dm-devel.ids

On 06/10/2011 03:46 PM, Christophe BOULLANGER wrote:
> Hi,
> i wanna know what is that difference of both stout of multipath -ll
> <Anti-T> multipath -ll
> <Anti-T> mpath2 (350010b900004b868) dm-3 IBM-ESXS,GNA073C3ESTT0Z
> <Anti-T> [size=68G][features=0][hwhandler=0]
> <Anti-T> \_ round-robin 0 [prio=1][active]
> <Anti-T> \_ 1:0:1:0 sdc 8:32 [active][ready]
> <Anti-T> \_ round-robin 0 [prio=1][enabled]
> <Anti-T> \_ 1:0:3:0 sde 8:64 [active][ready]
> <Anti-T> c quoi la diff entre ca
> <Anti-T> et ca
> <Anti-T> orasm (36005076b0755627f4dee6fd70000002d) dm-6 IBM,1820N00
> <Anti-T> size=250G features='1 queue_if_no_path' hwhandler='0' wp=rw
> <Anti-T> `-+- policy='round-robin 0' prio=1 status=active
> <Anti-T> |- 0:0:3:0 sdb 8:16 active ready running
> <Anti-T> `- 0:0:2:0 sda 8:0 active ready running
> One have 2 tree and one both disk is on the same branch
> One is more secure ?
> Thank you for your help.
> Have a nice day.

The first one has two path groups each with one path and is configured for
failover (no load balancing of I/O). The second has one path group with both
paths in it and I/O will be balanced (round-robin) between them. This is covered
in the man page and other documentation - see the "failover" and "multibus" path
grouping policies.

Regards,
Bryn.
