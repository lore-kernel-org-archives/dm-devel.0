From: "Yury Konovalov" <ykonovalov@gmail.com>
Subject: Re: DS4000 with multipath-tools 0.4.5
Date: Thu, 18 Jan 2007 12:28:31 +0300
Message-ID: <744db6db0701180128t19679057g3f5bb0658729c8f6@mail.gmail.com>
References: <OF396F7E56.FA311C77-ON85257261.00787002-85257261.00789A54@mohegansun.com>
	<45AF1C42.8050304@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45AF1C42.8050304@suse.de>
Content-Disposition: inline
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

2007/1/18, Hannes Reinecke <hare@suse.de>:
> Unfortunately the current multipath-tools do not handle RDAC mode.
> You'll need a specific hardware handler to do this properly.
> Mike Christie once did some work on it, but I'm not sure if it made it
> into RHEL. We will be adding support for it for SLES10 SP1, so you might
> get lucky with that.

Thank you for such a good news!.
Do you have any plans to include it in SLES9 SP# as well?

I think, my problem with SLES9 and DS4300 could be related with
absence of proper hw-handler. I mean AVT could be initialized by
almost any process (not only by multipathd)
Can you comment on it?
https://www.redhat.com/archives/dm-devel/2007-January/msg00065.html

 --
Best Regards.
