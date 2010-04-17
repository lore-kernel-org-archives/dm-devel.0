From: brem belguebli <brem.belguebli@gmail.com>
Subject: multipath blocking a single path making multipath -ll ,
 lvm commands go to D state
Date: Sat, 17 Apr 2010 22:26:55 +0200
Message-ID: <1271536015.5449.115.camel@localhost>
References: <E463DF2B2E584B4A82673F53D62C2EF48D088D7E@cosmail01.lsi.com>
	<1271503066.9079.21.camel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1271503066.9079.21.camel@localhost>
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
List-Id: dm-devel.ids

Hello,

I'm trying to troubleshoot a problem we had on RHEL 5.x (dm-mp 0.4.7.x).

When a path of a multipath'd device is in blocked state (echo blocked
> /sys/bus/sdX/device/state), multipath -ll, lvm (vgs, ...) go to D
state rendering the whole thing unresponsive (global wait ratio hitting
100%). 

Tried to figure out if newer versions of dm-mp are affected, and tried
the same test on a fedora 12 box (dm-mp 0.4.9-6) and got the same
results.

device timeout is set to 30, queue_depth is 16, multipath configuration
set to "no_path_retry fail".

Nothing in syslog or anything that could help

Thanks
