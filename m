From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [Patch] kpartx to accept device map name
Date: Mon, 16 May 2005 19:50:11 -0400
Message-ID: <428931B3.7010804@ce.jp.nec.com>
References: <4288F2B6.9070808@ce.jp.nec.com> <1116283839.9352.48.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1116283839.9352.48.camel@zezette>
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

Hi,

Excuse me for the misleading message.

The problem I saw was that when executing kpartx just after
multipath (in shell script), kpartx was invoked too early
and couldn't see the device node. I could avoid it by
inserting "sleep 5" after multipath execution but I can't
tell whether it's enough.
Kiyoshi's patch should fix it and the device node will be
created on the location which libdevmapper knows. (/dev/mapper)

'-m' option provides a way to avoid dependency to hidden knowledge
about the location (/dev or /dev/mapper or anywhere else).
Without this, we have to synchronize udev rules, hotplug shell
scripts and initscripts to see the same device node for dm devices.
This is why I thought it's better to give kpartx an option like this.

..However, in the really latest CVS, dmsetup has a new function
to execute external command with device node name.
So we can do the same thing with dmsetup now.
Given that you are reluctant to add kpartx more relationship with
libdevmapper, dmsetup is the best place.

Thanks,
Jun'ichi Nomura

christophe varoqui wrote:
> Can you elaborate on the problems you see with the asynchronous hotplug
> model ?
> 
> I would like to express my reluctance to add a devmap special case to
> kpartx.
> 
> On lun, 2005-05-16 at 15:21 -0400, Jun'ichi Nomura wrote:
>>Attached patch adds '-m' option which makes kpartx
>>to accept device map name.
