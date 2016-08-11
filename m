From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 14/15] multipath-tools: replace queue-length
 by default selector
Date: Thu, 11 Aug 2016 18:16:17 +0200
Message-ID: <8aca22a1-73c5-a5e9-e2bd-3180e2eec564@gmail.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
	<1470846038-6590-14-git-send-email-xose.vazquez@gmail.com>
	<411eb480-d21d-051b-1f7b-12631cae1f25@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <411eb480-d21d-051b-1f7b-12631cae1f25@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Vincent Chen <vincent.y.chen@emc.com>, Brian Bunker <brian@purestorage.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/11/2016 07:58 AM, Hannes Reinecke wrote:

> On 08/10/2016 06:20 PM, Xose Vazquez Perez wrote:

>> service-time is more advanced, and it works better in asymmetric and
>> symmetric(corrected) environments.

>> -		.selector      = "queue-length 0",

> I would _not_ do this, unless tested on the real hardware.
> Just claiming 'the other one is more advanced' is not enough here.

service-time works better in any wild environment, different adapters or
different links speeds and any kind of load, aka the Production Environment.
I guess that manufacturers' tests are done in ideal conditions(PV=nRT).

Anyhow, the default path selector algorithm does not depend, by no means, of
any array settings or hardware. It's only related to the Linux host and
its environment.

How PURE/FlashArray and XtremIO/XtremApp were tested? Is there anything
wrong with service-time?
