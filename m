From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipath prio_callout broke from 5.2 to 5.3
Date: Mon, 13 Apr 2009 15:55:11 -0500
Message-ID: <20090413205511.GI15911@ether.msp.redhat.com>
References: <1779195765.1578721239520436084.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<1239613205.6376.16.camel@jaspav.missionsit.net.missionsit.net>
	<20090413185745.GF15911@ether.msp.redhat.com>
	<1239652565.30476.41.camel@jaspav.missionsit.net.missionsit.net>
	<20090413203711.GH15911@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090413203711.GH15911@ether.msp.redhat.com>
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

Just to clear one more thing up. There is nothing special about the
"dummy" strings in the dummy section.  You could use 
"this is gross hack" and it would work just as well.  The only thing is
to choose a string that you can be reasonably sure that storage hardware
makers won't use for their vendor and product names on their devices.

-Ben

> devices {
>         device {
>                 vendor          "WINSYS"
>                 product         "SF2372"
>                 path_grouping_policy    group_by_prio
>                 prio_callout            "/bin/bash /sbin/mpath_prio_one"
>         }
>         device {
>                 vendor          "dummy"
>                 product         "dummy"
>                 prio_callout    "/sbin/mpath_prio_one"
>         }
> }
