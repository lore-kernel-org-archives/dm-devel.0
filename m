From: "Levy, Jerome" <jerome.levy@emc.com>
Subject: Re: Powerpath vs dm-multipath - two points of FUD?
Date: Sun, 14 Sep 2014 18:44:02 +0000
Message-ID: <454E18A46D7B064CA63B41E99AD179508A754100@MX103CL02.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

> Firstly, apologies if this is a common topic and my intentions are not 
> to start a flame war. I've googled extensively but haven't found
> specific information to address my queries, so I thought I would turn here.

At the risk of getting involved in a religious discussion (disclaimer: I am an EMC employee and was an advanced support engineer for both PowerPath and dm-multipath) I thought I'd pass along a few thoughts that might help:

PowerPath costs money. dm-multipath is included with the OS distro.

PowerPath operations are largely consistent across platforms.If you know how PowerPath works on Linux, you have a very short learning curve on AIX, Solaris, HP-UX, and so forth. This statement is not necessarily 
true of native multipath solutions on any platform, and can be a significant factor in a multi-vendor environment.

PowerPath contains proprietary load sensing and balancing algorithms which may help performance in a given situation. (It does. I've seen them.) YMMV.

Request size and other switching options  can be useful in a number of specific situations -- some may call them corner cases, but streaming media, heavy database backups, large dataset transfers, and others have been shown to benefit from alternate PowerPath policies.

As Hannes points out, PowerPath is supported by EMC. If things don't work, you have someone to call. That can be comforting in the middle of the night :)

I've seen both PowerPath and native multipath solutions provide a lot of value in different ways,  and the decision as to which to use is not always clear-cut. Hope this helps!

-- jml
